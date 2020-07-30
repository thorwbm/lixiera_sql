WITH	cte_email AS (
			SELECT ALUNO_CPF, LTRIM(RTRIM(lower(aluno_email))) AS EMAIL, tipo = 2 FROM VW_PES_PESSOA
			WHERE-- ORIGEM = 'MATRICULA' AND 
				  aluno_email IS NOT NULL 
)

--select * from pessoas_email

			INSERT INTO pessoas_email
			SELECT DISTINCT ema.email, PRINCIPAL = 0, PES.ID, ema.TIPO FROM cte_email ema LEFT JOIN PESSOAS_PESSOA PES ON (ema.ALUNO_CPF = PES.CPF)
			WHERE PES.ID IS NOT NULL  AND 
			      NOT EXISTS (SELECT 1
				                FROM pessoas_email emax 
							   WHERE emax.PESSOA_ID = PES.ID AND 
							         ltrim(rtrim(emax.email)) = ema.email)

/*
select * 
--update ema set ema.principal = 1
from pessoas_email ema where pessoa_id in (
select pessoa_id 
from pessoas_email
where principal = 0
group by pessoa_id 
having count(1) = 1)

update ema set ema.principal = 1
from pessoas_email ema 
where principal = 0 
and id = (select max(id) from pessoas_email pem where pem.pessoa_id = ema.pessoa_id)
*/

									