-- Criar Base de Dados:
create database db_IT2017
go
use db_IT2017
go


-- Criar Tabela 'Lojas'
create table Lojas
(IDLoja int identity (1, 1),
NomeLoja nvarchar(25) not null,
Contacto nchar(9) not null,
Endereço nvarchar(50) not null,
CodigoPostal nchar(8) not null,
Cidade nvarchar(50) not null,
Pais nvarchar(50) not null,
DataAbertura date not null,
constraint PK_Lojas primary key (IDLoja),
constraint CK_ContactoLojas check (Contacto like ('[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
constraint CK_CodigoPostalLojas check (CodigoPostal like ('[1-9][0-9][0-9][0-9][-][0-9][0-9][0-9]')),
constraint CK_DataAbertura check (year(DataAbertura) > 1950 and DataAbertura <= getdate()))


-- Criar Tabela 'Tecnicos'
create table Tecnicos
(IDTecnico int identity (1001,1),
PrimeirosNomes nvarchar(50) not null,
UltimosNomes nvarchar(50) not null,
Sexo nchar(1) not null,
NIF nchar(9) not null unique,
Contacto nchar(9) not null,
Endereço nvarchar(50) not null,
CodigoPostal nchar(8) not null,
Cidade nvarchar(50) not null,
Pais nvarchar(50) not null,
DataNascimento date not null,
DataIngresso date not null,
constraint PK_Tecnicos primary key (IDTecnico),
constraint CK_PrimeirosNomesTecnicos check (PrimeirosNomes not like '%[^A-Z ]%'),
constraint CK_UltimosNomesTecnicos check (UltimosNomes not like '%[^A-Z ]%'),
constraint CK_SexoTecnicos check (Sexo in ('M', 'F')),
constraint CK_NIFTecnicos check (NIF like ('[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
constraint CK_ContactoTecnicos check (Contacto like ('[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
constraint CK_CodigoPostalTecnicos check (CodigoPostal like ('[1-9][0-9][0-9][0-9][-][0-9][0-9][0-9]')),
constraint CK_DataNascimentoTecnicos check (year(DataNascimento) > 1950 and year(DataNascimento) < year(getdate()-16)),
constraint CK_DataIngressoTecnicos check (year(DataIngresso) > year(DataNascimento) and DataIngresso <= getdate()))


-- Criar Tabela 'TecnicosLojas'
create table TecnicosLojas
(IDTecnico int,
IDLoja int,
DataInicio date not null,
DataFim date,
constraint PK_TecnicosLojas primary key (IDTecnico, IDLoja, DataInicio),
constraint FK_TecnicosTecnicosLojas foreign key (IDTecnico) references Tecnicos (IDTecnico),
constraint FK_LojasTecnicosLojas foreign key (IDLoja) references Lojas (IDLoja),
constraint CK_DataInicioTecnicosLojas check (year(DataInicio) > 1950 and DataInicio <= getdate()),
constraint CK_DataFimTecnicosLojas check (DataFim > DataInicio))


-- Criar Tabela 'Clientes'
create table Clientes
(IDCliente int identity (1,1),
TipoCliente nchar(8) not null,
NomeEmpresa nvarchar(50),
PrimeirosNomes nvarchar(50) not null,
UltimosNomes nvarchar(50) not null,
Sexo nchar(1) not null,
NIF nchar(9) not null unique,
Contacto nchar(9) not null,
Endereço nvarchar(50) not null,
CodigoPostal nchar(8) not null,
Cidade nvarchar(50) not null,
Pais nvarchar(50) not null,
DataNascimento date not null,
constraint PK_Clientes primary key (IDCliente),
constraint CK_TipoClienteClientes check (TipoCliente in ('Pessoal', 'Empresa')),
constraint CK_PrimeirosNomesClientes check (PrimeirosNomes not like '%[^A-Z ]%'),
constraint CK_UltimosNomesClientes check (UltimosNomes not like '%[^A-Z ]%'),
constraint CK_SexoClientes check (Sexo in ('M', 'F')),
constraint CK_NIFClientes check (NIF like ('[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
constraint CK_ContactoClientes check (Contacto like ('[1-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
constraint CK_CodigoPostalClientes check (CodigoPostal like ('[1-9][0-9][0-9][0-9][-][0-9][0-9][0-9]')),
constraint CK_DataNascimentoClientes check (year(DataNascimento) > 1950 and year(DataNascimento) < year(getdate())))

-- Criar Tabela 'CategoriasProdutos'
create table CategoriasProdutos
(IDCategoria int identity (1,1),
Categoria nvarchar(50),
constraint PK_CategoriasProdutos primary key (IDCategoria))


-- Criar Tabela 'Produtos'
create table Produtos
(IDProduto int identity (101,1),
IDCategoria int not null,
NomeProduto nvarchar(50) not null,
DescriçaoProduto nvarchar(50),
Marca nvarchar(25),
PreçoUnitario smallmoney not null,
constraint PK_Produtos primary key (IDProduto),
constraint FK_IDCategoriaProdutos foreign key (IDCategoria) references CategoriasProdutos (IDCategoria))


-- Criar Tabela 'Processos'
create table Processos
(IDProcesso int identity (1001,1),
TipoProcesso nvarchar(20) not null,
IDCliente int not null,
IDTecnicoInicio int not null,
IDLojaInicio int not null,
Equipamento nvarchar(25),
Avaria nvarchar(50),
DataInicio date not null,
DataEnvio date,
DataFim date,
EstadoProcesso nvarchar(9) default 'Aberto',
constraint PK_Processos primary key (IDProcesso),
constraint CK_TipoProcessoProcessos check (TipoProcesso in ('Processo Reparação', 'Processo Manutenção')),
constraint FK_IDClienteProcessos foreign key (IDCliente) references Clientes (IDCliente),
constraint FK_IDTecnicoInicioProcessos foreign key (IDTecnicoInicio) references Tecnicos (IDTecnico),
constraint FK_IDLojaInicio foreign key (IDLojaInicio) references Lojas (IDLoja),
constraint CK_DataInicioProcessos check (year(DataInicio) > 1950 and DataInicio <= getdate()),
constraint CK_DataEnvioProcessos check (DataEnvio > DataInicio and DataEnvio <= getdate()),
constraint CK_DataFimProcessos check (DataFim >= DataInicio and DataFim <= getdate()),
constraint CK_EstadoProcessoProcesso check (EstadoProcesso in ('Aberto', 'Encerrado')))


-- Criar Tabela 'ProcessosTarefas'
create table ProcessosTarefas
(IDProcesso int,
IDTarefa int identity (1,1),
DescriçaoTarefa nvarchar(50) not null,
LojaRealizaçao int,
TecnicoRealizaçao int not null,
DataRealizaçao date not null,
IDProduto int not null,
CustoUnitario money,
Quantidade int not null,
IVA decimal(18,2) not null default 0.23,
SubTotal as (CustoUnitario*Quantidade)+(CustoUnitario*Quantidade)*IVA,
constraint PK_ProcessosTarefas primary key (IDProcesso, IDTarefa),
constraint FK_IDProcessoProcessosTarefas foreign key (IDProcesso) references Processos (IDProcesso),
constraint FK_LojaRealizaçaoProcessosTarefas foreign key (LojaRealizaçao) references Lojas (IDLoja),
constraint FK_TecnicoRealizaçaoProcessosTarefas foreign key (TecnicoRealizaçao) references Tecnicos (IDTecnico),
constraint CK_DataRealizaçaoProcessosTarefas check (DataRealizaçao <= getdate()),
constraint FK_IDProdutoProcessosTarefas foreign key (IDProduto) references Produtos (IDProduto))


-- Criar Tabela 'Faturas'
create table Faturas
(IDFatura int identity (1001,1),
NumeroFatura nvarchar(20) unique,
DataEmissao date default getdate(),
IDProcesso int,
EstadoFatura nvarchar(9),
constraint PK_Faturas primary key (IDFatura),
constraint FK_IDProcessoFaturas foreign key (IDProcesso) references Processos (IDProcesso),
constraint CK_EstadoFaturaFaturas check (EstadoFatura in ('Emitida', 'Anulada')))


-- Segurança -- Trigger que não permite alterações no NIF dos Clientes
go
create trigger TR_ClientesNIF on Clientes after update as
if update (NIF)
	begin
		print 'Este campo não pode ser alterado.'
		rollback tran
		return
	end
go


-- Segurança -- Trigger que não permite alterações no NIF dos Tecnicos
create trigger TR_TecnicosNIF on Tecnicos after update as
if update (NIF)
	begin
		print 'Este campo não pode ser alterado.'
		rollback tran
		return
	end
go

-- Segurança -- Trigger que não permite a remoçao de dados dos Clientes
create trigger TR_ClientesDeleted on Clientes after delete as
begin
	print 'Os registos de Cliente não podem ser apagados.'
	rollback tran
	return
end
go

-- Segurança -- Trigger que não permite a remoçao de dados dos Tecnicos
create trigger TR_TecnicosDeleted on Tecnicos after delete as
begin
	print 'Os registos de Cliente não podem ser apagados.'
	rollback tran
	return
end
go

-- Segurança -- Trigger que não permite a remoçao de dados das Faturas
create trigger TR_FatuasDeleted on Faturas after delete as
begin
	print 'Os registos das Faturas não podem ser apagados.'
	rollback tran
	return
end
go

-- Segurança -- Trigger que Remove espaços duplicados entre Primeiros e Ultimos Nomes dos Clientes
create trigger TR_ClientesNomes on Clientes instead of insert, update as
declare @TipoCliente nchar(8), @NomeEmpresa nvarchar(50), @PrimeirosNomes nvarchar(50), @UltimosNomes nvarchar(50)
declare @Sexo nchar(1), @NIF nchar(9), @Contacto nchar(9), @Endereço nvarchar(50), @CodigoPostal nchar(8)
declare @Cidade nvarchar(50), @Pais nvarchar(50), @DataNascimento date
set @TipoCliente = (select TipoCliente from inserted)
set @NomeEmpresa = (select NomeEmpresa from inserted)
set @PrimeirosNomes = (select PrimeirosNomes from inserted)
set @UltimosNomes = (select UltimosNomes from inserted)
set @Sexo = (select Sexo from inserted)
set @NIF = (select NIF from inserted)
set @Contacto = (select Contacto from inserted)
set @Endereço = (select Endereço from inserted)
set @CodigoPostal = (select CodigoPostal from inserted)
set @Cidade = (select Cidade from inserted)
set @Pais = (select Pais from inserted)
set @DataNascimento = (select DataNascimento from inserted)
begin
    while charindex('  ', @PrimeirosNomes) > 0 
        set @PrimeirosNomes = replace(@PrimeirosNomes, '  ', ' ')
	while charindex('  ', @UltimosNomes) > 0 
		set @UltimosNomes = replace(@UltimosNomes, '  ', ' ')
	while charindex('  ', @NomeEmpresa) > 0 
		set @NomeEmpresa = replace(@NomeEmpresa, '  ', ' ')
	insert into Clientes (TipoCliente, NomeEmpresa, PrimeirosNomes, UltimosNomes, Sexo, NIF, Contacto, Endereço, CodigoPostal, Cidade, Pais, DataNascimento) 
	values (@TipoCliente, @NomeEmpresa, @PrimeirosNomes, @UltimosNomes, @Sexo, @NIF, @Contacto, @Endereço, @CodigoPostal, @Cidade, @Pais, @DataNascimento)
end
go

-- Segurança -- Trigger que Remove espaços duplicados entre Primeiros e Ultimos Nomes dos Técnicos
create trigger TR_TecnicosNomes on Tecnicos instead of insert, update as
declare @PrimeirosNomes nvarchar(50), @UltimosNomes nvarchar(50), @Sexo nchar(1), @NIF nchar(9), @Contacto nchar(9)
declare @Endereço nvarchar(50), @CodigoPostal nchar(8), @Cidade nvarchar(50), @Pais nvarchar(50)
declare @DataNascimento date, @DataIngresso date
set @PrimeirosNomes = (select PrimeirosNomes from inserted)
set @UltimosNomes = (select UltimosNomes from inserted)
set @Sexo = (select Sexo from inserted)
set @NIF = (select NIF from inserted)
set @Contacto = (select Contacto from inserted)
set @Endereço = (select Endereço from inserted)
set @CodigoPostal = (select CodigoPostal from inserted)
set @Cidade = (select Cidade from inserted)
set @Pais = (select Pais from inserted)
set @DataNascimento = (select DataNascimento from inserted)
set @DataIngresso = (select DataIngresso from inserted)
begin
	while charindex('  ', @PrimeirosNomes) > 0
		set @PrimeirosNomes = replace(@PrimeirosNomes, '  ', ' ')
	while charindex('  ', @UltimosNomes) > 0
		set @UltimosNomes = replace(@UltimosNomes, '  ', ' ')
	insert into Tecnicos (PrimeirosNomes, UltimosNomes, Sexo, NIF, Contacto, Endereço, CodigoPostal, Cidade, Pais, DataNascimento, DataIngresso) 
	values (@PrimeirosNomes, @UltimosNomes, @Sexo, @NIF, @Contacto, @Endereço, @CodigoPostal, @Cidade, @Pais, @DataNascimento, @DataIngresso)
end
go

-- Segurança -- Trigger que vai buscar dinamicamente o preço de cada um dos Produtos/Serviços
create trigger TR_PreçoProdutoProcessosTarefas on ProcessosTarefas instead of insert as
declare @IDProcesso int, @DescriçaoTarefa nvarchar(50), @LojaRealizaçao int, @TecnicoRealizaçao int
declare @DataRealizaçao date, @IDProduto int, @CustoUnitario money, @Quantidade int
set @IDProcesso = (select IDProcesso from inserted)
set @DescriçaoTarefa = (select DescriçaoTarefa from inserted)
set @LojaRealizaçao = (select LojaRealizaçao from inserted)
set @TecnicoRealizaçao = (select TecnicoRealizaçao from inserted)
set @DataRealizaçao = (select DataRealizaçao from inserted)
set @IDProduto = (select IDProduto from inserted)
set @CustoUnitario = (select PreçoUnitario from Produtos where IDProduto = @IDProduto)
set @Quantidade = (select Quantidade from inserted)
begin
	insert into ProcessosTarefas (IDProcesso, DescriçaoTarefa, LojaRealizaçao, TecnicoRealizaçao, DataRealizaçao, IDProduto, CustoUnitario, Quantidade) 
	values (@IDProcesso, @DescriçaoTarefa, @LojaRealizaçao, @TecnicoRealizaçao, @DataRealizaçao, @IDProduto, @CustoUnitario, @Quantidade)
end
go

-- Segurança -- Trigger que incrementa o NumeroFatura na Tabela 'Faturas'
create trigger TR_IncrementarFaturas on Faturas after insert as
declare @IDFatura int, @NumeroFatura nvarchar(20)
set @IDFatura = (select IDFatura from inserted)
set @NumeroFatura = convert(nvarchar(20), @IDFatura) +'/' +convert(nvarchar(4), year(getdate())) +'/PT'
update Faturas set NumeroFatura = @NumeroFatura where IDFatura = @IDFatura
go


-- Procedimentos -- Procedimento que Emite Faturas
create proc PR_EmitirFatura @IDProcesso int as
declare @NumeroFatura nvarchar(20), @Total money, @EstadoFatura nvarchar(9)
begin
if exists (select IDProcesso from Processos where IDProcesso = @IDProcesso)
	begin
		if not exists (select * from Faturas where IDProcesso = @IDProcesso and EstadoFatura = 'Emitida')
		insert into Faturas (IDProcesso, EstadoFatura) values (@IDProcesso, 'Emitida')
		update Processos set EstadoProcesso = 'Encerrado' where IDProcesso = @IDProcesso
		update Processos set DataFim = getdate() where IDProcesso = @IDProcesso
	end
	set @NumeroFatura = (select NumeroFatura from Faturas where IDProcesso = @IDProcesso)
	set @Total = (select sum(Subtotal)'Total' from ProcessosTarefas where IDProcesso = @IDProcesso)
	set @EstadoFatura = (select EstadoFatura from Faturas where IDProcesso = @IDProcesso)
	print 'Fatura nº: ' +@NumeroFatura
	select DescriçaoTarefa, IDProduto, CustoUnitario, Quantidade, IVA, SubTotal from ProcessosTarefas where IDProcesso = @IDProcesso
	print 'Total: ' +convert(nvarchar(20), @Total) +'€'
	print 'Estado da Fatura: ' +@EstadoFatura
end
go


-- Procedimentos -- Procedimento que Anula Faturas
create proc PR_AnularFatura @NumeroFatura nvarchar(20) as
declare @IDProcesso int
set @IDProcesso = (select IDProcesso from Faturas where NumeroFatura = @NumeroFatura)
if exists (select NumeroFatura from Faturas where NumeroFatura = @NumeroFatura)
update Faturas set EstadoFatura = 'Anulada' where NumeroFatura = @NumeroFatura
update Processos set EstadoProcesso = 'Aberto' where IDProcesso = @IDProcesso
go

-- Procedimentos -- Procedimento que recebe o IDCliente e mostra todos os Processos a ele associados
create proc PR_ConsultaCliente @IDCliente int as
if exists (select IDCliente from Processos where IDCliente = @IDCliente)
begin
print 'Processos do Cliente: ' +convert(nvarchar(4),@IDCliente)
print '------------------------------------------------------------------'
select P.IDProcesso, P.EstadoProcesso, sum(PT.SubTotal)'SubTotal' from Processos P
join ProcessosTarefas PT on P.IDProcesso = PT.IDProcesso
where IDCliente = @IDCliente
group by P.IDProcesso, P.EstadoProcesso
order by P.IDProcesso
end