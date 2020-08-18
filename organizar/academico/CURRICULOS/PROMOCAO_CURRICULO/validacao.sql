select disciplina_nome, turma_tipo, grade_id, * 
  from vw_aluno_curriculo_curso_turma_etapa_discplina
  where CURRICULOALUNO_ID  = 36180 and 
        STATUS_TURMADISCIPLINAALUNO = 'Pré-enturmado'
		order by 1,2 desc



		select disciplina_nome,* from vw_curriculos_grade_disciplina where grade_id = 6711  order by 1










	create   view VW_ACD_CURSO_TURMA_DISCIPLINA as       
select cur.id as curso_id, cur.nome as curso_nome,       
       tur.id as turma_id, tur.nome as turma_nome,       
       dis.id as disciplina_id, dis.nome as disciplina_nome,       
       tur.inicio_vigencia, tur.termino_vigencia, tur.grade_id, tur.turma_pai_id,      
       tdc.id as turma_disciplina_id, tdc.maximo_vagas,    
       year(tur.inicio_vigencia) as ano_vigencia,    
    ctt.id as turma_categoria_id, ctt.nome as turma_categoria_nome,   
    case when month(tur.inicio_vigencia)  < 7 then 1 else 2 end as semestre        
  from academico_turmadisciplina tdc with(nolock) join academico_turma          tur with(nolock) on (tur.id = tdc.turma_id)      
                                                  join academico_disciplina     dis with(nolock) on (dis.id = tdc.disciplina_id)      
                                                  join academico_curso          cur with(nolock) on (cur.id = tur.curso_id)      
                                                  join academico_categoriaturma ctt with(nolock) on (ctt.id = tur.categoria_id)