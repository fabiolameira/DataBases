--T1SQL_FábioLameira--
--#Q01
use TSQL2012
select count(ProductID) 'totalproducts'
from Production.Products

--#Q02
select count(*) 'nondiscontinued'
from Production.Products
where supplierid = 12 and discontinued = 'False'

--#Q03
select supplierid, count(productid) 'numproducts'
from Production.Products
group by supplierid

--#Q04
select count(*) 'products'
from Production.Products
where supplierid = 4

--#Q05
select supplierid, companyname, fax 
from Production.Suppliers
where fax is NULL

--#Q06
select datepart(m, O.orderdate) as 'month',
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount)))'totalprice'
from Sales.OrderDetails OD
join Sales.Orders O on OD.orderid = O.orderid
where O.orderdate >= '2007-1-1' and O.orderdate <= '2007-12-31'
group by datepart(m, O.orderdate)
order by datepart(m, O.orderdate)

--#Q07
select sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'totalprice'
from Sales.Orders O
join Sales.OrderDetails OD on OD.Orderid = O.Orderid
where O.orderdate >= '2008-6-1' and O.Orderdate <= '2008-6-30'

--#Q08
select count(*) 'TotalOrders2008' 
from Sales.Orders
where orderdate >= '2008-1-1' and orderdate <= '2008-12-31'

--#Q09
select empid, count(orderid)'NumberOrdersByEmployee' 
from Sales.Orders
where orderdate >= '2006-1-1' and orderdate <= '2006-12-31'
group by empid

--#Q10
select empid, firstname, lastname, birthdate, FLOOR(DATEDIFF(Day, birthdate, GETDATE()) / 365.25) 'age' 
from HR.Employees

--#Q11
select FLOOR(avg(FLOOR(DATEDIFF(Day, birthdate, GETDATE()) / 365.25)))'AvgAge' 
from HR.Employees

--#Q12
select empid, firstname, lastname, hiredate
from HR.Employees
where hiredate = (select min(hiredate) from HR.Employees)

--#Q13
select empid, firstname, lastname, birthdate, FLOOR(DATEDIFF(Day, birthdate, GETDATE()) / 365.25)'age' 
from HR.Employees
where birthdate = (select min(birthdate) from HR.Employees)

--#Q14
select P.productid, P.productname, sum(OD.qty)'qty', O.shipcountry 
from Production.Products P
join Sales.OrderDetails OD on P.productid = OD.productid
join Sales.Orders O on OD.orderid = O.orderid
where O.shipcountry = 'Poland'
group by P.productid, P.productname, O.shipcountry
order by P.productid

--#Q15
select count(productid)'ProductsFromBerlin' from Production.Products P
join Production.Suppliers S on P.supplierid = S.supplierid
where S.city = 'Berlin'

--#Q16
select top 1 C.custid, C.companyname, C.city, C.country,
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'totalsales'
from Sales.OrderDetails OD
join Sales.Orders O on OD.orderid = O.orderid
join Sales.Customers C on O.custid = C.custid
group by C.custid, C.companyname, C.city, C.country
order by 'totalsales' desc

--#Q17
select top 5 C.custid, C.companyname, C.city, C.country,
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'totalsales'
from Sales.OrderDetails OD
join Sales.Orders O on OD.orderid = O.orderid
join Sales.Customers C on O.custid = C.custid
where O.orderdate >= '2007-1-1' and O.orderdate <= '2007-12-31'
group by C.custid, C.companyname, C.city, C.country
order by 'totalsales' desc

--#Q18
select top 1 OD.productid, P.productname, P.discontinued, P.unitprice,
sum(OD.qty)'totalqty'
from Sales.OrderDetails OD
join Production.Products P on OD.productid = P.productid
join Sales.Orders O on OD.orderid = O.orderid
where O.orderdate >= '2007-1-1' and O.orderdate <= '2007-12-31'
group by OD.productid, P.productname, P.discontinued, P.unitprice
order by 'totalqty' desc

--#Q19
select top 1 O.custid,
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'totalsales',
count(distinct O.orderid)'totalorders'
from Sales.Orders O
join Sales.OrderDetails OD on O.orderid = OD.orderid
group by O.custid
order by 'totalsales' desc

--#Q20
select top 1 O.shipcity,
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'totalsales'
from Sales.Orders O
join Sales.OrderDetails OD on O.orderid = OD.orderid
group by O.shipcity
order by 'totalsales' desc

--#Q21
select top 10 O.shipcity,
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'totalsales'
from Sales.Orders O
join Sales.OrderDetails OD on O.orderid = OD.orderid
group by O.shipcity
order by 'totalsales' desc

--#Q22
-- As vendas Totais a contar com os Descontos:
select O.empid, E.firstname, E.lastname,
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'salesbyemployee',
(sum(((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount)))*100.0)/(
select sum((unitprice*qty)-((unitprice*qty)*(discount))) 'totalsales' 
from Sales.OrderDetails))'percent%' 
from Sales.Orders O
join Sales.OrderDetails OD on O.orderid = OD.orderid
join HR.Employees E on O.empid = E.empid
group by O.empid, E.firstname, E.lastname
order by O.empid

-- As Vendas Totais sem contar com os Descontos:
select O.empid, E.firstname, E.lastname,
sum((OD.unitprice*OD.qty)) 'salesbyemployee',
(sum(((OD.unitprice*OD.qty))*100.0)/(
select sum((unitprice*qty)) 'totalsales' 
from Sales.OrderDetails))'percent%' 
from Sales.Orders O
join Sales.OrderDetails OD on O.orderid = OD.orderid
join HR.Employees E on O.empid = E.empid
group by O.empid, E.firstname, E.lastname
order by 'percent%' desc

--#Q23
select C.categoryid, C.categoryname, sum(OD.qty)'qty', 
(sum(OD.qty)*100.0)/(select sum(qty) from Sales.OrderDetails)'percent%' 
from Sales.OrderDetails OD
join Production.Products P on OD.productid = P.productid
join Production.Categories C on P.categoryid = C.categoryid
group by C.categoryid, C.categoryname

--#Q24
select O.shipcountry,
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'totalsales',
(sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount)))*100.0)/
(select sum((unitprice*qty)-((unitprice*qty)*(discount))) 'totalsales' from Sales.OrderDetails)'percent%'
from Sales.OrderDetails OD
join Sales.Orders O on OD.orderid = O.orderid
group by O.shipcountry
order by 'percent%' desc

--#Q25
select country, count(custid)'clientsnumber' 
from Sales.Customers
group by country

--#Q26
select top 1 country, count(custid)'clientsnumber' 
from Sales.Customers
group by country
order by count(custid)desc

--#Q27
select sum((OD.unitprice*OD.qty)*(OD.discount))'totaldiscount2007'
from Sales.OrderDetails OD
join Sales.Orders O on OD.orderid = O.orderid
where O.orderdate >= '2007-1-1' and O.orderdate <= '2007-12-31'

--#Q28
select datepart(m, O.orderdate) as 'month', sum((OD.unitprice*OD.qty)*(OD.discount))'totaldiscount'
from Sales.OrderDetails OD
join Sales.Orders O on OD.orderid = O.orderid
where O.orderdate >= '2007-1-1' and O.orderdate <= '2007-12-31'
group by datepart(m, O.orderdate)
order by datepart(m, O.orderdate)

--#Q29
select right(contactname, len(contactname)-patindex('% %', contactname))'firstname',
Left(contactname, patindex('%,%', contactname)-1)'lastname'
from Sales.Customers

--#Q30
select avg(datediff(day, orderdate, shippeddate)) as 'avgdays'
from Sales.Orders
where shippeddate > 0

--#Q31
select C.custid, C.companyname, count(O.orderid)'orders',
sum((OD.unitprice*OD.qty)-((OD.unitprice*OD.qty)*(OD.discount))) 'totalvalue',
count(OD.productid)'products'
from Sales.OrderDetails OD
join Sales.Orders O on OD.orderid = O.orderid
join Sales.Customers C on O.custid = C.custid
where C.custid = 22
group by C.custid, C.companyname
order by C.custid

select * from Sales.Customers where custid=22
-- O cliente 22 não tem qualquer encomenda --