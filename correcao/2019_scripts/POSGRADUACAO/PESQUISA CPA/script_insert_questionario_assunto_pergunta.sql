select *,
   aux = case questionario when 'QUESTIONÁRIO DO COORDENADORES DE CURSO' then 'Questionario IPG - Coordenador de Curso'
                           when 'QUESTIONÁRIO DO PROFESSOR'              then 'Questionario IPG - Professor'
						   when 'QUESTIONÁRIO DO TUTOR'                  then 'Questionario IPG - Tutor' end
 from  tmp_questionario_0711


-- ################ AJUSTE NO NOME E CODIGOS ####################################

update tmp_questionario_0711 set aux = case questionario when 'QUESTIONÁRIO DO COORDENADORES DE CURSO' then 'Questionario IPG - Coordenador de Curso'
                           when 'QUESTIONÁRIO DO PROFESSOR'              then 'Questionario IPG - Professor'
						   when 'QUESTIONÁRIO DO TUTOR'                  then 'Questionario IPG - Tutor' end

-- ################ INSERT QUESTIONARIOS ####################################
-- insert into questionario
select DISTINCT AUX, GETDATE(), GETDATE(),null FROM tmp_questionario_0711

-- ################ INSERT ASSUNTOS ####################################
/*select 'insert into assunto (nome, posicao, createdat, updatedat, questionarioid) '+
        ' select '+CHAR(39) + ASSUNTO + CHAR(39) +', ' + 
                  convert(varchar(10),row_number() over(ORDER BY ordem ASC) ) +', ' +
				  'getdate() , ' + 
				  'getdate() , 3'  ,ordem 
   from ( SELECT distinct ASSUNTO , MAX( id) ordem
         FROM tmp_questionario_0711 
            group by ASSUNTO) as tab
			ORDER BY 1*/

		select *,  assuto_aux = rtrim(ltrim(right(assunto, LEN( replace (replace (replace (assunto,'   ',' '),'  ',' '),' ','')) -2) )) 
		into #temp2
		from (SELECT distinct ASSUNTO , questionario, aux
			    FROM tmp_questionario_0711) as tab

	 -- insert into assunto (nome, posicao, createdat, updatedat, questionarioid) 		
	  select assuto_aux = rtrim(ltrim(right(replace (replace (assunto,'   ',' '),'  ',' '), LEN( replace (replace (assunto,'   ',' '),'  ',' ')) -2) )),
	   row_number() over(PARTITION BY que.id  ORDER BY que.id , assunto ASC),
	    GETDATE(), GETDATE(), que.id
	    from #temp2 tem join Questionario que on (tem.aux = que.nome)
		order by que.id , assunto 

	   -- update Assunto set nome = REPLACE(nome, '   ','') where questionarioId >=4 and nome like '   %'
       -- update Assunto set nome = REPLACE(nome, '    ','') where questionarioId >=4 and nome like '    %'
       -- update Assunto set nome = REPLACE(nome, '  ','') where questionarioId >=4 and nome like '  %'  

--#################################################################################################

--insert into Pergunta (nome, posicao, createdAt, updatedAt, tipoPerguntaId, assuntoId) 
select  tmp.pergunta, ROW_NUMBER() OVER(PARTITION BY ass.id ORDER BY tmp.id asc) , GETDATE(),GETDATE(), 1, ass.id
from Assunto ass join tmp_questionario_curso tmp on (ass.nome = tmp.grupo)
where questionarioId = 3
order by tmp.id 

--  insert into Pergunta (nome, posicao, createdAt, updatedAt, tipoPerguntaId, assuntoId) 
select tem.pergunta, ROW_NUMBER() OVER(PARTITION BY ass.id ORDER BY tem.id asc) , GETDATE(),GETDATE(), 1, ass.id
  from tmp_questionario_0711 tem join Questionario que on (tem.aux = que.nome)
         join Assunto ass on (ass.questionarioId = que.id and 
		                      rtrim(tem.assunto) like ('%'+ ass.nome ))

--#################################################################################################

-- insert into Alternativa ( nome, valor, posicao, createdAt, updatedAt, perguntaId)
select alt.nome, alt.valor, alt.posicao, GETDATE(), GETDATE(), tab.id 
  from Alternativa alt join (select * from Pergunta per where per.id > 72) as tab  on (1=1)
where  perguntaId = 1 
order by tab.id, alt.nome

--#################################################################################################

-- **** CONSIDERACAOES FINAIS  *****

SELECT * FROM ASSUNTO WHERE QUESTIONARIOiD = 4
-- INSERT INTO ASSUNTO 
SELECT 'CONSIDERAÇÕES FINAIS', 5, GETDATE(), GETDATE(), 4 UNION 
SELECT 'CONSIDERAÇÕES FINAIS', 5, GETDATE(), GETDATE(), 5 UNION 
SELECT 'CONSIDERAÇÕES FINAIS', 5, GETDATE(), GETDATE(), 6 


SELECT * FROM ASSUNTO WHERE QUESTIONARIOiD >= 4 AND nome like 'CONSIDERAÇÕES FINAIS%' 
-- INSERT INTO PERGUNTA
SELECT 'CRÍTICAS E SUGESTÕES',1, GETDATE(), GETDATE(),2,45 UNION 
SELECT 'CRÍTICAS E SUGESTÕES',1, GETDATE(), GETDATE(),2,46 UNION 
SELECT 'CRÍTICAS E SUGESTÕES',1, GETDATE(), GETDATE(),2,47 