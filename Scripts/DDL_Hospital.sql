CREATE DATABASE HospitalDB -- create databse 

USE HospitalDB -- Make Sure User the script of HospitalSystem database 

-- drop database HospitalSystem -- To drop databse but make sure that dose currently use to be ability to delete

--============================ Create Tables ========================================

-- 1. Create Departments Table
-- Stores information about various departments in the hospital.
CREATE TABLE Departments (
    Dep_ID INT PRIMARY KEY IDENTITY(1,1), -- Primary Key, auto-incrementing by use "IDENTITY"
    Dep_Name NVARCHAR(100) NOT NULL UNIQUE, -- Department name, must be unique and not null
    Dep_ContactNumber NVARCHAR(20) -- Department contact number
);

-- 2. Create Staff Table
-- Stores information about general hospital staff (nurses, administration, etc.).
CREATE TABLE Staff (
    S_ID INT PRIMARY KEY IDENTITY(1,1), -- Primary Key, auto-incrementing
    S_FName VARCHAR(50) NOT NULL, -- Staff's first name, not null
    S_LName VARCHAR(50) NOT NULL, -- Staff's last name, not null
    Role VARCHAR(100) NOT NULL, -- Staff's role (e.g., Nurse, Administrator, Doctore), not null
    contactInfo VARCHAR(20) UNIQUE, -- Staff's contact number, must be unique if provided
    HireDate DATE NOT NULL DEFAULT GETDATE(), -- Date staff was hired, defaults to current date, not null
	S_Shift VARCHAR(10) NOT NULL, -- Staff's last name, not null
	S_Salary DECIMAL(8,3) CHECK(S_Salary > 350.000), -- Staff's Salary with check constrain to make sure salary should not be less than 350.000
	S_Gender VARCHAR(10) NOT NULL, -- Staff's Gender, not null
	S_State VARCHAR(10) NOT NULL, -- Staff's State, not null
	S_City VARCHAR(10) NOT NULL, -- Staff's City, not null
    Dep_ID INT, -- Foreign Key to Departments table
);

-- 3. Create Doctors Table
-- Stores Additional information about doctors
CREATE TABLE Doctors (
    Specialization VARCHAR(100) NOT NULL, -- Doctor's specialization, not null
    Dep_ID INT, -- Foreign Key to Departments table
	S_ID INT -- Foreign Key to Staff table
);

-- 4. Create Patients Table
-- Stores demographic information for patients.
CREATE TABLE Patients (
    P_ID INT PRIMARY KEY IDENTITY(1,1), -- Primary Key, auto-incrementing
    P_FName VARCHAR(50) NOT NULL, -- Patient's first name, not null
    P_LName VARCHAR(50) NOT NULL, -- Patient's last name, not null
    DBO DATE NOT NULL, -- Patient's date of birth, not null
    P_Gender VARCHAR(10) NOT NULL CHECK (P_Gender IN ('Male', 'Female')), -- Patient's gender, restricted to 'Male', 'Female', not null
    Address VARCHAR(100) -- Patient's address, optional
);

 -- 5. Create Patient Phone Number Table 
 -- Stores Phone Number for patients.

 CREATE tABLE p_ContactInfo(
 P_ID INT, -- Foreign Key to Patient table
 P_ContactInfo VARCHAR(20) Not Null-- Patient's contact number, 
 );


 -- 6. Create Users Table which include UaserNAme and PassWord for Everey Staff in the hospital 
 -- Stored Username and password 
 CREATE TABLE Users(
 Username VARCHAR(10) NOT NULL UNIQUE, --Partial Key User's Information, must be unique 
 S_ID INT NOT NULL, -- Foreign Key to Staff table
 Password VARCHAR(3) NOT NULL
 );

 --7. Create Admissions Table 
 -- Stored setting room information 

 CREATE TABLE Admissions
 (
 AdmID INT UNIQUE NOT NULL, -- Partial key, UNIQUE NUMBER OF EVERY ADMISSION 
 P_ID INT NOT NULL, -- Foreign Key to Patient table
 Room_ID INT NOT NULL, -- Foreign Key to Rooms table
 DateIN DATE NOT NULL DEFAULT GETDATE(), -- Date IN was admitted , defaults to current date, not null
 DateOut DATE NOT NULL -- DATE OUT NOT NULL 
 );


 -- 8. Create Rooms Table
 -- Stores details about rooms in the hospital.
CREATE TABLE Rooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1), -- Primary Key, auto-incrementing
    RoomType VARCHAR(50) NOT NULL CHECK (RoomType IN ('Standard', 'Deluxe', 'ICU', 'Emergency', 'Operation Theater', 'Consultation')), -- Type of room, restricted values, not null
    Capacity INT NOT NULL CHECK (Capacity > 0), -- Maximum patient capacity of the room, must be greater than 0, not null
    Available  VARCHAR(10) DEFAULT 'TRUE' NOT NULL -- Room availability: by defualt is true, and not null

);

--9. Create MedicalRecords Table
-- Stores medical history, diagnosis, and treatment details for patients.
CREATE TABLE MedicalRecords (
    Record_ID INT Not null, -- Partial key, Not Null
    P_ID INT NOT NULL, -- Foreign Key to Patients table, not null
    s_ID INT NOT NULL, -- Foreign Key to Doctors table, not null
	Dep_ID INT NOT NULL, -- Foreign Key to Department table, not null
    Diagnosis VARCHAR(MAX) NOT NULL, -- Diagnosis, cannot be null
    Record_Notes VARCHAR(MAX), -- Treatment provided, optional THE WHY IT SOT SET AS NOT NULL 
    RecordDate DATETIME NOT NULL DEFAULT GETDATE(), -- Date and time the record was created, defaults to current datetime, not null
	Treatment_Plans NVARCHAR(MAX) -- Treatment provided, optional
);


--10. Create Biling table 
-- Records financial transactions related to patient services.
CREATE TABLE Biling (
    Biling_ID INT NOT NULL, -- Partial Key, Not null
    P_ID INT NOT NULL, -- Foreign Key to Patients table, not null
	B_Services VARCHAR(MAX) NOT NULL , --services information , not null 
    Total_Cost DECIMAL(10, 2) NOT NULL CHECK (Total_Cost >= 0), -- Payment amount, must be non-negative, not null
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(), -- Date and time of payment, defaults to current datetime, not null
    PaymentMethod NVARCHAR(50) NOT NULL CHECK (PaymentMethod IN ('Cash', 'Credit Card', 'Debit Card', 'Insurance', 'Bank Transfer')), -- Method of payment, restricted values, not null
);

--11. -- Create Medicine Table
-- Stores information about medicines available in the hospital pharmacy.
CREATE TABLE Medicine (
    MedID INT PRIMARY KEY IDENTITY(1,1), -- Primary Key, auto-incrementing
    Name NVARCHAR(100) NOT NULL UNIQUE, -- Name of the medicine, must be unique and not null
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0), -- Price of the medicine, must be non-negative, not null
    Quantity INT NOT NULL CHECK (Quantity >= 0) -- Quantity of the medicine in stock, must be non-negative, not null
);

-- 12. Create Patient_Medicine (Give) Table
-- This is a junction table to record which medicine is given to which patient.
-- Assumes PatientID and MedID refer to existing Patients and Medicine tables.
CREATE TABLE Patient_Medicine (
    P_ID INT NOT NULL, -- Foreign Key to Patients table
    MedID INT NOT NULL, -- Foreign Key to Medicine table
    QuantityGiven INT NOT NULL CHECK (QuantityGiven > 0), -- Quantity of medicine given to the patient, must be positive
    DateGiven DATETIME NOT NULL DEFAULT GETDATE(), -- Date and time the medicine was given, defaults to current datetime
    PRIMARY KEY (P_ID, MedID, DateGiven), -- Composite Primary Key to allow multiple records for same patient/medicine over time
    
);


-- 13. Create Patient_Doctor_Treats Table
-- This is a junction table to record which doctor treats which patient.
-- S_ID is likely StaffID or DoctorID; assuming DoctorID based on context.
-- Dep_ID is likely DepartmentID.
CREATE TABLE Patient_Doctor_Treats (
    P_ID INT NOT NULL, -- Foreign Key to Patients table
    S_ID INT NOT NULL, -- Foreign Key to Doctors table (assuming S_ID refers to DoctorID)
    Dep_ID INT NOT NULL, -- Foreign Key to Departments table (assuming Dep_ID refers to DepartmentID)
    PRIMARY KEY (P_ID, S_ID, Dep_ID) -- Composite Primary Key
);

-- -- 14. Create Patient_Doctor_Appointments_Log Table
-- Detailed log of patient appointments, similar to Appointments table but with more specific fields.
CREATE TABLE Patient_Doctor_Appointments (
    P_ID INT NOT NULL, -- Foreign Key to Patients table
    S_ID INT NOT NULL, -- Foreign Key to Doctors table (assuming S_ID refers to DoctorID)
    Dep_ID INT NOT NULL, -- Foreign Key to Departments table (assuming Dep_ID refers to DepartmentID)
    AppointmentDate DATE NOT NULL, -- Date of the appointment
    AppointmentTime TIME NOT NULL, -- Time of the appointment
    Status NVARCHAR(50) NOT NULL CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled', 'Rescheduled')), -- Status of the appointment
    AppointmentType NVARCHAR(100), -- Type of appointment (e.g., 'Follow-up', 'New Consultation')
    PRIMARY KEY (P_ID, S_ID, Dep_ID, AppointmentDate, AppointmentTime), -- Composite Primary Key for unique appointment entries
    
);

--drop table Patient_Doctor_Appointments_Log

-- 15. Create Staff_Department (Nursing Care) Table
-- This is a junction table to record staff assignments to departments, especially for nursing care.
-- Assumes S_ID is StaffID.
CREATE TABLE Staff_Department_NursingCare(
    S_ID INT NOT NULL, -- Foreign Key to Staff table
    Dep_ID INT NOT NULL, -- Foreign Key to Departments table
    PRIMARY KEY (S_ID, Dep_ID), -- Composite Primary Key (a staff member can be assigned to a department)
    
);
--drop table Staff_Department
-- ================================= Foriegn Key  ========================

-- 1. linke between P_ContactInfo table and Patients Table 
alter table p_ContactInfo
Add CONSTRAINT FK_P_ContactInfo_Patiant FOREIGN KEY (P_ID) REFERENCES Patients(P_ID)
ON DELETE  NO ACTION
ON UPDATE CASCADE

-- 2. link between Staff table and department table 
alter table Staff
Add CONSTRAINT FK_Staff_Departments FOREIGN KEY (Dep_ID) REFERENCES Departments(Dep_ID)
ON DELETE  NO ACTION
ON UPDATE CASCADE

-- 3. linke between Staff and dector
alter table Doctors
Add CONSTRAINT FK_Doctors_Staff FOREIGN KEY (S_ID) REFERENCES Staff(S_ID)
ON DELETE NO ACTION 
ON UPDATE CASCADE

-- 4. link between doctor table and department table

alter table Doctors
Add CONSTRAINT FK_Doctors_Departments FOREIGN KEY (Dep_ID) REFERENCES Departments(Dep_ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION


/*ALTER TABLE p_ContactInfo
      DROP  CONSTRAINT FK_Patiant_P_ContactInfo */

-- 5. link between users table and staff table 
alter table Users
Add CONSTRAINT FK_Users_staff FOREIGN KEY (S_ID) REFERENCES Staff(S_ID)
ON DELETE NO ACTION
ON UPDATE CASCADE

-- 6. linke between Admissions table and patiant table 
alter table Admissions
Add CONSTRAINT FK_Admissions_Patiant FOREIGN KEY (P_ID) REFERENCES Patients(P_ID)
ON DELETE CASCADE
ON UPDATE CASCADE

-- 7. linke bwtween Admissions table and room table
alter table Admissions
Add CONSTRAINT FK_Admissions_Room FOREIGN KEY (Room_ID) REFERENCES Rooms(RoomID)
ON DELETE CASCADE
ON UPDATE CASCADE

-- 8. linke between MedicalRecords table and patiant table
alter table MedicalRecords
Add CONSTRAINT FK_MedicalRecords_patiant FOREIGN KEY (P_ID) REFERENCES Patients(P_ID)
ON DELETE CASCADE
ON UPDATE CASCADE

-- 9. link between MedicalRecords table and doctor table
-- Modify the columns to be NOT NULL
ALTER TABLE Doctors
ALTER COLUMN Dep_ID INT NOT NULL;

ALTER TABLE Doctors
ALTER COLUMN S_ID INT NOT NULL;

-- Add primary key
ALTER TABLE Doctors
ADD PRIMARY KEY (S_ID, Dep_ID);


-- now can make link between MedicalRecords table and doctor table
alter table MedicalRecords
Add CONSTRAINT FK_MedicalRecords_doctor FOREIGN KEY (s_ID, Dep_ID) REFERENCES Doctors(S_ID, Dep_ID)
ON DELETE CASCADE
ON UPDATE CASCADE

-- 10. link between Billing table and patiant table
alter table Biling
Add CONSTRAINT FK_Billings_patiant FOREIGN KEY(P_ID) REFERENCES Patients(P_ID)
ON DELETE NO ACTION
ON UPDATE CASCADE

-- 11. link between Patient_Medicine (Give) table and patiant table
alter table Patient_Medicine
Add CONSTRAINT FK_Patient_Medicine_Give_patiant FOREIGN KEY(P_ID) REFERENCES Patients(P_ID)
ON DELETE CASCADE
ON UPDATE CASCADE

-- 12. link between Patient_Medicine (Give) table and Medicine table 
alter table Patient_Medicine
Add CONSTRAINT FK_Patient_Medicine_Give_Medicine FOREIGN KEY(MedID) REFERENCES Medicine(MedID)
ON DELETE CASCADE
ON UPDATE CASCADE

--13. link between Patient_Doctor(Treats) table and patiant table
alter table Patient_Doctor_Treats 
Add CONSTRAINT FK_Patient_Doctor_Treats_patiant FOREIGN KEY(P_ID) REFERENCES Patients(P_ID)
ON DELETE CASCADE
ON UPDATE CASCADE


-- 14. link between Patient_Doctor(Treats) table and Doctores table
alter table Patient_Doctor_Treats
Add CONSTRAINT FK_Patient_Doctor_Treats_Doctors FOREIGN KEY (s_ID, Dep_ID) REFERENCES Doctors(S_ID, Dep_ID)
ON DELETE CASCADE
ON UPDATE CASCADE

-- 15. link between Patient_Doctor(Appointment) table and doctor
alter table Patient_Doctor_Appointments  
Add CONSTRAINT FK_Patient_Doctor_Appointments_patiant FOREIGN KEY(P_ID) REFERENCES Patients(P_ID)
ON DELETE CASCADE
ON UPDATE CASCADE

-- 16. link between Patient_Doctor(Appointment) table and Doctores table
alter table Patient_Doctor_Appointments  
Add CONSTRAINT FK_Patient_Doctor_Appointments_Doctors FOREIGN KEY (s_ID, Dep_ID) REFERENCES Doctors(S_ID, Dep_ID)
ON DELETE CASCADE
ON UPDATE CASCADE


-- 17. link between Staff_Department_NursingCare table and sttaf table
alter table Staff_Department_NursingCare
Add CONSTRAINT FK_Staff_Department_NursingCare_staff FOREIGN KEY (S_ID) REFERENCES Staff(S_ID)
ON DELETE CASCADE
ON UPDATE CASCADE

-- 18. link between Staff_Department_NursingCare table and department table
alter table Staff_Department_NursingCare
Add CONSTRAINT FK_Staff_Department_NursingCare_Departments FOREIGN KEY (Dep_ID) REFERENCES Departments(Dep_ID)
ON DELETE NO ACTION
ON UPDATE NO ACTION
