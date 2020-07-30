--#################################################################################
-- MUDAR STATUS DAS REDACOES ATUAIS 


  SELECT * from correcoes_redacao
--  begin tran  update correcoes_redacao set justificativa_cancelamento = 'substituição por folha reserva', CANCELADO = 1
where MOTIVO_ID = 1 AND 
      co_inscricao in ('191059762721')


-- COMMIT 
-- ROLLBACK
--##################################################################################
-- CRIAR MOTIVIOS
select  * 
from correcoes_redacao
where cancelado = 1 AND 
     MOTIVO_ID = 1 AND       
  co_inscricao in (

'191059762721'
)
-- UPDATE correcoes_motivoredacao SET redacao_substituida_id = NULL WHERE ID = 1

SELECT * FROM correcoes_motivoredacao
SELECT * FROM correcoes_tipomotivoredacao

INSERT INTO correcoes_motivoredacao (descricao, tipo_id, redacao_substituida_id)
SELECT 'Inserção folha reserva', 2, 442463



-- ############################################################################
---  select * from subscriptions_subscription where enrolment_key in ('191052161053','191058723914','191056213553','191059762721')
/********
select co_barra_redacao = LEFT([filename], 16), 
	   co_inscricao     = enrolment_key,
	   link_imagem_recortada = processed_key, 
	   link_imagem_original  = original_key,
	   co_formulario         = left(LEFT([filename], 16),2), 
	   id_prova = substring(LEFT([filename], 16), 3, 1),
	   id_projeto = case when substring(LEFT([filename], 16), 3, 1) = '2' then 1 
	                     when substring(LEFT([filename], 16), 3, 1) = '3' then 4 end , 
	   id_redacao_situacao = 1, 
	   MOTIVO_ID = 'SELECT DISTINCT CONVERT(VARCHAR(10),ID) FROM correcoes_motivoredacao WHERE redacao_substituida_id IN (SELECT ID FROM CORRECOES_REDACAO WHERE MOTIVO_ID = 1 AND CANCELADO = 1 AND CO_INSCRICAO = ' + CHAR(39) + enrolment_key + CHAR(39) + ' )'

	   into #temp 
from  subscriptions_classifyerror ce join batch_essay e on e.id = ce.essay_id
-- select * from #temp 
--DROP TABLE #TEMP

select ' insert into correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,CANCELADO, ID_STATUS, MOTIVO_ID) values (' +
          CHAR(39) + link_imagem_recortada + CHAR(39) + ', ' +
		  CHAR(39) + link_imagem_original + CHAR(39)  + ', ' +
		  'null'  + ', ' +
		  '1'     + ', ' +		  
		  CHAR(39) + co_barra_redacao + CHAR(39)  + ', ' +
		  CHAR(39) + co_inscricao + CHAR(39)      + ', ' +
		  CHAR(39) + co_formulario + CHAR(39)     + ', ' +
		  CONVERT(varchar(10), id_prova)          + ', ' +
		  CONVERT(varchar(10), id_projeto)        + ', ' +
		  '0'     + ', ' +	
		  '1'     + ', ' +	
		  '(' + MOTIVO_ID  + ')) ' 
		  from #temp
		  WHERE co_inscricao <> '191059762721'
	******/	  
		  
		  BEGIN TRAN
 -- insert into correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,CANCELADO, ID_STATUS, MOTIVO_ID) values ('result/1911002_F_20191102_1544/essay/452/4521019341235800191102005.jpg', 'batch/1911002_F_20191102_1544/202/4521019341235800191102005.JPG', null, 1, '4521019341235800', '182000193844', '45', 2, 1, 0, 1, (SELECT DISTINCT CONVERT(VARCHAR(10),ID) FROM correcoes_motivoredacao WHERE redacao_substituida_id IN (SELECT ID FROM CORRECOES_REDACAO WHERE MOTIVO_ID = 1 AND CANCELADO = 1 AND CO_INSCRICAO = '182000193844' ))) 
 -- insert into correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,CANCELADO, ID_STATUS, MOTIVO_ID) values ('result/1911002_F_20191102_1544/essay/452/4521018241227417191102005.jpg', 'batch/1911002_F_20191102_1544/213/4521018241227417191102005.JPG', null, 1, '4521018241227417', '182000222823', '45', 2, 1, 0, 1, (SELECT DISTINCT CONVERT(VARCHAR(10),ID) FROM correcoes_motivoredacao WHERE redacao_substituida_id IN (SELECT ID FROM CORRECOES_REDACAO WHERE MOTIVO_ID = 1 AND CANCELADO = 1 AND CO_INSCRICAO = '182000222823' ))) 
 -- insert into correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,CANCELADO, ID_STATUS, MOTIVO_ID) values ('result/1911002_F_20191102_1544/essay/452/4521018241227336191102005.jpg', 'batch/1911002_F_20191102_1544/213/4521018241227336191102005.JPG', null, 1, '4521018241227336', '182000206222', '45', 2, 1, 0, 1, (SELECT DISTINCT CONVERT(VARCHAR(10),ID) FROM correcoes_motivoredacao WHERE redacao_substituida_id IN (SELECT ID FROM CORRECOES_REDACAO WHERE MOTIVO_ID = 1 AND CANCELADO = 1 AND CO_INSCRICAO = '182000206222' ))) 
 -- insert into correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,CANCELADO, ID_STATUS, MOTIVO_ID) values ('result/1911002_F_20191102_1544/essay/453/4531018241327807191102005.jpg', 'batch/1911002_F_20191102_1544/198/4531018241327807191102005.JPG', null, 1, '4531018241327807', '182000207202', '45', 3, 4, 0, 1, (SELECT DISTINCT CONVERT(VARCHAR(10),ID) FROM correcoes_motivoredacao WHERE redacao_substituida_id IN (SELECT ID FROM CORRECOES_REDACAO WHERE MOTIVO_ID = 1 AND CANCELADO = 1 AND CO_INSCRICAO = '182000207202' ))) 
-- SELECT TOP 10  * FROM correcoes_fila1 
 --  INSERT INTO correcoes_fila1 (corrigido_por, criado_em, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, redacao_id)
 SELECT NULL, dbo.getlocaldate(), NULL, 1, id_projeto, co_barra_redacao, ID FROM correcoes_redacao RED 
 WHERE cancelado = 0 AND 
      co_inscricao IN (

'191059762721'
) AND 
not EXISTS (SELECT 1 FROM correcoes_fila1 WHERE redacao_id = RED.ID)

-- COMMIT 
-- ROLLBACK

-- SELECT TOP 10 * FROM correcoes_redacao WHERE CO_INSCRICAO = '191056213553' 