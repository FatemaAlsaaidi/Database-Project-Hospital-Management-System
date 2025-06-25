USE HospitalDB;


-- 1. Create Core System Schema
-- This schema will contain foundational tables related to hospital administration and general staff.
CREATE SCHEMA SystemCore;

-- Transfer tables to SystemCore schema
ALTER SCHEMA SystemCore TRANSFER dbo.Departments;
ALTER SCHEMA SystemCore TRANSFER dbo.Staff;
ALTER SCHEMA SystemCore TRANSFER dbo.Users;

-- 2. Create Doctors and Medical Records Schema
-- This schema will group tables primarily related to doctors, their specializations, and patient medical records.
CREATE SCHEMA MedicalManagement;


-- Transfer tables to MedicalManagement schema
ALTER SCHEMA MedicalManagement TRANSFER dbo.Doctors;
ALTER SCHEMA MedicalManagement TRANSFER dbo.MedicalRecords;
ALTER SCHEMA MedicalManagement TRANSFER dbo.Patient_Doctor_Treats;
ALTER SCHEMA MedicalManagement TRANSFER dbo.Patient_Doctor_Appointments;


-- 3. Create Patients and Billing Schema
-- This schema will contain tables related to patient demographics, contact information, admissions, and billing.
CREATE SCHEMA PatientServices;


-- Transfer tables to PatientServices schema
ALTER SCHEMA PatientServices TRANSFER dbo.Patients;
ALTER SCHEMA PatientServices TRANSFER dbo.p_ContactInfo;
ALTER SCHEMA PatientServices TRANSFER dbo.Admissions;
ALTER SCHEMA PatientServices TRANSFER dbo.Biling;
ALTER SCHEMA PatientServices TRANSFER dbo.Patient_Medicine;


-- 4. Create Resources and Inventory Schema
-- This schema will manage hospital resources like rooms and medicine inventory.
CREATE SCHEMA HospitalResources;


-- Transfer tables to HospitalResources schema
ALTER SCHEMA HospitalResources TRANSFER dbo.Rooms;
ALTER SCHEMA HospitalResources TRANSFER dbo.Medicine;


-- 5. Create Nursing Care Schema
-- This schema specifically addresses staff assignments for nursing care.
CREATE SCHEMA NursingCare;


-- Transfer tables to NursingCare schema
ALTER SCHEMA NursingCare TRANSFER dbo.Staff_Department_NursingCare;

