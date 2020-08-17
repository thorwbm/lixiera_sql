DECLARE @DATAEXECUCAO DATETIME    
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME);  

--begin tran; 

with cte_insert as (
select distinct curso.id as cursoid, curso.nome as curso_nome, disc.id as disciplina_id, disc.nome as disciplina_nome, 
       turma.etapa_ano_id, gd.carga_horaria, etp.nome as etapa_nome 
from academico_turmadisciplina td
join academico_turma turma on turma.id = td.turma_id
join academico_disciplina disc on disc.id = td.disciplina_id
join curriculos_grade grade on grade.id = turma.grade_id
join curriculos_gradedisciplina gd on gd.grade_id = grade.id and gd.disciplina_id = td.disciplina_id
join academico_curso curso on curso.id = turma.curso_id
join academico_etapaano eta on (eta.id = turma.etapa_ano_id)
join academico_etapa    etp on (etp.id = eta.etapa_id) 
where year(turma.inicio_vigencia) = 2020
  and month(turma.inicio_vigencia) > 6
  and month(turma.termino_vigencia) <= 12
) 

	,	cte_plano_semestre_anterior as (
			select pla.id as plano_ensino_id,  pla.curso_id, pla.disciplina_id,
			       pla.ementa, pla.conteudo_programatico, pla.metodos_de_ensino,
				   pla.carga_horaria, pla.praticas_extensionistas, 
				   pla.agrupar_competencias, pla.exigir_atividades, pla.alterar_competencias_gerais,
				   alterar_competencias_especificas
              from planos_ensino_planoensino pla --join academico_etapaano eta on (eta.id = pla.etapa_ano_id)
			 where pla.ano = 2020 and 
			       pla.matriz not like '%2020 - 2' --and eta.periodo = 1
)



 --eta.ano, eta.periodo, cte.* 


--insert into planos_ensino_planoensino (
--       criado_em, atualizado_em, criado_por, atualizado_por, carga_horaria, ementa, curso_id, disciplina_Id, 
--	   matriz, serie, conteudo_programatico, metodos_de_ensino, etapa_ano_id, curriculo_id, replicado_em, 
--	   permite_replicacao_criterio, grade_disciplina_id, ano, praticas_extensionistas, 
--	   agrupar_competencias, exigir_atividades,alterar_competencias_gerais,alterar_competencias_especificas)

select distinct criado_em = @DATAEXECUCAO, atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717,
       carga_horaria = cte.carga_horaria, 
	   ementa = ant.ementa, -- 'nova ementa', 
	   cte.cursoid, cte.disciplina_Id, 
	   matriz = cte.curso_nome + ' / ' + cte.disciplina_nome + ' / 2020 - 2' , 
	   serie = cte.etapa_nome, 
	   conteudo_programatico = ant.conteudo_programatico, -- 'novo conteudo programatico', 
	   metodos_de_ensino = ant.metodos_de_ensino, -- 'novo metodo de ensino',
	   etapa_ano_id = cte.etapa_ano_id, 
	   curriculo_id = null, 
	   replicado_em = null, 
	   permite_replicacao_criteiro = 0, 
	   grade_disciplina_id = null, 
	   ano = 2020,
	   praticas_extensionistas = ant.praticas_extensionistas, 
	   isnull(ant.agrupar_competencias,0), isnull(ant.exigir_atividades,1),
	   isnull(ant.alterar_competencias_gerais,0), isnull(ant.alterar_competencias_especificas,0)

  from cte_insert cte --join academico_etapaano          eta on (eta.id = cte.etapa_ano_id)
                 left join cte_plano_semestre_anterior ant on (cte.cursoid = ant.curso_id and
                                                               cte.disciplina_id = ant.disciplina_id and
															   cte.carga_horaria = ant.carga_horaria)
				 left join planos_ensino_planoensino   xxx on (xxx.curso_id = cte.cursoid and 
				                                               xxx.disciplina_id = cte.disciplina_id and 
															   xxx.carga_horaria = cte.carga_horaria and 
															   xxx.etapa_ano_id  = cte.etapa_ano_id  and
															   xxx.ano           = 2020)

 
where xxx.id is null and 
      ant.plano_ensino_id is null --and 
     -- eta.periodo > 0



  select *   
	from planos_ensino_planoensino pla join academico_
   where matriz like '%/ 2020 - 2'


