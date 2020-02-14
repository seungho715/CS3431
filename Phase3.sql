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

/* Part 3 - Populate The Database */

/* Employee */
INSERT INTO Employee VALUES(10000,'Vicky','Luu','Regular Employee','10000.00','1000','0',10010);
INSERT INTO Employee VALUES(10001,'Gerald','Saranghae','Regular Employee','10001.00','1001','0',10010);
INSERT INTO Employee VALUES(10002,'Takeshi','Gonnichiwa','Regular Employee','10002.00','1002','0',10010);
INSERT INTO Employee VALUES(10003,'Heimer','Hajimemashite','Regular Employee','10003.00','1003','0',10010);
INSERT INTO Employee VALUES(10004,'Garen','Gimoti','Regular Employee','10004.00','1004','0',10011);
INSERT INTO Employee VALUES(10005,'Aatrox','Moe','Regular Employee','10005.00','1005','0',10011);
INSERT INTO Employee VALUES(10006,'Teemo','Sakura','Regular Employee','10006.00','1060','0',10011);
INSERT INTO Employee VALUES(10007,'Lulu','Calendar','Regular Employee','10070.00','1007','0',10012);
INSERT INTO Employee VALUES(10008,'Poppy','Lunar','Regular Employee','10008.00','1008','0',10012);
INSERT INTO Employee VALUES(10009,'Sylas','Shift','Regular Employee','10090.00','1009','0',10013);

INSERT INTO Employee VALUES(10010,'Zed','Static','Divison Employee','11000.00','2000','1',10014);
INSERT INTO Employee VALUES(10011,'Ahri','Edge','Divison Employee','12000.00','2001','1',10014);
INSERT INTO Employee VALUES(10012,'Riven','Infinity','Division Employee','13000.00','2002','1',10015);
INSERT INTO Employee VALUES(10013,'Darius','Void','Division Employee','13300.00','2003','1',10015);

INSERT INTO Employee(EmployeeID,FirstName,LastName,JobTitle,Salary,OfficeNumber,EmployeePosition,SupervisorID) VALUES(10014,'Draven','Demacia','General Employee','20000.00','2004','2', '');
INSERT INTO Employee(EmployeeID,FirstName,LastName,JobTitle,Salary,OfficeNumber,EmployeePosition,SupervisorID) VALUES(10015,'Sett','Tess','General Employee','99999.99','2005','2', '');


/* Doctors */
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('100','Jessica','Nguyen','Leg','F');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('101','Bhanuj','Wrong','Arm','M');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('102','Jeffery','Rong','Head','M');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('103','Jeffrey','Lung','Chest','M');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('104','Janice','Kang','Genitals','F');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('105','Andy','Li','Back','M');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('106','Austin','Texas','Lungs','M');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('107','Aurthr','King','Prostate','M');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('108','Patrick','Star','Wrist','F');
INSERT INTO Doctor(DoctorID,FirstName,LastName,Specialty,Gender) VALUES('109','Spongebob','Squarepants','Throat','F');

/* Rooms */
INSERT INTO Room VALUES(1000,'T');
INSERT INTO Room VALUES(1001,'F');
INSERT INTO Room VALUES(1002,'F');
INSERT INTO Room VALUES(1003,'F');
INSERT INTO Room VALUES(1004,'T');
INSERT INTO Room VALUES(1005,'F');
INSERT INTO Room VALUES(1006,'F');
INSERT INTO Room VALUES(1007,'T');
INSERT INTO Room VALUES(1008,'F');
INSERT INTO Room VALUES(1009,'T');

/* Room Service */
INSERT INTO RoomServices VALUES(1001,'MRI');
INSERT INTO RoomServices VALUES(1003,'MRI');
INSERT INTO RoomServices VALUES(1002,'Surgery');
INSERT INTO RoomServices VALUES(1004,'Surgery');
INSERT INTO RoomServices VALUES(1005,'X-ray');
INSERT INTO RoomServices VALUES(1006,'X-ray');

/* Room Access */
INSERT INTO RoomAccess VALUES(1000,10000);
INSERT INTO RoomAccess VALUES(1001,10001);
INSERT INTO RoomAccess VALUES(1002,10002);


/* Equipment Type */
INSERT INTO EquipmentType VALUES('10','Precision Knife','Use to make precision cuts.','A01', 1);
INSERT INTO EquipmentType VALUES('11','Latex Gloves','Use to put on hands','A02', 2);
INSERT INTO EquipmentType VALUES('12','Surgical Scissors','Use to cut body parts.','A03', 5);

/* Equipment */
INSERT INTO Equipment VALUES('A01-02X',TO_DATE('2010/10/29 18:06:34', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2005', 'yyyy'),10, 1000);
INSERT INTO Equipment VALUES('A01-03X',TO_DATE('2010/10/30 21:04:34', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010', 'yyyy'),10, 1001);
INSERT INTO Equipment VALUES('A01-04X',TO_DATE('2010/11/09 20:04:34', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2003', 'yyyy'),10, 1002);
INSERT INTO Equipment VALUES('A01-05X',TO_DATE('2015/10/31 08:04:34', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2011', 'yyyy'),11, 1003);
INSERT INTO Equipment VALUES('A01-06X',TO_DATE('2010/11/30 18:34:34', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010', 'yyyy'),11, 1004);
INSERT INTO Equipment VALUES('A01-07X',TO_DATE('2017/12/29 18:04:44', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2011', 'yyyy'),11, 1005);
INSERT INTO Equipment VALUES('A01-08X',TO_DATE('2009/10/29 18:04:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2004', 'yyyy'),12, 1006);
INSERT INTO Equipment VALUES('A01-09X',TO_DATE('2008/11/29 18:05:34', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2002', 'yyyy'),12, 1007);
INSERT INTO Equipment VALUES('A01-10X',TO_DATE('2008/10/30 19:04:34', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2001', 'yyyy'),12, 1008);

/* Patients with Admission*/
INSERT INTO Patient VALUES('111-22-3333','Ken','Snoddy','100 Institute Road','(123)-456-7890');
INSERT INTO Patient VALUES('123-45-6789','Chris','Lee','101 Institute Road','(111)-111-1111');
INSERT INTO Patient VALUES('234-56-7890','Luna','Kim','102 Institute Road','(222)-222-2222');
INSERT INTO Patient VALUES('857-21-6666','Trang','Park','103 Institute Road','(333)-333-3333');

INSERT INTO Patient VALUES('111-11-1111','Jackson','Sakura','104 Institute Road','(444)-444-4444');
INSERT INTO Admission VALUES(1,TO_DATE('2010/10/29 19:05:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 19:25:25', 'yyyy/mm/dd hh24:mi:ss'),2500,1500,TO_DATE('2011/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'111-11-1111');
INSERT INTO Admission VALUES(2,TO_DATE('2010/10/29 19:15:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:25:25', 'yyyy/mm/dd hh24:mi:ss'),2501,1509,TO_DATE('2012/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'111-11-1111');
INSERT INTO Examines VALUES(100,1,'Sprained Ankle');
INSERT INTO Examines VALUES(101,2,'Pneumonia');
INSERT INTO StaysIn VALUES (1,1000,TO_DATE('2010/10/29 19:05:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 19:25:25', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO StaysIn VALUES (2,1001,TO_DATE('2010/10/29 19:15:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:25:25', 'yyyy/mm/dd hh24:mi:ss'));


INSERT INTO Patient VALUES('222-22-2222','Aaron','Yamamoto','105 Institute Road','(555)-555-5555');
INSERT INTO Admission VALUES(3,TO_DATE('2010/10/29 19:25:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:25:25', 'yyyy/mm/dd hh24:mi:ss'),2502,1508,TO_DATE('2013/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'222-22-2222');
INSERT INTO Admission VALUES(4,TO_DATE('2010/10/29 19:35:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:25:25', 'yyyy/mm/dd hh24:mi:ss'),2503,1507,TO_DATE('2014/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'222-22-2222');
INSERT INTO Examines VALUES(102,3,'Chest Pain');
INSERT INTO Examines VALUES(103,4,'Lung Cancer');
INSERT INTO StaysIn VALUES (3,1002,TO_DATE('2010/10/29 19:25:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:25:25', 'yyyy/mm/dd hh24:mi:ss'));
INSERT INTO StaysIn VALUES (4,1003,TO_DATE('2010/10/29 19:35:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:25:25', 'yyyy/mm/dd hh24:mi:ss'));

INSERT INTO Patient VALUES('333-33-3333','Thomas','Phan','106 Institute Road','(666)-666-6666');
INSERT INTO Admission VALUES(5,TO_DATE('2010/10/29 19:45:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:15:25', 'yyyy/mm/dd hh24:mi:ss'),2504,1506,TO_DATE('2015/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'333-33-3333');
INSERT INTO Examines VALUES(104,5,'Testicular Cancer');
INSERT INTO StaysIn VALUES (5,1004,TO_DATE('2010/10/29 19:45:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:15:25', 'yyyy/mm/dd hh24:mi:ss'));

INSERT INTO Patient VALUES('444-44-4444','Phillip','Park','107 Institute Road','(857)-210-5031');
INSERT INTO Admission VALUES(7,TO_DATE('2010/10/29 20:05:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 21:25:25', 'yyyy/mm/dd hh24:mi:ss'),2506,1504,TO_DATE('2017/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'444-44-4444');
INSERT INTO Admission VALUES(6,TO_DATE('2010/10/29 19:55:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 20:55:25', 'yyyy/mm/dd hh24:mi:ss'),2505,1505,TO_DATE('2016/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'444-44-4444');

INSERT INTO Patient VALUES('555-55-5555','Michael','Sullivan','108 Institute Road','(010)-265-7123');
INSERT INTO Admission VALUES(8,TO_DATE('2010/10/29 20:15:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 21:25:45', 'yyyy/mm/dd hh24:mi:ss'),2507,1503,TO_DATE('2018/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'555-55-5555');

INSERT INTO Patient VALUES('666-66-6666','Max','Hunt','108 Institute Road','(000)-000-6666');
INSERT INTO Admission VALUES(9,TO_DATE('2010/10/29 20:25:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 21:05:25', 'yyyy/mm/dd hh24:mi:ss'),2508,1502,TO_DATE('2019/11/29 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'666-66-6666');
INSERT INTO Admission VALUES(10,TO_DATE('2010/10/29 21:35:35', 'yyyy/mm/dd hh24:mi:ss'),TO_DATE('2010/10/29 22:15:25', 'yyyy/mm/dd hh24:mi:ss'),2509,1501,TO_DATE('2019/11/30 19:00:00', 'yyyy/mm/dd hh24:mi:ss'),'666-66-6666');

