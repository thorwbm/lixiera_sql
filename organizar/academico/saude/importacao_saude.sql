/*
- saude_dadosaude: As informações da pessoa e do plano de saúde "health_data"
- saude_perguntadado: As respostas de uma pessoa ao questionário "health_dataquestion"
- saude_contato: As informações de contato de emergencia da pessoa "health_contact"
- saude_vacina: As informações de vacina da pessoa "health_datavaccine"
*/
create or alter view vw_sau_questionario_saude_matricula as 
select distinct 
       alu.student_id as aluno_ra, pes.real_name as aluno_nome, pes.cpf as aluno_cpf, 
       dat.health_insurrance as plano_saude, dat.health_insurrance_enrollment as plano_saude_numero, 
	   dat.health_insurrance_phone as plano_saude_fone,  dat.hospital, dat.has_insurrance as plano_saude_tem, 
	   dat.has_medications as medicacao_usa, dat.medications as medicacao,
	   QUE.ID AS QUESTAO_ID, QUE.description QUESTAO_NOME, 
	   DQU.answer as resposta, DQU.observation as observacao, 
	   tps.id as tipo_sanguineo_id, tps.name as tipo_sanguineo_nome, 
	   con.name as contato_nome, con.landline_number as contato_fone_fixo, con.phone_number as contato_telefone,
	   con.relationship as contato_parentesco,
	   dvc.expiration_date as vacina_data_expiracao, dvc.observation as vacina_observacao, dvc.has_exam as vacina_exame_possui, 
	   dvc.exam_result as resultado_exame, doc.name as vacina_exame,
	   vac.id as vacina_id, vac.name as vacina_nome, vac.doses as vacina_doses 
  from health_data dat join health_dataquestion   DQU on (dat.id = DQU.health_data_id)
                       JOIN health_question       QUE ON (QUE.ID = DQU.health_question_id)
                       join health_bloodtype      tps on (tps.id = dat.blood_type_id)
					   join onboarding_enrollment alu on (alu.id = dat.enrollment_id)
					   join personal_personaldata pes on (alu.id = pes.enrollment_id)
				  left join health_contact        con on (dat.id = con.health_data_id)
				  left join health_datavaccine    dvc on (dat.id = dvc.health_data_id)
				  left join health_vaccine        vac on (vac.id = dvc.health_vaccine_id)
				  left join core_document         doc on (doc.id = dvc.exam_id)
				  
				  
-- select * from health_datavaccine 
-- select * from health_vaccine 