/*
CREATE TABLE [dbo].[administracao_log_carga](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo] [varchar](50) NOT NULL,
	[descricao] [varchar](250) NULL,
	[info] [varchar](250) NULL,
	[data_criacao] [datetime] NOT NULL,
	[obsevacao] [varchar](1000) NULL,
	[status_processamento] [varchar](50) NOT NULL,
	[data_inicio] [datetime] NULL,
	[data_termino] [datetime] NULL,
 CONSTRAINT [PK_administracao_log_carga] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
*/
-- sp_gerar_log_carga @tipo, @descricao,	@observacao, @status_proessamento, @data_inicio, @data_termino
create or alter procedure sp_gerar_log_carga
	@tipo varchar(50), @descricao varchar(250),	@observacao varchar(1000), 
	@status_proessamento varchar(50), @data_inicio datetime, @data_termino datetime  as 
insert into administracao_log_carga
SELECT @tipo , @descricao, info = SYSTEM_USER + ' - ' + HOST_NAME() + ' - ' + cast(CONNECTIONPROPERTY('client_net_address') as varchar(20)),
       datacricao = getdate(), @observacao, @status_proessamento, @data_inicio, @data_termino 


	