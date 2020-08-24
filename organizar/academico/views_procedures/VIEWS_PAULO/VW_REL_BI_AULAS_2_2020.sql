/*****************************************************************************************************************
*                                            VW_REL_BI_AULAS_2_2020                                              *
*                                                                                                                *
*  VIEW QUE RELACIONA TODAS AS AULAS A PARTIR DA DATA DE (2020-07-31)                                            *
*                                                                                                                *
*                                                                                                                *
* BANCO_SISTEMA : ERP_PRD                                                                                       *
* CRIADO POR    : GUILHERME ANACLETO - JENILSO ANDRADE - WEMERSON BITTORI MADURO                 DATA:23/08/2020 *
* ALTERADO POR  : GUILHERME ANACLETO - JENILSO ANDRADE - WEMERSON BITTORI MADURO                 DATA:23/08/2020 *
******************************************************************************************************************/

CREATE OR ALTER VIEW VW_REL_BI_AULAS_2_2020 AS 
select
       CUR.ID AS CURSO_ID, CUR.NOME AS CURSO_NOME, 
       TUR.ID AS TURMA_ID, TUR.NOME AS TURMA_NOME, CAT.ID AS TURMA_CATEGORIA_ID, CAT.NOME AS TURMA_CATEGORIA_NOME,
	   DIS.ID AS DISCIPLINA_ID, DIS.NOME AS DISCIPLINA_NOME, 
	   AUL.ID AS AULA_ID, AUL.DATA_INICIO AS AULA_DATA_INICIO, AUL.DATA_TERMINO AS AULA_DATA_TERMINO, 
	   STA.ID AS AULA_STATUS_ID, STA.NOME AS AULA_STATUS_NOME, 
	   PRO.ID AS PROFESSOR_ID, PRO.NOME AS PROFESSOR_NOME
  from 
       academico_aula AUL with(nolock) join academico_turmadisciplina tdS with(nolock) on (tdS.id = AUL.turma_disciplina_id)
                                       join academico_turma           TUR with(nolock) on (TUR.id = tdS.turma_id)
                                       join academico_categoriaturma  CAT with(nolock) on (CAT.id = TUR.categoria_id)
                                       join academico_disciplina      DIS with(nolock) on (DIS.id = tdS.disciplina_id)
                                       join academico_etapaano        ETA with(nolock) on (ETA.id = TUR.etapa_ano_id)
                                       join academico_curso           CUR with(nolock) on (CUR.id = TUR.curso_id)
                                       join academico_statusaula      STA with(nolock) on (STA.id = AUL.status_id)
                                       join academico_professor       PRO with(nolock) on (PRO.id = AUL.professor_id)
where cast(AUL.data_inicio as date) > '2020-07-31'
