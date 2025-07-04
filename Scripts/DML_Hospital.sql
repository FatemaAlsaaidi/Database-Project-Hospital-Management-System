USE HospitalDB;

-- 1. Inserting data into Departments Table (20 values)
INSERT INTO Departments (Dep_Name, Dep_ContactNumber) VALUES
('Cardiology', '96871234567'),
('Pediatrics', '96871234568'),
('Orthopedics', '96871234569'),
('Dermatology', '96871234570'),
('Neurology', '96871234571'),
('Oncology', '96871234572'),
('Emergency', '96871234573'),
('Radiology', '96871234574'),
('Pathology', '96871234575'),
('Pharmacy', '96871234576'),
('Physiotherapy', '96871234577'),
('General Surgery', '96871234578'),
('Internal Medicine', '96871234579'),
('Ophthalmology', '96871234580'),
('ENT', '96871234581'),
('Urology', '96871234582'),
('Gastroenterology', '96871234583'),
('Anesthesiology', '96871234584'),
('Psychiatry', '96871234585'),
('Nutrition and Dietetics', '96871234586');


-- 2. Inserting data into Rooms Table (20 values)
INSERT INTO Rooms (RoomType, Capacity, Available) VALUES
('Standard', 2, 'TRUE'),
('Deluxe', 1, 'TRUE'),
('ICU', 1, 'FALSE'),
('Emergency', 3, 'TRUE'),
('Operation Theater', 4, 'TRUE'), -- Capacity 0 for OT as it's a procedural room, not for staying
('Consultation', 1, 'TRUE'),
('Standard', 2, 'TRUE'),
('Deluxe', 1, 'FALSE'),
('ICU', 1, 'TRUE'),
('Emergency', 3, 'TRUE'),
('Consultation', 1, 'TRUE'),
('Standard', 2, 'TRUE'),
('Deluxe', 1, 'TRUE'),
('ICU', 1, 'FALSE'),
('Emergency', 3, 'TRUE'),
('Operation Theater', 4, 'TRUE'),
('Consultation', 1, 'TRUE'),
('Standard', 2, 'FALSE'),
('Deluxe', 1, 'TRUE'),
('Consultation', 1, 'TRUE');


-- 3. Inserting data into Medicine Table (20 values)
INSERT INTO Medicine (Name, Price, Quantity) VALUES
('Paracetamol 500mg', 0.50, 1000),
('Amoxicillin 250mg', 1.20, 500),
('Ibuprofen 400mg', 0.75, 800),
('Omeprazole 20mg', 2.10, 300),
('Cetirizine 10mg', 0.90, 600),
('Dextromethorphan Syrup', 3.50, 200),
('Metformin 500mg', 1.80, 450),
('Atorvastatin 10mg', 4.20, 250),
('Amlodipine 5mg', 2.50, 350),
('Sertraline 50mg', 5.00, 150),
('Ventolin Inhaler', 15.00, 100),
('Hydrocortisone Cream', 6.00, 200),
('Furosemide 40mg', 1.00, 300),
('Lisinopril 10mg', 2.70, 280),
('Diazepam 5mg', 3.00, 180),
('Warfarin 5mg', 7.50, 120),
('Insulin Glargine', 50.00, 50),
('Ciprofloxacin 500mg', 2.80, 400),
('Gabapentin 300mg', 3.20, 220),
('Prednisone 5mg', 1.50, 330);


-- 4. Inserting data into Patients Table (20 values)
INSERT INTO Patients (P_FName, P_LName, DBO, P_Gender, Address) VALUES
('Ahmed', 'Al Balushi', '1985-03-15', 'Male', 'Muscat, Al Khuwair'),
('Fatima', 'Al Hinai', '1992-07-22', 'Female', 'Sohar, Al Batinah'),
('Khalid', 'Al Rashdi', '1970-11-01', 'Male', 'Salalah, Dhofar'),
('Aisha', 'Al Habsi', '2000-01-20', 'Female', 'Nizwa, Ad Dakhiliyah'),
('Sultan', 'Al Maamari', '1965-05-30', 'Male', 'Sur, Sharqiyah South'),
('Mariam', 'Al Amri', '1998-09-10', 'Female', 'Muscat, Seeb'),
('Abdullah', 'Al Fazari', '1980-02-28', 'Male', 'Ibri, Ad Dhahirah'),
('Noora', 'Al Saidi', '1995-12-05', 'Female', 'Barka, Al Batinah South'),
('Mohammed', 'Al Kalbani', '1973-06-18', 'Male', 'Khasab, Musandam'),
('Hoor', 'Al Zadjali', '2005-04-03', 'Female', 'Muscat, Bowsher'),
('Said', 'Al Harthi', '1988-08-08', 'Male', 'Rustaq, Al Batinah South'),
('Salma', 'Al Shukaili', '1960-10-25', 'Female', 'Sohar, Al Azaiba'),
('Yousuf', 'Al Hasani', '1990-01-12', 'Male', 'Duqm, Al Wusta'),
('Zainab', 'Al Qasmi', '1978-03-01', 'Female', 'Samail, Ad Dakhiliyah'),
('Hamad', 'Al Jahwari', '1993-07-07', 'Male', 'Al Buraimi, Al Buraimi'),
('Sara', 'Al Shizawi', '2002-11-14', 'Female', 'Sohar, Al Hambar'),
('Nasser', 'Al Rawahi', '1982-04-29', 'Male', 'Muscat, Ghubrah'),
('Hind', 'Al Busaidi', '1975-09-02', 'Female', 'Nizwa, Tanuf'),
('Ali', 'Al Abri', '1997-06-21', 'Male', 'Salalah, Ittin'),
('Khulood', 'Al Farsi', '1968-12-19', 'Female', 'Sur, Bilad Sur');

-- 5. Inserting data into Staff Table (20 values)
-- Requires Dep_ID from Departments table (1-20)
ALTER TABLE Staff
ALTER COLUMN S_City VARCHAR(50);


INSERT INTO Staff (S_FName, S_LName, Role, contactInfo, HireDate, S_Shift, S_Salary, S_Gender, S_State, S_City, Dep_ID) VALUES
('Dr. Salim', 'Al Rashdi', 'Doctor', '96891112222', '2018-01-10', 'Morning', 2500.000, 'Male', 'Muscat', 'Bowsher', 1), -- Cardiology
('Nurse Fatma', 'Al Farsi', 'Nurse', '96891112223', '2019-03-15', 'Night', 850.000, 'Female', 'Muscat', 'Seeb', 2), -- Pediatrics
('Dr. Aisha', 'Al Hasani', 'Doctor', '96891112224', '2017-06-20', 'Morning', 2800.000, 'Female', 'Sohar', 'Al Batinah', 3), -- Orthopedics
('Admin Khalid', 'Al Amri', 'Administrator', '96891112225', '2020-01-05', 'Day', 900.000, 'Male', 'Muscat', 'Al Khuwair', 4), -- Dermatology
('Dr. Hamed', 'Al Habsi', 'Doctor', '96891112226', '2016-11-11', 'Morning', 2600.000, 'Male', 'Salalah', 'Dhofar', 5), -- Neurology
('Nurse Sara', 'Al Busaidi', 'Nurse', '96891112227', '2021-02-01', 'Evening', 950.000, 'Female', 'Nizwa', 'Ad Dakhiliyah', 6), -- Oncology
('Dr. Ali', 'Al Qasmi', 'Doctor', '96891112228', '2015-09-01', 'Morning', 3000.000, 'Male', 'Muscat', 'Muttrah', 7), -- Emergency
('Technician Maryam', 'Al Hinai', 'Radiology Technician', '96891112229', '2022-04-01', 'Day', 700.000, 'Female', 'Sur', 'Sharqiyah South', 8), -- Radiology
('Dr. Ahmed', 'Al Abri', 'Doctor', '96891112230', '2019-07-25', 'Morning', 2700.000, 'Male', 'Sohar', 'Al Batinah', 9), -- Pathology
('Pharmacist Noor', 'Al Zadjali', 'Pharmacist', '96891112231', '2020-05-10', 'Day', 1200.000, 'Female', 'Muscat', 'Al Amerat', 10), -- Pharmacy
('Physio Yousef', 'Al Mahrouqi', 'Physiotherapist', '96891112232', '2021-08-01', 'Day', 1000.000, 'Male', 'Ibri', 'Ad Dhahirah', 11), -- Physiotherapy
('Dr. Layla', 'Al Wahaibi', 'Doctor', '96891112233', '2017-03-05', 'Morning', 2900.000, 'Female', 'Muscat', 'Rusayl', 12), -- General Surgery
('Nurse Sultan', 'Al Balushi', 'Nurse', '96891112234', '2022-01-10', 'Morning', 800.000, 'Male', 'Barka', 'Al Batinah South', 13), -- Internal Medicine
('Dr. Nadia', 'Al Siyabi', 'Doctor', '96891112235', '2018-04-20', 'Morning', 2750.000, 'Female', 'Muscat', 'Qurum', 14), -- Ophthalmology
('Dr. Omar', 'Al Kindi', 'Doctor', '96891112236', '2016-10-01', 'Morning', 2850.000, 'Male', 'Khasab', 'Musandam', 15), -- ENT
('Nurse Hind', 'Al Maskari', 'Nurse', '96891112237', '2019-09-01', 'Evening', 900.000, 'Female', 'Muscat', 'Darsait', 16), -- Urology
('Dr. Abdullah', 'Al Shukaili', 'Doctor', '96891112238', '2017-02-14', 'Morning', 2950.000, 'Male', 'Muscat', 'Mawaleh', 17), -- Gastroenterology
('Nurse Mohammed', 'Al Harthi', 'Nurse', '96891112239', '2020-03-01', 'Night', 880.000, 'Male', 'Rustaq', 'Al Batinah South', 18), -- Anesthesiology
('Dr. Mona', 'Al Ghaithi', 'Doctor', '96891112240', '2018-05-20', 'Morning', 2650.000, 'Female', 'Muscat', 'Al Khoud', 19), -- Psychiatry
('Dietitian Amani', 'Al Ruqaishi', 'Dietitian', '96891112241', '2021-01-15', 'Day', 1100.000, 'Female', 'Muscat', 'Al Ghubrah', 20); -- Nutrition and Dietetics

Select * from Staff

-- 6. Inserting data into Doctors Table (20 values)
INSERT INTO Doctors (Specialization, Dep_ID, S_ID) VALUES
('Cardiologist', 1, 7),
('Pediatrician', 2, 9), -- Adjusted S_ID for a new doctor, assuming original Staff S_ID 3 is a doctor
('Orthopedic Surgeon', 3, 11), -- Adjusted S_ID
('Dermatologist', 4, 13), -- Adjusted S_ID
('Neurologist', 5, 15), -- Adjusted S_ID
('Oncologist', 6, 12), -- Adjusted S_ID
('Emergency Physician', 7, 14), -- Adjusted S_ID
('Radiologist', 8, 15), -- Adjusted S_ID
('Pathologist', 9, 17), -- Adjusted S_ID
('Internal Medicine Specialist', 13, 19); -- Adjusted S_ID

INSERT INTO Staff (S_FName, S_LName, Role, contactInfo, HireDate, S_Shift, S_Salary, S_Gender, S_State, S_City, Dep_ID) VALUES
('Dr. Jasim', 'Al Rawahi', 'Doctor', '96891112242', '2019-02-01', 'Morning', 2700.000, 'Male', 'Muscat', 'Azaiba', 1), -- Cardiology
('Dr. Badriya', 'Al Kindi', 'Doctor', '96891112243', '2020-08-10', 'Morning', 2600.000, 'Female', 'Sohar', 'Falaj', 2), -- Pediatrics
('Dr. Fahad', 'Al Maqbali', 'Doctor', '96891112244', '2017-05-12', 'Morning', 2850.000, 'Male', 'Nizwa', 'Firq', 3), -- Orthopedics
('Dr. Shatha', 'Al Saadi', 'Doctor', '96891112245', '2021-03-01', 'Morning', 2550.000, 'Female', 'Sur', 'Aseela', 4), -- Dermatology
('Dr. Tareq', 'Al Ismaili', 'Doctor', '96891112246', '2018-09-15', 'Morning', 2900.000, 'Male', 'Muscat', 'Mabellah', 5), -- Neurology
('Dr. Hajar', 'Al Balushi', 'Doctor', '96891112247', '2016-04-22', 'Morning', 3000.000, 'Female', 'Salalah', 'Saadah', 6), -- Oncology
('Dr. Yousra', 'Al Ghaithi', 'Doctor', '96891112248', '2022-01-01', 'Morning', 2700.000, 'Female', 'Muscat', 'Wadi Kabir', 7), -- Emergency
('Dr. Qais', 'Al Hashmi', 'Doctor', '96891112249', '2019-11-05', 'Morning', 2650.000, 'Male', 'Muscat', 'Ruwi', 8), -- Radiology
('Dr. Amal', 'Al Riami', 'Doctor', '96891112250', '2020-07-07', 'Morning', 2750.000, 'Female', 'Ibri', 'Al Dariz', 9), -- Pathology
('Dr. Ghanim', 'Al Hajri', 'Doctor', '96891112251', '2017-08-01', 'Morning', 2950.000, 'Male', 'Muscat', 'Al Hail', 12); -- General Surgery


INSERT INTO Doctors (Specialization, Dep_ID, S_ID) VALUES
('Cardiologist', 1, 21),
('Pediatrician', 2, 22),
('Orthopedic Surgeon', 3, 23),
('Dermatologist', 4, 24),
('Neurologist', 5, 25),
('Oncologist', 6, 26),
('Emergency Physician', 7, 27),
('Radiologist', 8, 28),
('Pathologist', 9, 29),
('General Surgeon', 12, 30);


-- 7. Inserting data into p_ContactInfo Table 
INSERT INTO p_ContactInfo (P_ID, P_ContactInfo) VALUES
(1, '96879000001'),
(2, '96879000002'),
(3, '96879000003'),
(4, '96879000004'),
(5, '96879000005'),
(6, '96879000006'),
(7, '96879000007'),
(8, '96879000008'),
(9, '96879000009'),
(10, '96879000010'),
(11, '96879000011'),
(12, '96879000012'),
(13, '96879000013'),
(14, '96879000014'),
(15, '96879000015'),
(16, '96879000016'),
(17, '96879000017'),
(18, '96879000018'),
(19, '96879000019'),
(20, '96879000020');


-- 8. Inserting data into Users Table (20 values)
INSERT INTO Users (Username, S_ID, Password) VALUES
('salim.r', 7, 'psw'),
('fatma.f', 8, 'psw'),
('aisha.h', 9, 'psw'),
('khalid.a', 10, 'psw'),
('hamed.h', 11, 'psw'),
('sara.b', 12, 'psw'),
('ali.q', 13, 'psw'),
('maryam.h', 14, 'psw'),
('ahmed.a', 15, 'psw'),
('noor.z', 16, 'psw'),
('yousef.m', 17, 'psw'),
('layla.w', 18, 'psw'),
('sultan.b', 19, 'psw'),
('nadia.s', 20, 'psw'),
('omar.k', 21, 'psw'),
('hind.m', 22, 'psw'),
('abd.s', 23, 'psw'),
('moh.h', 24, 'psw'),
('mona.g', 25, 'psw'),
('amani.r', 26, 'psw');


-- 9. Inserting data into Admissions Table (20 values)
--select * from Rooms
INSERT INTO Admissions (AdmID, P_ID, Room_ID, DateIN, DateOut) VALUES
(101, 1, 6, '2023-01-05', '2023-01-10'),
(102, 2, 7, '2023-01-07', '2023-01-12'),
(103, 3, 8, '2023-01-08', '2023-01-15'),
(104, 4, 9, '2023-01-10', '2023-01-11'),
(105, 5, 10, '2023-01-12', '2023-01-14'),
(106, 6, 11, '2023-01-15', '2023-01-18'),
(107, 7, 12, '2023-01-16', '2023-01-20'),
(108, 8, 13, '2023-01-18', '2023-01-25'),
(109, 9, 14, '2023-01-20', '2023-01-22'),
(110, 10, 15, '2023-01-22', '2023-01-23'),
(111, 11, 16, '2023-02-01', '2023-02-05'),
(112, 12, 17, '2023-02-03', '2023-02-08'),
(113, 13, 18, '2023-02-05', '2023-02-12'),
(114, 14, 19, '2023-02-07', '2023-02-09'),
(115, 15, 20, '2023-02-10', '2023-02-13'),
(116, 16, 3, '2023-02-12', '2023-02-16'),
(117, 17, 2, '2023-02-14', '2023-02-20'),
(118, 18, 1, '2023-02-16', '2023-02-17'),
(119, 19, 6, '2023-02-18', '2023-02-22'),
(120, 20, 7, '2023-02-20', '2023-02-25');

Select * from Staff

-- 10. Inserting data into MedicalRecords Table (20 values)
INSERT INTO MedicalRecords (Record_ID, P_ID, s_ID, Dep_ID, Diagnosis, Record_Notes, RecordDate, Treatment_Plans) VALUES
(2001, 1, 7, 1, 'Hypertension', 'Started ACE inhibitor. Monitor blood pressure daily.', '2023-03-01 09:30:00', 'Medication adjustment, lifestyle changes.'),
(2002, 2, 9, 2, 'Viral Gastroenteritis', 'Prescribed oral rehydration solution. Advised light diet.', '2023-03-02 11:00:00', 'Symptomatic treatment, hydration.'),
(2003, 3, 11, 3, 'Fractured Tibia', 'Cast applied. Follow-up in 4 weeks.', '2023-03-03 14:15:00', 'Immobilization, pain management.'),
(2004, 4, 12, 6, 'Eczema Flare-up', 'Topical corticosteroids prescribed. Avoid irritants.', '2023-03-04 10:45:00', 'Topical treatment, skin care advice.'),
(2005, 5, 13, 4, 'Migraine', 'Prescribed triptan. Advised to avoid triggers.', '2023-03-05 16:00:00', 'Acute migraine treatment, prevention strategies.'),
(2006, 6, 14, 7, 'Breast Cancer (Stage II)', 'Chemotherapy cycle 1 initiated. Monitor for side effects.', '2023-03-06 08:30:00', 'Chemotherapy, surgical consultation.'),
(2007, 7, 29, 9, 'Acute Appendicitis', 'Prepared for emergency appendectomy.', '2023-03-07 19:00:00', 'Surgical intervention.'),
(2008, 8, 15, 5, 'Pneumonia', 'Chest X-ray confirmed pneumonia. Started antibiotics.', '2023-03-08 12:00:00', 'Antibiotic therapy, respiratory support.'),
(2009, 9, 15, 8, 'Urinary Tract Infection', 'Urine culture positive for E. coli. Prescribed Ciprofloxacin.', '2023-03-09 10:10:00', 'Antibiotic treatment.'),
(2010, 10, 17, 9, 'Diabetes Mellitus Type 2', 'Started Metformin. Dietary counseling.', '2023-03-10 11:30:00', 'Medication, diet control.'),
(2011, 11, 19, 13, 'Coronary Artery Disease', 'Angiogram scheduled. Advised statin therapy.', '2023-03-11 09:00:00', 'Medication, diagnostic procedures.'),
(2012, 12, 21, 1, 'Bronchiolitis', 'Oxygen therapy. Monitored respiratory status.', '2023-03-12 13:00:00', 'Supportive care, hydration.'),
(2013, 13, 22, 2, 'Spinal Stenosis', 'Pain management and physiotherapy referral.', '2023-03-13 15:00:00', 'Pain relief, physical therapy.'),
(2014, 14, 23, 3, 'Psoriasis', 'UVB phototherapy started. Topical treatments continued.', '2023-03-14 10:00:00', 'Phototherapy, topical medication.'),
(2015, 15, 24, 4, 'Epilepsy', 'Adjusted antiepileptic medication dosage. Monitor for seizures.', '2023-03-15 14:30:00', 'Medication management.'),
(2016, 16, 25, 5, 'Colon Cancer', 'Referred for surgical resection.', '2023-03-16 09:45:00', 'Surgical treatment.'),
(2017, 17, 26, 6, 'Motor Vehicle Accident Injuries', 'Stabilized and transferred to ICU.', '2023-03-17 21:00:00', 'Emergency stabilization, critical care.'),
(2018, 18, 27, 7, 'Thyroid Nodule', 'Ultrasound and fine-needle aspiration performed.', '2023-03-18 11:15:00', 'Diagnostic workup.'),
(2019, 19, 28, 8, 'Anemia', 'Blood tests confirmed iron deficiency. Iron supplements prescribed.', '2023-03-19 09:30:00', 'Iron supplementation, dietary advice.'),
(2020, 20, 30, 12, 'Cholecystitis', 'Scheduled for laparoscopic cholecystectomy.', '2023-03-20 16:30:00', 'Surgical consultation.');


-- 11. Inserting data into Biling Table (20 values)
INSERT INTO Biling (Biling_ID, P_ID, B_Services, Total_Cost, PaymentDate, PaymentMethod) VALUES
(3001, 1, 'Consultation, Lab Tests, Medication', 150.75, '2023-03-01 10:00:00', 'Credit Card'),
(3002, 2, 'Consultation, Medication', 80.00, '2023-03-02 11:30:00', 'Cash'),
(3003, 3, 'Consultation, X-ray, Cast Application', 500.50, '2023-03-03 14:45:00', 'Insurance'),
(3004, 4, 'Consultation, Topical Cream', 75.20, '2023-03-04 11:00:00', 'Debit Card'),
(3005, 5, 'Consultation, Medication', 95.00, '2023-03-05 16:30:00', 'Cash'),
(3006, 6, 'Chemotherapy Session', 2500.00, '2023-03-06 09:00:00', 'Bank Transfer'),
(3007, 7, 'Emergency Visit, Surgery', 3500.00, '2023-03-07 20:00:00', 'Insurance'),
(3008, 8, 'Consultation, X-ray, Medication', 320.00, '2023-03-08 12:30:00', 'Credit Card'),
(3009, 9, 'Consultation, Lab Tests, Medication', 180.50, '2023-03-09 10:30:00', 'Debit Card'),
(3010, 10, 'Consultation, Lab Tests, Medication', 210.00, '2023-03-10 12:00:00', 'Cash'),
(3011, 11, 'Consultation, Lab Tests', 120.00, '2023-03-11 09:30:00', 'Credit Card'),
(3012, 12, 'Consultation, Oxygen Therapy', 90.00, '2023-03-12 13:30:00', 'Cash'),
(3013, 13, 'Consultation, Physiotherapy', 110.00, '2023-03-13 15:30:00', 'Insurance'),
(3014, 14, 'Consultation, Phototherapy', 130.00, '2023-03-14 10:30:00', 'Debit Card'),
(3015, 15, 'Consultation, Medication Adjustment', 85.00, '2023-03-15 15:00:00', 'Cash'),
(3016, 16, 'Surgical Consultation', 150.00, '2023-03-16 10:15:00', 'Bank Transfer'),
(3017, 17, 'Emergency Resuscitation', 4000.00, '2023-03-17 22:00:00', 'Insurance'),
(3018, 18, 'Consultation, Ultrasound', 280.00, '2023-03-18 11:45:00', 'Credit Card'),
(3019, 19, 'Consultation, Lab Tests, Supplements', 100.00, '2023-03-19 09:30:00', 'Debit Card'),
(3020, 20, 'Surgical Consultation', 160.00, '2023-03-20 17:00:00', 'Cash');


-- 12. Inserting data into Patient_Medicine Table (20 values)
INSERT INTO Patient_Medicine (P_ID, MedID, QuantityGiven, DateGiven) VALUES
(1, 1, 2, '2023-03-01 10:00:00'),
(2, 6, 1, '2023-03-02 11:30:00'),
(3, 3, 2, '2023-03-03 14:45:00'),
(4, 12, 1, '2023-03-04 11:00:00'),
(5, 5, 1, '2023-03-05 16:30:00'),
(6, 17, 1, '2023-03-06 09:00:00'),
(7, 18, 2, '2023-03-07 20:00:00'),
(8, 2, 2, '2023-03-08 12:30:00'),
(9, 18, 1, '2023-03-09 10:30:00'),
(10, 7, 1, '2023-03-10 12:00:00'),
(11, 8, 1, '2023-03-11 09:30:00'),
(12, 6, 1, '2023-03-12 13:30:00'),
(13, 3, 1, '2023-03-13 15:30:00'),
(14, 12, 1, '2023-03-14 10:30:00'),
(15, 5, 1, '2023-03-15 15:00:00'),
(16, 17, 1, '2023-03-16 10:15:00'),
(17, 18, 2, '2023-03-17 22:00:00'),
(18, 2, 1, '2023-03-18 11:45:00'),
(19, 1, 2, '2023-03-19 09:30:00'),
(20, 1, 1, '2023-03-20 17:00:00');


-- 13. Inserting data into Patient_Doctor_Treats Table (20 values)
--Select * from Doctors

INSERT INTO Patient_Doctor_Treats (P_ID, S_ID, Dep_ID) VALUES
(1, 7, 1),
(2, 9, 2),
(3, 11, 3),
(4, 12, 6),
(5, 13, 4),
(6, 14, 7),
(7, 15, 5),
(8, 15, 8),
(9, 17, 9),
(10, 19, 13),
(11, 21, 1),
(12, 22, 2),
(13, 23, 3),
(14, 24, 4),
(15, 25, 5),
(16, 26, 6),
(17, 27, 7),
(18, 28, 8),
(19, 29, 9),
(20, 30, 12);


-- 14. Inserting data into Patient_Doctor_Appointments Table (20 values)
--select * from Doctors

INSERT INTO Patient_Doctor_Appointments (P_ID, S_ID, Dep_ID, AppointmentDate, AppointmentTime, Status, AppointmentType) VALUES
(1, 7, 1, '2024-07-01', '10:00:00', 'Scheduled', 'Follow-up'),
(2, 9, 2, '2024-07-02', '11:00:00', 'Scheduled', 'New Consultation'),
(3, 11, 3, '2024-07-03', '14:00:00', 'Completed', 'Follow-up'),
(4, 12, 6, '2024-07-04', '09:30:00', 'Scheduled', 'Follow-up'),
(5, 13, 4, '2024-07-05', '15:00:00', 'Cancelled', 'New Consultation'),
(6, 14, 7, '2024-07-08', '08:00:00', 'Scheduled', 'Chemotherapy Review'),
(7, 15, 5, '2024-07-09', '18:00:00', 'Completed', 'Emergency Follow-up'),
(8, 15, 8, '2024-07-10', '10:30:00', 'Scheduled', 'New Consultation'),
(9, 17, 9, '2024-07-11', '11:00:00', 'Completed', 'Follow-up'),
(10, 19, 13, '2024-07-12', '13:00:00', 'Scheduled', 'Diet Consultation'),
(11, 21, 1, '2024-07-15', '09:00:00', 'Scheduled', 'Diagnostic Review'),
(12, 22, 2, '2024-07-16', '12:00:00', 'Scheduled', 'Check-up'),
(13, 23, 3, '2024-07-17', '14:30:00', 'Completed', 'Physiotherapy Referral'),
(14, 24, 4, '2024-07-18', '09:00:00', 'Rescheduled', 'Phototherapy Session'),
(15, 25, 5, '2024-07-19', '16:00:00', 'Scheduled', 'Medication Review'),
(16, 26, 6, '2024-07-22', '08:30:00', 'Scheduled', 'Surgical Consultation'),
(17, 27, 7, '2024-07-23', '20:00:00', 'Completed', 'Post-Op Check'),
(18, 28, 8, '2024-07-24', '11:00:00', 'Scheduled', 'Imaging Review'),
(19, 29, 9, '2024-07-25', '09:30:00', 'Completed', 'Lab Results Review'),
(20, 30, 12, '2024-07-26', '15:00:00', 'Scheduled', 'Pre-Op Consultation');


-- 15. Inserting data into Staff_Department_NursingCare Table (20 values)

INSERT INTO Staff_Department_NursingCare (S_ID, Dep_ID) VALUES
(7, 2), -- Nurse Fatma in Pediatrics
(8, 6), -- Nurse Sara in Oncology
(9, 8), -- Radiology Technician Maryam in Radiology
(10, 10), -- Pharmacist Noor in Pharmacy
(11, 11), -- Physio Yousef in Physiotherapy
(13, 13), -- Nurse Sultan in Internal Medicine
(16, 16), -- Nurse Hind in Urology
(18, 18), -- Nurse Mohammed in Anesthesiology
(20, 20), -- Dietitian Amani in Nutrition and Dietetics
(7, 1), -- Dr. Salim in Cardiology (can be assigned to a department for care oversight)
(9, 3), -- Dr. Aisha in Orthopedics
(10, 4), -- Admin Khalid in Dermatology
(11, 5), -- Dr. Hamed in Neurology
(7, 7), -- Dr. Ali in Emergency
(9, 9), -- Dr. Ahmed in Pathology
(12, 12), -- Dr. Layla in General Surgery
(14, 14), -- Dr. Nadia in Ophthalmology
(15, 15), -- Dr. Omar in ENT
(17, 17), -- Dr. Abdullah in Gastroenterology
(19, 19); -- Dr. Mona in Psychiatry

--Select * from SystemCore.Staff

INSERT INTO SystemCore.Staff_Shift(S_ID, ShiftName, StartTime, EndTime) VALUES
(7, 'Morning', '07:00:00', '15:00:00'),
(10, 'Evening', '15:00:00', '23:00:00'),
(11, 'Night', '23:00:00', '07:00:00'), 
(12, 'Morning', '07:00:00', '15:00:00'),
(8, 'Evening', '15:00:00', '23:00:00'),
(7, 'Night', '23:00:00', '07:00:00'), 
(13, 'Morning', '07:00:00', '15:00:00'),
(14, 'Evening', '15:00:00', '23:00:00'),
(10, 'Night', '23:00:00', '07:00:00'), 
(15, 'Morning', '07:00:00', '15:00:00'),
(16, 'Evening', '15:00:00', '23:00:00'),
(13, 'Night', '23:00:00', '07:00:00');

-- inseration satement to Billing_Services table 
INSERT INTO PatientServices.Billing_Services (B_Services, Biling_ID, P_ID) VALUES
('Consultation', 3001, 1),
('Lab Tests', 3001, 1),
('Medication', 3001, 1),
('Consultation', 3002, 2),
('Medication', 3002, 2),
('X-ray', 3003, 3),
('Cast Application', 3003, 3),
('Topical Cream', 3004, 4),
('Consultation', 3005, 5),
('Chemotherapy Session', 3006, 6),
('Emergency Visit', 3007, 7),
('Surgery', 3007, 7),
('Consultation', 3008, 8),
('X-ray', 3008, 8),
('Lab Tests', 3009, 9),
('Consultation', 3010, 10),
('Oxygen Therapy', 3012, 12),
('Physiotherapy', 3013, 13),
('Phototherapy', 3014, 14),
('Surgical Consultation', 3020, 20);
