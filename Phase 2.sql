/* Phase 2 - Group 10 - Ken Snoddy, Seungho Lee */

/* Drop All Tables */
Drop Table Employee
Drop Table Room
Drop Table Admission
Drop Table Patient
Drop Table Equipment
Drop Table EquipmentType
Drop Table Doctor
Drop Table RoomServices
Drop Table Examines
Drop Table StaysIn
Drop Table RoomAccess

/* Part 1 - Create The Database */

/* Employee */
Create Table Employee(
	EmployeeID Integer NOT NULL Primary Key,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	JobTitle VARCHAR(30) NOT NULL,
	Salary Real NOT NULL,
	OfficeNumber CHAR(10) NOT NULL Unique,
	EmployeePosition Integer NOT NULL,
	SupervisorID Integer,
	Constraint CheckEmployeePosition Check(EmployeePosition = 0 OR EmployeePosition = 1 OR EmployeePosition = 2));

/* Room */
Create Table Room(
	RoomNumber Integer NOT NULL Primary Key,
	Occupied CHAR(1) NOT NULL,
	Constraint CheckOccupied Check(Occupied = 0 OR Occupied = 1));

/* Admission */
Create Table Admission(
	AdminID Integer NOT NULL Primary Key,
	AdminDate Date NOT NULL,
	LeaveDate Date NOT NULL,
	TotalPayment Real NOT NULL,
	InsurancePayment Real NOT NULL,
	FutureDate Date NOT NULL,
	PatientSSN CHAR(9) NOT NULL,
	FOREIGN KEY (PatientSSN) REFERENCES Patient(SSN),
	Constraint CheckAdmission Check(AdminDate <= LeaveDate),
	Constraint CheckFuture Check(LeaveDate < FutureDate),
	Constraint CheckPayment Check(InsurancePayment <= TotalPayment));

/* Patient */
Create Table Patient(
	SSN CHAR(9) NOT NULL Primary Key,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Address VARCHAR(30) NOT NULL,
	TelephoneNumber VARCHAR(11) NOT NULL);

/* Equipment */
Create Table Equipment(
	SerialNumber VARCHAR(30) NOT NULL Primary Key,
	LastInspection Date, 
	YearofPurchase Date NOT NULL,
	TypeID VARCHAR(20) NOT NULL,
	RoomNumber Integer NOT NULL,
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
	FOREIGN KEY (TypeID) REFERENCES EquipmentType(TypeID),
	Constraint CheckEquipment Check(YearofPurchase <= LastInspection));

/* Equipment Type */ 
Create Table EquipmentType(
	TypeID CHAR(20) NOT NULL Primary Key,
	Description VARCHAR(30),
	OperationalInstructions VARCHAR(400),
	Model VARCHAR(20) NOT NULL);

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
	EmployeeID Integer NOT NULL,
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber)
	FOREIGN KEY pkRoomAccess Primary Key (RoomNumber, EmployeeID));

/* Examines */
Create Table Examines(
	DoctorID Integer NOT NULL,
	AdminID Integer NOT NULL,
	Result VARCHAR(300),
	FOREIGN KEY (DoctorID) REFERENCES Doctor(ID),
	FOREIGN KEY (AdminID) REFERENCES Admission(ID),
	Constraint pkExamines Primary Key (DoctorID, AdminID));

/* Stays In */
Create Table StaysIn(
	AdminID Integer NOT NULL,
	RoomNumber Integer NOT NULL,
	StartDate Date NOT NULL,
	EndDate Date NOT NULL,
	FOREIGN KEY (AdminID) REFERENCES Admission(ID),
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
	Constraint pkStaysIn Primary Key (AdminID, RoomNumber, StartDate));


/* Part 3 - Populate The Database */

/* Patients */
INSERT INTO Patient(SSN,FirstName,LastName,Address,TelephoneNumber) VALUES('012-34-5678','Ken','Snoddy','100 Institute Road','(123)-456-7890');

/* Doctors */
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('100','Jessica','Nguyen','General','F');

/* Rooms */
INSERT INTO Room(RoomNumber,Occupied) VALUES('1000','0');

/* Room Service */
INSERT INTO RoomServices(RoomNumber,Services) VALUES('1000','MRI');

/* Equipment Type */
INSERT INTO EquipmentType(TypeID,Description,OperationalInstructions,Model) VALUES('10','Precision Knife','Use to make precision cuts.','A01');

/* Equipment */
INSERT INTO Equipment(SerialNumber,LastInspection, YearofPurchase, TypeID, RoomNumber) VALUES('QRC100',TO_DATE('2010/10/29 18:04:34', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2000', 'yyyy'),10, 1000);

/* Admission */
INSERT INTO Admission(AdminID,AdminDate,LeaveDate,TotalPayment,InsurancePayment,FutureVisit,PatientSSN) VALUES('1',TO_DATE('2010/10/29 19:05:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 19:25:25', 'yyyy/mm/dd hh24:mi:ss'),'2500','1500',TO_DATE('2010/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'012-34-5678');

/* Employee */
INSERT INTO Employee(EmployeeID,FirstName,LastName,JobTitle,Salary,OfficeNumber,EmployeePosition,SupervisorID) VALUES('10000','Vicky','Luu','Regular Employee','10000.00','1000','0','20000');

/* Room Access */
INSERT INTO RoomAccess(RoomNumber,EmployeeID) VALUES('1000s','10000');

/* Examine */
INSERT INTO Examine(DoctorID,AdminID,Result) VALUES('100','1','Sprained Ankle');

/* Stays In */
INSERT INTO StayIn(AdminID,RoomNumber,StartDate,EndDate) VALUES ('1','1000',TO_DATE('2010/10/29 19:05:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 19:25:25', 'yyyy/mm/dd hh24:mi:ss'));


/* Part 2 - SQL Queries */

/* Q1 */

/* Q2 */
Select EmployeeID, FirstName, LastName, Salary 
From Employee 
Where SupervisorID = 10 
AND 
JobTitle = 'Regular Employee';

/* Q3 */

/* Q4 */
Select SSN, FirstName, LastName, Visits 
From Patient NATURAL JOIN (                        
    Select PatientSSN AS SSN, Count(*) AS Visits 
    From Admission 
    Group By PatientSSN)
Union
    (Select SSN, FirstName, LastName, 0 AS Visits  
    From Patient               
    Minus
        (Select SSN, FirstName, LastName, Visits  
        From Patient NATURAL JOIN (     
            Select PatientSSN AS SSN, 0 AS Visits 
            From Admission)));

/* Q5 */

/* Q6 */
Select EmployeeID, Max(Room)
From
    (Select EmployeeID, Count(RoomNumber) AS Room
    From RoomAccess
    Group By EmployeeID)
Group By EmployeeID;

/* Q7 */

/* Q8 */
Select SSN, FirstName, LastName, FutureVisit
From Patient NATURAL JOIN (
    Select PatientSSN as SSN, FutureVisit
    From Admission);

/* Q9 */

/* Q10 */
Select Max(FutureVisit)
From Admission
Where PatientSSN = '111-22-3333';

/* Q11 */

/* Q12 */
Select TypeID
From Equipment
Where PurchaseYear = TO_DATE('2010', 'yyyy')
Intersect
    (Select TypeID
    From Equipment
    Where PurchaseYear = TO_DATE('2011', 'yyyy'));


