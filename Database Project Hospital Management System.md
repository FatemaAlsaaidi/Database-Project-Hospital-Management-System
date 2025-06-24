# Database Project Hospital Management System
## Required Database Objects
|Table| Description|
|------| ---------|
|Patients| Patient details: name, DOB, gender, contact info |
|Doctors| Doctor details: specialization, contact info |
|Departments| Department details:  cardiology, dermatology, etc.|
|Appointments| Appointment details: Links patients with doctors and a time |
|Admissions| Admission details: For in-patient stays: room number, date in/out |
|Rooms| Room details: Room number, type (ICU, general), availability |
|MedicalRecords| Diagnosis, treatment plans, date, notes|
|Billing| Total cost, patient ID, services, date|
|Staff| Staff details: Nurses, admin: role, shift, assigned dept |
|Users| User accounts: username, password, role (admin, doctor, nurse) |

## ER Diagram
![ER Diagram](img/HospitalManagementSystem-ERD.png)