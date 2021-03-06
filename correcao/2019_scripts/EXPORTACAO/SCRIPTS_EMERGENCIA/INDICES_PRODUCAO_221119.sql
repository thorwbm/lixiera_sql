/****** Object:  Table [dbo].[alerta_alerta]    Script Date: 22/11/2019 11:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alerta_alerta](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[excluido_em] [datetime2](7) NULL,
	[id_tipo] [int] NOT NULL,
	[id_usuario] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[alerta_parametro]    Script Date: 22/11/2019 11:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alerta_parametro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [nvarchar](200) NOT NULL,
	[valor_padrao] [nvarchar](4000) NULL,
	[configuravel] [bit] NOT NULL,
	[descricao] [nvarchar](255) NULL,
	[_valor] [nvarchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[alerta_tipo]    Script Date: 22/11/2019 11:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[alerta_tipo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [nvarchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_group]    Script Date: 22/11/2019 11:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](80) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_group_permissions]    Script Date: 22/11/2019 11:50:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group_permissions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[group_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_group_permissions_group_id_permission_id_0cd325b0_uniq] UNIQUE NONCLUSTERED 
(
	[group_id] ASC,
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_permission]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[content_type_id] [int] NOT NULL,
	[codename] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_permission_content_type_id_codename_01ab375a_uniq] UNIQUE NONCLUSTERED 
(
	[content_type_id] ASC,
	[codename] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[last_login] [datetime2](7) NULL,
	[is_superuser] [bit] NOT NULL,
	[username] [nvarchar](150) NOT NULL,
	[first_name] [nvarchar](30) NOT NULL,
	[last_name] [nvarchar](150) NOT NULL,
	[email] [nvarchar](254) NOT NULL,
	[is_staff] [bit] NOT NULL,
	[is_active] [bit] NOT NULL,
	[date_joined] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_user_username_6821ab7c_uniq] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user_groups]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user_groups](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[group_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_user_groups_user_id_group_id_94350c0c_uniq] UNIQUE NONCLUSTERED 
(
	[user_id] ASC,
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user_user_permissions]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user_user_permissions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [auth_user_user_permissions_user_id_permission_id_14a6b632_uniq] UNIQUE NONCLUSTERED 
(
	[user_id] ASC,
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[avisos_aviso]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[avisos_aviso](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](max) NOT NULL,
	[titulo] [nvarchar](4000) NULL,
	[icone] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[data_inicio] [datetime2](7) NOT NULL,
	[data_termino] [datetime2](7) NULL,
	[id_hierarquia] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[avisos_avisousuario]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[avisos_avisousuario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data_leitura] [datetime2](7) NULL,
	[id_aviso] [int] NOT NULL,
	[id_usuario] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[banca_pcd]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[banca_pcd](
	[co_inscricao] [varchar](50) NULL,
	[banca] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chamados_categoria]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chamados_categoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chamados_chamado]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chamados_chamado](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nivel_atual] [int] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[resolvido_em] [datetime2](7) NULL,
	[autor_id] [int] NOT NULL,
	[correcao_id] [int] NOT NULL,
	[responsavel_atual] [int] NULL,
	[responsavel_padrao] [int] NULL,
	[status_id] [int] NOT NULL,
	[tipo_id] [int] NOT NULL,
	[atualizado_por] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chamados_responsabilidade]    Script Date: 22/11/2019 11:50:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chamados_responsabilidade](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nivel] [int] NOT NULL,
	[marcacoes] [nvarchar](max) NULL,
	[pergunta] [nvarchar](max) NULL,
	[resposta] [nvarchar](max) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[resolvido_em] [datetime2](7) NULL,
	[responsavel_id] [int] NULL,
	[autor_id] [int] NOT NULL,
	[status_id] [int] NOT NULL,
	[chamado_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [chamados_responsabilidade_chamado_id_nivel_status_id_77663786_uniq] UNIQUE NONCLUSTERED 
(
	[chamado_id] ASC,
	[nivel] ASC,
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chamados_responsabilidadestatus]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chamados_responsabilidadestatus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chamados_status]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chamados_status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[icone] [nvarchar](50) NOT NULL,
	[classe] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chamados_tipo]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chamados_tipo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[pode_transferir_para_time_tecnico] [bit] NOT NULL,
	[tipo_alocacao_id] [int] NULL,
	[tipo_hierarquia_competente_id] [smallint] NULL,
	[categoria_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chamados_tipoalocacao]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chamados_tipoalocacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[chats_mensagem]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chats_mensagem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[mensagem] [nvarchar](max) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[id_destinatario] [int] NOT NULL,
	[id_remetente] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[core_cidade]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_cidade](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [nvarchar](255) NOT NULL,
	[codigo_ibge] [nvarchar](10) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[core_controlehorarioambiente]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_controlehorarioambiente](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [nvarchar](50) NOT NULL,
	[data_inicio] [datetime2](7) NOT NULL,
	[data_termino] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[core_estado]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_estado](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sigla] [nvarchar](2) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[core_feature]    Script Date: 22/11/2019 11:50:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_feature](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[descricao] [nvarchar](255) NULL,
	[ativo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[core_mensagem]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_mensagem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[conteudo_padrao] [nvarchar](4000) NULL,
	[conteudo] [nvarchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[core_notificacao]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_notificacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](max) NOT NULL,
	[icone] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[core_notificacaogrupo]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_notificacaogrupo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data_leitura] [datetime2](7) NULL,
	[id_grupo] [int] NOT NULL,
	[id_notificacao] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[core_parametros]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[core_parametros](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [nvarchar](50) NOT NULL,
	[descricao] [nvarchar](4000) NULL,
	[valor] [nvarchar](4000) NULL,
	[valor_padrao] [nvarchar](4000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [core_parametros_nome_6854bbec_uniq] UNIQUE NONCLUSTERED 
(
	[nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_analise]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_analise](
	[id] [int] IDENTITY(1,1) NOT NULL,
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
	[criado_em] [datetime2](7) NOT NULL,
 CONSTRAINT [PK__correcoe__3213E83FF9615D0B] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_conclusao_analise]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_conclusao_analise](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[conclusao_analise] [nvarchar](50) NULL,
	[discrepou] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_contador]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_contador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data_inicio_correcao] [datetime2](7) NULL,
	[data_validade_correcao] [datetime2](7) NULL,
	[data_fim_correcao] [datetime2](7) NULL,
	[data_buffer] [int] NULL,
	[id_corretor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_contador_id_corretor_d51d7122_uniq] UNIQUE NONCLUSTERED 
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_correcao]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_correcao](
	[id] [int] IDENTITY(1,1) NOT NULL,
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
	[redacao_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_correcao_redacao_id_id_corretor_id_tipo_correcao_119e919f_uniq] UNIQUE NONCLUSTERED 
(
	[redacao_id] ASC,
	[id_corretor] ASC,
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_correcaomoda]    Script Date: 22/11/2019 11:50:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_correcaomoda](
	[id] [int] IDENTITY(1,1) NOT NULL,
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
	[id_tipo_correcao] [int] NOT NULL,
	[redacao_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_correcaomoda_redacao_id_id_corretor_id_tipo_correcao_b77781e1_uniq] UNIQUE NONCLUSTERED 
(
	[redacao_id] ASC,
	[id_corretor] ASC,
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_correcaoouro]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_correcaoouro](
	[id] [int] IDENTITY(1,1) NOT NULL,
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
	[id_tipo_correcao] [int] NOT NULL,
	[redacao_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_correcaoouro_redacao_id_id_corretor_id_tipo_correcao_ab843771_uniq] UNIQUE NONCLUSTERED 
(
	[redacao_id] ASC,
	[id_corretor] ASC,
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_corretor]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_corretor](
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
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_corretor_indicadores]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_corretor_indicadores](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_hierarquia] [int] NOT NULL,
	[dsp] [numeric](4, 2) NOT NULL,
	[data_calculo] [date] NOT NULL,
	[nome] [nvarchar](255) NOT NULL,
	[indice] [nvarchar](50) NOT NULL,
	[tempo_correcao] [int] NULL,
	[ouros_corrigidas] [int] NULL,
	[modas_corrigidas] [int] NULL,
	[discrepancias_ouro] [int] NULL,
	[aproveitamentos_com_disc] [int] NULL,
	[aproveitamentos_sem_disc] [int] NULL,
	[total_correcoes] [int] NULL,
	[tempo_medio_correcao] [numeric](10, 2) NULL,
	[taxa_discrepancia_ouro] [numeric](10, 2) NULL,
	[taxa_aproveitamento] [numeric](10, 2) NULL,
	[taxa_aproveitamento_coletivo] [numeric](10, 2) NULL,
	[flg_dado_atual] [bit] NULL,
	[desempenho_ouro] [numeric](10, 2) NULL,
	[desempenho_moda] [numeric](10, 2) NULL,
	[projeto_id] [int] NOT NULL,
	[usuario_id] [int] NULL,
	[id_usuario_responsavel] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_entrega]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_entrega](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tabela] [nvarchar](30) NOT NULL,
	[codigo_imagem] [int] NULL,
	[codigo_projeto] [int] NULL,
	[inscricao] [nvarchar](50) NULL,
	[id_avaliador_ava1] [int] NULL,
	[nome_avaliador_ava1] [nvarchar](255) NULL,
	[cpf_avaliador_ava1] [nvarchar](14) NULL,
	[comp1_ava1] [int] NULL,
	[comp2_ava1] [int] NULL,
	[comp3_ava1] [int] NULL,
	[comp4_ava1] [int] NULL,
	[comp5_ava1] [int] NULL,
	[nota_comp1_ava1] [numeric](10, 2) NULL,
	[nota_comp2_ava1] [numeric](10, 2) NULL,
	[nota_comp3_ava1] [numeric](10, 2) NULL,
	[nota_comp4_ava1] [numeric](10, 2) NULL,
	[nota_comp5_ava1] [numeric](10, 2) NULL,
	[nota_final_ava1] [numeric](10, 2) NULL,
	[id_situacao_ava1] [int] NULL,
	[sigla_situacao_ava1] [nvarchar](10) NULL,
	[fere_dh_ava1] [int] NULL,
	[data_inicio_ava1] [nvarchar](27) NULL,
	[data_termino_ava1] [nvarchar](27) NULL,
	[duracao_ava1] [int] NULL,
	[link_imagem_av1] [nvarchar](255) NULL,
	[id_avaliador_ava2] [int] NULL,
	[nome_avaliador_ava2] [nvarchar](255) NULL,
	[cpf_avaliador_ava2] [nvarchar](14) NULL,
	[comp1_ava2] [int] NULL,
	[comp2_ava2] [int] NULL,
	[comp3_ava2] [int] NULL,
	[comp4_ava2] [int] NULL,
	[comp5_ava2] [int] NULL,
	[nota_comp1_ava2] [numeric](10, 2) NULL,
	[nota_comp2_ava2] [numeric](10, 2) NULL,
	[nota_comp3_ava2] [numeric](10, 2) NULL,
	[nota_comp4_ava2] [numeric](10, 2) NULL,
	[nota_comp5_ava2] [numeric](10, 2) NULL,
	[nota_final_ava2] [numeric](10, 2) NULL,
	[id_situacao_ava2] [int] NULL,
	[sigla_situacao_ava2] [nvarchar](10) NULL,
	[fere_dh_ava2] [int] NULL,
	[data_inicio_ava2] [nvarchar](27) NULL,
	[data_termino_ava2] [nvarchar](27) NULL,
	[duracao_ava2] [int] NULL,
	[link_imagem_av2] [nvarchar](255) NULL,
	[id_avaliador_ava3] [int] NULL,
	[nome_avaliador_ava3] [nvarchar](255) NULL,
	[cpf_avaliador_ava3] [nvarchar](14) NULL,
	[comp1_ava3] [int] NULL,
	[comp2_ava3] [int] NULL,
	[comp3_ava3] [int] NULL,
	[comp4_ava3] [int] NULL,
	[comp5_ava3] [int] NULL,
	[nota_comp1_ava3] [numeric](10, 2) NULL,
	[nota_comp2_ava3] [numeric](10, 2) NULL,
	[nota_comp3_ava3] [numeric](10, 2) NULL,
	[nota_comp4_ava3] [numeric](10, 2) NULL,
	[nota_comp5_ava3] [numeric](10, 2) NULL,
	[nota_final_ava3] [numeric](10, 2) NULL,
	[id_situacao_ava3] [int] NULL,
	[sigla_situacao_ava3] [nvarchar](10) NULL,
	[fere_dh_ava3] [int] NULL,
	[data_inicio_ava3] [nvarchar](27) NULL,
	[data_termino_ava3] [nvarchar](27) NULL,
	[duracao_ava3] [int] NULL,
	[link_imagem_av3] [nvarchar](255) NULL,
	[id_avaliador_ava4] [int] NULL,
	[nome_avaliador_ava4] [nvarchar](255) NULL,
	[cpf_avaliador_ava4] [nvarchar](14) NULL,
	[comp1_ava4] [int] NULL,
	[comp2_ava4] [int] NULL,
	[comp3_ava4] [int] NULL,
	[comp4_ava4] [int] NULL,
	[comp5_ava4] [int] NULL,
	[nota_comp1_ava4] [numeric](10, 2) NULL,
	[nota_comp2_ava4] [numeric](10, 2) NULL,
	[nota_comp3_ava4] [numeric](10, 2) NULL,
	[nota_comp4_ava4] [numeric](10, 2) NULL,
	[nota_comp5_ava4] [numeric](10, 2) NULL,
	[nota_final_ava4] [numeric](10, 2) NULL,
	[id_situacao_ava4] [int] NULL,
	[sigla_situacao_ava4] [nvarchar](10) NULL,
	[fere_dh_ava4] [int] NULL,
	[data_inicio_ava4] [nvarchar](27) NULL,
	[data_termino_ava4] [nvarchar](27) NULL,
	[duracao_ava4] [int] NULL,
	[link_imagem_av4] [nvarchar](255) NULL,
	[id_avaliador_avaa] [int] NULL,
	[nome_avaliador_avaa] [nvarchar](255) NULL,
	[cpf_avaliador_avaa] [nvarchar](14) NULL,
	[comp1_avaa] [int] NULL,
	[comp2_avaa] [int] NULL,
	[comp3_avaa] [int] NULL,
	[comp4_avaa] [int] NULL,
	[comp5_avaa] [int] NULL,
	[nota_comp1_avaa] [numeric](10, 2) NULL,
	[nota_comp2_avaa] [numeric](10, 2) NULL,
	[nota_comp3_avaa] [numeric](10, 2) NULL,
	[nota_comp4_avaa] [numeric](10, 2) NULL,
	[nota_comp5_avaa] [numeric](10, 2) NULL,
	[nota_final_avaa] [numeric](10, 2) NULL,
	[id_situacao_avaa] [int] NULL,
	[sigla_situacao_avaa] [nvarchar](10) NULL,
	[data_inicio_avaa] [nvarchar](27) NULL,
	[data_termino_avaa] [nvarchar](27) NULL,
	[duracao_avaa] [int] NULL,
	[link_imagem_ava] [nvarchar](255) NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NULL,
	[id_correcao_situacao] [int] NULL,
	[nota_final] [numeric](10, 2) NULL,
	[fere_dh_final] [int] NULL,
	[data_termino] [nvarchar](27) NULL,
	[co_projeto] [nvarchar](7) NULL,
	[sg_uf_prova] [nvarchar](2) NULL,
	[id_item_atendimento] [int] NULL,
	[nota_comp1] [numeric](15, 6) NULL,
	[nota_comp2] [numeric](15, 6) NULL,
	[nota_comp3] [numeric](15, 6) NULL,
	[nota_comp4] [numeric](15, 6) NULL,
	[nota_comp5] [numeric](15, 6) NULL,
	[co_justificativa] [int] NULL,
	[fere_dh_avaa] [int] NULL,
	[nu_cpf] [nvarchar](11) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_evento]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_evento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_fila1]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_fila1](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[id_correcao] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[redacao_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_fila2]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_fila2](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[id_correcao] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[redacao_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_fila3]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_fila3](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[id_correcao] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[redacao_id] [int] NOT NULL,
	[consistido] [bit] NULL,
	[consistido_auditoria] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_fila4]    Script Date: 22/11/2019 11:50:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_fila4](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[id_correcao] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[redacao_id] [int] NOT NULL,
	[consistido] [bit] NULL,
	[consistido_auditoria] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_filaauditoria]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_filaauditoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[pendente] [bit] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[id_correcao] [int] NULL,
	[id_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[tipo_id] [int] NULL,
	[redacao_id] [int] NOT NULL,
	[consistido] [bit] NULL,
	[consistido_auditoria] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_filaordem]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_filaordem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[lista] [nvarchar](50) NULL,
	[ordem] [nvarchar](10) NULL,
	[id_projeto] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_filaouro]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_filaouro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[posicao] [int] NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[id_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[redacao_id] [int] NULL,
	[alcance] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_filaouro_redacao_id_a38d830f_uniq] UNIQUE NONCLUSTERED 
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_filapessoal]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_filapessoal](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[atual] [int] NULL,
	[id_correcao] [int] NULL,
	[id_corretor] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[id_tipo_correcao] [int] NULL,
	[redacao_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_filapessoal_redacao_id_id_corretor_35e12fc2_uniq] UNIQUE NONCLUSTERED 
(
	[redacao_id] ASC,
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_gabarito]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_gabarito](
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[nota_final] [numeric](10, 2) NOT NULL,
	[id_competencia1] [int] NULL,
	[id_competencia2] [int] NULL,
	[id_competencia3] [int] NULL,
	[id_competencia4] [int] NULL,
	[id_competencia5] [int] NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[id_correcao_situacao] [int] NOT NULL,
	[redacao_id] [int] NOT NULL,
 CONSTRAINT [correcoes_gabarito_redacao_id_dba65b81_pk] PRIMARY KEY CLUSTERED 
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_gabarito_redacao_id_dba65b81_uniq] UNIQUE NONCLUSTERED 
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_graficocorrecoes]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_graficocorrecoes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data] [nvarchar](max) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[id_corretor] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_grupocorretor]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_grupocorretor](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[grupo] [nvarchar](50) NOT NULL,
	[proficiencia] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_historicocorrecao]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_historicocorrecao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[dt_historico] [datetime2](7) NOT NULL,
	[data] [nvarchar](max) NULL,
	[correcao_id] [int] NOT NULL,
	[evento_id] [int] NOT NULL,
	[usuario_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_motivoredacao]    Script Date: 22/11/2019 11:50:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_motivoredacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](100) NOT NULL,
	[tipo_id] [nvarchar](50) NOT NULL,
	[redacao_substituida_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_origemredacaoouro]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_origemredacaoouro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_pendenteanalise]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_pendenteanalise](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[erro] [nvarchar](500) NULL,
	[id_correcao] [int] NULL,
	[id_projeto] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[id_tipo_correcao] [int] NULL,
	[redacao_id] [int] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_reciclagem]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_reciclagem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[excluido_em] [datetime2](7) NULL,
	[id_corretor] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_redacao]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_redacao](
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
	[faixa_plano_amostral] [nvarchar](100) NULL,
 CONSTRAINT [correcoes_redacao_id_7a41dfbe_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_redacao_co_barra_redacao_motivo_id_a35d81b5_uniq] UNIQUE NONCLUSTERED 
(
	[co_barra_redacao] ASC,
	[motivo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [correcoes_redacao_co_inscricao_motivo_id_c62c307b_uniq] UNIQUE NONCLUSTERED 
(
	[co_inscricao] ASC,
	[motivo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_redacaobranco]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_redacaobranco](
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[id_redacao_situacao] [int] NOT NULL,
	[id_projeto] [int] NULL,
 CONSTRAINT [correcoes_redacaobranco_id_31c64748_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_redacaoinsuficiente]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_redacaoinsuficiente](
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[id_redacao_situacao] [int] NOT NULL,
	[id_projeto] [int] NULL,
 CONSTRAINT [correcoes_redacaoinsuficiente_id_49a23625_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_redacaomoda]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_redacaomoda](
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[id_competencia1] [int] NULL,
	[id_competencia2] [int] NULL,
	[id_competencia3] [int] NULL,
	[id_competencia4] [int] NULL,
	[id_competencia5] [int] NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[id_redacao_situacao] [int] NOT NULL,
	[id_projeto] [int] NULL,
 CONSTRAINT [correcoes_redacaomoda_id_2f9910e0_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_redacaoouro]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_redacaoouro](
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[id_competencia1] [int] NULL,
	[id_competencia2] [int] NULL,
	[id_competencia3] [int] NULL,
	[id_competencia4] [int] NULL,
	[id_competencia5] [int] NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[data_criacao] [datetime2](7) NOT NULL,
	[id_correcao_situacao] [int] NOT NULL,
	[id_origem] [int] NOT NULL,
	[id_projeto] [int] NULL,
	[id_redacaotipo] [int] NOT NULL,
	[distribuido_em] [datetime2](7) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[co_barra_redacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_redacaosituacao]    Script Date: 22/11/2019 11:50:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_redacaosituacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_redacaotipo]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_redacaotipo](
	[id] [int] NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_situacao]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_situacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[sigla] [nvarchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_status]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_statuscorretor]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_statuscorretor](
	[id] [int] NOT NULL,
	[descricao] [nvarchar](255) NOT NULL,
	[classe] [nvarchar](255) NOT NULL,
	[pedir_motivo_para_troca] [bit] NOT NULL,
	[cor] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_statusredacao]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_statusredacao](
	[id] [int] NOT NULL,
	[descricao] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_suspensao]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_suspensao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[excluido_em] [datetime2](7) NULL,
	[id_corretor] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_tipo]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_tipo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](100) NOT NULL,
	[flag_soberano] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_tipoauditoria]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_tipoauditoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[co_tipo_auditoria_n70] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_tipoindicador]    Script Date: 22/11/2019 11:50:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_tipoindicador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](255) NOT NULL,
	[sigla] [nvarchar](50) NOT NULL,
	[id_tipo_periodicidade_indicador] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_tipomotivoredacao]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_tipomotivoredacao](
	[id] [nvarchar](50) NOT NULL,
	[descricao] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_tipoperiodicidadeindicador]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_tipoperiodicidadeindicador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[correcoes_triagemfea]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[correcoes_triagemfea](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[atualizado_em] [datetime2](7) NOT NULL,
	[parecer] [bit] NULL,
	[atualizado_por_id] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[destinado_a_id] [int] NOT NULL,
	[redacao_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_admin_log]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_admin_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[action_time] [datetime2](7) NOT NULL,
	[object_id] [nvarchar](max) NULL,
	[object_repr] [nvarchar](200) NOT NULL,
	[action_flag] [smallint] NOT NULL,
	[change_message] [nvarchar](max) NOT NULL,
	[content_type_id] [int] NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_content_type]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_content_type](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[app_label] [nvarchar](100) NOT NULL,
	[model] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [django_content_type_app_label_model_76bd3d3b_uniq] UNIQUE NONCLUSTERED 
(
	[app_label] ASC,
	[model] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_cron_cronjoblog]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_cron_cronjoblog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](64) NOT NULL,
	[start_time] [datetime2](7) NOT NULL,
	[end_time] [datetime2](7) NOT NULL,
	[is_success] [bit] NOT NULL,
	[message] [nvarchar](max) NOT NULL,
	[ran_at_time] [time](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_migrations]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_migrations](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[app] [nvarchar](255) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[applied] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_session]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_session](
	[session_key] [nvarchar](40) NOT NULL,
	[session_data] [nvarchar](max) NOT NULL,
	[expire_date] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[session_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[external_auth_login]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[external_auth_login](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario] [nvarchar](1000) NOT NULL,
	[descricao] [nvarchar](1000) NULL,
	[status] [bit] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[ip] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[external_auth_segundofatorautenticacaoerro]    Script Date: 22/11/2019 11:50:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[external_auth_segundofatorautenticacaoerro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[usuario] [nvarchar](1000) NOT NULL,
	[error] [nvarchar](4000) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[external_auth_token]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[external_auth_token](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[token] [nvarchar](max) NOT NULL,
	[codigo_verificacao] [nvarchar](6) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[auxiliares_validados] [bit] NOT NULL,
	[desativado_em] [datetime2](7) NULL,
	[usuario_id] [int] NOT NULL,
	[ip] [nvarchar](1000) NULL,
	[validado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[inep_inscricao]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[inep_inscricao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [nvarchar](500) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[cpf] [nvarchar](11) NOT NULL,
	[uf_prova] [nvarchar](2) NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_municipio_prova] [nvarchar](7) NOT NULL,
	[co_projeto] [nvarchar](7) NOT NULL,
	[no_municipio_prova] [nvarchar](150) NOT NULL,
	[id_item_atendimento] [int] NULL,
	[projeto_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_alerta_alerta]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_alerta_alerta](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[excluido_em] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[id_tipo] [int] NULL,
	[id_usuario] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_alerta_tipo]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_alerta_tipo](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[nome] [nvarchar](1000) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_auth_group]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_auth_group](
	[id] [int] NOT NULL,
	[name] [nvarchar](80) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_auth_group_permissions]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_auth_group_permissions](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[group_id] [int] NULL,
	[history_user_id] [int] NULL,
	[permission_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_auth_permission]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_auth_permission](
	[id] [int] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[codename] [nvarchar](100) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[content_type_id] [int] NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_auth_user]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_auth_user](
	[id] [int] NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[last_login] [datetime2](7) NULL,
	[is_superuser] [bit] NOT NULL,
	[username] [nvarchar](150) NOT NULL,
	[first_name] [nvarchar](30) NOT NULL,
	[last_name] [nvarchar](150) NOT NULL,
	[email] [nvarchar](254) NOT NULL,
	[is_staff] [bit] NOT NULL,
	[is_active] [bit] NOT NULL,
	[date_joined] [datetime2](7) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_auth_user_groups]    Script Date: 22/11/2019 11:50:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_auth_user_groups](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[group_id] [int] NULL,
	[history_user_id] [int] NULL,
	[user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_auth_user_user_permissions]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_auth_user_user_permissions](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[permission_id] [int] NULL,
	[user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_avisos_aviso]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_avisos_aviso](
	[id] [int] NOT NULL,
	[descricao] [nvarchar](max) NOT NULL,
	[titulo] [nvarchar](4000) NULL,
	[icone] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[data_inicio] [datetime2](7) NOT NULL,
	[data_termino] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_hierarquia] [int] NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_avisos_avisousuario]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_avisos_avisousuario](
	[id] [int] NOT NULL,
	[data_leitura] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_aviso] [int] NULL,
	[history_user_id] [int] NULL,
	[id_usuario] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_chamados_chamado]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_chamados_chamado](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[nivel_atual] [int] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[resolvido_em] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[autor_id] [int] NULL,
	[correcao_id] [int] NULL,
	[responsavel_atual] [int] NULL,
	[responsavel_padrao] [int] NULL,
	[history_user_id] [int] NULL,
	[status_id] [int] NULL,
	[tipo_id] [int] NULL,
	[atualizado_por] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_chamados_responsabilidade]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_chamados_responsabilidade](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[nivel] [int] NOT NULL,
	[marcacoes] [nvarchar](max) NULL,
	[pergunta] [nvarchar](max) NULL,
	[resposta] [nvarchar](max) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[resolvido_em] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[responsavel_id] [int] NULL,
	[autor_id] [int] NULL,
	[history_user_id] [int] NULL,
	[status_id] [int] NULL,
	[chamado_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_chamados_responsabilidadestatus]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_chamados_responsabilidadestatus](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[name] [nvarchar](50) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_chats_mensagem]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_chats_mensagem](
	[id] [int] NOT NULL,
	[mensagem] [nvarchar](max) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_destinatario] [int] NULL,
	[history_user_id] [int] NULL,
	[id_remetente] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_core_controlehorarioambiente]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_core_controlehorarioambiente](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[nome] [nvarchar](50) NOT NULL,
	[data_inicio] [datetime2](7) NOT NULL,
	[data_termino] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_core_feature]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_core_feature](
	[id] [int] NOT NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[descricao] [nvarchar](255) NULL,
	[ativo] [bit] NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_core_mensagem]    Script Date: 22/11/2019 11:50:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_core_mensagem](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[conteudo] [nvarchar](4000) NULL,
	[conteudo_padrao] [nvarchar](4000) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_core_notificacao]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_core_notificacao](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[descricao] [nvarchar](max) NOT NULL,
	[icone] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_core_notificacaogrupo]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_core_notificacaogrupo](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[data_leitura] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_grupo] [int] NULL,
	[history_user_id] [int] NULL,
	[id_notificacao] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_core_parametros]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_core_parametros](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[nome] [nvarchar](50) NOT NULL,
	[descricao] [nvarchar](4000) NULL,
	[valor] [nvarchar](4000) NULL,
	[valor_padrao] [nvarchar](4000) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_analise]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_analise](
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
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao_A] [int] NULL,
	[id_correcao_B] [int] NULL,
	[id_correcao_situacao_A] [int] NULL,
	[id_correcao_situacao_B] [int] NULL,
	[id_corretor_A] [int] NULL,
	[id_corretor_B] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
	[criado_em] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_contador]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_contador](
	[id] [int] NOT NULL,
	[data_inicio_correcao] [datetime2](7) NULL,
	[data_validade_correcao] [datetime2](7) NULL,
	[data_fim_correcao] [datetime2](7) NULL,
	[data_buffer] [int] NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_correcao]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_correcao](
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
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[atualizado_por] [int] NULL,
	[id_auxiliar1] [int] NULL,
	[id_auxiliar2] [int] NULL,
	[id_correcao_situacao] [int] NULL,
	[id_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[id_status] [int] NULL,
	[tipo_auditoria_id] [int] NULL,
	[id_tipo_correcao] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_correcaomoda]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_correcaomoda](
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
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[atualizado_por] [int] NULL,
	[id_auxiliar1] [int] NULL,
	[id_auxiliar2] [int] NULL,
	[id_correcao_situacao] [int] NULL,
	[id_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[id_status] [int] NULL,
	[id_tipo_correcao] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_correcaoouro]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_correcaoouro](
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
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[atualizado_por] [int] NULL,
	[id_auxiliar1] [int] NULL,
	[id_auxiliar2] [int] NULL,
	[id_correcao_situacao] [int] NULL,
	[id_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[id_status] [int] NULL,
	[id_tipo_correcao] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_corretor]    Script Date: 22/11/2019 11:50:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_corretor](
	[max_correcoes_dia] [int] NOT NULL,
	[pode_corrigir_1] [bit] NOT NULL,
	[pode_corrigir_2] [bit] NOT NULL,
	[pode_corrigir_3] [bit] NOT NULL,
	[nota_corretor] [numeric](10, 2) NULL,
	[tipo_cota] [nvarchar](1) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[atualizado_por] [int] NULL,
	[id_grupo] [int] NULL,
	[history_user_id] [int] NULL,
	[id] [int] NULL,
	[status_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[dsp] [numeric](4, 2) NULL,
	[tempo_medio_correcao] [numeric](10, 2) NULL,
	[supervisor_em_banca] [bit] NULL,
	[pode_corrigir_4] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_corretor_indicadores]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_corretor_indicadores](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[id_hierarquia] [int] NOT NULL,
	[dsp] [numeric](4, 2) NOT NULL,
	[data_calculo] [date] NOT NULL,
	[nome] [nvarchar](255) NOT NULL,
	[indice] [nvarchar](50) NOT NULL,
	[tempo_correcao] [int] NULL,
	[ouros_corrigidas] [int] NULL,
	[modas_corrigidas] [int] NULL,
	[discrepancias_ouro] [int] NULL,
	[aproveitamentos_com_disc] [int] NULL,
	[aproveitamentos_sem_disc] [int] NULL,
	[total_correcoes] [int] NULL,
	[tempo_medio_correcao] [numeric](10, 2) NULL,
	[taxa_discrepancia_ouro] [numeric](10, 2) NULL,
	[taxa_aproveitamento] [numeric](10, 2) NULL,
	[taxa_aproveitamento_coletivo] [numeric](10, 2) NULL,
	[flg_dado_atual] [bit] NULL,
	[desempenho_ouro] [numeric](10, 2) NULL,
	[desempenho_moda] [numeric](10, 2) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[projeto_id] [int] NULL,
	[usuario_id] [int] NULL,
	[id_usuario_responsavel] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_fila1]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_fila1](
	[id] [int] NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_fila2]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_fila2](
	[id] [int] NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_fila3]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_fila3](
	[id] [int] NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
	[consistido] [bit] NULL,
	[consistido_auditoria] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_fila4]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_fila4](
	[id] [int] NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
	[consistido] [bit] NULL,
	[consistido_auditoria] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_filaauditoria]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_filaauditoria](
	[id] [int] NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[pendente] [bit] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao] [int] NULL,
	[id_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[tipo_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
	[consistido] [bit] NULL,
	[consistido_auditoria] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_filaordem]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_filaordem](
	[id] [int] NOT NULL,
	[lista] [nvarchar](50) NULL,
	[ordem] [nvarchar](10) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_filaouro]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_filaouro](
	[id] [int] NOT NULL,
	[posicao] [int] NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
	[alcance] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_filapessoal]    Script Date: 22/11/2019 11:50:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_filapessoal](
	[id] [int] NOT NULL,
	[corrigido_por] [nvarchar](255) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[atual] [int] NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao] [int] NULL,
	[id_corretor] [int] NULL,
	[id_grupo_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[id_tipo_correcao] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_gabarito]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_gabarito](
	[nota_final] [numeric](10, 2) NOT NULL,
	[id_competencia1] [int] NULL,
	[id_competencia2] [int] NULL,
	[id_competencia3] [int] NULL,
	[id_competencia4] [int] NULL,
	[id_competencia5] [int] NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao_situacao] [int] NULL,
	[history_user_id] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_historicocorrecao]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_historicocorrecao](
	[id] [int] NOT NULL,
	[dt_historico] [datetime2](7) NOT NULL,
	[data] [nvarchar](max) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[correcao_id] [int] NULL,
	[evento_id] [int] NULL,
	[history_user_id] [int] NULL,
	[usuario_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_pendenteanalise]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_pendenteanalise](
	[id] [int] NOT NULL,
	[erro] [nvarchar](500) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[id_tipo_correcao] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
	[criado_em] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_reciclagem]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_reciclagem](
	[id] [int] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[excluido_em] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_redacao]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_redacao](
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_correcao_situacao] [int] NULL,
	[history_user_id] [int] NULL,
	[id_redacao_situacao] [int] NULL,
	[id_projeto] [int] NULL,
	[id_redacaoouro] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[id_status] [int] NULL,
	[cancelado] [bit] NOT NULL,
	[justificativa_cancelamento] [nvarchar](500) NULL,
	[motivo_id] [int] NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[data_inicio] [datetime2](7) NULL,
	[data_termino] [datetime2](7) NULL,
	[faixa_plano_amostral] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_redacaobranco]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_redacaobranco](
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[id_redacao_situacao] [int] NULL,
	[id_projeto] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_redacaoinsuficiente]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_redacaoinsuficiente](
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[id_redacao_situacao] [int] NULL,
	[id_projeto] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_redacaomoda]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_redacaomoda](
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[id_competencia1] [int] NULL,
	[id_competencia2] [int] NULL,
	[id_competencia3] [int] NULL,
	[id_competencia4] [int] NULL,
	[id_competencia5] [int] NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[id_redacao_situacao] [int] NULL,
	[id_projeto] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_redacaoouro]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_redacaoouro](
	[co_inscricao] [nvarchar](50) NOT NULL,
	[link_imagem_recortada] [nvarchar](255) NOT NULL,
	[link_imagem_original] [nvarchar](255) NULL,
	[nota_final] [numeric](10, 2) NULL,
	[co_formulario] [nvarchar](2) NOT NULL,
	[id_prova] [nvarchar](1) NOT NULL,
	[id_competencia1] [int] NULL,
	[id_competencia2] [int] NULL,
	[id_competencia3] [int] NULL,
	[id_competencia4] [int] NULL,
	[id_competencia5] [int] NULL,
	[nota_competencia1] [numeric](10, 2) NULL,
	[nota_competencia2] [numeric](10, 2) NULL,
	[nota_competencia3] [numeric](10, 2) NULL,
	[nota_competencia4] [numeric](10, 2) NULL,
	[nota_competencia5] [numeric](10, 2) NULL,
	[id] [int] NOT NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[data_criacao] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[id_correcao_situacao] [int] NULL,
	[id_origem] [int] NULL,
	[id_projeto] [int] NULL,
	[id_redacaotipo] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[distribuido_em] [datetime2](7) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_suspensao]    Script Date: 22/11/2019 11:50:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_suspensao](
	[id] [int] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[excluido_em] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[id_corretor] [int] NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_correcoes_triagemfea]    Script Date: 22/11/2019 11:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_correcoes_triagemfea](
	[id] [int] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[atualizado_em] [datetime2](7) NOT NULL,
	[parecer] [bit] NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[atualizado_por_id] [int] NULL,
	[co_barra_redacao] [nvarchar](50) NOT NULL,
	[destinado_a_id] [int] NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[redacao_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_external_auth_login]    Script Date: 22/11/2019 11:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_external_auth_login](
	[id] [int] NOT NULL,
	[id_usuario] [nvarchar](1000) NOT NULL,
	[descricao] [nvarchar](1000) NULL,
	[status] [bit] NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[ip] [nvarchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_external_auth_token]    Script Date: 22/11/2019 11:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_external_auth_token](
	[id] [int] NOT NULL,
	[token] [nvarchar](max) NOT NULL,
	[codigo_verificacao] [nvarchar](6) NULL,
	[criado_em] [datetime2](7) NOT NULL,
	[auxiliares_validados] [bit] NOT NULL,
	[desativado_em] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[usuario_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[ip] [nvarchar](1000) NULL,
	[validado] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_ocorrencias_emaillote]    Script Date: 22/11/2019 11:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_ocorrencias_emaillote](
	[id] [int] NOT NULL,
	[destinatario] [nvarchar](255) NOT NULL,
	[remetente] [nvarchar](255) NOT NULL,
	[assunto] [nvarchar](255) NULL,
	[msg] [nvarchar](max) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_ocorrencias_imagemfalha]    Script Date: 22/11/2019 11:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_ocorrencias_imagemfalha](
	[id] [int] NOT NULL,
	[co_barra] [nvarchar](50) NOT NULL,
	[url_antiga] [nvarchar](255) NOT NULL,
	[url_nova] [nvarchar](255) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[lote_id] [int] NULL,
	[ocorrencia_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_ocorrencias_ocorrencia]    Script Date: 22/11/2019 11:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_ocorrencias_ocorrencia](
	[id] [int] NOT NULL,
	[data_solicitacao] [datetime2](7) NOT NULL,
	[data_resposta] [datetime2](7) NULL,
	[data_fechamento] [datetime2](7) NULL,
	[pergunta] [nvarchar](max) NULL,
	[resposta] [nvarchar](max) NULL,
	[nivel] [int] NULL,
	[dados_correcao] [nvarchar](max) NULL,
	[competencia1] [int] NULL,
	[competencia2] [int] NULL,
	[competencia3] [int] NULL,
	[competencia4] [int] NULL,
	[competencia5] [int] NULL,
	[correcao_situacao] [int] NULL,
	[img] [nvarchar](255) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[atualizado_por] [int] NULL,
	[categoria_id] [int] NULL,
	[correcao_id] [int] NULL,
	[history_user_id] [int] NULL,
	[id_projeto] [int] NULL,
	[lote_solicitado_id] [int] NULL,
	[ocorrencia_pai_id] [int] NULL,
	[situacao_id] [int] NULL,
	[status_id] [int] NULL,
	[tipo_id] [int] NULL,
	[usuario_autor_id] [int] NULL,
	[usuario_responsavel_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[ocorrencia_relacionada_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_projeto_projeto]    Script Date: 22/11/2019 11:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_projeto_projeto](
	[id] [int] NOT NULL,
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
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
	[etapa_ensino_id] [int] NULL,
	[peso_competencia] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_relatorios_mensagem]    Script Date: 22/11/2019 11:50:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_relatorios_mensagem](
	[id] [int] NOT NULL,
	[observacao] [nvarchar](max) NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[conteudo] [nvarchar](4000) NULL,
	[conteudo_padrao] [nvarchar](4000) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_status_corretor_trocastatus]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_status_corretor_trocastatus](
	[id] [int] NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[corretor_id] [int] NULL,
	[history_user_id] [int] NULL,
	[motivo_id] [int] NULL,
	[status_anterior_id] [int] NULL,
	[status_atual_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_usuarios_hierarquia]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_usuarios_hierarquia](
	[id] [int] NOT NULL,
	[descricao] [nvarchar](100) NOT NULL,
	[indice] [nvarchar](50) NOT NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[id_hierarquia_usuario_pai] [int] NULL,
	[id_tipo_hierarquia_usuario] [smallint] NULL,
	[id_usuario_responsavel] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_usuarios_mudancatime]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_usuarios_mudancatime](
	[id] [int] NOT NULL,
	[data_mudanca] [datetime2](7) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[atualizado_por] [int] NULL,
	[history_user_id] [int] NULL,
	[id_time_anterior] [int] NULL,
	[id_time_atual] [int] NULL,
	[id_usuario] [int] NULL,
	[id_coordenador] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[log_usuarios_pessoa]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[log_usuarios_pessoa](
	[id] [int] NOT NULL,
	[nome] [nvarchar](1000) NULL,
	[cpf] [nvarchar](14) NULL,
	[email] [nvarchar](1000) NULL,
	[excluido_em] [datetime2](7) NULL,
	[dddtelefone_celular] [nvarchar](2) NULL,
	[telefone_celular] [nvarchar](1000) NULL,
	[dddtelefone_residencial] [nvarchar](2) NULL,
	[telefone_residencial] [nvarchar](1000) NULL,
	[logradouro] [nvarchar](1000) NULL,
	[numero] [int] NULL,
	[complemento] [nvarchar](1000) NULL,
	[bairro] [nvarchar](1000) NULL,
	[cep] [nvarchar](1000) NULL,
	[municipio] [nvarchar](1000) NULL,
	[uf] [nvarchar](2) NULL,
	[usuario_externo_id] [int] NULL,
	[secret] [nvarchar](32) NULL,
	[history_id] [int] IDENTITY(1,1) NOT NULL,
	[history_date] [datetime2](7) NOT NULL,
	[history_change_reason] [nvarchar](100) NULL,
	[history_type] [nvarchar](1) NOT NULL,
	[history_user_id] [int] NULL,
	[usuario_id] [int] NULL,
	[observacao] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_categoria]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_categoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_emaillote]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_emaillote](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[destinatario] [nvarchar](255) NOT NULL,
	[remetente] [nvarchar](255) NOT NULL,
	[assunto] [nvarchar](255) NULL,
	[msg] [nvarchar](max) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_imagemfalha]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_imagemfalha](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[co_barra] [nvarchar](50) NOT NULL,
	[url_antiga] [nvarchar](255) NOT NULL,
	[url_nova] [nvarchar](255) NULL,
	[lote_id] [int] NOT NULL,
	[ocorrencia_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ocorrencia_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_loteimagem]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_loteimagem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](max) NOT NULL,
	[enviado] [bit] NOT NULL,
	[respondido] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_ocorrencia]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_ocorrencia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data_solicitacao] [datetime2](7) NOT NULL,
	[data_resposta] [datetime2](7) NULL,
	[data_fechamento] [datetime2](7) NULL,
	[pergunta] [nvarchar](max) NULL,
	[resposta] [nvarchar](max) NULL,
	[nivel] [int] NULL,
	[dados_correcao] [nvarchar](max) NULL,
	[competencia1] [int] NULL,
	[competencia2] [int] NULL,
	[competencia3] [int] NULL,
	[competencia4] [int] NULL,
	[competencia5] [int] NULL,
	[correcao_situacao] [int] NULL,
	[img] [nvarchar](255) NOT NULL,
	[atualizado_por] [int] NULL,
	[categoria_id] [int] NOT NULL,
	[correcao_id] [int] NOT NULL,
	[id_projeto] [int] NULL,
	[lote_solicitado_id] [int] NULL,
	[ocorrencia_pai_id] [int] NULL,
	[situacao_id] [int] NULL,
	[status_id] [int] NOT NULL,
	[tipo_id] [int] NULL,
	[usuario_autor_id] [int] NOT NULL,
	[usuario_responsavel_id] [int] NULL,
	[ocorrencia_relacionada_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_situacao]    Script Date: 22/11/2019 11:51:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_situacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[tipo_hierarquia_competente_id] [smallint] NULL,
	[tipo_alocacao_id] [int] NULL,
	[pode_transferir_para_time_tecnico] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_status]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_status](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[icone] [nvarchar](50) NOT NULL,
	[classe] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_tipo]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_tipo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
	[categoria_id] [int] NOT NULL,
	[tipo_hierarquia_competente_id] [smallint] NULL,
	[tipo_alocacao_id] [int] NULL,
	[pode_transferir_para_time_tecnico] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ocorrencias_tipoalocacao]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ocorrencias_tipoalocacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[parametro]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[parametro](
	[nome] [nvarchar](100) NOT NULL,
	[valor] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[projeto_etapaensino]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[projeto_etapaensino](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [nvarchar](255) NOT NULL,
	[abreviacao] [nvarchar](5) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[projeto_projeto]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[projeto_projeto](
	[id] [int] IDENTITY(1,1) NOT NULL,
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
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[projeto_projeto_usuarios]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[projeto_projeto_usuarios](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[projeto_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [projeto_projeto_usuarios_projeto_id_user_id_c505eb41_uniq] UNIQUE NONCLUSTERED 
(
	[projeto_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorio_quarta_correcao]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorio_quarta_correcao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[nome] [nvarchar](255) NOT NULL,
	[polo_id] [int] NULL,
	[polo_descricao] [nvarchar](100) NULL,
	[time_id] [int] NULL,
	[time_descricao] [nvarchar](100) NULL,
	[indice] [nvarchar](50) NOT NULL,
	[dis_cota_1] [int] NULL,
	[cor_cota_1] [int] NULL,
	[dis_cota_2] [int] NULL,
	[cor_cota_2] [int] NULL,
	[dis_cota_3] [int] NULL,
	[cor_cota_3] [int] NULL,
	[data] [date] NULL,
	[cor_cota_4] [int] NULL,
	[dis_cota_4] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorio_terceira_correcao_avaliador]    Script Date: 22/11/2019 11:51:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorio_terceira_correcao_avaliador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[id_correcao] [int] NOT NULL,
	[id_corretor] [int] NULL,
	[redacao] [nvarchar](50) NOT NULL,
	[data] [datetime2](7) NULL,
	[aproveitamento] [nvarchar](255) NULL,
	[terceira_situacao] [nvarchar](255) NULL,
	[terceira_c1] [int] NULL,
	[terceira_c2] [int] NULL,
	[terceira_c3] [int] NULL,
	[terceira_c4] [int] NULL,
	[terceira_c5] [int] NULL,
	[terceira_soma] [varchar](max) NULL,
	[quarta_situacao] [nvarchar](255) NULL,
	[quarta_c1] [int] NULL,
	[quarta_c2] [int] NULL,
	[quarta_c3] [int] NULL,
	[quarta_c4] [int] NULL,
	[quarta_c5] [int] NULL,
	[quarta_soma] [varchar](max) NULL,
	[co_barra_redacao] [nvarchar](255) NULL,
	[fgv_descricao] [nvarchar](255) NULL,
	[fgv_id] [int] NULL,
	[fgv_indice] [nvarchar](50) NULL,
	[geral_descricao] [nvarchar](255) NULL,
	[geral_id] [int] NULL,
	[geral_indice] [nvarchar](50) NULL,
	[id_hierarquia_usuario_pai] [int] NULL,
	[id_tipo_hierarquia_usuario] [int] NULL,
	[nome] [nvarchar](255) NOT NULL,
	[polo_descricao] [nvarchar](255) NULL,
	[polo_id] [int] NULL,
	[polo_indice] [nvarchar](255) NULL,
	[time_descricao] [nvarchar](255) NULL,
	[time_id] [int] NULL,
	[time_indice] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorio_terceira_correcao_geral]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorio_terceira_correcao_geral](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[polo_id] [int] NOT NULL,
	[id_hierarquia_usuario_pai] [int] NULL,
	[id_tipo_hierarquia_usuario] [int] NULL,
	[indice] [nvarchar](50) NULL,
	[polo_descricao] [nvarchar](100) NOT NULL,
	[terceiras_corrigidas] [int] NOT NULL,
	[terceiras_aproveitadas] [int] NOT NULL,
	[foram_quarta] [int] NOT NULL,
	[aproveitadas_quarta] [int] NOT NULL,
	[nao_aproveitadas_quarta] [int] NOT NULL,
	[data] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorio_terceira_correcao_polo]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorio_terceira_correcao_polo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[time_id] [int] NOT NULL,
	[id_hierarquia_usuario_pai] [int] NULL,
	[id_tipo_hierarquia_usuario] [int] NULL,
	[indice] [nvarchar](50) NULL,
	[time_descricao] [nvarchar](100) NOT NULL,
	[terceiras_corrigidas] [int] NOT NULL,
	[terceiras_aproveitadas] [int] NOT NULL,
	[foram_quarta] [int] NOT NULL,
	[aproveitadas_quarta] [int] NOT NULL,
	[nao_aproveitadas_quarta] [int] NOT NULL,
	[data] [date] NULL,
	[polo_descricao] [nvarchar](100) NULL,
	[polo_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorio_terceira_correcao_time]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorio_terceira_correcao_time](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[time_id] [int] NOT NULL,
	[id_hierarquia_usuario_pai] [int] NULL,
	[id_tipo_hierarquia_usuario] [int] NULL,
	[indice] [nvarchar](50) NULL,
	[time_descricao] [nvarchar](100) NOT NULL,
	[terceiras_corrigidas] [int] NOT NULL,
	[terceiras_aproveitadas] [int] NOT NULL,
	[foram_quarta] [int] NOT NULL,
	[aproveitadas_quarta] [int] NOT NULL,
	[nao_aproveitadas_quarta] [int] NOT NULL,
	[data] [date] NULL,
	[polo_descricao] [nvarchar](100) NULL,
	[polo_id] [int] NULL,
	[avaliador_id] [int] NULL,
	[avaliador_descricao] [nvarchar](100) NULL,
	[pode_corrigir_3] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_acompanhamento_auditoria]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_acompanhamento_auditoria](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[auditor] [nvarchar](255) NOT NULL,
	[pd] [int] NOT NULL,
	[ddh] [int] NOT NULL,
	[nota_maxima] [int] NOT NULL,
	[hierarquia_id] [int] NOT NULL,
	[indice] [nvarchar](255) NOT NULL,
	[situacao_esdruxula] [int] NOT NULL,
	[total] [int] NOT NULL,
	[data] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_acompanhamento_geral]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_acompanhamento_geral](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[projeto] [nvarchar](255) NOT NULL,
	[projeto_id] [int] NOT NULL,
	[nr_redacoes] [int] NULL,
	[nr_redacoes_branco] [int] NULL,
	[nr_redacoes_texto_insuficiente] [int] NULL,
	[nr_1_correcao_concluida] [int] NOT NULL,
	[nr_2_correcao_concluida] [int] NOT NULL,
	[nr_3_correcao_concluida] [int] NOT NULL,
	[nr_redacoes_em_andamento] [int] NOT NULL,
	[nr_redacoes_concluidas] [int] NOT NULL,
	[etapa_ensino_id] [int] NULL,
	[etapa_ensino] [nvarchar](5) NULL,
	[nr_4_correcao_concluida] [int] NOT NULL,
	[nr_auditoria_concluida] [int] NOT NULL,
	[nr_moda_concluida] [int] NULL,
	[nr_ouro_concluida] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_acompanhamentobatimento]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_acompanhamentobatimento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[projeto_id] [int] NOT NULL,
	[redacoes_recebidas] [int] NOT NULL,
	[redacoes_batidas] [int] NOT NULL,
	[textos_validos] [int] NOT NULL,
	[em_branco] [int] NOT NULL,
	[insuficiente] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_acompanhamentogeral]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_acompanhamentogeral](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_tipo_correcao] [int] NULL,
	[total_correcoes] [int] NULL,
	[porcentagem_correcoes] [numeric](10, 2) NULL,
	[total_correcoes_ocorrencia] [int] NULL,
	[total_correcoes_fila] [int] NULL,
	[total_correcoes_corrigidas] [int] NULL,
	[porcentagem_correcoes_correcoes_corrigidas] [numeric](10, 2) NULL,
	[grupo] [nvarchar](2) NULL,
	[flg_dado_atual] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_aproveitamento_notas]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_aproveitamento_notas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[polo_id] [int] NOT NULL,
	[polo_descricao] [nvarchar](500) NOT NULL,
	[time_id] [int] NOT NULL,
	[time_descricao] [nvarchar](500) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[indice] [nvarchar](500) NOT NULL,
	[avaliador] [nvarchar](500) NOT NULL,
	[data] [date] NULL,
	[nr_corrigidas] [int] NOT NULL,
	[nr_aproveitadas] [int] NOT NULL,
	[nr_nao_aproveitadas] [int] NOT NULL,
	[nr_discrepantes] [int] NOT NULL,
	[ultima_correcao] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_aproveitamento_notas_avaliador]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_aproveitamento_notas_avaliador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[id_hierarquia] [int] NULL,
	[id_usuario_responsavel] [int] NULL,
	[id_corretor] [int] NULL,
	[corretor] [nvarchar](255) NOT NULL,
	[total_correcoes_time] [int] NULL,
	[flg_dado_atual] [bit] NOT NULL,
	[redacao] [nvarchar](50) NOT NULL,
	[data] [datetime2](7) NULL,
	[aproveitamento] [nvarchar](255) NULL,
	[avaliador_situacao] [nvarchar](255) NOT NULL,
	[avaliador_c1] [int] NULL,
	[avaliador_c2] [int] NULL,
	[avaliador_c3] [int] NULL,
	[avaliador_c4] [int] NULL,
	[avaliador_c5] [int] NULL,
	[avaliador_is_ddh] [bit] NOT NULL,
	[avaliador_soma] [nvarchar](20) NULL,
	[espelho_situacao] [nvarchar](255) NOT NULL,
	[espelho_c1] [int] NULL,
	[espelho_c2] [int] NULL,
	[espelho_c3] [int] NULL,
	[espelho_c4] [int] NULL,
	[espelho_c5] [int] NULL,
	[espelho_is_ddh] [bit] NOT NULL,
	[espelho_soma] [nvarchar](20) NULL,
	[terceiro_situacao] [nvarchar](255) NULL,
	[terceiro_c1] [int] NULL,
	[terceiro_c2] [int] NULL,
	[terceiro_c3] [int] NULL,
	[terceiro_c4] [int] NULL,
	[terceiro_c5] [int] NULL,
	[terceiro_is_ddh] [bit] NOT NULL,
	[terceiro_soma] [nvarchar](20) NULL,
	[discrepou] [bit] NOT NULL,
	[espelho_data] [datetime2](7) NULL,
	[id_correcao] [int] NULL,
	[id_hierarquia_usuario_pai] [int] NULL,
	[id_projeto] [int] NULL,
	[id_redacao] [int] NULL,
	[id_tipo_hierarquia_usuario] [int] NULL,
	[indice] [nvarchar](500) NULL,
	[nome] [nvarchar](500) NULL,
	[terceiro_data] [datetime2](7) NULL,
	[usuario_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_aproveitamentotime]    Script Date: 22/11/2019 11:51:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_aproveitamentotime](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_usuario_responsavel] [int] NOT NULL,
	[id_hierarquia] [int] NOT NULL,
	[id_usuario] [int] NOT NULL,
	[nome] [nvarchar](255) NOT NULL,
	[data_correcao] [datetime2](7) NULL,
	[corrigidas] [int] NULL,
	[discrepou] [int] NULL,
	[nao_discrepou] [int] NULL,
	[aproveitada] [int] NULL,
	[nao_aproveitada] [int] NULL,
	[indice] [nvarchar](50) NULL,
	[polo] [nvarchar](100) NULL,
	[time] [nvarchar](100) NULL,
	[polo_id] [int] NULL,
	[time_id] [int] NULL,
	[flg_dado_atual] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_calculoacompanhamentogeral]    Script Date: 22/11/2019 11:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_calculoacompanhamentogeral](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_calculoacompanhamentoredacoes]    Script Date: 22/11/2019 11:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_calculoacompanhamentoredacoes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[criado_em] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_correcoes_usuario]    Script Date: 22/11/2019 11:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_correcoes_usuario](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[nome] [nvarchar](500) NOT NULL,
	[nr_corrigidas] [int] NOT NULL,
	[ultima_correcao] [datetime2](7) NOT NULL,
	[indice] [nvarchar](250) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_distribuicao_notas_competencia]    Script Date: 22/11/2019 11:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_distribuicao_notas_competencia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[polo_id] [int] NOT NULL,
	[polo_descricao] [nvarchar](500) NOT NULL,
	[polo_indice] [nvarchar](500) NOT NULL,
	[time_id] [int] NOT NULL,
	[time_descricao] [nvarchar](500) NOT NULL,
	[indice] [nvarchar](500) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[nome] [nvarchar](500) NOT NULL,
	[nr_competencia1_0] [int] NOT NULL,
	[nr_competencia1_1] [int] NOT NULL,
	[nr_competencia1_2] [int] NOT NULL,
	[nr_competencia1_3] [int] NOT NULL,
	[nr_competencia1_4] [int] NOT NULL,
	[nr_competencia1_5] [int] NOT NULL,
	[nr_competencia2_0] [int] NOT NULL,
	[nr_competencia2_1] [int] NOT NULL,
	[nr_competencia2_2] [int] NOT NULL,
	[nr_competencia2_3] [int] NOT NULL,
	[nr_competencia2_4] [int] NOT NULL,
	[nr_competencia2_5] [int] NOT NULL,
	[nr_competencia3_0] [int] NOT NULL,
	[nr_competencia3_1] [int] NOT NULL,
	[nr_competencia3_2] [int] NOT NULL,
	[nr_competencia3_3] [int] NOT NULL,
	[nr_competencia3_4] [int] NOT NULL,
	[nr_competencia3_5] [int] NOT NULL,
	[nr_competencia4_0] [int] NOT NULL,
	[nr_competencia4_1] [int] NOT NULL,
	[nr_competencia4_2] [int] NOT NULL,
	[nr_competencia4_3] [int] NOT NULL,
	[nr_competencia4_4] [int] NOT NULL,
	[nr_competencia4_5] [int] NOT NULL,
	[nr_competencia5_ddh] [int] NOT NULL,
	[nr_competencia5_0] [int] NOT NULL,
	[nr_competencia5_1] [int] NOT NULL,
	[nr_competencia5_2] [int] NOT NULL,
	[nr_competencia5_3] [int] NOT NULL,
	[nr_competencia5_4] [int] NOT NULL,
	[nr_competencia5_5] [int] NOT NULL,
	[data] [date] NULL,
	[nr_corrigidas] [int] NOT NULL,
	[nr_com_nota_normal] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_distribuicao_notas_situacao]    Script Date: 22/11/2019 11:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_distribuicao_notas_situacao](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[polo_id] [int] NOT NULL,
	[polo_descricao] [nvarchar](100) NOT NULL,
	[time_id] [int] NOT NULL,
	[time_descricao] [nvarchar](100) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[nome] [nvarchar](500) NOT NULL,
	[indice] [nvarchar](50) NOT NULL,
	[data] [date] NULL,
	[nr_nm] [int] NOT NULL,
	[nr_fea] [int] NOT NULL,
	[nr_copia] [int] NOT NULL,
	[nr_ft] [int] NOT NULL,
	[nr_natt] [int] NOT NULL,
	[nr_pd] [int] NOT NULL,
	[nr_corrigidas] [int] NOT NULL,
	[nr_situacoes] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_distribuicaonotas]    Script Date: 22/11/2019 11:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_distribuicaonotas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_hierarquia] [int] NULL,
	[id_usuario_responsavel] [int] NULL,
	[id_corretor] [int] NULL,
	[status] [int] NULL,
	[corretor] [nvarchar](255) NOT NULL,
	[nr_corrigidas] [int] NULL,
	[nr_com_nota_normal] [int] NULL,
	[competencia1_0] [numeric](4, 1) NULL,
	[competencia1_0_is_alerta] [bit] NOT NULL,
	[competencia1_1] [numeric](4, 1) NULL,
	[competencia1_1_is_alerta] [bit] NOT NULL,
	[competencia1_2] [numeric](4, 1) NULL,
	[competencia1_2_is_alerta] [bit] NOT NULL,
	[competencia1_3] [numeric](4, 1) NULL,
	[competencia1_3_is_alerta] [bit] NOT NULL,
	[competencia1_4] [numeric](4, 1) NULL,
	[competencia1_4_is_alerta] [bit] NOT NULL,
	[competencia1_5] [numeric](4, 1) NULL,
	[competencia1_5_is_alerta] [bit] NOT NULL,
	[competencia2_0] [numeric](4, 1) NULL,
	[competencia2_0_is_alerta] [bit] NOT NULL,
	[competencia2_1] [numeric](4, 1) NULL,
	[competencia2_1_is_alerta] [bit] NOT NULL,
	[competencia2_2] [numeric](4, 1) NULL,
	[competencia2_2_is_alerta] [bit] NOT NULL,
	[competencia2_3] [numeric](4, 1) NULL,
	[competencia2_3_is_alerta] [bit] NOT NULL,
	[competencia2_4] [numeric](4, 1) NULL,
	[competencia2_4_is_alerta] [bit] NOT NULL,
	[competencia2_5] [numeric](4, 1) NULL,
	[competencia2_5_is_alerta] [bit] NOT NULL,
	[competencia3_0] [numeric](4, 1) NULL,
	[competencia3_0_is_alerta] [bit] NOT NULL,
	[competencia3_1] [numeric](4, 1) NULL,
	[competencia3_1_is_alerta] [bit] NOT NULL,
	[competencia3_2] [numeric](4, 1) NULL,
	[competencia3_2_is_alerta] [bit] NOT NULL,
	[competencia3_3] [numeric](4, 1) NULL,
	[competencia3_3_is_alerta] [bit] NOT NULL,
	[competencia3_4] [numeric](4, 1) NULL,
	[competencia3_4_is_alerta] [bit] NOT NULL,
	[competencia3_5] [numeric](4, 1) NULL,
	[competencia3_5_is_alerta] [bit] NOT NULL,
	[competencia4_0] [numeric](4, 1) NULL,
	[competencia4_0_is_alerta] [bit] NOT NULL,
	[competencia4_1] [numeric](4, 1) NULL,
	[competencia4_1_is_alerta] [bit] NOT NULL,
	[competencia4_2] [numeric](4, 1) NULL,
	[competencia4_2_is_alerta] [bit] NOT NULL,
	[competencia4_3] [numeric](4, 1) NULL,
	[competencia4_3_is_alerta] [bit] NOT NULL,
	[competencia4_4] [numeric](4, 1) NULL,
	[competencia4_4_is_alerta] [bit] NOT NULL,
	[competencia4_5] [numeric](4, 1) NULL,
	[competencia4_5_is_alerta] [bit] NOT NULL,
	[competencia5_ddh] [numeric](4, 1) NULL,
	[competencia5_ddh_is_alerta] [bit] NOT NULL,
	[competencia5_0] [numeric](4, 1) NULL,
	[competencia5_0_is_alerta] [bit] NOT NULL,
	[competencia5_1] [numeric](4, 1) NULL,
	[competencia5_1_is_alerta] [bit] NOT NULL,
	[competencia5_2] [numeric](4, 1) NULL,
	[competencia5_2_is_alerta] [bit] NOT NULL,
	[competencia5_3] [numeric](4, 1) NULL,
	[competencia5_3_is_alerta] [bit] NOT NULL,
	[competencia5_4] [numeric](4, 1) NULL,
	[competencia5_4_is_alerta] [bit] NOT NULL,
	[competencia5_5] [numeric](4, 1) NULL,
	[competencia5_5_is_alerta] [bit] NOT NULL,
	[flg_dado_atual] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_distribuicaonotashierarquia]    Script Date: 22/11/2019 11:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_distribuicaonotashierarquia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[id_hierarquia] [int] NULL,
	[id_usuario_responsavel] [int] NULL,
	[nr_total_avaliadores] [int] NULL,
	[nr_corrigidas] [int] NULL,
	[nr_com_nota_normal] [int] NULL,
	[competencia1_0] [numeric](4, 1) NULL,
	[competencia1_1] [numeric](4, 1) NULL,
	[competencia1_2] [numeric](4, 1) NULL,
	[competencia1_3] [numeric](4, 1) NULL,
	[competencia1_4] [numeric](4, 1) NULL,
	[competencia1_5] [numeric](4, 1) NULL,
	[competencia2_0] [numeric](4, 1) NULL,
	[competencia2_1] [numeric](4, 1) NULL,
	[competencia2_2] [numeric](4, 1) NULL,
	[competencia2_3] [numeric](4, 1) NULL,
	[competencia2_4] [numeric](4, 1) NULL,
	[competencia2_5] [numeric](4, 1) NULL,
	[competencia3_0] [numeric](4, 1) NULL,
	[competencia3_1] [numeric](4, 1) NULL,
	[competencia3_2] [numeric](4, 1) NULL,
	[competencia3_3] [numeric](4, 1) NULL,
	[competencia3_4] [numeric](4, 1) NULL,
	[competencia3_5] [numeric](4, 1) NULL,
	[competencia4_0] [numeric](4, 1) NULL,
	[competencia4_1] [numeric](4, 1) NULL,
	[competencia4_2] [numeric](4, 1) NULL,
	[competencia4_3] [numeric](4, 1) NULL,
	[competencia4_4] [numeric](4, 1) NULL,
	[competencia4_5] [numeric](4, 1) NULL,
	[competencia5_ddh] [numeric](4, 1) NULL,
	[competencia5_0] [numeric](4, 1) NULL,
	[competencia5_1] [numeric](4, 1) NULL,
	[competencia5_2] [numeric](4, 1) NULL,
	[competencia5_3] [numeric](4, 1) NULL,
	[competencia5_4] [numeric](4, 1) NULL,
	[competencia5_5] [numeric](4, 1) NULL,
	[flg_dado_atual] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_extratocorrecao]    Script Date: 22/11/2019 11:51:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_extratocorrecao](
	[usuario_id] [int] NOT NULL,
	[cpf] [nvarchar](20) NOT NULL,
	[nome] [nvarchar](200) NOT NULL,
	[perfil] [nvarchar](50) NOT NULL,
	[enviados] [int] NOT NULL,
	[enviados_primeira] [int] NOT NULL,
	[enviados_segunda] [int] NOT NULL,
	[enviados_terceira] [int] NOT NULL,
	[enviados_quarta] [int] NOT NULL,
	[enviados_ouro] [int] NOT NULL,
	[enviados_moda] [int] NOT NULL,
	[enviados_auditoria] [int] NOT NULL,
	[glosadas] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_extratocorrecaodiario]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_extratocorrecaodiario](
	[cpf] [nvarchar](20) NOT NULL,
	[nome] [nvarchar](200) NOT NULL,
	[perfil] [nvarchar](50) NOT NULL,
	[enviados] [int] NOT NULL,
	[enviados_primeira] [int] NOT NULL,
	[enviados_segunda] [int] NOT NULL,
	[enviados_terceira] [int] NOT NULL,
	[enviados_quarta] [int] NOT NULL,
	[enviados_ouro] [int] NOT NULL,
	[enviados_moda] [int] NOT NULL,
	[enviados_auditoria] [int] NOT NULL,
	[glosadas] [int] NOT NULL,
	[id] [int] IDENTITY(1,1) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[data] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_historicoacompanhamentogeral]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_historicoacompanhamentogeral](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [nvarchar](1000) NOT NULL,
	[tipo_correcao_id] [int] NULL,
	[projeto_descricao] [nvarchar](1000) NOT NULL,
	[projeto_id] [int] NOT NULL,
	[disponiveis] [int] NOT NULL,
	[total_em_ocorrencia] [int] NOT NULL,
	[total_em_correcao] [int] NOT NULL,
	[total_finalizadas] [int] NOT NULL,
	[soma_totais] [int] NULL,
	[porcentagem_disponiveis] [numeric](5, 2) NULL,
	[porcentagem_finalizadas] [numeric](5, 2) NULL,
	[destacar] [bit] NOT NULL,
	[calculo_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_historicoacompanhamentoredacoes]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_historicoacompanhamentoredacoes](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[status] [nvarchar](1000) NOT NULL,
	[valor] [int] NOT NULL,
	[porcentagem] [numeric](5, 2) NULL,
	[calculo_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_informacaogeral]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_informacaogeral](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[grupo] [nvarchar](2) NULL,
	[total_inscritos] [int] NULL,
	[numero_brancos] [int] NULL,
	[numero_insuficiente] [int] NULL,
	[numero_review] [int] NULL,
	[numero_a_receber] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_mensagem]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_mensagem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[conteudo] [nvarchar](4000) NULL,
	[conteudo_padrao] [nvarchar](4000) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_padrao_ouro]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_padrao_ouro](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[polo_id] [int] NOT NULL,
	[polo_descricao] [nvarchar](500) NOT NULL,
	[time_id] [int] NOT NULL,
	[time_descricao] [nvarchar](500) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[hierarquia_id] [int] NOT NULL,
	[id_usuario_responsavel] [int] NOT NULL,
	[indice] [nvarchar](500) NOT NULL,
	[id_tipo_hierarquia_usuario] [int] NOT NULL,
	[avaliador] [nvarchar](500) NOT NULL,
	[data] [date] NULL,
	[nr_padrao_ouro] [int] NOT NULL,
	[nr_discrepancia_padrao_ouro] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_padrao_ouro_avaliador]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_padrao_ouro_avaliador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[id_correcao] [int] NULL,
	[id_corretor] [int] NULL,
	[redacao] [int] NULL,
	[avaliador_situacao] [nvarchar](255) NULL,
	[referencia_situacao] [nvarchar](255) NULL,
	[avaliador_c1] [int] NULL,
	[avaliador_c2] [int] NULL,
	[avaliador_c3] [int] NULL,
	[avaliador_c4] [int] NULL,
	[avaliador_c5] [int] NULL,
	[avaliador_is_ddh] [bit] NOT NULL,
	[nota] [int] NULL,
	[referencia_c1] [int] NULL,
	[referencia_c2] [int] NULL,
	[referencia_c3] [int] NULL,
	[referencia_c4] [int] NULL,
	[referencia_c5] [int] NULL,
	[referencia_is_ddh] [bit] NOT NULL,
	[nota_referencia] [int] NULL,
	[diferenca_c1] [int] NULL,
	[diferenca_c2] [int] NULL,
	[diferenca_c3] [int] NULL,
	[diferenca_c4] [int] NULL,
	[diferenca_c5] [int] NULL,
	[nota_diferenca] [int] NULL,
	[discrepou] [bit] NOT NULL,
	[data] [date] NULL,
	[fgv_descricao] [nvarchar](500) NULL,
	[fgv_id] [int] NULL,
	[fgv_indice] [nvarchar](500) NULL,
	[geral_descricao] [nvarchar](500) NULL,
	[geral_id] [int] NULL,
	[geral_indice] [nvarchar](500) NULL,
	[polo_descricao] [nvarchar](500) NULL,
	[polo_id] [int] NULL,
	[polo_indice] [nvarchar](500) NULL,
	[time_descricao] [nvarchar](500) NULL,
	[time_id] [int] NULL,
	[time_indice] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_panorama_geral_ocorrencia]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_panorama_geral_ocorrencia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[time_id] [int] NULL,
	[time_descricao] [nvarchar](255) NULL,
	[polo_id] [int] NULL,
	[polo_descricao] [nvarchar](255) NULL,
	[indice] [nvarchar](255) NULL,
	[data] [date] NULL,
	[ocorrencias_imagem] [int] NULL,
	[ocorrencias_imagem_pendentes] [int] NULL,
	[ocorrencias_imagem_respondidas] [int] NULL,
	[ocorrencias_pedagogica] [int] NULL,
	[ocorrencias_pedagogica_pendentes] [int] NULL,
	[ocorrencias_pedagogica_respondidas] [int] NULL,
	[ocorrencias_pendentes_coord_fgv] [int] NULL,
	[ocorrencias_pendentes_coord_polo] [int] NULL,
	[ocorrencias_pendentes_supervisor] [int] NULL,
	[ocorrencias_pendentes_time_tecnico] [int] NULL,
	[supervisor] [nvarchar](255) NULL,
	[total] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_relatorio_geral]    Script Date: 22/11/2019 11:51:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_relatorio_geral](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[versao] [char](32) NOT NULL,
	[polo_id] [int] NULL,
	[polo_descricao] [nvarchar](500) NULL,
	[time_id] [int] NOT NULL,
	[time_descricao] [nvarchar](500) NOT NULL,
	[avaliador] [nvarchar](500) NOT NULL,
	[usuario_id] [int] NOT NULL,
	[nr_corrigidas] [int] NULL,
	[nr_aproveitadas] [int] NULL,
	[nr_discrepantes] [int] NULL,
	[tempo_medio] [int] NULL,
	[dsp] [nvarchar](20) NULL,
	[indice] [nvarchar](500) NOT NULL,
	[data] [date] NULL,
	[nr_corrigidas_1_2] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[relatorios_tolerancia]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[relatorios_tolerancia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo_relatorio] [nvarchar](50) NOT NULL,
	[coluna] [nvarchar](50) NOT NULL,
	[valor] [numeric](10, 2) NULL,
	[descricao] [nvarchar](255) NOT NULL,
	[configuravel] [bit] NOT NULL,
	[relatorio_descricao] [nvarchar](255) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [reports_tolerancia_relatorio_code_coluna_6ad9c1e7_uniq] UNIQUE NONCLUSTERED 
(
	[codigo_relatorio] ASC,
	[coluna] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[reports_controlerelatorio]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[reports_controlerelatorio](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[codigo] [nvarchar](50) NOT NULL,
	[versao_atual] [char](32) NOT NULL,
	[atualizado_em] [datetime2](7) NOT NULL,
	[proxima_versao] [char](32) NULL,
	[ativo] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [reports_controlerelatorio_codigo_6b9b71dd_uniq] UNIQUE NONCLUSTERED 
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[status_corretor_motivotrocastatus]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[status_corretor_motivotrocastatus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](4000) NOT NULL,
	[codigo] [nvarchar](10) NULL,
	[status_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[status_corretor_trocastatus]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[status_corretor_trocastatus](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[corretor_id] [int] NOT NULL,
	[motivo_id] [int] NULL,
	[status_anterior_id] [int] NULL,
	[status_atual_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tmp_correcoes_redacao_16102019_1227]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmp_correcoes_redacao_16102019_1227](
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
	[motivo_id] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios_hierarquia]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios_hierarquia](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [nvarchar](100) NOT NULL,
	[indice] [nvarchar](50) NOT NULL,
	[id_hierarquia_usuario_pai] [int] NULL,
	[id_tipo_hierarquia_usuario] [smallint] NULL,
	[id_usuario_responsavel] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios_hierarquia_usuarios]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios_hierarquia_usuarios](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[hierarquia_id] [int] NOT NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [usuarios_hierarquia_usuarios_hierarquia_id_user_id_1e0cfd7b_uniq] UNIQUE NONCLUSTERED 
(
	[hierarquia_id] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios_mudancatime]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios_mudancatime](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data_mudanca] [datetime2](7) NULL,
	[atualizado_por] [int] NULL,
	[id_time_anterior] [int] NOT NULL,
	[id_time_atual] [int] NOT NULL,
	[id_usuario] [int] NOT NULL,
	[id_coordenador] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios_pessoa]    Script Date: 22/11/2019 11:51:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios_pessoa](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nome] [nvarchar](1000) NULL,
	[cpf] [nvarchar](14) NULL,
	[email] [nvarchar](1000) NULL,
	[excluido_em] [datetime2](7) NULL,
	[dddtelefone_celular] [nvarchar](2) NULL,
	[telefone_celular] [nvarchar](1000) NULL,
	[dddtelefone_residencial] [nvarchar](2) NULL,
	[telefone_residencial] [nvarchar](1000) NULL,
	[logradouro] [nvarchar](1000) NULL,
	[numero] [int] NULL,
	[complemento] [nvarchar](1000) NULL,
	[bairro] [nvarchar](1000) NULL,
	[cep] [nvarchar](1000) NULL,
	[municipio] [nvarchar](1000) NULL,
	[uf] [nvarchar](2) NULL,
	[usuario_externo_id] [int] NULL,
	[secret] [nvarchar](32) NULL,
	[usuario_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[usuarios_tipohierarquia]    Script Date: 22/11/2019 11:51:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarios_tipohierarquia](
	[id] [smallint] NOT NULL,
	[descricao] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [alerta_alerta_id_tipo_c9c4329e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [alerta_alerta_id_tipo_c9c4329e] ON [dbo].[alerta_alerta]
(
	[id_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [alerta_alerta_id_usuario_7fd22219]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [alerta_alerta_id_usuario_7fd22219] ON [dbo].[alerta_alerta]
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_group_id_b120cbf9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [auth_group_permissions_group_id_b120cbf9] ON [dbo].[auth_group_permissions]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_permission_id_84c5c92e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [auth_group_permissions_permission_id_84c5c92e] ON [dbo].[auth_group_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_permission_content_type_id_2f476e4b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [auth_permission_content_type_id_2f476e4b] ON [dbo].[auth_permission]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [nci_wi_auth_permission_944797587C2360A2248BA80B2F8F5B3C]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [nci_wi_auth_permission_944797587C2360A2248BA80B2F8F5B3C] ON [dbo].[auth_permission]
(
	[codename] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_group_id_97559544]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [auth_user_groups_group_id_97559544] ON [dbo].[auth_user_groups]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_user_id_6a12ed8b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [auth_user_groups_user_id_6a12ed8b] ON [dbo].[auth_user_groups]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_permission_id_1fbb5f2c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [auth_user_user_permissions_permission_id_1fbb5f2c] ON [dbo].[auth_user_user_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_user_id_a95ead1b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [auth_user_user_permissions_user_id_a95ead1b] ON [dbo].[auth_user_user_permissions]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [avisos_aviso_id_hierarquia_f7314227]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [avisos_aviso_id_hierarquia_f7314227] ON [dbo].[avisos_aviso]
(
	[id_hierarquia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [avisos_avisousuario_id_aviso_ee45e775]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [avisos_avisousuario_id_aviso_ee45e775] ON [dbo].[avisos_avisousuario]
(
	[id_aviso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [avisos_avisousuario_id_usuario_c1df7b37]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [avisos_avisousuario_id_usuario_c1df7b37] ON [dbo].[avisos_avisousuario]
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticket_atualizado_por_cb61852a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticket_atualizado_por_cb61852a] ON [dbo].[chamados_chamado]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticket_autor_id_05faf85c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticket_autor_id_05faf85c] ON [dbo].[chamados_chamado]
(
	[autor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticket_correcao_id_89534dda]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticket_correcao_id_89534dda] ON [dbo].[chamados_chamado]
(
	[correcao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticket_responsavel_atual_30a243cc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticket_responsavel_atual_30a243cc] ON [dbo].[chamados_chamado]
(
	[responsavel_atual] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticket_responsavel_padrao_9bd2d057]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticket_responsavel_padrao_9bd2d057] ON [dbo].[chamados_chamado]
(
	[responsavel_padrao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticket_status_id_757a0115]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticket_status_id_757a0115] ON [dbo].[chamados_chamado]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticket_tipo_id_b36c4e56]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticket_tipo_id_b36c4e56] ON [dbo].[chamados_chamado]
(
	[tipo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticketchat_answerable_id_4ed80e24]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticketchat_answerable_id_4ed80e24] ON [dbo].[chamados_responsabilidade]
(
	[responsavel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticketchat_author_id_5583929e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticketchat_author_id_5583929e] ON [dbo].[chamados_responsabilidade]
(
	[autor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticketchat_status_id_46090220]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticketchat_status_id_46090220] ON [dbo].[chamados_responsabilidade]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_ticketchat_ticket_id_5ebc32e1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_ticketchat_ticket_id_5ebc32e1] ON [dbo].[chamados_responsabilidade]
(
	[chamado_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_type_allocation_type_id_6cfc23cb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_type_allocation_type_id_6cfc23cb] ON [dbo].[chamados_tipo]
(
	[tipo_alocacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_type_answerable_hierarchy_type_id_3ca41ab3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_type_answerable_hierarchy_type_id_3ca41ab3] ON [dbo].[chamados_tipo]
(
	[tipo_hierarquia_competente_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ticket_type_category_id_55670299]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ticket_type_category_id_55670299] ON [dbo].[chamados_tipo]
(
	[categoria_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [chats_mensagem_id_destinatario_0310c858]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [chats_mensagem_id_destinatario_0310c858] ON [dbo].[chats_mensagem]
(
	[id_destinatario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [chats_mensagem_id_remetente_d45f1185]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [chats_mensagem_id_remetente_d45f1185] ON [dbo].[chats_mensagem]
(
	[id_remetente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [core_notificacaogrupo_id_grupo_e7b75175]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [core_notificacaogrupo_id_grupo_e7b75175] ON [dbo].[core_notificacaogrupo]
(
	[id_grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [core_notificacaogrupo_id_notificacao_20367ca8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [core_notificacaogrupo_id_notificacao_20367ca8] ON [dbo].[core_notificacaogrupo]
(
	[id_notificacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_data_termino_A_27e41bf0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_data_termino_A_27e41bf0] ON [dbo].[correcoes_analise]
(
	[data_termino_A] ASC
)
INCLUDE ( 	[id_tipo_correcao_A],
	[id_tipo_correcao_B],
	[id_corretor_A],
	[conclusao_analise]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_data_termino_B_ba77e1e9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_data_termino_B_ba77e1e9] ON [dbo].[correcoes_analise]
(
	[data_termino_B] ASC
)
INCLUDE ( 	[id_tipo_correcao_A],
	[id_tipo_correcao_B],
	[id_corretor_B],
	[conclusao_analise]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_id_correcao_A_4be32727_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_id_correcao_A_4be32727_idx] ON [dbo].[correcoes_analise]
(
	[id_correcao_A] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_id_correcao_B_7c5a0eea]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_id_correcao_B_7c5a0eea] ON [dbo].[correcoes_analise]
(
	[id_correcao_B] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_id_correcao_situacao_A_571be751_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_id_correcao_situacao_A_571be751_idx] ON [dbo].[correcoes_analise]
(
	[id_correcao_situacao_A] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_id_correcao_situacao_B_c289588e_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_id_correcao_situacao_B_c289588e_idx] ON [dbo].[correcoes_analise]
(
	[id_correcao_situacao_B] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_id_corretor_A_9a7e5624_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_id_corretor_A_9a7e5624_idx] ON [dbo].[correcoes_analise]
(
	[id_corretor_A] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_id_corretor_B_36e05ee3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_id_corretor_B_36e05ee3] ON [dbo].[correcoes_analise]
(
	[id_corretor_B] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_id_projeto_eb155f4e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_id_projeto_eb155f4e] ON [dbo].[correcoes_analise]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_analise_redacao_id_7c68bf3d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_analise_redacao_id_7c68bf3d] ON [dbo].[correcoes_analise]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix__correcoes_analise__data_inicio_b__id_tipo_correcao_b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ix__correcoes_analise__data_inicio_b__id_tipo_correcao_b] ON [dbo].[correcoes_analise]
(
	[data_inicio_B] ASC,
	[id_tipo_correcao_B] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [ix__correcoes_analise__id_tipo_correcao_A]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ix__correcoes_analise__id_tipo_correcao_A] ON [dbo].[correcoes_analise]
(
	[id_tipo_correcao_A] ASC
)
INCLUDE ( 	[data_termino_A],
	[nota_final_A],
	[competencia1_A],
	[competencia2_A],
	[competencia3_A],
	[id_projeto],
	[id_correcao_situacao_A],
	[id_correcao_A],
	[conclusao_analise],
	[competencia4_A],
	[competencia5_A],
	[id_corretor_A],
	[co_barra_redacao]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix__correcoes_analise__id_tipo_correcao_B]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ix__correcoes_analise__id_tipo_correcao_B] ON [dbo].[correcoes_analise]
(
	[id_tipo_correcao_B] ASC
)
INCLUDE ( 	[conclusao_analise],
	[redacao_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix__correcoes_analise__id_tipo_correcao_B__conclusao_analise]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ix__correcoes_analise__id_tipo_correcao_B__conclusao_analise] ON [dbo].[correcoes_analise]
(
	[id_tipo_correcao_B] ASC,
	[conclusao_analise] ASC
)
INCLUDE ( 	[redacao_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_atualizado_por_f6830e2d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_atualizado_por_f6830e2d] ON [dbo].[correcoes_correcao]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_id_auxiliar1_edecbd42]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_id_auxiliar1_edecbd42] ON [dbo].[correcoes_correcao]
(
	[id_auxiliar1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_id_auxiliar2_99d73068]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_id_auxiliar2_99d73068] ON [dbo].[correcoes_correcao]
(
	[id_auxiliar2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_id_correcao_situacao_e6bc6a7e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_id_correcao_situacao_e6bc6a7e] ON [dbo].[correcoes_correcao]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_id_corretor_21208678]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_id_corretor_21208678] ON [dbo].[correcoes_correcao]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_id_projeto_7a27365b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_id_projeto_7a27365b] ON [dbo].[correcoes_correcao]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_id_status_89434233]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_id_status_89434233] ON [dbo].[correcoes_correcao]
(
	[id_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_id_tipo_correcao_330dd5b7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_id_tipo_correcao_330dd5b7] ON [dbo].[correcoes_correcao]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_redacao_id_45ee63f4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_redacao_id_45ee63f4] ON [dbo].[correcoes_correcao]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcao_tipo_auditoria_id_5b6a58c7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcao_tipo_auditoria_id_5b6a58c7] ON [dbo].[correcoes_correcao]
(
	[tipo_auditoria_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_atualizado_por_20e1f68e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_atualizado_por_20e1f68e] ON [dbo].[correcoes_correcaomoda]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_id_auxiliar1_71b8f030]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_id_auxiliar1_71b8f030] ON [dbo].[correcoes_correcaomoda]
(
	[id_auxiliar1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_id_auxiliar2_821effbe]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_id_auxiliar2_821effbe] ON [dbo].[correcoes_correcaomoda]
(
	[id_auxiliar2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_id_correcao_situacao_9ea0df9f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_id_correcao_situacao_9ea0df9f] ON [dbo].[correcoes_correcaomoda]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_id_corretor_70d0c767]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_id_corretor_70d0c767] ON [dbo].[correcoes_correcaomoda]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_id_projeto_4aa92ecd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_id_projeto_4aa92ecd] ON [dbo].[correcoes_correcaomoda]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_id_status_4d50673a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_id_status_4d50673a] ON [dbo].[correcoes_correcaomoda]
(
	[id_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_id_tipo_correcao_85fd6301]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_id_tipo_correcao_85fd6301] ON [dbo].[correcoes_correcaomoda]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaomoda_redacao_id_af77ff5e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaomoda_redacao_id_af77ff5e] ON [dbo].[correcoes_correcaomoda]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_atualizado_por_f8c540bd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_atualizado_por_f8c540bd] ON [dbo].[correcoes_correcaoouro]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_id_auxiliar1_b76ddac5]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_id_auxiliar1_b76ddac5] ON [dbo].[correcoes_correcaoouro]
(
	[id_auxiliar1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_id_auxiliar2_45b7500a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_id_auxiliar2_45b7500a] ON [dbo].[correcoes_correcaoouro]
(
	[id_auxiliar2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_id_correcao_situacao_78a584ba]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_id_correcao_situacao_78a584ba] ON [dbo].[correcoes_correcaoouro]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_id_corretor_a6575b27]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_id_corretor_a6575b27] ON [dbo].[correcoes_correcaoouro]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_id_projeto_cd657a64]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_id_projeto_cd657a64] ON [dbo].[correcoes_correcaoouro]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_id_status_aec2cfc3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_id_status_aec2cfc3] ON [dbo].[correcoes_correcaoouro]
(
	[id_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_id_tipo_correcao_aef0d64f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_id_tipo_correcao_aef0d64f] ON [dbo].[correcoes_correcaoouro]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_correcaoouro_redacao_id_d7f2f8a8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_correcaoouro_redacao_id_d7f2f8a8] ON [dbo].[correcoes_correcaoouro]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_corretor_atualizado_por_9f217987]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_corretor_atualizado_por_9f217987] ON [dbo].[correcoes_corretor]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_corretor_id_grupo_20dbba7a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_corretor_id_grupo_20dbba7a] ON [dbo].[correcoes_corretor]
(
	[id_grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_corretor_status_id_f425c883_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_corretor_status_id_f425c883_idx] ON [dbo].[correcoes_corretor]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [correcoes_c_data_ca_0d6b57_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_c_data_ca_0d6b57_idx] ON [dbo].[correcoes_corretor_indicadores]
(
	[data_calculo] ASC,
	[indice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_c_data_ca_5d76ba_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_c_data_ca_5d76ba_idx] ON [dbo].[correcoes_corretor_indicadores]
(
	[data_calculo] ASC,
	[flg_dado_atual] ASC,
	[projeto_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_corretor_indicadores_id_usuario_responsavel_0beb84dc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_corretor_indicadores_id_usuario_responsavel_0beb84dc] ON [dbo].[correcoes_corretor_indicadores]
(
	[id_usuario_responsavel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_corretor_indicadores_projeto_id_604467fd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_corretor_indicadores_projeto_id_604467fd] ON [dbo].[correcoes_corretor_indicadores]
(
	[projeto_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_corretor_indicadores_usuario_id_444019d9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_corretor_indicadores_usuario_id_444019d9] ON [dbo].[correcoes_corretor_indicadores]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila1_id_correcao_916a5504]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila1_id_correcao_916a5504] ON [dbo].[correcoes_fila1]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila1_id_grupo_corretor_b0824133]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila1_id_grupo_corretor_b0824133] ON [dbo].[correcoes_fila1]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila1_id_projeto_8f6e6c28]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila1_id_projeto_8f6e6c28] ON [dbo].[correcoes_fila1]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila1_redacao_id_cb646572]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila1_redacao_id_cb646572] ON [dbo].[correcoes_fila1]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila2_id_correcao_51e4a531]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila2_id_correcao_51e4a531] ON [dbo].[correcoes_fila2]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila2_id_grupo_corretor_3fdd1c11]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila2_id_grupo_corretor_3fdd1c11] ON [dbo].[correcoes_fila2]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila2_id_projeto_4df66460]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila2_id_projeto_4df66460] ON [dbo].[correcoes_fila2]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila2_redacao_id_8ada1e16]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila2_redacao_id_8ada1e16] ON [dbo].[correcoes_fila2]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila3_id_correcao_daa6bb5e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila3_id_correcao_daa6bb5e] ON [dbo].[correcoes_fila3]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila3_id_grupo_corretor_c73ccd03]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila3_id_grupo_corretor_c73ccd03] ON [dbo].[correcoes_fila3]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila3_id_projeto_9fb2e6c4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila3_id_projeto_9fb2e6c4] ON [dbo].[correcoes_fila3]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila3_redacao_id_90ddb8da]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila3_redacao_id_90ddb8da] ON [dbo].[correcoes_fila3]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila4_id_correcao_e86579f1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila4_id_correcao_e86579f1] ON [dbo].[correcoes_fila4]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila4_id_grupo_corretor_4abe2295]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila4_id_grupo_corretor_4abe2295] ON [dbo].[correcoes_fila4]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila4_id_projeto_70b665a7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila4_id_projeto_70b665a7] ON [dbo].[correcoes_fila4]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_fila4_redacao_id_41de18a3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_fila4_redacao_id_41de18a3] ON [dbo].[correcoes_fila4]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filaauditoria_id_correcao_ed6208ef]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filaauditoria_id_correcao_ed6208ef] ON [dbo].[correcoes_filaauditoria]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filaauditoria_id_corretor_2ad28b0c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filaauditoria_id_corretor_2ad28b0c] ON [dbo].[correcoes_filaauditoria]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filaauditoria_id_projeto_3726542d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filaauditoria_id_projeto_3726542d] ON [dbo].[correcoes_filaauditoria]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filaauditoria_redacao_id_9b5efee8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filaauditoria_redacao_id_9b5efee8] ON [dbo].[correcoes_filaauditoria]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filaauditoria_tipo_id_1df39e96]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filaauditoria_tipo_id_1df39e96] ON [dbo].[correcoes_filaauditoria]
(
	[tipo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filaordem_id_projeto_e328a6cf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filaordem_id_projeto_e328a6cf] ON [dbo].[correcoes_filaordem]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filaouro_id_corretor_2068e85a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filaouro_id_corretor_2068e85a] ON [dbo].[correcoes_filaouro]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filaouro_id_projeto_80a4178f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filaouro_id_projeto_80a4178f] ON [dbo].[correcoes_filaouro]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filapessoal_id_correcao_5bf42741]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filapessoal_id_correcao_5bf42741] ON [dbo].[correcoes_filapessoal]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filapessoal_id_corretor_665e67e6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filapessoal_id_corretor_665e67e6] ON [dbo].[correcoes_filapessoal]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filapessoal_id_grupo_corretor_95649252]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filapessoal_id_grupo_corretor_95649252] ON [dbo].[correcoes_filapessoal]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filapessoal_id_projeto_8359cb0a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filapessoal_id_projeto_8359cb0a] ON [dbo].[correcoes_filapessoal]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filapessoal_id_tipo_correcao_3f701c38]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filapessoal_id_tipo_correcao_3f701c38] ON [dbo].[correcoes_filapessoal]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_filapessoal_redacao_id_8a859bef]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_filapessoal_redacao_id_8a859bef] ON [dbo].[correcoes_filapessoal]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_gabarito_id_correcao_situacao_4681e44d_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_gabarito_id_correcao_situacao_4681e44d_idx] ON [dbo].[correcoes_gabarito]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_graficocorrecoes_id_corretor_54d5f7f5]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_graficocorrecoes_id_corretor_54d5f7f5] ON [dbo].[correcoes_graficocorrecoes]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_historicocorrecao_correcao_id_5eca3e82]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_historicocorrecao_correcao_id_5eca3e82] ON [dbo].[correcoes_historicocorrecao]
(
	[correcao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_historicocorrecao_evento_id_e2f2a72c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_historicocorrecao_evento_id_e2f2a72c] ON [dbo].[correcoes_historicocorrecao]
(
	[evento_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_historicocorrecao_usuario_id_62f35e1b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_historicocorrecao_usuario_id_62f35e1b] ON [dbo].[correcoes_historicocorrecao]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_motivoredacao_redacao_substituida_id_6e2ffdcd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_motivoredacao_redacao_substituida_id_6e2ffdcd] ON [dbo].[correcoes_motivoredacao]
(
	[redacao_substituida_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [correcoes_motivoredacao_tipo_id_16681c8e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_motivoredacao_tipo_id_16681c8e] ON [dbo].[correcoes_motivoredacao]
(
	[tipo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_pendenteanalise_id_correcao_a89725b0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_pendenteanalise_id_correcao_a89725b0] ON [dbo].[correcoes_pendenteanalise]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_pendenteanalise_id_projeto_a000aa77]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_pendenteanalise_id_projeto_a000aa77] ON [dbo].[correcoes_pendenteanalise]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_pendenteanalise_id_tipo_correcao_512160b8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_pendenteanalise_id_tipo_correcao_512160b8] ON [dbo].[correcoes_pendenteanalise]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_pendenteanalise_redacao_id_b2c36df0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_pendenteanalise_redacao_id_b2c36df0] ON [dbo].[correcoes_pendenteanalise]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_reciclagem_id_corretor_6ec4258e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_reciclagem_id_corretor_6ec4258e] ON [dbo].[correcoes_reciclagem]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacao_id_correcao_situacao_5ae2b1e7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacao_id_correcao_situacao_5ae2b1e7] ON [dbo].[correcoes_redacao]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacao_id_projeto_d67c403f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacao_id_projeto_d67c403f] ON [dbo].[correcoes_redacao]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacao_id_redacao_situacao_145e0e9b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacao_id_redacao_situacao_145e0e9b] ON [dbo].[correcoes_redacao]
(
	[id_redacao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacao_id_redacaoouro_5713c979]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacao_id_redacaoouro_5713c979] ON [dbo].[correcoes_redacao]
(
	[id_redacaoouro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacao_id_status_4bf461fe]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacao_id_status_4bf461fe] ON [dbo].[correcoes_redacao]
(
	[id_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacao_motivo_id_54d8f6fd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacao_motivo_id_54d8f6fd] ON [dbo].[correcoes_redacao]
(
	[motivo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ix__correcoes_redacao__nota_final]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ix__correcoes_redacao__nota_final] ON [dbo].[correcoes_redacao]
(
	[nota_final] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaobranco_id_projeto_a9203d6c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaobranco_id_projeto_a9203d6c] ON [dbo].[correcoes_redacaobranco]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaobranco_id_redacao_situacao_c5d24cc0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaobranco_id_redacao_situacao_c5d24cc0] ON [dbo].[correcoes_redacaobranco]
(
	[id_redacao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaoinsuficiente_id_projeto_756953b3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaoinsuficiente_id_projeto_756953b3] ON [dbo].[correcoes_redacaoinsuficiente]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaoinsuficiente_id_redacao_situacao_9757b133]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaoinsuficiente_id_redacao_situacao_9757b133] ON [dbo].[correcoes_redacaoinsuficiente]
(
	[id_redacao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaomoda_id_projeto_9cd3423b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaomoda_id_projeto_9cd3423b] ON [dbo].[correcoes_redacaomoda]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaomoda_id_redacao_situacao_f65e2105]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaomoda_id_redacao_situacao_f65e2105] ON [dbo].[correcoes_redacaomoda]
(
	[id_redacao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaoouro_id_correcao_situacao_b95143e9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaoouro_id_correcao_situacao_b95143e9] ON [dbo].[correcoes_redacaoouro]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaoouro_id_origem_802f0b29]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaoouro_id_origem_802f0b29] ON [dbo].[correcoes_redacaoouro]
(
	[id_origem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaoouro_id_projeto_743c3f5e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaoouro_id_projeto_743c3f5e] ON [dbo].[correcoes_redacaoouro]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaoouro_id_redacaotipo_215ab5b7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaoouro_id_redacaotipo_215ab5b7] ON [dbo].[correcoes_redacaoouro]
(
	[id_redacaotipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_redacaoouro_redacao_id_e15b52c0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_redacaoouro_redacao_id_e15b52c0] ON [dbo].[correcoes_redacaoouro]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_suspensao_id_corretor_8b74a490]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_suspensao_id_corretor_8b74a490] ON [dbo].[correcoes_suspensao]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_tipoindicador_id_tipo_periodicidade_indicador_44511e8c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_tipoindicador_id_tipo_periodicidade_indicador_44511e8c] ON [dbo].[correcoes_tipoindicador]
(
	[id_tipo_periodicidade_indicador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_triagemfea_atualizado_por_id_b4a9285a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_triagemfea_atualizado_por_id_b4a9285a] ON [dbo].[correcoes_triagemfea]
(
	[atualizado_por_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_triagemfea_destinado_a_id_7764ff8a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_triagemfea_destinado_a_id_7764ff8a] ON [dbo].[correcoes_triagemfea]
(
	[destinado_a_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [correcoes_triagemfea_redacao_id_3acf184f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [correcoes_triagemfea_redacao_id_3acf184f] ON [dbo].[correcoes_triagemfea]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_admin_log_content_type_id_c4bce8eb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_admin_log_content_type_id_c4bce8eb] ON [dbo].[django_admin_log]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_admin_log_user_id_c564eba6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_admin_log_user_id_c564eba6] ON [dbo].[django_admin_log]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [django_cron_cronjoblog_code_48865653]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_cron_cronjoblog_code_48865653] ON [dbo].[django_cron_cronjoblog]
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [django_cron_cronjoblog_code_is_success_ran_at_time_84da9606_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_cron_cronjoblog_code_is_success_ran_at_time_84da9606_idx] ON [dbo].[django_cron_cronjoblog]
(
	[code] ASC,
	[is_success] ASC,
	[ran_at_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [django_cron_cronjoblog_code_start_time_4fc78f9d_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_cron_cronjoblog_code_start_time_4fc78f9d_idx] ON [dbo].[django_cron_cronjoblog]
(
	[code] ASC,
	[start_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [django_cron_cronjoblog_code_start_time_ran_at_time_8b50b8fa_idx]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_cron_cronjoblog_code_start_time_ran_at_time_8b50b8fa_idx] ON [dbo].[django_cron_cronjoblog]
(
	[code] ASC,
	[start_time] ASC,
	[ran_at_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_cron_cronjoblog_end_time_7918602a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_cron_cronjoblog_end_time_7918602a] ON [dbo].[django_cron_cronjoblog]
(
	[end_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_cron_cronjoblog_ran_at_time_7fed2751]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_cron_cronjoblog_ran_at_time_7fed2751] ON [dbo].[django_cron_cronjoblog]
(
	[ran_at_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_cron_cronjoblog_start_time_d68c0dd9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_cron_cronjoblog_start_time_d68c0dd9] ON [dbo].[django_cron_cronjoblog]
(
	[start_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [django_session_expire_date_a5c62663]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [django_session_expire_date_a5c62663] ON [dbo].[django_session]
(
	[expire_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [external_auth_token_usuario_id_7346c65b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [external_auth_token_usuario_id_7346c65b] ON [dbo].[external_auth_token]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_alerta_alerta_history_user_id_80df8e0f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_alerta_alerta_history_user_id_80df8e0f] ON [dbo].[log_alerta_alerta]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_alerta_alerta_id_f4d98106]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_alerta_alerta_id_f4d98106] ON [dbo].[log_alerta_alerta]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_alerta_alerta_id_tipo_f384b36c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_alerta_alerta_id_tipo_f384b36c] ON [dbo].[log_alerta_alerta]
(
	[id_tipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_alerta_alerta_id_usuario_1c6622f6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_alerta_alerta_id_usuario_1c6622f6] ON [dbo].[log_alerta_alerta]
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_alerta_tipo_history_user_id_7a8831d5]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_alerta_tipo_history_user_id_7a8831d5] ON [dbo].[log_alerta_tipo]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_alerta_tipo_id_07cb90eb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_alerta_tipo_id_07cb90eb] ON [dbo].[log_alerta_tipo]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_group_history_user_id_421514bf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_group_history_user_id_421514bf] ON [dbo].[log_auth_group]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_group_id_25607c03]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_group_id_25607c03] ON [dbo].[log_auth_group]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [log_auth_group_name_91fb1e3d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_group_name_91fb1e3d] ON [dbo].[log_auth_group]
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_group_permissions_group_id_1326b71b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_group_permissions_group_id_1326b71b] ON [dbo].[log_auth_group_permissions]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_group_permissions_history_user_id_fa9cae37]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_group_permissions_history_user_id_fa9cae37] ON [dbo].[log_auth_group_permissions]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_group_permissions_id_7af42202]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_group_permissions_id_7af42202] ON [dbo].[log_auth_group_permissions]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_group_permissions_permission_id_8fd2c3be]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_group_permissions_permission_id_8fd2c3be] ON [dbo].[log_auth_group_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_permission_content_type_id_33757c13]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_permission_content_type_id_33757c13] ON [dbo].[log_auth_permission]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_permission_history_user_id_f96a3477]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_permission_history_user_id_f96a3477] ON [dbo].[log_auth_permission]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_permission_id_a17664fa]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_permission_id_a17664fa] ON [dbo].[log_auth_permission]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_history_user_id_3a0d8fc4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_history_user_id_3a0d8fc4] ON [dbo].[log_auth_user]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_id_c8c732be]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_id_c8c732be] ON [dbo].[log_auth_user]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [log_auth_user_username_3427b32d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_username_3427b32d] ON [dbo].[log_auth_user]
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_groups_group_id_a8b1a3a8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_groups_group_id_a8b1a3a8] ON [dbo].[log_auth_user_groups]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_groups_history_user_id_b16d467d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_groups_history_user_id_b16d467d] ON [dbo].[log_auth_user_groups]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_groups_id_efc05067]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_groups_id_efc05067] ON [dbo].[log_auth_user_groups]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_groups_user_id_a7cf5927]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_groups_user_id_a7cf5927] ON [dbo].[log_auth_user_groups]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_user_permissions_history_user_id_47c67586]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_user_permissions_history_user_id_47c67586] ON [dbo].[log_auth_user_user_permissions]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_user_permissions_id_c26c0b95]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_user_permissions_id_c26c0b95] ON [dbo].[log_auth_user_user_permissions]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_user_permissions_permission_id_01b4254d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_user_permissions_permission_id_01b4254d] ON [dbo].[log_auth_user_user_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_auth_user_user_permissions_user_id_fef2c620]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_auth_user_user_permissions_user_id_fef2c620] ON [dbo].[log_auth_user_user_permissions]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_avisos_aviso_history_user_id_d0dfaf47]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_avisos_aviso_history_user_id_d0dfaf47] ON [dbo].[log_avisos_aviso]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_avisos_aviso_id_18be04f6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_avisos_aviso_id_18be04f6] ON [dbo].[log_avisos_aviso]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_avisos_aviso_id_hierarquia_9f22dc84]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_avisos_aviso_id_hierarquia_9f22dc84] ON [dbo].[log_avisos_aviso]
(
	[id_hierarquia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_avisos_avisousuario_history_user_id_a9fe9e50]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_avisos_avisousuario_history_user_id_a9fe9e50] ON [dbo].[log_avisos_avisousuario]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_avisos_avisousuario_id_aviso_aca87240]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_avisos_avisousuario_id_aviso_aca87240] ON [dbo].[log_avisos_avisousuario]
(
	[id_aviso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_avisos_avisousuario_id_b4bdc027]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_avisos_avisousuario_id_b4bdc027] ON [dbo].[log_avisos_avisousuario]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_avisos_avisousuario_id_usuario_86d0ff10]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_avisos_avisousuario_id_usuario_86d0ff10] ON [dbo].[log_avisos_avisousuario]
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_atualizado_por_a16151d5]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_atualizado_por_a16151d5] ON [dbo].[log_chamados_chamado]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_autor_id_e64e0f4e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_autor_id_e64e0f4e] ON [dbo].[log_chamados_chamado]
(
	[autor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_correcao_id_dae4db21]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_correcao_id_dae4db21] ON [dbo].[log_chamados_chamado]
(
	[correcao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_history_user_id_3cc64b2f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_history_user_id_3cc64b2f] ON [dbo].[log_chamados_chamado]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_id_3d867cc8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_id_3d867cc8] ON [dbo].[log_chamados_chamado]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_responsavel_atual_804a9b67]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_responsavel_atual_804a9b67] ON [dbo].[log_chamados_chamado]
(
	[responsavel_atual] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_responsavel_padrao_189ddb85]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_responsavel_padrao_189ddb85] ON [dbo].[log_chamados_chamado]
(
	[responsavel_padrao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_status_id_80654d80]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_status_id_80654d80] ON [dbo].[log_chamados_chamado]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticket_tipo_id_361f34e6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticket_tipo_id_361f34e6] ON [dbo].[log_chamados_chamado]
(
	[tipo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticketchat_answerable_id_fa7035ab]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticketchat_answerable_id_fa7035ab] ON [dbo].[log_chamados_responsabilidade]
(
	[responsavel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticketchat_author_id_768864b3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticketchat_author_id_768864b3] ON [dbo].[log_chamados_responsabilidade]
(
	[autor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticketchat_history_user_id_3f22e8b1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticketchat_history_user_id_3f22e8b1] ON [dbo].[log_chamados_responsabilidade]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticketchat_id_e41192eb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticketchat_id_e41192eb] ON [dbo].[log_chamados_responsabilidade]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticketchat_status_id_93c2fc53]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticketchat_status_id_93c2fc53] ON [dbo].[log_chamados_responsabilidade]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticketchat_ticket_id_ccf66ec7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticketchat_ticket_id_ccf66ec7] ON [dbo].[log_chamados_responsabilidade]
(
	[chamado_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticketchatstatus_history_user_id_5ed14aea]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticketchatstatus_history_user_id_5ed14aea] ON [dbo].[log_chamados_responsabilidadestatus]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ticket_ticketchatstatus_id_4d9562e3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ticket_ticketchatstatus_id_4d9562e3] ON [dbo].[log_chamados_responsabilidadestatus]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_chats_mensagem_history_user_id_26ba3847]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_chats_mensagem_history_user_id_26ba3847] ON [dbo].[log_chats_mensagem]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_chats_mensagem_id_bb5db2ff]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_chats_mensagem_id_bb5db2ff] ON [dbo].[log_chats_mensagem]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_chats_mensagem_id_destinatario_4ea8767a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_chats_mensagem_id_destinatario_4ea8767a] ON [dbo].[log_chats_mensagem]
(
	[id_destinatario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_chats_mensagem_id_remetente_e7a2fcb0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_chats_mensagem_id_remetente_e7a2fcb0] ON [dbo].[log_chats_mensagem]
(
	[id_remetente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_controlehorarioambiente_history_user_id_c57daa95]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_controlehorarioambiente_history_user_id_c57daa95] ON [dbo].[log_core_controlehorarioambiente]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_controlehorarioambiente_id_bae4b324]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_controlehorarioambiente_id_bae4b324] ON [dbo].[log_core_controlehorarioambiente]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [log_core_feature_codigo_9d63c2bd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_feature_codigo_9d63c2bd] ON [dbo].[log_core_feature]
(
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_feature_history_user_id_95a5a11d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_feature_history_user_id_95a5a11d] ON [dbo].[log_core_feature]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_feature_id_cd9ab77a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_feature_id_cd9ab77a] ON [dbo].[log_core_feature]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_mensagem_history_user_id_9f2001e8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_mensagem_history_user_id_9f2001e8] ON [dbo].[log_core_mensagem]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_mensagem_id_b25440e3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_mensagem_id_b25440e3] ON [dbo].[log_core_mensagem]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_notificacao_history_user_id_d094019b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_notificacao_history_user_id_d094019b] ON [dbo].[log_core_notificacao]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_notificacao_id_0f469cdf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_notificacao_id_0f469cdf] ON [dbo].[log_core_notificacao]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_notificacaogrupo_history_user_id_c4957b17]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_notificacaogrupo_history_user_id_c4957b17] ON [dbo].[log_core_notificacaogrupo]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_notificacaogrupo_id_7130194c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_notificacaogrupo_id_7130194c] ON [dbo].[log_core_notificacaogrupo]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_notificacaogrupo_id_grupo_9e3a7ac1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_notificacaogrupo_id_grupo_9e3a7ac1] ON [dbo].[log_core_notificacaogrupo]
(
	[id_grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_notificacaogrupo_id_notificacao_e4455b47]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_notificacaogrupo_id_notificacao_e4455b47] ON [dbo].[log_core_notificacaogrupo]
(
	[id_notificacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_parametros_history_user_id_bd45bcc3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_parametros_history_user_id_bd45bcc3] ON [dbo].[log_core_parametros]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_core_parametros_id_f85ef53c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_parametros_id_f85ef53c] ON [dbo].[log_core_parametros]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [log_core_parametros_nome_8df1d65a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_core_parametros_nome_8df1d65a] ON [dbo].[log_core_parametros]
(
	[nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_data_termino_A_855bc39a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_data_termino_A_855bc39a] ON [dbo].[log_correcoes_analise]
(
	[data_termino_A] ASC
)
INCLUDE ( 	[id_tipo_correcao_A],
	[id_tipo_correcao_B],
	[id_corretor_A],
	[conclusao_analise]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_data_termino_B_f6703d14]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_data_termino_B_f6703d14] ON [dbo].[log_correcoes_analise]
(
	[data_termino_B] ASC
)
INCLUDE ( 	[id_tipo_correcao_A],
	[id_tipo_correcao_B],
	[id_corretor_B],
	[conclusao_analise]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_history_user_id_9f0fd72d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_history_user_id_9f0fd72d] ON [dbo].[log_correcoes_analise]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_id_b6309b04]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_id_b6309b04] ON [dbo].[log_correcoes_analise]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_id_correcao_A_63122a27]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_id_correcao_A_63122a27] ON [dbo].[log_correcoes_analise]
(
	[id_correcao_A] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_id_correcao_B_117fe964]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_id_correcao_B_117fe964] ON [dbo].[log_correcoes_analise]
(
	[id_correcao_B] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_id_correcao_situacao_A_c7b07198]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_id_correcao_situacao_A_c7b07198] ON [dbo].[log_correcoes_analise]
(
	[id_correcao_situacao_A] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_id_correcao_situacao_B_be081eef]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_id_correcao_situacao_B_be081eef] ON [dbo].[log_correcoes_analise]
(
	[id_correcao_situacao_B] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_id_corretor_A_3fd75e26]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_id_corretor_A_3fd75e26] ON [dbo].[log_correcoes_analise]
(
	[id_corretor_A] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_id_corretor_B_93cfcc93]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_id_corretor_B_93cfcc93] ON [dbo].[log_correcoes_analise]
(
	[id_corretor_B] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_id_projeto_4f7b5a0b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_id_projeto_4f7b5a0b] ON [dbo].[log_correcoes_analise]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_analise_redacao_id_9a1d316f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_analise_redacao_id_9a1d316f] ON [dbo].[log_correcoes_analise]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_contador_history_user_id_86a2d363]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_contador_history_user_id_86a2d363] ON [dbo].[log_correcoes_contador]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_contador_id_2320e06e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_contador_id_2320e06e] ON [dbo].[log_correcoes_contador]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_contador_id_corretor_e30a1f06]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_contador_id_corretor_e30a1f06] ON [dbo].[log_correcoes_contador]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_atualizado_por_f69a60cd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_atualizado_por_f69a60cd] ON [dbo].[log_correcoes_correcao]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_history_user_id_39f73e90]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_history_user_id_39f73e90] ON [dbo].[log_correcoes_correcao]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_id_91442eeb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_id_91442eeb] ON [dbo].[log_correcoes_correcao]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_id_auxiliar1_a0f03276]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_id_auxiliar1_a0f03276] ON [dbo].[log_correcoes_correcao]
(
	[id_auxiliar1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_id_auxiliar2_d2a8ea89]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_id_auxiliar2_d2a8ea89] ON [dbo].[log_correcoes_correcao]
(
	[id_auxiliar2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_id_correcao_situacao_4657085c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_id_correcao_situacao_4657085c] ON [dbo].[log_correcoes_correcao]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_id_corretor_8aa069ce]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_id_corretor_8aa069ce] ON [dbo].[log_correcoes_correcao]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_id_projeto_028ba80a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_id_projeto_028ba80a] ON [dbo].[log_correcoes_correcao]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_id_status_31ecc080]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_id_status_31ecc080] ON [dbo].[log_correcoes_correcao]
(
	[id_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_id_tipo_correcao_d602cfb9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_id_tipo_correcao_d602cfb9] ON [dbo].[log_correcoes_correcao]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_redacao_id_47bfa6da]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_redacao_id_47bfa6da] ON [dbo].[log_correcoes_correcao]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcao_tipo_auditoria_id_9df279d6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcao_tipo_auditoria_id_9df279d6] ON [dbo].[log_correcoes_correcao]
(
	[tipo_auditoria_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_atualizado_por_4fb018e8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_atualizado_por_4fb018e8] ON [dbo].[log_correcoes_correcaomoda]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_history_user_id_7e4a1aa4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_history_user_id_7e4a1aa4] ON [dbo].[log_correcoes_correcaomoda]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_id_auxiliar1_f8f5f084]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_id_auxiliar1_f8f5f084] ON [dbo].[log_correcoes_correcaomoda]
(
	[id_auxiliar1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_id_auxiliar2_f26bb307]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_id_auxiliar2_f26bb307] ON [dbo].[log_correcoes_correcaomoda]
(
	[id_auxiliar2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_id_correcao_situacao_c2a0a31a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_id_correcao_situacao_c2a0a31a] ON [dbo].[log_correcoes_correcaomoda]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_id_corretor_d71af4e0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_id_corretor_d71af4e0] ON [dbo].[log_correcoes_correcaomoda]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_id_d84485e7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_id_d84485e7] ON [dbo].[log_correcoes_correcaomoda]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_id_projeto_5ba8fcca]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_id_projeto_5ba8fcca] ON [dbo].[log_correcoes_correcaomoda]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_id_status_0c0ad981]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_id_status_0c0ad981] ON [dbo].[log_correcoes_correcaomoda]
(
	[id_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_id_tipo_correcao_dd309840]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_id_tipo_correcao_dd309840] ON [dbo].[log_correcoes_correcaomoda]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaomoda_redacao_id_8ce23ffb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaomoda_redacao_id_8ce23ffb] ON [dbo].[log_correcoes_correcaomoda]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_atualizado_por_3ba596ea]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_atualizado_por_3ba596ea] ON [dbo].[log_correcoes_correcaoouro]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_history_user_id_b3456be4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_history_user_id_b3456be4] ON [dbo].[log_correcoes_correcaoouro]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_id_auxiliar1_cb61074a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_id_auxiliar1_cb61074a] ON [dbo].[log_correcoes_correcaoouro]
(
	[id_auxiliar1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_id_auxiliar2_d99287c4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_id_auxiliar2_d99287c4] ON [dbo].[log_correcoes_correcaoouro]
(
	[id_auxiliar2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_id_correcao_situacao_15808de7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_id_correcao_situacao_15808de7] ON [dbo].[log_correcoes_correcaoouro]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_id_corretor_0c98b5a8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_id_corretor_0c98b5a8] ON [dbo].[log_correcoes_correcaoouro]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_id_e9c5a2ad]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_id_e9c5a2ad] ON [dbo].[log_correcoes_correcaoouro]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_id_projeto_236d01bd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_id_projeto_236d01bd] ON [dbo].[log_correcoes_correcaoouro]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_id_status_9b2bf758]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_id_status_9b2bf758] ON [dbo].[log_correcoes_correcaoouro]
(
	[id_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_id_tipo_correcao_753bc251]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_id_tipo_correcao_753bc251] ON [dbo].[log_correcoes_correcaoouro]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_correcaoouro_redacao_id_0be2c34e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_correcaoouro_redacao_id_0be2c34e] ON [dbo].[log_correcoes_correcaoouro]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_atualizado_por_511e62bb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_atualizado_por_511e62bb] ON [dbo].[log_correcoes_corretor]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_history_user_id_05ea15c5]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_history_user_id_05ea15c5] ON [dbo].[log_correcoes_corretor]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_id_1fe5bced]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_id_1fe5bced] ON [dbo].[log_correcoes_corretor]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_id_grupo_1d9e98b6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_id_grupo_1d9e98b6] ON [dbo].[log_correcoes_corretor]
(
	[id_grupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_status_id_cbed21fc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_status_id_cbed21fc] ON [dbo].[log_correcoes_corretor]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_indicadores_history_user_id_e8e4ba1d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_indicadores_history_user_id_e8e4ba1d] ON [dbo].[log_correcoes_corretor_indicadores]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_indicadores_id_3c479a5f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_indicadores_id_3c479a5f] ON [dbo].[log_correcoes_corretor_indicadores]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_indicadores_id_usuario_responsavel_46de041d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_indicadores_id_usuario_responsavel_46de041d] ON [dbo].[log_correcoes_corretor_indicadores]
(
	[id_usuario_responsavel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_indicadores_projeto_id_8960b358]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_indicadores_projeto_id_8960b358] ON [dbo].[log_correcoes_corretor_indicadores]
(
	[projeto_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_corretor_indicadores_usuario_id_6dad7859]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_corretor_indicadores_usuario_id_6dad7859] ON [dbo].[log_correcoes_corretor_indicadores]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila1_history_user_id_4bf431fb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila1_history_user_id_4bf431fb] ON [dbo].[log_correcoes_fila1]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila1_id_ae6c8834]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila1_id_ae6c8834] ON [dbo].[log_correcoes_fila1]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila1_id_correcao_f3ef7da3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila1_id_correcao_f3ef7da3] ON [dbo].[log_correcoes_fila1]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila1_id_grupo_corretor_18bdf70d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila1_id_grupo_corretor_18bdf70d] ON [dbo].[log_correcoes_fila1]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila1_id_projeto_99f146bc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila1_id_projeto_99f146bc] ON [dbo].[log_correcoes_fila1]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila1_redacao_id_b257af5d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila1_redacao_id_b257af5d] ON [dbo].[log_correcoes_fila1]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila2_history_user_id_fde58f31]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila2_history_user_id_fde58f31] ON [dbo].[log_correcoes_fila2]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila2_id_correcao_525f6925]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila2_id_correcao_525f6925] ON [dbo].[log_correcoes_fila2]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila2_id_f331cf74]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila2_id_f331cf74] ON [dbo].[log_correcoes_fila2]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila2_id_grupo_corretor_04cb4a27]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila2_id_grupo_corretor_04cb4a27] ON [dbo].[log_correcoes_fila2]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila2_id_projeto_d5cc04dc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila2_id_projeto_d5cc04dc] ON [dbo].[log_correcoes_fila2]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila2_redacao_id_8e27c791]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila2_redacao_id_8e27c791] ON [dbo].[log_correcoes_fila2]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila3_history_user_id_f2e639e1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila3_history_user_id_f2e639e1] ON [dbo].[log_correcoes_fila3]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila3_id_711a11f1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila3_id_711a11f1] ON [dbo].[log_correcoes_fila3]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila3_id_correcao_bb1d2554]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila3_id_correcao_bb1d2554] ON [dbo].[log_correcoes_fila3]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila3_id_grupo_corretor_bd4e0f47]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila3_id_grupo_corretor_bd4e0f47] ON [dbo].[log_correcoes_fila3]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila3_id_projeto_aa04d965]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila3_id_projeto_aa04d965] ON [dbo].[log_correcoes_fila3]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila3_redacao_id_5843c057]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila3_redacao_id_5843c057] ON [dbo].[log_correcoes_fila3]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila4_history_user_id_b9d8c79e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila4_history_user_id_b9d8c79e] ON [dbo].[log_correcoes_fila4]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila4_id_763f7b29]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila4_id_763f7b29] ON [dbo].[log_correcoes_fila4]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila4_id_correcao_c80222d7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila4_id_correcao_c80222d7] ON [dbo].[log_correcoes_fila4]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila4_id_grupo_corretor_15474aa4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila4_id_grupo_corretor_15474aa4] ON [dbo].[log_correcoes_fila4]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila4_id_projeto_a5de4360]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila4_id_projeto_a5de4360] ON [dbo].[log_correcoes_fila4]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_fila4_redacao_id_e48d64e6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_fila4_redacao_id_e48d64e6] ON [dbo].[log_correcoes_fila4]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaauditoria_history_user_id_5d22da86]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaauditoria_history_user_id_5d22da86] ON [dbo].[log_correcoes_filaauditoria]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaauditoria_id_32cb778a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaauditoria_id_32cb778a] ON [dbo].[log_correcoes_filaauditoria]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaauditoria_id_correcao_d1e7151e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaauditoria_id_correcao_d1e7151e] ON [dbo].[log_correcoes_filaauditoria]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaauditoria_id_corretor_a648284a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaauditoria_id_corretor_a648284a] ON [dbo].[log_correcoes_filaauditoria]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaauditoria_id_projeto_7fdc52a9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaauditoria_id_projeto_7fdc52a9] ON [dbo].[log_correcoes_filaauditoria]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaauditoria_redacao_id_f0183a93]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaauditoria_redacao_id_f0183a93] ON [dbo].[log_correcoes_filaauditoria]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaauditoria_tipo_id_ca0ff402]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaauditoria_tipo_id_ca0ff402] ON [dbo].[log_correcoes_filaauditoria]
(
	[tipo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaordem_history_user_id_9bd115ba]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaordem_history_user_id_9bd115ba] ON [dbo].[log_correcoes_filaordem]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaordem_id_03fd0b01]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaordem_id_03fd0b01] ON [dbo].[log_correcoes_filaordem]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaordem_id_projeto_f1835c0a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaordem_id_projeto_f1835c0a] ON [dbo].[log_correcoes_filaordem]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaouro_history_user_id_e2230615]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaouro_history_user_id_e2230615] ON [dbo].[log_correcoes_filaouro]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaouro_id_3b389fb9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaouro_id_3b389fb9] ON [dbo].[log_correcoes_filaouro]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaouro_id_corretor_d1280e63]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaouro_id_corretor_d1280e63] ON [dbo].[log_correcoes_filaouro]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaouro_id_projeto_77b7e456]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaouro_id_projeto_77b7e456] ON [dbo].[log_correcoes_filaouro]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filaouro_redacao_id_04dbd999]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filaouro_redacao_id_04dbd999] ON [dbo].[log_correcoes_filaouro]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filapessoal_history_user_id_c42493fe]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filapessoal_history_user_id_c42493fe] ON [dbo].[log_correcoes_filapessoal]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filapessoal_id_4c7eea46]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filapessoal_id_4c7eea46] ON [dbo].[log_correcoes_filapessoal]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filapessoal_id_correcao_562ec4d7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filapessoal_id_correcao_562ec4d7] ON [dbo].[log_correcoes_filapessoal]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filapessoal_id_corretor_d2bfd2e3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filapessoal_id_corretor_d2bfd2e3] ON [dbo].[log_correcoes_filapessoal]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filapessoal_id_grupo_corretor_b712cf38]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filapessoal_id_grupo_corretor_b712cf38] ON [dbo].[log_correcoes_filapessoal]
(
	[id_grupo_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filapessoal_id_projeto_d523172f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filapessoal_id_projeto_d523172f] ON [dbo].[log_correcoes_filapessoal]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filapessoal_id_tipo_correcao_372fc627]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filapessoal_id_tipo_correcao_372fc627] ON [dbo].[log_correcoes_filapessoal]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_filapessoal_redacao_id_8c8d0e78]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_filapessoal_redacao_id_8c8d0e78] ON [dbo].[log_correcoes_filapessoal]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_gabarito_history_user_id_ba4a21dd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_gabarito_history_user_id_ba4a21dd] ON [dbo].[log_correcoes_gabarito]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_gabarito_id_correcao_situacao_b99043c3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_gabarito_id_correcao_situacao_b99043c3] ON [dbo].[log_correcoes_gabarito]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_gabarito_redacao_id_657fd535]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_gabarito_redacao_id_657fd535] ON [dbo].[log_correcoes_gabarito]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_historicocorrecao_correcao_id_b80914f4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_historicocorrecao_correcao_id_b80914f4] ON [dbo].[log_correcoes_historicocorrecao]
(
	[correcao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_historicocorrecao_evento_id_7f5a0262]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_historicocorrecao_evento_id_7f5a0262] ON [dbo].[log_correcoes_historicocorrecao]
(
	[evento_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_historicocorrecao_history_user_id_b2fffd06]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_historicocorrecao_history_user_id_b2fffd06] ON [dbo].[log_correcoes_historicocorrecao]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_historicocorrecao_id_ca665fea]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_historicocorrecao_id_ca665fea] ON [dbo].[log_correcoes_historicocorrecao]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_historicocorrecao_usuario_id_fcb35c9c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_historicocorrecao_usuario_id_fcb35c9c] ON [dbo].[log_correcoes_historicocorrecao]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_pendenteanalise_history_user_id_5f53f7e7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_pendenteanalise_history_user_id_5f53f7e7] ON [dbo].[log_correcoes_pendenteanalise]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_pendenteanalise_id_086c1f34]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_pendenteanalise_id_086c1f34] ON [dbo].[log_correcoes_pendenteanalise]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_pendenteanalise_id_correcao_d6821163]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_pendenteanalise_id_correcao_d6821163] ON [dbo].[log_correcoes_pendenteanalise]
(
	[id_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_pendenteanalise_id_projeto_77158724]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_pendenteanalise_id_projeto_77158724] ON [dbo].[log_correcoes_pendenteanalise]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_pendenteanalise_id_tipo_correcao_b36b6e0b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_pendenteanalise_id_tipo_correcao_b36b6e0b] ON [dbo].[log_correcoes_pendenteanalise]
(
	[id_tipo_correcao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_pendenteanalise_redacao_id_35893c1f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_pendenteanalise_redacao_id_35893c1f] ON [dbo].[log_correcoes_pendenteanalise]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_reciclagem_history_user_id_a37a97d9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_reciclagem_history_user_id_a37a97d9] ON [dbo].[log_correcoes_reciclagem]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_reciclagem_id_3c3c2b56]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_reciclagem_id_3c3c2b56] ON [dbo].[log_correcoes_reciclagem]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_reciclagem_id_corretor_a8505612]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_reciclagem_id_corretor_a8505612] ON [dbo].[log_correcoes_reciclagem]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacao_history_user_id_79e8a2ce]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacao_history_user_id_79e8a2ce] ON [dbo].[log_correcoes_redacao]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacao_id_61fff99b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacao_id_61fff99b] ON [dbo].[log_correcoes_redacao]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacao_id_correcao_situacao_3af4e34f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacao_id_correcao_situacao_3af4e34f] ON [dbo].[log_correcoes_redacao]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacao_id_projeto_2580944c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacao_id_projeto_2580944c] ON [dbo].[log_correcoes_redacao]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacao_id_redacao_situacao_f9679613]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacao_id_redacao_situacao_f9679613] ON [dbo].[log_correcoes_redacao]
(
	[id_redacao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacao_id_redacaoouro_e29bf6cf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacao_id_redacaoouro_e29bf6cf] ON [dbo].[log_correcoes_redacao]
(
	[id_redacaoouro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacao_id_status_c837439d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacao_id_status_c837439d] ON [dbo].[log_correcoes_redacao]
(
	[id_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacao_motivo_id_9748bc53]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacao_motivo_id_9748bc53] ON [dbo].[log_correcoes_redacao]
(
	[motivo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaobranco_history_user_id_f2e9d801]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaobranco_history_user_id_f2e9d801] ON [dbo].[log_correcoes_redacaobranco]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaobranco_id_225f13dc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaobranco_id_225f13dc] ON [dbo].[log_correcoes_redacaobranco]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaobranco_id_projeto_9ee2f30d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaobranco_id_projeto_9ee2f30d] ON [dbo].[log_correcoes_redacaobranco]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaobranco_id_redacao_situacao_7368ce15]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaobranco_id_redacao_situacao_7368ce15] ON [dbo].[log_correcoes_redacaobranco]
(
	[id_redacao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoinsuficiente_history_user_id_4d83f2b0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoinsuficiente_history_user_id_4d83f2b0] ON [dbo].[log_correcoes_redacaoinsuficiente]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoinsuficiente_id_7574cc75]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoinsuficiente_id_7574cc75] ON [dbo].[log_correcoes_redacaoinsuficiente]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoinsuficiente_id_projeto_e5764f82]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoinsuficiente_id_projeto_e5764f82] ON [dbo].[log_correcoes_redacaoinsuficiente]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoinsuficiente_id_redacao_situacao_7ca549bc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoinsuficiente_id_redacao_situacao_7ca549bc] ON [dbo].[log_correcoes_redacaoinsuficiente]
(
	[id_redacao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaomoda_history_user_id_22388652]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaomoda_history_user_id_22388652] ON [dbo].[log_correcoes_redacaomoda]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaomoda_id_15e8d9a5]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaomoda_id_15e8d9a5] ON [dbo].[log_correcoes_redacaomoda]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaomoda_id_projeto_0b5b00ef]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaomoda_id_projeto_0b5b00ef] ON [dbo].[log_correcoes_redacaomoda]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaomoda_id_redacao_situacao_7d98710c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaomoda_id_redacao_situacao_7d98710c] ON [dbo].[log_correcoes_redacaomoda]
(
	[id_redacao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [log_correcoes_redacaoouro_co_barra_redacao_f7b666cf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoouro_co_barra_redacao_f7b666cf] ON [dbo].[log_correcoes_redacaoouro]
(
	[co_barra_redacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoouro_history_user_id_2a25bc31]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoouro_history_user_id_2a25bc31] ON [dbo].[log_correcoes_redacaoouro]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoouro_id_9ec464c6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoouro_id_9ec464c6] ON [dbo].[log_correcoes_redacaoouro]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoouro_id_correcao_situacao_7be23a5a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoouro_id_correcao_situacao_7be23a5a] ON [dbo].[log_correcoes_redacaoouro]
(
	[id_correcao_situacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoouro_id_origem_0f52e123]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoouro_id_origem_0f52e123] ON [dbo].[log_correcoes_redacaoouro]
(
	[id_origem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoouro_id_projeto_492f4bfe]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoouro_id_projeto_492f4bfe] ON [dbo].[log_correcoes_redacaoouro]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoouro_id_redacaotipo_3de40e0d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoouro_id_redacaotipo_3de40e0d] ON [dbo].[log_correcoes_redacaoouro]
(
	[id_redacaotipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_redacaoouro_redacao_id_26875b47]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_redacaoouro_redacao_id_26875b47] ON [dbo].[log_correcoes_redacaoouro]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_suspensao_history_user_id_6cb10a07]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_suspensao_history_user_id_6cb10a07] ON [dbo].[log_correcoes_suspensao]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_suspensao_id_c6964998]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_suspensao_id_c6964998] ON [dbo].[log_correcoes_suspensao]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_suspensao_id_corretor_36f795c6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_suspensao_id_corretor_36f795c6] ON [dbo].[log_correcoes_suspensao]
(
	[id_corretor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_triagemfea_atualizado_por_id_480ff00a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_triagemfea_atualizado_por_id_480ff00a] ON [dbo].[log_correcoes_triagemfea]
(
	[atualizado_por_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_triagemfea_destinado_a_id_913e02c1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_triagemfea_destinado_a_id_913e02c1] ON [dbo].[log_correcoes_triagemfea]
(
	[destinado_a_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_triagemfea_history_user_id_87652d54]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_triagemfea_history_user_id_87652d54] ON [dbo].[log_correcoes_triagemfea]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_triagemfea_id_8a447f7d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_triagemfea_id_8a447f7d] ON [dbo].[log_correcoes_triagemfea]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_correcoes_triagemfea_redacao_id_c28a714c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_correcoes_triagemfea_redacao_id_c28a714c] ON [dbo].[log_correcoes_triagemfea]
(
	[redacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_external_auth_login_history_user_id_686a03c1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_external_auth_login_history_user_id_686a03c1] ON [dbo].[log_external_auth_login]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_external_auth_login_id_4a959c20]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_external_auth_login_id_4a959c20] ON [dbo].[log_external_auth_login]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_external_auth_token_history_user_id_629f99a1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_external_auth_token_history_user_id_629f99a1] ON [dbo].[log_external_auth_token]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_external_auth_token_id_43aee2ff]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_external_auth_token_id_43aee2ff] ON [dbo].[log_external_auth_token]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_external_auth_token_usuario_id_8829d101]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_external_auth_token_usuario_id_8829d101] ON [dbo].[log_external_auth_token]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_emaillote_history_user_id_33c6fa2a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_emaillote_history_user_id_33c6fa2a] ON [dbo].[log_ocorrencias_emaillote]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_emaillote_id_d4652df2]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_emaillote_id_d4652df2] ON [dbo].[log_ocorrencias_emaillote]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_imagemfalha_history_user_id_036e9027]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_imagemfalha_history_user_id_036e9027] ON [dbo].[log_ocorrencias_imagemfalha]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_imagemfalha_id_2f78a268]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_imagemfalha_id_2f78a268] ON [dbo].[log_ocorrencias_imagemfalha]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_imagemfalha_lote_id_dfbafb5b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_imagemfalha_lote_id_dfbafb5b] ON [dbo].[log_ocorrencias_imagemfalha]
(
	[lote_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_imagemfalha_ocorrencia_id_64be6e1b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_imagemfalha_ocorrencia_id_64be6e1b] ON [dbo].[log_ocorrencias_imagemfalha]
(
	[ocorrencia_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_atualizado_por_4b8bcddd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_atualizado_por_4b8bcddd] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_categoria_id_87c947fc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_categoria_id_87c947fc] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[categoria_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_correcao_id_ac3e4942]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_correcao_id_ac3e4942] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[correcao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_history_user_id_b225ea18]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_history_user_id_b225ea18] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_id_2b9b371e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_id_2b9b371e] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_id_projeto_f7d193b2]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_id_projeto_f7d193b2] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_lote_solicitado_id_4cc8af68]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_lote_solicitado_id_4cc8af68] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[lote_solicitado_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_ocorrencia_pai_id_0a572411]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_ocorrencia_pai_id_0a572411] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[ocorrencia_pai_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_ocorrencia_relacionada_id_53f961b7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_ocorrencia_relacionada_id_53f961b7] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[ocorrencia_relacionada_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_situacao_id_e5cc912f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_situacao_id_e5cc912f] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[situacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_status_id_55cd94d0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_status_id_55cd94d0] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_tipo_id_26370d68]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_tipo_id_26370d68] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[tipo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_usuario_autor_id_747bbd86]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_usuario_autor_id_747bbd86] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[usuario_autor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_ocorrencias_ocorrencia_usuario_responsavel_id_dc6f94a3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_ocorrencias_ocorrencia_usuario_responsavel_id_dc6f94a3] ON [dbo].[log_ocorrencias_ocorrencia]
(
	[usuario_responsavel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_projeto_projeto_etapa_ensino_id_a454302d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_projeto_projeto_etapa_ensino_id_a454302d] ON [dbo].[log_projeto_projeto]
(
	[etapa_ensino_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_projeto_projeto_history_user_id_6bb6375b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_projeto_projeto_history_user_id_6bb6375b] ON [dbo].[log_projeto_projeto]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_projeto_projeto_id_5e0e1498]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_projeto_projeto_id_5e0e1498] ON [dbo].[log_projeto_projeto]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_relatorios_mensagem_history_user_id_84a595cd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_relatorios_mensagem_history_user_id_84a595cd] ON [dbo].[log_relatorios_mensagem]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_relatorios_mensagem_id_e9994be7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_relatorios_mensagem_id_e9994be7] ON [dbo].[log_relatorios_mensagem]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_status_corretor_trocastatus_corretor_id_ab3387c7]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_status_corretor_trocastatus_corretor_id_ab3387c7] ON [dbo].[log_status_corretor_trocastatus]
(
	[corretor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_status_corretor_trocastatus_history_user_id_b5a59af3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_status_corretor_trocastatus_history_user_id_b5a59af3] ON [dbo].[log_status_corretor_trocastatus]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_status_corretor_trocastatus_id_31a16e64]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_status_corretor_trocastatus_id_31a16e64] ON [dbo].[log_status_corretor_trocastatus]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_status_corretor_trocastatus_motivo_id_c881bfe9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_status_corretor_trocastatus_motivo_id_c881bfe9] ON [dbo].[log_status_corretor_trocastatus]
(
	[motivo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_status_corretor_trocastatus_status_anterior_id_3d46ceb6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_status_corretor_trocastatus_status_anterior_id_3d46ceb6] ON [dbo].[log_status_corretor_trocastatus]
(
	[status_anterior_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_status_corretor_trocastatus_status_atual_id_b2fcf7e9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_status_corretor_trocastatus_status_atual_id_b2fcf7e9] ON [dbo].[log_status_corretor_trocastatus]
(
	[status_atual_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_hierarquia_history_user_id_85661568]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_hierarquia_history_user_id_85661568] ON [dbo].[log_usuarios_hierarquia]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_hierarquia_id_a2bbf288]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_hierarquia_id_a2bbf288] ON [dbo].[log_usuarios_hierarquia]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_hierarquia_id_hierarquia_usuario_pai_28391b94]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_hierarquia_id_hierarquia_usuario_pai_28391b94] ON [dbo].[log_usuarios_hierarquia]
(
	[id_hierarquia_usuario_pai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_hierarquia_id_tipo_hierarquia_usuario_b3457a5c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_hierarquia_id_tipo_hierarquia_usuario_b3457a5c] ON [dbo].[log_usuarios_hierarquia]
(
	[id_tipo_hierarquia_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_hierarquia_id_usuario_responsavel_e25d9aba]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_hierarquia_id_usuario_responsavel_e25d9aba] ON [dbo].[log_usuarios_hierarquia]
(
	[id_usuario_responsavel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_mudancatime_atualizado_por_bb88e893]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_mudancatime_atualizado_por_bb88e893] ON [dbo].[log_usuarios_mudancatime]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_mudancatime_history_user_id_15184fd4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_mudancatime_history_user_id_15184fd4] ON [dbo].[log_usuarios_mudancatime]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_mudancatime_id_1d174bbf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_mudancatime_id_1d174bbf] ON [dbo].[log_usuarios_mudancatime]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_mudancatime_id_coordenador_62e2d20c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_mudancatime_id_coordenador_62e2d20c] ON [dbo].[log_usuarios_mudancatime]
(
	[id_coordenador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_mudancatime_id_time_anterior_52a131b1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_mudancatime_id_time_anterior_52a131b1] ON [dbo].[log_usuarios_mudancatime]
(
	[id_time_anterior] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_mudancatime_id_time_atual_1010ac51]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_mudancatime_id_time_atual_1010ac51] ON [dbo].[log_usuarios_mudancatime]
(
	[id_time_atual] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_mudancatime_id_usuario_a8d22f8f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_mudancatime_id_usuario_a8d22f8f] ON [dbo].[log_usuarios_mudancatime]
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_pessoa_history_user_id_8b44917a]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_pessoa_history_user_id_8b44917a] ON [dbo].[log_usuarios_pessoa]
(
	[history_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_pessoa_id_95363e63]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_pessoa_id_95363e63] ON [dbo].[log_usuarios_pessoa]
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [log_usuarios_pessoa_usuario_id_91b20088]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [log_usuarios_pessoa_usuario_id_91b20088] ON [dbo].[log_usuarios_pessoa]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_imagemfalha_lote_id_bac2ab74]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_imagemfalha_lote_id_bac2ab74] ON [dbo].[ocorrencias_imagemfalha]
(
	[lote_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_atualizado_por_0bd3c1f4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_atualizado_por_0bd3c1f4] ON [dbo].[ocorrencias_ocorrencia]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_categoria_id_1e88daaf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_categoria_id_1e88daaf] ON [dbo].[ocorrencias_ocorrencia]
(
	[categoria_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_correcao_id_cc655c69]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_correcao_id_cc655c69] ON [dbo].[ocorrencias_ocorrencia]
(
	[correcao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_id_projeto_2a2fdf74]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_id_projeto_2a2fdf74] ON [dbo].[ocorrencias_ocorrencia]
(
	[id_projeto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_lote_solicitado_id_2e256bcc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_lote_solicitado_id_2e256bcc] ON [dbo].[ocorrencias_ocorrencia]
(
	[lote_solicitado_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_ocorrencia_pai_id_62e3fca4]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_ocorrencia_pai_id_62e3fca4] ON [dbo].[ocorrencias_ocorrencia]
(
	[ocorrencia_pai_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_ocorrencia_relacionada_id_0b912ea0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_ocorrencia_relacionada_id_0b912ea0] ON [dbo].[ocorrencias_ocorrencia]
(
	[ocorrencia_relacionada_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_situacao_id_8bfac1a6]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_situacao_id_8bfac1a6] ON [dbo].[ocorrencias_ocorrencia]
(
	[situacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_status_id_d8ff1a2f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_status_id_d8ff1a2f] ON [dbo].[ocorrencias_ocorrencia]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_tipo_id_3b2a2594]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_tipo_id_3b2a2594] ON [dbo].[ocorrencias_ocorrencia]
(
	[tipo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_usuario_autor_id_a0f65b05]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_usuario_autor_id_a0f65b05] ON [dbo].[ocorrencias_ocorrencia]
(
	[usuario_autor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_ocorrencia_usuario_responsavel_id_b53c9a1d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_ocorrencia_usuario_responsavel_id_b53c9a1d] ON [dbo].[ocorrencias_ocorrencia]
(
	[usuario_responsavel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_situacao_tipo_alocacao_id_49ec0ada]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_situacao_tipo_alocacao_id_49ec0ada] ON [dbo].[ocorrencias_situacao]
(
	[tipo_alocacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_situacao_tipo_hierarquia_competente_id_9672c080]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_situacao_tipo_hierarquia_competente_id_9672c080] ON [dbo].[ocorrencias_situacao]
(
	[tipo_hierarquia_competente_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_tipo_categoria_id_e88eb445]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_tipo_categoria_id_e88eb445] ON [dbo].[ocorrencias_tipo]
(
	[categoria_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_tipo_tipo_alocacao_id_c7acd92d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_tipo_tipo_alocacao_id_c7acd92d] ON [dbo].[ocorrencias_tipo]
(
	[tipo_alocacao_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [ocorrencias_tipo_tipo_hierarquia_competente_id_c9dab2f1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [ocorrencias_tipo_tipo_hierarquia_competente_id_c9dab2f1] ON [dbo].[ocorrencias_tipo]
(
	[tipo_hierarquia_competente_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [projeto_projeto_etapa_ensino_id_a5e9ce5e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [projeto_projeto_etapa_ensino_id_a5e9ce5e] ON [dbo].[projeto_projeto]
(
	[etapa_ensino_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [projeto_projeto_usuarios_projeto_id_2182f786]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [projeto_projeto_usuarios_projeto_id_2182f786] ON [dbo].[projeto_projeto_usuarios]
(
	[projeto_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [projeto_projeto_usuarios_user_id_19bf2da3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [projeto_projeto_usuarios_user_id_19bf2da3] ON [dbo].[projeto_projeto_usuarios]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_aproveitamento_notas_avaliador_693b3852]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_aproveitamento_notas_avaliador_693b3852] ON [dbo].[relatorios_aproveitamento_notas]
(
	[avaliador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_aproveitamento_notas_indice_bb4a29a0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_aproveitamento_notas_indice_bb4a29a0] ON [dbo].[relatorios_aproveitamento_notas]
(
	[indice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_aproveitamento_notas_polo_descricao_0c309c0b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_aproveitamento_notas_polo_descricao_0c309c0b] ON [dbo].[relatorios_aproveitamento_notas]
(
	[polo_descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_aproveitamento_notas_polo_id_3e295d6d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_aproveitamento_notas_polo_id_3e295d6d] ON [dbo].[relatorios_aproveitamento_notas]
(
	[polo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_aproveitamento_notas_time_descricao_c722ed0b]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_aproveitamento_notas_time_descricao_c722ed0b] ON [dbo].[relatorios_aproveitamento_notas]
(
	[time_descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_aproveitamento_notas_time_id_b476e012]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_aproveitamento_notas_time_id_b476e012] ON [dbo].[relatorios_aproveitamento_notas]
(
	[time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_aproveitamento_notas_usuario_id_cec2a2b9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_aproveitamento_notas_usuario_id_cec2a2b9] ON [dbo].[relatorios_aproveitamento_notas]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_correcoes_usuario_nome_deb41d8e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_correcoes_usuario_nome_deb41d8e] ON [dbo].[relatorios_correcoes_usuario]
(
	[nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_correcoes_usuario_usuario_id_5a6bb088]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_correcoes_usuario_usuario_id_5a6bb088] ON [dbo].[relatorios_correcoes_usuario]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_competencia_indice_f4a82f1f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_competencia_indice_f4a82f1f] ON [dbo].[relatorios_distribuicao_notas_competencia]
(
	[indice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_competencia_nome_c21162dc]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_competencia_nome_c21162dc] ON [dbo].[relatorios_distribuicao_notas_competencia]
(
	[nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_competencia_polo_descricao_881d1eeb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_competencia_polo_descricao_881d1eeb] ON [dbo].[relatorios_distribuicao_notas_competencia]
(
	[polo_descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_distribuicao_notas_competencia_polo_id_17a23545]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_competencia_polo_id_17a23545] ON [dbo].[relatorios_distribuicao_notas_competencia]
(
	[polo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_competencia_polo_indice_e46c50a9]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_competencia_polo_indice_e46c50a9] ON [dbo].[relatorios_distribuicao_notas_competencia]
(
	[polo_indice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_competencia_time_descricao_5cada2d3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_competencia_time_descricao_5cada2d3] ON [dbo].[relatorios_distribuicao_notas_competencia]
(
	[time_descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_distribuicao_notas_competencia_time_id_af89655e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_competencia_time_id_af89655e] ON [dbo].[relatorios_distribuicao_notas_competencia]
(
	[time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_distribuicao_notas_competencia_usuario_id_2b5a5a66]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_competencia_usuario_id_2b5a5a66] ON [dbo].[relatorios_distribuicao_notas_competencia]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_situacao_indice_e807dc77]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_situacao_indice_e807dc77] ON [dbo].[relatorios_distribuicao_notas_situacao]
(
	[indice] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_situacao_nome_7c0b91bb]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_situacao_nome_7c0b91bb] ON [dbo].[relatorios_distribuicao_notas_situacao]
(
	[nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_situacao_polo_descricao_d4590fdd]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_situacao_polo_descricao_d4590fdd] ON [dbo].[relatorios_distribuicao_notas_situacao]
(
	[polo_descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_distribuicao_notas_situacao_polo_id_6ca75a6c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_situacao_polo_id_6ca75a6c] ON [dbo].[relatorios_distribuicao_notas_situacao]
(
	[polo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_distribuicao_notas_situacao_time_descricao_4e04900e]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_situacao_time_descricao_4e04900e] ON [dbo].[relatorios_distribuicao_notas_situacao]
(
	[time_descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_distribuicao_notas_situacao_time_id_ab26232d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_situacao_time_id_ab26232d] ON [dbo].[relatorios_distribuicao_notas_situacao]
(
	[time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_distribuicao_notas_situacao_usuario_id_a144e91c]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_distribuicao_notas_situacao_usuario_id_a144e91c] ON [dbo].[relatorios_distribuicao_notas_situacao]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_historicoacompanhamentogeral_calculo_id_baadbddf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_historicoacompanhamentogeral_calculo_id_baadbddf] ON [dbo].[relatorios_historicoacompanhamentogeral]
(
	[calculo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_historicoacompanhamentoredacoes_calculo_id_a6635e3f]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_historicoacompanhamentoredacoes_calculo_id_a6635e3f] ON [dbo].[relatorios_historicoacompanhamentoredacoes]
(
	[calculo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_relatorio_geral_avaliador_986f0af1]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_relatorio_geral_avaliador_986f0af1] ON [dbo].[relatorios_relatorio_geral]
(
	[avaliador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_relatorio_geral_polo_descricao_21ccff11]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_relatorio_geral_polo_descricao_21ccff11] ON [dbo].[relatorios_relatorio_geral]
(
	[polo_descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_relatorio_geral_polo_id_b9a694b3]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_relatorio_geral_polo_id_b9a694b3] ON [dbo].[relatorios_relatorio_geral]
(
	[polo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [relatorios_relatorio_geral_time_descricao_d23f8b26]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_relatorio_geral_time_descricao_d23f8b26] ON [dbo].[relatorios_relatorio_geral]
(
	[time_descricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_relatorio_geral_time_id_f4582b88]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_relatorio_geral_time_id_f4582b88] ON [dbo].[relatorios_relatorio_geral]
(
	[time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [relatorios_relatorio_geral_usuario_id_94fb5b80]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [relatorios_relatorio_geral_usuario_id_94fb5b80] ON [dbo].[relatorios_relatorio_geral]
(
	[usuario_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [status_corretor_motivotrocastatus_status_id_98f8f3b5]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [status_corretor_motivotrocastatus_status_id_98f8f3b5] ON [dbo].[status_corretor_motivotrocastatus]
(
	[status_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [status_corretor_trocastatus_corretor_id_4d795839]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [status_corretor_trocastatus_corretor_id_4d795839] ON [dbo].[status_corretor_trocastatus]
(
	[corretor_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [status_corretor_trocastatus_motivo_id_f4229cd5]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [status_corretor_trocastatus_motivo_id_f4229cd5] ON [dbo].[status_corretor_trocastatus]
(
	[motivo_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [status_corretor_trocastatus_status_anterior_id_ebe59be0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [status_corretor_trocastatus_status_anterior_id_ebe59be0] ON [dbo].[status_corretor_trocastatus]
(
	[status_anterior_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [status_corretor_trocastatus_status_atual_id_3fe631ce]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [status_corretor_trocastatus_status_atual_id_3fe631ce] ON [dbo].[status_corretor_trocastatus]
(
	[status_atual_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_hierarquia_id_hierarquia_usuario_pai_ea129ee8]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_hierarquia_id_hierarquia_usuario_pai_ea129ee8] ON [dbo].[usuarios_hierarquia]
(
	[id_hierarquia_usuario_pai] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_hierarquia_id_tipo_hierarquia_usuario_d8885dcf]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_hierarquia_id_tipo_hierarquia_usuario_d8885dcf] ON [dbo].[usuarios_hierarquia]
(
	[id_tipo_hierarquia_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_hierarquia_id_usuario_responsavel_41e766be]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_hierarquia_id_usuario_responsavel_41e766be] ON [dbo].[usuarios_hierarquia]
(
	[id_usuario_responsavel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_hierarquia_usuarios_hierarquia_id_ba9d332d]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_hierarquia_usuarios_hierarquia_id_ba9d332d] ON [dbo].[usuarios_hierarquia_usuarios]
(
	[hierarquia_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_hierarquia_usuarios_user_id_86ac1192]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_hierarquia_usuarios_user_id_86ac1192] ON [dbo].[usuarios_hierarquia_usuarios]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_mudancatime_atualizado_por_c21c3ab0]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_mudancatime_atualizado_por_c21c3ab0] ON [dbo].[usuarios_mudancatime]
(
	[atualizado_por] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_mudancatime_id_coordenador_02c55807]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_mudancatime_id_coordenador_02c55807] ON [dbo].[usuarios_mudancatime]
(
	[id_coordenador] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_mudancatime_id_time_anterior_8050a427]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_mudancatime_id_time_anterior_8050a427] ON [dbo].[usuarios_mudancatime]
(
	[id_time_anterior] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_mudancatime_id_time_atual_201e7727]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_mudancatime_id_time_atual_201e7727] ON [dbo].[usuarios_mudancatime]
(
	[id_time_atual] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [usuarios_mudancatime_id_usuario_a4e8c701]    Script Date: 22/11/2019 11:51:06 ******/
CREATE NONCLUSTERED INDEX [usuarios_mudancatime_id_usuario_a4e8c701] ON [dbo].[usuarios_mudancatime]
(
	[id_usuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
