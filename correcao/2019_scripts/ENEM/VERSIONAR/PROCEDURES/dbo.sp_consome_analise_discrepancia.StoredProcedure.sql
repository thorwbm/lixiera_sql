/****** Object:  StoredProcedure [dbo].[sp_consome_analise_discrepancia]    Script Date: 25/11/2019 09:23:18 ******/
DROP PROCEDURE [dbo].[sp_consome_analise_discrepancia]
GO
/****** Object:  StoredProcedure [dbo].[sp_consome_analise_discrepancia]    Script Date: 25/11/2019 09:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[sp_consome_analise_discrepancia] 
as
declare @CODBARRA varchar(100)
declare @ID_ANALISE int
declare @REDACAO_ID int
declare @fila int

declare cur_con_ana_dis cursor for 
    select redacao_id, co_barra_redacao,id, id_tipo_correcao_B + 1
      from correcoes_analise 
     where conclusao_analise > 2 and 
      fila = 0
    open cur_con_ana_dis 
        fetch next from cur_con_ana_dis into @REDACAO_ID, @CODBARRA, @ID_ANALISE, @FILA
        while @@FETCH_STATUS = 0
            BEGIN
                EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA,@REDACAO_ID, @ID_ANALISE, 3


            fetch next from cur_con_ana_dis into  @REDACAO_ID, @CODBARRA, @ID_ANALISE, @FILA
            END
    close cur_con_ana_dis 
deallocate cur_con_ana_dis
GO
