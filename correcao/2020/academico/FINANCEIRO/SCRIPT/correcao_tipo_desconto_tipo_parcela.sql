/*
SELECT DISTINCT PAR.*,CASE WHEN PCA.TRANSACAO_ID IN(1,3) THEN 2 WHEN PCA.TRANSACAO_ID IN (2,4) THEN 1 END, PCA.* 
--UPDATE PAR SET PAR.TIPO_ID = CASE WHEN PCA.TRANSACAO_ID IN(1,3) THEN 2 WHEN PCA.TRANSACAO_ID IN (2,4) THEN 1 END
  FROM contratos_parcela PAR JOIN CONTRATOS_CONTRATO CON ON (CON.ID = PAR.contrato_id)
                             JOIN ACADEMICO_ALUNO    ALU ON (ALU.ID = CON.aluno_id)
						LEFT JOIN VW_FNC_PARECELAS_COMPETENCIA_ALUNO PCA ON (PCA.RA = ALU.RA COLLATE DATABASE_DEFAULT AND
							                                                 PCA.COMPETENCIA_ANO = PAR.ano_competencia AND 
																			 PCA.COMPETENCIA_MES = PAR.mes_competencia AND 
																			 PCA.VALOR           = PAR.valor AND 
																			 PCA.DATA_VENCIMENTO = PAR.data_vencimento)
 WHERE  PCA.RA IS NOT NULL  AND PAR.tipo_id  IN (1,2) AND 
       PAR.tipo_id <>  CASE WHEN PCA.TRANSACAO_ID IN(1,3) THEN 2 WHEN PCA.TRANSACAO_ID IN (2,4) THEN 1 END
 ORDER BY CONTRATO_ID,PAR.mes_competencia 

 ---#####################################################################3
 select lan.* 
--update lan set lan.tipo_id = par.tipo_id
from contratos_parcela par join financeiro_lancamento lan on (par.id = lan.parcela_id)
where par.id in (12879,12880) and 
      par.tipo_id <> lan.tipo_id



-- ######## ajuste tipos de desconto #######################
SELECT  alu.ra,  DSC.*, PCA.*, tds.id, tds.descricao as desconto_tipo_nome
-- update dsc set dsc.tipo_id = pca.desconto_id
  FROM CONTRATOS_DESCONTO DSC JOIN CONTRATOS_PARCELA PAR ON (PAR.ID = DSC.parcela_id)
JOIN CONTRATOS_CONTRATO CON ON (CON.ID = PAR.contrato_id)
                              JOIN ACADEMICO_ALUNO    ALU ON (ALU.ID = CON.aluno_id)
			                              				  join contratos_tipodesconto tds on (tds.id = dsc.tipo_id)
						 LEFT JOIN VW_FNC_PARECELAS_COMPETENCIA_ALUNO PCA ON (PCA.RA = ALU.RA COLLATE DATABASE_DEFAULT AND
							                                                  PCA.COMPETENCIA_ANO = PAR.ano_competencia AND 
																			  PCA.COMPETENCIA_MES = PAR.mes_competencia AND 
																			  PCA.VALOR           = DSC.valor AND 
																			  cast(PCA.DATA_VENCIMENTO as date) = cast(PAR.data_vencimento as date))

where dsc.tipo_id <> pca.desconto_id and 
      pca.transacao_nome = 'desconto'

*/


