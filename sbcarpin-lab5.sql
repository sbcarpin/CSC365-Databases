-- Lab 5
-- sbcarpin
-- Nov 14, 2019

USE `STUDENTS`;
-- STUDENTS-1
-- Report the names of teachers who have between seven and eight (inclusive) students in their classrooms. Sort output in alphabetical order by the teacher's last name.
SELECT distinct
    teachers.Last,
    teachers.First
FROM list JOIN teachers
WHERE list.classroom = teachers.classroom
GROUP BY list.classroom, teachers.Last,
    teachers.First
HAVING COUNT(list.classroom) >= 7 AND COUNT(list.classroom) <= 8
ORDER BY teachers.Last;


USE `STUDENTS`;
-- STUDENTS-2
-- For each grade, report the number of classrooms in which it is taught and the total number of students in the grade. Sort the output by the number of classrooms in descending order, then by grade in ascending order.

SELECT distinct
    list.grade,
    COUNT(distinct teachers.classroom) as 'Classrooms',
    COUNT(list.FirstName) as 'Students'
FROM list JOIN teachers
    ON list.classroom = teachers.classroom
GROUP BY list.grade
ORDER BY classrooms DESC, list.grade;


USE `STUDENTS`;
-- STUDENTS-3
-- For each Kindergarten (grade 0) classroom, report the total number of students. Sort output in the descending order by the number of students.
SELECT distinct
    list.classroom,
    COUNT(list.classroom) as 'Students'
FROM list
WHERE list.grade = 0
GROUP BY list.classroom
ORDER BY list.classroom DESC;


USE `STUDENTS`;
-- STUDENTS-4
-- For each fourth grade classroom, report the student (last name) who is the last (alphabetically) on the class roster. Sort output by classroom.
SELECT 
    list.classroom,
    MAX(list.LastName) as 'LastOnRoster'
FROM list
WHERE list.grade = 4
GROUP BY list.classroom
ORDER BY list.classroom LIMIT 3;


USE `BAKERY`;
-- BAKERY-1
-- For each flavor which is found in more than three types of items offered at the bakery, report the average price (rounded to the nearest penny) of an item of this flavor and the total number of different items of this flavor on the menu. Sort the output in ascending order by the average price.
SELECT distinct 
    goods.flavor,
    ROUND(AVG(goods.price), 2) as 'AveragePrice',
    count(goods.Food) as 'DifferentPasteries'
FROM goods
GROUP BY goods.flavor
HAVING count(distinct goods.Food) > 3
ORDER BY goods.flavor;


USE `BAKERY`;
-- BAKERY-2
-- Find the total amount of money the bakery earned in October 2007 from selling eclairs. Report just the amount.
SELECT 
    SUM(goods.PRICE) as 'EclairRevenue'
FROM goods 
    JOIN receipts 
    JOIN items ON goods.GId = items.Item
        AND items.Receipt = receipts.RNumber
WHERE receipts.SaleDate >= '2007-10-01' AND receipts.SaleDate <= '2007-10-31'
    AND goods.Food = 'Eclair';


USE `BAKERY`;
-- BAKERY-3
-- For each visit by NATACHA STENZ output the receipt number, date of purchase, total number of items purchased and amount paid, rounded to the nearest penny. Sort by the amount paid, most to least.
SELECT distinct
    receipts.RNumber,
    receipts.SaleDate,
    count(items.item) as 'NumberOfItems',
    ROUND(SUM(goods.price), 2) as 'CheckedAmount'
FROM receipts 
    JOIN items ON receipts.RNumber = items.receipt
    JOIN goods ON goods.GId = items.item
    JOIN customers ON receipts.Customer = customers.CId 
WHERE customers.LastName = 'STENZ' AND customers.FirstName = 'NATACHA'
GROUP BY receipts.SaleDate, receipts.RNumber
ORDER BY CheckedAmount DESC;


USE `BAKERY`;
-- BAKERY-4
-- For each day of the week of October 8 (Monday through Sunday) report the total number of purchases (receipts), the total number of pastries purchased and the overall daily revenue. Report results in chronological order and include both the day of the week and the date.
SELECT 
    DAYNAME(receipts.SaleDate) as 'Day',
    receipts.SaleDate,
    count(DISTINCT receipts.RNumber) as 'Reciepts',
    count(items.item) AS Items,
    ROUND(SUM(goods.PRICE),2) as 'Revenue'
FROM goods 
    JOIN items ON goods.GId = items.Item
    JOIN receipts ON items.Receipt = receipts.RNumber
WHERE receipts.SaleDate >= '2007-10-08' AND receipts.SaleDate <= '2007-10-14'
GROUP BY receipts.SaleDate
ORDER BY receipts.SaleDate ASC;


USE `BAKERY`;
-- BAKERY-5
-- Report all days on which more than ten tarts were purchased, sorted in chronological order.
SELECT distinct
    receipts.SaleDate
FROM receipts 
    JOIN items ON receipts.RNumber = items.receipt
    JOIN goods ON goods.GId = items.item
WHERE goods.food = 'Tart' 
GROUP BY receipts.SaleDate
HAVING count(goods.food) > 10
ORDER BY receipts.SaleDate;


USE `CSU`;
-- CSU-1
-- For each campus that averaged more than $2,500 in fees between the years 2000 and 2005 (inclusive), report the total cost of fees for this six year period. Sort in ascending order by fee.
SELECT distinct
    campuses.campus,
    SUM(fees.fee) as 'Total'
FROM campuses
    JOIN fees ON campuses.Id = fees.CampusId
WHERE fees.Year >= 2000 AND fees.Year <= 2005
GROUP BY campuses.campus
HAVING AVG(fees.fee) > 2500
ORDER BY Total;


USE `CSU`;
-- CSU-2
-- For each campus for which data exists for more than 60 years, report the average, the maximum and the minimum enrollment (for all years). Sort your output by average enrollment.
SELECT distinct
    campuses.Campus,
    min(enrollments.Enrolled) as 'Minimum',
    avg(enrollments.Enrolled) as 'Average',
    max(enrollments.Enrolled) as 'Maximum'
FROM campuses
    JOIN enrollments ON campuses.ID = enrollments.CampusId 
GROUP BY campuses.Campus
HAVING COUNT(enrollments.Year) > 60
ORDER BY Average;


USE `CSU`;
-- CSU-3
-- For each campus in LA and Orange counties report the total number of degrees granted between 1998 and 2002 (inclusive). Sort the output in descending order by the number of degrees.

SELECT distinct
    campuses.campus,
    SUM(degrees.degrees) as 'Total'
FROM campuses
    JOIN degrees ON campuses.Id = degrees.CampusId
WHERE degrees.year >= 1998 AND degrees.year <= 2002
GROUP BY campuses.campus, campuses.County
HAVING campuses.County = 'Los Angeles' OR campuses.County = 'Orange'
ORDER BY Total DESC;


USE `CSU`;
-- CSU-4
-- For each campus that had more than 20,000 enrolled students in 2004, report the number of disciplines for which the campus had non-zero graduate enrollment. Sort the output in alphabetical order by the name of the campus. (Exclude campuses that had no graduate enrollment at all.)
SELECT distinct
    campuses.campus,
    count(discEnr.discipline)
FROM campuses
    JOIN enrollments ON campuses.Id = enrollments.CampusId
    JOIN discEnr ON campuses.Id = discEnr.CampusId
WHERE enrollments.year = 2004 AND enrollments.enrolled > 20000
    AND discEnr.Gr > 0
GROUP BY campuses.campus
ORDER BY campuses.campus;


USE `MARATHON`;
-- MARATHON-1
-- For each gender/age group, report total number of runners in the group, the overall place of the best runner in the group and the overall place of the slowest runner in the group. Output result sorted by age group and sorted by gender (F followed by M) within each age group.
SELECT distinct
    AgeGroup,
    Sex,
    count(FirstName) as 'Total',
    min(Place) as 'BestPlacing',
    max(Place) as 'SlowestPlacing'
FROM marathon
GROUP BY AgeGroup, Sex
ORDER BY AgeGroup, Sex;


USE `MARATHON`;
-- MARATHON-2
-- Report the total number of gender/age groups for which both the first and the second place runners (within the group) are from the same state.
SELECT 
    COUNT(m2.AgeGroup) as 'Total'
FROM marathon m1
    JOIN marathon m2 ON m1.AgeGroup = m2.AgeGroup
        AND m1.State = m2.State AND m1.GroupPlace = '1'
        AND m2.GroupPlace = '2' AND m1.Sex = m2.Sex;


USE `MARATHON`;
-- MARATHON-3
-- For each full minute, report the total number of runners whose pace was between that number of minutes and the next. In other words: how many runners ran the marathon at a pace between 5 and 6 mins, how many at a pace between 6 and 7 mins, and so on.
SELECT distinct
    Minute(pace) as 'PaceMinutes',
    count(FirstName) as 'Count'
FROM marathon
WHERE pace >= '00:05:00' AND pace < '00:13:00'
GROUP BY PaceMinutes
ORDER BY PaceMinutes;


USE `MARATHON`;
-- MARATHON-4
-- For each state with runners in the marathon, report the number of runners from the state who finished in top 10 in their gender-age group. If a state did not have runners in top 10, do not output information for that state. Sort in descending order by the number of top 10 runners.
SELECT 
    marathon.State,
    count(marathon.AgeGroup) as 'Total'
FROM marathon
WHERE marathon.GroupPlace <= '10'
GROUP BY marathon.State
ORDER BY Total DESC;


USE `MARATHON`;
-- MARATHON-5
-- For each Connecticut town with 3 or more participants in the race, report the average time of its runners in the race computed in seconds. Output the results sorted by the average time (lowest average time first).
SELECT distinct
    Town,
    round(AVG(time_to_sec(RunTime)), 1) as 'AverageTimeInSeconds'
FROM marathon
WHERE State = 'CT'
GROUP BY Town
HAVING count(FirstName) >= 3
ORDER BY AverageTimeInSeconds;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airports with exactly 17 outgoing flights. Report airport code and the full name of the airport sorted in alphabetical order by the code.
SELECT distinct
    airports.Code,
    airports.Name
FROM airports 
    JOIN flights ON airports.Code = flights.Source
GROUP BY airports.Code, airports.Name
HAVING count(flights.destination) = 17
ORDER BY airports.Code;


USE `AIRLINES`;
-- AIRLINES-2
-- Find the number of airports from which airport ANP can be reached with exactly one transfer. Make sure to exclude ANP itself from the count. Report just the number.
SELECT
    count(DISTINCT F1.Source) as 'AirportCount'
FROM flights F1 
    JOIN flights F2 ON F1.Destination = F2.Source
WHERE F1.Source != 'ANP' AND F2.Destination = 'ANP';


USE `AIRLINES`;
-- AIRLINES-3
-- Find the number of airports from which airport ATE can be reached with at most one transfer. Make sure to exclude ATE itself from the count. Report just the number.
SELECT distinct
    count(distinct F1.Source) as 'AirportCount'
FROM flights F1
    JOIN flights F2 ON F1.Destination = F2.Source
WHERE F1.Source != 'ATE' AND F2.Destination = 'ATE' 
    OR F1.Destination = 'ATE';


USE `AIRLINES`;
-- AIRLINES-4
-- For each airline, report the total number of airports from which it has at least one outgoing flight. Report the full name of the airline and the number of airports computed. Report the results sorted by the number of airports in descending order. In case of tie, sort by airline name A-Z.
SELECT 
    airlines.name,
    count(DISTINCT flights.Source) as 'Airports'
FROM airlines 
    JOIN flights ON airlines.ID = flights.Airline
    JOIN airports ON airports.Code = flights.Source
WHERE flights.Source != flights.Destination
GROUP BY airlines.name
ORDER BY count(DISTINCT flights.Source) DESC, airlines.name;


USE `INN`;
-- INN-1
-- For each room, report the total revenue for all stays and the average revenue per stay generated by stays in the room that began in the months of September, October and November. Sort output in descending order by total revenue. Output full room names.
SELECT distinct
    rooms.RoomName,
    SUM((reservations.Rate) * (DATEDIFF(reservations.CheckOut, reservations.CheckIn))) as 'TotalRevenue',
    round(AVG((reservations.Rate) * (DATEDIFF(reservations.CheckOut, reservations.CheckIn))),2) as 'AveragePerStay'
FROM rooms 
    JOIN reservations ON rooms.RoomCode = reservations.Room
WHERE MONTH(reservations.CheckIn) >= 9 AND MONTH(reservations.CheckIn) <= 11
GROUP BY rooms.RoomName
ORDER BY TotalRevenue DESC;


USE `INN`;
-- INN-2
-- Report the total number of reservations that began on Fridays, and the total revenue they brought in.
SELECT 
    COUNT(DISTINCT reservations.code) AS Stays, 
    SUM((reservations.Rate) * (DATEDIFF(reservations.CheckOut, reservations.CheckIn))) as 'Revenue'
FROM reservations
WHERE DAYNAME(reservations.CheckIn) = 'Friday';


USE `INN`;
-- INN-3
-- For each day of the week, report the total number of reservations that began on that day and the total revenue for these reservations. Report days of week as Monday, Tuesday, etc. Order days from Sunday to Saturday.
SELECT 
     DAYNAME(CheckIn) as 'Day',
     COUNT(*) as 'Stays',
     SUM(reservations.Rate * (DATEDIFF(reservations.CheckOut, reservations.CheckIn))) as 'Revenue' 
FROM rooms 
    JOIN reservations ON rooms.RoomCode = reservations.Room
GROUP BY DAYNAME(CheckIn), DAYOFWEEK(CheckIn)
ORDER BY DAYOFWEEK(CheckIn);


USE `INN`;
-- INN-4
-- For each room report the highest markup against the base price and the largest markdown (discount). Report markups and markdowns as the signed difference between the base price and the rate. Sort output in descending order beginning with the largest markup. In case of identical markup/down sort by room name A-Z. Report full room names.
SELECT DISTINCT
    rooms.roomname,
    max(reservations.rate - rooms.basePrice) as 'Markup', 
    min(reservations.rate - rooms.basePrice) as 'Discount'
FROM reservations
    JOIN rooms ON reservations.Room = rooms.RoomCode
GROUP BY rooms.roomname
ORDER BY Markup DESC, rooms.roomname;


USE `INN`;
-- INN-5
-- For each room report how many nights in calendar year 2010 the room was occupied. Report the room code, the full name of the room and the number of occupied nights. Sort in descending order by occupied nights. (Note: it has to be number of nights in 2010. The last reservation in each room can go beyond December 31, 2010, so the ”extra” nights in 2011 need to be deducted).
SELECT 
    rooms.RoomCode,
    rooms.RoomName,
    SUM((DATEDIFF(least(reservations.CheckOut,str_to_date('12-31-2010', '%m-%d-%Y') ), reservations.CheckIn))) as 'DaysOccupied'
FROM rooms 
    JOIN reservations ON rooms.RoomCode = reservations.Room
WHERE Year(reservations.CheckIn) = 2010 
GROUP BY rooms.RoomCode
ORDER BY DaysOccupied DESC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- For each performer (by first name) report how many times she sang lead vocals on a song. Sort output in descending order by the number of leads.
SELECT 
    Band.Firsname,
    count(Band.Firsname) as 'Lead'
FROM Band 
    JOIN Vocals ON Band.Id = Vocals.Bandmate
WHERE Vocals.VocalType = 'lead'
GROUP BY Band.Firsname
ORDER BY count(Band.Firsname) DESC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- Report how many different instruments each performer plays on songs from the album 'Le Pop'. Sort the output by the first name of the performers.
SELECT
    Band.Firsname as FirstName, 
    count(DISTINCT Instruments.Instrument) as 'InstrumentCount'
FROM Albums 
    JOIN Tracklists ON Albums.AID = Tracklists.Album
    JOIN Songs ON Tracklists.Song = Songs.SongId
    JOIN Instruments ON Songs.SongID = Instruments.Song
    JOIN Band ON Instruments.Bandmate = Band.Id
WHERE Albums.Title = 'Le Pop'
GROUP BY Band.Firsname
ORDER BY Band.Firsname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- Report the number of times Turid stood at each stage position when performing live. Sort output in ascending order of the number of times she performed in each position.

SELECT distinct
    p1.Stageposition as 'TuridPosition',
    count(Band.Firsname) as 'Count'
FROM Band 
    JOIN Performance p1 ON Band.Id = p1.Bandmate
WHERE Band.Firsname = 'Turid'
GROUP BY p1.Stageposition
ORDER BY Count;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Report how many times each performer (other than Anne-Marit) played bass balalaika on the songs where Anne-Marit was positioned on the left side of the stage. Sort output alphabetically by the name of the performer.

SELECT 
    B1.Firsname, 
    COUNT(DISTINCT P2.Song) as Bass
FROM Albums 
    JOIN Tracklists ON Albums.AID = Tracklists.Album
    JOIN Songs 
    JOIN Instruments I1 ON Songs.SongID = I1.Song
    JOIN Instruments I2 ON Songs.SongID = I2.Song
    JOIN Band B1 ON I1.Bandmate = B1.Id
    JOIN Band B2 ON I2.Bandmate = B2.Id
    JOIN Performance P1 ON P1.Song = Songs.SongId AND P1.Bandmate = B1.Id
    JOIN Performance P2 ON P2.Song = Songs.SongId AND P2.Bandmate = B2.Id
WHERE B1.Firsname != 'Anne-Marit' AND I1.Instrument = 'bass balalaika'
    AND B2.Firsname = 'Anne-Marit' AND P2.StagePosition = 'left'
GROUP BY B1.Firsname
ORDER BY B1.Firsname;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Report all instruments (in alphabetical order) that were played by three or more people.
SELECT distinct 
    Instruments.Instrument 
FROM Band 
    JOIN Instruments ON Band.Id = Instruments.Bandmate
GROUP BY Instruments.Instrument
HAVING count(distinct Band.Firsname) >= 3
ORDER BY Instruments.Instrument;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- For each performer, report the number of times they played more than one instrument on the same song. Sort output in alphabetical order by first name of the performer
SELECT 
    B1.Firsname, 
    COUNT(DISTINCT I1.Song) as MultiInstrumentCount
FROM Albums JOIN Songs 
    JOIN Instruments I1 ON Songs.SongID = I1.Song
    JOIN Instruments I2 ON Songs.SongID = I2.Song
    JOIN Band B1 ON I1.Bandmate = B1.Id AND I2.Bandmate = B1.Id
    JOIN Performance ON Performance.Song = Songs.SongId
WHERE I1.Instrument < I2.Instrument AND I2.Song = I1.Song 
    AND I1.Bandmate = I2.Bandmate
GROUP BY B1.Firsname
ORDER BY B1.Firsname;


