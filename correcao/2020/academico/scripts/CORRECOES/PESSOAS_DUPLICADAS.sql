declare @pessoa_id_origem int, @pessoa_id_destino int, 
        @usuario_id_origem int, @usuario_id_destino int, 
		@existe_duplicidade_pessoa int,  @existe_duplicidade_usuario int

		

	set @pessoa_id_origem           = 831880 -- id da pessoa que sera excluido
	set @pessoa_id_destino          = 791333 -- id da pessoa que sera mantido
	set @existe_duplicidade_pessoa  = 0      -- flag que define se existe ou nao duplicidade [0-nao],[1-sim]
	set @existe_duplicidade_usuario = 0      -- flag que define se existe ou nao duplicidade [0-nao],[1-sim]
	set @usuario_id_origem          = 0      -- usurio origem que devera ser excluido
	set @usuario_id_destino         = 0      -- usuario destino que devera ser matido

select @existe_duplicidade_pessoa = 1 
  from  pessoas_pessoa pes1 join pessoas_pessoa pes2 on (pes1.cpf = pes2.cpf)
 where pes1.id = @pessoa_id_origem and 
       pes2.id = @pessoa_id_destino
    
	-- **** se existir duplicidade de pessoa sera verificado se existe duplicidade para os usuario desta pessoa
	if (@existe_duplicidade_pessoa = 1)
		begin 
			select @usuario_id_origem  = usu.id from pessoas_pessoa pes join auth_user usu on (pes.id = usu.person_id and pes.id = @pessoa_id_origem)
			select @usuario_id_destino = usu.id from pessoas_pessoa pes join auth_user usu on (pes.id = usu.person_id and pes.id = @pessoa_id_destino)

			select @existe_duplicidade_usuario = 1 
			  from  auth_user usu1 join auth_user usu2 on (usu1.last_name = usu2.last_name)
			 where usu1.id = @usuario_id_origem and 
				   usu2.id = @usuario_id_destino

			if(@existe_duplicidade_usuario = 1) 
				BEGIN
					EXEC SP_ALTERAR_VALOR_EM_TODO_BANCO_FK 'AUTH_USER', 'ID', @usuario_id_origem, @usuario_id_destino
					EXEC SP_GERAR_LOG 'PESSOAS_PESSOA',  @usuario_id_origem, '-', 2137, NULL, NULL, NULL
					DELETE FROM AUTH_USER WHERE ID = @usuario_id_origem
				END 
				EXEC SP_ALTERAR_VALOR_EM_TODO_BANCO_FK 'PESSOAS_PESSOA', 'ID', @pessoa_id_origem, @pessoa_id_destino				
				EXEC SP_GERAR_LOG 'PESSOAS_PESSOA', @pessoa_id_origem, '-', 2137, NULL, NULL, NULL
				DELETE FROM PESSOAS_PESSOA WHERE ID = @pessoa_id_origem


SELECT * FROM LOG_PESSOAS_PESSOA WHERE ID IN (829757, 780370) 

             PRINT 'ATUALIZAR PESSOA'
			 PRINT 'APAGAR USUARIO ORIGEM'
			 PRINT 'APAGAR PESSOA ORIGEM'


		end 


		SELECT * FROM LOG_AUTH_USER 




-- #########################################################################################3

declare @usuario_id_origem int, @usuario_id_destino int
	set @usuario_id_origem          = 9356      -- usurio origem que devera ser excluido
	set @usuario_id_destino         = 8      -- usuario destino que devera ser matido



CREATE PROCEDURE SP_ALTERAR_VALOR_EM_TODO_BANCO_FK   
   @TABELA_PAI VARCHAR(200), @CAMPO_PAI VARCHAR(200), @ATUAL INT, @NOVO INT AS 

 DECLARE @TABELA VARCHAR(MAX),@COLUNA VARCHAR(MAX), @SQL VARCHAR(MAX) 
declare CUR_ALTERAR cursor for 
	SELECT DISTINCT TABELA_FK, COLUNA_FK FROM VW_CONSTRAINT_DETALHE
		WHERE TABELA_PK = 'AUTH_USER' AND COLUNA_PK = 'ID'
		  order by TABELA_FK, COLUNA_FK
	open CUR_ALTERAR 
		fetch next from CUR_ALTERAR into @TABELA, @COLUNA
		while @@FETCH_STATUS = 0
			BEGIN
			    IF(@ATUAL <> @NOVO)
					BEGIN
						SET @SQL = 'UPDATE ' + @TABELA + ' SET ' + @COLUNA + ' = ' + CONVERT(VARCHAR(20), @NOVO)
						         + ' WHERE ' + @COLUNA + ' = ' + CONVERT(VARCHAR(20), @ATUAL) 
						PRINT @SQL
					END
			fetch next from CUR_ALTERAR into @TABELA, @COLUNA
			END
	close CUR_ALTERAR 
deallocate CUR_ALTERAR 

SELECT USER_ID, PESSOA_ID, NOME FROM ACADEMICO_ALUNO WHERE USER_ID = 9356


SELECT * FROM ACADEMICO_PROFESSOR 
--SELECT * FROM ACADEMICO_ALUNO WHERE USER_ID = 8

select LAST_NAME, ID, PERSON_ID  from auth_user WHERE ID = 9356
SELECT * FROM PESSOAS_PESSOA WHERE ID IN (766852)


SELECT DISTINCT TABELA_FK, COLUNA_FK FROM VW_CONSTRAINT_DETALHE
WHERE TABELA_PK = 'AUTH_USER' AND COLUNA_PK = 'ID'