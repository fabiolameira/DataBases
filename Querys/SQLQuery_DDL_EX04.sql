-- Página 150 da Sebenta -- Exercício 4
use db_Inqueritos2
exec sp_rename 'Inqueritos$', 'Inqueritos'

select * from Inqueritos

-- Apagar as Colunas F8, F9 e F10
alter table Inqueritos drop column F8
alter table Inqueritos drop column F9
alter table Inqueritos drop column F10

-- Alteração do Campo ID para Not Null
alter table Inqueritos alter column ID int not null

-- Criação da Chave Primária
alter table Inqueritos add 
constraint PK_Inqueritos primary key  (ID)

-- Alteração do Tipo de Dados das Colunas
alter table Inqueritos alter column Sexo nchar(1)

-- Criação da Tabela 'Profissões'
create table Profissões
(IDProfissão int identity(1,1) primary key,
Profissão nchar(50) not null)

-- Passagem dos Dados da Tabela 'Inqueritos' para a Tabela 'Profissões'
insert into Profissões (Profissão)
select distinct Profissão from Inqueritos

-- Alteração do Campo 'Profissão' para o Campo 'IDProfissão'
update Inqueritos set Profissão = (
select IDProfissão from Profissões
where Profissões.Profissão = Inqueritos.Profissão)

-- Passagem do Campo 'Profissão' para o DataType 'Int'
alter table Inqueritos alter column Profissão int

-- Criação de Chave Estrangeira entre a Tabela 'Inqueritos' e 'Profissões'
alter table Inqueritos add constraint FK_Profissões foreign key (Profissão)
references Profissões (IDProfissão)
