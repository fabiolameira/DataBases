-- Exemplo 46
use vendas
select max(OrderQty) from Saleslt.Salesorderdetail
select min(OrderQty) from Saleslt.Salesorderdetail
select avg(OrderQty) from Saleslt.Salesorderdetail

select count(*) from Saleslt.Salesorderdetail
where OrderQty < (select avg(OrderQty) from Saleslt.Salesorderdetail)

select * from Saleslt.Salesorderheader
where TotalDue=(select Max(TotalDue)
	from Saleslt.Salesorderheader)

select * from Saleslt.customer
where CustomerID = (select CustomerID from Saleslt.Salesorderheader
					where TotalDue=(select Max(TotalDue) from Saleslt.Salesorderheader))

-- Exemplo 47 - Funções de Data/Horas
select getdate() 'Data/Horas actual'

-- Exemplo 48
select getdate(), day(getdate())'Dia', month(getdate())'Mês', year(getdate())'Ano'

-- Exemplo 49
use Exames
select data, day(data), month(data), year(Data) from Exames

-- Exemplo 50
select getdate(), datepart(dw,getdate()), datepart(dy,getdate()), datepart(wk,getdate()), datepart(qq,getdate())
select getdate(), datename (mm,getdate()), datename (dw,getdate())

-- Exemplo 51
use Exames
select datename(dw,data) as B, datepart(wk, data) as A, data from Exames
order by A, B

-- Exemplo 52
select datediff(day, '12-12-2008','12-12-2009')
select datediff(month, '12-12-2008','12-12-2009')
select datediff(year, '12-12-2008','12-12-2009')

-- Exemplo 53
use Vendas
select datediff(day, orderdate, shipdate) from Saleslt.salesorderheader

-- Exemplo 54
use prodados
select datediff(day, orderdate, shippeddate) from orders
select max(datediff(day, orderdate, shippeddate)) from orders
select min(datediff(day, orderdate, shippeddate)) from orders
select avg(datediff(day, orderdate, shippeddate)) from orders

-- Exemplo 55
use Exames
select datediff(day, min(data), max(data)) from exames
where IDEpoca = 1

-- Exemplo 56 e 57
select Data, isdate(data), IDEpoca, isdate(IDEpoca) from Exames

-- Exemplo 58
use Vendas
select SalesOrderNumber, 
	Len(SalesOrderNumber) 'Len',
	Left(SalesOrderNumber, 2) 'Left',
	Right(SalesOrderNumber, 2) 'Right',
	Substring(SalesOrderNumber, 3, 2) 'Substring',
	Reverse(SalesOrderNumber) 'Reverse',
	Lower(SalesOrderNumber) 'Lower',
	Replace(SalesOrderNumber, 'S', 'X') 'Replace',
	Replicate(SalesOrderNumber, 2) 'Replicate',
	Stuff(SalesOrderNumber, 3, 3, 'HHH') 'Stuff',
	Patindex('%1%', SalesOrderNumber) 'Patindex'
from Saleslt.SalesOrderHeader

-- Exemplo 59
select emailaddress,
	Len(emailaddress)'Len',
	Patindex('%@%', emailaddress)-1'Patindex',
	Left(emailaddress, patindex('%@%', emailaddress)-1)'UserName',
	right(emailaddress, len(emailaddress)-patindex('%@%', emailaddress))'Server'
from Saleslt.Customer

-- Exemplo 60
select '   texto', len('   texto')'Contagem com Espaços'
select ltrim('   texto'), len(ltrim('   texto'))'Contagem sem Espaços'
select rtrim('texto   '), len(rtrim('texto   '))'Contagem sem Espaços'

-- Exemplo 61
use Exames
select área, count(*)'Docentes por área' from Docentes
group by área

-- Exemplo 62
select CD.IDCurso, Curso, count(*)'Disciplinas' from cursosdisciplinas CD, Cursos C
where CD.IDCurso = C.IDCurso
group by CD.IDCurso, curso

-- Exemplo 63
use Vendas
select P.ProductModelID, PM.Name, count(*)'Número de Modelos' from Saleslt.product P, Saleslt.ProductModel PM
where P.ProductModelID = PM.ProductModelID 
group by P.ProductModelID, PM.Name

-- Exemplo 64
select P.ProductCategoryID, PC.name, count(*)
from saleslt.product P, saleslt.ProductCategory PC
where P.ProductCategoryID = PC.ProductCategoryID
group by P.ProductCategoryID, PC.name

-- Exemplo 65
select P1.ParentProductCategoryID, 
(select P2.Name from SalesLT.ProductCategory as P2
	where P1.ParentProductCategoryID = P2.ProductCategoryID), 
	count(*) 
from Saleslt.ProductCategory as P1
group by P1.ParentProductCategoryID

-- Na Tabela ADDRESS quantos clientes tenho por Cidade?
select City, count(*) from Saleslt.Address
group by City
order by count(*) desc

-- Exemplo 66
select City, count(*) from Saleslt.Address
group by City
having count(*) > 10
order by count(*) desc

-- Exemplo 67 - Listar as Categorias de Produto com mais que 10 Produtos
select ProductCategoryID, count(*) from Saleslt.Product
group by ProductCategoryID
having count(*) > 10

-- Exempo 68
select ProductID, Name, Size =
	Case Size
		When 'S' Then 'Pequeno'
		When 'M' Then 'Médio'
		When 'L' Then 'grande'
		else Size
	End
from Saleslt.Product

-- Exemplo 69
select ProductId, Name, 'Nível'=
	Case
		When ListPrice = 0 Then 'Nível 0'
		When ListPrice < 50 Then 'Nível 1'
		When ListPrice >= 50 and ListPrice < 250 Then 'Nível 2'
		When ListPrice >= 250 and ListPrice < 1000 Then 'Nível 3'
		Else 'Nível 4'
	End
from Saleslt.Product
order by Nível

-- Exemplo 74
use Vendas
select PC.ProductCategoryID, PC.Name, P.ProductID, P.Name
from Saleslt.ProductCategory PC
join Saleslt.product P
on PC.ProductCategoryID = P.ProductCategoryID

use Vendas
select PC.ProductCategoryID, PC.Name, P.ProductID, P.Name
from Saleslt.ProductCategory PC
left join Saleslt.product P
on PC.ProductCategoryID = P.ProductCategoryID

use Vendas
select PC.ProductCategoryID, PC.Name, P.ProductID, P.Name
from Saleslt.ProductCategory PC
right join Saleslt.product P
on PC.ProductCategoryID = P.ProductCategoryID

-- Exemplo 75
select C.CustomerID, FirstName, LastName, SalesOrderID from Saleslt.Customer C
	left join Saleslt.SalesOrderHeader SOH
	on C.CustomerID = SOH.CustomerID

-- Que Produtos Comprou o Cliente ID 295?
select C.CustomerID, SOH.SalesOrderID, SOD.ProductID, P.Name, SOD.OrderQty 
from Saleslt.Customer C 
join Saleslt.SalesOrderHeader SOH
on C.CustomerID = SOH.CustomerID
	join Saleslt.SalesOrderDetail SOD
	on SOH.SalesOrderID = SOD.SalesOrderID
		join Saleslt.Product P
		on SOD.ProductID = P.ProductID
where C.CustomerID = 142

-- Qual a Quantidade Vendida por Producto?
select SOD.ProductID, P.Name, sum(orderQty) 
from SalesLt.SalesOrderDetail SOD
join Saleslt.Product P
on SOD.ProductID = P.ProductID
group by SOD.ProductID, P.Name
order by sum(orderQty) desc

-- Exemplo 79
use Vendas
select * from SalesLT.Product
where Color = 'Blue'
union
select * from SalesLT.Product
where Color = 'Silver'

-- Exemplo 80
use Exames
select * from ExamesSalas ES
join Exames E on ES.IdExame = E.IdExame
where IdSala = 17 and IdEpoca = 1
intersect
select * from ExamesSalas ES
join Exames E on ES.IdExame = E.IdExame
where Hora = '13:30'

-- Exemplo 81
use Exames
select * from ExamesSalas ES
join Exames E on ES.IdExame = E.IdExame
where IdSala = 17 and IdEpoca = 1
Except
select * from ExamesSalas ES
join Exames E on ES.IdExame = E.IdExame
where Hora = '13:30'