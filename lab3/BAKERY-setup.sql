DROP TABLE if exists Items;
DROP TABLE if exists Goods;
DROP TABLE if exists Reciepts;
DROP TABLE if exists Customers;

CREATE TABLE Customers(
   Id INTEGER primary key,
   LastName varchar(250),
   FirstName varchar(250)
);

CREATE TABLE Goods(
   Id varchar(100) primary key,
   Flavor varchar(250),
   Food varchar(250),
   Price DECIMAL(4,2)
);

CREATE TABLE Reciepts(
   RecieptNumber INTEGER primary key,  
   RecDate DATE,
   CustomerId INTEGER,

   foreign key (CustomerId) references Customers (Id)
);

CREATE TABLE Items(
   Reciept INTEGER,
   Ordinal INTEGER,
   Item varchar(250), 

   primary key (Reciept, Ordinal),

   foreign key (Reciept) references Reciepts (RecieptNumber),
   foreign key (Item) references Goods (Id)
);
