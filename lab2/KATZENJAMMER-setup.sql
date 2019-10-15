DROP TABLE if exists Tracklists;
DROP TABLE if exists Vocals;
DROP TABLE if exists Performance;
DROP TABLE if exists Instruments;
DROP TABLE if exists Albums;
DROP TABLE if exists Songs;
DROP TABLE if exists Band;

CREATE TABLE Albums(
   AId INTEGER primary key,
   Title varchar(250),
   Year INTEGER,
   Label varchar(250),
   Type varchar(250)
);

CREATE TABLE Songs(
   SongId INTEGER primary key,
   Title varchar(250)
);

CREATE TABLE Band(
   Id INTEGER primary key,
   FirstName varchar(250),
   LastName varchar(250)
);

CREATE TABLE Instruments(
   SongId INTEGER,
   BandmateId INTEGER,
   Instrument varchar(250),

   foreign key (SongId) references Songs (SongId),
   foreign key (BandmateId) references Band (Id)
);

CREATE TABLE Performance(
   SongId INTEGER,
   BandmateId INTEGER,
   StagePosition varchar(250), 

   primary key (SongId, BandmateId),

   foreign key (SongId) references Songs (SongId),
   foreign key (BandmateId) references Band (Id)
);

CREATE TABLE Tracklists(
   AlbumId INTEGER,
   Position INTEGER,
   SongId INTEGER, 

   primary key (AlbumId, Position),

   foreign key (SongId) references Songs (SongId),
   foreign key (AlbumId) references Albums (AId)
);

CREATE TABLE Vocals(
   SongId INTEGER,
   BandmateId INTEGER,
   Type varchar(250), 

   foreign key (SongId) references Songs (SongId),
   foreign key (BandmateId) references Band (Id)
);
