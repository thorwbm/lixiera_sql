/****** Object:  Table [dbo].[inep_n02]    Script Date: 14/10/2019 09:24:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
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


