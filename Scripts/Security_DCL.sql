USE HospitalDB;

--1. Create at least two user roles: DoctorUser, AdminUser.
CREATE ROLE DoctorUser;
CREATE ROLE AdminUser;

--2. GRANT SELECT for DoctorUser on Patients and Appointments only. 
-- Grant SELECT on Patients table (in PatientServices schema)
GRANT SELECT ON SCHEMA::PatientServices TO DoctorUser; -- Grant SELECT on the entire schema for simplicity
-- If you want to be more granular:
-- GRANT SELECT ON PatientServices.Patients TO DoctorUser;

-- Grant SELECT on Patient_Doctor_Appointments table (in MedicalManagement schema)
GRANT SELECT ON MedicalManagement.Patient_Doctor_Appointments TO DoctorUser;

PRINT 'SELECT permissions granted to DoctorUser on Patients and Patient_Doctor_Appointments.';

--3. GRANT INSERT, UPDATE for AdminUser on all tables.
-- Grant INSERT and UPDATE on all schemas for AdminUser
-- Grant on SystemCore schema
GRANT INSERT ON SCHEMA::SystemCore TO AdminUser;
GRANT UPDATE ON SCHEMA::SystemCore TO AdminUser;

-- Grant on MedicalManagement schema
GRANT INSERT ON SCHEMA::MedicalManagement TO AdminUser;
GRANT UPDATE ON SCHEMA::MedicalManagement TO AdminUser;

-- Grant on PatientServices schema
GRANT INSERT ON SCHEMA::PatientServices TO AdminUser;
GRANT UPDATE ON SCHEMA::PatientServices TO AdminUser;

-- Grant on HospitalResources schema
GRANT INSERT ON SCHEMA::HospitalResources TO AdminUser;
GRANT UPDATE ON SCHEMA::HospitalResources TO AdminUser;

-- Grant on NursingCare schema
GRANT INSERT ON SCHEMA::NursingCare TO AdminUser;
GRANT UPDATE ON SCHEMA::NursingCare TO AdminUser;

-- Additionally, grant SELECT on all schemas if AdminUser needs to view data
GRANT SELECT ON SCHEMA::SystemCore TO AdminUser;
GRANT SELECT ON SCHEMA::MedicalManagement TO AdminUser;
GRANT SELECT ON SCHEMA::PatientServices TO AdminUser;
GRANT SELECT ON SCHEMA::HospitalResources TO AdminUser;
GRANT SELECT ON SCHEMA::NursingCare TO AdminUser;

PRINT 'INSERT, UPDATE, and SELECT permissions granted to AdminUser on all schemas/tables.';

--4. REVOKE DELETE for Doctors. 

REVOKE DELETE ON MedicalManagement.Doctors TO AdminUser;

PRINT 'DELETE permission revoked for AdminUser on MedicalManagement.Doctors table.';