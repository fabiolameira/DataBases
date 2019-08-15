-- P�gina 148 da Sebenta -- Exerc�cio 3
create database db_ControloQuotas
use db_ControloQuotas

-- Cria��o da Tabela 'TipoQuotas'
create table TipoQuotas
(IDTipoQuota int,
TipoQuota nchar(10) not null,
QuotaMensal smallmoney not null,
constraint PK_TipoQuotas primary key (IDTipoQuota))

-- Cira��o da Tabela 'Socios'
create table Socios
(NumeroSocio int identity (1000,1),
IndicadoPor int,
Numecompleto nvarchar(30) not null,
DataInscri��o datetime default (getdate()),
IDTipoQuota int not null,
Sexo char(1),
constraint PK_Socios primary key (NumeroSocio),
constraint CK_Sexo check (Sexo in ('M', 'F')),
constraint FK_IndicadoPor foreign key (IndicadoPor)
references Socios (NumeroSocio),
constraint FK_IDTipoQuota foreign key (IDTipoQuota)
references TipoQuotas (IDTipoQuota) on update cascade)

-- Cria��o da Tabela 'PagamentosQuotas'
create table PagamentosQuotas
(NumeroSocio int,
DataPagamento datetime default (getdate()),
AnoQuota char(4),
MesQuota char(2),
Mensalidade smallmoney,
IVA decimal(4,2),
TotalPagar as (Mensalidade + (Mensalidade * IVA)),
constraint PK_PagamentosQuotas primary key (NumeroSocio, AnoQuota, MesQuota),
constraint FK_NumeroSocio foreign key (NumeroSocio)
references Socios (NumeroSocio),
constraint CK_AnoQuota check (AnoQuota like ('[2-9][0-9][0-9][0-9]')),
constraint CK_MesQuota check (MesQuota like ('[0-1][0-9]')))

-- Inserir Dados na Tabela 'TipoQuotas'
insert into TipoQuotas values (1, 'Juvenil', 50.00)
insert into TipoQuotas values (2, 'Adulto', 70.00)
insert into TipoQuotas values (3, 'Senior', 50.00)

-- Inserir Dados na Tabela 'Socios'
insert into Socios (Numecompleto, DataInscri��o, IDTipoQuota, Sexo)
values ('Jo�o Paulo Costa', '2010-01-01 00:00', 1, 'M')
insert into Socios (Numecompleto, DataInscri��o, IDTipoQuota, Sexo)
values ('Maria Jo�o Abreu', '2010-01-01 00:00', 2, 'F')
insert into Socios (Numecompleto, DataInscri��o, IDTipoQuota, Sexo)
values ('Pedro Jos� Santos', '2010-01-01 00:00', 3, 'F')

-- Inserir Dados na Tabela 'PagamentosQuotas'
insert into PagamentosQuotas (NumeroSocio, DataPagamento, AnoQuota, MesQuota)
values ('1000', '2010-01-19 10:45:51.060', '2010', '01')
insert into PagamentosQuotas (NumeroSocio, DataPagamento, AnoQuota, MesQuota)
values ('1000', '2010-01-19 10:45:51.060', '2010', '02')
insert into PagamentosQuotas (NumeroSocio, DataPagamento, AnoQuota, MesQuota)
values ('1001', '2010-01-19 10:45:51.060', '2010', '01')
insert into PagamentosQuotas (NumeroSocio, DataPagamento, AnoQuota, MesQuota)
values ('1001', '2010-01-19 10:45:51.060', '2010', '02')
insert into PagamentosQuotas (NumeroSocio, DataPagamento, AnoQuota, MesQuota)
values ('1002', '2010-01-19 10:45:51.060', '2010', '01')

-- Uso do Update para Inserir o Campo 'IndicadoPor'
update Socios set IndicadoPor = 1002 where NumeroSocio = 1000
update Socios set IndicadoPor = 1002 where NumeroSocio = 1001

-- Uso do Update para Alterar o Valor da Mensalidade Senior
update TipoQuotas set QuotaMensal = 40.00 where TipoQuota = 'Senior'

-- Uso do Update para Alterar o Valor do IDTipoQuota 3 para 13
update TipoQuotas set IDTipoQuota = 13 where IDTipoQuota = 3

-- Uso do AlterTable para Adicionar o Campo 'EstadoInscri��o' � tabela 'Socios'
alter table Socios add EstadoInscri��o nchar(10),
constraint CK_EstadoInscri��o check (EstadoInscri��o in ('Activa', 'Desativa'))
update Socios set EstadoInscri��o = 'Activa'

-- Uso do Update para tornar o Valor da Mensalidade Din�mico
update PagamentosQuotas set Mensalidade = (
select QuotaMensal from TipoQuotas as TQ1
where TQ1.IDTipoQuota = TQ.IDTipoQuota)
from PagamentosQuotas PQ
join Socios S on PQ.NumeroSocio = S.NumeroSocio
join TipoQuotas TQ on S.IDTipoQuota = TQ.IDTipoQuota

-- Uso do Update para Inserir Valores no Campo 'IVA'
update PagamentosQuotas set IVA = 0.21

select * from PagamentosQuotas