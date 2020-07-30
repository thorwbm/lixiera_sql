select
(
    select count(1) from correcoes_fila3 with (nolock) where consistido = 0
) as fila3_inconsistencias
,
(
    select count(1) from correcoes_fila3 with (nolock) where consistido_auditoria = 0
) as fila3_inconsistencias_auditoria
,
(
    select count(1) from correcoes_fila4 with (nolock) where consistido = 0
) as fila4_inconsistencias
,
(
    select count(1) from correcoes_fila4 with (nolock) where consistido_auditoria = 0
) as fila4_inconsistencias_auditoria
,
(
    select count(1) from correcoes_filaauditoria with (nolock) where consistido = 0
) as fila7_inconsistencias
,
(
    select count(1) from correcoes_filaauditoria with (nolock) where consistido_auditoria = 0
) as fila7_inconsistencias_auditoria
,
(
    select count(1) from correcoes_redacao with (nolock) where id_status = 3
) as redacoes_inconsistentes
,
(
    select count(1) from correcoes_pendenteanalise with (nolock) where dbo.getlocaldate() <= dateadd(minute, -2, criado_em)
) as analises_pendentes
,
(

   select count(1)
      from correcoes_analise ana with (nolock)
           join correcoes_conclusao_analise conc on conc.id = ana.conclusao_analise
     where ana.id_tipo_correcao_B = 2
       and conc.discrepou = 1
       and not exists (select top 1 1 from correcoes_fila3 fila with (nolock) where fila.redacao_id = ana.redacao_id)
       and not exists (select top 1 1 from correcoes_correcao corr with (nolock) where corr.id_tipo_correcao = 3 and corr.redacao_id = ana.redacao_id)	   
       and not exists (select top 1 1 from correcoes_filaauditoria filaaud with (nolock) where filaaud.redacao_id = ana.redacao_id)
       and not exists (select top 1 1 from correcoes_correcao corr with (nolock) where corr.id_tipo_correcao = 7 and corr.redacao_id = ana.redacao_id)

) as terceiras_nao_geradas
,
(
    select count(1)
       from correcoes_analise ana with (nolock) JOIN correcoes_analise ana2 with (nolock) ON (ANA.REDACAO_ID = ANA2.REDACAO_ID AND 
	                                                                                         ana.id_tipo_correcao_A = 1 AND 
																							 ana2.id_tipo_correcao_A = 2 )
     where ana.id_tipo_correcao_B = 3 AND 
	       ANA.CONCLUSAO_ANALISE > 2 AND  ANA2.CONCLUSAO_ANALISE > 2       

       and not exists (select top 1 1 from correcoes_fila4 fila with (nolock) where fila.redacao_id = ana.redacao_id)
       and not exists (select top 1 1 from correcoes_correcao corr with (nolock) where corr.id_tipo_correcao = 4 and corr.redacao_id = ana.redacao_id)
	   
       and not exists (select top 1 1 from correcoes_filaAUDITORIA filaAUD with (nolock) where filaAUD.redacao_id = ana.redacao_id)
       and not exists (select top 1 1 from correcoes_correcao corr with (nolock) where corr.id_tipo_correcao = 7 and corr.redacao_id = ana.redacao_id)
) as quartas_nao_geradas
,
(
    select count(1)
      from correcoes_analise ana with (nolock)
     where ana.id_tipo_correcao_B = 3
       and ana.data_inicio_A is null
) as analise3_inconsistente_falta_dados_A
,
(
    select count(1)
      from correcoes_analise ana with (nolock)
     where ana.id_tipo_correcao_B = 3
       and ana.data_inicio_B is null
) as analise3_inconsistente_falta_dados_B
,
(
    select count(1)
      from correcoes_analise ana with (nolock)
           join correcoes_filapessoal fila with (nolock) on fila.redacao_id = ana.redacao_id and fila.id_tipo_correcao in (1, 2)
     where ana.id_tipo_correcao_B = 2
) as correcoes12_retornaram_para_correcao
,
(
    select count(1)
      from correcoes_analise ana with (nolock)
           join correcoes_filapessoal fila with (nolock) on fila.redacao_id = ana.redacao_id and fila.id_tipo_correcao in (3)
     where ana.id_tipo_correcao_B = 3
) as correcoes3_retornaram_para_correcao
,
(
    select count(1)
      from correcoes_correcao cor with (nolock)
           join projeto_projeto_usuarios proju with (nolock) on proju.user_id = cor.id_corretor and cor.id_projeto <> proju.projeto_id
) as correcoes_com_corretor_de_outro_projeto
,
(
    select count(1) from correcoes_fila1 fila1 with (nolock) join correcoes_redacao red with (nolock) on red.id = fila1.redacao_id and red.id_redacaoouro is not null
) as redacoes_ouro_na_fila1
,
(
    select count(1) from correcoes_fila3 with (nolock) where dbo.getlocaldate() <= dateadd(minute, -2, criado_em) and consistido is null
) as fila3_sem_calculo_de_consistencia
,
(
    select count(1) from correcoes_fila3 with (nolock) where dbo.getlocaldate() <= dateadd(minute, -2, criado_em) and consistido_auditoria is null
) as fila3_sem_calculo_de_consistencia_auditoria
,
(
    select count(1) from correcoes_fila4 with (nolock) where dbo.getlocaldate() <= dateadd(minute, -2, criado_em) and consistido is null
) as fila4_sem_calculo_de_consistencia
,
(
    select count(1) from correcoes_fila4 with (nolock) where dbo.getlocaldate() <= dateadd(minute, -2, criado_em) and consistido_auditoria is null
) as fila4_sem_calculo_de_consistencia_auditoria
,
(
    select count(1) from correcoes_filaauditoria with (nolock) where dbo.getlocaldate() <= dateadd(minute, -2, criado_em) and consistido is null
) as fila7_sem_calculo_de_consistencia
,
(
    select count(1) from correcoes_filaauditoria with (nolock) where dbo.getlocaldate() <= dateadd(minute, -2, criado_em) and consistido_auditoria is null
) as fila7_sem_calculo_de_consistencia_auditoria
,
(
	select count(1)
	  from correcoes_corretor cor
	       join auth_user_groups ug on ug.user_id = cor.id
		   join auth_user us on us.id = cor.id
	 where cor.status_id = 1
	   and (cor.nota_corretor is null or (cor.nota_corretor is not null and cor.nota_corretor < 7))
	   and not exists(select top 1 1 from projeto_projeto_usuarios pu where pu.user_id = cor.id and pu.projeto_id in (5,6))
	    and ug.group_id in (34,26)
) as corretores_nao_habilitados_ativos_para_correcao
,
(
	select count(1) from django_cron_cronjoblog where is_success = 0 and id not in (select id from django_cron_cronjoblog_errors where resolvido = 1)
) as jobs_com_erro
,
(
	select count(*) from correcoes_pendenteanalise where erro is not null
) as pendencias_analise_com_erro