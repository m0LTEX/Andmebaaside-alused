--teeme andmebaasi e db
create database IKT25tar

--andmebaasi valimine
use master

--andmebaasi kustutame koodiga
--andmebaasi kustutamine
DROP DATABASE IKT25tar


--Meil on muutuja Id,
--mis on täisarv andmetüüp,
--kui sisestad arndme, siis see veerg peab olema täidetud,
--tegemist on primaarvõtmega
create table Gender
(
Id int not null primary key,
--veeru nimi on Gender,
--10 tähemärki ma max pikkus,
--andmed peavad olema sisestatud e
--ei tohi olla tühi
Gender nvarchar(10) not null
)

--andmete sisestamine Gender tabelisse
--proovige ise teha
-- Id = 1, Gender Male
-- Id = 2, Gender Female
INSERT INTO Gender (Id, Gender)
Values (1, 'Male'),
(2, 'Female');

--vaateame trabeli sisu
-- * tähendab, et näita kõike seal sees olevat infot
select * from Gender

--teeme tabeli nimega Perðon
-- veeru nimed: Id int not null primary key,
--Name nvarchar (30)
--Email nvarchar (30)
--Genderid int
Create table person
(
Id int not null primary key,
Name nvarchar (30),
Email nvarchar (30),
GenderId int
)
