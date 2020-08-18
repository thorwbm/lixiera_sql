-- select * from TbAvaliacaoAplicacao order by id_avaliacao_aplicacao desc
-- 'Avaliação APIC - 1º período de Enfermagem - E015A01A201T - Trabalho em equipe' 363
-- Avaliação APIC - 3º período de Enfermagem - E014A02A201T - Metodologia do Trabalho e da Pesquisa Científica 362
-- Avaliação APIC - 7º período de Enfermagem - E013S07A201T - Assistência de Enfermagem à Saúde do idoso       360

declare @id_avaliacao_aplicacao int 
select @id_avaliacao_aplicacao = id_avaliacao_aplicacao
-- select *
  from TbAvaliacaoAplicacao 
 where ds_aplicacao LIKE 'APIC do 1º período de Medicina - 1º/2020%'

-- 'APIC do 1º período de Medicina - 1º/2020 - M073S01A201T'
-- 'APIC do 1º período de Medicina - 1º/2020 - M073S01B201T'
-- 'APIC do 1º período de Medicina - 1º/2020 - M073S01C201T'
-- 'APIC do 1º período de Medicina - 1º/2020 - M073S01D201T'
-- 'APIC do 1º período de Medicina - 1º/2020 - M073S01E201T'
-- 'APIC do 1º período de Medicina - 1º/2020 - M073S01F201T'
-- 'APIC do 1º período de Medicina - 1º/2020 - M073S01G201T'
 'APIC do 1º período de Medicina - 1º/2020 - M073S01H201T'



begin try
	begin tran
		-- ###################################################################
		  delete arr 
            --SELECT * INTO tmp_TbAvaliacaoRealizacaoResposta_1906
			from TbAvaliacaoRealizacaoResposta arr join TbAvaliacaoRealizacao avr on (arr.id_avaliacao_realizacao = avr.id_avaliacao_realizacao)
		   where avr.id_avaliacao_aplicacao = @id_avaliacao_aplicacao
			
-----------------------------------------------------------------------------------
		delete avr
          --SELECT * INTO tmp_TbAvaliacaoRealizacao_1906
		  from TbAvaliacaoRealizacao avr 
		 where avr.id_avaliacao_aplicacao = @id_avaliacao_aplicacao

-----------------------------------------------------------------------------------
		-- delete ava
		--   from TbAvaliacaoAplicacao ava 
		--  where ava.id_avaliacao_aplicacao = @id_avaliacao_aplicacao
	commit
	PRINT 'PROCESSO FINALIZADO COM SUSCESSO'
end try
begin catch
	rollback 
	print 'ERRO DURANTE O PROCESSAMENTO -- ' + ERROR_MESSAGE()
end catch