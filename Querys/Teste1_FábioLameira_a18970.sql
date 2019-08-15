-- Teste - a18970 - Fábio Lameira
--Q01 a)
use Vendas
select SalesPerson, count(CustomerID)'NClientes' 
from SalesLT.Customer
group by SalesPerson
order by 'NClientes' desc

--Q01 b)
select PC.ParentProductCategoryID, 'Clothing', P.Color, count(P.ProductID)'NºProducts'
from SalesLT.ProductCategory PC
join SalesLT.Product P on PC.ProductCategoryID = P.ProductCategoryID
where P.Color is not NULL and PC.ParentProductCategoryID = 3
group by PC.ParentProductCategoryID, P.Color
order by P.Color

--Q01 c)
select  (select count(CustomerID) from SalesLT.Customer)'NºClientes',
((select count(CustomerID) from SalesLT.Customer)-count(SOH.CustomerID))'NºClientes s/Encomendas',
count(SOH.CustomerID)'NºClientes c/Encomendas'
from SalesLT.Customer C
join SalesLT.SalesOrderHeader SOH on C.CustomerID = SOH.CustomerID

--Q02
create database db_Teste1_201718
use db_Teste1_201718

create table Funcionários (
NFuncionário int identity (1000,1),
PrimeirosNomes nchar(20) not null,
UltimosNomes nchar(20) not null,
CategoriaProfissional nchar(25) not null,
NIF nchar(9) not null unique,
VencimentoBase smallmoney,
constraint PK_Funcionários primary key (NFuncionário),
constraint CK_NIF check (NIF like ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
constraint CK_VencimentoBase check (VencimentoBase > 557))

insert into Funcionários (PrimeirosNomes, UltimosNomes, CategoriaProfissional, NIF, VencimentoBase)
values ('Joana', 'Pires', 'Estagiário', 152789415, 1500.00)
insert into Funcionários (PrimeirosNomes, UltimosNomes, CategoriaProfissional, NIF, VencimentoBase)
values ('Pedro', 'Almeida', 'Técnico Superior', 211748852, 2560.00)
insert into Funcionários (PrimeirosNomes, UltimosNomes, CategoriaProfissional, NIF, VencimentoBase)
values ('Maria', 'Santos', 'Técnico Superior', 215462357, 3200.00)

create table Vencimentos (
NFuncionário int,
Ano nchar(4),
Mês nchar(02),
VencimentoBase smallmoney,
SubsidioAlimentação smallmoney,
IRS smallmoney,
ADSE smallmoney,
VencimentoLiquido as ((VencimentoBase - (IRS + ADSE)) + SubsidioAlimentação),
constraint PK_Vencimentos primary key (NFuncionário, Ano, Mês),
constraint FK_Funcionários foreign key (NFuncionário)
references Funcionários (NFuncionário))

insert into Vencimentos (NFuncionário, Ano, Mês)
values (1000, '2017', '01')
insert into Vencimentos (NFuncionário, Ano, Mês)
values (1000, '2017', '02')
insert into Vencimentos (NFuncionário, Ano, Mês)
values (1001, '2017', '01')
insert into Vencimentos (NFuncionário, Ano, Mês)
values (1001, '2017', '02')
insert into Vencimentos (NFuncionário, Ano, Mês)
values (1002, '2017', '01')
insert into Vencimentos (NFuncionário, Ano, Mês)
values (1002, '2017', '02')

select * from Funcionários
select * from Vencimentos

--Q03 a)
update Vencimentos set VencimentoBase = (
select VencimentoBase from Funcionários
where Vencimentos.NFuncionário = Funcionários.NFuncionário)

--Q03 b)
update Vencimentos set SubsidioAlimentação = '65' where Ano = '2017' and Mês = '01'
update Vencimentos set SubsidioAlimentação = '77' where Ano = '2017' and Mês = '02'

--Q03 c)
update Vencimentos set IRS = (VencimentoBase * 0.35)

--Q03 d)
update Vencimentos set ADSE = (VencimentoBase * 0.05)

--Q04 a)
alter table Funcionários add EstadoCivil nchar(20)

--Q04 b)
alter table Funcionários alter column CategoriaProfissional nchar(40)

--Q04 c)
alter table Vencimentos drop constraint PK_Vencimentos
alter table Vencimentos add IDVencimento int identity (1000,1)
alter table Vencimentos add constraint PK_Vencimentos primary key (IDVencimento)

select * from Vencimentos

--Q05
create table Assiduidade (
NFuncionário int,
AnoMês nchar(6),
DiasTrabalho int not null,
constraint PK_Assiduidade primary key (NFuncionário, AnoMês),
constraint FK_Assiduidade foreign key (NFuncionário)
references Funcionários (NFuncionário),
constraint CK_DiasTraalho check (DiasTrabalho like ('[0-3][0-9]')))

insert into Assiduidade values (1000, '201701', 21)
insert into Assiduidade values (1001, '201701', 25)
insert into Assiduidade values (1002, '201701', 20)
insert into Assiduidade values (1000, '201702', 20)
insert into Assiduidade values (1001, '201702', 20)
insert into Assiduidade values (1002, '201702', 19)

select * from Assiduidade