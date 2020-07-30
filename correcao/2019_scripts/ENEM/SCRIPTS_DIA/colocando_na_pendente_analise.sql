select * from correcoes_pendenteanalise
-- 3488	515
select * from correcoes_analise
where redacao_id = 3488 and id= 515

begin tran
insert into correcoes_pendenteanalise
select null, id_correcao_B, id_projeto, co_barra_redacao, id_tipo_correcao_B, redacao_id, dbo.getlocaldate() from correcoes_analise
where redacao_id = 3488 and id = 515

delete from correcoes_analise
where redacao_id = 3488 and id= 515

--   commit 
--   rollback 

select * from correcoes_fila4

-- SELECT * FROM correcoes_redacao WHERE id = 271716
	 SELECT * FROM correcoes_analise WHERE redacao_id = 271716

	 EXEC SP_RECALCULA_ANALISE 311,4 

	select redacao_id, id, id_projeto, conclusao_analise, fila, * from correcoes_analise 
	where id_tipo_correcao_B = 4 and 
	      ID = 311



2019-11-08 15:55:21.4600000

