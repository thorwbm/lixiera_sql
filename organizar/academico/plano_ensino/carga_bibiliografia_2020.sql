
DECLARE @DATAEXECUCAO DATETIME    
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)    

begin tran 
insert into planos_ensino_planoensino_bibliografia (criado_em, atualizado_em, criado_por, atualizado_por, bibliografia_id, planoensino_id)
select distinct
    --   criado_em = @DATAEXECUCAO,atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717, 
	   bibliografia_id, planoensino_id = ple.id
  from planos_ensino_planoensino pla join planos_ensino_planoensino_bibliografia bib on (pla.id = bib.planoensino_id)
                                     join planos_ensino_planoensino              ple on (ple.ano = 2020 and 
									                                                     ple.disciplina_id = pla.disciplina_id and
																						 ple.curso_id      = pla.curso_id)
where pla.ano = 2020

 -- GERAR LOG    
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PLANOS_ENSINO_PLANOENSINO_BIBLIOGRAFIA', @DATAEXECUCAO, 11717    
    
	-- COMMIT
	-- ROLLBACK 




DECLARE @DATAEXECUCAO DATETIME    
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)    

begin tran 
	insert into planos_ensino_planoensino_bibliografia (criado_em, atualizado_em, criado_por, atualizado_por, bibliografia_id, planoensino_id)
select distinct
    --  criado_em = @DATAEXECUCAO,atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717, 
	     bbb.bibliografia_id,pln.id 
	from planos_ensino_planoensino pln join planos_ensino_planoensino plv on (plv.ano = pln.ano and 
	                                                                                   plv.curso_id = pln.curso_id and 
																					   plv.disciplina_id = pln.disciplina_id and
																					   plv.criado_em < '2020-08-14')
												join planos_ensino_planoensino_bibliografia bbb on (plv.id = bbb.planoensino_id)
										   left join planos_ensino_planoensino_bibliografia xxx on (xxx.bibliografia_id = bbb.bibliografia_id and 
										                                                            xxx.planoensino_id = pln.id)
	where pln.ano = 2020 and pln.criado_por = 11717 and 
	      pln.criado_em > '2020-08-14' and 
		  xxx.id is null 

 EXEC SP_GERAR_LOG_EM_LOTE_INSERT_usuario 'PLANOS_ENSINO_PLANOENSINO_BIBLIOGRAFIA', @DATAEXECUCAO, 11717    
    

  select * from log_planos_ensino_planoensino_bibliografia order by history_id desc


  commit