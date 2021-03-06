/****** Object:  StoredProcedure [dbo].[sp_distribuir_ordem]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_distribuir_ordem] 
    @id_avaliador int, 
    @id_projeto   int,
    @id_redacaotipo int
as

DECLARE @QUANTIDADE           INT
DECLARE @CONT                 INT
declare @aux                  int
declare @resultado            int 
declare @id                   int
declare @nova_faixa           int
declare @nova_quantidade      int
declare @faixa_ouro           int
declare @qtd_ouro             int
declare @aux_ouro             int
declare @qtd_correcao         int
DECLARE @QUANTIDADE_CORRIGIDA INT 
DECLARE @POSICAO_INICIAL      INT 

/*
select @qtd_correcao = count(cor.id)
  from correcoes_correcao cor join correcoes_redacao red on (cor.co_barra_redacao = red.co_barra_redacao and
                                                             cor.id_projeto       = red.id_projeto)
where cor.id_corretor = 469 and
      cor.id_projeto  = 4 and 
      cor.id_correcao_situacao = 3 and
      red.id_redacaoouro is null 
*/
select @faixa_ouro = ouro_frequencia, @qtd_ouro= ouro_quantidade 
 from projeto_projeto where id = @id_projeto
set @aux = @faixa_ouro/ @qtd_ouro

SET @CONT   = 0
SET @QUANTIDADE = (SELECT COUNT(*) FROM CORRECOES_REDACAOOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
                                                                                JOIN CORRECOES_FILAOURO FIL WITH (NOLOCK)  ON (FIL.co_barra_redacao = RED.co_barra_redacao)
                    WHERE ID_REDACAOTIPO =  @ID_REDACAOTIPO AND 
                          FIL.posicao IS NULL AND 
                          FIL.id_corretor = @id_avaliador)

set @QUANTIDADE_CORRIGIDA = (SELECT COUNT(ID) FROM CORRECOES_CORRECAO COR  WITH (NOLOCK)
                             WHERE COR.id_corretor = @ID_AVALIADOR AND 
                                   COR.id_projeto  = @ID_PROJETO   AND
                                   COR.id_status   = 3             AND
                                   COR.id_tipo_correcao < 5)


    SELECT @POSICAO_INICIAL = MAX(POSICAO) FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED  WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
                                                       JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro)
    WHERE OUR.id_corretor = @id_avaliador AND REO.id_redacaotipo = @id_redacaotipo

    IF (@POSICAO_INICIAL IS NOT NULL)
            BEGIN
                SET @QUANTIDADE_CORRIGIDA = @POSICAO_INICIAL
            END

    /*

    UPDATE  OURO SET OURO.POSICAO = NULL 
    FROM CORRECOES_FILAOURO OURO
    WHERE id_corretor = @id_avaliador and
          id_projeto  = @id_projeto   and             
          posicao > @QUANTIDADE_CORRIGIDA AND 
          EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
                                                                           JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro) 
                    WHERE OURO.CO_BARRA_REDACAO = OUR.CO_BARRA_REDACAO AND 
                          REO.id_redacaotipo = @id_redacaotipo)

*/


WHILE (@CONT < @QUANTIDADE)
    BEGIN
    
        
        set @resultado =  ((@QUANTIDADE_CORRIGIDA + @aux*@cont ) + (  @aux )*rand())
        if (@resultado = 0)
            begin
                set @resultado = 5
            end


        select top 1 @id = id from correcoes_filaouro OURO
        where id_corretor = @id_avaliador and
              id_projeto  = @id_projeto   and             
              posicao is null AND 
               EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
                                                                           JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro) 
                    WHERE OURO.CO_BARRA_REDACAO = OUR.CO_BARRA_REDACAO AND 
                          REO.id_redacaotipo = @id_redacaotipo)
        ORDER BY OURO.ID

        update correcoes_filaouro set posicao =  @resultado 
        where id = @id
		
		-- CRIACAO LOG 
		EXEC SP_INSERE_LOG_FILAOURO @ID, @ID_PROJETO, @id_avaliador, '~'
		-- CRIACAO LOG - FIM 

        SET @CONT = @CONT + 1
    END
GO
