/****** Object:  View [dbo].[vw_correcoes_redacao_resultado]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_correcoes_redacao_resultado] as
select 1 as ordem, 'Fechou nota na primeira e segunda correções' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Fechou nota na primeira e segunda correções' union all
select 2 as ordem, 'Fechou nota na terceira correção' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Fechou nota na terceira correção' union all
select 3 as ordem, 'Fechou nota na quarta correção' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Fechou nota na quarta correção' union all
select 4 as ordem, 'Fechou nota com auditoria' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Fechou nota com auditoria' union all
select 5 as ordem, 'Em correção' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Em correção' union all
select 6 as ordem, 'Texto insuficiente' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Texto insuficiente' union all
select 7 as ordem, 'Em branco' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Em branco' union all
select 8 as ordem, 'Material não retornou' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Material não retornou' union all
select 9 as ordem, 'Redação não recebida' as status, count(*) as valor from correcoes_redacao_resultado where conclusao_final_detalhe = 'Redação não recebida'
GO
