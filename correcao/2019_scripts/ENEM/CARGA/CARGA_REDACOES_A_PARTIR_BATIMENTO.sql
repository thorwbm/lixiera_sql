select id, original_key, processed_key, enrolment_key, LEFT([filename], 16) from batch_essay where processed_key in (
    'result/1911002_F_20191102_1544/essay/452/4521019341235800191102005.jpg',
    'result/1911002_F_20191102_1544/essay/452/4521018241227417191102005.jpg',
    'result/1911002_F_20191102_1544/essay/452/4521018241227336191102005.jpg',
    'result/1911002_F_20191102_1544/essay/453/4531018241327807191102005.jpg'
)
---  select * from subscriptions_subscription where enrolment_key in ('191052161053','191058723914','191056213553','191059762721')
-- drop table #temp
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
	   from batch_essay
--from  subscriptions_classifyerror ce join batch_essay e on e.id = ce.essay_id
where processed_key in (
    'result/1911002_F_20191102_1544/essay/452/4521019341235800191102005.jpg',
    'result/1911002_F_20191102_1544/essay/452/4521018241227417191102005.jpg',
    'result/1911002_F_20191102_1544/essay/452/4521018241227336191102005.jpg',
    'result/1911002_F_20191102_1544/essay/453/4531018241327807191102005.jpg')
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