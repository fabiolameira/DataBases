-- SQLQuery_TSQL
use ProDados

-- Declarar uma Variável
declare @A int, @A1 nvarchar(25)
select @A 'A', @A1 'A1'

-- Atribuir Valor a uma Variável
set @A = 1
set @A1 = 'Valor'
select @A 'A', @A1 'A1'

declare @ID nvarchar(10)
set @ID = 'BLAUS'
select * from Customers
where CustomerID = @ID

declare @ID nvarchar(10), @NomeCliente nvarchar(50)
set @ID = 'BLAUS'
select @NomeCliente = CompanyName from Customers
where CustomerID = @ID
print @NomeCliente

-- Variaveis de sistema
select @@LANGUAGE
select @@SERVERNAME
select @@SPID
select @@VERSION
select @@IDENTITY

-- Declarar Variavel do Tipo 'Table'
declare @TableBackup table (IDProduto int primary key,
NomeProduto nvarchar(50))

insert into @TableBackup values (1, 'A')
insert into @TableBackup values (2, 'B')
select * from @TableBackup

-- Criar Tabela Temporária Local (#)
create table #TableBackup (
IDProduto int primary key,
NomeProduto nvarchar(50))
select * from #TableBackup

-- Criar Tabela Temporária Globais (##)
create table ##TableBackup (
IDProduto int primary key,
NomeProduto nvarchar(50))
select * from #TableBackup

-- Uso do Print (Converter Int para Char)
declare @A int
set @A = 96
print 'O Resultado é: ' +cast(@A as nvarchar(10))
print 'O Resultado é: ' +convert(nvarchar(10), @A)

-- Uso do Print (Converter Date para Char)
declare @DT as date
set @DT = getdate()
print @DT
print 'Data de Hoje: ' +cast(@DT as nvarchar(10))
print 'Data de Hoje: ' +convert(nvarchar(10),@DT)

-- Uso do While
declare @A int, @B int
set @A = 1
set @B = 10

while @A <= @B
begin
print 'A --> ' +convert(nvarchar(2),@A)
set @A = @A + 1
end

-- Uso do If Else
declare @Total int
select @Total = count(*) from Orders
print @Total

if @Total > 500
print 'Vendas Excelentes!'
else
print 'Vendas Inferiores à média'

-- Uso do While - Exemplo 13 - Pág.167 Sebenta
print 'Início da Contagem'
declare @Contador int, @Date datetime
set @Contador = 0
set @Date = getdate()
print 'Data de Hoje: ' +convert(nvarchar(12), @Date)

while @Contador <= 8
begin
print convert(nvarchar(10), @Contador) +' - ' +convert(nvarchar(12),@Date) +' ' +datename(weekday, @Date)
set @Contador = @Contador + 1
set @Date = @Date + 1
end

-- Uso do While - Exemplo 14 - Pág.167 Sebenta
create table #RelatorioDiario(
ID int identity(1,1) primary key,
Data smalldatetime,
Total bigint)

declare @DTI datetime, @DTF datetime
set @DTI = '1-1-2018'
set @DTF = @DTI + 365
print @DTI
print @DTF

while @DTI < @DTF
begin
insert into #RelatorioDiario (Data)
values (@DTI)
set @DTI = @DTI + 1
end

select * from #RelatorioDiario

-- Uso do While para Criar Relatório Diário nas Vendas da Prodados (Update)
create table #RelatorioDiario1997(
ID int identity(1,1) primary key,
Data smalldatetime,
Total bigint)

declare @DTI datetime, @DTF datetime
set @DTI = '1-1-1997'
set @DTF = @DTI + 365
print @DTI
print @DTF

while @DTI < @DTF
begin
insert into #RelatorioDiario1997 (Data)
values (@DTI)
set @DTI = @DTI + 1
end

select * from #RelatorioDiario1997

update #RelatorioDiario1997 set Total = (
select sum(OD.UnitPrice * OD.Quantity) from Orders O
join OrderDetails OD on O.OrderID = OD.OrderID
where O.OrderDate = #RelatorioDiario1997.Data)

-- Uso do While para Criar Relatório Diário nas Vendas da Prodados (Tudo dentro do mesmo While)
truncate table #RelatorioDiario1997
declare @DTI datetime, @DTF datetime
set @DTI = '1-1-1997'
set @DTF = @DTI + 365
print @DTI
print @DTF

while @DTI < @DTF
begin
insert into #RelatorioDiario1997 (Data, Total)
values (@DTI,(select sum(OD.UnitPrice * OD.Quantity) from Orders O
join OrderDetails OD on O.OrderID = OD.OrderID
where O.OrderDate = @DTI))
set @DTI = @DTI + 1
end

select * from #RelatorioDiario1997

-- Criar Procedimento - Exemplo 18 - Pág.171
use ProDados
Select * from Employees

create proc pr_NomeCompleto as 
select TitleOfCourtesy +' ' +FirstName +' ' +LastName 'Nome Completo' 
from Employees

exec pr_NomeCompleto

-- Criar Procedimento com Variável de Entrada
create proc pr_NomeCompletoIndividual @ID int as 
select TitleOfCourtesy +' ' +FirstName +' ' +LastName 'Nome Completo' 
from Employees
where EmployeeID = @ID

-- Executar o Procedimento com a Variável de Entrada
exec pr_NomeCompletoIndividual 5

-- Criar Procedimento que lista todos os Clientes com base no 'Country'
create proc pr_ListarClientes @Country nvarchar(20) as
select * from Customers
where Country = @Country

exec pr_ListarClientes 'France'

-- Alterar Procedimento para Exibir Mensagem Caso o País não exista e deixar o códico encriptado
alter proc pr_ListarClientes @Country nvarchar(20) with encryption as
if exists (select * from Customers
where Country = @Country)
select * from Customers
where Country = @Country
else
print 'O País não Existe'

exec pr_ListarClientes 'Frances'
exec sp_helptext pr_ListarClientes

-- Uso de Procedimentos para listar os Produtos com Duas Variáveis de Entrada (SupplierID, CategoryID)
create proc pr_ListarProdutos @S int, @C int as
select * from Products
where SupplierID = @S and CategoryID = @C

exec pr_ListarProdutos 2, 2

-- Alterar Procedimento para listar os Produtos com Variaveis definidas por Defeito
alter proc pr_ListarProdutos @S int = 1, @C int = null as
if @C is null
select * from Products
where SupplierID = @S
else
select * from Products
where SupplierID = @S and CategoryID = @C

exec pr_ListarProdutos @S = 1, @C = 2

-- Uso do Argumento OUTPUT
create proc pr_TesteOUTPUT @Valor1 int, @Valor2 int OUTPUT as
print @Valor1
print @Valor2
set @Valor2 = @Valor1 * @Valor2

declare @A int
set @A = 98 
exec pr_TesteOUTPUT 34, @Valor2 = @A OUTPUT
print @A

-- Uso do Argumento OUTPUT V2
create proc pr_TesteOUTPUT2 (@Valor1 int, @Valor2 int) as
print @Valor1
print @Valor2
set @Valor2 = @Valor1 * @Valor2
return @Valor2

declare @A int
exec @A = pr_TesteOUTPUT2 2, 5
print @A

-- Criar Procedimento com Variáveis da Tabela (ValorEntrada = ProductID, ValorSaida = UnitPrice)
create proc pr_ObterPU @ProductID nvarchar(10) OUTPUT as
set @ProductID = (select UnitPrice from Products
where ProductID = @ProductID)

declare @A nvarchar(10)
set @A = '10'
exec pr_ObterPU @ProductID = @A OUTPUT
print @A

-- Exemplo 29 - Pág. 180 Sebenta
create proc pr_BackupDados as
declare @ProductsTemp table (
[ProductID] [int] primary key,
[ProductName] [nvarchar](40) not null,
[SupplierID] [int] null,
[CategoryID] [int] null,
[QuantityPerUnit] [nvarchar](20) null,
[UnitPrice] [money] null,
[UnitsInStock] [smallint] null,
[UnitsOnOrder] [smallint] null,
[ReorderLevel] [smallint] null,
[Discontinued] [bit] not null)
insert into @ProductsTemp select * from Products
select * from @ProductsTemp

declare @OrdersBackUp table (
[OrderID] [int] primary key,
[CustomerID] [nchar](5) null,
[EmployeeID] [int] null,
[OrderDate] [datetime] null,
[RequiredDate] [datetime] null,
[ShippedDate] [datetime] null,
[ShipVia] [int] null,
[Freight] [money] null,
[ShipName] [nvarchar](40) null,
[ShipAddress] [nvarchar](60) null,
[ShipCity] [nvarchar](15) null,
[ShipRegion] [nvarchar](15) null,
[ShipPostalCode] [nvarchar](10) null,
[ShipCountry] [nvarchar](15) null)
insert into @OrdersBackUp select * from Orders
select * from @OrdersBackUp

exec pr_BackupDados

-- Exemplo 30 - Pág. 180 Sebenta
alter proc pr_CompararProdutos @P1 int, @P2 int as
if exists (select ProductID from Products where ProductID = @P1)
print 'Produto P1: ' +convert(nvarchar(5),@P1) +' Existe'
else
print 'Produto P1: ' +convert(nvarchar(5),@P1) +' Não Existe'

if exists (select ProductID from Products where ProductID = @P2)
print 'Produto P1: ' +convert(nvarchar(5),@P2) +' Existe'
else
print 'Produto P1: ' +convert(nvarchar(5),@P2) +' Não Existe'
print '---------------------------------------------------------------------------------'

select ProductName, sum(Quantity) 'Quantidade Vendida', sum(OD.Quantity*OD.UnitPrice) 'Montante Total' from Products P
join OrderDetails OD on P.ProductID = OD.ProductID
where P.ProductID = @P1 or P.ProductID = @P2
group by ProductName

exec pr_CompararProdutos 8, 9

-- Exemplo 31 - Pág. 181 Sebenta
alter proc pr_TopClientes @Product int, @Top int as
declare @ProductName nvarchar(40)
set @ProductName = (select ProductName from Products where ProductID = @Product)
declare @TotalQty decimal (6,2)
set @TotalQty = (select sum(Quantity) from OrderDetails where ProductID = @Product group by ProductID)
if exists (select ProductID from Products where ProductID = @Product)
begin
print 'Produto ' +convert(nvarchar(10),@Product) + ' - ' +@ProductName
print 'Quantidade Total Vendida - ' +convert(nvarchar(10),@TotalQty)
print '-----------------------------------------------------------------------------------------------------------------'
select top (@Top) C.CompanyName, C.Country, sum(OD.Quantity)'Quantidade Total', sum(OD.Quantity)/@TotalQty'Percent%'
from OrderDetails OD
join Orders O on OD.OrderID = O.OrderID
join Customers C on O.CustomerID = C.CustomerID
where OD.ProductID = @Product
group by C.CompanyName, C.Country
order by 'percent%' desc
end

else
print 'Produto ' +convert(nvarchar(10),@Product) + ' - ' +' Não Existe'

exec pr_TopClientes 2, 3

-- Exemplo 37 - Pág. 190 Sebenta -- Não Permite que um Dado seja Alterado - !!IMPORTANTE!!
use ProDados

create trigger tr_Employees_LastName on Employees
after update as
	if update (LastName)
		begin
			print 'Não pode alterar este campo'
			rollback tran
			return
		end

select * from Employees
update Employees set LastName = 'Fullerr' where EmployeeID = 2

--Exemplo 38
create table TabelaExemplo38
(ID int identity (1,1) primary key,
Custo money not null,
IVA decimal (18,2) not null,
Total as (Custo + (Custo*IVA)))

insert into TabelaExemplo38 (Custo, IVA) values (10, 0.23)
select * from TabelaExemplo38
-- Imaginando que alguém está a tentar alterar o Total
insert into TabelaExemplo38 (Custo, IVA, Total) values (10, 0.23, 9)

-- Criar View
create view View_TabelaExemplo38 as
select ID, Custo, IVA, Total from TabelaExemplo38

select * from View_TabelaExemplo38
insert into View_TabelaExemplo38 (Custo, IVA, Total) values (100, 0.23, 95)

-- Crirar Trigger - Este Trigger seleceiona apenas a informação que interessa
create trigger TrigerExemplo38 on View_TabelaExemplo38 instead of insert as
	begin
		insert into TabelaExemplo38 (Custo, IVA)
		select Custo, IVA from inserted
	end


-- Exemplo 40 - !!IMPORTANTE!!
select * from OrderDetails

create trigger tr_ObterPreçoUnitário on OrderDetails
after update, insert as 
declare @OrderID int, @ProductID int
if update (ProductID)
	begin
		set @OrderID = (select OrderID from inserted)
		set @ProductID = (select ProductID from inserted)
		print @OrderID
		print @ProductID
		update OrderDetails set UnitPrice = (select UnitPrice from Products where ProductID = @ProductID)
		where OrderDetails.OrderID = @OrderID and OrderDetails.ProductID = @ProductID
	end

-- Inserir Dados 
insert into OrderDetails (OrderID, ProductID, Quantity) values (10248, 1, 1)
update OrderDetails set ProductID = 2 where OrderID = 10248 and ProductID = 1

select * from OrderDetails
delete from OrderDetails where OrderID = 10248 and ProductID = 1

-- Exemplo 41
-- Criar Tabela Gemea da 'Customers' com o nome 'CustomersDeleted'
-- Criar Trigger que copia os dados do cliente apagado para a tabela 'CustomersDeleted'
create trigger tr_CustomersDeleteda on Customers instead of delete as
declare @CustomerID nvarchar(5)
	begin
		set @CustomerID = (select CustomerID from deleted)
		print @CustomerID
		if exists (select CustomerID from Orders where CustomerID = @CustomerID)
		begin
			print 'Este Cliente não pode ser Eliminado.'
			rollback tran
			return
		end
		else
			begin
				insert into CustomersDeleted select * from deleted
				delete from Customers where CustomerID = @CustomerID
				print 'Registo Eliminado.'
			end
	end

-- Identificar Clientes que não têm Orders
select * from Customers where not exists (select * from Orders where Customers.CustomerID = Orders.CustomerID)
-- Ou
select CustomerID from Customers except
select distinct (CustomerID) from Orders

-- Apagar o Cliente que não tem Orders
delete from Customers where CustomerID = 'PARIS'
insert into Customers select * from CustomersDeleted
select * from CustomersDeleted

-- Exemplo 42
select * from Products
alter table Products add IsDeleted nchar(1) not null default 0

-- Criar Trigger
create trigger tr_Products_IDeleted on Products instead of delete as
declare @IsDeleted nchar(1)
set @IsDeleted = (select IsDeleted from deleted)
if @IsDeleted = 0
	begin
		print 'IsDeleted = 0'
		rollback
	end
else
	begin
		print 'IsDeleted = 1'
		rollback
	end

select * from Products
update Products set IsDeleted = '1'
delete from Products where ProductID = 1
-- Fim dos Exemplos da Sebenta

-- Criar Tabela 'Users'
create table Users
(UserID int identity (1000,1) primary key,
UserName nvarchar(20),
Password varbinary(128))

select * from Users
insert into Users values ('João', convert(varbinary(128), 'XPTO'))

-- Criar Chave de Encriptação para a Password
create symmetric key CKey with Algorithm = triple_des
encryption by password = 'k4hg5kjhg3'

-- Criar Chave de Desencriptação
open symmetric key Ckey Decryption by password = 'k4hg5kjhg3'

-- Inserir uma Password com Encryptação
insert into Users values ('Maria', encryptbykey(key_Guid('CKey'), 'Mariajota'))

-- Desencriptar Passwords
select UserName, decryptbykey(Password) from Users

-- Converter varbinary para varchar
select UserName, convert(varchar(20),decryptbykey(Password)) from Users

-- Crirar tabela para Incrementar NumeroEncomenda
create table Encomendas
(ID int identity (10000,1) primary key,
NumeroEncomenda nvarchar(20),
DataEncomenda date default getdate() not null,
IDCliende int not null,
ValorTotal money not null)

insert into Encomendas (NumeroEncomenda, IDCliende, ValorTotal) values ('1/2018/PT', 1, 1500)
insert into Encomendas (NumeroEncomenda, IDCliende, ValorTotal) values ('2/2018/PT', 2, 2500)
insert into Encomendas (NumeroEncomenda, IDCliende, ValorTotal) values ('3/2018/PT', 3, 3500)
insert into Encomendas (NumeroEncomenda, IDCliende, ValorTotal) values ('4/2018/PT', 4, 4500)
insert into Encomendas (IDCliende, ValorTotal) values (4, 4500)

select * from Encomendas
drop table Encomendas

-- Criar Trigger que Incrementa o NumeroEncomenda - Aplicar No Trabalho!!
create trigger tr_IncrementarNumeroEncomenda on Encomendas after insert as
declare @NumeroEncomenda nvarchar(20), @N int
set @NumeroEncomenda = (select NumeroEncomenda from Encomendas where ID = (select max(ID)-1 from Encomendas))
set @N = convert(int , left(@NumeroEncomenda, patindex('%/%', @NumeroEncomenda)-1))
set @N =  @N+1
set @NumeroEncomenda = convert(nvarchar(4), @N) + '/2018/PT'
update Encomendas set NumeroEncomenda = @NumeroEncomenda
where ID = (select ID from inserted)