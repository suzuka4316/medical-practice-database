Use MedicalPractice
Go

Select * From Patient
---1. List the first name and last name of female patients who live in St Kilda or Lidcombe.
Select FirstName, LastName From Patient
Where (Suburb='St Kilda' or Suburb='Lidcombe') and Gender='female'

---2. List the first name, last name, state and Medicare Number of any patients who do not live in NSW.
Select FirstName, LastName, State, MedicareNumber From Patient
Where NOT State='NSW'

Select * From PathTestReqs
Select * From TestType
--3. List the practitioner's and patient's first and last names, the date and time that the pathology tests were ordered and the name of the pathology test.
Select p.FirstName, p.LastName, dr.FirstName, dr.LastName,
	   DateOrdered, TimeOrdered, TestName
From Patient p, Practitioner dr, PathTestReqs, TestType
Where Patient_ID=Patient_Ref AND Practitioner_ID=Practitioner_Ref AND Test_Ref=Test_Code
Order by p.FirstName ASC

---4. List the Patient's first name, last name and the appointment date and time, for all appointments held on the 18/09/2019 by Dr Anne Funsworth.
Select p.FirstName, p.LastName, AppDate, AppStartTime,
	   dr.FirstName +' '+ dr.LastName AS PractitionerFullName
From Patient p, Practitioner dr, Appointment
Where dr.FirstName='Anne' AND dr.LastName='Funsworth' AND AppDate='2019-09-18' 
	  AND Patient_ID=Patient_Ref AND Practitioner_ID=Practitioner_Ref
Order by AppStartTime ASC

--5. List each Patient's first name, last name, Medicare Number and their date of birth. Sort the list by date of birth, listing the youngest patients first.
Select FirstName, LastName, MedicareNumber, DateOfBirth From Patient
Order by DateOfBirth DESC

--6. For each pathology test request, list the test code, the test name the date and time that the test was ordered. Sort the results by the date the test was ordered and then by the time that it was ordered.
Select Test_Code, TestName, DateOrdered, TimeOrdered 
From PathTestReqs, TestType
Where Test_Ref=Test_Code
Order by DateOrdered, TimeOrdered ASC

--7. List the ID and date of birth of any patient who has not had an appointment and was born before 1950.
Select DISTINCT Patient_ID, DateOfBirth
From Patient
Where Patient_ID NOT IN (Select Patient_Ref From Appointment) AND DateOfBirth<'19500101'

Select * From Patient
Order by DateOfBirth ASC
--8. List the patient ID, last name and date of birth of all male patients born between 1962 and 1973 (inclusive).
Select Patient_ID, LastName, DateOfBirth From Patient
Where Gender='male' AND (DateOfBirth BETWEEN '1962-01-01' and '1973-01-01')

--9. List the patient ID, first name and last name of any male patients who have had appointments with either Dr Huston or Dr Vergenargen.
Select Patient_ID, p.FirstName, p.LastName,
	   dr.FirstName +' '+ dr.LastName AS PractitionerFullName
From Patient p, Practitioner dr, Appointment
Where p.Gender='male' AND (dr.LastName='Huston' OR dr.LastName='Vergenargen') AND 
	  Patient_ID=Patient_Ref AND Practitioner_ID=Practitioner_Ref

Select * From Availability
Order by Practitioner_Ref ASC
--10. List the practitioner ID, first name, last name and practitioner type of each practitioner, and the number of days of the week that they're available.
Select Practitioner_ID, FirstName, LastName, PractitionerType, Count(WeekDayName_Ref) AS #OfDaysAvailable
From Availability, Practitioner, PractitionerType
Where Practitioner_ID=Practitioner_Ref AND PractitionerType=PractitionerType_Ref
Group by Practitioner_ID, FirstName, LastName, PractitionerType
Order by Practitioner_ID ASC

Select * From Appointment
Order by Patient_Ref ASC
--11. List the patient ID, first name, last name and the number of appointments for patients who have had at least three appointments.
Select Patient_ID, FirstName, LastName, COUNT(Patient_Ref) AS #OfAppointments
From Patient, Appointment
Where Patient_ID=Patient_Ref
Group by Patient_ID, FirstName, LastName
Having COUNT(Patient_Ref) >= 3

--12. List the first name, last name, gender, and the number of days since the last appointment of each patient and the 23/09/2019.
Select Patient_Ref, FirstName, LastName, Gender, 
	   MAX(AppDate) AS LastVisit, DATEDIFF(DAY, MAX(AppDate), '2019/09/23') as DateDiff
From Appointment, Patient
where Patient_ID=Patient_Ref
Group by Patient_Ref, FirstName, LastName, Gender

--13.	For each practitioner, list their ID, first name, last name and the total number of hours worked each week at the Medical Practice. Assume a nine-hour working day and that practitioners work the full nine hours on each day that they're available.
Select Practitioner_ID, FirstName, LastName, 
	   Count(WeekDayName_Ref) AS #OfDaysAvailable, Count(WeekDayName_Ref)*9 AS TotalWorkHours
From Availability, Practitioner
Where Practitioner_ID=Practitioner_Ref
Group by Practitioner_ID, FirstName, LastName
Order by Practitioner_ID ASC

Select * From Practitioner
--14. List the full name and full address of each practitioner in the following format exactly. (Dr Mark P. Huston. 21 Fuller Street SUNSHINE, NSW 2343) Make sure you include the punctuation and the suburb in upper case.
Select Title +' '+ FirstName +' '+ MiddleInitial +'. '+ LastName +'. '+
	   HouseUnitLotNum +' '+ Street +' '+ UPPER(Suburb) +', '+ State +' '+ PostCode
	   AS PractitionerInfo
From Practitioner

--15. List the date of birth of the male practitioner named Leslie Gray in the following format exactly: Saturday, 11 March 1989
Select DATENAME(WEEKDAY, DateOfBirth) +', '+ CONVERT(varchar, DateOfBirth, 106) AS DOB
From Practitioner
Where FirstName='Leslie' AND LastName='Gray'

Select dateofbirth, FirstName, LastName From patient Order by dateofbirth ASC
--16. List the patient id, first name, last name and date of birth of the fifth oldest patient(s).
Select Top 1 Patient_ID, FirstName, LastName, DateOfBirth 
From(Select Top 5 * From Patient Order by DateOfBirth ASC) AS A
Order by DateOfBirth DESC

Select * From Appointment
--17. List the patient ID, first name, last name, appointment date (in the format 'Tuesday 17 September, 2019') and appointment time (in the format '14:15 PM') for all patients who have had appointments on any Tuesday after 10:00 AM.
Select Patient_ID, FirstName, LastName, DATENAME(WEEKDAY, AppDate) +' '+ CONVERT(varchar, DateOfBirth, 106) AS AppDate,
	   FORMAT(CAST(AppStartTime AS datetime2), N'hh:mm tt') AS AppStartTime
From Patient, Appointment
Where Patient_ID=Patient_Ref AND DATENAME(WEEKDAY, AppDate)='Tuesday' AND AppStartTime>='10:00'
Order by Patient_ID ASC

--18. Calculate and list the number of hours and minutes between Joan Wothers' 8:00 AM appointment on 17/09/2019 and Terrence Hill's 2:15 PM appointment on that same day with Dr Ludo Vergenargen. Format the result in the following format: 5 hrs 35 mins 
Select p.FirstName +' '+ p.LastName AS PatientFullName, dr.FirstName +' '+ dr.LastName AS PractitionerFullName, AppDate, AppStartTime
From Appointment, Patient p, Practitioner dr
Where Patient_ID=Patient_Ref AND Practitioner_ID=Practitioner_Ref AND AppDate='20190917' AND (AppStartTime BETWEEN '08:00' AND '14:15') AND dr.FirstName='Ludo'
Order by AppDate, AppStartTime ASC

Select CAST(DATEDIFF(HOUR, App1.AppStartTime, App2.AppStartTime) as varchar) + ' hrs ' + 
	   CAST((DATEDIFF(MINUTE, App1.AppStartTime, App2.AppStartTime)) - (DATEDIFF(HOUR, App1.AppStartTime, App2.AppStartTime) * 60) as varchar) + ' mins' 
	   AS TimeDifference
From(
	Select AppStartTime From Appointment, Patient p, Practitioner dr
	Where Patient_ID=Patient_Ref AND Practitioner_ID=Practitioner_Ref AND AppDate='20190917' AND AppStartTime='08:00' AND dr.FirstName='Ludo'
) AS App1,
(
	Select AppStartTime From Appointment, Patient p, Practitioner dr
	Where Patient_ID=Patient_Ref AND Practitioner_ID=Practitioner_Ref AND AppDate='20190917' AND AppStartTime='14:15' AND dr.FirstName='Ludo'
) AS App2

--19. List the age difference in years between the youngest patient and the oldest patient in the following format: The age difference between our oldest and our youngest patient is 76 years.
Select FirstName, LastName, DateOfBirth From Patient
Order by DateOfBirth ASC

Select 'The age difference between our oldest and our youngest patient is ' +
	   CAST(DATEDIFF(YEAR, MIN(DateOfBirth), MAX(DateOfBirth)) as varchar) +
	   ' years.' AS AgeDifference
From Patient



