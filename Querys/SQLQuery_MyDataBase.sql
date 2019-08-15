-- Criar Base de Dados:
-- create Database MyDataBase
use MyDataBase

-- Criar Tabela 'Clientes':
create table Clientes
(IDCliente integer,
PrimeiroNome nchar(50) NOT NULL,
UltimoNome nchar(50) NOT NULL,
Endereco nchar(50) default 'Unknown',
CodigoPostal nchar(8) check (CodigoPostal LIKE '[1-9][0-9][0-9][0-9][-][0-9][0-9][0-9]'),
Cidade nchar(50) default 'Lisboa',
Pais nchar(25) default 'Portugal',
DataNascimento datetime check (year(DataNascimento)> 1950 and year(DataNascimento) < year(getdate())),
Sexo nchar(1) NOT NULL check (Sexo in ('M', 'F')),
constraint PK_Clientes primary key (IDCliente))

-- Inserir Dados em Tabelas:
insert into Clientes values (101, 'Pedro', 'Silva', 'Rua A', '7300-191','Portalegre',
'Portugal', '5-5-2001', 'M')
insert into Clientes (IDCliente ,PrimeiroNome,UltimoNome) values (102, 'Maria', 'Pires')

select * from Clientes

-- Recuro de Sistema para ver Infomações sobre as Tabelas:
exec sp_help Clientes

-- Apagar uma Tabela:
drop table Clientes


-- Criar Tabela 'Vendas':
create table Vendas
(IDVenda integer,
DataVenda datetime
constraint DF_Vendas_DataVenda default getdate(),
DataEntrega datetime,
IDCliente integer,
MétodoPagamento nchar(20),
Status nchar(10),
constraint PK_Vendas primary key (IDVenda),
constraint CK_MP check (MétodoPagamento in ('Numerário','Cheque', 'Visa')),
constraint CK_Status check (Status in ('Concluída', 'Retida')),
constraint FK_Vendas foreign key (IDCliente) references Clientes (IDCliente))

select * from Clientes

-- Criar Tabela 'CategotiasProduto'
create table CategoriasProduto (
IDCategoria smallint,
DesigncaçãoCategoria nchar(60),
constraint PK_CategoriasProduto primary key (IDCategoria))

-- Criar Tabela 'FornecedoresProduto'
create table FornecedoresProduto (
NumeroFornecedor smallint,
NomeFornecedor nchar(70),
Endereço nchar(50),
CodigoPostal nchar(8) check (CodigoPostal LIKE '[1-9][0-9][0-9][0-9][-][0-9][0-9][0-9]'),
Localidade nchar(50),
constraint PK_FP primary key (NumeroFornecedor))

-- Criar Tabela 'Produtos'
create table Produtos (
IDProduto integer,
NomeProduto nchar(50) not null,
PreçoUnitario money,
IDCategoria smallint,
NumeroFornecedor smallint,
constraint PK_Produtos primary key (IDProduto),
constraint FK_CategoriasProduto foreign key (IDCategoria) 
references CategoriasProduto (IDCategoria),
constraint FK_FornecedoresProduto foreign key (NumeroFornecedor) 
references FornecedoresProduto (NumeroFornecedor))

-- Criar Tabela 'VendasProdutos'
create table VendasProdutos (
IDVenda int,
IDProduto int,
PreçoUnitario money,
Quantidade smallint default (1),
IVA decimal (18,2),
SubTotal as (PreçoUnitario*Quantidade)+(PreçoUnitario*Quantidade)*IVA,
constraint PK_VendasProdutos primary key (IDVenda, IDProduto),
constraint FK_Produtos foreign key (IDProduto) 
references Produtos (IDProduto) on update cascade,
constraint FK_VendasProdutos foreign key (IDVenda)
references Vendas (IDVenda) on update cascade)


-- Inserir Dados na Tabela 'FornecedorProduto'
insert into FornecedoresProduto values (24, 'CHIP7', 'Rua da Sé', '2100-234', 'Lisboa')
insert into FornecedoresProduto values (25, 'HP Portugal', 'AV. de Portugal', '2200-456', 'Lisboa')

select * from FornecedoresProduto

-- Inserir Dados na Tabela 'CategoriasProduto'
insert into CategoriasProduto values (101, 'Computadores')
insert into CategoriasProduto values (102, 'Impressores')
insert into CategoriasProduto values (103, 'Consumíveis')

-- Inserir Dados na Tabela 'Produtos'
insert into Produtos values (134, 'Notebooke HPnx7400', 789, 101, 25)
insert into Produtos values (135, 'Impressore HP120', 125, 102, 25)
insert into Produtos values (136, 'Rato USB Microsodt', 15, 103, 24)

select * from VendasProdutos

-- Inserir Dados na Tabela 'VendasProdutos'
insert into VendasProdutos values (1201, 134, 789, 3, 0.21)
insert into VendasProdutos values (1201, 135, 125, 2, 0.21)
insert into VendasProdutos values (1201, 136, 15, 1, 0.21)
insert into VendasProdutos values (1202, 136, 15, 22, 0.21)
insert into VendasProdutos values (1206, 134, 789, 20, 0.21)

-- Alter Table -- Exemplos da Página 135 da Sebenta:
select * from Clientes
alter table Clientes
add EstadoCivil nchar(20)
default ('Solteiro') 
check (EstadoCivil in ('Solteiro', 'Casado', 'Viúvo', 'Divorciado', 'União de Facto'))

exec sp_help Clientes

-- Renomear Colunas de Tabelas
exec sp_rename 'Clientes.PrimeiroNome', 'PrimeriosNomes', 'column'

-- Alterar Tipo de Coluna
alter table Clientes alter column Endereco nchar(255)

-- Adicionar Coluna a uma Tabela
alter table FornecedoresProduto add Telefone nchar(10)
alter table FornecedoresProduto add Email nchar(50)

select * from FornecedoresProduto

-- Remover Coluna de Tabelas
alter table FornecedoresProduto drop column Email

-- Adicionar Coluna 'Desconto' à Tabela 'VendasProdutos'
alter table VendasProdutos add Desconto decimal (5,3)
default (0) not null

-- Adicionar Coluna 'ValorDesconto' à Tabela 'VendasProdutos'
alter table VendasProdutos add ValorDesconto 
as ((PreçoUnitario*Quantidade)+(PreçoUnitario*Quantidade)*IVA)*desconto

-- Adicionar Constraint à Tabela 'VendasProdutos'
alter table VendasProdutos add constraint CK_Quantidade
check ((Quantidade) >= 1 and (Quantidade) <= 100)

--
alter table VendasProdutos 
add IDRegisto int identity (1, 1) not null

alter table VendasProdutos drop constraint PK_VendasProdutos
alter table VendasProdutos add constraint PK_VendasProdutos primary key (IDRegisto)

select * from VendasProdutos
exec sp_help VendasProdutos

truncate table VendasProdutos

drop table VendasProdutos

insert into FornecedoresProduto 
values ('26', 'ABC Link', 'Rua dos Franciscanos, 23, RC', '4700-099', 'Braga', '279500600')
insert into FornecedoresProduto 
values ('27', 'Só Hardware', 'Av dos Álamos, 2001, 8ºD', '3800-352', 'Aveiro', '265400850')

insert into Produtos (IDProduto, NomeProduto, PreçoUnitario,IDCategoria, NumeroFornecedor)
values (137, 'Notebook Dell', 899, 101, 24)

insert into Produtos (NomeProduto, IDProduto, IDCategoria, NumeroFornecedor, PreçoUnitario)
values ('Notebook Asus', 138, 101, 24, 1250)

select * from FornecedoresProduto
select * from Produtos

-- Criar Tabela 'BackupVendas'
create table BackupVendas (
IDVenda int primary key,
DataVenda datetime,
IDCliente int references Clientes (IDCliente),
TotalVenda money)

-- Inserir Dados numa Tabela, a Partir de Outra Tabela
insert into BackupVendas (V.IDVenda, DataVenda, IDCliente, TotalVenda)
select V.IDVenda, DataVenda, IDCliente, sum(PreçoUnitario*Quantidade) from Vendas V
join VendasProdutos VP on V.IDVenda = VP.IDVenda
group by V.IDVenda, DataVenda, IDCliente

-- Update -- Alterar/Atualizar um Certo dado na Tabela -- Exemplo 15
alter table Clientes add CategoriaCliente nchar(2)
check (CategoriaCliente in ('I', 'EP', 'IP'))

select * from Clientes

update Clientes set CategoriaCliente = 'EP' where Cidade = 'Lisboa'
update Clientes set CategoriaCliente = 'IP' where Cidade = 'Portalegre'
update Clientes set CategoriaCliente = 'I' where CategoriaCliente is null

-- Update -- Exemplo 16
select * from Produtos
update Produtos set PreçoUnitario = PreçoUnitario + (PreçoUnitario * 0.0123)

-- Update -- Exemplo 17
select * from Clientes
update Clientes set EstadoCivil = 'Solteiro'
where IDCliente = 5

-- Update -- Exemplo 19
select * from Vendas
update Vendas set DataVenda = replace (DataVenda, year(DataVenda), '2008')

-- Update -- Exemplo 20
select * from Clientes
update Clientes set Endereco = 'Atualizar na Próxima Venda'
where Endereco = 'Desconhecida'

-- Update -- Exemplo 21
select * from Clientes
update Clientes set UltimoNome = 'Rochas'
where IDCliente = 10

-- Update -- Exemplo 22
select * from Clientes C
join Vendas V on C.IDCliente = V.IDCliente
where C.IDCliente = 80

alter table Vendas Drop constraint FK_Vendas 
alter table Vendas add constraint FK_Vendas 
foreign key (IDCliente) references Clientes (IDCliente) on update cascade

update Clientes set IDCliente = 80 where IDcliente = 8

-- Update -- Exemplo 23
insert into FornecedoresProduto values (99, 'LinkSys', 'Av', '2100-547', 'Lisboa', '215478741')

select * from FornecedoresProduto
select * from Produtos

update Produtos set NumeroFornecedor = 99 where NumeroFornecedor = 24