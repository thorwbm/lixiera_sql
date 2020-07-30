USE [rem_prd]
GO


CREATE OR ALTER   VIEW [dbo].[VW_DESCONTO_REMATRICULA] as     
  
select EXT.id         as extrato_id,   
       EXT.student_id collate database_default as ra,   
       EXT.competency as COMPETENCIA,   
       cast(EXT.[date] as date) as DATA_VENCIMENTO,   
       EXT.[value]    as VALOR,  
       PLA.name collate database_default as plano_nome, 
	   dis.id as desconto_id,
       dis.name collate database_default as desconto_nome,   
       dis.percentage as desconto_porcentagem,   
       dis.value as desconto_valor,   
	   crc.curriculum collate database_default as curriculo, 
       dtp.name collate database_default as desconto_tipo,      
       mes_competencia = cast(left(EXT.competency, charindex('/', EXT.competency)-1) as int) ,  
       ano_competencia = cast(right(EXT.competency, len(EXT.competency) - charindex('/', EXT.competency)) as int) ,
	   matricula_status_id = ers.id,
	   matricula_status_nome = ers.name,
	   gratuidade_id = gra.id, 
	   gratuidade_nome = gra.name, 
	   periodo_id = per.id,
	   periodo_nome = per.description,
	   periodo_corrente = per.[current],
	   pessoa_prouni = pes.prouni, 
	   PES.real_name AS PESSOA_NOME, PES.CPF AS PESSOA_CPF, 
	   origem = 'REMATRICULA'
  
  from finances_studentstatement EXT join onboarding_enrollment       MAT on (MAT.id = EXT.enrollment_id)    
                                     join onboarding_financedata      FIN on (MAT.id = FIN.enrollment_id)    
                                     join onboarding_financeplan      PLA on (PLA.id = FIN.plan_id)    
                                     join personal_personaldata       PES on (MAT.id = PES.enrollment_id)    
                                     join onboarding_onboarding       crc on (crc.id = MAT.onboarding_id)    
                                     join onboarding_termyear         per on (per.id = crc.term_year_id)   
                                left join finances_discount           dis on (dis.id = EXT.discount_id)  
                                left join finances_discounttype       dtp on (dtp.id = dis.type_id)        
								left join onboarding_gratuity         gra on (gra.id = mat.gratuity_id)
								left join onboarding_enrollmentstatus ers on (ers.id = mat.status_id)
    where dis.id is not null
GO


