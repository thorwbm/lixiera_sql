
CREATE OR ALTER view [dbo].[VW_REL_BI_INFORMACAO_PROCESSO_SELETIVO] AS 
select CRC.ID AS CURRICULO_ID, CRC.NOME AS CURRICULO_NOME, 
       CUR.ID AS CURSO_ID, CUR.NOME AS CURSO_NOME,
	   ALU.ID AS ALUNO_ID, ALU.RA AS ALUNO_RA, ALU.NOME AS ALUNO_NOME, 
	   CSA.ID AS CURRICULO_ALUNO_STATUS_ID, CSA.NOME AS CURRICULO_ALUNO_STATUS_NOME,
	   CRA.PONTUACAO_PROCESSO_SELETIVO, CRA.DATA_PROCESSO_SELETIVO, CRA.POSICAO_PROCESSO_SELETIVO

  from curriculos_aluno cra join academico_aluno        alu on (alu.id = cra.aluno_id)
                            join curriculos_curriculo   crc on (crc.id = cra.curriculo_id)
							join academico_curso        cur on (cur.id = crc.curso_id)
							join curriculos_statusaluno csa on (csa.id = cra.status_id)





