-- select * from TbAvaliacaoAplicacao order by id_avaliacao_aplicacao desc
-- 'Avalia��o APIC - 1� per�odo de Enfermagem - E015A01A201T - Trabalho em equipe' 363
-- Avalia��o APIC - 3� per�odo de Enfermagem - E014A02A201T - Metodologia do Trabalho e da Pesquisa Cient�fica 362
-- Avalia��o APIC - 7� per�odo de Enfermagem - E013S07A201T - Assist�ncia de Enfermagem � Sa�de do idoso       360

declare @id_avaliacao_aplicacao int 
select @id_avaliacao_aplicacao = id_avaliacao_aplicacao
-- select *
  from TbAvaliacaoAplicacao 
 where ds_aplicacao LIKE --'Avalia��o de EMBRIOLOGIA HUMANA%'

-- 'Avalia��o de EMBRIOLOGIA HUMANA - M073S01B201T'
-- 'Avalia��o de EMBRIOLOGIA HUMANA - M073S01C201T'
 'Avalia��o de EMBRIOLOGIA HUMANA - M073S01D201T'


-- 'APIC do 7� per�odo de Medicina - 1�/2020 - M067A04D201T'
-- 'APIC do 7� per�odo de Medicina - 1�/2020 - M067A04E201T'
-- 'APIC do 7� per�odo de Medicina - 1�/2020 - M067A04F201T'


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