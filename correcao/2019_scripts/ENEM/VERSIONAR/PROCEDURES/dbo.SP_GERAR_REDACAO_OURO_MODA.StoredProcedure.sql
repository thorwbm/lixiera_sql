/****** Object:  StoredProcedure [dbo].[SP_GERAR_REDACAO_OURO_MODA]    Script Date: 25/11/2019 09:23:18 ******/
DROP PROCEDURE [dbo].[SP_GERAR_REDACAO_OURO_MODA]
GO
/****** Object:  StoredProcedure [dbo].[SP_GERAR_REDACAO_OURO_MODA]    Script Date: 25/11/2019 09:23:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--####################################################################################################

/*****************************************************************************************************************
*                                  PROCEDURE PARA CRIAR REDACOES OURO OU MODA                                    *
*                                                                                                                *
*  PROCEDURE QUE RECEBE O TIPO DE REDACAO A SER GERADA (2-OURO OU 3-MODA) E COM BASE NAS REDACOES CADASTRADAS NA * 
* TABELA redacoes_redacaoreferencia SERA CRIADO UMA COPIA NA TABELA CORRECOES_REDACAOOURO, UMA COPIA NA          *
* CORRECOES_REDACAO COM O CODIGO DE BARRA ALTERADO (SENDO INICIADO COM 001 PARA OURO E 002 PARA MODA DEPOIS      *
* CRIADO UM REGISTRO PARA CADA UMA NA CORRECOES_FILAOURO E EM SEGUIDA CRIADO UMA ORDENACAO DE BUSCA COM BASE NAS *
* INFORMACOESDA PROJETO_PROJETO                                                                                  *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:27/11/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:27/11/2018 *
******************************************************************************************************************/

CREATE   PROCEDURE [dbo].[SP_GERAR_REDACAO_OURO_MODA] @TIPO_REDACAO INT AS 

DECLARE @ID_CORRETOR  INT 
DECLARE @ID_PROJETO   INT 

--***** INSERIR NA TABELA CORRRECOES_REDACAOOURO (as modas selecionadas na tabela redacoes_redacaoreferencia)
insert into correcoes_redacaoouro (link_imagem_recortada, link_imagem_original, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaotipo, data_criacao, id_origem)
select red.link_imagem_recortada, red.link_imagem_original, red.co_barra_redacao, red.co_inscricao, red.co_formulario, red.id_prova, red.id_projeto, id_redacaotipo = ref.id_redacao_tipo, 
       data_criacao = DBO.GETLOCALDATE(), id_origem = 1 
  from correcoes_redacao red join redacoes_redacaoreferencia  ref on  (ref.id_redacao       = red.id)  
                        left join correcoes_redacaoouro       our on  (red.co_barra_redacao = our.co_barra_redacao)
                        left join correcoes_redacaoouro       ourx on (red.id_redacaoouro   = ourx.id)
 where ref.id_redacao_tipo = @tipo_redacao and 
       our.co_barra_redacao is null and 
       ourx.co_barra_redacao is null 

-- **** inserir na tabela redacao as redacoes ouro para o candidato 
     select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
            co_barra_redacao = CASE WHEN @tipo_redacao = 2 THEN '001'
                                    WHEN @tipo_redacao = 3 THEN '002'ELSE '***' END + right('000000' +convert(varchar(6),our.id),6) +
                                                                                      right('000000' +convert(varchar(6),cor.id),6),
            co_inscricao     = CASE WHEN @tipo_redacao = 2 THEN '001'
                                    WHEN @tipo_redacao = 3 THEN '002'ELSE '***' END + right('000000' +convert(varchar(6),our.id),6) +
                                                                                      right('000000' +convert(varchar(6),cor.id),6),
            co_formulario,id_prova, id_projeto,our.id, id_corretor = cor.id
        into #tmp_correcoes_redacao
       from correcoes_redacaoouro OUR join correcoes_corretor cor on (1=1)
                                      join projeto_projeto_usuarios usu on (cor.id = usu.user_id)
        where usu.projeto_id = 4 and 
              our.id_redacaotipo = @tipo_redacao and 
              usu.user_id in (select usuario_id from vw_usuario_hierarquia where perfil in ('AUXILIARES DE CORREÇÃO DE REDAÇÃO', 'avaliador'))
      order by co_barra_redacao

      select * from #tmp_correcoes_redacao
      -- *** inserir na tabela redacao com o codigo de barra alterado para o padrao moda ou ouro dependendo do tipo_redacao escolhido e levando o id da redacao referencia 
    insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao,
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
    select link_imagem_recortada, link_imagem_original, nota_final, 1, 
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
      from #tmp_correcoes_redacao tmp
     where not exists (select 1 from correcoes_redacao redx 
                        where redx.co_barra_redacao = tmp.co_barra_redacao AND
                              REDX.id_projeto = TMP.id_projeto)

    -- **** inserir na tabela filaOURO
    -- **** select * from correcoes_filaouro where posicao is null 
    insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto, criado_em)
    SELECT tem.co_barra_redacao, tem.id_corretor, null, tem.id_projeto, DBO.GETLOCALDATE()
      FROM #tmp_correcoes_redacao tem
     where not exists (select top 1 1 from correcoes_filaouro flox 
                        where flox.co_barra_redacao = tem.co_barra_redacao and 
                              flox.id_corretor      = tem.id_corretor AND 
                              FLOX.id_projeto       = 4)
 
 -- ***** monto a ordenacao de busca das redacoes para o busca mais um 
 declare CUR_DIS_ORD_OUR_MOD cursor for 
    SELECT id_corretor, id_projeto FROM #tmp_correcoes_redacao
    open CUR_DIS_ORD_OUR_MOD 
        fetch next from CUR_DIS_ORD_OUR_MOD into @id_corretor, @id_projeto
        while @@FETCH_STATUS = 0
            BEGIN
                 exec sp_distribuir_ordem  @id_corretor, @id_projeto, @tipo_redacao

            fetch next from CUR_DIS_ORD_OUR_MOD into @id_corretor, @id_projeto
            END
    close CUR_DIS_ORD_OUR_MOD 
deallocate CUR_DIS_ORD_OUR_MOD

GO
