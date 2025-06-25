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

-- test
SELECT
    P.P_FName,
    P.P_LName,
    P.DBO,
    dbo.fn_CalculatePatientAge(P.DBO) AS Age
FROM
    PatientServices.Patients AS P;

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
-- Declare the inputes variable 
    @P_ID INT,
    @Room_ID INT,
    @DateOut DATE,
    @AdmissionID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON; -- 
	-- declare this variable to store the value which get from table 
    DECLARE @IsRoomAvailable VARCHAR(10); 
    DECLARE @MaxAdmID INT;

    BEGIN TRY
        -- Check room availability
        SELECT @IsRoomAvailable = Available
        FROM HospitalResources.Rooms
        WHERE RoomID = @Room_ID;

        IF @IsRoomAvailable = 'TRUE'
        BEGIN
            -- Generate a new unique Admission ID
            SELECT @MaxAdmID = ISNULL(MAX(AdmID), 100) FROM PatientServices.Admissions;
            SET @AdmissionID = @MaxAdmID + 1; -- add last admID +1 to generate the 

            -- Insert into Admissions table
            INSERT INTO PatientServices.Admissions (AdmID, P_ID, Room_ID, DateIN, DateOut)
            VALUES (@AdmissionID, @P_ID, @Room_ID, GETDATE(), @DateOut);

            -- Update Room availability
            UPDATE HospitalResources.Rooms
            SET Available = 'FALSE'
            WHERE RoomID = @Room_ID;

            PRINT 'Patient admitted successfully. Admission ID: ' + CAST(@AdmissionID AS NVARCHAR(10)); -- CAST: It is a function used to convert a data type from one type to another.
        END
        ELSE
        BEGIN
            SET @AdmissionID = -1; -- Indicate admission failure
            PRINT 'Error: Room is not available.';
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
    @Room_ID = 101,         -- Room currently available (Available = 'TRUE')
    @DateOut = '2025-07-10',
    @AdmissionID = @NewAdmissionID OUTPUT;

--Third: Display the resulting ID value
SELECT @NewAdmissionID AS NewAdmissionID;
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
CREATE PROCEDURE dbo.sp_AssignDoctorToDepartmentAndShift
    @S_ID INT,
    @NewDep_ID INT,
    @NewShift VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Check if the Staff ID exists and belongs to a 'Doctor' role
        IF EXISTS (SELECT 1 FROM SystemCore.Staff WHERE S_ID = @S_ID AND Role = 'Doctor')
        BEGIN
            -- Check if the NewDep_ID is a valid department
            IF EXISTS (SELECT 1 FROM SystemCore.Departments WHERE Dep_ID = @NewDep_ID)
            BEGIN
                -- Update the doctor's department and shift in the Staff table
                UPDATE SystemCore.Staff
                SET
                    Dep_ID = @NewDep_ID,
                    S_Shift = @NewShift
                WHERE
                    S_ID = @S_ID;
				-- print this massage to the user 
                PRINT 'Doctor ' + CAST(@S_ID AS NVARCHAR(10)) + ' assigned to Department ID ' +
                      CAST(@NewDep_ID AS NVARCHAR(10)) + ' and ' + @NewShift + ' shift successfully.';
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
    END CATCH
END;
GO

EXEC dbo.sp_AssignDoctorToDepartmentAndShift @S_ID = 1, @NewDep_ID = 2, @NewShift = 'Evening';

select * from SystemCore.Staff