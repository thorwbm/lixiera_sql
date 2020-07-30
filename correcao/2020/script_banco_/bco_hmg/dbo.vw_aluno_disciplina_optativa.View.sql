USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_aluno_disciplina_optativa]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_aluno_disciplina_optativa] as 
select * ,  
      CARGA_HORARIA_TOTAL = (select sum(cargahoraria_concluida) 
	                           from vw_disciplinaoptativa_concluida OPTX
		                      WHERE OPTX.CURRICULOALUNO_ID = OPT.CURRICULOALUNO_ID)

from vw_disciplinaoptativa_concluida opt 
GO
