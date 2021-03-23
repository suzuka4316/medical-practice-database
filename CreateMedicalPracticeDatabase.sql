	-----Creating MedicalPractice Database-----
	USE master
	CREATE DATABASE MedicalPractice
	GO

	USE MedicalPractice
	GO

	-----Creating Tables-----
	CREATE TABLE Patient (
		Patient_ID int PRIMARY KEY,
		Title nvarchar(20),
		FirstName nvarchar(50) NOT NULL,
		MiddleInitial nchar(1),
		LastName nvarchar(50) NOT NULL,
		HouseUnitLotNum nvarchar(5) NOT NULL,
		Street nvarchar(50) NOT NULL,
		Suburb nvarchar(50) NOT NULL,
		State nvarchar(3) NOT NULL,
		PostCode nchar(4) NOT NULL,
		HomePhone nchar(10),
		MobilePhone nchar(10),
		MedicareNumber nchar(16),
		DateOfBirth date NOT NULL,
		Gender nchar(20) NOT NULL,
	)
	GO

	CREATE TABLE PractitionerType (
		PractitionerType nvarchar(50) PRIMARY KEY
	)
	GO

	CREATE TABLE Practitioner (
		Practitioner_ID int PRIMARY KEY,
		MedicalRegistrationNumber nchar(11) UNIQUE NOT NULL,
		Title nvarchar(20),
		FirstName nvarchar(50) NOT NULL,
		MiddleInitial nchar(1),
		LastName nvarchar(50) NOT NULL,
		HouseUnitLotNum nvarchar(5) NOT NULL,
		Street nvarchar(50) NOT NULL,
		Suburb nvarchar(50) NOT NULL,
		State nvarchar(3) NOT NULL,
		PostCode nchar(4) NOT NULL,
		HomePhone nchar(8),
		MobilePhone nchar(8),
		MedicareNumber nchar(16),
		DateOfBirth date NOT NULL,
		Gender nchar(20) NOT NULL,
		PractitionerType_Ref nvarchar(50) FOREIGN KEY REFERENCES PractitionerType(PractitionerType) NOT NULL
	)
	GO

	CREATE TABLE WeekDays (
		WeekDayName nvarchar(9) PRIMARY KEY
	)
	GO

	CREATE TABLE Availability (
		WeekDayName_Ref nvarchar(9) FOREIGN KEY REFERENCES WeekDays(WeekDayName) NOT NULL,
		Practitioner_Ref int FOREIGN KEY REFERENCES Practitioner(Practitioner_ID) NOT NULL,
		CONSTRAINT PK_Availability PRIMARY KEY
		(
			WeekDayName_Ref,
			Practitioner_Ref
		)
	)
	GO

	CREATE TABLE Appointment (
		Practitioner_Ref int FOREIGN KEY REFERENCES Practitioner(Practitioner_ID) NOT NULL,
		AppDate date NOT NULL,
		AppStartTime time NOT NULL,
		Patient_Ref int FOREIGN KEY REFERENCES Patient(Patient_ID) NOT NULL,
		CONSTRAINT PK_Appointment PRIMARY KEY
		(
			Practitioner_Ref,
			AppDate,
			AppStartTime
		)
	)
	GO

	CREATE TABLE TestType (
		Test_Code nvarchar(20) PRIMARY KEY,
		TestName nvarchar(200) NOT NULL,
		Description nvarchar(500)
	)
	GO

	CREATE TABLE PathTestReqs (
		Practitioner_Ref int FOREIGN KEY REFERENCES Practitioner(Practitioner_ID) NOT NULL,
		DateOrdered date NOT NULL,
		TimeOrdered time NOT NULL,
		Patient_Ref int FOREIGN KEY REFERENCES Patient(Patient_ID) NOT NULL,
		Test_Ref nvarchar(20) FOREIGN KEY REFERENCES TestType(Test_Code) NOT NULL,
		CONSTRAINT PK_PathTestReqs PRIMARY KEY
		(
			Practitioner_Ref,
			DateOrdered,
			TimeOrdered
		)
	)
	GO

	ALTER TABLE Practitioner
	ALTER COLUMN	HomePhone nchar(10)
	GO

	ALTER TABLE Practitioner
	ALTER COLUMN	MobilePhone nchar(10)
	GO

	IF EXISTS (SELECT * FROM sysobjects WHERE name = 'FK__Appointme__Patie__35BCFE0A')
	BEGIN
		ALTER TABLE Appointment
		DROP CONSTRAINT FK__Appointme__Patie__35BCFE0A
	END

	SELECT * FROM sys.foreign_keys


	-----Populating Tables-----
	BULK INSERT Patient
	FROM 'D:\Certificate IV in Programming\Database\StudentFace\Skill Assessment 12_Nov\15_PatientData.csv'
	WITH
	(
		FIRSTROW = 1,
		FIELDTERMINATOR = ', ',
		ROWTERMINATOR = '\n',
		FIELDQUOTE = '''',
		FORMAT = 'CSV'
	)
	Select * From Patient

	BULK INSERT PractitionerType
	From 'D:\Certificate IV in Programming\Database\StudentFace\Skill Assessment 12_Nov\17_PractitionerTypeData.csv'
	WITH
	(
		FIRSTROW = 1,
		FIELDTERMINATOR = ', ',
		ROWTERMINATOR = '\n',
		FIELDQUOTE = '''',
		FORMAT = 'CSV'
	)
	Select * From PractitionerType


	BULK INSERT Practitioner
	FROM 'D:\Certificate IV in Programming\Database\StudentFace\Skill Assessment 12_Nov\16_PractitionerDataModified.csv'
	WITH
	(
		FORMAT = 'CSV',
		FIRSTROW = 1,
		FIELDQUOTE = '''',
		FIELDTERMINATOR = ', ',
		ROWTERMINATOR = '\n'
	)
	Select * From Practitioner


	BULK INSERT WeekDays
	FROM 'D:\Certificate IV in Programming\Database\StudentFace\Skill Assessment 12_Nov\19_WeekDaysData.csv'
	WITH
	(
		FORMAT = 'CSV',
		FIRSTROW = 1,
		FIELDQUOTE = '''',
		FIELDTERMINATOR = ', ',
		ROWTERMINATOR = '\n'
	)
	Select * From WeekDays

	BULK INSERT Availability
	FROM 'D:\Certificate IV in Programming\Database\StudentFace\Skill Assessment 12_Nov\13_AvailabilityDataModified.csv'
	WITH
	(
		FORMAT = 'CSV',
		FIRSTROW = 1,
		FIELDQUOTE = '''',
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n '
	)
	Select * from Availability

	BULK INSERT Appointment
	FROM 'D:\Certificate IV in Programming\Database\StudentFace\Skill Assessment 12_Nov\12_AppointmentData.csv'
	WITH
	(
		FORMAT = 'CSV',
		FIRSTROW = 1,
		FIELDQUOTE = '''',
		FIELDTERMINATOR = ', ',
		ROWTERMINATOR = '\n'
	)
	SELECT * FROM Appointment
	ORDER BY Practitioner_Ref ASC

	BULK INSERT TestType
	FROM 'D:\Certificate IV in Programming\Database\StudentFace\Skill Assessment 12_Nov\18_TestTypeDataModified.csv'
	WITH
	(
		FORMAT = 'CSV',
		FIRSTROW = 1,
		FIELDQUOTE = '''',
		FIELDTERMINATOR = ', ',
		ROWTERMINATOR = '\n'
	)
	SELECT * FROM TestType

	BULK INSERT PathTestReqs
	FROM 'D:\Certificate IV in Programming\Database\StudentFace\Skill Assessment 12_Nov\14_PathTestReqsDataModified.csv'
	WITH
	(
		FORMAT = 'CSV',
		FIRSTROW = 1,
		FIELDQUOTE = '''',
		FIELDTERMINATOR = ', ',
		ROWTERMINATOR = '\n'
	)
	SELECT * FROM PathTestReqs


