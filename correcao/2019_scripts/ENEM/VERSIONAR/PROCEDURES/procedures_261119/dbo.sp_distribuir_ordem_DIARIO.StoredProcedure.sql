/****** Object:  StoredProcedure [dbo].[sp_distribuir_ordem_DIARIO]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[sp_distribuir_ordem_DIARIO]
GO
/****** Object:  StoredProcedure [dbo].[sp_distribuir_ordem_DIARIO]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_distribuir_ordem_DIARIO]
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
DECLARE @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR INT
DECLARE @POSICAO_INICIAL      INT
declare @alcance              int


--update projeto_projeto set ouro_quantidade = 2, ouro_frequencia = 30 where id = 4

select @faixa_ouro = ouro_frequencia, @qtd_ouro= ouro_quantidade
 from projeto_projeto where id =  @id_projeto
set @aux = @faixa_ouro/ @qtd_ouro

SET @CONT   = 1

/* LIMPAR A POSICAO DE TODAS AS CORRECOES OURO OU MODA PARA NOVA REDISTRIBUICAO */
UPDATE  FIL SET FIL.POSICAO = NULL
    FROM CORRECOES_FILAOURO FIL WITH (NOLOCK) JOIN CORRECOES_REDACAO     RED WITH (NOLOCK) ON (FIL.REDACAO_ID = RED.ID)
                                              JOIN CORRECOES_REDACAOOURO OUR WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
    WHERE FIL.id_corretor = @id_avaliador and
          FIL.id_projeto  = @id_projeto   AND
          OUR.id_redacaotipo = @id_redacaotipo



SET @QUANTIDADE = (SELECT COUNT(*) FROM CORRECOES_REDACAOOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED  WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
                                                                                JOIN CORRECOES_FILAOURO FIL WITH (NOLOCK)  ON (FIL.redacao_id = RED.id)
                    WHERE ID_REDACAOTIPO =  @ID_REDACAOTIPO AND
                          FIL.posicao IS NULL AND
                          FIL.id_corretor = @id_avaliador AND
                          FIL.id_projeto  = @id_projeto)

set @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR = (SELECT COUNT(ID) FROM CORRECOES_CORRECAO COR  WITH (NOLOCK)
                                             WHERE COR.id_corretor = @ID_AVALIADOR AND
                                                   COR.id_projeto  = @ID_PROJETO   AND
                                                   COR.id_status   = 3             AND
                                                   COR.id_tipo_correcao < 5       AND
                                          CAST(COR.DATA_TERMINO AS DATE)  <CAST(DBO.GETLOCALDATE() AS DATE))

WHILE (@CONT <= @QUANTIDADE)
    BEGIN

		set @resultado =  @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + (@aux * @cont) - (cast (RAND() * (@aux - 1) as int) + 1)  
		set @alcance   = (@QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + @aux*@cont )
        if (@resultado = 0)
            begin
                set @resultado = @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + 5
            end

        select top 1 @id = id from correcoes_filaouro OURO
        where id_corretor = @id_avaliador and
              id_projeto  = @id_projeto   and
              posicao is null AND
               EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.redacao_id = RED.id)
                                                                           JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro)
                    WHERE OURO.redacao_id = OUR.redacao_id AND
                          REO.id_redacaotipo = @id_redacaotipo)
        ORDER BY OURO.ID

        update correcoes_filaouro set posicao =  @resultado, alcance = @alcance
        where id = @id
		
		-- CRIACAO LOG 
		EXEC SP_INSERE_LOG_FILAOURO @ID, @ID_PROJETO, @id_avaliador, '~'
		-- CRIACAO LOG - FIM 

        SET @CONT = @CONT + 1
    END

GO
