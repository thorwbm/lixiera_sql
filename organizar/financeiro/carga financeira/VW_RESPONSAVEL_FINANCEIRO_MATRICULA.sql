  
--CREATE or alter VIEW [dbo].[VW_RESPONSAVEL_FINANCEIRO] as   
SELECT DISTINCT 
       CURRICULO = ONB.curriculum  COLLATE DATABASE_DEFAULT,   
       RA = ENR.student_id COLLATE DATABASE_DEFAULT,   
       CPF = REPLACE(REPLACE(OFC.cpf,'.',''),'-','') COLLATE DATABASE_DEFAULT,   
       COMPETENCIA =  STD.competency COLLATE DATABASE_DEFAULT,
       mes_competencia = cast(left(STD.competency, charindex('/', STD.competency)-1) as int) ,      
       ano_competencia = cast(right(STD.competency, len(STD.competency) - charindex('/', STD.competency)) as int)
  FROM 
       onboarding_financeofficer OFC JOIN onboarding_financedata OFD ON (OFD.ID = OFC.finance_data_id)  
                                     JOIN onboarding_enrollment  ENR ON (ENR.ID = OFD.enrollment_id)  
                                     JOIN onboarding_onboarding  ONB ON (ONB.ID = ENR.onboarding_id)  
                                     JOIN finances_studentstatement STD ON (STD.student_id = ENR.student_id AND   
                                                                            STD.enrollment_id = ENR.ID)  


