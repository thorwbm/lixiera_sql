create OR alter view VW_CMMG_PARAMENTRO_IMPORTACAO AS  
select distinct   
       ava.avaliacao_id, isnull(cur.id_curso,120) as curso_id, 
	   per.id_periodo as periodo_id,  
       ava.data_aplicacao, ins.id_instituicao as instituicao_id,   
       dis.id_disciplina, ava.qtd_participante,   
       ava.avaliacao_nome, ava.curso_nome, ava.grade_nome,  ava.instituicao_nome,   
       ava.disciplina_nome  

  from CMMG_DADOS_EXPORTACAO ava join tbperiodo per on (per.ds_periodo = ava.grade_nome)  
                                join TbInstituicao ins on (ins.ds_instituicao = ava.instituicao_nome)  
                                join TbDisciplina  dis on (dis.ds_disciplina  = ava.disciplina_nome)  
                           left join TbCurso cur on (ava.curso_nome = cur.ds_curso)



