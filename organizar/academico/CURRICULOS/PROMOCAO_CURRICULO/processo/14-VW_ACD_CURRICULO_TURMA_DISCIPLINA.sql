
CREATE   VIEW [dbo].[VW_ACD_CURRICULO_TURMA_DISCIPLINA] AS   
SELECT tds.id as turma_disciplina_id, tds.maximo_vagas AS turma_disciplina_max_vaga,   
       crc.id AS curriculo_id, crc.nome AS curriculo_nome,   
       cur.id AS curso_id, cur.nome AS curso_nome,   
       dis.id AS disciplina_id, dis.nome AS disciplina_nome,  
       tur.id AS turma_id, tur.nome AS turma_nome,   
       case when turma_pai_id is null then 'PAI' ELSE 'FILHA' END AS tipo_turma,  
       tur.inicio_vigencia, tur.termino_vigencia,   
       cat.id AS turma_categoria_id, cat.nome as turma_categoria_nome,  
       gra.id AS grade_id, gra.nome as grade_nome,   
       eta.etapa_id, eta.ano AS etapa_ano, eta.periodo as etapa_periodo  
  
  FROM academico_turmadisciplina tds JOIN academico_turma           tur ON (tur.id = tds.turma_id)  
                                     JOIN academico_disciplina      dis ON (dis.id = tds.disciplina_id)  
                                     JOIN curriculos_grade          gra ON (gra.id = tur.grade_id)  
                                     JOIN academico_etapaano        eta ON (eta.id = tur.etapa_ano_id)  
                                     JOIN academico_categoriaturma  cat ON (cat.id = tur.categoria_id)  
                                     JOIN curriculos_curriculo      crc ON (crc.id = gra.curriculo_id)  
                                     JOIN academico_curso           cur ON (cur.id = crc.curso_id)