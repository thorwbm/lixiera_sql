/*****************************************************************************************************************
*                                      VW_REL_BI_ALUNO_ENEM_PROUNI_ATIVOS                                        *
*                                                                                                                *
*  VIEW QUE RELACIONA OS ALUNOS QUE TIVERAM FORMA DE INGRESSO ENEM-PROUNI E POSSUIEM CURRICULO ATIVO             *
*                                                                                                                *
*                                                                                                                *
* BANCO_SISTEMA : GENERICO                                                                                       *
* CRIADO POR    : GUILHERME ANACLETO - JENILSO ANDRADE - WEMERSON BITTORI MADURO                 DATA:23/08/2020 *
* ALTERADO POR  : GUILHERME ANACLETO - JENILSO ANDRADE - WEMERSON BITTORI MADURO                 DATA:23/08/2020 *
******************************************************************************************************************/

CREATE VIEW VW_REL_BI_EQUIVALENCIAS_ENTRE_CURRICULOS AS 
select 
       CRC.ID AS CURRICULO_ID, CRC.NOME AS CURRICLO_NOME, 
       CUR.ID AS CURSO_ID, CUR.NOME AS CURSO_NOME, 
	   ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, ALU.RA AS ALUNO_RA,
	   ING.ID AS FORMA_INGRESSO_ID, ING.NOME AS FORMA_INGRESSO_NOME, 
	   STA.ID AS CURRICULO_STATUS_ID, STA.NOME AS CURRICULO_STATUS_NOME     
  from 
       curriculos_aluno cra join curriculos_curriculo     crc on (crc.id = cra.curriculo_id)
                            join academico_curso          cur on (cur.id = crc.curso_id)
                            join academico_aluno          alu on (alu.id = cra.aluno_id)
                            join curriculos_formaingresso ing on (ing.id = cra.metodo_admissao_id)
                            join curriculos_statusaluno   sta on (sta.id = cra.status_id)
 where 
       cra.status_id = 13 and 
       ing.id = 21
