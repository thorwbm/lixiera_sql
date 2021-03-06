USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_salas_sala]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_salas_sala] as
select andar.predio_id, predio.nome as predio, predio.code as sigla_predio, sala.andar_id, andar.nome as andar, sala.id as sala_id, sala.nome as sala
  from salas_sala sala
       join salas_andar andar on andar.id = sala.andar_id
       join salas_predio predio on predio.id = andar.predio_id
GO
