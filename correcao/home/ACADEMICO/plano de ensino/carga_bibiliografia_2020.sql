
DECLARE @DATAEXECUCAO DATETIME    
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)    

begin tran 
insert into planos_ensino_planoensino_bibliografia (criado_em, atualizado_em, criado_por, atualizado_por, bibliografia_id, planoensino_id)
select distinct
       criado_em = @DATAEXECUCAO,atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717, 
	   bibliografia_id, planoensino_id = ple.id
  from planos_ensino_planoensino pla join planos_ensino_planoensino_bibliografia bib on (pla.id = bib.planoensino_id)
                                     join planos_ensino_planoensino              ple on (ple.ano = 2020 and 
									                                                     ple.disciplina_id = pla.disciplina_id and
																						 ple.curso_id      = pla.curso_id)
where pla.ano = 2019

 -- GERAR LOG    
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PLANOS_ENSINO_PLANOENSINO_BIBLIOGRAFIA', @DATAEXECUCAO, 11717    
    
	-- COMMIT
	-- ROLLBACK 


