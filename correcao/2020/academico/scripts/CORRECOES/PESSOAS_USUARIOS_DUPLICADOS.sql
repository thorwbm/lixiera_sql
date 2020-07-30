with cte_pessoas_dup as (
			select   nome, cpf 
			from     pessoas_pessoa pes 
			group by nome, cpf
			having count(1) > 1
) 
	,	cte_usuario_dup as (		
			select   last_name
			from     pessoas_pessoa pes join auth_user usu on (pes.id = usu.person_id)
			group by last_name
			having count(1) > 1
) 
	,	cte_pessoas_duplicadas as (
			select id, nome, cpf 
			from pessoas_pessoa where nome in (select nome from cte_pessoas_dup)
)
	,	cte_usuarios_duplicados as (
			select id, last_name, username, email, person_id  
			from auth_user where last_name in (select last_name from cte_usuario_dup)
)

			-- select * from cte_pessoas_duplicadas WHERE NOME IN (select LAST_NAME from cte_usuarios_duplicados) order by NOME


			select * from cte_pessoas_duplicadas where cpf is not null  order by NOME
	--		select * from cte_usuarios_duplicados  order by LAST_NAME
			/*
      
		    exec sp_limpa_duplicidade_pessoa 767002,807631
			
			declare @nome varchar(max) = 'MARCELA SENA BRAGA'
			SELECT * FROM PESSOAS_PESSOA WHERE NOME= @nome
			SELECT * FROM auth_user WHERE LAST_NAME= @nome

			
			select * from academico_professor where nome = 'MARCELA SENA BRAGA'

			*/