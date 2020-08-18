declare @escola_id varchar(50)
declare @inicio datetime  
declare @fim   datetime

set @escola_id = 'a91e8f52aa8c1afdfc1ce949dbf93274'
set @inicio = '2020-04-22'
set @fim = '2020-04-25'


 select distinct * 
   from  [dbo].[vw_application_answer_user]
where application_id in
(SELECT distinct [application_id]
  FROM [dbo].[vw_aluno_escola_grade_application]
    where escola_id = @escola_id    
 and started_at >= @inicio
 and started_at < @fim
 and started_at is not null
      and alternative_id is not null)

select name, id,* from auth_user where id in (
select user_id from  [dbo].[vw_application_answer_user] where application_id in
(SELECT distinct [application_id] FROM [dbo].[vw_aluno_escola_grade_application]
    where escola_id = @escola_id    
 and started_at >= @inicio
 and started_at < @fim
 and started_at is not null
      ))
order by 1

--drop table bkp_pergunta
--drop table bkp_aplicacao

  -- begin tran update application_answer set free_response = null, alternative_id = null, seconds = 0
  select * --into bkp_pergunta  
  from application_answer
where application_id in
(SELECT distinct [application_id] FROM [dbo].[vw_aluno_escola_grade_application]
    where escola_id =  @escola_id    
 and started_at >= @inicio
 and started_at < @fim
 and started_at is not null
      )



 -- begin tran update application_application set started_at = null, finished_at = null, should_update_answers = 0, timeout = null, forced_status = null  
  select * --into bkp_aplicacao 
  from application_application
where id in
 (
SELECT distinct [application_id]
  FROM [dbo].[vw_aluno_escola_application]
      where escola_id = @escola_id    
 and started_at >= @inicio
 and started_at < @fim)