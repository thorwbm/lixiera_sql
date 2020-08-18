  
create OR ALTER view VW_CURRICULO_CURSO_TURMA_DISCIPLINA_ALUNO_GRADE as       
select alu.id as aluno_id, alu.nome as aluno_nome,        
       cur.id as curso_id, cur.nome as curso_nome,       
    tur.id as turma_id, tur.nome as turma_nome,       
    dis.id as disciplina_id, dis.nome as disciplina_nome,       
    tds.id as turma_disciplina_id,       
    gra.id as grade_id, gra.nome as grade_nome,       
    crc.id as curriculo_id, crc.nome as curriculo_nome ,     
 smd.id as status_mat_dis_id, smd.nome as status_mat_dis_nome ,    
 tda.criado_em as turma_disciplina_aluno_criado_em,   
 tda.curriculo_aluno_id  as tda_curriculo_aluno_id , tda.id AS TURMA_DISCIPLINA_ALUNO_ID 
     
 from academico_aluno alu join academico_turmadisciplinaaluno      tda on (alu.id = tda.aluno_id)      
                          join academico_turmadisciplina           tds on (tds.id = tda.turma_disciplina_id)      
                          join academico_turma                     tur on (tur.id = tds.turma_id)      
                          join curriculos_grade                    gra on (gra.id = tur.grade_id)      
                          join curriculos_curriculo                crc on (crc.id = gra.curriculo_id)      
                          join academico_disciplina                dis on (dis.id = tds.disciplina_id)      
                          join academico_curso                     cur on (cur.id = tur.curso_id)    
                          join academico_statusmatriculadisciplina smd on (smd.id = tda.status_matricula_disciplina_id)    