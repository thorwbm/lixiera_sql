/**********************************************************************************************************************************
*                                                       SP_DELETAR_USUARIO                                                        *
*                                                                                                                                 *
*  PROCEDURE QUE RECEBE O ID DE UM USUARIO E O DELETA CASO ELE NAO TENHA REFERENCIA EM NENHUMA TABELA DO SISTEMA A NAO SER AS DE  *
*  CONTROLE DE USUARIO                                                                                                            *
*                                                                                                                                 *
* BANCO_SISTEMA : EDUCAT                                                                                                          *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:18/03/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:18/03/2020 *
**********************************************************************************************************************************/

create or alter procedure sp_deletar_usuario @usuario_id int as 

begin try
	begin tran
		delete from auth_user_user_permissions where user_id = @usuario_id
		delete from auth_user_groups where user_id = @usuario_id
		delete from auth_user where id = @usuario_id

	commit
	print 'USUARIO DELATADO COM SUCESSO - [' + CONVERT(VARCHAR(20), @USUARIO_ID) + ']'
END TRY
BEGIN CATCH
	ROLLBACK 
	PRINT 'FALHA AO TENTAR DELETAR O USUARIO - [' + CONVERT(VARCHAR(20), @USUARIO_ID) + ']'
	PRINT ERROR_MESSAGE()
END CATCH