with cte_professor as (
select  pes.id ,email
  from import_dados_professor imp join pessoas_pessoa pes on (imp.cpf = pes.cpf and 
                                                              imp.professor = pes.nome)
) 
	,	cte_email as (
			select id, email from cte_professor 
			where email <> 'null' 
)

   -- INSERT INTO PESSOAS_email
     SELECT lower(email), 0, ID, 2 FROM cte_email CTE
	 WHERE NOT EXISTS (SELECT 1 
	                     FROM PESSOAS_email ema 
						 WHERE ema.pessoa_id = CTE.ID AND 
						       ema.email = CTE.email)

	--		select * from PESSOAS_email 


		