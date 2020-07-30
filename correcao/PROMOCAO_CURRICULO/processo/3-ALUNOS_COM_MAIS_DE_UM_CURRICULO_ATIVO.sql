/****************************************************************************************************
*                                  VW_PRO_ALUNO_MAIS_DE_UM_ATIVO                                    *
*                                                                                                   *
*  VIEW QUE LISTA TODOS OS ALUNOS QUE POSSUEM MAIS DE UM CURRICULO ATIVO                            *
*  DESCONSIDERANDO .[CURSO DE TUTORIA],[CURSO DE EXTENSÃO EM ORATÓRIA]                              *
*                                                                                                   *
* BANCO_SISTEMA : ERP_PRD                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                           DATA:23/07/2020 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                           DATA:23/07/2020 *
****************************************************************************************************/

CREATE OR alter VIEW VW_PRO_ALUNO_MAIS_DE_UM_ATIVO AS 
	select distinct 
	       ALUNO_ID, curriculo_nome, curso_nome, aluno_nome, aluno_ra, curriculo_aluno_status_id
	  from vw_Curriculo_aluno_pessoa 
	 where curriculo_aluno_status_id =13 AND 
	       aluno_id in (
	          select aluno_id
			    from vw_Curriculo_aluno_pessoa 
			   where curso_nome not in ('CURSO DE TUTORIA','CURSO DE EXTENSÃO EM ORATÓRIA') and 
					 curriculo_aluno_status_id = 13
			   group by aluno_id  having count(1) > 1)   
	       


