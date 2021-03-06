
ALTER procedure [dbo].[SP_LIMPA_DUPLICIDADE_PESSOA] @pessoa_id_origem int, @pessoa_id_destino int as
 declare @usuario_id_origem int, @usuario_id_destino int, 
		 @existe_duplicidade_pessoa int,  @existe_duplicidade_usuario int


	set @existe_duplicidade_pessoa  = 0      -- flag que define se existe ou nao duplicidade [0-nao],[1-sim]
	set @existe_duplicidade_usuario = 0      -- flag que define se existe ou nao duplicidade [0-nao],[1-sim]
	set @usuario_id_origem          = 0      -- usurio origem que devera ser excluido
	set @usuario_id_destino         = 0      -- usuario destino que devera ser matido

select @existe_duplicidade_pessoa = 1 
  from  pessoas_pessoa pes1 join pessoas_pessoa pes2 on (pes1.nome = pes2.nome)-- (pes1.cpf = pes2.cpf)
 where pes1.id = @pessoa_id_origem and 
       pes2.id = @pessoa_id_destino
BEGIN TRY
BEGIN TRAN
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
					DELETE FROM AUTH_USER WHERE ID = @usuario_id_origem
				END 

				EXEC SP_ALTERAR_VALOR_EM_TODO_BANCO_FK 'PESSOAS_PESSOA', 'ID', @pessoa_id_origem, @pessoa_id_destino				
				EXEC SP_GERAR_LOG 'PESSOAS_PESSOA', @pessoa_id_origem, '-', 2137, NULL, NULL, NULL
				DELETE FROM PESSOAS_PESSOA WHERE ID = @pessoa_id_origem
	END
  COMMIT	
END TRY 
BEGIN CATCH
	ROLLBACK 
	PRINT ERROR_MESSAGE()
END CATCH

