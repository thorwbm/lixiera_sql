CREATE       PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito] as    
    
DECLARE @ID               INT    
DECLARE @ID_CORRECAO      INT    
DECLARE @ID_PROJETO       INT    
DECLARE @ERRO             VARCHAR(500)    
DECLARE @RETORNO          VARCHAR(500)    
DECLARE @CO_BARRA_REDACAO VARCHAR(50)    
  
  SET NOCOUNT ON;   
    
/****** INICIO DO CURSOR ******/    
declare CRS_ANALISE cursor for    
    SELECT id, erro, id_correcao, co_barra_redacao, id_projeto    
      FROM CORRECOES_PENDENTEANALISE PEN with(nolock)    
     WHERE PEN.ERRO IS  NULL and id_tipo_correcao in (1,2)    
      ORDER BY ID    
    
    open CRS_ANALISE    
        fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO, @ID_PROJETO    
        while @@FETCH_STATUS = 0    
            BEGIN    
                   
                EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @retorno output    
                /*****************************************************************/    
                /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */    
                /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */    
                /*****************************************************************/    
                IF(@RETORNO in('OK','JÁ EXISTE'))    
                    BEGIN    
                        DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID    
                    END    
                ELSE    
                    BEGIN    
                        UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID    
                    END    
                        
    
    
            fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO, @ID_PROJETO    
            END    
    close CRS_ANALISE    
deallocate CRS_ANALISE    
   
    SET NOCOUNT OFF;    