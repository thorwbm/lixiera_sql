CREATE OR ALTER VIEW VW_EXTRATO_NOTA_ALUNO AS 
with cte_nota_exame as (
			select PROVA_NOME, ESCOLA_NOME, EXAME_NOME, GRADE_NOME, ALUNO_NOME, sum(nota) as nota_exame
			  from VW_AGENDAMENTO_PROVA_ALUNO_PERGUNTA_RESPOSTA 
			 group by PROVA_NOME, ESCOLA_NOME, EXAME_NOME, GRADE_NOME, ALUNO_NOME
)
	,	cte_nota_prova as (
			select PROVA_NOME, ESCOLA_NOME, GRADE_NOME, ALUNO_NOME, sum(nota) as nota_prova, 
			MIN(ANS.CREATED_AT) AS PROVA_INICIO, MAX(ANS.updated_at) AS PROVA_TERMINO 
			  from VW_AGENDAMENTO_PROVA_ALUNO_PERGUNTA_RESPOSTA APR JOIN APPLICATION_ANSWER ANS ON (ANS.ID = APR.answer_id)
			 group by PROVA_NOME, ESCOLA_NOME,  GRADE_NOME, ALUNO_NOME
)

	select distinct 
	       apr.PROVA_NOME, apr.ESCOLA_NOME, apr.EXAME_NOME, apr.GRADE_NOME, apr.ALUNO_NOME, 
		   AGENDAMENTO_INICIO  = CASE WHEN EXA_TWD_INICIO  IS NULL THEN APP_TWD_INICIO  ELSE EXA_TWD_INICIO  END,
		   AGENDAMENTO_TERMINO = CASE WHEN EXA_TWD_TERMINO IS NULL THEN APP_TWD_TERMINO ELSE EXA_TWD_TERMINO END,
		   PRO.PROVA_INICIO, PRO.PROVA_TERMINO,
		   exa.nota_exame, pro.nota_prova
	  from VW_AGENDAMENTO_PROVA_ALUNO_PERGUNTA_RESPOSTA apr left join cte_nota_exame exa on (exa.ALUNO_NOME  = apr.ALUNO_NOME and 
	                                                                                         exa.EXAME_NOME  = apr.EXAME_NOME and 
																							 exa.ESCOLA_NOME = apr.ESCOLA_NOME and 
																							 exa.PROVA_NOME  = apr.PROVA_NOME)
															left join cte_nota_prova pro on (apr.ALUNO_NOME  = pro.ALUNO_NOME and 
																							 apr.ESCOLA_NOME = pro.ESCOLA_NOME and 
																							 apr.PROVA_NOME  = pro.PROVA_NOME)


 where  -- apr.aluno_nome = 'Matheus Da Conceição Bastos' and 

 SELECT * FROM VW_EXTRATO_NOTA_ALUNO APR WHERE 
	 	 apr.prova_nome like   'Desafio SAE % 2°BI%' and 
	 	 apr.prova_nome not like  '%prospect%' 


--		 SELECT * FROM application_answer WHERE ID IN (20309049, 20312281, 20315513, 20318745, 20321977, 20325209, 20328441, 20331673)


select * from exam_collection where name like 'Desafio SAE % 2°BI%'