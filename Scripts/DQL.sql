 -- Queries to Test (DQL) 
 USE HospitalDB;
 -- 1. List all patients who visited a certain doctor.
 SELECT
    P.P_ID,
    P.P_FName,
    P.P_LName,
    P.DBO,
    P.P_Gender,
    P.Address
FROM
    PatientServices.Patients AS P
JOIN
    MedicalManagement.Patient_Doctor_Treats AS PDT ON P.P_ID = PDT.P_ID
JOIN
    MedicalManagement.Doctors AS D ON PDT.S_ID = D.S_ID AND PDT.Dep_ID = D.Dep_ID
JOIN
    SystemCore.Staff AS S ON D.S_ID = S.S_ID
WHERE
    S.S_FName = 'Dr. Salim' AND S.S_LName = 'Al Rashdi';

--2. Count of appointments per department. 
SELECT
    D.Dep_Name,
    COUNT(PDA.P_ID) AS NumberOfAppointments
FROM
    SystemCore.Departments AS D
JOIN
    MedicalManagement.Patient_Doctor_Appointments AS PDA ON D.Dep_ID = PDA.Dep_ID
GROUP BY
    D.Dep_Name
ORDER BY
    NumberOfAppointments DESC;

-- 3. Retrieve doctors who have more than 5 appointments in a month.
-- This query uses GROUP BY, HAVING, and date functions, along with JOINs.
-- Replace '2024-07' with the desired year and month.
SELECT * FROM MedicalManagement.Patient_Doctor_Appointments
SELECT
    S.S_FName,
    S.S_LName,
    D.Specialization,
    COUNT(PDA.P_ID) AS TotalAppointments
FROM
    SystemCore.Staff AS S
JOIN
    MedicalManagement.Doctors AS D ON S.S_ID = D.S_ID
JOIN
    MedicalManagement.Patient_Doctor_Appointments AS PDA ON D.S_ID = PDA.S_ID AND D.Dep_ID = PDA.Dep_ID
WHERE
    FORMAT(PDA.AppointmentDate, 'yyyy-MM') = '2024-07' -- Filter for a specific month
GROUP BY
    S.S_FName,
    S.S_LName,
    D.Specialization
HAVING
    COUNT(PDA.P_ID) >=1
ORDER BY
    TotalAppointments DESC;

--4. -- Query 4: Use JOINs across 3-4 tables 
--(Example: Patients, Admissions, Rooms, Departments)
-- This query lists patients currently admitted, their room type, and the department managing that room.

SELECT
    P.P_FName,
    P.P_LName,
    A.DateIN,
    R.RoomType,
    R.RoomID
FROM
    PatientServices.Patients AS P
JOIN
    PatientServices.Admissions AS A ON P.P_ID = A.P_ID
JOIN
    HospitalResources.Rooms AS R ON A.Room_ID = R.RoomID
WHERE
    R.Available = 'FALSE'; -- Assuming 'FALSE' means currently occupied

--5. Use GROUP BY, HAVING, and aggregate functions. 
SELECT
    D.Dep_Name,
    SUM(S.S_Salary) AS TotalDepartmentSalary
FROM
    SystemCore.Departments AS D
JOIN
    SystemCore.Staff AS S ON D.Dep_ID = S.Dep_ID
GROUP BY
    D.Dep_Name
HAVING
    SUM(S.S_Salary) > 5000.000 -- Adjust this threshold as needed
ORDER BY
    TotalDepartmentSalary DESC;

--6. Use SUBQUERIES and EXISTS. 
SELECT
    S.S_FName,
    S.S_LName,
    D.Specialization
FROM
    SystemCore.Staff AS S
JOIN
    MedicalManagement.Doctors AS D ON S.S_ID = D.S_ID
WHERE D.S_ID IN (
    SELECT MR.s_ID
    FROM MedicalManagement.MedicalRecords AS MR
    WHERE MR.Diagnosis = 'Hypertension'
);