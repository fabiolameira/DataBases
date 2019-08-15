-- Teste - a18970 - F�bio Lameira
--Q01 a)
use Vendas
select SalesPerson, count(CustomerID)'NClientes' 
from SalesLT.Customer
group by SalesPerson
order by 'NClientes' desc

--Q01 b)
select PC.ParentProductCategoryID, 'Clothing', P.Color, count(P.ProductID)'N�Products'
from SalesLT.ProductCategory PC
join SalesLT.Product P on PC.ProductCategoryID = P.ProductCategoryID
where P.Color is not NULL and PC.ParentProductCategoryID = 3
group by PC.ParentProductCategoryID, P.Color
order by P.Color

--Q01 c)
select  (select count(CustomerID) from SalesLT.Customer)'N�Clientes',
((select count(CustomerID) from SalesLT.Customer)-count(SOH.CustomerID))'N�Clientes s/Encomendas',
count(SOH.CustomerID)'N�Clientes c/Encomendas'
from SalesLT.Customer C
join SalesLT.SalesOrderHeader SOH on C.CustomerID = SOH.CustomerID

--Q02
create database db_Teste1_201718
use db_Teste1_201718

create table Funcion�rios (
NFuncion�rio int identity (1000,1),
PrimeirosNomes nchar(20) not null,
UltimosNomes nchar(20) not null,
CategoriaProfissional nchar(25) not null,
NIF nchar(9) not null unique,
VencimentoBase smallmoney,
constraint PK_Funcion�rios primary key (NFuncion�rio),
constraint CK_NIF check (NIF like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
constraint CK_VencimentoBase check (VencimentoBase > 557))

insert into Funcion�rios (PrimeirosNomes, UltimosNomes, CategoriaProfissional, NIF, VencimentoBase)
values ('Joana', 'Pires', 'Estagi�rio', 152789415, 1500.00)
insert into Funcion�rios (PrimeirosNomes, UltimosNomes, CategoriaProfissional, NIF, VencimentoBase)
values ('Pedro', 'Almeida', 'T�cnico Superior', 211748852, 2560.00)
insert into Funcion�rios (PrimeirosNomes, UltimosNomes, CategoriaProfissional, NIF, VencimentoBase)
values ('Maria', 'Santos', 'T�cnico Superior', 215462357, 3200.00)

create table Vencimentos (
NFuncion�rio int,
Ano nchar(4),
M�s nchar(02),
VencimentoBase smallmoney,
SubsidioAlimenta��o smallmoney,
IRS smallmoney,
ADSE smallmoney,
VencimentoLiquido as ((VencimentoBase - (IRS + ADSE)) + SubsidioAlimenta��o),
constraint PK_Vencimentos primary key (NFuncion�rio, Ano, M�s),
constraint FK_Funcion�rios foreign key (NFuncion�rio)
references Funcion�rios (NFuncion�rio))

insert into Vencimentos (NFuncion�rio, Ano, M�s)
values (1000, '2017', '01')
insert into Vencimentos (NFuncion�rio, Ano, M�s)
values (1000, '2017', '02')
insert into Vencimentos (NFuncion�rio, Ano, M�s)
values (1001, '2017', '01')
insert into Vencimentos (NFuncion�rio, Ano, M�s)
values (1001, '2017', '02')
insert into Vencimentos (NFuncion�rio, Ano, M�s)
values (1002, '2017', '01')
insert into Vencimentos (NFuncion�rio, Ano, M�s)
values (1002, '2017', '02')

select * from Funcion�rios
select * from Vencimentos

--Q03 a)
update Vencimentos set VencimentoBase = (
select VencimentoBase from Funcion�rios
where Vencimentos.NFuncion�rio = Funcion�rios.NFuncion�rio)

--Q03 b)
update Vencimentos set SubsidioAlimenta��o = '65' where Ano = '2017' and M�s = '01'
update Vencimentos set SubsidioAlimenta��o = '77' where Ano = '2017' and M�s = '02'

--Q03 c)
update Vencimentos set IRS = (VencimentoBase * 0.35)

--Q03 d)
update Vencimentos set ADSE = (VencimentoBase * 0.05)

--Q04 a)
alter table Funcion�rios add EstadoCivil nchar(20)

--Q04 b)
alter table Funcion�rios alter column CategoriaProfissional nchar(40)

--Q04 c)
alter table Vencimentos drop constraint PK_Vencimentos
alter table Vencimentos add IDVencimento int identity (1000,1)
alter table Vencimentos add constraint PK_Vencimentos primary key (IDVencimento)

select * from Vencimentos

--Q05
create table Assiduidade (
NFuncion�rio int,
AnoM�s nchar(6),
DiasTrabalho int not null,
constraint PK_Assiduidade primary key (NFuncion�rio, AnoM�s),
constraint FK_Assiduidade foreign key (NFuncion�rio)
references Funcion�rios (NFuncion�rio),
constraint CK_DiasTraalho check (DiasTrabalho like ('[0-3][0-9]')))

insert into Assiduidade values (1000, '201701', 21)
insert into Assiduidade values (1001, '201701', 25)
insert into Assiduidade values (1002, '201701', 20)
insert into Assiduidade values (1000, '201702', 20)
insert into Assiduidade values (1001, '201702', 20)
insert into Assiduidade values (1002, '201702', 19)

select * from Assiduidade