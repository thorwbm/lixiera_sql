/*****************************************************************************************************************
*                                       VW_REL_BI_CONTATO_ENDERECO_ALUNOS                                        *
*                                                                                                                *
*  VIEW QUE RELACIONA ALUNOS E SEUS DADOS PARA CONTATO                                                           *
*                                                                                                                *
*                                                                                                                *
* BANCO_SISTEMA : ERP_PRD                                                                                        *
* CRIADO POR    : GUILHERME ANACLETO - JENILSO ANDRADE - WEMERSON BITTORI MADURO                 DATA:23/08/2020 *
* ALTERADO POR  : GUILHERME ANACLETO - JENILSO ANDRADE - WEMERSON BITTORI MADURO                 DATA:23/08/2020 *
******************************************************************************************************************/

CREATE OR ALTER VIEW VW_REL_BI_CONTATO_ENDERECO_ALUNOS AS
select DISTINCT
       CRC.ID AS CURRICULO_ID, CRC.NOME AS CURRICULO_NOME, 
	   CUR.ID AS CURSO_ID, CUR.NOME AS CURSO_NOME, 
	   ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, ALU.RA AS ALUNO_RA, 
	   USU.EMAIL AS USUARIO_EMAIL, 
	   
	   TEL.ID AS TELEFONE_ID, TEL.NUMERO AS TELEFONE_NOMERO, TEL.PRINCIPAL AS TELEFONE_PRINCIPAL, 
	   TPT.ID AS TELEFONE_TIPO_ID, TPT.NOME AS TELEFONE_TIPO_NOME, 
	   EDR.ID AS ENDERECO_ID, EDR.LOGRADOURO AS ENDERECO_LOGRADOURO, EDR.NUMERO AS ENDERECO_NUMERO, 
	   EDR.COMPLEMENTO AS ENDERECO_COMPLEMENTO, EDR.BAIRRO AS ENDERECO_BAIRRO, EDR.CEP AS ENDERECO_CEP,
	   CID.ID AS ENDERECO_CIDADE_ID, CID.NOME AS ENDERECO_CIDADE_NOME, 
	   EST.ID AS ENDERECO_ESTADO_ID, EST.NOME AS ENDERECO_ESTADO_NOME, EST.SIGLA AS ENDERECO_ESTADO_SIGLA, 
	   TPE.ID AS ENDERECO_TIPO_ID, TPE.NOME AS ENDERECO_TIPO_NOME, 
	   EMA.ID AS EMAIL_ID, EMA.EMAIL AS EMAIL_EMAIL, TPM.ID AS EMAIL_TIPO_ID, TPM.NOME AS EMAIL_TIPO_NOME
	   
  from curriculos_aluno CRA join curriculos_curriculo   CRC on (CRC.id = CRA.curriculo_id)
                            join academico_curso        CUR on (CUR.id = CRC.curso_id)
                            join academico_aluno        ALU on (ALU.id = CRA.aluno_id)
                            join curriculos_statusaluno STA on (STA.id = CRA.status_id)
                            join auth_user              USU on (USU.id = ALU.user_id)
                            join pessoas_pessoa         PES on (PES.id = ALU.pessoa_id)
                       LEFT join pessoas_telefone       TEL on (PES.id = TEL.pessoa_id)
					   LEFT JOIN pessoas_tipotelefone   TPT ON (TPT.ID = TEL.tipo_id)
                       LEFT join pessoas_endereco       EDR on (PES.id = EDR.pessoa_id)
					   LEFT JOIN pessoas_tipoendereco   TPE ON (TPE.ID = EDR.tipo_endereco_id)
                       LEFT join cidades_cidade         CID on (CID.id = EDR.cidade_id)
                       LEFT join cidades_estado         EST on (EST.id = CID.estado_id)
					   LEFT JOIN pessoas_email          EMA ON (PES.ID = EMA.pessoa_id)
					   LEFT JOIN pessoas_tipoemail      TPM ON (TPM.ID = EMA.tipo_id)
where CRA.status_id = 13