--  41318	GUILHERME TOFANE MAIA VILASBOAS 
--select * from curriculos_disciplinaconcluida
with cte_aluno_disciplina as (
			select cgd.*, cra.aluno_id, cra.id as curriculo_aluno_id, alu.nome as aluno_nome
			  from vw_curriculo_grade_disciplina cgd join curriculos_aluno cra on (cgd.curriculo_id = cra.curriculo_id)
			                                         join academico_aluno  alu on (alu.id = cra.aluno_id)
			 where cgd.curriculo_nome in ('MEDICINA 2015/6-1 (1-2015)','ENFERMAGEM 2016/10-1','PSICOLOGIA 2016/10-1','FISIOTERAPIA 2016/5-1D') and 
				   cra.status_id = 13 and cra.aluno_id = 41318
	  
) 
	,	cte_aluno_disciplina_situacao as (
select  cad.aluno_id , cad.aluno_nome , cad.curriculo_aluno_id, cad.disciplina_id, cad.gradeDisciplina_id, cad.curriculo_nome, cad.curriculo_id, 
        situacao = case when dsc.id is null then 'nao concluido' else 'concluido' end 
  from cte_aluno_disciplina cad left join curriculos_disciplinaconcluida dsc on (cad.curriculo_aluno_id = dsc.curriculo_aluno_id and 
                                                                                 cad.disciplina_id = dsc.disciplina_id and 
                                                                                 dsc.status_id in (2,6)) 							                                          
) 

	,	cte_turmadisciplinaaluno_cursando as (
			select distinct tda.curriculo_aluno_id, tda.aluno_id, tds.disciplina_id 
			  from cte_aluno_disciplina_situacao cte left join academico_turmadisciplinaaluno tda on (cte.curriculo_aluno_id = tda.curriculo_aluno_id and )
			  join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id
			                                          
			 where tda.status_matricula_disciplina_id = 1
)

	,	cte_alunos_tda as (
			select cad.*, case when cur.curriculo_aluno_id is null then 'nao cursada' else 'cursando' end as situacao_tda
			  from cte_aluno_disciplina_situacao cad left join cte_turmadisciplinaaluno_cursando cur on (cad.curriculo_aluno_id = cur.curriculo_aluno_id and 
			                                                                                             cad.disciplina_id = cur.disciplina_id )													
			 where cad.situacao = 'nao concluido'  
)

	,	cte_alunos_disciplina_1 as (
		   select cad.*, dis.nome as disciplina_nome, tda.situacao_tda, eqv.disciplina 
		     from cte_aluno_disciplina_situacao cad join academico_disciplina dis on (dis.id = cad.disciplina_id)
			                                        left join cte_alunos_tda tda on (cad.curriculo_aluno_id = tda.curriculo_aluno_id and 
			                                                                         cad.disciplina_id      = tda.disciplina_id)
													left join vw_gradedisciplinaequivalente eqv on (eqv.grade_disciplina_equivalente_id = cad.gradeDisciplina_id and 
													                                                eqv.curriculo_id = cad.curriculo_id)			
) 

	,	cte_equivalencia as (
			select equ.grade_disciplina_id, tda.curriculo_aluno_id
			  from academico_turmadisciplinaaluno tda join academico_turmadisciplina  tds on (tds.id = tda.turma_disciplina_id)
													  join academico_disciplina       dis on (dis.id = tds.disciplina_id)
													  join academico_turma            tur on (tur.id = tds.turma_id)
													  join curriculos_grade           gra on (gra.id = tur.grade_id)
													  join curriculos_gradedisciplina gds on (gra.id = gds.grade_id and 
																							  gds.disciplina_id = tds.disciplina_id)
													  join curriculos_gradedisciplinaequivalente equ on (equ.grade_disciplina_equivalente_id = gds.id)
)


	, cte_final as (
select ald.aluno_id, ald.aluno_nome, ald.curriculo_aluno_id, ald.disciplina_id, ald.gradeDisciplina_id, ald.curriculo_nome, 
       ald.curriculo_id, ald.situacao, ald.disciplina_nome, ald.situacao_tda,  
	   case when equ.grade_disciplina_id is null then 'nao e equivalencia' else 'equivalente' end as equivalencia , 

	   situacao_final = case when situacao_tda = 'nao cursada' and equ.grade_disciplina_id is not null then 'cursando'
	                         when situacao_tda = 'cursando'    then 'cursando' else 'nao cursada'  end

from cte_alunos_disciplina_1 ald left join cte_equivalencia equ on (equ.curriculo_aluno_id = ald.curriculo_aluno_id and 
                                                                             equ.grade_disciplina_id = ald.gradeDisciplina_id)



)

select * from cte_final cte
where not exists(select 1 from cte_final ctex where cte.curriculo_aluno_id = ctex.curriculo_aluno_id and ctex.situacao_final = 'nao cursada' )
