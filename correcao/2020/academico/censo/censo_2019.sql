with cte_atividade_complementar as (
			select curriculo_aluno_id, sum(carga_horaria) as qtd_carga_horaria
			  from atividades_complementares_atividade
			 group by curriculo_aluno_id

)	
	,	cte_optativa_aprovado_excurricular as (
			select cra.aluno_id as aluno_id, dsc.curriculo_aluno_id, sum(dsc.carga_horaria) as carga
			  from curriculos_disciplinaconcluida dsc join academico_exigenciamatriculadisciplina exi on (dsc.exigencia_id = exi.id)
															 join curriculos_aluno                cra on (cra.id = dsc.curriculo_aluno_id)
			where exi.id in (1,4)  and --optativa extracurricular
				  dsc.status_id = 2
				  group by cra.aluno_id, dsc.curriculo_aluno_id
) 
	,	cte_optativa_aprovado_curricular as (
			select cra.aluno_id as aluno_id, dsc.curriculo_aluno_id, sum(dsc.carga_horaria) as carga
			  from curriculos_disciplinaconcluida dsc join academico_exigenciamatriculadisciplina exi on (dsc.exigencia_id = exi.id)
															 join curriculos_aluno                cra on (cra.id = dsc.curriculo_aluno_id)
			where exi.id = 2 and --optativa curricular
				  dsc.status_id in (2,6,7)
				  group by cra.aluno_id, dsc.curriculo_aluno_id
) 
	,	cte_sintetico_horas as (
			select acc.CURRICULO_NOME, acc.ALUNO_NOME, acc.ALUNO_RA, acc.aluno_id, 
				   horas_atividade_complementar = isnull(ati.qtd_carga_horaria,0), 
				   horas_optativa               = isnull(exc.carga,0), 
				   horas_curricular             = isnull(crc.carga,0) 
				   , acc.curriculo_aluno_id,
				   total = isnull(ati.qtd_carga_horaria,0) + isnull(exc.carga,0) +  isnull(crc.carga,0),
				   acc.curriculo_aluno_status_id, acc.curriculo_aluno_status_nome

			from vw_curriculo_aluno acc left join cte_atividade_complementar         ati on (ati.curriculo_aluno_id = acc.curriculo_aluno_id)
										left join cte_optativa_aprovado_excurricular exc on (exc.curriculo_aluno_id = acc.curriculo_aluno_id)
										left join cte_optativa_aprovado_curricular   crc on (crc.curriculo_aluno_id = acc.curriculo_aluno_id) 
			where acc.curriculo_aluno_status_id not in (21,19,12,16,14)
)

		--	select  carga_horaria_integralizada, aac.ano_cursado, sth.*
			update cen set cen.carga_horaria_integralizada = sth.total
			from censo_censo cen left join vw_aluno_ano_cursado aac on (aac.aluno_id = cen.aluno_id and aac.ano_cursado = 2019)
			                     left join cte_sintetico_horas sth on (sth.aluno_id = cen.aluno_id)
			where carga_horaria_integralizada is not null and 
			      isnull(sth.total,-1.0) <> isnull(carga_horaria_integralizada,-2.0) and sth.total is not null 


--select * into tmp_censo_censo_05_03_2020 from  censo_censo
-- drop table tmp_validacao_censo
--select * from vw_aluno_curriculo_curso_turma_etapa_discplina 
--select * from academico_exigenciamatriculadisciplina


