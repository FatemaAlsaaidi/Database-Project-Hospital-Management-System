CREATE TABLE SystemCore.DoctorDailyScheduleLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    DoctorID INT,
    DoctorName VARCHAR(100),
    AppointmentDate DATE,
    AppointmentTime TIME,
    PatientID INT,
    PatientName VARCHAR(100),
    LogDate DATETIME DEFAULT GETDATE()
);

CREATE PROCEDURE SystemCore.sp_InsertDoctorDailySchedule
AS
BEGIN
    SET NOCOUNT ON;--to improve the preformance of the system (Prevents Unnecessary Messages) 

    DECLARE @Today DATE = CAST(GETDATE() AS DATE);

    INSERT INTO SystemCore.DoctorDailyScheduleLog (DoctorID, DoctorName, AppointmentDate, AppointmentTime, PatientID, PatientName)
    SELECT 
        A.S_ID,
        S.S_FName + ' ' + s.S_LName AS DoctoreFullName,
        A.AppointmentDate,
        A.AppointmentTime,
        A.P_ID,
        P.P_FName + '  ' + P.P_LName AS PatientFullName
    FROM MedicalManagement.Patient_Doctor_Appointments A
    INNER JOIN MedicalManagement.Doctors D ON D.S_ID = A.S_ID and  D.Dep_ID = A.Dep_ID
    INNER JOIN PatientServices .Patients P ON P.P_ID = A.P_ID
	INNER JOIN SystemCore.Staff S ON  S.S_ID= D.S_ID
    WHERE A.AppointmentDate = @Today and S.Role = 'Doctor';
END;



SELECT * FROM SystemCore.DoctorDailyScheduleLog;