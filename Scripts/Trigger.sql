Use HospitalDB

-- Trigger 

-- 1. After insert on Appointments → auto log in MedicalRecords. 
-- Fires AFTER an INSERT operation on the Patient_Doctor_Appointments table.
-- Automatically creates a new entry in the MedicalRecords table to log the appointment.
-- This provides a basic audit trail or initial record for each appointment.
-- =======================================================

CREATE TRIGGER trg_Appointments_AutoLogMedicalRecords
ON MedicalManagement.Patient_Doctor_Appointments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- For each new appointment inserted, create a corresponding medical record entry.
    INSERT INTO MedicalManagement.MedicalRecords (
        Record_ID,
        P_ID,
        s_ID,
        Dep_ID,
        Diagnosis,
        Record_Notes,
        RecordDate,
        Treatment_Plans
    )
    SELECT
        -- Generate a new Record_ID (assuming it's not an IDENTITY column, if it is, remove this line)
        ISNULL((SELECT MAX(Record_ID) FROM MedicalManagement.MedicalRecords), 2000) + ROW_NUMBER() OVER (ORDER BY I.P_ID),
        I.P_ID,
        I.S_ID,
        I.Dep_ID,
        'Initial Appointment Log', -- Generic diagnosis for auto-log
        'Auto-generated log for new appointment on ' + CONVERT(NVARCHAR(20), I.AppointmentDate, 101) + ' at ' + CONVERT(NVARCHAR(20), I.AppointmentTime, 108) + '.',
        GETDATE(), -- Record date is now
        'Follow-up/Diagnosis Pending' -- Generic treatment plan
    FROM
        INSERTED AS I;

    PRINT 'Trigger [trg_Appointments_AutoLogMedicalRecords] executed: Medical record(s) logged for new appointment(s).';
END;

-- Test

-- Example 1: Inserting a new appointment for Patient ID 1, Doctor S_ID 1, Department ID 1
-- (Ensure P_ID=1 exists in Patients, and (S_ID=1, Dep_ID=1) exists in Doctors)
INSERT INTO PatientServices.Patients (P_FName, P_LName, DBO, P_Gender, Address) VALUES
('Ali', 'Al Balushi', '1985-03-15', 'Male', 'Muscat, Al Khuwair')

INSERT INTO MedicalManagement.Patient_Doctor_Appointments (P_ID, S_ID, Dep_ID, AppointmentDate, AppointmentTime, Status, AppointmentType)
VALUES (21, 7, 1, '2024-08-01', '09:00:00', 'Scheduled', 'General Checkup');
GO

Select * from PatientServices.Patients

Select * from MedicalManagement.MedicalRecords

-- =======================================================
-- Trigger 2: trg_Patients_PreventDeleteIfPendingBills
-- Fires INSTEAD OF a DELETE operation on the Patients table.
-- Prevents the deletion of a patient if there are any existing billing records
-- with a Total_Cost greater than 0, indicating an outstanding or unresolved financial obligation.
-- If no such pending bills exist, the actual deletion proceeds.
-- =======================================================
-- Fires INSTEAD OF a DELETE operation on the Patients table.
-- Prevents deletion if any patient in the batch has pending bills (Total_Cost > 0).
-- =======================================================
CREATE TRIGGER trg_Patients_PreventDeleteIfPendingBills
ON PatientServices.Patients
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if any patient being deleted has bills with a Total_Cost greater than 0
    IF EXISTS (
        SELECT 1
        FROM DELETED AS D
        JOIN PatientServices.Biling AS B ON D.P_ID = B.P_ID
        WHERE B.Total_Cost > 0
    )
    BEGIN
        -- If found, raise an error and stop the deletion
        RAISERROR('Cannot delete patient(s). One or more patients have pending billing records (Total_Cost > 0).', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- If no pending bills, proceed with the actual delete for all patients in the batch
        DELETE FROM PatientServices.Patients
        WHERE P_ID IN (SELECT P_ID FROM DELETED);
        PRINT 'Patient(s) deleted successfully (no pending bills found).';
    END
END;
GO

-- TEST 
DELETE FROM PatientServices.Patients
WHERE P_ID = 1;
-- =======================================================
-- Trigger 3: trg_Rooms_PreventConflictingAvailability
-- Fires AFTER an UPDATE operation on the Rooms table.
-- Ensures data consistency:
-- 1. Prevents a room from being marked as 'TRUE' (available) if it is currently
--    occupied by an active patient according to the Admissions table.
-- 2. Prevents a reduction in room capacity if it would cause the number of
--    currently admitted patients to exceed the new capacity.
-- =======================================================
CREATE TRIGGER trg_Rooms_PreventConflictingAvailability
ON HospitalResources.Rooms
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Scenario 1: Preventing marking an occupied room as available
    IF UPDATE(Available) AND EXISTS (
        SELECT 1
        FROM INSERTED AS I
        JOIN DELETED AS D ON I.RoomID = D.RoomID
        WHERE I.Available = 'TRUE' AND D.Available = 'FALSE' -- Status changed to available
          AND EXISTS ( -- Check for any active patient in this room
                SELECT 1
                FROM PatientServices.Admissions AS A
                WHERE A.Room_ID = I.RoomID
                  AND A.DateIN <= GETDATE() -- Admission started
                  AND (A.DateOut >= GETDATE() OR A.DateOut IS NULL) -- Not yet discharged
            )
    )
    BEGIN
        RAISERROR('Cannot mark room as available while it is currently occupied by an active patient.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Scenario 2: Preventing reducing capacity below active patients
    IF UPDATE(Capacity) AND EXISTS (
        SELECT 1
        FROM INSERTED AS I
        JOIN DELETED AS D ON I.RoomID = D.RoomID
        WHERE I.Capacity < D.Capacity -- Capacity was reduced
          AND ( -- Count active patients in the room
                SELECT COUNT(A.P_ID)
                FROM PatientServices.Admissions AS A
                WHERE A.Room_ID = I.RoomID
                  AND A.DateIN <= GETDATE()
                  AND (A.DateOut >= GETDATE() OR A.DateOut IS NULL)
              ) > I.Capacity -- Active patients exceed new capacity
    )
    BEGIN
        RAISERROR('Cannot reduce room capacity below the number of currently admitted patients.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- Print message for valid updates that pass trigger checks
    PRINT 'Trigger [trg_Rooms_PreventConflictingAvailability] executed: Room update consistency checked.';
END;
GO

-- TEST 

-- SELECT * FROM PatientServices.Admissions
-- SELECT * FROM HospitalResources.Rooms

-- Test 1: Reduce capacity to less than the number of patients present
UPDATE HospitalResources.Rooms
SET Capacity = 1
WHERE RoomID = 21;

INSERT INTO HospitalResources.Rooms (RoomType, Available, Capacity)
VALUES ('ICU', 'FALSE', 1);

INSERT INTO PatientServices.Admissions (AdmID, P_ID, Room_ID, DateIN, DateOut)
VALUES (1, 7, 22, GETDATE(), '2025-06-30'); 

-- Test 2: Trying to make the occupied room "available"
UPDATE HospitalResources.Rooms
SET Available = 'TRUE'
WHERE RoomID = 22;
