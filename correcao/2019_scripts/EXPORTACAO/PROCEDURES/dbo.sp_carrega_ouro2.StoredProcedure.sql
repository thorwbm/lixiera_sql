/****** Object:  StoredProcedure [dbo].[sp_carrega_ouro2]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_carrega_ouro2] 
    @ID_CORRETOR INT,
	@ID_PROJETO  INT 
as 

begin try
--begin tran


	 -- **** inserir na tabela redacao as redacoes ouro para o candidato 
	 select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
	        co_barra_redacao = '001' + right('000000' +convert(varchar(6),our.id),6) +
							           right('000000' +convert(varchar(6),@ID_CORRETOR),6),
	        co_inscricao    = '001' + right('000000' +convert(varchar(6),our.id),6) +
							           right('000000' +convert(varchar(6),@ID_CORRETOR),6),
	        co_formulario,id_prova, id_projeto,id 
	   into #tmp_correcoes_redacao
	   from correcoes_redacaoouro OUR 
	  order by co_barra_redacao

	insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao,
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
	select link_imagem_recortada, link_imagem_original, nota_final, 1, 
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
	  from #tmp_correcoes_redacao tmp
	 where not exists (select 1 from correcoes_redacao redx 
	                    where redx.co_barra_redacao = tmp.co_barra_redacao AND
						      REDX.id_projeto = TMP.id_projeto)

	-- **** inserir na tabela filaOURO
	insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto)
	SELECT co_barra_redacao,
		   @ID_CORRETOR, null, id_projeto
	  FROM #tmp_correcoes_redacao

 
	--- INSERE NA CORRECOES GABARITO
	insert correcoes_gabarito (nota_final, id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
		   nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
		   co_barra_redacao)
	select our.nota_final, our.id_correcao_situacao, our.id_competencia1, our.id_competencia2, our.id_competencia3, our.id_competencia4, our.id_competencia5,
		   our.nota_competencia1, our.nota_competencia2, our.nota_competencia3, our.nota_competencia4, our.nota_competencia5,
		   red.co_barra_redacao
	 frOM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
	 where not exists (select 1 from correcoes_gabarito gabx
	                    where gabx.co_barra_redacao = red.co_barra_redacao) and
		   our.id_projeto = @ID_PROJETO
		   

	 exec sp_distribuir_ordem @ID_CORRETOR, @ID_PROJETO, 2

	 --commit
end try
begin catch
	print error_message()
	rollback
end catch
GO
