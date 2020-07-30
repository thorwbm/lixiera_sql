/****************************************************************************************************
*                                      VW_ACD_TURMA_PAI_FILHA                                       *
*                                                                                                   *
*  VIEW QUE ASSOCIA AS TURMAS PAIS E FILHAS E O NUMERO DE MAXIMO DE VAGAS.                          *
*                                                                                                   *
*                                                                                                   *
* BANCO_SISTEMA : ERP_PRD                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:24/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:24/07/2020 *
****************************************************************************************************/

create or alter view VW_ACD_TURMA_PAI_FILHA as 
select distinct tds.id as turmadisciplina_pai_id, tds.maximo_vagas as maximo_pai_vagas,
       tur.id as turma_pai_id, tur.nome as turma_pai_nome,
	   dis.id as disciplina_pai_id, dis.nome as disciplina_pai_nome,
       trf.id as turma_filha_id, trf.nome as turma_filha_nome,
	   tdsf.id as turmadisciplina_filha_id, 
	   dsf.id as disciplina_filha_id, dsf.nome as disciplina_filha_nome,	   
	   tdsf.maximo_vagas as maximo_filha_vagas
  from academico_turmadisciplina tds join academico_turma tur on (tur.id = tds.turma_id)
                                     join academico_disciplina dis on (dis.id = tds.disciplina_id)
                                     join academico_turma trf on (trf.turma_pai_id = tur.id)
							         join academico_turmadisciplina tdsf on (trf.id = tdsf.turma_id and 
									                                         dis.id = tdsf.disciplina_id)
									 join academico_disciplina      dsf on (dsf.id = tdsf.disciplina_id)

						