-- db_Inqueritos1 -- Exercícios: 
--Quadro 1
use db_Inqueritos1
select * from Inqueritos

select count(*) from Inqueritos

select avg(age)'Media', max(age)'MaisIdosa', min(age)'MaisNova' 
from Inqueritos

-- Quadro 2
select count(*)'NumSolteiros', avg(Age)'Media' 
from Inqueritos
where MaritalStatus = 0

select count(*)'NumSolteiros', avg(Age)'Media' 
from Inqueritos
where MaritalStatus = 1

select MaritalStatus, count(*)'NumSolteiros', avg(Age)'Media' 
from Inqueritos
Group by MaritalStatus

select Gender, count(*)'NumPessoas', avg(age)'IdadeMedia', max(age)'IdadeMaxima', min(age)'IdadeMinima'
from Inqueritos
Group by Gender

-- Quadro 3
select Gender, MaritalStatus, count(*)'NumPessoas' 
from Inqueritos
group by Gender, MaritalStatus
order by Gender

-- Quadro 4
select Gender, MaritalStatus, Wireless, count(*)'NumPessoas'
from Inqueritos
group by Gender, MaritalStatus, Wireless
Order by Gender

-- Quadro 5
select count(*) from Inqueritos
where Education = 3 and Retired = 0 and EmploymentCategory = 3