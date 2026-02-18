-- teeme andmebaasi ehk db
create database IKT25tar

-- andmebaasi valimine
use IKT25tar


-- andmebaasi kustutamine
drop database IKT25tar

-- teeme uuesti andmebaasi IKT25tar
create database IKT25tar

-- teeme tabeli
create table Gender
(
--Meil on muutuja Id,
--mis on täisarv andmetüüp,
--kui sisetad andmed, siis see veerg peab olema täidetud
--tegemist on primaarvõtmega
Id int not null primary key,
--Veeru nimi on Gender,
--10 tähemärki on max pikkus
--andmed peavad olema sisestatud ehk
-- ei tohi olla tühi
Gender nvarchar(10) not null
)

--andmete sisestamine
--proovige ise teha
-- Id 1, Gender Male
-- Id 2, Gender Female
insert into Gender (Id, Gender)
Values (1, 'Male'),
(2, 'Female');

--vaatame tabeli sisu
-- * tähendab, et näita kõike seal sees olevat infot
select * from Gender

--teeme tabeli nimega Person
--veeru nimed: Id Int not null primary key
--Name nvarchar (30)
--Email nvarchar (30)
--Genderid int
drop table Person

Create Table Person
(
Id int not null primary key,
Age nvarchar(10),
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--näen tabelis olevat infot
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla
--väärtust, siis automaatselt sisestab sellele reale väärtuse 3
-- ehk unknown
alter table Person
add constraint DF_Persons_GenderId
Default 3 for GenderId

insert into Gender (Id, Gender)
values (3, 'Unknown')

insert into Person (Id, Name, Email, GenderId)
values (7, 'Black Panther', 'b@b.com', NULL)

insert into Person (Id, Name, Email)
values (9, 'Spiderman', 'spider@m.com')

select * from Person

--prriangu kustutamine
alter table Person
drop constraint DF_Persons_GenderId

--kuidas lisada veergu tabelile Person
--Veeru nimi on Age nvarchar(10)
alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--kuidas uuendada andmeid
update Person
set Age = 159
where Id = 7

select * from Person

--soovin kustutada ühe rea
  --kuidas seda teha
delete from Person
where Id = 8

-- lisame uue veeru City nvarchar(50)
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
--kõik, kes ei ela Gothamis
select * from Person Where City != 'Gotham'
--variant nr2. kõik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'

--näitab teatud vanusega inimesi
--valime 151, 35, 25
select * from Person Where Age In (151, 35, 23)
--Teine võimalus
select * from Person Where Age = 151 or Age = 35 or Age = 23

--soovin näha inimesi vahemikus 22 kuni 41
select * from Person Where Age between 22 and 41

--wildcard ehk näitab kõik g-tähega linnad
select * from Person Where City Like 'g%';
--otsib emailid @-märgiga
select * from Person Where Email like '%@%';

--tahan näga, kellel on emailis ees ja peale @-märki üks täht
select * from Person Where Email like '_@_.com'

--kõik, kelle nimes ei ole esimene täht W, A, S
select * from Person Where Name like '[^WAS]%'

--kõik, kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

--kõik, kes elavad Gothamis ja New Yorkis ning peavad olema
--vanemad, kui 29
select * from Person where (City = 'Gotham' or City = 'New York' and Age > 29)