/****************************************************************************************************
*                                  VW_CURRICULOS_GRADE_DISCIPLINA                                   *
*                                                                                                   *
*  VIEW QUE MAPEIA TODAS AS DISCIPLINAS DE UMA GRADE EM UM CURSO DE UM CURRICULO.                   *
*                                                                                                   *
*                                                                                                   *
* BANCO_SISTEMA : ERP_PRD                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:23/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:23/07/2020 *
****************************************************************************************************/

CREATE OR ALTER view [dbo].[VW_CURRICULOS_GRADE_DISCIPLINA] as   
select crc.id as curriculo_id, crc.nome as curriculo_nome,   
       gra.id as grade_id, gra.nome as grade_nome,   
       grd.id as gradedisciplina_id,  
       dis.id as disciplina_id, dis.nome as disciplina_nome,   
       etp.id as etapa_id, etp.nome as etapa_nome,etp.etapa,
	   egd.id as exigenciadisciplina_id, egd.nome as exigenciaDisciplina_nome  
  from curriculos_curriculo crc join curriculos_grade               gra on (crc.id = gra.curriculo_id)  
                                join curriculos_gradedisciplina     grd on (gra.id = grd.grade_id)  
                                join curriculos_exigenciadisciplina egd on (egd.id = grd.exigencia_disciplina_id)  
                                join academico_disciplina           dis on (dis.id = grd.disciplina_id)  
                                join academico_etapa                etp on (etp.id = gra.etapa_id)