-- use exams_cmmg

/************************************************************************************
 *                          PASSOS 
 *  - ATUALIZAR A TABELA [TMPIMP_PROVAEXAM] - origem excel 
 * 
 *
 ************************************************************************************/
 -- rollback 
 -- select * from erp_prd..tmpimp_provaexam
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
            --where tda.status_matricula_disciplina_id = 1  
			

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
    where fel.aluno_email not in ('','laa@sgcomex.com.br')

--#################################################################################################################################################### 
-- #### CARGA NA TABELA APPLICATION
insert into application_application (exam_id, user_id, should_update_answers, created_at, updated_at, started_at, finished_at, timeout, forced_status)
select --distinct 
       exam_id = CAR.exam_id, [user_id] = CAR.[user_id], should_update_answers = CAR.should_update_answers,
       created_at = CAR.created_at , updated_at = CAR.updated_at,
       started_at = null, finished_at = null,timeout = null, forced_status = CAR.forced_status
  from 
       #TMP_CARGA CAR left join application_application xxx on (xxx.exam_id = CAR.exam_id and
                                                                xxx.[user_id] = CAR.[user_id])
WHERE XXX.ID IS NULL 

--------------------------------------------------------------------------------
-- #### CARGA NA TABELA ANSWER
---   insert into application_answer ([position], application_id, item_id, created_at, updated_at, seconds)
select distinct 
       EXI.position, application_id = APP.id, EXI.item_id, created_at = APP.created_at, updated_at = APP.created_at, seconds = 0 
  from 
       application_application APP join exam_exam          EXA on (EXA.id = APP.exam_id)
                                   join exam_examitem      EXI on (EXA.id = EXI.exam_id)
	                               join auth_user          USU on (USU.id = apP.user_id)
                              left join application_answer xxx on (APP.id = xxx.application_id and 
                                                                   EXI.item_id = xxx.item_id)
 where xxx.id is null AND        
       APP.created_at = '2020-09-21 08:28:32'
    order by APP.id, EXI.[position]


-- ### ATUALIZAR CAMPO EXTRA DO AUTH_USER 
begin tran 

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
    --         SELECT distinct usu.name,  usu.extra,
    --                EXTRA =     JSON_MODIFY( JSON_MODIFY(
	--			             			  JSON_MODIFY(
    --                                          JSON_MODIFY(
    --                                              JSON_MODIFY(
    --                                                  JSON_MODIFY(usu.extra, '$.hierarchy.class.value', aux.turma_id), 
    --                                                  '$.hierarchy.class.name', tur.turma_nome),
    --                                              '$.hierarchy.grade.value', isnull(cast(hgr.value as varchar), '999999')),
    --                                          '$.hierarchy.grade.name', isnull(hgr.name,'Não informado') collate database_default),
    --                                     '$.hierarchy.class.value', isnull(htu.value,'Não informado') collate database_default),
    --                                '$.hierarchy.class.name', isnull(htu.name,'Não informado') collate database_default)
			 
              from #TMP_CARGA aux join auth_user                    usu on (usu.public_identifier = aux.aluno_ra)
                                 join erp_prd..vw_acd_turma_detalhe tur on (tur.turma_id = aux.TURMA_ID)
								 join hierarchy_hierarchy           htu on (htu.name  collate database_default = aux.turma_nome  collate database_default
								                                            and htu.type = 'class')
                                 join erp_prd..curriculos_grade     grd on (grd.id = tur.grade_id)      
                                 JOIN erp_prd..academico_etapa  eta on (
                                                                            eta.nome =  aux.periodo collate database_default)
							                  
								 join hierarchy_hierarchy           hgr on (hgr.name  collate database_default = eta.nome  collate database_default
								                                            and hgr.type = 'grade')
        WHERE --USU.EXTRA IS NULL  and 
		      aux.external_id = 380


        -- COMMIT 

        -- ROLLBACK 


		select * from  erp_prd..academico_etapa
		
		select * from 

-- #### ATUALIZAR O CAMPO EXTRA DO APPLICATION_APPLICATION 
DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"unity":{"value":"CMMG","name":"Faculdade Ciências Médicas"},"class":{"value":"CMMG","name":"CMMG"},"grade":{"value":"999999","name":"Não informado"},"curso":{"value":"999999","name":"Não informado"}}}'
  
--SELECT DISTINCT APP.*,
--  UPDATE APP SET APP.EXTRA = '{"hierarchy": {"class":{"value":"' + CONVERT(VARCHAR(20), CAR.TURMA_ID) + '","name":"' + CAR.TURMA_NOME + '"}}}'
  
--SELECT *,
UPDATE app SET app.extra = 
                 JSON_MODIFY(
	                 JSON_MODIFY(
	                     JSON_MODIFY(
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                     JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', CAR.TURMA_NOME), 
                                     '$.hierarchy.class.name', car.turma_nome),
                                 '$.hierarchy.grade.value', 99999999),
                             '$.hierarchy.grade.name', car.periodo), 
					     '$.hierarchy.curso.name', car.curso_nome),
			         '$.hierarchy.curso.value', car.curso_id)
--SELECT *				
FROM APPLICATION_APPLICATION APP JOIN EXAM_EXAM EXA ON (APP.EXAM_ID = EXA.ID)
                                 JOIN #TMP_CARGA CAR ON(CAR.exam_id = EXA.ID AND 
                                                          CAR.user_id = APP.user_id)
WHERE  exa.external_id = 380 and 
   --   exa.name = 'APIC do 7º período de Medicina - 1º/2020'
      CAR.TURMA_NOME IN   (
	 select turma collate database_default from erp_prd..tmpimp_provaexam
	 )


	 select distinct turma_nome from #TMP_CARGA

--#####################################################################################################
DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX = '{"hierarchy": {"unity":{"value":"CMMG","name":"Faculdade Ciências Médicas"},"discipline":{"value":"99999","name":"Não informado"},"grade":{"value":"999999","name":"Não informado"},"curso":{"value":"999999","name":"Não informado"}}}'
  
       UPDATE exa SET exa.EXTRA = JSON_MODIFY(
                                      JSON_MODIFY(
											JSON_MODIFY(
												JSON_MODIFY(
												  JSON_MODIFY(
													  JSON_MODIFY(@JSON_AUX, '$.hierarchy.discipline.value', vw.disciplina_id), 
													  '$.hierarchy.discipline.name', vw.disciplina_nome),
												  '$.hierarchy.grade.value', vw.periodo_id),
											  '$.hierarchy.grade.name', vw.periodo_nome),
											'$.hierarchy.curso.value', vw.curso_id),
										'$.hierarchy.curso.name', vw.curso_nome)
--SELECT *
FROM exam_exam exa JOIN vw_educat_cmmg_curso_disciplina_periodo vw ON (exa.external_id = vw.id_avaliacao)
 WHERE id_avaliacao = 367



 Mensagem 2627, Nível 14, Estado 1, Linha 173
Violation of UNIQUE KEY constraint 'UQ__auth_use__F3DBC572CAB7BCB0'. Cannot insert duplicate key in object 'dbo.auth_user'. The duplicate key value is (20201.00020).
The statement has been terminated.

Horário de conclusão: 2020-09-17T13:20:09.0921072-03:00


DECLARE @JSON_AUX VARCHAR(MAX)
SET @JSON_AUX =  '{"hierarchy": {"unity":{"value":"A982B54F-E41C-48D7-B261-2D374166631A","name":"Faculdade Ciências Médicas"},"discipline":{"value":"99999","name":"Não informado"},"grade":{"value":"999999","name":"Não informado"},"class":{"value":"999999","name":"Não informado"}}}'
    
;

WITH cte_grade AS (
			SELECT distinct name collate database_default AS grade_nome,  
			 cast(max(value) as varchar(200)) AS grade_value
			 from hierarchy_hierarchy WHERE type = 'grade'
			 group by name, type
)
	,	cte_turma as (
			SELECT distinct name collate database_default AS Turma_nome, 
			cast(max(value) as varchar(200)) AS turma_value
			 from hierarchy_hierarchy WHERE type = 'class' 
			 group by name, type
)


 /*   insert into auth_user (password, last_login, is_superuser, username, first_name, last_name, email, 
                           is_staff, is_active, date_joined, name, public_identifier, extra, provider_id, 
    					   created_at, updated_at, welcome_email_sent_at)
 select distinct password = '', 
        last_login = null, 
		is_superuser = 0,
		username = alu.aluno_ra, 
		first_name = CASE WHEN charindex(' ',alu.aluno_nome) > 0 THEN left (alu.aluno_nome,  charindex(' ',alu.aluno_nome)-1)
                                                                 ELSE alu.aluno_nome END,
		last_name = alu.aluno_nome, email = alu.aluno_email, 
        is_staff = 0, is_active = 1, 
		date_joined = getdate(), name = alu.aluno_nome, public_identifier = alu.aluno_ra, 
		extra =          JSON_MODIFY(
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                    JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', tur.turma_value), 
                                     '$.hierarchy.class.name', tur.Turma_nome),
                                 '$.hierarchy.grade.value', gra.grade_value),
                             '$.hierarchy.grade.name', gra.grade_nome), 
		provider_id = 1, 
	    created_at = getdate(), updated_at  = getdate(), welcome_email_sent_at = null*/
  --select alu.*
 update usu set usu.extra =          JSON_MODIFY(
                             JSON_MODIFY(
                                 JSON_MODIFY(
                                    JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', tur.turma_value), 
                                     '$.hierarchy.class.name', tur.Turma_nome),
                                 '$.hierarchy.grade.value', gra.grade_value),
                             '$.hierarchy.grade.name', gra.grade_nome)


 from  #tmp_aluno alu  join auth_user usu On (alu.aluno_ra = usu.public_identifier)
                      left JOIN cte_grade gra ON (gra.grade_nome = alu.periodo)
                      left join cte_turma tur on (tur.turma_nome = alu.turma_nome)
 where usu.id is not  null and alu.aluno_email not in ('','laa@sgcomex.com.br')




 select * from auth_user where extra is not null 

 select * from hierarchy_hierarchy

 insert into hierarchy_hierarchy ( type, value, name, parent_id)
 select tipo,  newid(),nome, parent_id from (
 select distinct 'grade' as tipo,periodo as nome, 15 as parent_id from #tmp_aluno) as tab

 
 insert into hierarchy_hierarchy ( type, value, name, parent_id)
 select distinct 'class' as tipo,turma_id, turma_nome as nome, 16 as parent_id 
 from #tmp_aluno alu left join hierarchy_hierarchy hie on (alu.TURMA_ID = hie.value and 
                                                           parent_id = 16)
 where hie.id is null 


 select * from #tmp_aluno where aluno_ra in ('20201.00312', '20201.00020') and aluno_email not in ('','laa@sgcomex.com.br')





select alu.*
 from  #tmp_aluno alu left join auth_user usu On (alu.aluno_ra = usu.public_identifier)
                      
 where usu.id is not  null and alu.aluno_email not in ('','laa@sgcomex.com.br')


 select * from application_application where id = 




 select aluno_ra, count(1)
 from #TMP_CARGA
 group by aluno_ra 
 having count(1) > 1


 select * from hierarchy_hierarchy where type = 'grade'

 insert into hierarchy_hierarchy
 select distinct type = 'grade', newid(), '2º período', 15  





 
insert into hierarchy_hierarchy (type, value, name, parent_id)
 select distinct type = 'class',value = 5754,'M073S02A202T', parent_id = 16
  SELECT distinct turma_id, turma_nome                        
              from #TMP_CARGA aux

where turma_nome not in (		select name from hierarchy_hierarchy	  )


