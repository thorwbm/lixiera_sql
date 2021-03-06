/****** Object:  StoredProcedure [dbo].[sp_consome_analise_discrepancia]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[sp_consome_analise_discrepancia] 
as
declare @CODBARRA varchar(100)
declare @ID_ANALISE int
declare @fila int

declare cur_con_ana_dis cursor for 
	select co_barra_redacao,id, id_tipo_correcao_B + 1
	  from correcoes_analise  with (nolock)
     where conclusao_analise > 2 and 
      fila = 0
	open cur_con_ana_dis 
		fetch next from cur_con_ana_dis into @CODBARRA, @ID_ANALISE, @FILA
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @ID_ANALISE, 3


			fetch next from cur_con_ana_dis into  @CODBARRA, @ID_ANALISE, @FILA
			END
	close cur_con_ana_dis 
deallocate cur_con_ana_dis
GO
