-- select * from TbAvaliacaoAplicacao where  ds_aplicacao like '1ª série - Matemática - 2º BI/2020'


--select * from tbavaliacaoAplicacao where id_avaliacao = 1556


declare @id_avaliacao_aplicacao int
declare @descricao varchar(max)
declare @error varchar(max)

DECLARE @AVALIACAO VARCHAR(200) = '3ª SÉRIE - MATEMÁTICA - 2º BI/2020'
DECLARE @INICIO DATETIME
DECLARE @FINAL  DATETIME
-----------------------------------------------------------
select @id_avaliacao_aplicacao = id_avaliacao_aplicacao
  from TbAvaliacaoAplicacao 
 where ds_aplicacao = @AVALIACAO and id_avaliacao_aplicacao = 32231

set @descricao = 'EXCLUSAO DA AVALIACAO - [' + @AVALIACAO + ']'
SET @INICIO = GETDATE()
------------------------------------------------------
begin try
	begin tran
		-- ###################################################################
		  delete arr 
			from TbAvaliacaoRealizacaoResposta arr join TbAvaliacaoRealizacao avr on (arr.id_avaliacao_realizacao = avr.id_avaliacao_realizacao)
		   where avr.id_avaliacao_aplicacao = @id_avaliacao_aplicacao
			
-----------------------------------------------------------------------------------
		delete avr
		  from TbAvaliacaoRealizacao avr 
		 where avr.id_avaliacao_aplicacao = @id_avaliacao_aplicacao

-----------------------------------------------------------------------------------			
-----------------------------------------------------------------------------------
		delete ana
		  from TbAnalise_Aplicacao ana 
		 where ana.id_avaliacao_aplicacao = @id_avaliacao_aplicacao

-----------------------------------------------------------------------------------
		 delete ava
		   from TbAvaliacaoAplicacao ava 
		  where ava.id_avaliacao_aplicacao = @id_avaliacao_aplicacao
	commit
	PRINT 'PROCESSO FINALIZADO COM SUSCESSO'
	SET @FINAL = GETDATE()
	exec sp_gerar_log_carga 'EXCLUSAO AVALIACAO', @descricao, NULL, 'OK', @INICIO, @FINAL
end try
begin catch
	rollback 
	set @error = 'ERRO DURANTE O PROCESSAMENTO -- ' + ERROR_MESSAGE()SET @FINAL = GETDATE()
	print @error 
	exec sp_gerar_log_carga 'EXCLUSAO AVALIACAO', @descricao, @error, 'ERRO', @INICIO, @FINAL
end catch



