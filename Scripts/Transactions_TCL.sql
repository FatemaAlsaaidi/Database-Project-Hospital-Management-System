Use HospitalDB

-- =======================================================
-- Transaction: Simulate Patient Admission Process
-- Description: This script simulates a complete patient admission transaction.
-- It encapsulates multiple DML operations (insert into Admissions, update Rooms,
-- insert into Billing) into a single atomic unit.
-- If any step fails, the entire transaction is rolled back, ensuring data consistency.
--
-- Components used:
-- - BEGIN TRANSACTION, COMMIT TRANSACTION, ROLLBACK TRANSACTION
-- - TRY...CATCH block for robust error handling
-- - Calls to previously defined stored procedures:
--   - dbo.sp_AdmitPatient
--   - dbo.sp_GenerateInvoice
-- =======================================================

-- Declare variables for patient, room, and billing details
DECLARE @PatientID INT = 1;      -- Existing Patient ID (e.g., Ahmed Al Balushi)
DECLARE @RoomID INT = 1;         -- Existing Room ID (e.g., Standard room, ensure it's available)
DECLARE @DateOut DATE = '2025-07-01'; -- Expected discharge date
DECLARE @Services NVARCHAR(MAX) = 'Admission Fee, Room Charge (Standard), Initial Consultation';
DECLARE @TotalCost DECIMAL(10, 2) = 500.00;
DECLARE @PaymentMethod NVARCHAR(50) = 'Credit Card';

-- Variables to capture output from stored procedures
DECLARE @GeneratedAdmissionID INT;
DECLARE @GeneratedBillingID INT;

-- --- Pre-Transaction State Check (Optional, for demonstration) ---
PRINT '--- Pre-Transaction State ---';
SELECT 'Rooms' AS TableName, RoomID, RoomType, Available, Capacity FROM HospitalResources.Rooms WHERE RoomID = @RoomID;
SELECT 'Admissions' AS TableName, AdmID, P_ID, Room_ID, DateIN, DateOut FROM PatientServices.Admissions WHERE P_ID = @PatientID;
SELECT 'Billing' AS TableName, Biling_ID, P_ID, B_Services, Total_Cost FROM PatientServices.Biling WHERE P_ID = @PatientID;
PRINT '-----------------------------';

BEGIN TRY
    -- Start the transaction
    BEGIN TRANSACTION;
    PRINT 'Transaction Started.';

    -- 1. Admit the patient (Insert into Admissions, Update Room availability)
    -- This calls the sp_AdmitPatient stored procedure
    EXEC dbo.sp_AdmitPatient
        @P_ID = @PatientID,
        @Room_ID = @RoomID,
        @DateOut = @DateOut,
        @AdmissionID = @GeneratedAdmissionID OUTPUT;

    -- Check if patient admission was successful (sp_AdmitPatient sets @AdmissionID to -1 on failure)
    IF @GeneratedAdmissionID = -1
    BEGIN
        THROW 50001, 'Patient admission failed in sp_AdmitPatient. Rolling back transaction.', 1;
    END

    PRINT 'Patient admitted successfully. Admission ID: ' + CAST(@GeneratedAdmissionID AS NVARCHAR(10));

    -- 2. Create initial billing for the admission
    -- This calls the sp_GenerateInvoice stored procedure
    EXEC dbo.sp_GenerateInvoice
        @P_ID = @PatientID,
        @Services = @Services,
        @Total_Cost = @TotalCost,
        @PaymentMethod = @PaymentMethod,
        @BillingID = @GeneratedBillingID OUTPUT;

    -- Check if billing creation was successful (sp_GenerateInvoice sets @BillingID to -1 on failure)
    IF @GeneratedBillingID = -1
    BEGIN
        THROW 50002, 'Billing creation failed in sp_GenerateInvoice. Rolling back transaction.', 1;
    END

    PRINT 'Billing created successfully. Billing ID: ' + CAST(@GeneratedBillingID AS NVARCHAR(10));

    -- If all operations succeed, commit the transaction
    COMMIT TRANSACTION;
    PRINT 'Transaction Committed Successfully.';

END TRY
BEGIN CATCH
    -- If any error occurs, roll back the transaction
    IF @@TRANCOUNT > 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Transaction Rolled Back Due to Error.';
    END

END CATCH

-- Test
PRINT '--- Post-Transaction State ---';
SELECT 'Rooms' AS TableName, RoomID, RoomType, Available, Capacity FROM HospitalResources.Rooms WHERE RoomID = @RoomID;
SELECT 'Admissions' AS TableName, AdmID, P_ID, Room_ID, DateIN, DateOut FROM PatientServices.Admissions WHERE P_ID = @PatientID;
SELECT 'Billing' AS TableName, Biling_ID, P_ID, B_Services, Total_Cost FROM PatientServices.Biling WHERE P_ID = @PatientID;
PRINT '-----------------------------';


-- Note:
/*
The main logic behind why we need a rollback is: When an error occurs at any step of the transaction, before the transaction has successfully completed (Commit).

In the code I've referenced, this logic is implemented through the BEGIN CATCH block and the IF @@TRANCOUNT > 0 condition:

BEGIN TRY...END TRY and BEGIN CATCH...END CATCH blocks:

BEGIN TRY: This block contains all the operations that must be completed as an integral part of the transaction (such as patient admission, room update, invoice creation). If all these operations proceed successfully without any errors, the COMMIT TRANSACTION is reached, and the changes are permanently committed to the database.
BEGIN CATCH: This block only executes if an error occurs at any point within the BEGIN TRY block. Once an error is detected (whether it's a data error, a failed stored procedure execution, or any other issue that prevents the process from completing successfully), execution jumps directly to the BEGIN CATCH block. Condition IF @@TRANCOUNT > 0:

@@TRANCOUNT is a special counter in SQL Server that tells you how many transactions are currently active in your session.
When you start a transaction with BEGIN TRANSACTION;, the value of @@TRANCOUNT is incremented by one.
When you perform a COMMIT TRANSACTION; or ROLLBACK TRANSACTION;, the value of @@TRANCOUNT is decremented by one.
The logic here is simple: if we enter a BEGIN CATCH block (meaning an error has occurred), we want to ensure that there is indeed an active transaction (not yet committed or rolled back) before we attempt to roll it back.
If @@TRANCOUNT is greater than zero, it means that the BEGIN TRANSACTION has been committed and the transaction is still open. In this case, we know that partial (incomplete) changes have occurred that need to be rolled back.
Why do we need to roll back? (Commit vs. Rollback)

In transactions, we want an "all or nothing" principle:

If every step succeeds, all changes must be permanently committed to the database (COMMIT).
If any step fails, all changes made up to that point must be rolled back (ROLLBACK), returning the database to its original state before the transaction started. This prevents incomplete or inconsistent data.
Example code:
In a patient admission transaction, we have three main steps:

Admit the patient (sp_AdmitPatient).
Generate an invoice (sp_GenerateInvoice).
(And if there are other steps).
If the first step fails (for example, a room is unavailable), it makes no sense to move on to create an invoice or leave the patient in a "pending" state in some part of the system without actually being admitted to a room. Therefore, once the failure is detected in sp_AdmitPatient (which returns -1 and throws a THROW error), execution jumps to BEGIN CATCH. There, it sees that @@TRANCOUNT > 0, so it does a ROLLBACK TRANSACTION to undo any potential changes and leave the database as it was before the accept attempt.

*/
