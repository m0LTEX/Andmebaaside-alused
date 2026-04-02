create function dbo.GetAllCustomers_ITVF()
returns Table as
return (select * from SalesLT.Customer);

select * from dbo.GetAllCustomers_ITVF()

--1. GetAllCustomers_ITVF Koosta inline funktsioon,
--mis tagastab kõik kliendid. Tabel: SalesLT.Customer

create function GetCustomerById_itvf(@customerid int)
returns Table as
return
(select FirstName, LastName from SalesLT.Customer)
select * from GetCustomerById_itvf(1);

--2. GetCustomerByID_ITVF Koosta funktsioon,
--mis: võtab @CustomerID tagastab: FirstName LastName 

create function GetOrdersByCustomer_itvf(@CustomerId int)
returns Table as
return
(select * from SalesLT.SalesOrderHeader where CustomerID = @CustomerId);
select * from GetOrdersByCustomer_itvf(29847)

--3. GetOrdersByCustomer_ITVF Koosta funktsioon,
--mis: võtab @CustomerID tagastab kõik selle kliendi tellimused Tabel: SalesLT.SalesOrderHeader

create function GetProductsByPrice_itvf(@MinPrice money, @MaxPrice money)
returns Table as
return
(select * from SalesLT.product where ListPrice between @MinPrice and @MaxPrice);
select * from GetProductsByPrice_itvf(200, 500)

drop function GetProductsByPrice_itvf

-- 4. GetProductsByPrice_ITVF Koosta funktsioon,
--mis: võtab @MinPrice, @MaxPrice tagastab tooted hinnavahemikus Tabel: SalesLT.Product

create function GetTopExpensiveProducts_itvf()
returns Table as
return
(select top 10 * from SalesLT.product order by ListPrice desc);

select * from GetTopExpensiveProducts_itvf()

--5. GetTopExpensiveProducts_ITVF Koosta funktsioon,
--mis: tagastab TOP 10 kõige kallimat toodet OSA 2: Multi-Statement Functions (keerulisemad)

create function GetCustomerFullInfo_mstvf(@CustomerId int)
returns @result Table
(FullName nvarchar(200), Email nvarchar(100), Phone nvarchar(50))
as begin
    insert into @result
    select FirstName + ' ' + LastName, EmailAddress, Phone
    from SalesLT.Customer
    where CustomerId = @CustomerId;
    return;
end;

select * from GetCustomerFullInfo_mstvf(3)

--6. GetCustomerFullInfo_MSTVF Koosta funktsioon, mis: võtab @CustomerID tagastab tabeli,
--kus on: nimi (First + Last kokku) email telefon Tabel: SalesLT.Customer kasuta @Result TABLE 

create function GetCustomerOrderSummary_mstvf(@CustomerId int)
returns @result Table
(OrderCount int, TotalSum money)
as begin
    insert into @result select 
    count(*),
    sum(TotalDue)
    from SalesLT.SalesOrderHeader
    where CustomerId = @CustomerId;
    return;
end;

select * from GetCustomerOrderSummary_mstvf(29653)
--7. GetCustomerOrderSummary_MSTVF Koosta funktsioon,
--mis: võtab @CustomerID tagastab: tellimuste arv kogusumma Tabel: SalesLT.SalesOrderHeader



create function GetProductPriceCategory_mstvf()
returns @result Table
(ProductId int, Name nvarchar(200), ListPrice money, PriceCategory nvarchar(50))
as begin
    insert into @result
    Select ProductId, Name, ListPrice, case 
    when ListPrice < 100 then 'odav'
    when ListPrice between 100 and 1000 then 'keskmine'
    else 'kallis'
end
    from SalesLT.product;
    return;
end;

select * from GetProductPriceCategory_mstvf()

--8. GetProductPriceCategory_MSTVF Koosta funktsioon,
--mis: tagastab kõik tooted + hinnaklass: "Odav", "Keskmine", "Kallis" Tabel: SalesLT.Product

create function GetCustomersWithOrders_mstvf()
returns @result Table
(CustomerId int, FirstName nvarchar(100), LastName nvarchar(100))
as begin
    insert into @result
    select distinct c.CustomerId, c.FirstName, c.LastName
    from SalesLT.Customer c
    inner join SalesLT.SalesOrderHeader s
    on c.CustomerId = s.CustomerId;
    return;
end;

select * from GetCustomersWithOrders_mstvf()

--9. GetCustomersWithOrders_MSTVF Koosta funktsioon, mis: tagastab ainult need kliendid,
--kellel on vähemalt 1 tellimus Tabelid: SalesLT.Customer SalesLT.SalesOrderHeader


create function GetTopCustomersBySpending_mstvf()
returns @result Table
(FullName nvarchar(200), TotalSpending money)
as begin insert 
into @result
    select top 5
        c.FirstName + ' ' + c.LastName,
        sum(s.TotalDue) as TotalSpending
    from SalesLT.Customer c
    inner join SalesLT.SalesOrderHeader s
    on c.customerid = s.CustomerId
    Group By c.FirstName, c.LastName
    Order By TotalSpending desc;
    return;
end;

select * from GetTopCustomersBySpending_mstvf()

--10. GetTopCustomersBySpending_MSTVF Koosta funktsioon,
--mis: tagastab TOP 5 klienti koos: nimega kogukuluga