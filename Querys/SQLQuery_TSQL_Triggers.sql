-- SQLQuery_TSQL_Triggers -- Pág.182 Sebenta
use ProDados

-- Criar Tabela 'Auditoria'
create table Auditoria
(IDRegisto int identity (1,1) primary key,
Data datetime default getdate(),
Utilizador nchar(30) not null default suser_sname(),
EstaçãoTrabalho nchar(30) default host_name(),
IDProduto int not null,
PreçoUnitárioNovo money not null,
PreçoUnitárioAntigo money not null)

select * from Auditoria

-- Criar Trigger 'tr_AuditoriaPreçoProduto'
alter trigger tr_AuditoriaPreçoProduto on Products after update as
if UPDATE (UnitPrice)
begin
set nocount on
--print 'Foi Alterado o Preço de um Produto!'
declare @Produto int, @PreçoUnitárioNovo money, @PreçoUnitárioAntigo money
set @Produto = (select ProductID from inserted)
set @PreçoUnitárioNovo = (select UnitPrice from inserted)
set @PreçoUnitárioAntigo = (select UnitPrice from deleted)
--print 'ID do Produto - ' +convert(nvarchar(25),@Produto)
--print 'Preço Novo - ' +convert(nvarchar(25),@PreçoUnitárioNovo)
--print 'Preço Antigo - ' +convert(nvarchar(25),@PreçoUnitárioAntigo)
insert into Auditoria (IDProduto, PreçoUnitárioNovo, PreçoUnitárioAntigo)
values (@Produto, @PreçoUnitárioNovo, @PreçoUnitárioAntigo)
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
Operação varchar(10) not null,
Registo varchar(50) not null,
Tabela varchar(20) not null)

-- Criar Trigger ''
alter trigger tr_Eventos_Customers on Customers after insert, update, delete as
declare @ID varchar(50)
if (select CustomerID from Inserted) <> '' and (select CustomerID from Deleted) <> ''
	begin
		set @ID = (select CustomerID from Inserted)
		insert into AuditarTabelas (Operação, Registo, Tabela)
		values ('UPDATE', @ID, 'CUSTOMERS')
	end
else
	begin
		if (select CustomerID from Inserted) <> ''
			begin
				set @ID = (select CustomerID from Inserted)
				insert into AuditarTabelas (Operação, Registo, Tabela)
				values ('INSERT', @ID, 'CUSTOMERS')
			end
		else
			begin
				set @ID = (select CustomerID from Deleted)
				insert into AuditarTabelas (Operação, Registo, Tabela)
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