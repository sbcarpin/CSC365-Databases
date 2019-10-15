DROP TABLE if exists Reservations;
DROP TABLE if exists Rooms;

CREATE TABLE Rooms(
   RoomId varchar(20) primary key,
   roomName varchar(250),
   beds INTEGER,
   bedType varchar(100),
   maxOccupancy INTEGER,
   basePrice INTEGER,
   decor varchar(100)
);

CREATE TABLE Reservations(
   Code INTEGER primary key,
   Room varchar(20),
   CheckIn DATE,
   CheckOut DATE,
   Rate DECIMAL(6,2),
   LastName varchar(100),
   FirstName varchar(100),
   Adults INTEGER,
   Kids INTEGER,

   foreign key (Room) references Rooms (RoomId)
);
