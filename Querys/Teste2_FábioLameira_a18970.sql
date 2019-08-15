-- Teste2_F�bioLameira_a18970
-- 2. Criar Base de Dados 'db_Teste2_20172018'
create database db_Teste2_20172018
use db_Teste2_20172018


-- 2. Criar Tabela 'CategoriasSoftware'
create table CategoriasSoftware
(ID_CS smallint,
Categoria nvarchar(25) unique,
constraint PK_CategoriasSoftware primary key (ID_CS))


-- 2. Criar Tabela 'Software'
create table Software
(IDSoftware nvarchar(5),
Designa��o nvarchar(40),
AnoLan�amento nvarchar(4),
Vendedor nvarchar(25),
ID_CS smallint,
Pre�oInicial smallmoney,
Suporte nvarchar(20),
constraint PK_Software primary key (IDSoftware),
constraint FK_CategoriaSoftware foreign key (ID_CS) references CategoriasSoftware (ID_CS))


-- 2. Inserir Dados na Tabela 'CategoriasSoftware'
insert into CategoriasSoftware (ID_CS, Categoria) values (1, 'Database Management')
insert into CategoriasSoftware (ID_CS, Categoria) values (2, 'Application Development')
insert into CategoriasSoftware (ID_CS, Categoria) values (3, 'Networking')


-- 2. Inserir Dados na Tabela 'Software'
insert into Software (IDSoftware, Designa��o, AnoLan�amento, Vendedor, ID_CS, Pre�oInicial, Suporte)
values ('S1001', 'SQL Server 2016', '2016', 'Microsoft', 1, '1500.00', 'OnLine')
insert into Software (IDSoftware, Designa��o, AnoLan�amento, Vendedor, ID_CS, Pre�oInicial, Suporte)
values ('S1002', 'Oracle Database 12c', '2016', 'Oracle', 1, '3250.00', 'in loco')
insert into Software (IDSoftware, Designa��o, AnoLan�amento, Vendedor, ID_CS, Pre�oInicial, Suporte)
values ('S1003', 'Google Cloud Platform', '2010', 'Google', 2, '550.00', 'OnLine')
insert into Software (IDSoftware, Designa��o, AnoLan�amento, Vendedor, ID_CS, Pre�oInicial, Suporte)
values ('S1004', 'Azure', '2011', 'Microsoft', 2, '200.00', 'OnLine')


-- 3. Criar Tabela 'Avalia��oSoftware'
create table Avalia��oSoftware
(IDAvalia��o int identity (1, 1),
IDSoftware nvarchar(5) not null,
Overall decimal(18,2) not null,
EaseOfUse decimal(18,2) not null,
FeaturesAndFuncionality decimal(18,2) not null,
CustomerSupport decimal(18,2) not null,
ValueOfMoney decimal(18,2) not null,
constraint PK_Avalia��oSoftware primary key (IDAvalia��o),
constraint FK_Avalia��oSoftware foreign key (IDSoftware) references Software (IDSoftware))


-- 3. Inserir Dados na tabela 'Avalia��oSoftware'
insert into Avalia��oSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1001', '4.2', '3.8', '4', '3', '4.5')
insert into Avalia��oSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1001', '4.1', '3.5', '4.1', '3', '4.4')
insert into Avalia��oSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1002', '4.5', '3.5', '4', '3', '4.8')
insert into Avalia��oSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1003', '4.1', '4', '4.5', '3.5', '4.5')
insert into Avalia��oSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1003', '3', '3', '3', '3', '3')
insert into Avalia��oSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1004', '4', '4', '4.2', '3.7', '4.2')
insert into Avalia��oSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1004', '4', '4.1', '4.2', '3.9', '4.5')


-- 4 a. Trigger que n�o permite que o User atribua avalia��es maiores que 5
create trigger TR_ControlarValor on Avalia��oSoftware instead of insert, update as
declare @IDSoftware nvarchar(5), @Overall decimal(18,2), @EaseOfUse decimal(18,2)
declare @FeaturesAndFuncionality decimal(18,2), @CustomerSupport decimal(18,2), @ValueOfMoney decimal(18,2)
set @IDSoftware = (select IDSoftware from inserted)
set @Overall = (select Overall from inserted)
set @EaseOfUse = (select EaseOfUse from inserted)
set @FeaturesAndFuncionality = (select FeaturesAndFuncionality from inserted)
set @CustomerSupport = (select CustomerSupport from inserted)
set @ValueOfMoney = (select ValueOfMoney from inserted)
begin
	if @Overall > 5
		set @Overall = 0
	if @EaseOfUse > 5
		set @EaseOfUse = 0
	if @FeaturesAndFuncionality > 5
		set @FeaturesAndFuncionality = 0
	if @CustomerSupport > 5
		set @CustomerSupport = 0
	if @ValueOfMoney > 5
		set @ValueOfMoney = 0
	insert into Avalia��oSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
	values (@IDSoftware, @Overall, @EaseOfUse, @FeaturesAndFuncionality, @CustomerSupport, @ValueOfMoney)
end


-- 4. b. Trigger que n�o permite eliminar dados da tabela 'Software' caso hajam avalia��es Pendentes
create trigger TR_EliminarSoftware on Software instead of delete as
declare @IDSoftware nvarchar(5)
begin
	set @IDSoftware = (select IDSoftware from deleted)
	if exists (select IDSoftware from Avalia��oSoftware where IDSoftware = @IDSoftware)
	begin
		print 'Este Software n�o pode ser Eliminado.'
		rollback tran
		return
	end
	else
		print 'Registo Eliminado.'
		delete from Software where IDSoftware = @IDSoftware
	end


-- 5. Procedimento que Analisa as avalia��es do Software
create proc PR_AnalisarSoftware @IDSoftware nvarchar(5) as
declare @Designa��o nvarchar(40), @AnoLan�amento nvarchar(4), @Vendedor nvarchar(25)
declare @ID_CS smallint, @Categoria nvarchar(25), @Pre�oInicial smallmoney, @Suporte nvarchar(20)
declare @NumeroAv int, @M�diaOverall decimal(18,2), @M�diaEaseOfUse decimal(18,2)
declare @M�diaFeaturesAndFunctionality decimal(18,2), @M�diaCustomerSupport decimal(18,2)
declare @M�diaValueOfMoney decimal(18,2)
if exists (select IDSoftware from Avalia��oSoftware where IDSoftware= @IDSoftware)
begin
set @Designa��o = (select Designa��o from Software where IDSoftware = @IDSoftware)
set @AnoLan�amento = (select AnoLan�amento from Software where IDSoftware = @IDSoftware)
set @Vendedor = (select Vendedor from Software where IDSoftware = @IDSoftware)
set @ID_CS = (select ID_CS from Software where IDSoftware = @IDSoftware)
set @Categoria = (select Categoria from CategoriasSoftware where ID_CS = @ID_CS)
set @Pre�oInicial = (select Pre�oInicial from Software where IDSoftware = @IDSoftware)
set @Suporte = (select Suporte from Software where IDSoftware = @IDSoftware)
set @NumeroAv = (select count(IDSoftware) from Avalia��oSoftware where IDSoftware = @IDSoftware)
set @M�diaOverall = (select sum(Overall) from Avalia��oSoftware where IDSoftware = @IDSoftware)/@NumeroAv
set @M�diaEaseOfUse = (select sum(EaseOfUse) from Avalia��oSoftware where IDSoftware = @IDSoftware)/@NumeroAv
set @M�diaFeaturesAndFunctionality = (select sum(FeaturesAndFuncionality) from Avalia��oSoftware where IDSoftware = @IDSoftware)/@NumeroAv
set @M�diaCustomerSupport = (select sum(CustomerSupport) from Avalia��oSoftware where IDSoftware = @IDSoftware)/@NumeroAv
set @M�diaValueOfMoney = (select sum(ValueOfMoney) from Avalia��oSoftware where IDSoftware = @IDSoftware)/@NumeroAv
print 'IDSoftware --> ' +@IDSoftware
print '#1 ---'
print 'Designa��o: ' +@Designa��o
print 'Ano de Lan�amento: ' +@AnoLan�amento
print 'Vendedor: ' +@Vendedor
print 'Categoria: ' +@Categoria
print 'Pre�o Inicial: ' +convert(nvarchar(10), @Pre�oInicial)
print 'Suporte: ' +@Suporte
print '#2 ---'
print 'N�mero de utilizadores / registos de avalia��o: ' +convert(nvarchar(5), @NumeroAv)
print '#3 ---'
print 'M�dia de Overall: ' +convert(nvarchar(10), @M�diaOverall)
print 'M�dia de Ease of Use: ' +convert(nvarchar(10), @M�diaEaseOfUse)
print 'M�dia de Features And Funcionality: ' +convert(nvarchar(10), @M�diaFeaturesAndFunctionality)
print 'M�dia de Customer Support: ' +convert(nvarchar(10), @M�diaCustomerSupport)
print 'M�dia de Value Of Money: ' +convert(nvarchar(10), @M�diaValueOfMoney)
end

PR_AnalisarSoftware 'S1003'