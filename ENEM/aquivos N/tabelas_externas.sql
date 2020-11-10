
CREATE EXTERNAL TABLE [dbo].[EXT_CORRECOES_CORRECAO]
(
	[id] [int] NOT NULL,
	[token_auxiliar1] [nvarchar](10) NULL,
	[token_auxiliar2] [nvarchar](10) NULL,
	[data_inicio] [datetime2](7) NULL,
	[data_termino] [datetime2](7) NULL,
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
	[id_auxiliar1] [int] NULL,
	[id_auxiliar2] [int] NULL,
	[id_correcao_situacao] [int] NULL,
	[id_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[id_status] [int] NOT NULL,
	[tipo_auditoria_id] [int] NULL,
	[id_tipo_correcao] [int] NOT NULL,
	[redacao_id] [int] NOT NULL
)
WITH (
DATA_SOURCE = [DTS_Correcao],SCHEMA_NAME = N'dbo',OBJECT_NAME = N'CORRECOES_CORRECAO')
GO






CREATE EXTERNAL TABLE [dbo].[EXT_CORRECOES_REDACAO]
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
DATA_SOURCE = [DTS_Correcao],SCHEMA_NAME = N'dbo',OBJECT_NAME = N'correcoes_redacao')
GO


/****** Object:  Table [dbo].[correcoes_analise]    Script Date: 10/20/2020 11:52:40 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE EXTERNAL TABLE [dbo].[EXT_CORRECOES_ANALISE]
(
	[id] [int] NOT NULL,
	[data_inicio_A] [datetime2](7) NOT NULL,
	[data_inicio_B] [datetime2](7) NULL,
	[data_termino_A] [datetime2](7) NOT NULL,
	[data_termino_B] [datetime2](7) NULL,
	[nota_final_A] [numeric](10, 2) NOT NULL,
	[nota_final_B] [numeric](10, 2) NULL,
	[situacao_nota_final] [int] NULL,
	[diferenca_competencia1] [numeric](10, 2) NULL,
	[situacao_competencia1] [int] NULL,
	[diferenca_competencia2] [numeric](10, 2) NULL,
	[situacao_competencia2] [int] NULL,
	[diferenca_competencia3] [numeric](10, 2) NULL,
	[situacao_competencia3] [int] NULL,
	[diferenca_competencia4] [numeric](10, 2) NULL,
	[situacao_competencia4] [int] NULL,
	[diferenca_competencia5] [numeric](10, 2) NULL,
	[situacao_competencia5] [int] NULL,
	[diferenca_nota_final] [numeric](10, 2) NULL,
	[id_auxiliar1_A] [int] NULL,
	[id_auxiliar2_A] [int] NULL,
	[id_auxiliar1_B] [int] NULL,
	[id_auxiliar2_B] [int] NULL,
	[diferenca_situacao] [int] NULL,
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
	[redacao_id] [int] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL
)
WITH (
DATA_SOURCE = [DTS_Correcao],SCHEMA_NAME = N'dbo',OBJECT_NAME = N'correcoes_analise')
GO

CREATE EXTERNAL TABLE [dbo].[EXT_PROJETO_PROJETO]
(	[id] [int]  NOT NULL,
	[descricao] [nvarchar](255) NOT NULL,
	[max_correcoes_dia] [int] NOT NULL,
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
DATA_SOURCE = [DTS_Correcao],SCHEMA_NAME = N'dbo',OBJECT_NAME = N'projeto_projeto')
GO

--######################################################
CREATE EXTERNAL TABLE[dbo].[EXT_CORRECOES_CORRETOR](
	[id] [int] NOT NULL,
	[max_correcoes_dia] [int] NOT NULL,
	[pode_corrigir_1] [bit] NOT NULL,
	[pode_corrigir_2] [bit] NOT NULL,
	[pode_corrigir_3] [bit] NOT NULL,
	[nota_corretor] [numeric](10, 2) NULL,
	[tipo_cota] [nvarchar](1) NOT NULL,
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
DATA_SOURCE = [DTS_Correcao],SCHEMA_NAME = N'dbo',OBJECT_NAME = N'correcoes_corretor')
GO



CREATE EXTERNAL TABLE  [dbo].[EXT_AUTH_USER](
	[id] [int]  NOT NULL,
	[is_superuser] [bit] NOT NULL,
	[username] [nvarchar](150) NOT NULL,
	[last_name] [nvarchar](150) NOT NULL,
	[email] [nvarchar](254) NOT NULL,
	[is_staff] [bit] NOT NULL,
	[is_active] [bit] NOT NULL,
	[date_joined] [datetime2](7) NOT NULL
)
WITH (
DATA_SOURCE = [DTS_Correcao],SCHEMA_NAME = N'dbo',OBJECT_NAME = N'auth_user')
GO


/****** Object:  Table [dbo].[inep_n02_local]    Script Date: 10/22/2020 5:18:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE EXTERNAL TABLE [dbo].[EXT_INEP_N02]
(
	[CO_PROJETO] [nvarchar](255) NULL,
	[TP_ORIGEM] [nvarchar](255) NULL,
	[CO_INSCRICAO] [nvarchar](255) NULL,
	[NO_INSCRITO] [nvarchar](255) NULL,
	[NO_SOCIAL] [nvarchar](255) NULL,
	[NU_CPF] [nvarchar](255) NULL,
	[NU_RG] [nvarchar](255) NULL,
	[DT_NASCIMENTO] [nvarchar](255) NULL,
	[SG_UF_PROVA] [nvarchar](255) NULL,
	[CO_MUNICIPIO_PROVA] [nvarchar](255) NULL,
	[NO_MUNICIPIO_PROVA] [nvarchar](255) NULL,
	[CO_BARRA_REDACAO] [nvarchar](255) NULL
)
WITH (DATA_SOURCE = [DTS_Correcao],SCHEMA_NAME = N'dbo',OBJECT_NAME = N'inep_n02_local')
GO


CREATE EXTERNAL TABLE [dbo].[EXT_CORRECOES_SITUACAO]
(
	[id] [int] NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[sigla] [nvarchar](10) NULL
)
WITH (DATA_SOURCE = [DTS_Correcao],SCHEMA_NAME = N'dbo',OBJECT_NAME = N'correcoes_situacao')
GO













--###########################################
/*
CREATE EXTERNAL TABLE [dbo].[XXXXXX]
(	
)
WITH (
DATA_SOURCE = [DTS_Correcao])
GO

*/
