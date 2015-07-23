CREATE DATABASE Test;

USE Test;

GO

--Table TVendor

CREATE TABLE TVendor(
VendorID INT PRIMARY KEY IDENTITY(101,1),
Name VARCHAR(25)
);

INSERT INTO TVendor VALUES('Sai Travels');

INSERT INTO TVendor VALUES('Meru Cabs');

INSERT INTO TVendor VALUES('Miracle Cabs');

SELECT * FROM TVendor;


--Table TCab

CREATE TABLE TCab(
CabID INT PRIMARY KEY IDENTITY(201,1),
VendorID INT CONSTRAINT FkVen FOREIGN KEY REFERENCES TVendor(VendorID),
Number INT ,
BrandName VARCHAR(25)
);

INSERT INTO TCab VALUES(101,8529,'Mercedes');

INSERT INTO TCab VALUES(103,5764,'Jaguar');

INSERT INTO TCab VALUES(101,1967,'Lamborghini');

INSERT INTO TCab VALUES(102,7359,'Mercedes');

INSERT INTO TCab VALUES(103,1992,'Audi');

INSERT INTO TCab VALUES(103,0786,'BWW');

INSERT INTO TCab VALUES(101,0007,'Audi');

INSERT INTO TCab VALUES(102,8541,'Fiat');

SELECT * FROM TCab

--Table TUser

CREATE TABLE TUser(
UserID INT PRIMARY KEY IDENTITY(301,1),
Name VARCHAR(25),
Gender VARCHAR(2)
);

INSERT INTO TUser VALUES('Ravi','M');


INSERT INTO TUser VALUES('Kavi','F');


INSERT INTO TUser VALUES('Abhi','M');


INSERT INTO TUser VALUES('Savita','F');


INSERT INTO TUser VALUES('Gopal','M');


INSERT INTO TUser VALUES('Bhopal','M');


INSERT INTO TUser VALUES('Dolly','F');


INSERT INTO TUser VALUES('Tanu','F');


INSERT INTO TUser VALUES('Prince','M');


INSERT INTO TUser VALUES('Raj Kishore','M');

SELECT * FROM TUser

--Table TBookings

CREATE TABLE TBookings(
BookingID INT PRIMARY KEY IDENTITY(401,1),
CabID INT CONSTRAINT FkCab FOREIGN KEY REFERENCES TCab(CabID),
UserID INT CONSTRAINT FkUser FOREIGN KEY REFERENCES TUser(UserID),
Fare INT,
Distance FLOAT,
PickupTime DATETIME,
DropTime DATETIME,
Rating INT
);

INSERT INTO TBookings VALUES(204,309,101,13,'2015-04-07 19:00:00','2015-04-07 19:30:00',5);

INSERT INTO TBookings VALUES(205,301,105,15.2,'2015-05-011 9:15:00','2015-05-11 10:00:00',3);

INSERT INTO TBookings VALUES(204,309,2000,190,'2015-03-19 20:45:00','2015-05-20 01:00:00',2);

INSERT INTO TBookings VALUES(201,302,1995,150,'2015-07-07 11:00:00','2015-07-07 15:00:00',5);

INSERT INTO TBookings VALUES(204,303,553,50,'2014-09-12 19:00:00','2014-09-12 22:15:00',2);

INSERT INTO TBookings VALUES(202,302,465,45,'2015-01-07 9:00:00','2015-01-07 9:40:00',1);

INSERT INTO TBookings VALUES(205,304,258,20,'2015-07-02 3:00:00','2015-07-02 3:15:00',4);

INSERT INTO TBookings VALUES(202,309,125,15,'2015-06-23 9:00:00','2015-06-23 10:00:00',5);

INSERT INTO TBookings VALUES(204,310,1462,30,'2015-02-05 6:00:00','2015-02-05 8:00:00',4);

INSERT INTO TBookings VALUES(207,306,1876,60,'2015-01-29 15:00:00','2015-01-29 18:00:00',1);

INSERT INTO TBookings VALUES(203,308,1145,100,'2015-06-04 20:00:00','2015-06-05 6:00:00',0);

INSERT INTO TBookings VALUES(206,309,1358,90,'2015-01-19 02:00:00','2015-01-19 08:00:00',1);

INSERT INTO TBookings VALUES(208,301,102,5,'2015-03-21 11:00:00','2015-03-21 11:15:00',5);

INSERT INTO TBookings VALUES(206,309,503,50,'2015-02-28 08:00:00','2015-02-28 10:00:00',4);

INSERT INTO TBookings VALUES(204,304,786,62,'2015-03-09 16:00:00','2015-03-09 19:00:00',3);

INSERT INTO TBookings VALUES(208,306,143,3,'2015-04-09 11:30:00','2015-04-09 11:45:00',2);

INSERT INTO TBookings VALUES(203,309,658,12,'2015-05-04 01:00:00','2015-05-04 01:45:00',0);

INSERT INTO TBookings VALUES(206,308,852,17,'2015-02-18 15:00:00','2015-02-18 16:00:00',1);

INSERT INTO TBookings VALUES(208,301,450,22,'2015-03-11 18:00:00','2015-03-12 10:00:00',4);

INSERT INTO TBookings VALUES(204,309,420,29,'2015-02-17 11:00:00','2015-02-17 21:00:00',1);


SELECT * FROM TBookings;


--Question 1
SELECT Name,BrandName,Number,(CAST(DropTime AS INT)-CAST(PickupTime AS INT))
AS TravelTime 
FROM(
SELECT Number,BrandName,UserID,LTRIM(DATEDIFF(MINUTE,0,PickupTime))AS PickupTime ,
LTRIM(DATEDIFF(MINUTE,0,DropTime))AS DropTime 
FROM
(SELECT CabID,UserID,CONVERT(VARCHAR(20),PickupTime,108)AS Pickuptime,CONVERT(VARCHAR(20),DropTime,108)AS DropTime FROM TBookings WHERE Fare BETWEEN 500 AND 1000)
AS Temp JOIN TCab ON Temp.CabID=TCab.CabID)
AS Temp1 JOIN TUser ON Temp1.UserID=TUser.UserID;


--Question 2

 SELECT Number,BrandName FROM TCab JOIN(
 SELECT TOP 1 CabID,COUNT(CabID)AS NumOfBookings FROM TBookings 
 GROUP BY CabID ORDER BY NumOfBookings desc) AS Temp ON Temp.CabID=TCab.CabID;
 
 --Question 3
 
 SELECT Name,NumOfCabsUsed FROM(
 SELECT Name,NumOfCabsUsed,RANK()OVER(ORDER BY NumOfCabsUsed DESC)AS Ranking FROM(
 SELECT  UserID,COUNT(UserID)AS NumOfCabsUsed 
 FROM TBookings GROUP BY UserID )
 AS Temp JOIN TUser ON Temp.UserID=TUser.UserID )AS Temp2 WHERE Ranking BETWEEN 1 AND 3;
 
 
 --Question 4
SELECT TVendor.Name AS VendorName,Temp2.Name 
AS UserName,NumOfTimesCabBooked FROM(
SELECT Name ,VendorID,NumOfTimesCabBooked 
FROM(
SELECT VendorID ,NumOfTimesCabBooked ,UserID FROM(
SELECT CabID,UserID,COUNT(CabID)AS NumOfTimesCabBooked 
FROM TBookings 
GROUP BY CabID,UserID )AS Temp 
JOIN 
TCab ON Temp.CabID=TCab.CabID)AS Temp1 
JOIN TUser ON Temp1.UserID=TUser.UserID)AS Temp2 
JOIN TVendor ON TVendor.VendorID=Temp2.VendorID ORDER BY TVendor.Name ; 

 
 --Question 5
SELECT BrandName,Number,Gender FROM (
SELECT UserID,BrandName,Number ,Temp.CabID FROM
(SELECT UserID,CabID,RANK()OVER(PARTITION BY UserID ORDER BY CabID)AS Ranking 
FROM TBookings )AS Temp JOIN TCab ON TCab.CabID=Temp.CabID)
AS Temp1 JOIN TUser ON Temp1.UserID=TUser.UserID ORDER BY Number

--Question 6

SELECT VendorID,SUM(AverageRating)/COUNT(Sub1.CabID)AS TotalRating FROM TCab
JOIN
(SELECT CabID,AVG(Rating)AS AverageRating FROM TBookings GROUP BY CabID)AS Sub1
ON TCab.CabID=Sub1.CabID GROUP BY VendorID

--Question 7
SELECT BrandName,Temp1.VendorID,TotalDistance,Name AS VendorName FROM(
SELECT BrandName,VendorID,TotalDistance 
FROM(
SELECT CabID,SUM(Distance)AS TotalDistance
FROM TBookings GROUP BY CabID)
AS Temp JOIN TCab ON
Temp.CabID=TCab.CabID)AS Temp1 JOIN TVendor ON Temp1.VendorID=TVendor.VendorID

--Question 8

SELECT VendorID ,COUNT(Temp.CabID)AS NumOfCabs FROM TCab JOIN(
SELECT CabID ,CONVERT(DATETIME,PickupTime)as BookingDate FROM TBookings WHERE 
CONVERT(DATE,PickupTime)='2015-04-07')AS Temp ON TCab.CabID=Temp.CabID GROUP BY VendorID

-- Question 9
SELECT BrandName FROM(
SELECT BrandName ,AverageFare,Temp.CabID,
rank()OVER(ORDER BY AverageFare)AS Ranking FROM TCab 
JOIN( 
SELECT  CabID,AVG(Fare)AS AverageFare FROM TBookings 
GROUP BY CabID )AS Temp ON Temp.CabID=TCab.CabID)AS Temp1 WHERE Ranking=1




SELECT BrandName ,rank()OVER(ORDER BY )FROM TCab JOIN( 
 SELECT  TOP 1 CabID,AVG(Fare)AS AverageFare FROM TBookings 
GROUP BY CabID 
ORDER BY AverageFare)AS Temp ON Temp.CabID=TCab.CabID





 




