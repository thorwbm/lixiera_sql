/****** Object:  Table [dbo].[inep_n02]    Script Date: 14/10/2019 09:24:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE EXTERNAL TABLE [dbo].[inep_n02]
(
	[CO_PROJETO] [varchar](150) NULL,
	[TP_ORIGEM] [varchar](150) NULL,
	[CO_INSCRICAO] [varchar](150) NULL,
	[NO_INSCRITO] [varchar](150) NULL,
	[NO_SOCIAL] [varchar](150) NULL,
	[NU_CPF] [varchar](150) NULL,
	[NU_RG] [varchar](150) NULL,
	[DT_NASCIMENTO] [varchar](150) NULL,
	[ID_KIT_PROVA] [varchar](150) NULL,
	[ID_PROVA] [varchar](150) NULL,
	[DS_PROVA] [varchar](150) NULL,
	[CO_COORDENACAO] [varchar](150) NULL,
	[CO_PAIS_PROVA] [varchar](150) NULL,
	[NO_PAIS_PROVA] [varchar](150) NULL,
	[SG_UF_PROVA] [varchar](150) NULL,
	[CO_MUNICIPIO_PROVA] [varchar](150) NULL,
	[NO_MUNICIPIO_PROVA] [varchar](150) NULL,
	[CO_LOCAL] [varchar](150) NULL,
	[NO_LOCAL_PROVA] [varchar](150) NULL,
	[CO_BLOCO] [varchar](150) NULL,
	[NO_BLOCO] [varchar](150) NULL,
	[NO_ANDAR] [varchar](150) NULL,
	[NO_SALA] [varchar](150) NULL,
	[NO_SALA_VIRTUAL] [varchar](150) NULL,
	[NU_SEQUENCIAL] [varchar](150) NULL,
	[NU_SEQ_ENVELOPE] [varchar](150) NULL,
	[NU_TOTAL_ENVELOPE] [varchar](150) NULL,
	[CO_BARRA_CONTRACAPA] [varchar](150) NULL,
	[CO_BARRA_RESPOSTA] [varchar](150) NULL,
	[CO_BARRA_REDACAO] [varchar](150) NULL,
	[CO_BARRA_PACOTE] [varchar](150) NULL,
	[CO_TURNO_PROVA] [varchar](150) NULL,
	[IN_ATENDIMENTO_ESPECIFICO] [varchar](150) NULL,
	[IN_ATENDIMENTO_ESPECIALIZADO] [varchar](150) NULL,
	[IN_RECURSO] [varchar](150) NULL,
	[IN_TEMPO_ADICIONAL] [varchar](150) NULL,
	[TP_ENSALAMENTO] [varchar](150) NULL,
	[DT_APLICACAO] [varchar](150) NULL,
	[NU_PARTICIPANTES] [varchar](150) NULL,
	[NU_PROVAS] [varchar](150) NULL,
	[ID_MALOTE] [varchar](150) NULL,
	[NU_CDL] [varchar](150) NULL,
	[IN_RESERVA] [varchar](150) NULL,
	[NO_ARQUIVO_REFERENCIA] [varchar](150) NULL,
	[TP_IMPRIMIR] [varchar](150) NULL,
	[CO_JUSTIFICATIVA] [varchar](150) NULL
)
WITH (DATA_SOURCE = [InepDS])
GO


