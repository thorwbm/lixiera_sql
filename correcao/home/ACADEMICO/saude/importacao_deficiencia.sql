-- ############################################################################################################
-- criar view na matricula e rematricula
create or ALTER view [dbo].[vw_aluno_deficiencia] as 
select distinct 
       PES.real_name as Aluno_nome, PES.cpf as aluno_CPF, ENR.student_id as aluno_ra, pes.email as aluno_email, 
       dis.name as aluno_Deficiencia, nec.name aluno_necessidade, origem = 'MATRICULA'

  from personal_personaldata per join personal_personaldata_disabilities  def on (per.id = def.personaldata_id)
                                 join onboarding_enrollment               enr on (enr.id = per.enrollment_id)
                            left join core_handicapoption                 HAN on (HAN.id = per.handicap_id)
                                 join onboarding_onboarding               ONB on (ONB.id = enr.onboarding_id)
                                 join onboarding_termyear                 TER on (TER.id = ONB.term_year_id)
                                 join core_disability                     dis on (dis.id = def.disability_id)
                                 JOIN personal_personaldata               PES ON (ENR.ID = PES.enrollment_id)
                            left join personal_personaldata_special_needs nea on (pes.id = nea.personaldata_id)
                            left join core_specialneed                    nec on (nec.id = nea.specialneed_id)
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-- #############################################################################################################
-- criar view que unifica matricula e rematricula no portal
drop view vw_sau_aluno_deficiencia_mat_rem


create or alter view vw_sau_aluno_deficiencia_mat_rem as 
select * from mat_prd..vw_aluno_deficiencia 
union
select * from rem_prd..vw_aluno_deficiencia  
---------------------------------------------------------------------------------------------------------------
--############################################################################################################
-- cargas 
    -- tabela necesidades 
    insert into censo_necessidadeespecial (nome) 
    select distinct 
           def.aluno_necessidade collate database_default
      from
           vw_sau_aluno_deficiencia_mat_rem def left join censo_necessidadeespecial nec on (def.aluno_necessidade collate database_default = nec.nome collate database_default)
     where  
           nec.id is  null  and 
           def.aluno_necessidade is not null 
     order by 1

-- select distinct aluno_necessidade from vw_sau_aluno_deficiencia_mat_rem
--select *  from censo_necessidadeespecial 
----------------------------------------------------------------------------------------------------------------

    -- tabela censo tipo deficiencia
    insert into censo_tipodeficiencia (nome)
    select distinct 
           def.aluno_deficiencia collate database_default
      from
           vw_sau_aluno_deficiencia_mat_rem def left join censo_tipodeficiencia tpd on (def.aluno_deficiencia collate database_default = tpd.nome collate database_default)
     where  
           tpd.id is null 
     order by 1

 --   select * from censo_tipodeficiencia
----------------------------------------------------------------------------------------------------------------

    -- tabela censo aluno deficiencia
    insert into censo_censo_necessidades_especiais (censo_id, necessidadeespecial_id)
    select distinct 
           censo_id = cen.id, 
           necessidadeespecial_id = nes.id   
      from 
           censo_censo cen join vw_Curriculo_aluno_pessoa          pes on (cen.aluno_id = pes.aluno_id)
                           join vw_sau_aluno_deficiencia_mat_rem   def on (def.aluno_ra = pes.aluno_ra collate database_default)
                           join censo_necessidadeespecial          nes on (nes.nome = def.aluno_necessidade collate database_default)
                      left join censo_censo_necessidades_especiais xxx on (cen.id = xxx.censo_id and 
                                                                           nes.id = xxx.necessidadeespecial_id)
     where xxx.id is null 
     order by cen.id

-- select * from censo_censo_necessidades_especiais
select * from vw_sau_aluno_deficiencia_mat_rem where aluno_necessidade is not null 
---------------------------------------------------------------------------------------------------------

    -- tabela censo aluno deficiencia
    insert into censo_censo_tipo_deficiencias (censo_id, tipodeficiencia_id)
    select distinct 
           censo_id = cen.id, 
           tipodeficiencia_id = tpd.id   
      from 
           censo_censo cen join vw_Curriculo_aluno_pessoa          pes on (cen.aluno_id = pes.aluno_id)
                           join vw_sau_aluno_deficiencia_mat_rem   def on (def.aluno_ra = pes.aluno_ra collate database_default)
                           join censo_tipodeficiencia              tpd on (tpd.nome = def.aluno_Deficiencia collate database_default)
                      left join censo_censo_tipo_deficiencias      xxx on (cen.id = xxx.censo_id and 
                                                                           tpd.id = xxx.tipodeficiencia_id)
     where xxx.id is null 
     order by cen.id

-- select top 10 * from censo_censo_tipo_deficiencias
--- select * from vw_sau_aluno_deficiencia_mat_rem where aluno_necessidade is not null 
---------------------------------------------------------------------------------------------------------
select * 
-- begin tran update cen set cen.deficiencia_id = 1
from censo_censo cen join censo_censo_tipo_deficiencias def on (cen.id = def.censo_id)
where deficiencia_id <> 1 and aluno_id = 60771

--  commit 
--  rollback


select * from censo_deficiencia



create or alter view vw_sau_aluno_deficiencia as 
select distinct 
       alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra,
       cdf.id as deficiencia_id, cdf.nome as deficiencia_nome, 
       tpd.id as necessidade_id, tpd.nome as necessidade_nome, cen.deficiencia_id      
  from censo_censo cen join academico_aluno                    alu on (alu.id = cen.aluno_id)
                       join censo_censo_tipo_deficiencias      ctp on (cen.id = ctp.censo_id)
                       join censo_tipodeficiencia              cdf on (cdf.id = ctp.tipodeficiencia_id)
                  left join censo_censo_necessidades_especiais cne on (cen.id = cne.censo_id)
                  left join censo_necessidadeespecial          tpd on (tpd.id = cne.necessidadeespecial_id)

order by alu.nome
                                              
select * from vw_sau_aluno_deficienc

select * from academico_aluno where nome = 'ANA PAULA GOMES DE OLIVEIRA MAGALHÃES'
select * from censo_censo where aluno_id = 60223
select * from censo_censo_necessidades_especiais where censo_id = 8555
select * from censo_censo_tipo_deficiencias where id = 13
select * from censo_tipodeficiencia where id = 2
select * from censo_censo_tipo_deficiencias where id = 2


