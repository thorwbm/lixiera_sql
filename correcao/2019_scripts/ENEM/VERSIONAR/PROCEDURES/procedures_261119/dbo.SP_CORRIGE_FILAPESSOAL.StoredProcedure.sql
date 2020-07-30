/****** Object:  StoredProcedure [dbo].[SP_CORRIGE_FILAPESSOAL]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[SP_CORRIGE_FILAPESSOAL]
GO
/****** Object:  StoredProcedure [dbo].[SP_CORRIGE_FILAPESSOAL]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************
OS COORDENADORES POLO E SUPERVISORES APESENTAVAM REGISTROS NA FILAPESSOAL QUE NAO POSSUIAM REFERENCIA NA CORRECOES_CORRECAO

SOLUCAO: APGAR OS REGISTROS DA FILAPESSOAL (FOI FEITO BACKUP -> CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115)
SELECT IDENTIFICA OS CASOS
*******************/
-- SELECT * FROM CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115
CREATE   procedure [dbo].[SP_CORRIGE_FILAPESSOAL] AS
BEGIN TRY
    BEGIN TRAN FILA
        insert into CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115
        SELECT * FROM correcoes_filapessoal PES 
        WHERE NOT EXISTS (SELECT TOP 1 1 FROM CORRECOES_CORRECAO COR WHERE COR.co_barra_redacao = PES.co_barra_redacao AND 
                                                                           COR.id_corretor      = PES.id_corretor)
                                                                           ORDER BY id_corretor
        
        delete FROM CORRECOES_FILAPESSOAL WHERE ID IN (
        SELECT PES.ID 
        FROM CORRECOES_FILAPESSOAL PES JOIN CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115 BKP ON (PES.id = BKP.ID))

    COMMIT TRAN FILA
END TRY
BEGIN CATCH
    ROLLBACK TRAN FILA 
END CATCH

GO
