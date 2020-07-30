
 select   redacao_id, id_correcao_a, id_correcao_b, count(1) 
  from correcoes_analise 
  group by redacao_id, id_correcao_a, id_correcao_b 
  having count(1) > 1


  select max(id) 
  from correcoes_analise where redacao_id = 469261
  select 

 select distinct ana.*  into tmp_analise_dulpicada_291119 from correcoes_analise ana join (
		   
			select   redacao_id, id_correcao_a, id_correcao_b 
			  from correcoes_analise anax
			 group by redacao_id, id_correcao_a, id_correcao_b 
			 having count(1) > 1
			) as tab on (ana.redacao_id = tab.redacao_id and 
			             ana.id_correcao_a = tab.id_correcao_a and 
						 ana.id_correcao_b = tab.id_correcao_b)








declare @redacao_id int, @correcao_a int, @correcao_b int, @analise_id int
  declare abc cursor for 

			select   redacao_id, id_correcao_a, id_correcao_b 
			  from correcoes_analise 
			 group by redacao_id, id_correcao_a, id_correcao_b 
			 having count(1) > 1
			 order by 1
	open abc 
		fetch next from abc into @redacao_id, @correcao_a, @correcao_b
		while @@FETCH_STATUS = 0
			BEGIN
				
				 select @analise_id =  max(id) from correcoes_analise where redacao_id = @redacao_id
				 
				  delete  from correcoes_analise where id = @analise_id

			fetch next from abc into @redacao_id, @correcao_a, @correcao_b
			END
	close abc 
deallocate abc 