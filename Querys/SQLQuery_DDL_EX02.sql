-- Página 147 da Sebenta -- Exercício 2
create database ERP_Consultas
use ERP_Consultas

-- Criação da Tabela 'Utentes'
create table Utentes
(NIC int,
NumeroUtenteSaude int not null unique,
Nomes nchar(20) not null,
Apelidos nchar(20) not null,
constraint PK_Utentes primary key (NIC))

-- Criação da Tabela 'MedicosFamilia'
create table MedicosFamilia
(NumeroMedico nchar(3),
NomeCompleto nchar(40),
NIC int,
Nacionalidade nchar(20),
constraint PK_MedicosFamilia primary key (NumeroMedico))

-- Criação da Tabela 'AgendaConsultas'
create table AgendaConsultas
(NumeroConsulta int identity (1,1),
NumeroConsultaAnterior int,
DataHoraConsulta datetime not null,
NumeroUtenteSaude int,
NumeroMedico nchar(3),
Status nchar(10) default 'Agendada',
constraint PK_AgendaConsultas primary key (NumeroConsulta),
constraint FK_AgendaConsultas foreign key (NumeroConsultaAnterior) 
references AgendaConsultas (NumeroConsulta),
constraint FK_NumeroMedico foreign key (NumeroMedico)
references MedicosFamilia (NumeroMedico) on update cascade,
constraint FK_NumeroUtenteSaude foreign key (NumeroUtenteSaude)
references Utentes (NumeroUtenteSaude),
constraint CK_Status check (Status in ('Agendada', 'Anulada', 'Realizada')))

-- Inserir Dados na Tabela 'Utentes'
insert into Utentes values (12345678, 24364718, 'José Silva', 'Lopes')
insert into Utentes values (87654321, 24364787, 'Maria João', 'Costa')

-- Inserir Dados na Tabela 'MedicosFamilia'
insert into MedicosFamilia values ('M01', 'João Seabra Pereira', 25371829, 'Portugal')
insert into MedicosFamilia values ('M02', 'Francisco Manuel Santo', 98654317, 'Portugal')

-- Inserir Dados na Tabela 'AgendaConsultas'
insert into AgendaConsultas (DataHoraConsulta, NumeroUtenteSaude, NumeroMedico, Status)
values ('2011-01-27 10:00', 24364718, 'M01', 'Realizada')
insert into AgendaConsultas (DataHoraConsulta, NumeroUtenteSaude, NumeroMedico, Status)
values ('2011-01-27 10:00', 24364787, 'M02', 'Realizada')
insert into AgendaConsultas (NumeroConsultaAnterior, DataHoraConsulta, NumeroUtenteSaude, NumeroMedico, Status)
values (1, '2011-03-23 11:00', 24364718, 'M01', 'Agendada')
insert into AgendaConsultas (NumeroConsultaAnterior, DataHoraConsulta, NumeroUtenteSaude, NumeroMedico, Status)
values (2, '2011-03-24 12:00', 24364787, 'M02', 'Agendada')

-- Uso do Update para alterar o Número do Médico
update MedicosFamilia set NumeroMedico = 'M10' where NumeroMedico = 'M01'

-- Import e Alter Table 'Medicamentos'
select * from Medicamentos
alter table Medicamentos add IDMedicamento int identity (1,1) not null
alter table Medicamentos add constraint PK_Medicamentos primary key (IDMedicamento)

-- Criação de Tabela 'ConsultasMedicamentos'
create table ConsultasMedicamentos
(NumeroConsulta int,
IDMedicamento int,
Problema nchar(255)
constraint PK_ConstultasMedicamentos primary key (NumeroConsulta, IDMedicamento),
constraint FK_Consultas foreign key (NumeroConsulta)
references AgendaConsultas (NumeroConsulta),
constraint FK_Medicamentos foreign key (IDMedicamento)
references Medicamentos (IDMedicamento))