USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_aluno_curriculo_curso_turma_etapa_discplina]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_aluno_curriculo_curso_turma_etapa_discplina] as       
SELECT distinct       
       ALU.ID  AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, ALU.RA AS ALUNO_RA, pes.cpf as ALUNO_CPF,  
       CRC.ID  AS CURRICULO_ID, CRC.NOME AS CURRICULO_NOME,       
       CSTA.ID AS STATUSCURRICULO_ID, CSTA.NOME AS STATUSCURRICULO_NOME, CSTA.curso_atual AS STATUSCURRICULOALUNO_ATUAL,       
       CUR.ID  AS CURSO_ID, CUR.NOME AS CURSO_NOME,       
       TUR.ID  AS TURMA_ID, TUR.NOME AS TURMA_NOME, TUR.INICIO_VIGENCIA AS TURMA_INICIOVIGENCIA, TUR.TERMINO_VIGENCIA AS TURMA_TERMINOVIGENCIA,       
       DIS.ID  AS DISCIPLINA_ID, DIS.NOME AS DISCIPLINA_NOME,       
       ETA.ID  AS ETAPA_ID, ETA.ETAPA AS ETAPA,       
       TPA.ID  AS ETAPAANO_ID, TPA.ANO AS ETAPAANO_ANO,      
       TDA.ID  AS TURMADISCIPLINAALUNO_ID, TDS.ID AS TURMADISCIPLINA_ID,       
       TRN.ID  AS TURNO_ID, TUR.NOME AS TURNO_NOME,      
       CRA.ID  AS CURRICULOALUNO_ID,       
       CRA.data_admissao as CURRICULOALUNO_DATA_ADMISSAO,
	   case when tur.turma_pai_id is null then 'PAI' ELSE 'FILHA' end as TURMA_TIPO,
	   isnull(pai.nome, tur.nome) as TURMA_PAI 
      
 FROM  curriculos_aluno   CRA  WITH(NOLOCK) JOIN curriculos_statusaluno         CSTA WITH(NOLOCK) ON (CSTA.id = CRA.status_id)        
                                               JOIN curriculos_curriculo           CRC  WITH(NOLOCK) ON (CRC.id  = CRA.curriculo_id)        
                                               JOIN academico_curso                CUR  WITH(NOLOCK) ON (CUR.id  = CRC.curso_id)        
                                               JOIN academico_turno                TRN  WITH(NOLOCK) ON (TRN.id  = CRC.turno_id)        
                                               JOIN academico_aluno                ALU  WITH(NOLOCK) ON (ALU.id  = CRA.aluno_id)        
                                               JOIN academico_turmadisciplinaaluno TDA  WITH(NOLOCK) ON (ALU.id  = TDA.aluno_id)      
                                               JOIN academico_turmadisciplina      TDS  WITH(NOLOCK) ON (TDS.id  = TDA.turma_disciplina_id)      
                                               join academico_turma                tur  with(nolock) on (tur.id  = TDS.turma_id)            
                                          left join academico_turma                pai  with(nolock) on (pai.id  = tur.turma_pai_id)       
                                               JOIN academico_disciplina           DIS  WITH(NOLOCK) ON (DIS.id  = TDS.disciplina_id)      
                                               JOIN academico_etapaano             TPA  WITH(NOLOCK) ON (tpa.id  = tur.etapa_ano_id)      
                                               JOIN academico_etapa                ETA  WITH(NOLOCK) ON (ETA.id  = TPA.etapa_id)      
                                               JOIN pessoas_pessoa                 pes  with(nolock) on (pes.id  = ALU.pessoa_id)  
                     
GO
