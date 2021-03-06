/****** Object:  View [dbo].[vw_correcoes_por_redacao_grand_finale_full]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create      view [dbo].[vw_correcoes_por_redacao_grand_finale_full] as
SELECT 
       CODIGO_IMAGEM     = RED.ID,
       CODIGO_PROJETO    = RED.id_projeto,
	   INSCRICAO         = left(red.co_inscricao, 12),
	   
	   ID_AVALIADOR_AVA1         = COR1.ID_CORRETOR,
	   NOME_AVALIADOR_AVA1       = PES1.NOME,
	   CPF_AVALIADOR_AVA1        = PES1.cpf,  
	   COMP1_AVA1                = COR1.COMPETENCIA1,
	   COMP2_AVA1                = COR1.COMPETENCIA2,
	   COMP3_AVA1                = COR1.COMPETENCIA3,
	   COMP4_AVA1                = COR1.COMPETENCIA4,
	   COMP5_AVA1                = COR1.COMPETENCIA5,
	   NOTA_COMP1_AVA1           = COR1.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AVA1           = COR1.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AVA1           = COR1.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AVA1           = COR1.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AVA1           = COR1.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AVA1           = COR1.NOTA_FINAL,
	   ID_SITUACAO_AVA1          = COR1.id_correcao_situacao, 
	   SIGLA_SITUACAO_AVA1       = (select sitx.sigla from correcoes_situacao sitx with (nolock) where sitx.id = COR1.id_correcao_situacao),
	   FERE_DH_AVA1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
	   DATA_INICIO_AVA1          = COR1.data_inicio,
	   DATA_TERMINO_AVA1         = COR1.data_termino,
	   DURACAO_AVA1              = (CASE WHEN (cor1.tempo_em_correcao) > 9999 THEN 9999 ELSE cor1.tempo_em_correcao END),
	   LINK_IMAGEM_AV1           = COR1.LINK_IMAGEM_RECORTADA,
				   
	   ID_AVALIADOR_AVA2         = COR2.ID_CORRETOR,
	   NOME_AVALIADOR_AVA2       = PES2.NOME,
	   CPF_AVALIADOR_AVA2        = PES2.cpf,  
	   COMP1_AVA2                = COR2.COMPETENCIA1,
	   COMP2_AVA2                = COR2.COMPETENCIA2,
	   COMP3_AVA2                = COR2.COMPETENCIA3,
	   COMP4_AVA2                = COR2.COMPETENCIA4,
	   COMP5_AVA2                = COR2.COMPETENCIA5,
	   NOTA_COMP1_AVA2           = COR2.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AVA2           = COR2.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AVA2           = COR2.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AVA2           = COR2.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AVA2           = COR2.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AVA2           = COR2.NOTA_FINAL,
	   ID_SITUACAO_AVA2          = COR2.id_correcao_situacao, 
	   SIGLA_SITUACAO_AVA2       = (select sitx.sigla from correcoes_situacao sitx with (nolock) where sitx.id = COR2.id_correcao_situacao),
	   FERE_DH_AVA2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
	   DATA_INICIO_AVA2          = COR2.data_inicio,
	   DATA_TERMINO_AVA2         = COR2.data_termino,
	   DURACAO_AVA2              = (CASE WHEN (cor2.tempo_em_correcao) > 9999 THEN 9999 ELSE cor2.tempo_em_correcao END),
	   LINK_IMAGEM_AV2           = COR2.LINK_IMAGEM_RECORTADA,
	   
	   	
	   ID_AVALIADOR_AVA3         = COR3.ID_CORRETOR,
	   NOME_AVALIADOR_AVA3       = PES3.NOME,
	   CPF_AVALIADOR_AVA3        = PES3.cpf,  
	   COMP1_AVA3                = COR3.COMPETENCIA1,
	   COMP2_AVA3                = COR3.COMPETENCIA2,
	   COMP3_AVA3                = COR3.COMPETENCIA3,
	   COMP4_AVA3                = COR3.COMPETENCIA4,
	   COMP5_AVA3                = COR3.COMPETENCIA5,
	   NOTA_COMP1_AVA3           = COR3.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AVA3           = COR3.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AVA3           = COR3.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AVA3           = COR3.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AVA3           = COR3.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AVA3           = COR3.NOTA_FINAL,
	   ID_SITUACAO_AVA3          = COR3.id_correcao_situacao, 
	   SIGLA_SITUACAO_AVA3       = (select sitx.sigla from correcoes_situacao sitx with (nolock) where sitx.id = COR3.id_correcao_situacao),
	   FERE_DH_AVA3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
	   DATA_INICIO_AVA3          = COR3.data_inicio,
	   DATA_TERMINO_AVA3         = COR3.data_termino,
	   DURACAO_AVA3              = (CASE WHEN (cor3.tempo_em_correcao) > 9999 THEN 9999 ELSE cor3.tempo_em_correcao END),	   
	   LINK_IMAGEM_AV3           = COR3.LINK_IMAGEM_RECORTADA,
	    	
	   ID_AVALIADOR_AVA4         = COR4.ID_CORRETOR,
	   NOME_AVALIADOR_AVA4       = PES4.NOME,
	   CPF_AVALIADOR_AVA4        = PES4.cpf,  
	   COMP1_AVA4                = COR4.COMPETENCIA1,
	   COMP2_AVA4                = COR4.COMPETENCIA2,
	   COMP3_AVA4                = COR4.COMPETENCIA3,
	   COMP4_AVA4                = COR4.COMPETENCIA4,
	   COMP5_AVA4                = COR4.COMPETENCIA5,
	   NOTA_COMP1_AVA4           = COR4.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AVA4           = COR4.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AVA4           = COR4.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AVA4           = COR4.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AVA4           = COR4.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AVA4           = COR4.NOTA_FINAL,
	   ID_SITUACAO_AVA4          = COR4.id_correcao_situacao, 
	   SIGLA_SITUACAO_AVA4       = (select sitx.sigla from correcoes_situacao sitx with (nolock) where sitx.id = COR4.id_correcao_situacao),
	   FERE_DH_AVA4              = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
	   DATA_INICIO_AVA4          = COR4.data_inicio,
	   DATA_TERMINO_AVA4         = COR4.data_termino,
	   DURACAO_AVA4              = (CASE WHEN (cor4.tempo_em_correcao) > 9999 THEN 9999 ELSE cor4.tempo_em_correcao END),
	   LINK_IMAGEM_AV4           = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
	   ID_AVALIADOR_AVAA         = CORA.ID_CORRETOR,
	   NOME_AVALIADOR_AVAA       = PESA.NOME,
	   CPF_AVALIADOR_AVAA        = PESA.cpf,  
	   COMP1_AVAA                = CORA.COMPETENCIA1,
	   COMP2_AVAA                = CORA.COMPETENCIA2,
	   COMP3_AVAA                = CORA.COMPETENCIA3,
	   COMP4_AVAA                = CORA.COMPETENCIA4,
	   COMP5_AVAA                = CORA.COMPETENCIA5,
	   NOTA_COMP1_AVAA           = CORA.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AVAA           = CORA.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AVAA           = CORA.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AVAA           = CORA.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AVAA           = CORA.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AVAA           = CORA.NOTA_FINAL,
	   ID_SITUACAO_AVAA          = CORA.id_correcao_situacao, 
	   SIGLA_SITUACAO_AVAA       = (select sitx.sigla from correcoes_situacao sitx with (nolock) where sitx.id = CORA.id_correcao_situacao),
	   DATA_INICIO_AVAA          = CORA.data_inicio,
	   DATA_TERMINO_AVAA         = CORA.data_termino,
	   DURACAO_AVAA              = (CASE WHEN (corA.tempo_em_correcao) > 9999 THEN 9999 ELSE corA.tempo_em_correcao END),
	   LINK_IMAGEM_AVA           = CORA.LINK_IMAGEM_RECORTADA,

	   RED.CO_BARRA_REDACAO, 
	   CO_INSCRICAO = left(red.co_inscricao, 12),
	   RED.id_correcao_situacao,
	   RED.nota_final,
	   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
	                                     when CORA.id is not null and CORA.competencia5 = 0 then 0
	                                     when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
	                                     when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
	                                     when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
	                                     when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
	                                     else NULL end,
   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
	   sno2.CO_PROJETO,               
	   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
	   sn91.ID_ITEM_ATENDIMENTO,
	   NOTA_COMP1 = case
	                   when CORA.id is not null then CORA.nota_competencia1
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia1
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then (ANA3.nota_competencia1_A + ANA3.nota_competencia1_B) / 2
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia1 + COR2.nota_competencia1) / 2
					end,
	   NOTA_COMP2 = case
	                   when CORA.id is not null then CORA.nota_competencia2
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia2
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then (ANA3.nota_competencia2_A + ANA3.nota_competencia2_B) / 2
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia2 + COR2.nota_competencia2) / 2
					end,
	   NOTA_COMP3 = case
	                   when CORA.id is not null then CORA.nota_competencia3
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia3
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then (ANA3.nota_competencia3_A + ANA3.nota_competencia3_B) / 2
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia3 + COR2.nota_competencia3) / 2
					end,
	   NOTA_COMP4 = case
	                   when CORA.id is not null then CORA.nota_competencia4
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia4
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then (ANA3.nota_competencia4_A + ANA3.nota_competencia4_B) / 2
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia4 + COR2.nota_competencia4) / 2
					end,
	   NOTA_COMP5 = case
	                   when CORA.id is not null then CORA.nota_competencia5
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia5
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then (ANA3.nota_competencia5_A + ANA3.nota_competencia5_B) / 2
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia5 + COR2.nota_competencia5) / 2
					end,
	   co_justificativa = null,
	   FERE_DH_AVAA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
--  into REDACOES_04012019_FULL_2
  FROM CORRECOES_REDACAO RED with (nolock)  LEFT JOIN inep.INEP_N02        SNO2 ON (SNO2.CO_INSCRICAO     = left(red.co_inscricao, 12))  
       INNER JOIN inep.inep_n90 sn90 on sn90.co_inscricao = left(red.co_inscricao, 12)
       INNER JOIN correcoes_redacao_resultado res with (nolock) on res.co_inscricao = left(red.co_inscricao, 12)
	   LEFT JOIN inep.INEP_N91 SN91  ON (SN91.CO_INSCRICAO = left(red.co_inscricao, 12) and sn91.ID_ITEM_ATENDIMENTO IN (5, 8))
	   LEFT JOIN CORRECOES_CORRECAO COR1 with (nolock) ON (RED.co_barra_redacao  = COR1.co_barra_redacao AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
	   LEFT JOIN USUARIOS_PESSOA    PES1 with (nolock) ON (COR1.id_corretor      = PES1.usuario_id)
	   LEFT JOIN CORRECOES_CORRECAO COR2 with (nolock) ON (RED.co_barra_redacao  = COR2.co_barra_redacao AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
	   LEFT JOIN USUARIOS_PESSOA    PES2 with (nolock) ON (COR2.id_corretor      = PES2.usuario_id)
	   LEFT JOIN CORRECOES_CORRECAO COR3 with (nolock) ON (RED.co_barra_redacao  = COR3.co_barra_redacao AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
	   LEFT JOIN USUARIOS_PESSOA    PES3 with (nolock) ON (COR3.id_corretor      = PES3.usuario_id)
	   LEFT JOIN CORRECOES_CORRECAO COR4 with (nolock) ON (RED.co_barra_redacao  = COR4.co_barra_redacao AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
	   LEFT JOIN USUARIOS_PESSOA    PES4 with (nolock) ON (COR4.id_corretor      = PES4.usuario_id)
	   LEFT JOIN CORRECOES_CORRECAO CORA with (nolock) ON (RED.co_barra_redacao  = CORA.co_barra_redacao AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
	   LEFT JOIN USUARIOS_PESSOA    PESA with (nolock) ON (CORA.id_corretor      = PESA.usuario_id)
	   LEFT JOIN CORRECOES_ANALISE  ANA3 with (nolock) ON (ANA3.co_barra_redacao = RED.co_barra_redacao AND ANA3.id_tipo_correcao_B = 3 AND ANA3.aproveitamento = 1) 
 WHERE red.cancelado = 0 and res.mensagem_validacao is null
   and red.co_barra_redacao in ('029218100223657603', '029218102895704907')
  -- and red.id_redacao_situacao = 1
  --and red.co_inscricao like '%[_]%'

GO
