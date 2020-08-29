 create or alter   view VW_ACD_VALIDACAO_NOTAS_COMPARATIVO AS       
with cte_nota_total_atividade as (      
   select nta.curriculo_aluno_id,       
          nta.aluno_id, nta.aluno_nome,       
       nta.disciplina_id, nta.disciplina_nome, nta.grade_id, nta.grade_nome ,  nta.grade_disciplina_id,     
       nta.etapa_ano_id, nta.etapa_ano, sum(isnull(nta.atividade_nota,0)) as nota_total      
     from vw_acd_aluno_turma_disciplina_nota_atividade nta           
       group by nta.curriculo_aluno_id, nta.aluno_id, nta.aluno_nome, nta.disciplina_id,       
             nta.disciplina_nome, nta.etapa_ano_id, nta.etapa_ano, nta.grade_id, nta.grade_nome,  nta.grade_disciplina_id       
)       
, cte_nota_recuperacao_atividade as (      
   select nta.curriculo_aluno_id,       
          nta.aluno_id, nta.aluno_nome,       
       nta.disciplina_id, nta.disciplina_nome,       
       nta.etapa_ano_id, nta.etapa_ano, nta.grade_id, nta.grade_nome ,  nta.grade_disciplina_id,    
    CASE WHEN sum(isnull(nta.atividade_nota,0)) >= 60 THEN 60 ELSE  sum(isnull(nta.atividade_nota,0)) END as nota_total      
     from vw_acd_aluno_turma_disciplina_nota_recuperacao nta           
       group by nta.curriculo_aluno_id, nta.aluno_id, nta.aluno_nome, nta.disciplina_id,       
             nta.disciplina_nome, nta.etapa_ano_id, nta.etapa_ano , nta.grade_id, nta.grade_nome,  nta.grade_disciplina_id     
)       
	,	cte_nota_disciplina_equivalente as (
			select cra.id as curriculo_aluno_id, grd.id  as gradedisciplina_id, con.nota as nota_equivalente, dis.id as disciplina_equ_id,  
			       EQU.grade_disciplina_id AS grade_disciplina_equ_id, dis.nome as disciplina_equ_nome, con.id
			  from curriculos_disciplinaconcluida con join curriculos_aluno cra on (cra.id = con.curriculo_aluno_id)
			                                          join curriculos_gradedisciplina grd on (grd.disciplina_id = con.disciplina_id)
													  join academico_disciplina       dis on (dis.id = grd.disciplina_id)
													  join academico_etapaano         eta on (eta.id = con.etapa_ano_id) 
													  join curriculos_grade           gra on (gra.id = grd.grade_id and 
													                                          gra.etapa_id = eta.etapa_id and 
													  									      gra.curriculo_id = cra.curriculo_id)
													  JOIN curriculos_gradedisciplinaequivalente EQU ON (EQU.grade_disciplina_equivalente_id = GRD.ID)
	)
      
	,	CTE_FINAL AS (
select tat.curriculo_aluno_id, tat.aluno_id, tat.aluno_nome, tat.disciplina_id, tat.disciplina_nome,       
       tat.etapa_ano_id, tat.etapa_ano, tat.grade_id, tat.grade_nome, isnull(rec.nota_total, tat.nota_total) nota_final,       
 CASE WHEN rec.nota_total IS NOT NULL THEN 'NOTA RECUPERACAO' ELSE 'NOTA NORMAL' END AS tipo_nota,    
      con.nota as nota_concluida, tat.grade_disciplina_id     
  from cte_nota_total_atividade tat left join cte_nota_recuperacao_atividade rec on (tat.curriculo_aluno_id = rec.curriculo_aluno_id and       
                                                                                     tat.disciplina_id = rec.disciplina_id and       
                                                                                     tat.etapa_ano_id = rec.etapa_ano_id and 
																					 tat.grade_disciplina_id = rec.grade_disciplina_id)      
         left join curriculos_disciplinaconcluida con on (con.curriculo_aluno_id = tat.curriculo_aluno_id and       
                                                          con.disciplina_id      = tat.disciplina_id and      
                                                          con.etapa_ano_id       = tat.etapa_ano_id) 
)
														  
						SELECT FIN.curriculo_aluno_id, FIN.aluno_id, FIN.aluno_nome, 
						       FIN.disciplina_id  as disciplina_cursada_id, 
						       FIN.disciplina_nome as disciplina_cursada_nome, 
							   FIN.etapa_ano_id, FIN.etapa_ano, FIN.grade_id, 
						       FIN.grade_nome, FIN.nota_final, FIN.tipo_nota, 
							   case when equ.id is null then FIN.nota_concluida else nota_equivalente end as nota_concluida, 
							   FIN.grade_disciplina_id, EQU.disciplina_equ_nome, equ.nota_equivalente
						FROM CTE_FINAL FIN LEFT JOIN cte_nota_disciplina_equivalente EQU ON (FIN.curriculo_aluno_id = EQU.curriculo_aluno_id AND 
						                                                                     FIN.GRADE_DISCIPLINA_ID = EQU.grade_disciplina_equ_id)										
			
			select * from VW_ACD_VALIDACAO_NOTAS_COMPARATIVO 