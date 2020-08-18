create or alter view VW_CMMG_PARAMENTRO_IMPORTACAO AS      
select distinct       
       ava.avaliacao_id, isnull(cur.id_curso,120) as curso_id,     
       per.id_periodo as periodo_id,      
       ava.data_aplicacao, ins.id_instituicao as instituicao_id,       
       ava.disciplina_id,
	   ava.qtd_participante,   app.exa_avaliacao_id,    
       ava.avaliacao_nome, ava.curso_nome, ava.grade_nome,  ava.instituicao_nome,       
       ava.disciplina_nome, dis.id_disciplina     
  -- select top 100 *  
  from sae_DADOS_EXPORTACAO ava join tbperiodo per on (per.ds_periodo = ava.grade_nome)      
                                join TbInstituicao ins on (ins.sigla = ava.instituicao_nome)      
                                join TbDisciplina  dis on (dis.ds_disciplina  = ava.disciplina_nome) 
								join VW_SAE_AVALIACAO app on (ava.avaliacao_id = app.exa_id)
                           left join TbCurso cur on (ava.curso_nome = cur.ds_curso)
where ava.avaliacao_id = 156



select * 

select distinct dt_aplicacao from vw_aplicacao_resposta_usuario
 where id_avaliacao = 1555

select top 100 * from vw_aplicacao_resposta_usuario
 where id_avaliacao = 1555
 -----------------------------------------------------------------

select distinct avaliacao_id, curso_id, periodo_id, data_aplicacao, instituicao_id, id_disciplina,
       qtd_participante, exa_avaliacao_id,disciplina_id, disciplina_nome, avaliacao_nome
from VW_CMMG_PARAMENTRO_IMPORTACAO 
where avaliacao_id = 241 and 
      exa_avaliacao_id = 1555

------------------------------------------------------------------------------
declare @AVALIACAO_EXT_ID INT = 241
declare @ID_CURSO         int = 120
declare @ID_PERIODO       int = 105
declare @DATA_APLICACAO   datetime = '2020-07-31'
declare @ID_INSTITUICAO   int = 22 
declare @ID_DISCIPLINA    int = 1699
declare @NR_RESPONDENTES  int = 3268 

exec sp_carga_prova_sae  @AVALIACAO_EXT_ID, @ID_DISCIPLINA, @ID_CURSO, @ID_PERIODO, @DATA_APLICACAO, @ID_INSTITUICAO, @NR_RESPONDENTES    


--select * from tbperiodo where id_periodo in (107,105)


