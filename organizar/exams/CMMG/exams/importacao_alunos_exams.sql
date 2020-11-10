-- use exams_cmmg
-- commit
/************************************************************************************
 *                          PASSOS 
 *  - ATUALIZAR A TABELA [TMPIMP_PROVAEXAM] - origem excel 
 * 
 *
 ************************************************************************************/
 -- rollback 
 -- select * from erp_prd..tmpimp_provaexam


 drop table #TMP_CARGA

DECLARE @DATAEXECUCAO DATETIME      
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)
;

with cte_aluno_graducao as (
            select distinct alu.id as aluno_id, alu.nome as aluno_nome, alu.ra collate database_default as aluno_ra,
                   tur.nome as turma_nome, usu.email collate database_default as aluno_email,
                   periodo = pro.periodo,                                  
                   prova   = pro.prova, 
                   cur.id as curso_id, cur.nome as curso_nome, TUR.ID AS TURMA_ID, PRO.ENTIDADE, pro.external_id   
			
              from erp_prd..auth_user usu join erp_prd..academico_aluno                alu on (usu.person_id = alu.pessoa_id)
                                          join erp_prd..academico_turmadisciplinaaluno tda on (alu.id = tda.aluno_id)
                                          join erp_prd..academico_turmadisciplina      tds on (tds.id = tda.turma_disciplina_id)
                                          join erp_prd..academico_disciplina           dis on (dis.id = tds.disciplina_id)
                                          join erp_prd..academico_turma                tur on (tur.id = tds.turma_id)
                                          join erp_prd..academico_curso                cur on (cur.id = tur.curso_id)
                                          join erp_prd..tmpimp_provaexam               pro on (tur.nome = pro.turma      collate database_default and 
                                                                                               dis.nome = pro.disciplina collate database_default and 
                                                                                               cur.nome = pro.curso      collate database_default)
)

-- DROP TABLE #TMP_CARGA
-- select * from  #TMP_CARGA
-- ##### CARGA TABELA TEMPORARIA 
 select distinct    
        exam_id = pro.id, [user_id] = usu.id, should_update_answers = 0, created_at = @DATAEXECUCAO, updated_at = @DATAEXECUCAO,
        started_at = null, finished_at = null,timeout = null, forced_status = null, fel.aluno_ra, periodo =  fel.periodo  collate database_default , 
        FEL.TURMA_ID, turma_nome = FEL.TURMA_NOME collate database_default , fel.curso_id, curso_nome = fel.curso_nome  collate database_default , fel.external_id
       INTO #TMP_CARGA
  from 
       cte_aluno_graducao fel join auth_user                    usu on (fel.aluno_ra collate database_default = usu.public_identifier  collate database_default)
                              join exam_exam                    pro on (pro.external_id = fel.external_id)
                              left join application_application xxx on (xxx.exam_id = pro.id and
                                                                        xxx.[user_id] = usu.id)

--#################################################################################################################################################### 
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

--------------------------------------------------------------------------------
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
       APP.created_at in (select top 1 created_at from #TMP_CARGA)
    order by APP.id, EXI.[position]

-----------------------------------------------------------------------------------------------------
-- ### ATUALIZAR CAMPO EXTRA DO AUTH_USER 
-- ### CORRECAO DO CAMPO EXTRA 
--begin tran 

       UPDATE USU SET USU.EXTRA = JSON_MODIFY( JSON_MODIFY(
										  JSON_MODIFY(
                                              JSON_MODIFY(
                                                  JSON_MODIFY(
                                                      JSON_MODIFY(usu.extra, '$.hierarchy.class.value', aux.turma_id), 
                                                      '$.hierarchy.class.name', tur.turma_nome),
                                                  '$.hierarchy.grade.value', isnull(cast(hgr.value as varchar), '999999')),
                                              '$.hierarchy.grade.name', isnull(hgr.name,'Não informado') collate database_default),
                                         '$.hierarchy.class.value', isnull(htu.value,'Não informado') collate database_default),
                                    '$.hierarchy.class.name', isnull(htu.name,'Não informado') collate database_default)
   
			-- select distinct aux.* , usu.extra
              from #TMP_CARGA aux join auth_user                    usu on (usu.public_identifier = aux.aluno_ra)
                                 join erp_prd..vw_acd_turma_detalhe tur on (tur.turma_id = aux.TURMA_ID)
								 join hierarchy_hierarchy           htu on (htu.name  collate database_default = aux.turma_nome  collate database_default
								                                            and htu.type = 'class')
                                 join erp_prd..curriculos_grade     grd on (grd.id = tur.grade_id)      
                                 JOIN erp_prd..academico_etapa  eta on (eta.nome =  aux.periodo collate database_default)							                  
								 join hierarchy_hierarchy           hgr on (hgr.name  collate database_default = eta.nome  collate database_default
								                                            and hgr.type = 'grade')

----------------------------------------------------------------------------------------------------
-- #### ATUALIZAR O CAMPO EXTRA DO APPLICATION_APPLICATION 

DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"unity":{"value":"CMMG","name":"Faculdade Ciências Médicas"},"class":{"value":"CMMG","name":"CMMG"},"grade":{"value":"999999","name":"Não informado"},"curso":{"value":"999999","name":"Não informado"}}}'
  
UPDATE app SET app.extra = 
                 JSON_MODIFY(
	                 JSON_MODIFY(
	                     JSON_MODIFY(
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                     JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', tur.value), 
                                     '$.hierarchy.class.name', tur.name),
                                 '$.hierarchy.grade.value', gra.value),
                             '$.hierarchy.grade.name', gra.name), 
					     '$.hierarchy.curso.name', car.curso_nome),
			         '$.hierarchy.curso.value', car.curso_id)

  FROM #TMP_CARGA CAR JOIN APPLICATION_APPLICATION APP ON (APP.user_id = CAR.user_id AND CAR.exam_id = APP.exam_id)
                   left    JOIN hierarchy_hierarchy     TUR ON (TUR.NAME = CAR.turma_nome AND TUR.type = 'class')
                    left  JOIN hierarchy_hierarchy     gra ON (gra.NAME = CAR.periodo AND gra.type = 'grade')

--#####################################################################################################
DECLARE @JSON_AUX_EXA VARCHAR(MAX)
SET @JSON_AUX_EXA = '{"hierarchy": {"unity":{"value":"CMMG","name":"Faculdade Ciências Médicas"},"discipline":{"value":"99999","name":"Não informado"},"grade":{"value":"999999","name":"Não informado"},"curso":{"value":"999999","name":"Não informado"}}}'
  
       UPDATE exa SET exa.EXTRA = JSON_MODIFY(
                                      JSON_MODIFY(
											JSON_MODIFY(
												JSON_MODIFY(
												  JSON_MODIFY(
													  JSON_MODIFY(@JSON_AUX_EXA, '$.hierarchy.discipline.value', vw.disciplina_id), 
													  '$.hierarchy.discipline.name', vw.disciplina_nome),
												  '$.hierarchy.grade.value', gra.value),
											  '$.hierarchy.grade.name', gra.name),
											'$.hierarchy.curso.value', vw.curso_id),
										'$.hierarchy.curso.name', vw.curso_nome)
FROM exam_exam exa JOIN vw_educat_cmmg_curso_disciplina_periodo vw ON (exa.external_id = vw.id_avaliacao)
                   JOIN hierarchy_hierarchy     gra ON (gra.NAME = vw.periodo_nome AND gra.type = 'grade')
 WHERE id_avaliacao  in (select top 1 external_id from #TMP_CARGA)

-----------------------------------------------------------------------------------------------------
select usu.id , usu.name as aluno_nome from auth_user usu 
where usu.id in (select user_id   --,  count(1) 
                 from #TMP_CARGA
                 group by user_id
                 having count(1) > 1)

-----------------------------------------------------------------------------------------------------
select top 1 external_id from #TMP_CARGA



select *  from #TMP_CARGA 
 