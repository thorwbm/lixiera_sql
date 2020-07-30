
create or alter view VW_PRO_CURRICULO_TURMA_ESTAGIO as (
select CUR.ID AS CURRICULO_ID, CUR.NOME AS CURRICULO_NOME, 
	   TUR.ID AS TURMA_ID, TUR.NOME AS TURMA_NOME, 
       DIS.ID AS DISCIPLINA_ID, DIS.NOME AS DISCIPLINA_NOME,
	   GRA.ID AS GRADE_ID, GRA.NOME AS GRADE_NOME,
	   ETA.ETAPA,
       TDS.ID AS TURMADISCIPLINA_ID
   from curriculos_curriculo cur with(nolock)
                                join curriculos_grade           gra with(nolock) on (gra.curriculo_id = cur.id)
                                join academico_etapa            eta with(nolock) on (eta.id = gra.etapa_id)
                                join curriculos_gradedisciplina gds with(nolock) on (gds.grade_id = gra.id)
                                join academico_disciplina       dis with(nolock) on (dis.id = gds.disciplina_id)
                                join academico_turma            tur with(nolock) on (tur.grade_id = gra.id)
                                join academico_turmadisciplina  tds with(nolock) on (tds.turma_id = tur.id and 
								                                                     tds.disciplina_id = gds.disciplina_id)
where dis.nome LIKE 'ESTAGIO%'
)