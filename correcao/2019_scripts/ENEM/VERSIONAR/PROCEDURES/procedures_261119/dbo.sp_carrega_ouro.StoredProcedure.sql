/****** Object:  StoredProcedure [dbo].[sp_carrega_ouro]    Script Date: 26/11/2019 08:33:15 ******/
DROP PROCEDURE [dbo].[sp_carrega_ouro]
GO
/****** Object:  StoredProcedure [dbo].[sp_carrega_ouro]    Script Date: 26/11/2019 08:33:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_carrega_ouro] 
    @ID_REDACAO INT,
    @ID_CORRETOR INT,
    @ID_PROJETO  INT 
as 

begin try
begin tran

    -- ***** colocar na tabela redacoes ouro as redacoes selecionadas

    insert into correcoes_redacaoouro (link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
                                       co_barra_redacao,co_inscricao,co_formulario,id_prova, id_projeto, id_redacaotipo)
    select link_imagem_recortada, link_imagem_original,nota_final, null, 
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,2 
     from correcoes_redacao red 
    where not exists (select 1 from correcoes_redacaoouro our 
                       where our.co_barra_redacao = red.co_barra_redacao and 
                             our.id_projeto = red.id_projeto and 
                             our.id_redacaotipo = 2) and
          id_redacaoouro is null and 
          RED.id_projeto = @ID_PROJETO AND
          red.id in (@id_redacao)
    order by co_barra_redacao

    DROP TABLE  #tmp_correcoes_redacao
     -- **** inserir na tabela redacao as redacoes ouro para o candidato 
     select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
            co_barra_redacao = '001' + right('000000' +convert(varchar(6),our.id),6) +
                                       right('000000' +convert(varchar(6),@ID_CORRETOR),6),
            co_inscricaon    = '001' + right('000000' +convert(varchar(6),our.id),6) +
                                       right('000000' +convert(varchar(6),@ID_CORRETOR),6),
            co_formulario,id_prova, id_projeto,id 
      into #tmp_correcoes_redacao
       from correcoes_redacaoouro OUR 
         where data_criacao > '2018-12-03 23:00'
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
    SELECT red.co_barra_redacao,
           @ID_CORRETOR, null, red.id_projeto
      FROM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
     where not exists (select * from correcoes_filaouro flox 
                        where flox.co_barra_redacao = red.co_barra_redacao and 
                              flox.id_corretor      = @ID_CORRETOR AND 
                              FLOX.id_projeto       = @ID_PROJETO)
 
    --- INSERE NA CORRECOES GABARITO
    insert correcoes_gabarito (nota_final, id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
           nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
           co_barra_redacao)
    select  our.nota_final, our.id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
           nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
           red.co_barra_redacao
     frOM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
     where not exists (select 1 from correcoes_gabarito gabx
                        where gabx.co_barra_redacao = red.co_barra_redacao) and
           our.id_projeto = 4
           and data_criacao > '2018-12-03 23:00'

     exec sp_distribuir_ordem @ID_CORRETOR, @ID_PROJETO, 2

     commit
end try
begin catch
    print error_message()
    rollback
end catch


SELECT * FROM correcoes_REDACAOouro WHERE id_redacaotipo = 3

GO
