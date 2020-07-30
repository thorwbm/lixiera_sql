CREATE OR ALTER VIEW VW_FIADOR_REMATRICULA AS 
with    cte_fiador as (
            select distinct
                   NOME_FIADOR = fia.name, CPF_FIADOR = fia.cpf, RG_FIADOR = fia.rg, TELEFONE_FIADOR = fia.phone_number, E_MAIL_FIADOR = fia.email, fia.finance_data_id,
                   numero = ROW_NUMBER ( ) OVER (partition by fia.finance_data_id order by fia.name )   
              from onboarding_guarantor fia 
)

select DISTINCT 
       PER.description AS ETAPA_MATRICULA, ALU.STUDENT_ID AS RA, PES.real_name AS PESSOA_NOME, PES.CPF AS PESSOA_CPF, 
       PES.fathers_name AS NOME_PAI, PES.mothers_name AS NOME_MAE, 
       CUR.NAME AS CURSO_NOME, CRC.curriculum AS CURRICULO_NOME, PLA.name AS PLANO_ESCOLHIDO, 
       FIA1.NOME_FIADOR AS FIADOR_NOME1, FIA1.CPF_FIADOR AS FIADOR_CPF1, FIA1.RG_FIADOR AS FIADOR_RG1, 
       FIA1.TELEFONE_FIADOR AS FIADOR_TEL1, FIA1.E_MAIL_FIADOR AS FIADOR_EMAIL1,
       FIA2.NOME_FIADOR AS FIADOR_NOME2, FIA2.CPF_FIADOR AS FIADOR_CPF2, FIA2.RG_FIADOR AS FIADOR_RG2, 
       FIA2.TELEFONE_FIADOR AS FIADOR_TEL2, FIA2.E_MAIL_FIADOR AS FIADOR_EMAIL2, 
       ENS.NAME AS STATUS_MATRICULA, ORIGEM = 'REMATRICULA'
  from onboarding_enrollment alu join personal_personaldata       pes  on (alu.id = pes.enrollment_id)
                                 join onboarding_onboarding       crc  on (crc.id = alu.onboarding_id)                                   
                                 join onboarding_termyear         per  on (per.id = crc.term_year_id)
                                 join onboarding_course           cur  on (cur.id = crc.course_id)
                                 join onboarding_financedata      fin  on (alu.id = fin.enrollment_id)                                        
                                 join onboarding_financeplan      pla  on (pla.id = fin.plan_id)                                         
                                 join onboarding_enrollmentstatus ens  on (ens.id = ALU.status_id)   
                            left join cte_fiador                  fia1 on (fin.id = fia1.finance_data_id and fia1.numero = 1)  
                            left join cte_fiador                  fia2 on (fin.id = fia2.finance_data_id and fia2.numero = 2)         



