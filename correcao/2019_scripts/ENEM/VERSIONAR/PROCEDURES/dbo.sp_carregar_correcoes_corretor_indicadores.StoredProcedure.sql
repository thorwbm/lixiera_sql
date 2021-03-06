/****** Object:  StoredProcedure [dbo].[sp_carregar_correcoes_corretor_indicadores]    Script Date: 25/11/2019 09:23:18 ******/
DROP PROCEDURE [dbo].[sp_carregar_correcoes_corretor_indicadores]
GO
/****** Object:  StoredProcedure [dbo].[sp_carregar_correcoes_corretor_indicadores]    Script Date: 25/11/2019 09:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_carregar_correcoes_corretor_indicadores] as
DECLARE @DATA DATE
DECLARE @DATA_ANTERIOR DATE
DECLARE @ID_PROJETO INT

SET @DATA = CAST(dbo.getlocaldate() AS DATE)

declare abc cursor for 
    select id from projeto_projeto
     where cast(dbo.getlocaldate() as date) between cast(data_inicio as date) and cast(data_termino as date)

    open abc 
        fetch next from abc into @ID_PROJETO
        while @@FETCH_STATUS = 0
            BEGIN
                --IF (NOT EXISTS(SELECT * FROM CORRECOES_CORRETOR_INDICADORES WHERE DATA_CALCULO = @DATA))
                --  BEGIN
                --      SET @DATA_ANTERIOR = DATEADD(DAY,-1,@DATA)
                --      EXEC SP_CORRECOES_CORRETOR_INDICADORES @DATA_ANTERIOR, @ID_PROJETO
                --  END
                SET @DATA_ANTERIOR = DATEADD(DAY,-1,@DATA)
                EXEC SP_CORRECOES_CORRETOR_INDICADORES @DATA_ANTERIOR, @ID_PROJETO

            fetch next from abc into @ID_PROJETO
            END
    close abc 
deallocate abc

GO
