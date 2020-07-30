with cte_educat as (
			select aluno_cpf collate database_default  as aluno_cpf, cast(round(sum(carga_horaria),2) as numeric(10,2)) as horas_academicas
			from VW_ATIVIDADE_COMPLEMENTAR_ALUNO
			group by aluno_cpf
) 

	,	cte_atividade as (
			select CPFALUNO collate database_default  as aluno_cpf, cast(round(sum(horcomputada),2) as numeric(10,2)) as horas_academicas, 
			CURSO_NOME collate database_default  as curso_nome
			from atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO
			where exportado = 1
			group by cpfaluno,CURSO_NOME
)

			select  pes.aluno_cpf, pes.aluno_ra, pes.aluno_nome, pes.curriculo_aluno_status_nome, pes.curriculo_nome  ,
			       ati.horas_academicas as horas_academicas_atividade,
			       horas_atividade = right('0000'+cast(cast(ati.horas_academicas as int) as varchar(4)),4) + ':' +  right('00'+cast(cast(round(ati.horas_academicas * 60,1)as int) % 60 as varchar(3)),2),
			       edu.horas_academicas as horas_academicas_educat,
			       horas_educat    = right('0000'+cast(cast(edu.horas_academicas as int) as varchar(4)),4) + ':' +  right('00'+cast(cast(round(edu.horas_academicas * 60,1)as int) % 60 as varchar(3)),2)
			
			from cte_atividade ati join vw_Curriculo_aluno_pessoa pes on (ati.aluno_cpf = pes.aluno_cpf and 
			                                                              pes.curriculo_aluno_status_id in  (13,16,14,18) and 
																		  pes.curriculo_nome not in ('CURRÍCULO CURSO EXTENSÃO EM ORATÓRIA 2020') and 
																		  ati.curso_nome = pes.curso_nome)
			                        left join cte_educat edu on (ati.aluno_cpf = edu.aluno_cpf)
			   
			where edu.aluno_cpf is not null  and 
			      edu.horas_academicas <> ati.horas_academicas 
				  order by pes.aluno_nome




				--  select distinct curriculo_aluno_status_id,curriculo_aluno_status_nome from vw_Curriculo_aluno_pessoa


