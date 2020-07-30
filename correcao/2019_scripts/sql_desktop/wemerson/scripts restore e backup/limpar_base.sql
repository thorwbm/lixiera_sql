-- *** DESATIVAR OS JOBS

EXEC msdb.dbo.sp_update_job @job_name=  'JOB - CORRECAO_REDACAO_REGULAR - CARGA RELATORIOS' ,@enabled = 0

EXEC msdb.dbo.sp_update_job @job_name=  'JOB - CORRECAO_REDACAO_REGULAR - EXECUTA SINCRONISMO' ,@enabled = 0

EXEC msdb.dbo.sp_update_job @job_name=  'JOB - CORRECAO_REDACAO_REGULAR - CONSOME PENDENCIA ANALISE' ,@enabled = 0




-- limpa principal

use [correcao_redacao_regular_homolog] go

exec sp_msforeachtable 'ALTER TABLE ? DISABLE TRIGGER all'

begin tran


update correcoes_redacao set nota_final = null, id_redacao_situacao = 1 where nota_final is not null
delete from correcoes_filapessoal
delete from correcoes_fila1
delete from correcoes_fila2
delete from correcoes_fila3
delete from correcoes_analise
delete from ocorrencias_ocorrencia
delete from correcoes_correcao

insert into correcoes_fila1
select null, null, 1, id_projeto, co_barra_redacao from correcoes_redacao

truncate table correcoes_analise_log
truncate table correcoes_correcao_log
truncate table correcoes_corretor_log
truncate table correcoes_fila1_log
truncate table correcoes_fila2_log
truncate table correcoes_fila3_log
truncate table correcoes_fila4_log
truncate table correcoes_filaauditoria_log
truncate table correcoes_filamoda_log
truncate table correcoes_filaordem_log
truncate table correcoes_filaouro_log
truncate table correcoes_filapessoal_log
truncate table correcoes_redacao_log
truncate table ocorrencias_ocorrencia_log
truncate table usuarios_hierarquia_log
truncate table usuarios_hierarquia_usuarios_log
truncate table usuarios_pessoa_log


-- COMMIT
-- ROLLBACK

exec sp_msforeachtable 'ALTER TABLE ? enable TRIGGER all'



-- limpar replica
use [correcao_redacao_regular_replica_homolog] 

BEGIN TRAN

update correcoes_redacao set nota_final = null, id_redacao_situacao = 1 where nota_final is not null

delete from correcoes_analise
delete from correcoes_correcao
update  correcoes_corretor set status_id = 1

delete from correcoes_fila1
insert into correcoes_fila1 select *, getdate() from sn_correcoes_fila1

delete from correcoes_fila2
delete from correcoes_fila3
delete from correcoes_fila4
delete from correcoes_filaauditoria
delete from correcoes_filamoda
delete from correcoes_filaordem
delete from correcoes_filaouro
delete from correcoes_filapessoal
delete from ocorrencias_ocorrencia
delete from relatorios_acompanhamentogeral
delete from relatorios_distribuicaonotas
delete from relatorios_distribuicaonotashierarquia
delete from relatorios_distribuicaonotassituacao
delete from relatorios_distribuicaonotassituacaohierarquia
delete from relatorios_responsabilidadeavaliador

--  COMMIT
-- ROLLBACK

--  ** ATIVAR OS JOBS

EXEC msdb.dbo.sp_update_job @job_name=  'JOB - CORRECAO_REDACAO_REGULAR - CARGA RELATORIOS' ,@enabled = 1

EXEC msdb.dbo.sp_update_job @job_name=  'JOB - CORRECAO_REDACAO_REGULAR - EXECUTA SINCRONISMO' ,@enabled = 1

EXEC msdb.dbo.sp_update_job @job_name=  'JOB - CORRECAO_REDACAO_REGULAR - CONSOME PENDENCIA ANALISE' ,@enabled = 1