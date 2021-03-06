USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_disciplina_pendente_conclusao]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vw_disciplina_pendente_conclusao] as
select ETN.ALUNO_ID, ETN.ALUNO_NOME, ETN.RA, etn.etapa_natural,
       GRA.curriculo_id, GRA.curriculo_nome, GRA.disciplina_id, GRA.disciplina_nome,
	   GRA.etapa_id, GRA.etapa_nome, gra.etapa
from vw_curriculos_grade_disciplina gra join vw_etapa_natural_aluno_ativo etn on (etn.curriculo_id = gra.curriculo_id )
where  not exists (select 1 from vw_disciplina_obrigatoria_concluida crs
	               where crs.aluno_id = etn.aluno_id         and 
				         crs.curriculo_id = etn.curriculo_id and 
						 crs.disciplina_id = gra.disciplina_id) AND 
	  NOT EXISTS (SELECT 1 FROM vw_aluno_disciplina_em_curso ENC
	               WHERE ENC.ALUNO_ID      = ETN.ALUNO_ID     AND 
				         ENC.CURRICULO_ID  = ETN.CURRICULO_ID AND 
						 ENC.DISCIPLINA_ID = GRA.DISCIPLINA_ID) AND 
	  NOT EXISTS (SELECT 1 FROM vw_disciplina_obrigatoria_concluida OBR
	               WHERE OBR.ALUNO_ID      = ETN.ALUNO_ID     AND 
				         OBR.CURRICULO_ID  = ETN.CURRICULO_ID AND 
						 OBR.DISCIPLINA_ID = GRA.DISCIPLINA_ID)
	
GO
