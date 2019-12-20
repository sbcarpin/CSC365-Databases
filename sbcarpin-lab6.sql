-- Lab 6 nested queries (subqueries)
-- sbcarpin
-- Dec 3, 2019

USE `BAKERY`;
-- BAKERY-1
-- Find all customers who did not make a purchase between October 5 and October 11 (inclusive) of 2007. Output first and last name in alphabetical order by last name.
SELECT distinct
    customers.FirstName,
    customers.LastName
FROM customers 
    JOIN receipts ON customers.CId = receipts.Customer
    WHERE customers.CId NOT IN 
    (SELECT 
        customers.CId
    FROM customers 
        JOIN receipts ON customers.CId = receipts.Customer 
    WHERE SaleDate >= '2007-10-05' AND SaleDate <= '2007-10-11');


USE `BAKERY`;
-- BAKERY-2
-- Find the customer(s) who spent the most money at the bakery during October of 2007. Report first, last name and total amount spent (rounded to two decimal places). Sort by last name.
WITH tab AS (
SELECT 
    FirstName, 
    LastName,
    ROUND(SUM(Price), 2) AS MoneySpent 
FROM customers
   JOIN receipts ON Customer = CId
   JOIN items ON Receipt = RNumber
   JOIN goods ON GId = Item
WHERE SaleDate >= '2007-10-01' AND SaleDate <= '2007-10-31'
GROUP BY CId
ORDER BY MoneySpent DESC)

SELECT *
FROM tab
WHERE MoneySpent = (SELECT max(MoneySpent) FROM tab);


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who never purchased a twist ('Twist') during October 2007. Report first and last name in alphabetical order by last name.

SELECT distinct
    customers.FirstName,
    customers.LastName
FROM receipts 
    JOIN items ON receipts.RNumber = items.receipt
    JOIN goods ON goods.GId = items.item
    JOIN customers ON receipts.Customer = customers.CId 
    WHERE customers.CId NOT IN 
    (SELECT 
        customers.CId
    FROM receipts 
        JOIN items ON receipts.RNumber = items.receipt
        JOIN goods ON goods.GId = items.item
        JOIN customers ON receipts.Customer = customers.CId 
    WHERE SaleDate >= '2007-10-01' AND SaleDate <= '2007-10-31'
        AND goods.food = 'Twist');


USE `BAKERY`;
-- BAKERY-4
-- Find the type of baked good (food type & flavor) responsible for the most total revenue.
WITH rev AS (
SELECT 
    goods.Flavor, 
    goods.Food, 
    items.Ordinal,
    goods.Price AS topPrice
FROM goods JOIN items
ON items.Item = goods.GId),
    
Total AS (
SELECT 
    Flavor, 
    Food, 
    topPrice,
    SUM(Ordinal) AS Count
FROM rev
GROUP BY Flavor, Food, topPrice),

Outcome AS (
    SELECT 
    Flavor, 
    Food,
    (topPrice * Count) AS revenue
FROM Total)

SELECT 
    Flavor, 
    Food
FROM Outcome
WHERE revenue = (SELECT MAX(revenue) FROM Outcome);


USE `BAKERY`;
-- BAKERY-5
-- Find the most popular item, based on number of pastries sold. Report the item (food, flavor) and total quantity sold.
-- Correct 
WITH timeFrame AS (
SELECT *
FROM receipts
	JOIN items ON RNumber = Receipt
	JOIN goods ON Item = GId
	JOIN customers ON customer = CId
WHERE SaleDate between '2007-10-01' AND '2007-10-31'),

itemsSold AS (
SELECT 
    flavor, 
    food, 
    COUNT(*) as itemCount
FROM timeFrame
GROUP BY flavor, food)

SELECT *
FROM itemsSold
WHERE itemCount = (SELECT max(itemCount) FROM itemsSold);


USE `BAKERY`;
-- BAKERY-6
-- Find the date of highest revenue during the month of October, 2007.
WITH timeFrame AS (
SELECT *
FROM receipts
	JOIN items ON RNumber = Receipt
	JOIn goods ON Item = GId
WHERE SaleDate between '2007-10-01' AND '2007-10-31'),

RevenuePerDay AS (
SELECT 
    SaleDate, 
    SUM(price) AS revenue
FROM timeFrame
GROUP BY SaleDate)

SELECT SaleDate FROM RevenuePerDay
WHERE revenue = (SELECT MAX(revenue) FROM RevenuePerDay);


USE `BAKERY`;
-- BAKERY-7
-- Find the best-selling item (by number of purchases) on the day of the highest revenue in October of 2007.
WITH timeFrame as (
SELECT *
FROM receipts
	JOIN items ON RNumber = Receipt
	JOIN goods ON Item = GId
	JOIN customers ON customer = CId
WHERE SaleDate between '2007-10-01' AND '2007-10-31'),

RevenuePerDay AS (
SELECT 
    SaleDate, 
    SUM(price) as revenue
FROM timeFrame
GROUP BY SaleDate),

BestSaleDate AS (
SELECT 
    SaleDate
FROM RevenuePerDay
WHERE revenue = (SELECT MAX(revenue) FROM RevenuePerDay)),

itemsSold AS (
SELECT 
    flavor, 
    food, 
    COUNT(*) AS itemCount
FROM timeFrame
WHERE SaleDate = (SELECT * FROM BestSaleDate)
GROUP BY flavor, food)

SELECT *
FROM itemsSold
WHERE itemCount = (SELECT max(itemCount) FROM itemsSold);


USE `BAKERY`;
-- BAKERY-8
-- For every type of Cake report the customer(s) who purchased it the largest number of times during the month of October 2007. Report the name of the pastry (flavor, food type), the name of the customer (first, last), and the number of purchases made. Sort output in descending order on the number of purchases, then in alphabetical order by last name of the customer, then by flavor.
WITH timeFrame AS (
SELECT *
FROM receipts
    JOIN items ON RNumber = Receipt
    JOIN goods ON Item = GId
    JOIN customers ON customer = CId
WHERE SaleDate between '2007-10-01' AND '2007-10-31'),

itemsSold AS (
SELECT 
    flavor, 
    food,
    firstname,
    lastname,
    COUNT(*) AS itemCount
FROM timeFrame
WHERE food = 'Cake'
GROUP BY flavor, food, firstname, lastname),

maxitemCount as (
SELECT 
    flavor,
    food, 
    max(itemCount) AS maxitemCount 
FROM itemsSold
GROUP BY flavor,food)

SELECT 
    flavor,
    food, 
    firstname, 
    lastname,
    itemCount
FROM itemsSold
WHERE (flavor,food, itemCount) IN 
    (SELECT 
        flavor,
        food, 
        maxitemCount 
        FROM maxitemCount)
ORDER BY itemCount DESC, lastname ASC, flavor ASC;


USE `BAKERY`;
-- BAKERY-9
-- Output the names of all customers who made multiple purchases (more than one receipt) on the latest day in October on which they made a purchase. Report names (first, last) of the customers and the earliest day in October on which they made a purchase, sorted in chronological order.

WITH timeFrame AS (
SELECT *
FROM receipts
    JOIN customers ON customer = CId
WHERE SaleDate between '2007-10-01' AND '2007-10-31'),

recieptsFinal AS (
SELECT 
    lastname, 
    firstname, 
    COUNT(firstname) AS recieptCount, 
    saleDate, 
    RANK() OVER (PARTITION BY lastname ORDER BY saleDate DESC) AS rk
FROM timeFrame
GROUP BY lastname, firstname, saleDate
ORDER BY lastname, saledate), 

recieptsDate AS (
SELECT 
    lastname, 
    firstname, 
    COUNT(firstname) AS recieptCountTwo, saleDate, 
    RANK() OVER (PARTITION BY lastname ORDER BY saleDate ASC) AS rk2
FROM timeFrame
GROUP BY lastname, firstname, saleDate
ORDER BY lastname, saledate)

SELECT 
    recieptsFinal.lastname, 
    recieptsFinal.firstname, 
    recieptsDate.saleDate
FROM recieptsFinal 
    JOIN recieptsDate ON recieptsFinal.lastname = recieptsDate.lastname
WHERE rk = 1 AND recieptCount > 1 AND 
rk2 = 1
ORDER BY saleDate, lastname DESC;


USE `BAKERY`;
-- BAKERY-10
-- Find out if sales (in terms of revenue) of Chocolate-flavored items or sales of Croissants (of all flavors) were higher in October of 2007. Output the word 'Chocolate' if sales of Chocolate-flavored items had higher revenue, or the word 'Croissant' if sales of Croissants brought in more revenue.

WITH timeFrame as (
SELECT *
FROM receipts
	JOIN items ON RNumber = Receipt
	JOIN goods ON Item = GId
	JOIN customers ON customer = CId
WHERE SaleDate between '2007-10-01' AND '2007-10-31'),

chocolate AS (
SELECT distinct
    flavor,
    food,
    SUM(price) as ChocoRevenue
FROM timeFrame
WHERE flavor = 'Chocolate'
GROUP BY flavor, food),

croissants AS (
SELECT 
    flavor,
    food,
    SUM(price) as CroissRevenue
FROM timeFrame
WHERE food = 'Croissant'
GROUP BY food, flavor),

HR as(
SELECT
    CASE
      WHEN ChocoRevenue > CroissRevenue THEN 'Chocolate'
      ELSE 'Croissants'
   END AS HighestRev
FROM chocolate JOIN croissants),

croiss AS (
SELECT 
    count(*) as highCrois
FROM HR
WHERE HighestRev = 'Croissants'),

choco AS (
SELECT 
    count(*) as highChoc
FROM HR
WHERE HighestRev = 'Chocolate')

SELECT
    CASE
      WHEN highChoc > highCrois THEN 'Chocolate'
      ELSE 'Croissants'
   END AS Winner
FROM croiss JOIN choco;


USE `INN`;
-- INN-1
-- Find the most popular room (based on the number of reservations) in the hotel  (Note: if there is a tie for the most popular room status, report all such rooms). Report the full name of the room, the room code and the number of reservations.

WITH ReservationNum AS (
SELECT 
    RoomName, 
    RoomCode, 
    COUNT(*) AS reservationCount
FROM rooms
    JOIN reservations ON RoomCode = Room
GROUP BY RoomName, RoomCode)

SELECT *
FROM ReservationNum
WHERE reservationCount = (SELECT max(reservationCount) FROM ReservationNum);


USE `INN`;
-- INN-2
-- Find the room(s) that have been occupied the largest number of days based on all reservations in the database. Report the room name(s), room code(s) and the number of days occupied. Sort by room name.
WITH ReservationNum AS (
SELECT 
    RoomName, 
    RoomCode, 
    SUM(DATEDIFF(Checkout, CheckIn)) AS Occupancy
FROM rooms
    join reservations on RoomCode = Room
GROUP BY RoomName, RoomCode)

SELECT *
FROM ReservationNum
WHERE Occupancy = (SELECT MAX(Occupancy) FROM ReservationNum);


USE `INN`;
-- INN-3
-- For each room, report the most expensive reservation. Report the full room name, dates of stay, last name of the person who made the reservation, daily rate and the total amount paid. Sort the output in descending order by total amount paid.
WITH ReservationRooms AS (
SELECT 
    room,
    roomname, 
    checkin, 
    checkout, 
    lastname, 
    rate,
    ROUND(Rate * (DATEDIFF(CheckOut, CheckIn)), 2) AS 'total'
FROM rooms
	JOIN reservations ON RoomCode = Room
GROUP BY reservations.code),

RoomRank AS (
SELECT *,
    RANK() OVER (PARTITION BY room ORDER BY total DESC) AS rk
FROM ReservationRooms
)

SELECT 
    roomname, 
    checkin, 
    checkout, 
    lastname, 
    rate,
    total
FROM RoomRank
WHERE rk = 1
ORDER BY total DESC;


USE `INN`;
-- INN-4
-- For each room, report whether it is occupied or unoccupied on July 4, 2010. Report the full name of the room, the room code, and either 'Occupied' or 'Empty' depending on whether the room is occupied on that day. (the room is occupied if there is someone staying the night of July 4, 2010. It is NOT occupied if there is a checkout on this day, but no checkin). Output in alphabetical order by room code. 
SELECT DISTINCT 
    RoomName, 
    RoomCode,
   CASE
      WHEN RoomCode = ANY (
         SELECT 
            Room
         FROM reservations
         WHERE CheckIn <= '2010-07-04' AND Checkout > '2010-07-04') THEN 'Occupied'
      ELSE 'Empty'
   END AS Occupied
FROM reservations JOIN rooms
ORDER BY RoomName;


USE `INN`;
-- INN-5
-- Find the highest-grossing month (or months, in case of a tie). Report the month, the total number of reservations and the revenue. For the purposes of the query, count the entire revenue of a stay that commenced in one month and ended in another towards the earlier month. (e.g., a September 29 - October 3 stay is counted as September stay for the purpose of revenue computation). In case of a tie, months should be sorted in chronological order.
WITH dates AS(
SELECT *, 
    DATEDIFF(CheckOut,CheckIn)*Rate AS staysrevenue
   FROM reservations),

totals AS (SELECT MONTHNAME(CheckIn) AS Month,
   COUNT(CheckIn) AS NReservations,
   SUM(staysrevenue) as MonthlyRevenue
FROM dates
GROUP BY month
ORDER BY Month DESC)

SELECT *
FROM totals
WHERE MonthlyRevenue = (SELECT max(MonthlyRevenue) FROM totals);


USE `STUDENTS`;
-- STUDENTS-1
-- Find the teacher(s) who teach(es) the largest number of students. Report the name of the teacher(s) (first and last) and the number of students in their class.

WITH fullList AS (
SELECT 
    list.LastName, 
    list.FirstName, 
    list.grade, 
    list.classroom, 
    teachers.Last, 
    teachers.First
FROM list 
    JOIN teachers ON list.classroom = teachers.classroom), 

Students AS(
SELECT 
    Last, 
    First, 
    COUNT(*) AS numstudents
FROM fullList
GROUP BY Last, First)
    
SELECT *
FROM Students
WHERE numstudents = (SELECT max(numstudents) FROM Students);


USE `STUDENTS`;
-- STUDENTS-2
-- Find the grade(s) with the largest number of students whose last names start with letters 'A', 'B' or 'C' Report the grade and the number of students
WITH fullList AS (
SELECT 
    LastName, 
    FirstName, 
    grade
FROM list
WHERE LEFT(LastName, 1) = 'A' OR LEFT(LastName, 1) = 'B' OR
    LEFT(LastName, 1) = 'C'), 

Students AS (
SELECT 
    Grade,
    COUNT(*) AS alphCount
FROM fullList
GROUP BY grade)
    
SELECT *
FROM Students
WHERE alphCount = (SELECT MAX(alphCount) FROM Students);


USE `STUDENTS`;
-- STUDENTS-3
-- Find all classrooms which have fewer students in them than the average number of students in a classroom in the school. Report the classroom numbers in ascending order. Report the number of student in each classroom.
WITH fullList AS (
SELECT 
    LastName, 
    FirstName, 
    grade, 
    classroom
FROM list), 

Students AS (
SELECT 
    classroom,
    COUNT(*) AS numStudents
FROM fullList
GROUP BY classroom)
    
SELECT *
FROM Students
WHERE numStudents < (SELECT AVG(numStudents) FROM Students);


USE `STUDENTS`;
-- STUDENTS-4
--  Find all pairs of classrooms with the same number of students in them. Report each pair only once. Report both classrooms and the number of students. Sort output in ascending order by the number of students in the classroom.
WITH class1 AS (
SELECT 
    classroom,
    count(LastName) as count1
FROM list
GROUP BY classroom),
    
class2 AS (
SELECT 
    classroom,
    count(LastName) as count2
FROM list
GROUP BY classroom)
 
SELECT distinct
    class1.classroom, 
    class2.classroom,
    class1.count1 as 'StudentCount'
FROM class1 JOIN class2
ON class1.count1 = class2.count2 
    AND class1.classroom < class2.classroom
ORDER BY count1;


USE `STUDENTS`;
-- STUDENTS-5
-- For each grade with more than one classroom, report the last name of the teacher who teachers the classroom with the largest number of students in the grade. Output results in ascending order by grade.
SELECT
    list.grade, 
    teachers.last AS Tlastname
FROM teachers 
    JOIN list ON teachers.classroom = list.classroom
WHERE grade IN (
    SELECT grade
    FROM list
    GROUP BY grade
    HAVING count(distinct classroom) > 1)
GROUP BY tlastname, grade
HAVING count(*) >= ALL (
    SELECT count(*) 
    FROM list AS students 
    WHERE students.grade = list.grade 
    GROUP BY classroom)
ORDER BY grade;


USE `CSU`;
-- CSU-1
-- Find the campus with the largest enrollment in 2000. Output the name of the campus and the enrollment.

WITH yearFrame AS (
SELECT 
    campuses.Id, 
    campuses.Campus, 
    enrollments.Year, 
    enrollments.Enrolled
FROM campuses
    JOIN enrollments ON campuses.ID = enrollments.CampusId
WHERE enrollments.Year = '2000'),

enrollments AS (
SELECT 
    Campus, 
    Enrolled
FROM yearFrame)

SELECT *
FROM enrollments
WHERE Enrolled = (SELECT max(Enrolled) FROM enrollments);


USE `CSU`;
-- CSU-2
-- Find the university that granted the highest average number of degrees per year over its entire recorded history. Report the name of the university.

WITH numDegrees AS (
SELECT 
    campuses.Campus, 
    degrees.degrees
FROM degrees
    JOIN campuses ON campuses.ID = degrees.CampusId),

degreeCount AS (
SELECT *
FROM numDegrees
WHERE degrees = (SELECT max(degrees) FROM numDegrees))

SELECT Campus
FROM degreeCount;


USE `CSU`;
-- CSU-3
-- Find the university with the lowest student-to-faculty ratio in 2003. Report the name of the campus and the student-to-faculty ratio, rounded to one decimal place. Use FTE numbers for enrollment.
WITH timeFrame AS(
SELECT 
    campuses.Campus, 
    faculty.Year AS FYear, 
    enrollments.Year,
    faculty.FTE, 
    enrollments.FTE AS EFTE
FROM campuses
    JOIN faculty ON campuses.ID = faculty.CampusId
    JOIN enrollments ON campuses.ID = enrollments.CampusId
WHERE faculty.Year = '2003' AND enrollments.YEAR = '2003'),

enrollments AS (
SELECT 
    Campus, 
    ROUND((EFTE/FTE), 1) AS StudentFacultyRatio
FROM timeFrame)

SELECT *
FROM enrollments
WHERE StudentFacultyRatio = (SELECT min(StudentFacultyRatio) FROM enrollments);


USE `CSU`;
-- CSU-4
-- Find the university with the largest percentage of the undergraduate student body in the discipline 'Computer and Info. Sciences' in 2004. Output the name of the campus and the percent of these undergraduate students on campus.
WITH fullList AS(
SELECT  
	discEnr.Ug, 
	campuses.Campus, 
	disciplines.Name,
	enrollments.enrolled AS 'enrolled'
FROM discEnr
	JOIN disciplines ON disciplines.ID = discEnr.Discipline
	JOIN campuses ON discEnr.CampusID = campuses.Id
	JOIN enrollments ON enrollments.CampusID = campuses.Id 
	    AND enrollments.Year = discEnr.Year
WHERE discEnr.Year = '2004'),

csFinal AS (
SELECT 
    Campus,
    Ug,
    enrolled
FROM fullList
WHERE Name = 'Computer and Info. Sciences'),

finalRatio AS (
SELECT 
    Campus,  
    ROUND(Ug/enrolled * 100, 1) AS PercentCS
FROM csFinal)

SELECT *
FROM finalRatio
WHERE PercentCS = (SELECT MAX(PercentCS) FROM finalRatio);


USE `CSU`;
-- CSU-5
-- For each year between 1997 and 2003 (inclusive) find the university with the highest ratio of total degrees granted to total enrollment (use enrollment numbers). Report the years, the names of the campuses and the ratios. List in chronological order.
WITH t as (
SELECT 
    e.year, 
    campus,
    d.degrees/e.enrolled as enrollmentDegree,
    Rank() OVER (PARTITION BY year ORDER BY d.degrees/e.enrolled DESC) AS rk
    FROM campuses c
        JOIN degrees d on d.campusid = c.id
        JOIN enrollments e on e.campusid = d.campusid
            AND e.year = d.year
    WHERE d.year BETWEEN 1997 AND 2003)
    
SELECT 
    year,
    campus,
    enrollmentDegree
FROM t 
WHERE rk = 1;


USE `CSU`;
-- CSU-6
-- For each campus report the year of the best student-to-faculty ratio, together with the ratio itself. Sort output in alphabetical order by campus name. Use FTE numbers to compute ratios.
SELECT 
    campus, 
    Fyear,
    ratio
FROM (
SELECT 
    campuses.Campus, 
    faculty.Year AS 'FYear',
	ROUND((enrollments.FTE/faculty.FTE), 2) AS 'ratio',
	RANK() OVER (PARTITION BY Campus ORDER BY ROUND((enrollments.FTE/faculty.FTE), 2) DESC) AS rk
FROM campuses
	JOIN faculty ON campuses.ID = faculty.CampusId
	JOIN enrollments ON campuses.ID = enrollments.CampusId AND enrollments.year = faculty.year
GROUP BY campuses.Campus, FYear, ratio
) t 
WHERE rk = 1
ORDER BY Campus;


USE `CSU`;
-- CSU-7
-- For each year (for which the data is available) report the total number of campuses in which student-to-faculty ratio became worse (i.e. more students per faculty) as compared to the previous year. Report in chronological order.

with ratios as (
select 
    e.campusid,
    e.year,
    e.fte/f.fte as ratio
from enrollments e join faculty f
on f.campusid = e.campusid and f.year = e.year
)

select 
    r1.year + 1 as year,
    count(*) as campus
from ratios r1 join ratios r2
on r1.year = r2.year - 1 and r1.campusid = r2.campusid
and r1.ratio < r2.ratio
group by r1.year
order by year;


USE `MARATHON`;
-- MARATHON-1
-- Find the state(s) with the largest number of participants. List state code(s) sorted alphabetically.

WITH t AS (
SELECT 
    State, 
    COUNT(*) AS total
FROM marathon
GROUP BY State)

SELECT State
FROM t
WHERE total = (SELECT MAX(total) FROM t);


USE `MARATHON`;
-- MARATHON-2
--  Find all towns in Rhode Island (RI) which fielded more female runners than male runners for the race. Report the names of towns, sorted alphabetically.

WITH runners AS (
SELECT 
    Town, 
    State, 
    Sex, 
    COUNT(*) AS numrunners 
FROM marathon
WHERE State = 'RI'
GROUP BY Sex, Town, State
ORDER BY Town, numrunners DESC),

females AS (
SELECT 
    Town, 
    numrunners AS femalesCount
FROM runners
GROUP BY Town, Sex
HAVING Sex = 'F'), 

males AS (
SELECT 
    Town, 
    numrunners AS malesCount
FROM runners
GROUP BY Sex, Town, State
HAVING Sex = 'M'
), 

Total AS (
SELECT 
    females.Town
FROM females join males
    ON females.Town = males.Town
WHERE malesCount < femalesCount
GROUP BY females.Town)

SELECT *
FROM Total;


USE `MARATHON`;
-- MARATHON-3
-- For each state, report the gender-age group with the largest number of participants. Output state, age group, gender, and the number of runners in the group. Report only information for the states where the largest number of participants in a gender-age group is greater than one. Sort in ascending order by state code, age group, then gender.
SELECT 
    State, 
    AgeGroup, 
    Sex,
    RunnerCount
FROM (
SELECT
    State, 
    AgeGroup, 
    Sex,
    COUNT(*) as RunnerCount,
    RANK() OVER (PARTITION BY State ORDER BY COUNT(*) DESC) AS rk
FROM marathon
GROUP BY State, AgeGroup, Sex) t
WHERE RunnerCount > 1 AND rk = 1
ORDER BY State, AgeGroup, Sex;


USE `MARATHON`;
-- MARATHON-4
-- Find the 30th fastest female runner. Report her overall place in the race, first name, and last name. This must be done using a single SQL query (which may be nested) that DOES NOT use the LIMIT clause. Think carefully about what it means for a row to represent the 30th fastest (female) runner.
SELECT 
    Place, 
    FirstName, 
    LastName 
FROM marathon m
WHERE Sex = 'F' AND 29 = (
   SELECT COUNT(*) FROM marathon
   WHERE Sex = 'F'
   AND Place < m.Place
);


USE `MARATHON`;
-- MARATHON-5
-- For each town in Connecticut report the total number of male and the total number of female runners. Both numbers shall be reported on the same line. If no runners of a given gender from the town participated in the marathon, report 0. Sort by number of total runners from each town (in descending order) then by town.

WITH male AS (
SELECT 
    town, 
    count(*) AS menCount 
FROM marathon
WHERE state = 'CT' AND sex = 'M' 
GROUP BY town), 

female AS (
SELECT
    town, 
    count(*) AS womenCount
FROM marathon
WHERE state = 'CT' AND sex = 'F' 
GROUP BY town), 

combined AS (
(SELECT 
    male.town, 
    menCount,
    womenCount
FROM male LEFT OUTER JOIN  female
ON male.town = female.town)

UNION all

(SELECT
    female.town, 
    menCount,
    womenCount
FROM male RIGHT OUTER JOIN female
ON male.town = female.town 
WHERE male.town is null))

SELECT 
    combined.town, 
    IFNULL(combined.menCount, 0) as M, 
    IFNULL(combined.womenCount, 0) as W
FROM combined
ORDER BY(IFNULL(combined.menCount, 0) + IFNULL(combined.womenCount, 0)) DESC, town;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report the first name of the performer who never played accordion.

SELECT distinct Band.firsname
FROM Instruments
	JOIN Band On Instruments.Bandmate = Band.Id
WHERE Band.firsname NOT IN
	(SELECT distinct
    	Band.firsname
	FROM Instruments
    	JOIN Band On Instruments.Bandmate = Band.Id
	WHERE Instruments.Instrument = 'accordion');


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report, in alphabetical order, the titles of all instrumental compositions performed by Katzenjammer ("instrumental composition" means no vocals).

SELECT distinct
    Songs.Title
FROM Instruments 
    JOIN Band ON Instruments.Bandmate = Band.Id
    JOIN Songs ON Instruments.Song = Songs.SongId
WHERE Songs.SongId NOT IN 
    (SELECT distinct
        Songs.SongId
    FROM Instruments 
    JOIN Band ON Instruments.Bandmate = Band.Id
    JOIN Songs ON Instruments.Song = Songs.SongId
    JOIN Vocals ON Vocals.Song = Songs.SongId);


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the title(s) of the song(s) that involved the largest number of different instruments played (if multiple songs, report the titles in alphabetical order).
WITH numInstru AS (
SELECT 
    Songs.SongId,
    Songs.Title,
    count(Instruments.Instrument) as numI
FROM Instruments 
    JOIN Songs ON Instruments.Song = Songs.SongId
GROUP BY Songs.SongId, Songs.Title)

SELECT 
    Title
FROM numInstru 
WHERE numI = (SELECT MAX(numI) FROM numInstru) ;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find the favorite instrument of each performer. Report the first name of the performer, the name of the instrument and the number of songs the performer played the instrument on. Sort in alphabetical order by the first name.

with t as (
SELECT distinct
    Band.firsname,
    Instruments.Instrument,
    count(Songs.Title) as numoftimeplayed
FROM Instruments 
    JOIN Band ON Instruments.Bandmate = Band.Id
    JOIN Songs ON Instruments.Song = Songs.SongId
GROUP BY Band.firsname, Instruments.Instrument
),

maxtime as (
SELECT 
    firsname,
    max(numoftimeplayed) as num1
from t
GROUP BY firsname),

maxinstru as(
SELECT 
    firsname,
    Instrument,
    max(numoftimeplayed) as num2
from t
GROUP BY Instrument, firsname
)

select distinct
    maxinstru.firsname,
    Instrument,
    num1 as num
from maxtime join maxinstru on num1 = num2
order by firsname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments played ONLY by Anne-Marit. Report instruments in alphabetical order.
SELECT DISTINCT 
    Instruments.Instrument
FROM Instruments 
    JOIN Band ON Instruments.Bandmate = Band.Id
    JOIN Songs ON Instruments.Song = Songs.SongId
WHERE Instruments.Instrument NOT IN (
    SELECT DISTINCT
        Instruments.Instrument
    FROM Instruments 
        JOIN Band ON Instruments.Bandmate = Band.Id
        JOIN Songs ON Instruments.Song = Songs.SongId
        JOIN Vocals ON Vocals.Song = Songs.SongId
    WHERE NOT(Band.Firsname = 'Anne-Marit')) 
AND NOT Instruments.Instrument = 'keyboard';


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Report the first name of the performer who played the largest number of different instruments. Sort in ascending order.

WITH t AS (
SELECT DISTINCT 
    Band.Firsname, 
    Instruments.Instrument 
FROM Instruments 
    JOIN Band ON Instruments.Bandmate = Band.Id
    JOIN Songs ON Instruments.Song = Songs.SongId),

names AS (
SELECT 
    Firsname, 
    COUNT(Instrument) AS instruCount
FROM t
GROUP BY Firsname
ORDER BY Firsname, instruCount)

SELECT 
    Firsname
FROM names
WHERE instruCount = (SELECT max(instruCount) FROM names
ORDER BY Firsname);


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Who spent the most time performing in the center of the stage (in terms of number of songs on which she was positioned there)? Return just the first name of the performer(s). Sort in ascending order.

WITH stage AS (
SELECT DISTINCT 
    firsname, 
    StagePosition, 
    Song
FROM Band
    JOIN Performance ON Performance.Bandmate = Band.Id
    JOIN Songs ON Performance.Song = Songs.SongId
WHERE StagePosition = 'center'),

position AS (
SELECT 
    firsname, 
    StagePosition, 
    COUNT(*) AS counter
FROM stage
GROUP BY firsname, StagePosition)

SELECT firsname
FROM position
WHERE counter = (SELECT max(counter) FROM position)
ORDER BY firsname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Which instrument(s) was/were played on the largest number of songs? Report just the names of the instruments (note, you are counting number of songs on which an instrument was played, make sure to not count two different performers playing same instrument on the same song twice).
WITH music AS (
SELECT DISTINCT 
    Song, 
    Instrument
FROM Instruments
    JOIN Band ON Instruments.Bandmate = Band.Id
    JOIN Songs ON Instruments.Song = Songs.SongId),

instru AS (
SELECT 
    Instrument, 
    COUNT(*) AS counter
FROM music
GROUP BY Instrument)

SELECT Instrument
FROM instru
WHERE counter = (SELECT max(counter) FROM instru);


