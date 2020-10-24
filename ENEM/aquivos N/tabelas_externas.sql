
CREATE EXTERNAL TABLE [dbo].[correcoes_correcao]
(
	[id] [int] NOT NULL,
	[token_auxiliar1] [nvarchar](10) NULL,
	[token_auxiliar2] [nvarchar](10) NULL,
	[data_inicio] [datetime2](7) NULL,
	[data_termino] [datetime2](7) NULL,
	[correcao] [nvarchar](max) NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[competencia1] [int] NULL,
	[competencia2] [int] NULL,
	[competencia3] [int] NULL,
	[competencia4] [int] NULL,
	[competencia5] [int] NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[tempo_em_correcao] [int] NOT NULL,
	[angulo_imagem] [int] NOT NULL,
	[atualizado_por] [int] NULL,
	[id_auxiliar1] [int] NULL,
	[id_auxiliar2] [int] NULL,
	[id_correcao_situacao] [int] NULL,
	[id_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[id_status] [int] NOT NULL,
	[tipo_auditoria_id] [int] NULL,
	[id_tipo_correcao] [int] NOT NULL,
	[redacao_id] [int] NOT NULL
)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO






CREATE EXTERNAL TABLE [dbo].[correcoes_redacao]
(
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[id_correcao_situacao] [int] NULL,
	[id_redacao_situacao] [int] NOT NULL,
	[id_projeto] [int] NULL,
	[id_redacaoouro] [int] NULL,
	[id_status] [int] NULL,
	[cancelado] [bit] NOT NULL,
	[justificativa_cancelamento] [nvarchar](500) NULL,
	[motivo_id] [int] NOT NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[data_inicio] [datetime2](7) NULL,
	[data_termino] [datetime2](7) NULL,
	[faixa_plano_amostral] [nvarchar](100) NULL
)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO


/****** Object:  Table [dbo].[correcoes_analise]    Script Date: 10/20/2020 11:52:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE EXTERNAL TABLE [dbo].[correcoes_analise]
(
	[id] [int] NOT NULL,
	[data_inicio_A] [datetime2](7) NOT NULL,
	[data_inicio_B] [datetime2](7) NULL,
	[data_termino_A] [datetime2](7) NOT NULL,
	[data_termino_B] [datetime2](7) NULL,
	[link_imagem_recortada] [nvarchar](255) NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final_A] [numeric](10, 2) NOT NULL,
	[nota_final_B] [numeric](10, 2) NULL,
	[situacao_nota_final] [int] NULL,
	[competencia1_A] [int] NULL,
	[competencia1_B] [int] NULL,
	[competencia2_A] [int] NULL,
	[competencia2_B] [int] NULL,
	[competencia3_A] [int] NULL,
	[competencia3_B] [int] NULL,
	[competencia4_A] [int] NULL,
	[competencia4_B] [int] NULL,
	[competencia5_A] [int] NULL,
	[competencia5_B] [int] NULL,
	[nota_competencia1_A] [numeric](10, 2) NULL,
	[nota_competencia1_B] [numeric](10, 2) NULL,
	[diferenca_competencia1] [numeric](10, 2) NULL,
	[situacao_competencia1] [int] NULL,
	[nota_competencia2_A] [numeric](10, 2) NULL,
	[nota_competencia2_B] [numeric](10, 2) NULL,
	[diferenca_competencia2] [numeric](10, 2) NULL,
	[situacao_competencia2] [int] NULL,
	[nota_competencia3_A] [numeric](10, 2) NULL,
	[nota_competencia3_B] [numeric](10, 2) NULL,
	[diferenca_competencia3] [numeric](10, 2) NULL,
	[situacao_competencia3] [int] NULL,
	[nota_competencia4_A] [numeric](10, 2) NULL,
	[nota_competencia4_B] [numeric](10, 2) NULL,
	[diferenca_competencia4] [numeric](10, 2) NULL,
	[situacao_competencia4] [int] NULL,
	[nota_competencia5_A] [numeric](10, 2) NULL,
	[nota_competencia5_B] [numeric](10, 2) NULL,
	[diferenca_competencia5] [numeric](10, 2) NULL,
	[situacao_competencia5] [int] NULL,
	[diferenca_nota_final] [numeric](10, 2) NULL,
	[id_auxiliar1_A] [int] NULL,
	[id_auxiliar2_A] [int] NULL,
	[id_auxiliar1_B] [int] NULL,
	[id_auxiliar2_B] [int] NULL,
	[diferenca_situacao] [int] NULL,
	[id_status_A] [int] NOT NULL,
	[id_status_B] [int] NULL,
	[id_tipo_correcao_A] [int] NOT NULL,
	[id_tipo_correcao_B] [int] NULL,
	[conclusao_analise] [int] NOT NULL,
	[fila] [int] NULL,
	[nota_corretor] [numeric](10, 6) NULL,
	[aproveitamento] [bit] NULL,
	[nota_desempenho] [numeric](10, 6) NULL,
	[id_correcao_A] [int] NOT NULL,
	[id_correcao_B] [int] NULL,
	[id_correcao_situacao_A] [int] NOT NULL,
	[id_correcao_situacao_B] [int] NULL,
	[id_corretor_A] [int] NOT NULL,
	[id_corretor_B] [int] NULL,
	[id_projeto] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[redacao_id] [int] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL
)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO

CREATE EXTERNAL TABLE [dbo].[projeto_projeto]
(	[id] [int]  NOT NULL,
	[descricao] [nvarchar](255) NOT NULL,
	[max_correcoes_dia] [int] NOT NULL,
	[titulo] [nvarchar](10) NOT NULL,
	[subtitulo] [nvarchar](50) NOT NULL,
	[fila_prioritaria] [int] NOT NULL,
	[fila_supervisor] [int] NOT NULL,
	[limite_nota_final] [numeric](10, 2) NOT NULL,
	[limite_nota_competencia] [numeric](10, 2) NOT NULL,
	[data_inicio] [datetime2](7) NULL,
	[data_termino] [datetime2](7) NULL,
	[ouro_frequencia] [int] NULL,
	[ouro_quantidade] [int] NULL,
	[peso_aproveitamento_individual] [numeric](10, 2) NULL,
	[peso_aproveitamento_coletivo] [numeric](10, 2) NULL,
	[peso_prova_ouro] [numeric](10, 2) NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[etapa_ensino_id] [int] NULL,
	[peso_competencia] [int] NOT NULL,
	[possui_avaliacao_desempenho] [bit] NOT NULL

)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO

--######################################################
CREATE EXTERNAL TABLE[dbo].[correcoes_corretor](
	[id] [int] NOT NULL,
	[max_correcoes_dia] [int] NOT NULL,
	[pode_corrigir_1] [bit] NOT NULL,
	[pode_corrigir_2] [bit] NOT NULL,
	[pode_corrigir_3] [bit] NOT NULL,
	[nota_corretor] [numeric](10, 2) NULL,
	[tipo_cota] [nvarchar](1) NOT NULL,
	[atualizado_por] [int] NULL,
	[id_grupo] [int] NULL,
	[status_id] [int] NOT NULL,
	[dsp] [numeric](4, 2) NULL,
	[tempo_medio_correcao] [numeric](10, 2) NULL,
	[supervisor_em_banca] [bit] NULL,
	[pode_corrigir_4] [bit] NOT NULL,
	[enviado_para_correcao_em] [datetime2](7) NULL,
	[recapacitacao_criada_em] [datetime2](7) NULL,
	[recapacitacao_habilitada_em] [datetime2](7) NULL
)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO



CREATE EXTERNAL TABLE  [dbo].[auth_user](
	[id] [int]  NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[last_login] [datetime2](7) NULL,
	[is_superuser] [bit] NOT NULL,
	[username] [nvarchar](150) NOT NULL,
	[first_name] [nvarchar](30) NOT NULL,
	[last_name] [nvarchar](150) NOT NULL,
	[email] [nvarchar](254) NOT NULL,
	[is_staff] [bit] NOT NULL,
	[is_active] [bit] NOT NULL,
	[date_joined] [datetime2](7) NOT NULL
)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO


/****** Object:  Table [dbo].[inep_n02_local]    Script Date: 10/22/2020 5:18:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE EXTERNAL TABLE [dbo].INEP_N02
(
	[CO_PROJETO] [nvarchar](255) NULL,
	[TP_ORIGEM] [nvarchar](255) NULL,
	[CO_INSCRICAO] [nvarchar](255) NULL,
	[NO_INSCRITO] [nvarchar](255) NULL,
	[NO_SOCIAL] [nvarchar](255) NULL,
	[NU_CPF] [nvarchar](255) NULL,
	[NU_RG] [nvarchar](255) NULL,
	[DT_NASCIMENTO] [nvarchar](255) NULL,
	[TP_LINGUA_ESTRANGEIRA] [nvarchar](255) NULL,
	[NO_LINGUA_ESTRANGEIRA] [nvarchar](255) NULL,
	[CO_ATENDIMENTO_LISTA_PRESENCA] [nvarchar](255) NULL,
	[ID_KIT_PROVA] [nvarchar](255) NULL,
	[CO_COORDENACAO] [nvarchar](255) NULL,
	[SG_UF_PROVA] [nvarchar](255) NULL,
	[CO_MUNICIPIO_PROVA] [nvarchar](255) NULL,
	[NO_MUNICIPIO_PROVA] [nvarchar](255) NULL,
	[CO_LOCAL] [nvarchar](255) NULL,
	[NO_LOCAL_PROVA] [nvarchar](255) NULL,
	[CO_BLOCO] [nvarchar](255) NULL,
	[NO_BLOCO] [nvarchar](255) NULL,
	[NO_ANDAR] [nvarchar](255) NULL,
	[NO_SALA] [nvarchar](255) NULL,
	[NO_SALA_VIRTUAL] [nvarchar](255) NULL,
	[NU_SEQUENCIAL] [nvarchar](255) NULL,
	[NU_SEQ_ENVELOPE] [nvarchar](255) NULL,
	[NU_TOTAL_ENVELOPE] [nvarchar](255) NULL,
	[CO_BARRA_CONTRACAPA_DIA1] [nvarchar](255) NULL,
	[CO_BARRA_CONTRACAPA_DIA2] [nvarchar](255) NULL,
	[CO_BARRA_RESPOSTA_DIA1] [nvarchar](255) NULL,
	[CO_BARRA_RESPOSTA_DIA2] [nvarchar](255) NULL,
	[CO_BARRA_REDACAO] [nvarchar](255) NULL,
	[CO_BARRA_LISTAPRESENCA_DIA1] [nvarchar](255) NULL,
	[CO_BARRA_LISTAPRESENCA_DIA2] [nvarchar](255) NULL,
	[CO_BARRA_RASCUNHO] [nvarchar](255) NULL,
	[CO_BARRA_QSE] [nvarchar](255) NULL,
	[CO_BARRA_BIOMETRIA_DIA1] [nvarchar](255) NULL,
	[CO_BARRA_BIOMETRIA_DIA2] [nvarchar](255) NULL,
	[CO_BARRA_PACOTE_DIA1] [nvarchar](255) NULL,
	[CO_BARRA_PACOTE_DIA2] [nvarchar](255) NULL,
	[CO_JUSTIFICATIVA] [nvarchar](255) NULL,
	[TP_IMPRIMIR] [nvarchar](255) NULL,
	[NU_DIA_PROVA] [nvarchar](255) NULL,
	[IN_SABATISTA] [nvarchar](255) NULL,
	[IN_ATENDIMENTO_ESPECIFICO] [nvarchar](255) NULL,
	[IN_ATENDIMENTO_ESPECIALIZADO] [nvarchar](255) NULL,
	[IN_RECURSO] [nvarchar](255) NULL,
	[IN_TEMPO_ADICIONAL] [nvarchar](255) NULL,
	[TP_ENSALAMENTO] [nvarchar](255) NULL,
	[DT_APLICACAO_DIA1] [nvarchar](255) NULL,
	[DT_APLICACAO_DIA2] [nvarchar](255) NULL,
	[NU_PARTICIPANTES] [nvarchar](255) NULL,
	[NU_PROVAS] [nvarchar](255) NULL,
	[ID_MALOTE_DIA1] [nvarchar](255) NULL,
	[ID_MALOTE_DIA2] [nvarchar](255) NULL,
	[NU_CDL] [nvarchar](255) NULL,
	[IN_RESERVA] [nvarchar](255) NULL,
	[NO_ARQUIVO_REFERENCIA] [nvarchar](255) NULL

)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO









--###########################################

CREATE EXTERNAL TABLE [dbo].[XXXXXX]
(	
)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO


