-- P�gina 150 da Sebenta -- Exerc�cio 4
use db_Inqueritos2
exec sp_rename 'Inqueritos$', 'Inqueritos'

select * from Inqueritos

-- Apagar as Colunas F8, F9 e F10
alter table Inqueritos drop column F8
alter table Inqueritos drop column F9
alter table Inqueritos drop column F10

-- Altera��o do Campo ID para Not Null
alter table Inqueritos alter column ID int not null

-- Cria��o da Chave Prim�ria
alter table Inqueritos add 
constraint PK_Inqueritos primary key  (ID)

-- Altera��o do Tipo de Dados das Colunas
alter table Inqueritos alter column Sexo nchar(1)

-- Cria��o da Tabela 'Profiss�es'
create table Profiss�es
(IDProfiss�o int identity(1,1) primary key,
Profiss�o nchar(50) not null)

-- Passagem dos Dados da Tabela 'Inqueritos' para a Tabela 'Profiss�es'
insert into Profiss�es (Profiss�o)
select distinct Profiss�o from Inqueritos

-- Altera��o do Campo 'Profiss�o' para o Campo 'IDProfiss�o'
update Inqueritos set Profiss�o = (
select IDProfiss�o from Profiss�es
where Profiss�es.Profiss�o = Inqueritos.Profiss�o)

-- Passagem do Campo 'Profiss�o' para o DataType 'Int'
alter table Inqueritos alter column Profiss�o int

-- Cria��o de Chave Estrangeira entre a Tabela 'Inqueritos' e 'Profiss�es'
alter table Inqueritos add constraint FK_Profiss�es foreign key (Profiss�o)
references Profiss�es (IDProfiss�o)
