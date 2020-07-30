

 declare @corretor int
declare @correcao int 
declare @correcaoouro int 
declare @contador int
declare @id int

declare abc cursor for 
	select * from (
select distinct  id_corretor, correcao = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 ), 
					  correcaoouro = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 and id_tipo_correcao = 5 and cast(data_termino as date)=  cast(GETDATE() as date))
 from correcoes_filaouro our) as tab 
	open abc 
		fetch next from abc into @corretor, @correcao,@correcaoouro
		while @@FETCH_STATUS = 0
			BEGIN
			      update correcoes_filaouro set posicao = 10000   where id_corretor = @corretor 
			      set @contador = 4 - @correcaoouro
				  set  @correcao = @correcao + 3
				  while (@contador > 0)
					begin
					    select top 1 @id = Id from correcoes_filaouro with (nolock) where id_corretor = @corretor and posicao = 10000
						update correcoes_filaouro set posicao = @correcao  where id= @id

						set @contador = @contador - 1
						set  @correcao = @correcao + 17
					end


			fetch next from abc into  @corretor, @correcao,@correcaoouro
			END
	close abc 
deallocate abc 

---  *************************************************************************
---  CORRECAO DAS FORA DA FAIXA DO DIA
---  *************************************************************************
select our.*, faixa.limite_dia, faixa.faixa, faixa.total_dia_correcao  
 ,novaposicao = cast( faixa.faixa +  (faixa.limite_dia - faixa.faixa) * rand() as int)
 ---update our set our.posicao =  cast( faixa.faixa +  (faixa.limite_dia - faixa.faixa) * rand() as int)
from vw_distribiucao_faixa_ouro faixa join correcoes_filaouro our on (faixa.id_corretor = our.id_corretor)
where posicao > limite_dia and 
      posicao < 10000

	 select * from correcoes_filaouro  
	 where posicao < 10000  	 
	 and id_corretor = 1937	 
	 order by id_corretor, posicao

	 select * from correcoes_correcao where id_tipo_correcao = 5 and 
	               id_corretor = 1937 and 
				   data_termino >= '2018-11-30'