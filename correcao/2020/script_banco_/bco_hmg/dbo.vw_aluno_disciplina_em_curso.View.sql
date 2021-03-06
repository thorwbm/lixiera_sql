USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_aluno_disciplina_em_curso]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_aluno_disciplina_em_curso] as       
SELECT distinct       
       ALU.ID  AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, ALU.RA AS ALUNO_RA, 
       CRC.ID  AS CURRICULO_ID, CRC.NOME AS CURRICULO_NOME,       
      DIS.ID  AS DISCIPLINA_ID, DIS.NOME AS DISCIPLINA_NOME,   
    TDA.ID  AS TURMADISCIPLINAALUNO_ID, TDS.ID AS TURMADISCIPLINA_ID, 
    CRA.ID  AS CURRICULOALUNO_ID
      
 FROM  curriculos_aluno   CRA  WITH(NOLOCK)         
                                               JOIN curriculos_curriculo           CRC  WITH(NOLOCK) ON (CRC.id  = CRA.curriculo_id)        
                                               JOIN academico_curso                CUR  WITH(NOLOCK) ON (CUR.id  = CRC.curso_id)        
                                               JOIN academico_turno                TRN  WITH(NOLOCK) ON (TRN.id  = CRC.turno_id)        
                                               JOIN academico_aluno                ALU  WITH(NOLOCK) ON (ALU.id  = CRA.aluno_id)        
              JOIN academico_turmadisciplinaaluno TDA  WITH(NOLOCK) ON (ALU.id  = TDA.aluno_id)      
              JOIN academico_turmadisciplina      TDS  WITH(NOLOCK) ON (TDS.id  = TDA.turma_disciplina_id) 
			  join academico_turma                tur  with(nolock) on (tur.id = tds.turma_id and tur.turma_pai_id is null )
              JOIN academico_disciplina           DIS  WITH(NOLOCK) ON (DIS.id  = TDS.disciplina_id) 
     join pessoas_pessoa                 pes  with(nolock) on (pes.id  = ALU.pessoa_id)  
                     

where alu.nome = 'ÂNGELA GIL PATRUS PENA' and 
      tda.status_matricula_disciplina_id = 1
GO
