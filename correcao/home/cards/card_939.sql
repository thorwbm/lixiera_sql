DECLARE @DATAEXECUCAO DATETIME, @JSON_AUX VARCHAR(MAX)     
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)
SET @JSON_AUX = '{"hierarchy": {"unity":{"value":"CMMG","name":"Faculdade Ciências Médicas"},"class":{"value":"CMMG","name":"CMMG"},"grade":{"value":"999999","name":"Não informado"}}}'
                 ;
--begin tran; 


with cte_aluno_graducao as (
            select distinct usu.id as usuario_id, alu.id as aluno_id, alu.nome as aluno_nome, alu.ra collate database_default as aluno_ra,
                   CAST(TUR.ID AS VARCHAR) AS TURMA_ID, tur.nome as turma_nome, usu.email collate database_default as aluno_email,
                   periodo = case when tur.nome = 'E015A01A201T' then '1º período'
                                  when tur.nome = 'E014A02A201T' then '3º período'
                                  when tur.nome = 'E013S07A201T' then '7º período'                                  
                                  when tur.nome in ('M073S01A201T', 'M073S01B201T', 'M073S01C201T', 'M073S01D201T') then '1º período'
                                  when tur.nome in ('M072S02A201T', 'M072S02B201T', 'M072S02C201T', 'M072S02D201T') then '2º período'
                                  when tur.nome in ('M071S03A201T', 'M071S03B201T', 'M071S03C201T', 'M071S03D201T') then '3º período'
                                  when tur.nome in ('M070A02A201T', 'M070A02B201T', 'M070A02C201T', 'M070A02D201T') then '4º período'
                                  when tur.nome in ('M069A03A201T', 'M069A03B201T', 'M069A03C201T')                 then '5º período'
                                  when tur.nome in ('M068A03A201T', 'M068A03B201T'                                 ) then '6º período'end ,
                                  
                   prova   = case when tur.nome = 'E015A01A201T' then 'APIC do 1º período de Enfermagem - 1º/2020'
                                  when tur.nome = 'E014A02A201T' then 'APIC do 3º período de Enfermagem - 1º/2020'
                                  when tur.nome = 'E013S07A201T' then 'APIC do 7º período de Enfermagem - 1º/2020'                                  
                                  when tur.nome in ('M073S01A201T', 'M073S01B201T', 'M073S01C201T', 'M073S01D201T') then 'APIC do 1º período de Medicina - 1º/2020'
                                  when tur.nome in ('M072S02A201T', 'M072S02B201T', 'M072S02C201T', 'M072S02D201T') then 'APIC do 2º período de Medicina - 1º/2020'
                                  when tur.nome in ('M071S03A201T', 'M071S03B201T', 'M071S03C201T', 'M071S03D201T') then 'APIC do 3º período de Medicina - 1º/2020'
                                  when tur.nome in ('M070A02A201T', 'M070A02B201T', 'M070A02C201T', 'M070A02D201T') then 'APIC do 4º período de Medicina - 1º/2020'
                                  when tur.nome in ('M069A03A201T', 'M069A03B201T', 'M069A03C201T')                 then 'APIC do 5º período de Medicina - 1º/2020'
                                  when tur.nome in ('M068A03A201T', 'M068A03B201T'                                ) then 'APIC do 6º período de Medicina - 1º/2020'end , 
                   curso   = case when left(tur.nome,1) = 'E' then 'enfermagem' 
                                  when left(tur.nome,1) = 'M' then 'medicina' end 
              from erp_prd..auth_user usu join erp_prd..academico_aluno                alu on (usu.id = alu.user_id)
                                          join erp_prd..academico_turmadisciplinaaluno tda on (alu.id = tda.aluno_id)
                                          join erp_prd..academico_turmadisciplina      tds on (tds.id = tda.turma_disciplina_id)
                                          join erp_prd..academico_turma                tur on (tur.id = tds.turma_id)
                                          
             where tda.status_matricula_disciplina_id = 1 and 
                   tur.nome in (
                    'E015A01A201T',                                                 -- enfermagem 1 periodo
                    'E014A02A201T',                                                 -- enfermagem 3 periodo
                    'E013S07A201T',                                                 -- enfermagem 7 periodo
                    'M073S01A201T', 'M073S01B201T', 'M073S01C201T', 'M073S01D201T', -- medicina 1 periodo
                    'M072S02A201T', 'M072S02B201T', 'M072S02C201T', 'M072S02D201T', -- medicina 2 periodo
                    'M071S03A201T', 'M071S03B201T', 'M071S03C201T', 'M071S03D201T', -- medicina 3 periodo
                    'M070A02A201T', 'M070A02B201T', 'M070A02C201T', 'M070A02D201T', -- medicina 4 periodo
                    'M069A03A201T', 'M069A03B201T', 'M069A03C201T',                 -- medicina 5 periodo
                    'M068A03A201T', 'M068A03B201T'                                  -- medicina 6 periodo
                 )
)

    ,   cte_aux_1 as (
            select distinct gra.usuario_id, gra.aluno_id, gra.aluno_nome, gra.aluno_ra, gra.aluno_email, gra.periodo, gra.prova, gra.curso,
                            min(turma_id)as turma_id
            from cte_aluno_graducao gra join auth_user usu on (gra.aluno_ra = usu.public_identifier)
            where aluno_id in (select aluno_id
                                 from cte_aluno_graducao
                                group by aluno_id 
                               having count(distinct prova) = 1 and 
                                      count(distinct turma_id) > 1) and 
                                      usu.extra is null 
          group by gra.usuario_id, gra.aluno_id, gra.aluno_nome, gra.aluno_ra, gra.aluno_email, gra.periodo, gra.prova, gra.curso
)
            select distinct aux.*, tur.turma_nome, eta.id, tur.etapa_id
            /*,
                   extra =  JSON_MODIFY(
                                JSON_MODIFY(
                                    JSON_MODIFY(
                                        JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', aux.turma_id), 
                                        '$.hierarchy.class.name', tur.nome),
                                    '$.hierarchy.grade.value', cast(eta.id as varchar)),
                                '$.hierarchy.grade.name', eta.nome collate database_default)*/
              from cte_aux_1 aux join auth_user                     usu on (usu.public_identifier = aux.aluno_ra)
                                 join erp_prd..vw_acd_turma_detalhe tur on (tur.turma_id = aux.TURMA_ID)
                                 join erp_prd..curriculos_grade     grd on (grd.id = tur.grade_id)                                  
                              left   JOIN erp_prd..academico_etapa  eta on (eta.id = grd.etapa_id and  
                                                                            eta.nome =  aux.periodo)
order by aluno_nome

/*
--drop table #tmpUsuario
   -- ,   cte_carga_json as (
                select distinct 
                
                       gra.*, eta.nome , eta.id,--, 
                extra =  JSON_MODIFY(
                       JSON_MODIFY(
                           JSON_MODIFY(
                               JSON_MODIFY(@JSON_AUX, '$.hierarchy.class.value', gra.turma_id), 
                               '$.hierarchy.class.name', gra.turma_nome),
                           '$.hierarchy.grade.value', cast(eta.id as varchar)),
                       '$.hierarchy.grade.name', eta.nome collate database_default)

                   into #tmpUsuario       
                 from cte_aluno_graducao GRA JOIN erp_prd..academico_etapa eta on (eta.nome =  gra.periodo)
                                             join erp_prd..curriculos_grade grd on (grd.etapa_id = eta.id) 
                                             join erp_prd..academico_turma tur on (tur.id = gra.TURMA_ID and 
                                                                                   tur.grade_id = grd.id)

                 where gra.aluno_id in ( select aluno_id
                                        from #temp 
                                        group by aluno_id
                                        having count(distinct turma_id) = 1)
        order by aluno_nome

        select * 
        --update usu set usu.extra = tmp.extra
        from auth_user usu join #tmpUsuario tmp on (usu.public_identifier = tmp.aluno_ra)
         where usu.extra is null  

*/


-- #### CARGA NA TABELA APPLICATION
--insert into application_application (exam_id, user_id, should_update_answers, created_at, updated_at, started_at, finished_at, timeout, forced_status)
select distinct 
       exam_id = pro.id, [user_id] = usu.id, should_update_answers = 0, created_at = @DATAEXECUCAO, updated_at = @DATAEXECUCAO,
       started_at = null, finished_at = null,timeout = null, forced_status = null
  from 
       cte_aluno_graducao fel join auth_user usu on (fel.aluno_ra collate database_default = usu.public_identifier  collate database_default)
                              join exam_exam pro on (pro.name collate database_default = fel.prova collate database_default)
                         left join application_application xxx on (xxx.exam_id = pro.id and
                                                                   xxx.[user_id] = usu.id)

-- #### CARGA NA TABELA ANSWER
--insert into application_answer ([position], application_id, item_id, created_at, updated_at, seconds)
select distinct 
       ei.position, application_id = ap.id, ei.item_id, created_at = @DATAEXECUCAO, updated_at = @DATAEXECUCAO, seconds = 0 
  from 
       application_application ap join exam_exam     e  on (ap.exam_id = e.id)
                                  join exam_examitem ei on (ei.exam_id = e.id)
	                              join auth_user     au on (au.id = ap.user_id)
                             left join application_answer xxx on (ap.id = xxx.application_id and 
                                                                  ei.item_id = xxx.item_id)
 where xxx.id is null and 
       ap.created_at = @DATAEXECUCAO
    order by ap.id, ei.[position]


-- commit 
-- rollback


