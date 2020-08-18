-- use exams_cmmg

/************************************************************************************
 *                          PASSOS 
 *  - ATUALIZAR A TABELA [TMPIMP_PROVAEXAM] - origem excel 
 * 
 *
 ************************************************************************************/
 -- rollback 

 -- drop table #TMP_CARGA

DECLARE @DATAEXECUCAO DATETIME      
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)
--begin tran; 
;
with cte_aluno_graducao as (
            select distinct alu.id as aluno_id, alu.nome as aluno_nome, alu.ra collate database_default as aluno_ra,
                   tur.nome as turma_nome, usu.email collate database_default as aluno_email,
                   periodo = pro.periodo,                                  
                   prova   = pro.prova, 
                   cur.id as curso_id, cur.nome as curso_nome, TUR.ID AS TURMA_ID, PRO.ENTIDADE 
                    
              from erp_prd..auth_user usu join erp_prd..academico_aluno         alu on (usu.person_id = alu.pessoa_id)
                                          join erp_prd..academico_turmadisciplinaaluno tda on (alu.id = tda.aluno_id)
                                          join erp_prd..academico_turmadisciplina      tds on (tds.id = tda.turma_disciplina_id)
                                          join erp_prd..academico_disciplina           dis on (dis.id = tds.disciplina_id)
                                          join erp_prd..academico_turma                tur on (tur.id = tds.turma_id)
                                          join erp_prd..academico_curso                cur on (cur.id = tur.curso_id)
                                          join erp_prd..tmpimp_provaexam               pro on (tur.nome = pro.turma and 
                                                                                                      dis.nome = pro.disciplina and 
                                                                                                      cur.nome = pro.curso)
            where tda.status_matricula_disciplina_id = 1  
)
-- DROP TABLE #TMP_CARGA

-- ##### CARGA TABELA TEMPORARIA 
 select distinct    
        exam_id = pro.id, [user_id] = usu.id, should_update_answers = 0, created_at = @DATAEXECUCAO, updated_at = @DATAEXECUCAO,
        started_at = null, finished_at = null,timeout = null, forced_status = null, fel.aluno_ra, fel.TURMA_ID, fel.periodo
       INTO #TMP_CARGA
  from 
       cte_aluno_graducao fel join auth_user usu on (fel.aluno_ra collate database_default = usu.public_identifier  collate database_default)
                              join exam_exam pro on (pro.name collate database_default = fel.prova collate database_default)
                              left join application_application xxx on (xxx.exam_id = pro.id and
                                                                   xxx.[user_id] = usu.id)
  
-- #### CARGA NA TABELA APPLICATION
insert into application_application (exam_id, user_id, should_update_answers, created_at, updated_at, started_at, finished_at, timeout, forced_status)
select distinct 
       exam_id = CAR.exam_id, [user_id] = CAR.[user_id], should_update_answers = CAR.should_update_answers,
       created_at = CAR.created_at , updated_at = CAR.updated_at,
       started_at = null, finished_at = null,timeout = null, forced_status = CAR.forced_status
  from 
       #TMP_CARGA CAR left join application_application xxx on (xxx.exam_id = CAR.exam_id and
                                                                xxx.[user_id] = CAR.[user_id])
WHERE XXX.ID IS NULL 
-- #### CARGA NA TABELA ANSWER
insert into application_answer ([position], application_id, item_id, created_at, updated_at, seconds)
select distinct 
       EXI.position, application_id = APP.id, EXI.item_id, created_at = APP.created_at, updated_at = APP.created_at, seconds = 0 
  from 
       application_application APP join exam_exam          EXA on (EXA.id = APP.exam_id)
                                   join exam_examitem      EXI on (EXA.id = EXI.exam_id)
	                               join auth_user          USU on (USU.id = apP.user_id)
                              left join application_answer xxx on (APP.id = xxx.application_id and 
                                                                   EXI.item_id = xxx.item_id)
 where xxx.id is null AND 
       APP.created_at = '2020-06-12 18:44:29.0000000'
    order by APP.id, EXI.[position]

    select * from #TMP_CARGA

-- ### ATUALIZAR CAMPO EXTRA DO AUTH_USER 
begin tran 
DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"unity":{"value":"CMMG","name":"Faculdade Ciências Médicas"},"class":{"value":"CMMG","name":"CMMG"},"grade":{"value":"999999","name":"Não informado"}}}'
  
       UPDATE USU SET USU.EXTRA = JSON_MODIFY(
                                      JSON_MODIFY(
                                          JSON_MODIFY(
                                              JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', aux.turma_id), 
                                              '$.hierarchy.class.name', tur.turma_nome),
                                          '$.hierarchy.grade.value', isnull(cast(eta.id as varchar), '999999')),
                                      '$.hierarchy.grade.name', isnull(eta.nome,'Não informado') collate database_default)
                                      
              from #TMP_CARGA aux join auth_user                    usu on (usu.public_identifier = aux.aluno_ra)
                                 join erp_prd..vw_acd_turma_detalhe tur on (tur.turma_id = aux.TURMA_ID)
                                 join erp_prd..curriculos_grade     grd on (grd.id = tur.grade_id)                                  
                              left   JOIN erp_prd..academico_etapa  eta on (eta.id = grd.etapa_id and  
                                                                            eta.nome =  aux.periodo)
        WHERE USU.EXTRA IS NULL 


        -- COMMIT 

        -- ROLLBACK 


DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"unity":{"value":"CMMG","name":"Faculdade Ciências Médicas"},"class":{"value":"CMMG","name":"CMMG"},"grade":{"value":"999999","name":"Não informado"}}}'
  
      select * , 
      EXTRA = JSON_MODIFY(
                                      JSON_MODIFY(
                                          JSON_MODIFY(
                                              JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', aux.turma_id), 
                                              '$.hierarchy.class.name', tur.turma_nome),
                                          '$.hierarchy.grade.value', isnull(cast(eta.id as varchar), '999999')),
                                      '$.hierarchy.grade.name', isnull(aux.periodo,'Não informado') collate database_default)
              from #TMP_CARGA aux join auth_user                            usu on (usu.public_identifier = aux.aluno_ra)
                                  join erp_prd..vw_acd_turma_detalhe tur on (tur.turma_id = aux.TURMA_ID)
                                  join erp_prd..curriculos_grade     grd on (grd.id = tur.grade_id)                                  
                             left JOIN erp_prd..academico_etapa      eta on (eta.id = grd.etapa_id and  
                                                                                    eta.nome =  aux.periodo)
        WHERE USU.EXTRA IS NULL 

select distinct exa.id ,exa.name--, count(car.user_id)
from #TMP_CARGA car join exam_exam exa on (exa.id = car.exam_id)
               --     join application_application app 
group by exa.name


select * from  tmp_application_answer_202020612 from application_application


select *  from application_answer where application_id in (
select id from application_application where exam_id in (9,12,10,13,11,14))
and (free_response is not null or alternative_id is not null )


select id delete  from application_application where exam_id in (9,12,10,13,11,14)



select * delete from application_applicationtimewindow 
where application_id in (select id   from application_application where exam_id in (9,12,10,13,11,14))



select * from application_application