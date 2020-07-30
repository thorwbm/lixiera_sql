
declare @codigobarra varchar(100)

declare abc cursor for 
	
select co_barra_redacao from /*suas condicoesssssss*/


	open abc 
		fetch next from abc into @codigobarra
		while @@FETCH_STATUS = 0
			BEGIN
--********************************************************************************************************				


delete from correcoes_analise 
                                                                 where co_barra_redacao = @codigobarra and id_tipo_correcao_b = 3 and 
      not exists (select top 1 1 from correcoes_correcao         where co_barra_redacao = @codigobarra and id_tipo_correcao = 4) and 
      not exists (select top 1 1 from correcoes_correcao         where co_barra_redacao = @codigobarra and id_tipo_correcao = 7) and 
      not exists (select top 1 1 from correcoes_fila4            where co_barra_redacao = @codigobarra) and 
      not exists (select top 1 1 from correcoes_filaauditoria    where co_barra_redacao = @codigobarra)  
      
update correcoes_redacao set nota_final = null, id_correcao_situacao = null where co_barra_redacao = @codigobarra and 
      not exists (select top 1 1 from correcoes_correcao                    where co_barra_redacao = @codigobarra and id_tipo_correcao = 4) and 
      not exists (select top 1 1 from correcoes_correcao                    where co_barra_redacao = @codigobarra and id_tipo_correcao = 7) and 
      not exists (select top 1 1 from correcoes_fila4                       where co_barra_redacao = @codigobarra) and 
      not exists (select top 1 1 from correcoes_filaauditoria               where co_barra_redacao = @codigobarra) 

insert correcoes_pendenteanalise
select null, id, co_barra_redacao, id_tipo_correcao, id_projeto 
  from correcoes_correcao                                        where co_barra_redacao = @codigobarra and id_tipo_correcao = 3  and 
      not exists (select top 1 1 from correcoes_correcao         where co_barra_redacao = @codigobarra and id_tipo_correcao = 4) and 
      not exists (select top 1 1 from correcoes_correcao         where co_barra_redacao = @codigobarra and id_tipo_correcao = 7) and 
      not exists (select top 1 1 from correcoes_fila4            where co_barra_redacao = @codigobarra) and 
      not exists (select top 1 1 from correcoes_filaauditoria    where co_barra_redacao = @codigobarra) 

	  
--********************************************************************************************************
			fetch next from abc into @codigobarra
			END
	close abc 
deallocate abc 