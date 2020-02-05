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

Create Table Employee(
	EmployeeID Integer NOT NULL Primary Key,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	JobTitle VARCHAR(30) NOT NULL,
	Salary Real NOT NULL,
	OfficeNumber CHAR(10) NOT NULL Unique,
	EmployeePosition Integer NOT NULL,
	SupervisorID Integer,
	Constraint CheckEmployeePosition Check(EmployeePosition = 0 OR EmployeePosition = 1 OR EmployeePosition =2));

Create Table Room(
	RoomNumber Integer NOT NULL Primary Key,
	Occupied CHAR(1) NOT NULL,
	Constraint CheckOccupied Check(Occupied = 0 OR Occupied = 1));

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

Create Table Patient(
	SSN CHAR(9) NOT NULL Primary Key,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Address VARCHAR(30) NOT NULL,
	TelephoneNumber VARCHAR(11) NOT NULL);

Create Table Equipment(
	SerialNumber VARCHAR(30) NOT NULL Primary Key,
	LastInspection Date, 
	YearofPurchase Date NOT NULL,
	TypeID VARCHAR(20) NOT NULL,
	RoomNumber Integer NOT NULL,
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
	FOREIGN KEY (TypeID) REFERENCES EquipmentType(TypeID),
	Constraint CheckEquipment Check(YearofPurchase <= LastInspection));

Create Table EquipmentType(
	TypeID CHAR(20) NOT NULL Primary Key,
	Description VARCHAR(30),
	OperationalInstruction VARCHAR(400),
	Model VARCHAR(20) NOT NULL);

Create Table Doctor(
	DoctorID Integer NOT NULL Primary Key,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Specialty VARCHAR(20) NOT NULL,
	Gender CHAR(1) NOT NULL,
	Constraint CheckGender Check(Gender = 'M' OR Gender = 'F'));

Create Table RoomServices(
	RoomNumber Integer NOT NULL,
	Services VARCHAR(30) NOT NULL,
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
	Constraint pkRoomServices Primary Key (RoomNumber, Services));

Create Table RoomAccess(
	RoomNumber Integer NOT NULL,
	EmployeeID Integer NOT NULL,
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber)
	FOREIGN KEY pkRoomAccess Primary Key (RoomNumber, EmployeeID));

Create Table Examines(
	DoctorID Integer NOT NULL,
	AdminID Integer NOT NULL,
	Result VARCHAR(300),
	FOREIGN KEY (DoctorID) REFERENCES Doctor(ID),
	FOREIGN KEY (AdminID) REFERENCES Admission(ID),
	Constraint pkExamines Primary Key (DoctorID, AdminID));

Create Table StaysIn(
	AdminID Integer NOT NULL,
	RoomNumber Integer NOT NULL,
	StartDate Date NOT NULL,
	EndDate Date NOT NULL,
	FOREIGN KEY (AdminID) REFERENCES Admission(ID),
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber),
	Constraint pkStaysIn Primary Key (AdminID, RoomNumber));