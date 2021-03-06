/****** Object:  StoredProcedure [dbo].[sp_inserir_log_erro_N]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/*****************************************************************************************************************
*                        PROCEDURE PARA INSERIR NA TABELA DE LOG DE ERROS DOS ARQUIVOS N                         *
*                                                                                                                *
* PROCEDIMENTO QUE RECEBE O CODIGO DA CORRECAO QUE DEU ERRO, TIPO, O ARQUIVO N QUE DEU ERRO E A DESCRICAO DO     *
* ERRO                                                                                                           *
*                                                                                                                *
* BANCO_SISTEMA: CORRECAO_ENCCEJA                                                                                *
* AUTOR: WEMERSON BITTORI MADURO                                                                 DATA:07/08/2018 *
* MODIFICADO: WEMERSON BITTORI MADURO                                                            DATA:10/08/2018 *
******************************************************************************************************************/
-- SELECT * FROM inep_log_erro_N

CREATE procedure [dbo].[sp_inserir_log_erro_N] 
	@idCorrecao int,        /****  IDENTIFICADOR DA CORRECAO                         ***/
	@tipo_log varchar(100), /****  TIPO DO LOG { INSERT, UPDATE, DELETE,...          ***/
	@arquivo varchar(100),  /****  NOME DO ARQUIVO QUE GEROU O LOG { N02, N59, ...}  ***/
	@descricao varchar(1000),/****  DETALHAMENTO DO LOG                               ***/
	@tipo_erro varchar(1000) /****  TIPO DO ERRO QUE GEROU O LOG                      ***/
as 

insert into inep_log_erro_N (criado_em, id_correcao, tipo_log,   arquivo, des_log,     tipo_erro) 
     values                 (getdate(), @idCorrecao, @tipo_log, @arquivo, @descricao, @tipo_erro)
GO
