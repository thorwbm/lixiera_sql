with    cte_redacao as (
            select  
                   CO_INSCRICAO, 
                   CO_SITUACAO_REDACAO = id_correcao_situacao, 
                   VL_NOTA_REDACAO_COMP1 = nota_competencia1, 
                   VL_NOTA_REDACAO_COMP2 = nota_competencia2, 
                   VL_NOTA_REDACAO_COMP3 = nota_competencia3, 
                   VL_NOTA_REDACAO_COMP4 = nota_competencia4,       
                   VL_NOTA_REDACAO_COMP5 = nota_competencia5,
                   VL_NOTA_REDACAO       = nota_final, 
                   NU_GRUPO              = case when pro.descricao = 'Surdos'       then 13
                                                when pro.descricao = 'Disléxicos'   then 14
                                                when nota_final           = 1000    then 6
                                                when id_correcao_situacao = 6       then 7
                                                when id_correcao_situacao = 2       then 8
                                                when id_correcao_situacao = 7       then 9
                                                when id_correcao_situacao = 8       then 10
                                                when id_correcao_situacao = 9       then 11
                                                when id_correcao_situacao = 3       then 12
                                                when nota_final between   0 and 200 then 1
                                                when nota_final between 201 and 400 then 2
                                                when nota_final between 401 and 600 then 3
                                                when nota_final between 601 and 800 then 4
                                                when nota_final between 801 and 980 then 5 end, 
                   Imagem                = null,
                   aplicacao             = pro.descricao, 
                   link_imagem_recortada
              from correcoes_redacao red join projeto_projeto pro on (pro.id = red.id_projeto)
)
            select top 1000 * from cte_redacao red where nu_grupo = 1  and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 2  and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 3  and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 4  and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 5  and aplicacao = 'regular' union
            select *          from cte_redacao red where nu_grupo = 6  and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 7  and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 8  and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 9  and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 10 and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 11 and aplicacao = 'regular' union
            select top 1000 * from cte_redacao red where nu_grupo = 12 and aplicacao = 'regular' union
            select *          from cte_redacao red where nu_grupo = 13 union
            select *          from cte_redacao red where nu_grupo = 14 


          