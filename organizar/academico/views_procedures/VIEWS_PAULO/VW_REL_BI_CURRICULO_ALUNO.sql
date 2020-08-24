

CREATE OR ALTER view [dbo].[VW_REL_BI_CURRICULO_ALUNO] as     
select CRC.ID AS CURRICULO_ID, CRC.NOME AS CURRICULO_NOME, 
       ALU.ID AS ALUNO_ID, ALU.RA AS ALUNO_RA, ALU.NOME AS ALUNO_NOME, 
	   CUR.ID AS CURSO_ID, CUR.NOME AS CURSO_NOME, 
       CSA.ID AS CURRICULO_ALUNO_STATUS_ID,CSA.NOME AS CURRICULO_ALUNO_STATUS_NOME,      
       CRA.ID AS CURRICULO_ALUNO_ID,
	   CRA.data_admissao, CRA.ano_admissao, CRA.periodo_admissao, 
	   CRA.media_geral_aluno, 
	   FMI.ID AS FORMA_INGRESSO_ID, FMI.NOME AS FORMA_INGRESSO_NOME,
	   CAST(ROUND(AVG(DSC.NOTA),1) AS DECIMAL(10,1)) AS MEDIA_GERAL_CALCULADA, 
	   SUM(DSC.CARGA_HORARIA) AS CARGA_HORARIA_CUMPRIDA_CALCULADA
from curriculos_disciplinaconcluida dsc join curriculos_aluno       cra on (cra.id = dsc.curriculo_aluno_id)    
                                        join curriculos_curriculo   crc on (crc.id = cra.curriculo_id)    
                                        join academico_aluno        alu on (alu.id = cra.aluno_id)    
                                        join curriculos_statusaluno csa on (csa.id = cra.status_id)  
                                        join academico_curso        cur on (cur.id = crc.curso_id) 
								   LEFT JOIN curriculos_formaingresso FMI ON (FMI.ID = CRA.metodo_admissao_id)
where dsc.status_id = 2     
group by dsc.curriculo_aluno_id, alu.id, alu.ra, alu.nome, cur.nome, crc.nome, csa.nome, 
         CRC.ID, CUR.ID, CSA.ID, CRA.ID, FMI.ID, CRA.data_admissao, CRA.ano_admissao, CRA.periodo_admissao, 
	   CRA.media_geral_aluno, FMI.NOME


GO


