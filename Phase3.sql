/* Phase 2 - Group 10 - Ken Snoddy, Seungho Lee */

/* Drop All Tables */
Drop Table Employee Cascade Constraints;
Drop Table Room Cascade Constraints;
Drop Table Admission Cascade Constraints;
Drop Table Patient Cascade Constraints;
Drop Table Equipment Cascade Constraints;
Drop Table EquipmentType Cascade Constraints;
Drop Table Doctor Cascade Constraints;
Drop Table RoomServices Cascade Constraints;
Drop Table RoomAccess Cascade Constraints;
Drop Table Examines Cascade Constraints;
Drop Table StaysIn Cascade Constraints;


/* Part 1 - Create The Database */

/* Employee */
Create Table Employee(
	EmployeeID Integer NOT NULL Primary Key,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	JobTitle VARCHAR(30) NOT NULL,
	Salary Real NOT NULL,
	OfficeNumber CHAR(20) NOT NULL Unique,
	EmployeePosition Integer NOT NULL,
	SupervisorID Integer,
	Constraint CheckEmployeePosition Check(EmployeePosition = 0 OR EmployeePosition = 1 OR EmployeePosition = 2));

/* Equipment Type */ 
Create Table EquipmentType(
	TypeID CHAR(20) NOT NULL Primary Key,
	Description VARCHAR(30),
	OperationalInstructions VARCHAR(400),
	Model VARCHAR(20) NOT NULL,
	NumberofUnits Integer NOT NULL);

/* Room */
Create Table Room(
	RoomNumber Integer NOT NULL Primary Key,
	Occupied CHAR(1) DEFAULT 'F');

/* Equipment */
Create Table Equipment(
	SerialNumber VARCHAR(30) NOT NULL Primary Key,
	LastInspection Date, 
	YearofPurchase Date NOT NULL,
	EquipmentTypeID CHAR(20) NOT NULL,
	RoomNumber Integer NOT NULL,
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
	FOREIGN KEY (EquipmentTypeID) REFERENCES EquipmentType(TypeID),
	Constraint CheckEquipment Check(YearofPurchase <= LastInspection));

/* Patient */
Create Table Patient(
	SSN CHAR(11) NOT NULL Primary Key,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Address VARCHAR(30) NOT NULL,
	TelephoneNumber VARCHAR(14) NOT NULL);

/* Admission */
Create Table Admission(
	AdminID Integer NOT NULL Primary Key,
	AdminDate Date NOT NULL,
	LeaveDate Date NOT NULL,
	TotalPayment Real NOT NULL,
	InsurancePayment Real NOT NULL,
	FutureDate Date NOT NULL,
	PatientSSN CHAR(11) NOT NULL,
	FOREIGN KEY (PatientSSN) REFERENCES Patient(SSN),
	Constraint CheckAdmission Check(AdminDate <= LeaveDate),
	Constraint CheckFuture Check(LeaveDate < FutureDate),
	Constraint CheckPayment Check(InsurancePayment <= TotalPayment));

/* Doctor */
Create Table Doctor(
	DoctorID Integer NOT NULL Primary Key,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Specialty VARCHAR(20) NOT NULL,
	Gender CHAR(1) NOT NULL,
	Constraint CheckGender Check(Gender = 'M' OR Gender = 'F'));

/* Room Services */
Create Table RoomServices(
	RoomNumber Integer NOT NULL,
	Services VARCHAR(30) NOT NULL,
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
	Constraint pkRoomServices Primary Key (RoomNumber, Services));

/* Room Access */
Create Table RoomAccess(
	RoomNumber Integer NOT NULL,
	EmployeeEmployeeID Integer NOT NULL,
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
	FOREIGN KEY (EmployeeEmployeeID) REFERENCES Employee(EmployeeID),	
	Constraint pkRoomAccess Primary Key (RoomNumber, EmployeeEmployeeID));

/* Examines */
Create Table Examines(
	DoctorID Integer NOT NULL,
	AdmissionAdminID Integer NOT NULL,
	Result VARCHAR(300),
	Constraint pkExamines Primary Key (DoctorID, AdmissionAdminID),
	FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
	FOREIGN KEY (AdmissionAdminID) REFERENCES Admission(AdminID));

/* Stays In */
Create Table StaysIn(
	AdmissionAdminID Integer NOT NULL,
	RoomNumber Integer NOT NULL,
	StartDate Date NOT NULL,
	EndDate Date NOT NULL,
	Constraint pkStaysIn Primary Key (AdmissionAdminID, RoomNumber, StartDate),
	FOREIGN KEY (AdmissionAdminID) REFERENCES Admission(AdminID),
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber));

/* Phase 3 - Group 10 - Ken Snoddy, Seungho Lee */

/* Drop Views and Triggers */
DROP VIEW CriticalCases;
DROP VIEW DoctorsLoad;

/* Part 1 - Database Views */
GO

CREATE VIEW CriticalCases AS 
    Select SSN AS PatientSSN, FirstName, LastName, numberOfAdmissionsToICU 
    From Patient NATURAL JOIN ( 
        Select PatientSSN AS SSN, Count(*) AS numberOfAdmissionsToICU 
        From Admission NATURAL JOIN ( 
            Select AdminID AS ANum  
            From StaysIn NATURAL JOIN ( 
                Select RoomNumber 
                From RoomServices 
                Where Service = 'ICU')) 
        Group By PatientSSN) 
    Where numberOfAdmissionsToICU >= 2;

GO

CREATE VIEW DoctorsLoad AS    
    Select ID as DoctorID, Gender, 'Overloaded' AS load
    From Doctor NATURAL JOIN(
        Select DoctorID AS ID, Count(AdminID) AS LoadNum
        From Examines
        Group By DoctorID)
    Where Loadnum > 10
    Union
        (Select ID as DoctorID, Gender, 'Underloaded' AS load
        From Doctor NATURAL JOIN(
            Select DoctorID AS ID, Count(AdmissionNum) AS LoadNum
            From Examines
            Group By DoctorID)
        Where Loadnum <= 10);

GO

Select *
From CriticalCases
Where numberOfAdmissionsToICU > 4;

Select DoctorID, FirstName, LastName
From Doctor D, DoctorsLoad L
Where D.ID = L.DoctorID
    AND
    D.Gender = 'F'
    AND
    L.load = 'Overloaded';

Select D.DoctorID, C.PatientSSN, Results
From CriticalCases C, Admission A, Examine E, DoctorsLoad D
Where C.PatientSSN = A.PatientSSN
    AND
    A.ANum = E.AdminID
    AND
    E.DoctorID = D.DoctorID
    AND
    D.load = 'Underloaded';

/* Part 2 - Databases Triggers */
