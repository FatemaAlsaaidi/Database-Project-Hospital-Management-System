SELECT name FROM sys.databases;



BACKUP DATABASE HospitalDB
TO DISK = 'c:\Backup\HospitalManagementSystem.bak'
WITH INIT, COMPRESSION;


SELECT name, state_desc
FROM sys.databases
WHERE name = 'HospitalManagementSystem';
