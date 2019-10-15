DROP TABLE if exists BasicNutrients;
DROP TABLE if exists Vitamins;
DROP TABLE if exists FoodItem;

/* this setups the tables for my custom Nutrient database */

CREATE TABLE FoodItem(
   NDBnum INTEGER primary key,
   itemDesc varchar(250) 
);

CREATE TABLE BasicNutrients(
   Id INTEGER,
   Water DECIMAL(5,2),
   Energy INTEGER,
   Protein DECIMAL(5,2),
   Carbohydrt DECIMAL(5,2),
   Fiber DECIMAL(2,1),
   Sugar DECIMAL(5,2),
   Calcuim INTEGER,
   Sodium INTEGER,
   Cholestrl INTEGER,

   foreign key (Id) references FoodItem (NDBnum)
);

CREATE TABLE Vitamins(
   Id INTEGER,
   C DECIMAL(2,1),
   B6 DECIMAL(4,3),
   B12 DECIMAL(3,2),
   A_IU INTEGER,
   A_RAE INTEGER,
   E DECIMAL(3,2),
   D_mg DECIMAL(3,1),
   D_IU INTEGER,
   K DECIMAL(2,1),

   foreign key (Id) references FoodItem (NDBnum)
);
