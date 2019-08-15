-- SQLQuery_TSQL_Triggers -- P�g.182 Sebenta
use ProDados

-- Criar Tabela 'Auditoria'
create table Auditoria
(IDRegisto int identity (1,1) primary key,
Data datetime default getdate(),
Utilizador nchar(30) not null default suser_sname(),
Esta��oTrabalho nchar(30) default host_name(),
IDProduto int not null,
Pre�oUnit�rioNovo money not null,
Pre�oUnit�rioAntigo money not null)

select * from Auditoria

-- Criar Trigger 'tr_AuditoriaPre�oProduto'
alter trigger tr_AuditoriaPre�oProduto on Products after update as
if UPDATE (UnitPrice)
begin
set nocount on
--print 'Foi Alterado o Pre�o de um Produto!'
declare @Produto int, @Pre�oUnit�rioNovo money, @Pre�oUnit�rioAntigo money
set @Produto = (select ProductID from inserted)
set @Pre�oUnit�rioNovo = (select UnitPrice from inserted)
set @Pre�oUnit�rioAntigo = (select UnitPrice from deleted)
--print 'ID do Produto - ' +convert(nvarchar(25),@Produto)
--print 'Pre�o Novo - ' +convert(nvarchar(25),@Pre�oUnit�rioNovo)
--print 'Pre�o Antigo - ' +convert(nvarchar(25),@Pre�oUnit�rioAntigo)
insert into Auditoria (IDProduto, Pre�oUnit�rioNovo, Pre�oUnit�rioAntigo)
values (@Produto, @Pre�oUnit�rioNovo, @Pre�oUnit�rioAntigo)
end

update Products set UnitPrice = 18 where ProductID = 1
select * from Auditoria

-- Criar Trigger 'tr_Eventos'
create trigger tr_Eventos on Products after insert, update, delete as
declare @ID int
if (select ProductID from Inserted) <> '' and (select ProductID from Deleted) <> ''
	print 'UPDATE'
else
	begin
		if (select ProductID from Inserted) <> ''
			print 'INSERT'
		else
			print 'DELETE'
	end

insert into Products (ProductName, SupplierID, CategoryID)
values ('Produto Nacional', 10, 1)

update Products set UnitPrice = 100 where ProductID = 78
delete from Products where ProductID = 78

-- Criar Tabela 'AuditarTabelas'
create table AuditarTabelas
(IDRegisto int primary key identity(1,1),
DataReg datetime default getdate(),
Opera��o varchar(10) not null,
Registo varchar(50) not null,
Tabela varchar(20) not null)

-- Criar Trigger ''
alter trigger tr_Eventos_Customers on Customers after insert, update, delete as
declare @ID varchar(50)
if (select CustomerID from Inserted) <> '' and (select CustomerID from Deleted) <> ''
	begin
		set @ID = (select CustomerID from Inserted)
		insert into AuditarTabelas (Opera��o, Registo, Tabela)
		values ('UPDATE', @ID, 'CUSTOMERS')
	end
else
	begin
		if (select CustomerID from Inserted) <> ''
			begin
				set @ID = (select CustomerID from Inserted)
				insert into AuditarTabelas (Opera��o, Registo, Tabela)
				values ('INSERT', @ID, 'CUSTOMERS')
			end
		else
			begin
				set @ID = (select CustomerID from Deleted)
				insert into AuditarTabelas (Opera��o, Registo, Tabela)
				values ('DELETE', @ID, 'CUSTOMERS')
			end
	end

select * from AuditarTabelas
select * from Customers
insert into Customers (CustomerID, CompanyName)
values ('XPTO', 'Nome do XPTO')

update Customers set CompanyName = 'XPTO de Portalegre'
where CustomerID = 'XPTO'

delete from Customers where CustomerID = 'XPTO'

truncate table AuditarTabelas