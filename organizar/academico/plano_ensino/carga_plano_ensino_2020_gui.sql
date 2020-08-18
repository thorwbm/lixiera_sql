
begin tran 

insert into planos_ensino_planoensino (
             criado_em, atualizado_em, criado_por, atualizado_por, carga_horaria, 
			 ementa, curso_id, disciplina_Id, matriz, serie, conteudo_programatico, metodos_de_ensino, 
			 etapa_ano_id, permite_replicacao_criterio, ano, praticas_extensionistas, agrupar_competencias, 
			 exigir_atividades, alterar_competencias_gerais, alterar_competencias_especificas)


select distinct
	   criado_em = getdate(), atualizado_em = getdate(),criado_por = 11717 , atualizado_por = 11717 , 
		pla.carga_horaria, pla.ementa, pla.curso_id, pla.disciplina_Id, 
	   matriz = curso.nome + ' / ' + disc.nome + ' / 2020 - 2', 
	   serie = etp.nome, pla.conteudo_programatico, pla.metodos_de_ensino, 
	   etapa_ano_id = turma.etapa_ano_id,  
	   permite_replicacao_criterio = 0 ,  ano = 2020, pla.praticas_extensionistas, 
	   agrupar_competencias = 0, exigir_atividades = 1,alterar_competencias_gerais = 0,alterar_competencias_especificas = 0

from academico_turmadisciplina td
join academico_turma turma on turma.id = td.turma_id
join academico_disciplina disc on disc.id = td.disciplina_id
join curriculos_grade grade on grade.id = turma.grade_id
join curriculos_gradedisciplina gd on gd.grade_id = grade.id and gd.disciplina_id = td.disciplina_id
join academico_curso curso on curso.id = turma.curso_id
join academico_etapaano eta on (eta.id = turma.etapa_ano_id)
join academico_etapa    etp on (etp.id = eta.etapa_id) 
join planos_ensino_planoensino pla on (pla.curso_id = curso.id and pla.disciplina_id = disc.id and pla.carga_horaria = gd.carga_horaria)


where year(turma.inicio_vigencia) = 2020
  and month(turma.inicio_vigencia) > 6
  and month(turma.termino_vigencia) <= 12 
  and pla.ano = 2020 and 
      pla.matriz not like '%2020 - 2' 
	

-- commit 

--	  rollback 
/*

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
--  and eta.id = 35
) 


select * from cte_insert cte left join planos_ensino_planoensino pla on (cte.cursoid = pla.curso_id and 
                                                                    cte.disciplina_id = pla.disciplina_id and 
																	cte.etapa_ano_id = pla.etapa_ano_id and
																	cte.carga_horaria = pla.carga_horaria and matriz like '%2020 - 2')
	where  pla.id is  null --  matriz like '%2020 - 2'


	select * from planos_ensino_planoensino
	where curso_id = 1 and 
	      disciplina_id = 3863 and 
		 -- etapa_ano_id = 3669 and 
		  carga_horaria = 40

*/