/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_com_auditoria]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_gera_lote_n59_com_auditoria]
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_com_auditoria]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_com_auditoria]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @12_lote_id int
	declare @3_lote_id int
	declare @4_lote_id int
	declare @auditoria_lote_id int
	declare @bi_lote_id int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '5'

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_9 int = 9
    declare @tipo_bi int = 3
    declare @interface_n59 int = 1


	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_9 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_9)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_9
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_AUDITORIA', 1, dbo.getlocaldate(), @tipo_9, @interface_n59)
	set @auditoria_lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(COR1.data_inicio, COR2.data_inicio), COR3.data_inicio), COR4.data_inicio), CORA.data_inicio),
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   sn91.ID_ITEM_ATENDIMENTO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = null,
		   FERE_DH_AVA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (' + @pcd_surdez + ', ' + @pcd_dislexia + '))
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado = 0 and red.nota_final is not null and red.id_status = 4
	   and red.data_termino is not null
	   and red.co_inscricao not in (select n59.co_inscricao from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id and lote.status_id in (4, 2))
	   and CORA.ID_CORRETOR is not null
	   and cor4.id_corretor is null;
	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	CREATE NONCLUSTERED INDEX ix__tmp_redacoes__co_inscricao__CPF_AVALIADOR_AV4__NOTA_FINAL
	ON #tmp_redacoes ([CPF_AVALIADOR_AV4],[NOTA_FINAL])
	INCLUDE ([REDACAO_ID],[PROJETO_ID],[CPF_AVALIADOR_AV1],[NOTA_COMP1_AV1],[NOTA_COMP2_AV1],[NOTA_COMP3_AV1],[NOTA_COMP4_AV1],[NOTA_COMP5_AV1],[NOTA_FINAL_AV1],[ID_SITUACAO_AV1],[SIGLA_SITUACAO_AV1],[FERE_DH_AV1],[DATA_INICIO_AV1],[DATA_TERMINO_AV1],[DURACAO_AV1],[LINK_IMAGEM_AV1],[CPF_AVALIADOR_AV2],[NOTA_COMP1_AV2],[NOTA_COMP2_AV2],[NOTA_COMP3_AV2],[NOTA_COMP4_AV2],[NOTA_COMP5_AV2],[NOTA_FINAL_AV2],[ID_SITUACAO_AV2],[SIGLA_SITUACAO_AV2],[FERE_DH_AV2],[DATA_INICIO_AV2],[DATA_TERMINO_AV2],[DURACAO_AV2],[CPF_AVALIADOR_AV3],[NOTA_COMP1_AV3],[NOTA_COMP2_AV3],[NOTA_COMP3_AV3],[NOTA_COMP4_AV3],[NOTA_COMP5_AV3],[NOTA_FINAL_AV3],[ID_SITUACAO_AV3],[SIGLA_SITUACAO_AV3],[FERE_DH_AV3],[DATA_INICIO_AV3],[DATA_TERMINO_AV3],[DURACAO_AV3],[NOTA_COMP1_AV4],[NOTA_COMP2_AV4],[NOTA_COMP3_AV4],[NOTA_COMP4_AV4],[NOTA_COMP5_AV4],[NOTA_FINAL_AV4],[ID_SITUACAO_AV4],[SIGLA_SITUACAO_AV4],[FERE_DH_AV4],[DATA_INICIO_AV4],[DATA_TERMINO_AV4],[DURACAO_AV4],[CPF_AVALIADOR_AVA],[NOTA_COMP1_AVA],[NOTA_COMP2_AVA],[NOTA_COMP3_AVA],[NOTA_COMP4_AVA],[NOTA_COMP5_AVA],[NOTA_FINAL_AVA],[ID_SITUACAO_AVA],[SIGLA_SITUACAO_AVA],[DATA_INICIO_AVA],[DATA_TERMINO_AVA],[DURACAO_AVA],[CO_INSCRICAO],[ID_CORRECAO_SITUACAO],[FERE_DH_FINAL],[DATA_INICIO],[DATA_TERMINO],[CO_PROJETO],[SG_UF_PROVA],[ID_ITEM_ATENDIMENTO],[NOTA_COMP1],[NOTA_COMP2],[NOTA_COMP3],[NOTA_COMP4],[NOTA_COMP5],[co_justificativa],[FERE_DH_AVAA])

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao, nu_cpf_auditor)
		 select red.redacao_id, ' + convert(varchar(50), @auditoria_lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, case red.id_item_atendimento when ' + @pcd_surdez + ' then 2 when ' + @pcd_dislexia + ' then 3 else 1 end, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.cpf_avaliador_ava else red.cpf_avaliador_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_inicio_ava else red.data_inicio_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_termino_ava else red.data_termino_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.duracao_ava else red.duracao_av3 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.id_situacao_ava else red.id_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.sigla_situacao_ava else red.sigla_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_final_ava else red.nota_final_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp1_ava else red.nota_comp1_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp2_ava else red.nota_comp2_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp3_ava else red.nota_comp3_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp4_ava else red.nota_comp4_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp5_ava else red.nota_comp5_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.fere_dh_ava else red.fere_dh_av3 end,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.cpf_avaliador_ava else red.cpf_avaliador_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_inicio_ava else red.data_inicio_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_termino_ava else red.data_termino_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.duracao_ava else red.duracao_av4 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.id_situacao_ava else red.id_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.sigla_situacao_ava else red.sigla_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_final_ava else red.nota_final_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp1_ava else red.nota_comp1_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp2_ava else red.nota_comp2_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp3_ava else red.nota_comp3_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp4_ava else red.nota_comp4_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp5_ava else red.nota_comp5_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.fere_dh_ava else red.fere_dh_av4 end,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0, red.cpf_avaliador_ava
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
	   and not exists(select top 1 1 from inep_n59 n59 join inep_lote lote on n59.co_inscricao = red.co_inscricao and lote.id = n59.lote_id and lote.status_id in (4, 2));

	'
	exec (@sql)


	--Garante o IN_FERE_DH correto
	update inep_n59 set in_fere_dh = null where nu_nota_media_comp5 > 0 and in_fere_dh = 0 and lote_id in (@auditoria_lote_id)
	update inep_n59 set in_fere_dh = 0 where nu_nota_media_comp5 = 0 and in_fere_dh is null and lote_id in (@auditoria_lote_id)


	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    exec sp_consiste_lote_n59 @auditoria_lote_id


end
GO
