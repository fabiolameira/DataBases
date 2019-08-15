-- Teste2_FábioLameira_a18970
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
Designação nvarchar(40),
AnoLançamento nvarchar(4),
Vendedor nvarchar(25),
ID_CS smallint,
PreçoInicial smallmoney,
Suporte nvarchar(20),
constraint PK_Software primary key (IDSoftware),
constraint FK_CategoriaSoftware foreign key (ID_CS) references CategoriasSoftware (ID_CS))


-- 2. Inserir Dados na Tabela 'CategoriasSoftware'
insert into CategoriasSoftware (ID_CS, Categoria) values (1, 'Database Management')
insert into CategoriasSoftware (ID_CS, Categoria) values (2, 'Application Development')
insert into CategoriasSoftware (ID_CS, Categoria) values (3, 'Networking')


-- 2. Inserir Dados na Tabela 'Software'
insert into Software (IDSoftware, Designação, AnoLançamento, Vendedor, ID_CS, PreçoInicial, Suporte)
values ('S1001', 'SQL Server 2016', '2016', 'Microsoft', 1, '1500.00', 'OnLine')
insert into Software (IDSoftware, Designação, AnoLançamento, Vendedor, ID_CS, PreçoInicial, Suporte)
values ('S1002', 'Oracle Database 12c', '2016', 'Oracle', 1, '3250.00', 'in loco')
insert into Software (IDSoftware, Designação, AnoLançamento, Vendedor, ID_CS, PreçoInicial, Suporte)
values ('S1003', 'Google Cloud Platform', '2010', 'Google', 2, '550.00', 'OnLine')
insert into Software (IDSoftware, Designação, AnoLançamento, Vendedor, ID_CS, PreçoInicial, Suporte)
values ('S1004', 'Azure', '2011', 'Microsoft', 2, '200.00', 'OnLine')


-- 3. Criar Tabela 'AvaliaçãoSoftware'
create table AvaliaçãoSoftware
(IDAvaliação int identity (1, 1),
IDSoftware nvarchar(5) not null,
Overall decimal(18,2) not null,
EaseOfUse decimal(18,2) not null,
FeaturesAndFuncionality decimal(18,2) not null,
CustomerSupport decimal(18,2) not null,
ValueOfMoney decimal(18,2) not null,
constraint PK_AvaliaçãoSoftware primary key (IDAvaliação),
constraint FK_AvaliaçãoSoftware foreign key (IDSoftware) references Software (IDSoftware))


-- 3. Inserir Dados na tabela 'AvaliaçãoSoftware'
insert into AvaliaçãoSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1001', '4.2', '3.8', '4', '3', '4.5')
insert into AvaliaçãoSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1001', '4.1', '3.5', '4.1', '3', '4.4')
insert into AvaliaçãoSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1002', '4.5', '3.5', '4', '3', '4.8')
insert into AvaliaçãoSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1003', '4.1', '4', '4.5', '3.5', '4.5')
insert into AvaliaçãoSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1003', '3', '3', '3', '3', '3')
insert into AvaliaçãoSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1004', '4', '4', '4.2', '3.7', '4.2')
insert into AvaliaçãoSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
values ('S1004', '4', '4.1', '4.2', '3.9', '4.5')


-- 4 a. Trigger que não permite que o User atribua avaliações maiores que 5
create trigger TR_ControlarValor on AvaliaçãoSoftware instead of insert, update as
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
	insert into AvaliaçãoSoftware (IDSoftware, Overall, EaseOfUse, FeaturesAndFuncionality, CustomerSupport, ValueOfMoney)
	values (@IDSoftware, @Overall, @EaseOfUse, @FeaturesAndFuncionality, @CustomerSupport, @ValueOfMoney)
end


-- 4. b. Trigger que não permite eliminar dados da tabela 'Software' caso hajam avaliações Pendentes
create trigger TR_EliminarSoftware on Software instead of delete as
declare @IDSoftware nvarchar(5)
begin
	set @IDSoftware = (select IDSoftware from deleted)
	if exists (select IDSoftware from AvaliaçãoSoftware where IDSoftware = @IDSoftware)
	begin
		print 'Este Software não pode ser Eliminado.'
		rollback tran
		return
	end
	else
		print 'Registo Eliminado.'
		delete from Software where IDSoftware = @IDSoftware
	end


-- 5. Procedimento que Analisa as avaliações do Software
create proc PR_AnalisarSoftware @IDSoftware nvarchar(5) as
declare @Designação nvarchar(40), @AnoLançamento nvarchar(4), @Vendedor nvarchar(25)
declare @ID_CS smallint, @Categoria nvarchar(25), @PreçoInicial smallmoney, @Suporte nvarchar(20)
declare @NumeroAv int, @MédiaOverall decimal(18,2), @MédiaEaseOfUse decimal(18,2)
declare @MédiaFeaturesAndFunctionality decimal(18,2), @MédiaCustomerSupport decimal(18,2)
declare @MédiaValueOfMoney decimal(18,2)
if exists (select IDSoftware from AvaliaçãoSoftware where IDSoftware= @IDSoftware)
begin
set @Designação = (select Designação from Software where IDSoftware = @IDSoftware)
set @AnoLançamento = (select AnoLançamento from Software where IDSoftware = @IDSoftware)
set @Vendedor = (select Vendedor from Software where IDSoftware = @IDSoftware)
set @ID_CS = (select ID_CS from Software where IDSoftware = @IDSoftware)
set @Categoria = (select Categoria from CategoriasSoftware where ID_CS = @ID_CS)
set @PreçoInicial = (select PreçoInicial from Software where IDSoftware = @IDSoftware)
set @Suporte = (select Suporte from Software where IDSoftware = @IDSoftware)
set @NumeroAv = (select count(IDSoftware) from AvaliaçãoSoftware where IDSoftware = @IDSoftware)
set @MédiaOverall = (select sum(Overall) from AvaliaçãoSoftware where IDSoftware = @IDSoftware)/@NumeroAv
set @MédiaEaseOfUse = (select sum(EaseOfUse) from AvaliaçãoSoftware where IDSoftware = @IDSoftware)/@NumeroAv
set @MédiaFeaturesAndFunctionality = (select sum(FeaturesAndFuncionality) from AvaliaçãoSoftware where IDSoftware = @IDSoftware)/@NumeroAv
set @MédiaCustomerSupport = (select sum(CustomerSupport) from AvaliaçãoSoftware where IDSoftware = @IDSoftware)/@NumeroAv
set @MédiaValueOfMoney = (select sum(ValueOfMoney) from AvaliaçãoSoftware where IDSoftware = @IDSoftware)/@NumeroAv
print 'IDSoftware --> ' +@IDSoftware
print '#1 ---'
print 'Designação: ' +@Designação
print 'Ano de Lançamento: ' +@AnoLançamento
print 'Vendedor: ' +@Vendedor
print 'Categoria: ' +@Categoria
print 'Preço Inicial: ' +convert(nvarchar(10), @PreçoInicial)
print 'Suporte: ' +@Suporte
print '#2 ---'
print 'Número de utilizadores / registos de avaliação: ' +convert(nvarchar(5), @NumeroAv)
print '#3 ---'
print 'Média de Overall: ' +convert(nvarchar(10), @MédiaOverall)
print 'Média de Ease of Use: ' +convert(nvarchar(10), @MédiaEaseOfUse)
print 'Média de Features And Funcionality: ' +convert(nvarchar(10), @MédiaFeaturesAndFunctionality)
print 'Média de Customer Support: ' +convert(nvarchar(10), @MédiaCustomerSupport)
print 'Média de Value Of Money: ' +convert(nvarchar(10), @MédiaValueOfMoney)
end

PR_AnalisarSoftware 'S1003'