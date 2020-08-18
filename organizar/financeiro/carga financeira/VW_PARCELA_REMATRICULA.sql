USE [rem_prd]
GO

 CREATE OR ALTER   view [dbo].[VW_PARCELA_REMATRICULA] as        
with cte_parcelas_qtd as (    
   SELECT student_id COLLATE DATABASE_default AS RA, COUNT(ID) AS QTD_PARCELA_CONTRATO, SUM(VALUE) AS VALOR_CONTRATO    
     FROM finances_studentstatement    
    GROUP BY STUDENT_ID     
)    
------------------------------------------------------------    
select ext.id         as extrato_id,          
       ext.student_id collate database_default as RA,         
       ext.competency  collate database_default  AS COMPETENCIA,         
       ext.[date]         AS DATA_VENCIMENTO,         
       ext.[value]        AS VALOR,        
       crc.[curriculum]  collate database_default AS CURRICULO_NOME,        
       pla.id             as plano_id,         
       pla.name collate database_default as plano_nome,        
       case when blt.boleto_status = 'paid' then 'PAGO'       
            WHEN BLT.BOLETO_STATUS = 'pending' THEN 'EM ABERTO'ELSE 'NAO AVALIADO' END AS status_parcela,        
       valor_pago = blt.valor_pago,    
       blt.data_pagamento as data_pagamento,   
       ext.boleto_id,         
       cast(ISNULL(mat.ended_at,MAT.sent_at) as date) as data_matricula ,      
       ext.transaction_id as transacao_tipo_id,       
       mes_competencia = cast(left(ext.competency, charindex('/', ext.competency)-1) as int) ,      
       ano_competencia = cast(right(ext.competency, len(ext.competency) - charindex('/', ext.competency)) as int),    
       cte.QTD_PARCELA_CONTRATO, CTE.VALOR_CONTRATO ,  
       mat.status_id as status_matricula_id,   
       ens.name as status_matricula_nome,  
       gra.id as gratuidade_id, gra.name as gratuidade_nome,  
       des.id as desconto_id, des.name as desconto_nome,  
       origem = 'REMATRICULA',  
       PER.ID AS PERIODO_ID, PER.description AS PERIODO_NOME, PER.[current] AS PERIODO_CORRENTE,  
       PES.real_name AS PESSOA_NOME, PES.CPF AS PESSOA_CPF,   
       PES.PROUNI AS PESSOA_PROUNI, PES.FIES AS PESSOA_FIES  
  
from finances_studentstatement ext join onboarding_enrollment                    mat on (mat.id = ext.enrollment_id)  
                                   join onboarding_financedata                   fin on (mat.id = fin.enrollment_id)        
                                   join onboarding_financeplan                   pla on (pla.id = fin.plan_id)        
                                   join personal_personaldata                    pes on (mat.id = pes.enrollment_id)        
                                   join onboarding_onboarding                    crc on (crc.id = mat.onboarding_id)        
                                   join onboarding_termyear                      per on (per.id = crc.term_year_id)     
                                   join onboarding_enrollmentstatus              ens on (ens.id = mat.status_id)  
                              left join [boletos_service].[db_owner].[vw_boleto] blt on (blt.boleto_id = ext.boleto_id)     
                              left join cte_parcelas_qtd                         cte on (cte.ra = ext.student_id)     
                              left join onboarding_gratuity                      gra on (gra.id = mat.gratuity_id)  
                              left join finances_discount                        des on (des.id = ext.discount_id)  
      
GO


