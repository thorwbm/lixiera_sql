
 create or alter view [dbo].[VW_ACD_CURSO_TURMA_DISCIPLINA_GRADE] as   
select distinct  
       cur.id as curso_id, cur.nome as curso_nome,   
       tur.id as turma_id, tur.nome as turma_nome,   
       tur.inicio_vigencia as turma_inicio, tur.termino_vigencia as turma_termino,   
       year(tur.inicio_vigencia) as turma_ano,  
       dis.id as disciplina_id, dis.nome as disciplina_nome,  
       gra.id as grade_id, gra.nome as grade_nome,   
       etp.id as etapa_id, etp.nome as etapa_nome, etp.etapa as etapa_etapa,  
       eta.id as etapaano_id, eta.ano as etapa_ano,  eta.periodo as etapa_periodo,
       tds.id as turma_disciplina_id  
  from academico_turmadisciplina tds join academico_turma      tur on (tur.id = tds.turma_id)  
                                     join academico_disciplina dis on (dis.id = tds.disciplina_id)  
                                     join academico_curso      cur on (cur.id = tur.curso_id)  
                                     join curriculos_grade     gra on (gra.id = tur.grade_id)  
                                     join academico_etapa      etp on (etp.id = gra.etapa_id)  
                                     join academico_etapaano   eta on (etp.id = eta.etapa_id)