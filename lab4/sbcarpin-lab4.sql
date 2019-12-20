-- Lab 4: JOIN and WHERE
-- sbcarpin
-- Nov 6, 2019

USE `STUDENTS`;
-- STUDENTS-1
-- Find all students who study in classroom 111. For each student list first and last name. Sort the output by the last name of the student.
SELECT FirstName, LastName
FROM list  
WHERE classroom = '111'
ORDER BY LastName;


USE `STUDENTS`;
-- STUDENTS-2
-- For each classroom report the grade that is taught in it. Report just the classroom number and the grade number. Sort output by classroom in descending order.
SELECT DISTINCT Classroom, Grade
FROM list  
ORDER BY Classroom DESC;


USE `STUDENTS`;
-- STUDENTS-3
-- Find all teachers who teach fifth grade. Report first and last name of the teachers and the room number. Sort the output by room number.
SELECT DISTINCT
    teachers.First,
    teachers.Last,
    teachers.classroom
FROM teachers INNER JOIN list
ON teachers.classroom = list.classroom
WHERE list.grade = 5;


USE `STUDENTS`;
-- STUDENTS-4
-- Find all students taught by OTHA MOYER. Output first and last names of students sorted in alphabetical order by their last name.
SELECT DISTINCT
    list.FirstName,
    list.LastName
FROM teachers INNER JOIN list
ON teachers.classroom = list.classroom
WHERE teachers.First = 'OTHA' AND teachers.Last = 'MOYER'
ORDER BY list.LastName ASC;


USE `STUDENTS`;
-- STUDENTS-5
-- For each teacher teaching grades K through 3, report the grade (s)he teaches. Each name has to be reported exactly once. Sort the output by grade and alphabetically by teacher’s last name for each grade.
SELECT DISTINCT
    teachers.first,
    teachers.last,
    list.grade
FROM teachers INNER JOIN list
ON teachers.classroom = list.classroom
WHERE list.grade >= 0 AND list.grade <= 3
ORDER BY list.grade ASC, teachers.last ASC;


USE `BAKERY`;
-- BAKERY-1
-- Find all chocolate-flavored items on the menu whose price is under $5.00. For each item output the flavor, the name (food type) of the item, and the price. Sort your output in descending order by price.
SELECT 
    goods.Flavor,
    goods.Food,
    goods.PRICE
FROM goods
WHERE PRICE < 5.00 AND Flavor = 'Chocolate'
ORDER BY PRICE DESC;


USE `BAKERY`;
-- BAKERY-2
-- Report the prices of the following items (a) any cookie priced above $1.10, (b) any lemon-flavored items, or (c) any apple-flavored item except for the pie. Output the flavor, the name (food type) and the price of each pastry. Sort the output in alphabetical order by the flavor and then pastry name.
SELECT 
    goods.Flavor,
    goods.Food,
    goods.PRICE
FROM goods
WHERE (Food = 'Cookie' AND PRICE > 1.10)
OR (Flavor = 'Lemon') OR (Flavor = 'Apple' AND NOT Food = 'Pie')
ORDER BY Flavor ASC, Food ASC;


USE `BAKERY`;
-- BAKERY-3
-- Find all customers who made a purchase on October 3, 2007. Report the name of the customer (last, first). Sort the output in alphabetical order by the customer’s last name. Each customer name must appear at most once.
SELECT distinct
    customers.LastName,
    customers.FirstName
FROM customers INNER JOIN receipts
ON customers.CId = receipts. Customer
WHERE receipts.SaleDate = '2007-10-03'
ORDER BY customers.LastName ASC;


USE `BAKERY`;
-- BAKERY-4
-- Find all different cakes purchased on October 4, 2007. Each cake (flavor, food) is to be listed once. Sort output in alphabetical order by the cake flavor.
SELECT distinct
    goods.Flavor,
    goods.Food
FROM ((goods INNER JOIN items
ON goods.GId = items.Item) INNER JOIN
receipts ON receipts.RNumber = items.Receipt)
WHERE SaleDate = '2007-10-04' AND Food = 'Cake'
ORDER BY Flavor ASC;


USE `BAKERY`;
-- BAKERY-5
-- List all pastries purchased by ARIANE CRUZEN on October 25, 2007. For each pastry, specify its flavor and type, as well as the price. Output the pastries in the order in which they appear on the receipt (each pastry needs to appear the number of times it was purchased).
SELECT
    goods.Flavor,
    goods.Food,
    goods.PRICE
FROM (((customers INNER JOIN receipts
ON customers.CId = receipts.Customer) INNER JOIN
items ON RNumber = items.Receipt) INNER JOIN
goods ON Item = goods.GId)
WHERE (LastName = 'CRUZEN' AND FirstName = 'ARIANE') 
AND SaleDate = '2007-10-25'
ORDER BY receipt;


USE `BAKERY`;
-- BAKERY-6
-- Find all types of cookies purchased by KIP ARNN during the month of October of 2007. Report each cookie type (flavor, food type) exactly once in alphabetical order by flavor.

SELECT
    goods.Flavor,
    goods.Food
FROM (((customers INNER JOIN receipts
ON customers.CId = receipts.Customer) INNER JOIN
items ON RNumber = items.Receipt) INNER JOIN
goods ON Item = goods.GId)
WHERE (LastName = 'ARNN' AND FirstName = 'KIP') 
AND (SaleDate >= '2007-10-01' AND SaleDate <= '2007-10-31')
AND Food = 'Cookie'
ORDER BY Flavor ASC;


USE `CSU`;
-- CSU-1
-- Report all campuses from Los Angeles county. Output the full name of campus in alphabetical order.
SELECT 
    Campus
FROM campuses
WHERE County = 'Los Angeles'
ORDER BY Campus ASC;


USE `CSU`;
-- CSU-2
-- For each year between 1994 and 2000 (inclusive) report the number of students who graduated from California Maritime Academy Output the year and the number of degrees granted. Sort output by year.
SELECT 
    degrees.year,
    degrees.degrees
FROM degrees INNER JOIN campuses
ON degrees.CampusId = campuses.Id
WHERE (degrees.year >= 1994 AND degrees.year <= 2000)
AND Campus = 'California Maritime Academy'
ORDER BY degrees.year ASC;


USE `CSU`;
-- CSU-3
-- Report undergraduate and graduate enrollments (as two numbers) in ’Mathematics’, ’Engineering’ and ’Computer and Info. Sciences’ disciplines for both Polytechnic universities of the CSU system in 2004. Output the name of the campus, the discipline and the number of graduate and the number of undergraduate students enrolled. Sort output by campus name, and by discipline for each campus.
select 
    campuses.campus,
    disciplines.name,
    gr,
    ug
    
FROM ((discEnr INNER JOIN disciplines 
ON discEnr.discipline = disciplines.Id) INNER JOIN
campuses ON discEnr.CampusId = campuses.Id)


WHERE ((campus = 'California State Polytechnic University-Pomona' OR
campus = 'California Polytechnic State University-San Luis Obispo') 
AND (disciplines.name = 'Mathematics' OR disciplines.name = 'Engineering' OR disciplines.name = 'Computer and Info. Sciences')
AND discEnr.year = '2004')
ORDER BY campus ASC, disciplines.name ASC;


USE `CSU`;
-- CSU-4
-- Report graduate enrollments in 2004 in ’Agriculture’ and ’Biological Sciences’ for any university that offers graduate studies in both disciplines. Report one line per university (with the two grad. enrollment numbers in separate columns), sort universities in descending order by the number of ’Agriculture’ graduate students.
SELECT DISTINCT 
    campuses.Campus, 
    deg1.gr As Agriculture,
    deg2.gr As Biology
FROM disciplines AS d1 INNER JOIN disciplines AS d2 INNER JOIN degrees 
INNER JOIN discEnr AS deg1 INNER JOIN discEnr AS deg2 INNER JOIN campuses
ON (campuses.Id = degrees.CampusId AND d1.ID = deg1.Discipline
AND d2.ID = deg2.Discipline AND deg1.campusId = campuses.Id
AND deg2.campusId = campuses.Id)
WHERE (d1.Name = 'Agriculture' AND d2.Name = 'Biological Sciences')
AND (degrees.year = '2004' AND deg2.gr > 0 AND deg1.gr > 0)
ORDER BY deg1.gr DESC;


USE `CSU`;
-- CSU-5
-- Find all disciplines and campuses where graduate enrollment in 2004 was at least three times higher than undergraduate enrollment. Report campus names and discipline names. Sort output by campus name, then by discipline name in alphabetical order.
SELECT DISTINCT 
    campuses.Campus, 
    disciplines.name, 
    discEnr.ug, 
    discEnr.gr
FROM CSU.disciplines INNER JOIN CSU.discEnr
INNER JOIN CSU.campuses 
INNER JOIN CSU.degrees
ON (campuses.Id = degrees.CampusId AND campuses.Id = discEnr.CampusId
  AND disciplines.ID = discEnr.Discipline AND campuses.ID = degrees.CampusId)
WHERE (degrees.year = '2004' AND 3 * discEnr.Ug <= discEnr.Gr)
ORDER BY campuses.Campus, disciplines.name ASC;


USE `CSU`;
-- CSU-6
-- Report the total amount of money collected from student fees (use the full-time equivalent enrollment for computations) at ’Fresno State University’ for each year between 2002 and 2004 inclusively, and the amount of money (rounded to the nearest penny) collected from student fees per each full-time equivalent faculty. Output the year, the two computed numbers sorted chronologically by year.
SELECT distinct 
    enrollments.year, 
    fees.fee * enrollments.FTE as 'COLLECTED',
    round((fees.fee * enrollments.FTE / faculty.FTE), 2) as 'PER FACULTY'
FROM disciplines 
    JOIN discEnr 
    JOIN faculty
    JOIN campuses 
    JOIN degrees
    JOIN enrollments
    JOIN fees
ON campuses.Id = degrees.CampusId AND campuses.Id = discEnr.CampusId
    AND disciplines.ID = discEnr.Discipline AND campuses.ID = degrees.CampusId
    AND campuses.ID = fees.CampusId AND campuses.ID = faculty.CampusID
    AND campuses.ID = enrollments.CampusID AND enrollments.year = fees.year
WHERE campuses.Campus = 'Fresno State University' AND (fees.year >= 2002 AND fees.year <= 2004)
    AND enrollments.year >= 2002 AND enrollments.year <= 2004 AND enrollments.year = fees.year
    AND faculty.year = fees.year;


USE `CSU`;
-- CSU-7
-- Find all campuses where enrollment in 2003 (use the FTE numbers), was higher than the 2003 enrollment in ’San Jose State University’. Report the name of campus, the 2003 enrollment number, the number of faculty teaching that year, and the student-to-faculty ratio, rounded to one decimal place. Sort output in ascending order by student-to-faculty ratio.
SELECT distinct 
    c2.Campus, 
    e2.FTE As Students, 
    faculty.FTE, 
    Round((e2.FTE / faculty.FTE), 1) As Ratio
FROM disciplines 
    JOIN faculty
    JOIN campuses c1
    JOIN campuses c2
    JOIN enrollments e1
    JOIN enrollments e2
ON (c1.ID = e1.CampusID AND c2.ID = e2.CampusID
    AND faculty.CampusID = e2.CampusID)
WHERE e1.Year = '2003' AND e2.Year = '2003' AND faculty.year = '2003'
    AND c1.Campus = 'San Jose State University' AND e1.FTE < e2.FTE
    AND c1.Campus != c2.Campus
ORDER BY Round((e2.FTE / faculty.FTE), 1);


USE `INN`;
-- INN-1
-- Find all modern rooms with a base price below $160 and two beds. Report room names and codes in alphabetical order by the code.
SELECT 
    RoomCode,
    RoomName
FROM rooms
WHERE (decor = 'modern') AND (basePrice < 160) AND (Beds = 2)
ORDER BY RoomName ASC;


USE `INN`;
-- INN-2
-- Find all July 2010 reservations (a.k.a., all reservations that both start AND end during July 2010) for the ’Convoke and sanguine’ room. For each reservation report the last name of the person who reserved it, checkin and checkout dates, the total number of people staying and the daily rate. Output reservations in chronological order.
SELECT
    reservations.LastName,
    reservations.CheckIn,
    reservations.CheckOut,
    reservations.Adults + reservations.Kids as Guest,
    reservations.Rate
FROM reservations INNER JOIN rooms
ON reservations.Room = rooms.RoomCode
WHERE (RoomName = 'Convoke and sanguine') 
AND (CheckIn >= '2010-07-01') AND (CheckIn <= '2010-07-30');


USE `INN`;
-- INN-3
-- Find all rooms occupied on February 6, 2010. Report full name of the room, the check-in and checkout dates of the reservation. Sort output in alphabetical order by room name.
SELECT distinct
    rooms.RoomName,
    reservations.CheckIn,
    reservations.CheckOut
FROM reservations INNER JOIN rooms
ON reservations.Room = rooms.RoomCode
WHERE (CheckIn <= '2010-02-06') AND (CheckOut > '2010-02-06')
ORDER BY rooms.RoomName ASC;


USE `INN`;
-- INN-4
-- For each stay by GRANT KNERIEN in the hotel, calculate the total amount of money, he paid. Report reservation code, checkin and checkout dates, room name (full) and the total stay cost. Sort output in chronological order by the day of arrival.

SELECT distinct
    reservations.Code,
    rooms.RoomName,
    reservations.CheckIn,
    reservations.CheckOut,
    reservations.Rate * (DATEDIFF(reservations.CheckOut, reservations.CheckIn)) as 'PAID'
FROM reservations INNER JOIN rooms
ON reservations.Room = rooms.RoomCode
WHERE (reservations.FirstName = 'GRANT') AND (reservations.LastName = 'KNERIEN')
ORDER BY reservations.Code ASC;


USE `INN`;
-- INN-5
-- For each reservation that starts on December 31, 2010 report the room name, nightly rate, number of nights spent and the total amount of money paid. Sort output in descending order by the number of nights stayed.
SELECT distinct
    rooms.RoomName,
    reservations.Rate,
    DATEDIFF(reservations.CheckOut, reservations.CheckIn) as 'Nights',
    reservations.Rate * (DATEDIFF(reservations.CheckOut, reservations.CheckIn)) as 'Money'
FROM reservations INNER JOIN rooms
ON reservations.Room = rooms.RoomCode
WHERE (reservations.CheckIn = '2010-12-31')
ORDER BY Nights DESC;


USE `INN`;
-- INN-6
-- Report all reservations in rooms with double beds that contained four adults. For each reservation report its code, the full name and the code of the room, check-in and check out dates. Report reservations in chronological order, then sorted by the three-letter room code (in alphabetical order) for any reservations that began on the same day.
SELECT distinct
    reservations.Code,
    rooms.RoomCode, 
    rooms.RoomName,
    reservations.CheckIn,
    reservations.CheckOut
FROM reservations INNER JOIN rooms
ON reservations.Room = rooms.RoomCode
WHERE (reservations.Adults = 4) AND (rooms.bedtype = 'Double')
ORDER BY reservations.CheckIn ASC;


USE `MARATHON`;
-- MARATHON-1
-- Report the time, pace and the overall place of TEDDY BRASEL.
SELECT 
    Place,
    RunTime,
    Pace
FROM marathon
WHERE FirstName = 'TEDDY' AND LastName = 'BRASEL';


USE `MARATHON`;
-- MARATHON-2
-- Report names (first, last), times, overall places as well as places in their gender-age group for all female runners from QUNICY, MA. Sort output by overall place in the race.
SELECT 
    FirstName,
    LastName,
    Place,
    RunTime,
    GroupPlace
FROM marathon
WHERE Sex = 'F' AND Town = 'QUNICY' AND State = 'MA'
ORDER BY Pace;


USE `MARATHON`;
-- MARATHON-3
-- Find the results for all 34-year old female runners from Connecticut (CT). For each runner, output name (first, last), town and the running time. Sort by time.
SELECT 
    FirstName,
    LastName,
    Town,
    RunTime
FROM marathon
WHERE Sex = 'F' AND State = 'CT' AND Age = 34
ORDER BY RunTime;


USE `MARATHON`;
-- MARATHON-4
-- Find all duplicate bibs in the race. Report just the bib numbers. Sort in ascending order of the bib number. Each duplicate bib number must be reported exactly once.
SELECT distinct 
    m1.BibNumber
FROM marathon m1 INNER JOIN marathon m2
ON m1.BibNumber = m2.BibNumber
WHERE (NOT m1.Place = m2.Place)
ORDER BY BibNumber ASC;


USE `MARATHON`;
-- MARATHON-5
-- List all runners who took first place and second place in their respective age/gender groups. For age group, output name (first, last) and age for both the winner and the runner up (in a single row). Order the output by gender, then by age group.
SELECT distinct
    m1.Sex,
    m1.AgeGroup,
    m1.FirstName,
    m1.LastName,
    m1.Age,
    m2.FirstName,
    m2.LastName,
    m2.Age
FROM marathon m1 INNER JOIN marathon m2
ON m1.AgeGroup = m2.AgeGroup AND m1.Sex = m2.Sex
WHERE m1.GroupPlace = 1 AND m2.GroupPlace = 2
ORDER BY Sex, AgeGroup;


USE `AIRLINES`;
-- AIRLINES-1
-- Find all airlines that have at least one flight out of AXX airport. Report the full name and the abbreviation of each airline. Report each name only once. Sort the airlines in alphabetical order.
select distinct
    airlines.Name,
    airlines.Abbr
FROM airlines INNER JOIN flights
ON airlines.Id = flights.airline
WHERE flights.source = 'AXX'
ORDER BY airlines.Name;


USE `AIRLINES`;
-- AIRLINES-2
-- Find all destinations served from the AXX airport by Northwest. Re- port flight number, airport code and the full name of the airport. Sort in ascending order by flight number.

select distinct
    flights.flightno,
    flights.destination,
    a2.Name
FROM (((airlines INNER JOIN flights
ON airlines.Id = flights.airline) INNER JOIN airports
ON flights.source = airports.Code) INNER JOIN airports a2
ON flights.destination = a2.Code)
WHERE airports.Code = 'AXX' AND airlines.Abbr = 'Northwest'
ORDER BY flights.flightno;


USE `AIRLINES`;
-- AIRLINES-3
-- Find all *other* destinations that are accessible from AXX on only Northwest flights with exactly one change-over. Report pairs of flight numbers, airport codes for the final destinations, and full names of the airports sorted in alphabetical order by the airport code.
Select distinct 
    f1.flightno, 
    f2.flightno,
    airports.code, 
    airports.name
FROM airlines, airports, flights f1, flights f2 
WHERE f1.Destination = f2.Source AND f1.Source != f2.Destination
    AND airlines.Id = f1.airline AND airlines.Id = f2.airline
    AND airlines.Abbr = 'Northwest' AND f1.Source = 'AXX'
    AND f2.Destination = airports.code
ORDER BY airports.code;


USE `AIRLINES`;
-- AIRLINES-4
-- Report all pairs of airports served by both Frontier and JetBlue. Each airport pair must be reported exactly once (if a pair X,Y is reported, then a pair Y,X is redundant and should not be reported).
select distinct
    f1.source,
    f1.destination
FROM 
    (airlines air1 INNER JOIN flights f1
    ON air1.Id = f1.airline) 
    INNER JOIN 
    (airlines air2 INNER JOIN flights f2
    ON air2.Id = f2.airline) 
WHERE air1.Abbr = 'Frontier' AND air2.Abbr = 'JetBlue'
AND f1.source = f2.source AND f1.destination = f2.destination
AND f1.source < f2.destination;


USE `AIRLINES`;
-- AIRLINES-5
-- Find all airports served by ALL five of the airlines listed below: Delta, Frontier, USAir, UAL and Southwest. Report just the airport codes, sorted in alphabetical order.
Select distinct 
    f1.source
FROM airlines a1 
    JOIN airlines a2
    JOIN airlines a3
    JOIN airlines a4
    JOIN airlines a5
    JOIN flights f1
    JOIN flights f2
    JOIN flights f3
    JOIN flights f4
    JOIN flights f5
ON a1.Id = f1.airline AND a2.Id = f2.airline AND a3.Id = f3.airline
    AND a4.Id = f4.airline AND a5.Id = f5.airline
WHERE a1.Abbr = 'Southwest' AND a2.Abbr = 'Frontier' 
    AND a3.Abbr = 'Delta' AND a4.Abbr = 'USAir' 
    AND a5.Abbr = 'UAL' AND f1.source = f2.source
    AND f2.source = f3.source AND f3.source = f4.source
    AND f4.source = f5.source
ORDER BY f1.source;


USE `AIRLINES`;
-- AIRLINES-6
-- Find all airports that are served by at least three Southwest flights. Report just the three-letter codes of the airports — each code exactly once, in alphabetical order.
select distinct 
    f1.source
FROM airlines 
    JOIN flights f1
    JOIN flights f2
    JOIN flights f3
ON airlines.Id = f1.airline AND airlines.Id = f2.airline
    AND airlines.Id = f3.airline
WHERE airlines.Abbr = 'Southwest' AND f1.source = f2.source 
    AND f2.source = f3.source AND f1.destination != f2.destination 
    AND f2.destination != f3.destination AND f1.destination != f3.destination
    ORDER BY f1.source ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-1
-- Report, in order, the tracklist for ’Le Pop’. Output just the names of the songs in the order in which they occur on the album.
SELECT 
    Songs.Title
FROM ((Albums JOIN Tracklists
ON Albums.AId = Tracklists.Album) JOIN Songs
ON Songs.SongId = Song)
WHERE Albums.Title = 'Le Pop';


USE `KATZENJAMMER`;
-- KATZENJAMMER-2
-- List the instruments each performer plays on ’Mother Superior’. Output the first name of each performer and the instrument, sort alphabetically by the first name.
SELECT  
    Band.Firsname,
    Instruments.Instrument
FROM ((Instruments JOIN Band
ON Instruments.Bandmate = Band.Id) JOIN Songs
ON Instruments.Song = Songs.SongId)
WHERE Songs.Title = 'Mother Superior'
ORDER BY Band.Firsname ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-3
-- List all instruments played by Anne-Marit at least once during the performances. Report the instruments in alphabetical order (each instrument needs to be reported exactly once).
SELECT distinct
    Instruments.Instrument
FROM (Instruments JOIN Band
ON Instruments.Bandmate = Band.Id) 
WHERE Band.Firsname = 'Anne-Marit'
ORDER BY Instruments.Instrument ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-4
-- Find all songs that featured ukalele playing (by any of the performers). Report song titles in alphabetical order.
SELECT distinct
    Songs.Title
FROM ((Instruments JOIN Band
ON Instruments.Bandmate = Band.Id) JOIN Songs
ON Instruments.Song = Songs.SongId)
WHERE Instruments.Instrument = 'ukalele'
ORDER BY Songs.Title ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-5
-- Find all instruments Turid ever played on the songs where she sang lead vocals. Report the names of instruments in alphabetical order (each instrument needs to be reported exactly once).
SELECT distinct 
    Instruments.Instrument
FROM Vocals INNER JOIN ((Instruments JOIN Band
ON Instruments.Bandmate = Band.Id) JOIN Songs
ON Instruments.Song = Songs.SongId)
ON Vocals.Song = Songs.SongId AND Vocals.Bandmate = Band.Id
WHERE Vocals.VocalType = 'lead' AND Band.FirsName = 'Turid'
    AND Band.LastName = 'Jorgensen'
ORDER BY Instruments.Instrument ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-6
-- Find all songs where the lead vocalist is not positioned center stage. For each song, report the name, the name of the lead vocalist (first name) and her position on the stage. Output results in alphabetical order by the song. (Note: if a song had more than one lead vocalist, you may see multiple rows returned for that song. This is the expected behavior).
SELECT distinct 
    Songs.Title, 
    Band.FirsName, 
    Performance.StagePosition
FROM Vocals INNER JOIN Performance 
    INNER JOIN Songs INNER JOIN Band
ON Performance.Song = Songs.SongId AND Performance.Bandmate = Band.Id 
    AND Vocals.Song = Songs.SongId AND Vocals.Bandmate = Band.Id
WHERE Performance.StagePosition != 'center' AND Vocals.VocalType = 'lead'
ORDER BY Songs.Title ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-7
-- Find a song on which Anne-Marit played three different instruments. Report the name of the song. (The name of the song shall be reported exactly once)
SELECT distinct 
    s1.Title
FROM Instruments AS i1 
INNER JOIN Instruments AS i2 INNER JOIN Instruments AS i3 
INNER JOIN Band AS b1 INNER JOIN Band AS b2 INNER JOIN Band AS b3 
INNER JOIN Songs AS s1 INNER JOIN Songs AS s2 INNER JOIN Songs AS s3
ON (i1.Bandmate = b1.Id AND i2.Bandmate = b2.Id
    AND i3.Bandmate = b3.Id AND i1.Song = s1.SongId
    AND i2.Song = s2.SongId AND i3.Song = s3.SongId)
WHERE (b1.FirsName = 'Anne-Marit' AND b1.LastName = 'Bergheim')
    AND (b2.FirsName = 'Anne-Marit' AND b2.LastName = 'Bergheim')
    AND (b3.FirsName = 'Anne-Marit' AND b3.LastName = 'Bergheim')
    AND (i1.Instrument != i2.Instrument AND i2.Instrument != i3.Instrument)
    AND (s1.SongId = s2.SongId AND s2.SongId = s3.SongId)
ORDER BY s1.Title ASC;


USE `KATZENJAMMER`;
-- KATZENJAMMER-8
-- Report the positioning of the band during ’A Bar In Amsterdam’. (just one record needs to be returned with four columns (right, center, back, left) containing the first names of the performers who were staged at the specific positions during the song).
SELECT distinct
    b1.Firsname as 'RIGHT',
    b2.Firsname as 'CENTER',
    b3.Firsname as 'BACK',
    b4.Firsname as 'LEFT'
FROM Songs INNER JOIN Band AS b1 
    INNER JOIN Band AS b2 INNER JOIN Band AS b3 
    INNER JOIN Band AS b4 INNER JOIN Performance AS p1 
    INNER JOIN Performance AS p2 INNER JOIN Performance AS p3 
    INNER JOIN Performance AS p4 
ON p1.Song = Songs.SongId AND p2.Song = Songs.SongId
    AND p3.Song = Songs.SongId AND p4.Song = Songs.SongId
    AND p1.Bandmate = b1.Id AND p2.Bandmate = b2.Id 
    AND p3.Bandmate = b3.Id AND p4.Bandmate = b4.Id
WHERE Songs.Title = 'A Bar In Amsterdam' AND p1.StagePosition = 'right'
    AND p2.StagePosition = 'center' AND p3.StagePosition = 'back'
    AND p4.StagePosition = 'left';


