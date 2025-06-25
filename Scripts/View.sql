Use HospitalDB
 -- 1. vw_DoctorSchedule: Upcoming appointments per doctor. 
CREATE VIEW vw_DoctorSchedule AS
SELECT
    S.S_FName AS DoctorFirstName,
    S.S_LName AS DoctorLastName,
    D.Specialization,
    P.P_FName AS PatientFirstName,
    P.P_LName AS PatientLastName,
    PDA.AppointmentDate,
    PDA.AppointmentTime,
    PDA.Status,
    PDA.AppointmentType,
    Dept.Dep_Name AS DepartmentName
FROM
    MedicalManagement.Patient_Doctor_Appointments AS PDA
JOIN
    PatientServices.Patients AS P ON PDA.P_ID = P.P_ID
JOIN
    MedicalManagement.Doctors AS D ON PDA.S_ID = D.S_ID AND PDA.Dep_ID = D.Dep_ID
JOIN
    SystemCore.Staff AS S ON D.S_ID = S.S_ID
JOIN
    SystemCore.Departments AS Dept ON D.Dep_ID = Dept.Dep_ID
WHERE
    PDA.AppointmentDate >= CONVERT(DATE, GETDATE()) -- Only show upcoming or today's appointments
    AND PDA.Status IN ('Scheduled', 'Rescheduled'); -- Only show active appointments

select * from vw_DoctorSchedule

-- 2. vw_PatientSummary: Patient info with their latest visit.
CREATE VIEW vw_PatientSummary AS
WITH PatientLatestVisit AS (
    SELECT
        P.P_ID,
        P.P_FName,
        P.P_LName,
        P.DBO,
        P.P_Gender,
        P.Address,
        MR.RecordDate AS LatestVisitDate,
        MR.Diagnosis AS LatestDiagnosis,
        S.S_FName AS LatestVisitDoctorFirstName,
        S.S_LName AS LatestVisitDoctorLastName,
        Dept.Dep_Name AS LatestVisitDepartment,
        ROW_NUMBER() OVER (PARTITION BY P.P_ID ORDER BY MR.RecordDate DESC) AS rn
    FROM
        PatientServices.Patients AS P
    LEFT JOIN
        MedicalManagement.MedicalRecords AS MR ON P.P_ID = MR.P_ID
    LEFT JOIN
        SystemCore.Staff AS S ON MR.s_ID = S.S_ID
    LEFT JOIN
        SystemCore.Departments AS Dept ON MR.Dep_ID = Dept.Dep_ID
)
SELECT
    P_ID,
    P_FName,
    P_LName,
    DBO,
    P_Gender,
    Address,
    LatestVisitDate,
    LatestDiagnosis,
    LatestVisitDoctorFirstName,
    LatestVisitDoctorLastName,
    LatestVisitDepartment
FROM
    PatientLatestVisit
WHERE
    rn = 1; -- Select only the latest visit for each patient

select * from vw_PatientSummary

--3. vw_DepartmentStats: Number of doctors and patients per department. 

CREATE VIEW vw_DepartmentStats AS
SELECT
    D.Dep_ID,
    D.Dep_Name,
    COUNT(Doc.S_ID) AS NumberOfDoctors,
    COUNT(Adm.P_ID) AS NumberOfPatientsAdmitted, -- Patients with admissions in this department
    COUNT(PDA.P_ID) AS NumberOfPatientsWithAppointments -- Patients with appointments in this department
FROM
    SystemCore.Departments AS D
LEFT JOIN
    MedicalManagement.Doctors AS Doc ON D.Dep_ID = Doc.Dep_ID
LEFT JOIN
    MedicalManagement.Patient_Doctor_Appointments AS PDA ON D.Dep_ID = PDA.Dep_ID
LEFT JOIN
	PatientServices.Patients AS P ON P.P_ID = PDA.P_ID
LEFT JOIN
    PatientServices.Admissions AS Adm ON P.P_ID = Adm.P_ID
GROUP BY
    D.Dep_ID,
    D.Dep_Name;

select * from vw_DepartmentStats