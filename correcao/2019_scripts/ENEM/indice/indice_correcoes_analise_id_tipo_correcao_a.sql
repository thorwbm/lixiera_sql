/*
Missing Index Details from SQLQuery11.sql - enemregular.database.windows.net.correcao_redacao_regular (enem (144))
The Query Processor estimates that implementing the following index could improve the query cost by 74.7266%.
*/

/*
USE [correcao_redacao_regular]
GO
CREATE NONCLUSTERED INDEX ix__correcoes_analise__id_tipo_correcao_A
ON [dbo].[correcoes_analise] ([id_tipo_correcao_A])
INCLUDE ([data_termino_A],[nota_final_A],[competencia1_A],[competencia2_A],[competencia3_A],[competencia4_A],[competencia5_A],[id_corretor_A],[co_barra_redacao],[id_projeto],[id_correcao_situacao_A],[id_correcao_A],[conclusao_analise])
GO
*/
