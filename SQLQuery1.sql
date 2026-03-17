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

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks 
-- Name veeru
select * from Person
select * from Person order by Name

--võtab kolm esimest rida Person tabelist
select top 3 * from Person

--tund 3
--25.02.2026
--kolm esimest, aga tabeli järjestus on Age ja siis Name
select top 3 Age, Name from Person

--näita esimesed 50% tabelist
select top 50 percent * from Person
select * from Person

--järjestab vanuse järgi isikud
select * from Person order by Age desc

--muudab Age muutuja int-ks ja näitab vanuselises järjestuses
-- cast abil saab andmetüüpi muuta
select * from Person order by cast(Age as int) desc

-- kõikide isikute koondvanus e liidab kõik kokku
select sum(cast(Age as int)) from Person

--kõige noorem isik tuleb üles leida
select min(cast(Age as int)) from Person

--kõige vanem isik
select max(cast(Age as int)) from Person

--muudame Age muutuja int peale
-- näeme konkreetsetes linnades olevate isikute koondvanust
select City, sum(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
alter table Person 
alter column Name nvarchar(25)

-- kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i 
-- TotalAge-ks
--järjestab City-s olevate nimede järgi ja siis Genderid järgi
--kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

--näitab, et mitu rida andmeid on selles tabelis
select count(*) from Person

--näitab tulemust, et mitu inimest on Genderid väärtusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '1'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ära
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '2'
group by GenderId, City having sum(Age) > 41

--loome tabelid Employees ja Department
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

---
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
---

--arvutab k]ikide palgad kokku Employees tabelist
select sum(cast(Salary as int)) from Employees --arvutab kõikide palgad kokku
-- kõige väiksema palga saaja
select min(cast(Salary as int)) from Employees

--näitab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--grupitab Locationiga
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location

--rida 257
-- 4 tund

select * from Employees
select SUM(cast(Salary as int)) from Employees

--lisame veeru City ja pikkus on 30

alter table Employees
add City nvarchar(30)

select City, Gender, SUM(cast(Salary as int)) as TotalSalary
from Employees
group by City, Gender

--peaaegu sama päring, aga linnad on tähestikulises järjestuses
select City, Gender, SUM(cast(Salary as int)) as TotalSalary
from Employees
group by City, Gender order by City

--on vaja teada, etmitu inimest on nimekirjas

Select COUNT(*) From Employees

--mitu töötajat on soo ja linna kaupa töötamas
select City, Gender, SUM(cast(Salary as int)) as TotalSalary,
COUNT(Id) as [Total Employee(s)]
from Employees
group by Gender, City

--kuvab kas naised või mehed linnade kaupa
--kasutage where

select City, Gender, SUM(cast(Salary as int)) as TotalSalary,
COUNT(Id) as [Total Employee(s)]
from Employees
Where Gender = 'Male'
group by Gender, City

--sama tulemus nagu eelmine, aga kasutame having

select City, Gender, SUM(cast(Salary as int)) as TotalSalary,
COUNT(Id) as [Total Employee(s)]
from Employees
group by Gender, City
Having Gender = 'Male'

--kõik kes teenivad rohkem kui 4000 (variandis peab error tulema)
select * from Employees
where SUM(cast(Salary as int)) > 4000

--teeme variandi, kus saame tulemuse
select  Gender, City, SUM(cast(Salary as int)) as TotalSalary,
COUNT(Id) as [Total Employee(s)]
from Employees
group by Gender, City
having SUM(CAST(salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')
select * from Test1

--kustutame veeru nimega City Employees tabelist
alter table Emloyees 
drop column City

--inner join
--kuvab neid, kellel on DepartmentName al olemas väärtus
--mitte kattuvad read eemaldtakse tulemusest
--ja sellepärast ei näidata Jamesi ja Russelit tabelis
--kuna neil on DepartmentId NULL
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department 
on Employees.DepartmentId = Department.Id

--left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department --võib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--uurige, mis on left join
--näitab andmeid, kus vasakpoolsest tabelist isegi, siis kui sela puudub
--mõnes reas väärtus

--right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department --võib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join näitab paremas (Department) tabelis olevaid väärtuseid,
--mis ei ühti vasaku (Employees) tabeliga

--outer join
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department 
on Employees.DepartmentId = Department.Id
--mõlema tabeli read kuvab

--teha croos join
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department 
--korrutab kõik omavahel läbi

--teha left join, kus Employees tabelist Department on null
select Name, Gender, Salary, DepartmentName
from Employees
left join Department 
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL

--teine variant ja sama tulemus
select Name, Gender, Salary, DepartmentName
from Employees
left join Department 
on Employees.DepartmentId = Department.Id
where Department.Id is NULL
--näitab ainult neid, kellel on vasakus tabelis (Employees)
--DepartmentId null

select Name, Gender, Salary, DepartmentName
from Employees
right join Department 
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL
--näitab ainult paremas tabelis olevat rida, 
--mis ei kattu Employees-ga.

--full join
--mõlema tabeli mitte-kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department 
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is NULL
or Department.Id is null

--teete ArventureWorksLT2019 andmebaasile join päringuid:
--inner join, left join, right join, cross join ja full join
--tabeleid sellesse andmebaasi juurde ei tohi teha

USE AdventureWorksLT2019
select NameStyle, Title, FirstName
from SalesLT.Customer
cross join SalesLT.CustomerAddress

USE AdventureWorksLT2019
select NameStyle, Title, FirstName
from SalesLT.Customer
inner join SalesLT.CustomerAddress
on SalesLT.CustomerAddress.CustomerId = SalesLT.Customer.CustomerId

USE AdventureWorksLT2019
select NameStyle, Title, FirstName
from SalesLT.Customer
left join SalesLT.CustomerAddress
on SalesLT.CustomerAddress.CustomerId = SalesLT.Customer.CustomerId

USE AdventureWorksLT2019
select NameStyle, Title, FirstName
from SalesLT.Customer
right join SalesLT.CustomerAddress
on SalesLT.CustomerAddress.CustomerId = SalesLT.Customer.CustomerId

USE AdventureWorksLT2019
select NameStyle, Title, FirstName
from SalesLT.Customer
full join SalesLT.CustomerAddress
on SalesLT.CustomerAddress.CustomerId = SalesLT.Customer.CustomerId
where SalesLT.CustomerAddress.CustomerId is NULL
or SalesLT.customer.CustomerId is NULL

--Mõnikord peab muutuja ette kirjutama tabeli nimetuse nagu on Prodyct.Name,
--et editor saaks aru, et kumma tabeli muutujat soovitatakse kasutada ja ei tekiks
--segadust 
select Product.Name as [Product Name], ProductNumber, ListPrice,
ProductModel.Name as [Product Model Name],
Product.productModelId, ProductModel.ProductModelId
--mõnikord peab ka tabeli ette kirjutama täpsustuse info
--nagu on SalesLT.Product
from SalesLT.Product
inner join SalesLT.ProductModel
--antud juhul Producti tabelis ProductModelId võõrvõti,
--mis ProdustModeli tabelis on primaatvõti
on Product.ProductModelId = ProductModel.ProductModelId

select isnull('Ingvar', 'No Manager') as Manager

--NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

alter table Employees 
add ManagerId int

--neile, kelle ei ole ülemust, siis paneb No Manager teksti
--kasutage left joini
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--kasutame inner joini
--kuvab ainult ManagerId all olevate isikute väärtused
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--kõik saavad kõikide ülemused olla
select E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
cross join Employees M

--lisame Employees tabelisse uued veerud
alter table Employees
add MiddleName nvarchar (30)

alter table Employees
add LastName nvarchar (30) 

select * from Employees 

--muudame olemasoleva veeru nimetust
sp_rename 'Employees.Name', 'FirstName'

sp_rename 'Employees.FristName', 'FirstName'

select * from Employees
update Employees set MiddleName = '007' where Id = 9
update Employees set MiddleName = 'Balerine' where Id = 8
update Employees set MiddleName = 'Nick' where Id = 1
update Employees set MiddleName = 'Todd' where Id = 5
update Employees set MiddleName = 'Ten' where Id = 6
update Employees set FirstName = NULL where Id = 5
update Employees set FirstName = NULL where Id = 10
update Employees set LastName = 'Crowe' where Id = 10
update Employees set LastName = 'Bond' where Id = 9
update Employees set LastName = 'Connor' where Id = 7
update Employees set LastName = 'Sven' where Id = 6
update Employees set LastName = 'Someone' where Id = 5
update Employees set LastName = 'Smith' where Id = 4
update Employees set LastName = 'Anderson' where Id = 2
update Employees set LastName = 'Jones' where Id = 1

--igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
select * from Employees
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

--loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)


--sisestame tabalisse andmeid
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutane union all, mis näitab kõiki ridu
--union all ühendab tabelid ja näitab sisu

select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtustega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
Order by Name

--stored procedure
--tavaliselt pannakse nimetuse ette sp, mis tähendab stored procedure
create procedure spGetEmployees
as begin
select FirstName, Gender from Employees
end

--nüüd saab kasutada selle nimelist sp-d 
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGederAndDepartment
--@ tähendab muutjat
@Gender nvarchar(20),
@DepartmentId int
as begin
select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
AND DepartmentId = @DepartmentId
end

EXECute spGetEmployeesByGenderAndDepartment

--kui nüüd allolevat käsklust käima panna, siis nõuab gender parameetrit
spGetEmployeesByGenderAndDepartment

--õige variant
spGetEmployeesByGenderAndDepartment 'Male', 1	
spGetEmployeesByGenderAndDepartment 'Female', 3	

--niimodi sp kirja pandud järjekorrast mööda minna, kui ise paned muut
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender= 'Male'

--saab sp sisu vaadata result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta sp-d ja panna sinna võti peale, et keegi teine peale teie ei saaks muuta
--kuskile tuleb lisada with encryption
alter proc spGetEmployeesByGederAndDepartment
@Gender nvarchar(20),
@DepartmentId int 
with encryption
as begin
select FirstName, Gender, @DepartmentId from Employees where Gender = @Gender
and DepartmentId = @DepartmentId

--sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output 
as begin
select @EmployeeCount = COUNT(Id) from Employees where Gender = @Gender
end

--annab tulemuse, kus loendab ära nõuetele vastavad read 
--prindib ka tulemuse kirja teel
--tuleb teha declare muutja @TotalCount, mis on int
--execute spGetEmployeeCountByGender sp, kus on parameetrid Male ja TotalCount
--if ja else, kui TotalCount = 0, siis tuleb tekst TotalCount is null
--lõpus kasuta print @TotalCounti puhul


declare @TotalCount int

-- Stored procedure
execute spGetEmployeeCountByGender 'Male', @TotalCount out
if(@TotalCount = 0)
print '@TotalCount is null'
else 
print '@Total is not null'
print @TotalCount
--lõpus kasuta print @TotalCounti puhul

--näitab ära, mitu rida vastab nõuetele

--deklareerime muutuja @TotalCount, mis on int andmetüüp
declare @TotalCount int
--käivitame stored procedure spGetEmployeeCountByGender sp, kus on parameetrid
--@EmployeeCount = @TotalCount out ja @Gender
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender= 'Male'
--prindib konsooli välja, kui TotalCount on null või mitte null
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
--tabeli info vaatamine
sp_help Employees
--kui soovid sp teksti näha, siis
sp_helptext spGetEmployeeCountByGender

--vaatame, millest sõltub meie valitud sp
sp_depends spGetEmployeeCountByGender
--näitab, et sp sältub Employees tabelist, kuna seal on count(Id)
--ja Id on Employees tabelis

--vaatame tabelit
sp_depends Employees

--teeme sp, mis annab andmeid Id ja Name veeruga kohta Employees tabelis
create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees 
end

--annab kogu tabeli ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = count(Id) from Employees
end

--on vaja teha uus päring, kus kasutame spTotalCount2 sp-d,
--et saada tabeli ridade arv
--tuleb deklareerida muutuja @TotalCount, mis int andmetüüp
--tuleb execute spTotalCount2, kus on parameeter @TotalCount = @TotalCount out
declare @TotalCount int

execute spTotalCount2
@TotalCount = @TotalCount out
select @TotalCount

--mis Id all on keegi nime järgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(20) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end

--annab tulemuse, kus id 1(Seda numbrit saab muuta) real on keegi koos nimeg
--print tuleb kasutada, et näidata tulemust
declare @FirstName nvarchar(20)
execute spGetNameById1 1, @FirstName output
print 'Name of the employee = ' + @FirstName

--tehke sama, mis eelmine, aga kasutage spGetNameById sp-d
--FirstName lõpus on out
declare @FirstName nvarchar(20)
execute spGetNameById 1, @FirstName outprint 'Name = ' +@FirstName

--output tagastab muudetud read kohe päringu tuemusena
--see on salvestatud protseduuris ja ühe väärtuse tagastamine 