USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_Todos_Protocolos]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_Todos_Protocolos] AS  
select protocolos_protocolo.id as Codigo, protocolos_categoria.nome as Protocolo, cast(protocolos_protocolo.criado_em as date) as DataSolicitacao,   
       REPLACE(REPLACE(REPLACE(CAST(protocolos_protocolo.mensagem AS CHAR(150)), CHAR(10),''), CHAR(13), ''),CHAR(9), '') as MotivoSolicitacao,  
       auth_user.last_name as Solicitante, protocolos_status.nome as Status, cast(protocolos_resolucao.criado_em as date) as DataExecucao,   
    REPLACE(REPLACE(REPLACE(CAST(protocolos_resolucao.mensagem AS CHAR(150)), CHAR(10),''), CHAR(13), ''),CHAR(9), '') as RetornoSolicitacao,  
    auth_user2.last_name as Executor  
from protocolos_protocolo  
join auth_user on auth_user.id = protocolos_protocolo.requerido_por  
join protocolos_status on protocolos_status.id = protocolos_protocolo.status_id  
left join protocolos_resolucao on protocolos_resolucao.protocolo_id = protocolos_protocolo.id  
join protocolos_categoria on protocolos_categoria.id = protocolos_protocolo.categoria_id  
left join auth_user auth_user2 on auth_user2.id = protocolos_resolucao.criado_por  
  
GO
