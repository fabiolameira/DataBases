use tempdb

-- Criar Tabela
create table Tecnicos
(IDCliente int identity (1,1),
PrimeirosNomes nvarchar(50),
UltimosNomes nvarchar(50),
constraint CK_PrimeirosNomesClientes check (PrimeirosNomes not like '%[^A-Z ]%'),
constraint CK_UltimosNomesClientes check (UltimosNomes not like '%[^A-Z ]%'))

-- Inserir Dados
insert into Tecnicos (PrimeirosNomes, UltimosNomes) values ('Fábio          André', 'Miranda             Lameira')

select * from Tecnicos

truncate table Tecnicos

drop table Tecnicos


-- TESTE (1) --
create trigger TR_TecnicosNomes on Tecnicos instead of insert, update as
declare @PrimeirosNomes nvarchar(50), @UltimosNomes nvarchar(50)
set @PrimeirosNomes = (select PrimeirosNomes from inserted)
set @UltimosNomes = (select UltimosNomes from inserted)
begin
	while charindex('  ', @PrimeirosNomes) > 0
		set @PrimeirosNomes = replace(@PrimeirosNomes, '  ', ' ')
	while charindex('  ', @UltimosNomes) > 0
		set @UltimosNomes = replace(@UltimosNomes, '  ', ' ')
	insert into Tecnicos (PrimeirosNomes, UltimosNomes) values (@PrimeirosNomes, @UltimosNomes)
end

drop trigger TR_TecnicosNomes