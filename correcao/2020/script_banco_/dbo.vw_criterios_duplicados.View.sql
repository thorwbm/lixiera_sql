USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_criterios_duplicados]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                                   VIEW CRITERIOS DUPLICADOS                                                     *
*                                                                                                                                 *
*  VIEW QUE LISTA OS CIRTERIOS QUE ESTAO DUPLICADOS NA TABELA [ATIVIDADES_CRITERIO_TURMADISCIPLINA] E O CODIGO IDENTIFICADOR DAS  *
* DUPLICACOES                                                                                                                     *
*                                                                                                                                 *
* BANCO_SISTEMA : ATIVIDADE COMPLEMENTAR - EDUCAT                                                                                 *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:11/12/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:11/12/2019 *
**********************************************************************************************************************************/

create   view [dbo].[vw_criterios_duplicados] as 

with cte_duplicidade_criterios as (
		select turma_disciplina_id, criterio_id, professor_id, count(1) as qtd
		  from atividades_criterio_turmadisciplina
		  group by turma_disciplina_id, criterio_id, professor_id
		  having count(1) > 1
)

	, cte_duplicidades_ordenadas as (
	   select atc.id as atividadeCriterioTurmaDisciplina_id , cte.criterio_id, tds.id as turmadisciplina_id, tur.nome as turma_nome,
			  dis.nome as disciplina_nome, cri.nome as criterio_nome, cte.professor_id,
			  identificador = ( ROW_NUMBER() OVER(PARTITION BY tds.id, cte.criterio_id,cte.professor_id ORDER BY tds.id, cte.criterio_id, atc.id))
		 from cte_duplicidade_criterios cte join academico_turmadisciplina tds on (tds.id = cte.turma_disciplina_id)
											join academico_turma           tur on (tur.id = tds.turma_id)
											join atividades_criterio       cri on (cri.id = cte.criterio_id)
											join academico_disciplina      dis on (dis.id = tds.disciplina_id) 
											join atividades_criterio_turmadisciplina atc on (tds.id = atc.turma_disciplina_id and 
																							 cri.id = atc.criterio_id         and 
																							 cte.professor_id = atc.professor_id)
 
)
	
		select cdc.*, cdo1.turma_nome, cdo1.disciplina_nome, cdo1.criterio_nome, cdo1.atividadeCriterioTurmaDisciplina_id as atv_cri_tur_dis_id_1, cdo2.atividadeCriterioTurmaDisciplina_id as atv_cri_tur_dis_id_2
		  from cte_duplicidade_criterios cdc join cte_duplicidades_ordenadas cdo1 on (cdo1.criterio_id = cdc.criterio_id and 
		                                                                              cdo1.turmadisciplina_id = cdc.turma_disciplina_id and 
																					  cdo1.professor_id = cdc.professor_id              and 
																					  cdo1.identificador = 1) 
											 join cte_duplicidades_ordenadas cdo2 on (cdo2.criterio_id = cdc.criterio_id and 
		                                                                              cdo2.turmadisciplina_id = cdc.turma_disciplina_id and 
																					  cdo2.professor_id = cdc.professor_id              and 
																					  cdo2.identificador = 2)  
GO
