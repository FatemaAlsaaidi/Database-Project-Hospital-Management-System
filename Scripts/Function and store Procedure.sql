Use HospitalDB

/*ALTER DATABASE HospitalDB
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

DROP DATABASE HospitalDB;*/


-- 1. Scalar function to calculate patient age from DOB.
-- Description: Calculates the age of a patient based on their Date of Birth (DOB).
-- Parameters:
--   @DateOfBirth DATE: The patient's date of birth.
-- Returns: INT (The calculated age in years).
-- Example Usage: SELECT dbo.fn_CalculatePatientAge('1990-05-15');
CREATE FUNCTION dbo.fn_CalculatePatientAge (@DateOfBirth DATE)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;

    -- Calculate age by subtracting birth year from current year.
    -- Then, adjust if the birthday hasn't occurred yet this year.
    SET @Age = DATEDIFF(year, @DateOfBirth, GETDATE()); 

    IF MONTH(@DateOfBirth) > MONTH(GETDATE()) OR
       (MONTH(@DateOfBirth) = MONTH(GETDATE()) AND DAY(@DateOfBirth) > DAY(GETDATE()))
    BEGIN
        SET @Age = @Age - 1;
    END

    RETURN @Age;
END;

-- drop FUNCTION dbo.fn_CalculatePatientAge
-- IF WE HAVE STORED PROCEDURE WITH NO TABLE
Declare @Age Int;
exec dbo.fn_CalculatePatientAge '1998/08/09', @Age OUTPUT;
SELECT @Age;

-- IF WE HAVE FUNCTION WITH NO TABLE 
Declare @Age Int;
SET @Age = dbo.fn_CalculatePatientAge('1998/08/08'); -- Call the function and assign its return value
SELECT @Age;

--2. Stored procedure to admit a patient (insert to Admissions, update Room availability).
-- Description: Admits a patient to a room, updating room availability.
-- Parameters:
--   @P_ID INT: The Patient ID.
--   @Room_ID INT: The Room ID where the patient will be admitted.
--   @DateOut DATE: The expected or actual date of discharge.
--   @AdmissionID INT OUTPUT: Outputs the newly generated Admission ID.
-- Remarks:
--   - Assumes AdmID is UNIQUE but not IDENTITY in your table structure based on your original DDL.
--     If AdmID is IDENTITY, remove it from the INSERT and output SCOPE_IDENTITY().
--   - This procedure checks if the room is available before admitting.
--   - The AdmID is generated here using MAX(AdmID) + 1 for simplicity. In a real system,
--     consider using a sequence object for robust ID generation.
-- Example Usage:
--   DECLARE @newAdmID INT;
--   EXEC dbo.sp_AdmitPatient @P_ID = 1, @Room_ID = 1, @DateOut = '2025-07-05', @AdmissionID = @newAdmID OUTPUT;
--   SELECT @newAdmID AS NewAdmissionID;
-- =======================================================
CREATE PROCEDURE dbo.sp_AdmitPatient
(
    @P_ID INT,
    @Room_ID INT,
    @DateOut DATE,
    @AdmissionID INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables with appropriate data types
    DECLARE @RoomAvailabilityStatus VARCHAR(10); -- Renamed for clarity
    DECLARE @MaxAdmID INT;
    DECLARE @CurrentPatientsInRoom INT; -- Renamed for clarity
    DECLARE @RoomCapacity INT;          -- Renamed for clarity

    BEGIN TRY
        -- Check if the Room_ID exists and get its availability status and capacity
        SELECT
            @RoomAvailabilityStatus = R.Available,
            @RoomCapacity = R.Capacity
        FROM
            HospitalResources.Rooms AS R
        WHERE
            R.RoomID = @Room_ID;

        -- Handle case where Room_ID does not exist
        IF @RoomAvailabilityStatus IS NULL
        BEGIN
            SET @AdmissionID = -1; -- Indicate room not found
            PRINT 'Error: Room ID ' + CAST(@Room_ID AS NVARCHAR(10)) + ' does not exist.';
            RETURN; -- Exit the procedure
        END

        -- Count the current number of patients admitted to this room
        -- Only count active admissions (where DateOut is in the future or NULL)
        SELECT
            @CurrentPatientsInRoom = COUNT(AdmID)
        FROM
            PatientServices.Admissions
        WHERE
            Room_ID = @Room_ID
            AND (DateOut IS NULL OR DateOut > GETDATE()); -- Assuming DateOut marks the end of admission

        -- Determine if the room has space
        IF @CurrentPatientsInRoom < @RoomCapacity
        BEGIN
            -- Generate a new unique Admission ID
            SELECT @MaxAdmID = ISNULL(MAX(AdmID), 0) FROM PatientServices.Admissions; -- Start from 0 to ensure first ID is 1
            SET @AdmissionID = @MaxAdmID + 1;

            -- Insert into Admissions table
            INSERT INTO PatientServices.Admissions (AdmID, P_ID, Room_ID, DateIN, DateOut)
            VALUES (@AdmissionID, @P_ID, @Room_ID, GETDATE(), @DateOut);

            -- Update Room availability based on new patient count
            IF (@CurrentPatientsInRoom + 1) >= @RoomCapacity -- Check if the room becomes full AFTER this admission
            BEGIN
                UPDATE HospitalResources.Rooms
                SET Available = 'FALSE'
                WHERE RoomID = @Room_ID;
            END
            ELSE
            BEGIN
                -- Ensure it's marked TRUE if there's still capacity
                UPDATE HospitalResources.Rooms
                SET Available = 'TRUE'
                WHERE RoomID = @Room_ID;
            END

            PRINT 'Patient admitted successfully. Admission ID: ' + CAST(@AdmissionID AS NVARCHAR(10));
        END
        ELSE
        BEGIN
            SET @AdmissionID = -1; -- Indicate admission failure: Room is full or not available
            PRINT 'Error: Room ' + CAST(@Room_ID AS NVARCHAR(10)) + ' is currently full.';
        END
    END TRY
    BEGIN CATCH
        -- Handle errors
        PRINT 'An error occurred during patient admission: ' + ERROR_MESSAGE();
        SET @AdmissionID = -1; -- Indicate admission failure
    END CATCH
END;
GO

-- test 
-- First: Defining the variable that will hold the resulting ID value
DECLARE @NewAdmissionID INT;

-- Second: Call the stored procedure and pass the variable as output
EXEC dbo.sp_AdmitPatient
    @P_ID = 1,              --This patient must be pre-existing.
    @Room_ID = 19,         -- Room currently available (Available = 'TRUE')
    @DateOut = '2025-07-10',
    @AdmissionID = @NewAdmissionID OUTPUT;

--Third: Display the resulting ID value
SELECT @NewAdmissionID AS NewAdmissionID; -- -1 Unseccuseeful inseart in admiss

--===============================
-- =======================================================
-- 3. Stored Procedure: sp_GenerateInvoice
-- Description: Generates a billing invoice for a patient based on treatments and total cost.
-- Parameters:
--   @P_ID INT: The Patient ID for whom the invoice is being generated.
--   @Services NVARCHAR(MAX): A description of the services provided.
--   @Total_Cost DECIMAL(10, 2): The total cost of the services.
--   @PaymentMethod NVARCHAR(50): The method of payment (e.g., 'Cash', 'Credit Card').
--   @BillingID INT OUTPUT: Outputs the newly generated Billing ID.
-- Remarks:
--   - Assumes Biling_ID is NOT NULL but not IDENTITY in your table structure.
--     If Biling_ID is IDENTITY, remove it from the INSERT and output SCOPE_IDENTITY().
--   - Biling_ID is generated using MAX(Biling_ID) + 1 for simplicity.
-- Example Usage:
--   DECLARE @newBillID INT;
--   EXEC dbo.sp_GenerateInvoice @P_ID = 1, @Services = 'Routine Checkup, Lab Tests',
--                               @Total_Cost = 250.75, @PaymentMethod = 'Credit Card',
--                               @BillingID = @newBillID OUTPUT;
--   SELECT @newBillID AS NewBillingID;
-- =======================================================
--SELECT *FROM PatientServices.Biling
CREATE PROCEDURE dbo.sp_GenerateInvoice
    @P_ID INT,
    @Services NVARCHAR(MAX),
    @Total_Cost DECIMAL(10, 2),
    @PaymentMethod NVARCHAR(50),
    @BillingID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @MaxBillingID INT;

    BEGIN TRY
        -- Generate a new unique Billing ID
        SELECT @MaxBillingID = ISNULL(MAX(Biling_ID), 3000) FROM PatientServices.Biling;
        SET @BillingID = @MaxBillingID + 1;

        -- Insert into Biling table
        INSERT INTO PatientServices.Biling (Biling_ID, P_ID, B_Services, Total_Cost, PaymentDate, PaymentMethod)
        VALUES (@BillingID, @P_ID, @Services, @Total_Cost, GETDATE(), @PaymentMethod);

        PRINT 'Invoice generated successfully. Billing ID: ' + CAST(@BillingID AS NVARCHAR(10)); -- CAST: It is a function used to convert a data type from one type to another.
    END TRY
    BEGIN CATCH
        -- Handle errors
        PRINT 'An error occurred during invoice generation: ' + ERROR_MESSAGE();
        SET @BillingID = -1; -- Indicate failure
    END CATCH
END;
GO

-- TEST
DECLARE @newBillID INT;
EXEC dbo.sp_GenerateInvoice @P_ID = 1, @Services = 'Routine Checkup, Lab Tests',
                            @Total_Cost = 250.75, @PaymentMethod = 'Credit Card',
                            @BillingID = @newBillID OUTPUT;
SELECT @newBillID AS NewBillingID;

SELECT *FROM PatientServices.Biling

-- =======================================================
-- 4. Stored Procedure: sp_AssignDoctorToDepartmentAndShift
-- Description: Assigns or updates a doctor's primary working department and shift.
-- Parameters:
--   @S_ID INT: The Staff ID of the doctor.
--   @NewDep_ID INT: The ID of the new department to assign the doctor to.
--   @NewShift VARCHAR(10): The new shift for the doctor (e.g., 'Morning', 'Evening', 'Night').
-- Remarks:
--   - This procedure updates the Staff table only. If a doctor's primary
--     specialization department in the Doctors table needs to change,
--     that would require additional logic (e.g., deleting and re-inserting
--     into the Doctors table, or updating if Specialization allows multiple entries).
--     This procedure assumes Staff.Dep_ID tracks their current working assignment.
-- Example Usage: EXEC dbo.sp_AssignDoctorToDepartmentAndShift @S_ID = 1, @NewDep_ID = 2, @NewShift = 'Evening';
-- =======================================================
--drop procedure dbo.sp_AssignDoctorToDepartmentAndShift
CREATE PROCEDURE dbo.sp_AssignDoctorToDepartmentAndShift
    @S_ID INT,
    @NewDep_ID INT,
    @NewShift VARCHAR(10),
    @SetStartTime Time,
    @SetEndTime Time
AS
BEGIN
    BEGIN TRY
        -- Debugging: Print received parameters
        PRINT 'Parameters received: S_ID=' + CAST(@S_ID AS NVARCHAR(10)) +
              ', NewDep_ID=' + CAST(@NewDep_ID AS NVARCHAR(10)) +
              ', NewShift=' + @NewShift +
              ', StartTime=' + CONVERT(NVARCHAR(8), @SetStartTime, 108) +
              ', EndTime=' + CONVERT(NVARCHAR(8), @SetEndTime, 108);

        -- Check if the Staff ID exists and belongs to a 'Doctor' role
        IF EXISTS (SELECT 1 FROM SystemCore.Staff WHERE S_ID = @S_ID)
        BEGIN
            PRINT 'S_ID ' + CAST(@S_ID AS NVARCHAR(10)) + ' found and is a Doctor.';
            -- Check if the NewDep_ID is a valid department
            IF EXISTS (SELECT 1 FROM SystemCore.Departments WHERE Dep_ID = @NewDep_ID)
            BEGIN
                PRINT 'Dep_ID ' + CAST(@NewDep_ID AS NVARCHAR(10)) + ' is valid.';

                -- Update the doctor's department in Staff table
                UPDATE SystemCore.Staff
                SET
                    Dep_ID = @NewDep_ID
                WHERE
                    S_ID = @S_ID;
                PRINT 'Staff table updated. Rows affected: ' + CAST(@@ROWCOUNT AS NVARCHAR(10));

                -- Inseart The doctor's shift in the Staff_Shift table
				INSERT INTO SystemCore.Staff_Shift (ShiftName, S_ID, StartTime, EndTime)VALUES (@NewShift, @S_ID, @SetStartTime, @SetEndTime);


                PRINT 'Staff_Shift table Inseart.'

                -- print this message to the user
                PRINT 'Doctor ' + CAST(@S_ID AS NVARCHAR(10)) + ' assigned to Department ID ' +
                      CAST(@NewDep_ID AS NVARCHAR(10)) + ' and ' + @NewShift + ' from ' +
                      CONVERT(NVARCHAR(8), @SetStartTime, 108) + ' to ' +
                      CONVERT(NVARCHAR(8), @SetEndTime, 108) +' shift successfully.';
            END
            ELSE
            BEGIN
                PRINT 'Error: New Department ID ' + CAST(@NewDep_ID AS NVARCHAR(10)) + ' does not exist.';
            END
        END
        ELSE
        BEGIN
            PRINT 'Error: Staff ID ' + CAST(@S_ID AS NVARCHAR(10)) + ' does not exist or is not a doctor.';
        END
    END TRY
    BEGIN CATCH
        -- Handle errors
        PRINT 'An error occurred during doctor assignment: ' + ERROR_MESSAGE();
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
    END CATCH
END;
GO

select * from SystemCore.Staff
Select * from SystemCore.Staff_Shift

Go 

EXEC dbo.sp_AssignDoctorToDepartmentAndShift
    @S_ID = 7, -- Replace with actual S_ID
    @NewDep_ID = 1, -- Replace with actual Department ID
    @NewShift = 'Evening', -- Replace with actual shift name
    @SetStartTime = '08:00:00',
    @SetEndTime = '16:00:00';
Go 

select * from SystemCore.Staff
Select * from SystemCore.Staff_Shift