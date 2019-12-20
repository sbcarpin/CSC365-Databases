DROP TABLE if exists Flights;
DROP TABLE if exists Airlines;
DROP TABLE if exists Airports;

CREATE TABLE Airlines(
   Id INTEGER primary key,
   Airline varchar(250),
   Abbreviation varchar(250),
   Country varchar(20) 
);

CREATE TABLE Airports(
   City varchar(250),
   AirportCode varchar(10) primary key,
   AirportName varchar(250),
   Country varchar(250),
   CountryAbbrev varchar(10)
);

CREATE TABLE Flights(
   Airline INTEGER,
   FlightNo INTEGER,
   SourceAirport varchar(5),
   DestAirport varchar(5), 

   primary key (Airline, FlightNo),

   foreign key (Airline) references Airlines (Id),
   foreign key (SourceAirport) references Airports (AirportCode),
   foreign key (DestAirport) references Airports (AirportCode)
);








