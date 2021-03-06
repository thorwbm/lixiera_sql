/****** Object:  StoredProcedure [dbo].[sp_consiste_lote_n59]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_consiste_lote_n59]
GO
/****** Object:  StoredProcedure [dbo].[sp_consiste_lote_n59]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_consiste_lote_n59] @lote_id int as
begin

    declare @inconsistencias int
    set @inconsistencias = 0

    print '------------------------------------------------------------------'
    print 'Consistência do lote ' + convert(varchar(50), @lote_id)
    print '------------------------------------------------------------------'

    --------------------------------------------------------------------------------------------------------------------------------------------
    -- VALIDAÇÕES
    --------------------------------------------------------------------------------------------------------------------------------------------
    --Verifica se existe redação com situação diferente de Texto em Branco e Texto Insuficiente que não possua Avaliador
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_001'
    select n59.co_inscricao
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.co_situacao_redacao_final not in (4, 8)
    and (n59.co_situacao_redacao_av1 is null or n59.co_situacao_redacao_av2 is null)
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existe redação com situação de Texto em Branco e Texto Insuficiente que possua avaliador
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_002'
    select n59.co_inscricao
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.co_situacao_redacao_final in (4, 8)
    and (n59.co_situacao_redacao_av1 is not null or n59.co_situacao_redacao_av2 is not null)
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existe redação sem nota
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_003'
    select n59.co_inscricao
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.nu_nota_final is null
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existe redação sem situação
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_004'
    select n59.redacao_id, n59.co_situacao_redacao_av1, n59.co_situacao_redacao_av2, n59.co_situacao_redacao_final
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.co_situacao_redacao_final is null and n59.co_situacao_redacao_av2 <> n59.co_situacao_redacao_av1
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existe redação sem a primeira correção ou segunda correção com situação diferente de Texto em Branco e Texto Insuficiente
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_005'
    select n59.co_inscricao
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and (n59.nu_cpf_av1 is null or nu_cpf_av2 is null)
       and co_situacao_redacao_final not in (4, 8)
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se a média das notas está correta, para as redacoes que não possuem terceiras redações
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_006'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and nu_cpf_av3 is null
    and nu_nota_final <> ((nu_nota_av1 + nu_nota_av2) / 2)
    and n59.lote_id = @lote_id


    /*

    --select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2
    select 'delete from correcoes_analise where redacao_id = ' + convert(varchar(50), n59.redacao_id), 'insert into correcoes_pendenteanalise (co_barra_redacao, id_correcao, id_projeto, id_tipo_correcao, redacao_id, criado_em) values (''' + corr.co_barra_redacao + ''', ' + convert(varchar(50), corr.id) + ', ' + convert(varchar(50), corr.id_projeto) + ', ' + convert(varchar(50), corr.id_tipo_correcao) + ', ' + convert(varchar(50), corr.redacao_id) + ', dbo.getlocaldate())'
    from inep_n59 n59
        join inep_lote lote on lote.id = n59.lote_id
        join correcoes_correcao corr on corr.redacao_id = n59.redacao_id and corr.id_tipo_correcao = 1
    where lote.status_id in (1,3)
    and nu_cpf_av3 is null
    and nu_nota_final <> ((nu_nota_av1 + nu_nota_av2) / 2)
    */


    --Verifica se a média das notas está correta, para as redacoes que possuem terceiras correções
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_007'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.nu_cpf_av3 is not null and nu_cpf_av4 is null and nu_cpf_auditor is null
    and n59.lote_id = @lote_id
	and (n59.nu_nota_final <> ((nu_nota_av1 + nu_nota_av3) / 2) and n59.nu_nota_final <> ((nu_nota_av2 + nu_nota_av3) / 2))


    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se todas as redações onde a diferença da nota da prova1 e da prova2 é > 100 e não possui terceira
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_008'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id join projeto_projeto proj on proj.id = n59.projeto_id
    where lote.status_id in (1,3)
    and n59.nu_cpf_av3 is null
    and abs(n59.nu_nota_av1 - n59.nu_nota_av2) >= proj.limite_nota_final
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica todas as redações que possuem situações diferentes entre as duas primeiras e não possuem terceira correção, caso a situação não seja PD
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_009'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.nu_cpf_av3 is null
    and n59.co_situacao_redacao_av1 <> n59.co_situacao_redacao_av2
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existem redaçoes com situação = 1 (normal) e nota = 0 
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_010'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.nu_nota_final = 0 and n59.co_situacao_redacao_final = 1
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existem redaçoes com nota e situação nula
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_011'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.nu_nota_final is null or n59.co_situacao_redacao_final is null
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se uma redação foi corrigida pelo mesmo avaliador mais de uma vez
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_012'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.nu_cpf_av1 = n59.nu_cpf_av2 or isnull(n59.nu_cpf_av3, 0) = n59.nu_cpf_av1 or isnull(n59.nu_cpf_av3, 0) = n59.nu_cpf_av2
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se a nota da redação bate com a nota baseada nas marcações
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_013'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id join projeto_projeto proj on proj.id = n59.projeto_id
    where lote.status_id in (1,3)

    and (((n59.nu_nota_comp1_av1 + n59.nu_nota_comp2_av1 + n59.nu_nota_comp3_av1 + n59.nu_nota_comp4_av1 + n59.nu_nota_comp5_av1) <> n59.nu_nota_av1)
        or  ((n59.nu_nota_comp1_av2 + n59.nu_nota_comp2_av2 + n59.nu_nota_comp3_av2 + n59.nu_nota_comp4_av2 + n59.nu_nota_comp5_av2) <> n59.nu_nota_av2)
        or  ((n59.nu_nota_media_comp1 + n59.nu_nota_media_comp2 + n59.nu_nota_media_comp3 + n59.nu_nota_media_comp4 + n59.nu_nota_media_comp5) <> n59.nu_nota_final)
        or (n59.nu_cpf_av3 is not null and ((n59.nu_nota_comp1_av3 + n59.nu_nota_comp2_av3 + n59.nu_nota_comp3_av3 + n59.nu_nota_comp4_av3 + n59.nu_nota_comp5_av3) <> n59.nu_nota_av3))
    )
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica correções que estão anuladas (possuem situação <> 1), mas possuem nota > 0
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_014'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3, n59.co_situacao_redacao_final
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and n59.nu_nota_final > 0 and n59.co_situacao_redacao_final is not null and n59.co_situacao_redacao_final <> 1
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existem correções com data de termino menor que data de início
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_015'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3, n59.co_situacao_redacao_final
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where lote.status_id in (1,3)
    and (n59.dt_fim_av1 < n59.dt_inicio_av1 or n59.dt_fim_av2 < n59.dt_inicio_av2 or (n59.nu_cpf_av3 is not null and n59.dt_fim_av3 < n59.dt_inicio_av3))
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

	-------------------------------------------------------------------------------------------
	---REGRAS DE QUARTA
	-------------------------------------------------------------------------------------------
	--Verifica se a nota das redações que possuem quarta, está igual a nota da quarta correção. Desde que não exista auditoria.
	--RESULTADO ESPERADO: Não trazer registros
	print 'VLD_N59_016'
	select n59.co_inscricao
	  from inep_n59 n59
	       join inep_lote lote on lote.id = n59.lote_id
	 where lote.status_id in (1,3)
	   and n59.nu_cpf_av4 is not null
	   and n59.nu_cpf_auditor is null
	   and n59.nu_nota_final <> n59.nu_nota_av4
	   and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

	--Verifica se as notas finais das competências das redações que possuem quarta batem com as notas das competencias de quarta
	--RESULTADO ESPERADO: 0
	print 'VLD_N59_017'
	select n59.co_inscricao
	  from inep_n59 n59
	       join inep_lote lote on lote.id = n59.lote_id
	 where lote.status_id in (1,3)
	   and n59.nu_cpf_av4 is not null and n59.nu_cpf_auditor is null
	   and (n59.nu_nota_comp1_av4 <> n59.nu_nota_media_comp1 or n59.nu_nota_comp2_av4 <> n59.nu_nota_media_comp2 or n59.nu_nota_comp3_av4 <> n59.nu_nota_media_comp3 or n59.nu_nota_comp4_av4 <> n59.nu_nota_media_comp4 or n59.nu_nota_comp5_av4 <> n59.nu_nota_media_comp5)
	   and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

	--Verifica se existe quarta gerada sem necessidade
	--RESULTADO ESPERADO: Não trazer registros
	print 'VLD_N59_018'
	select co_inscricao
	--select count(*)
	from (
	select n59.co_inscricao,
	case when ((abs(n59.nu_nota_av3 - n59.nu_nota_av2) > 100 or
		  abs(n59.nu_nota_comp1_av3 - n59.nu_nota_comp1_av2) > 80 or 
		  abs(n59.nu_nota_comp2_av3 - n59.nu_nota_comp2_av2) > 80 or 
		  abs(n59.nu_nota_comp3_av3 - n59.nu_nota_comp3_av2) > 80 or 
		  abs(n59.nu_nota_comp4_av3 - n59.nu_nota_comp4_av2) > 80 or 
		  abs(n59.nu_nota_comp5_av3 - n59.nu_nota_comp5_av2) > 80 or
			(n59.co_situacao_redacao_av3 <> n59.co_situacao_redacao_av2))) then 1 else 0 end as disc_av2, 
	 case when (abs(n59.nu_nota_av3 - n59.nu_nota_av1) > 100 or
		  abs(n59.nu_nota_comp1_av3 - n59.nu_nota_comp1_av1) > 80 or 
		  abs(n59.nu_nota_comp2_av3 - n59.nu_nota_comp2_av1) > 80 or 
		  abs(n59.nu_nota_comp3_av3 - n59.nu_nota_comp3_av1) > 80 or 
		  abs(n59.nu_nota_comp4_av3 - n59.nu_nota_comp4_av1) > 80 or 
		  abs(n59.nu_nota_comp5_av3 - n59.nu_nota_comp5_av1) > 80 or
			(n59.co_situacao_redacao_av3 <> n59.co_situacao_redacao_av1)) then 1 else 0 end as disc_av1
	 from inep_n59 n59
	      join inep_lote lote on lote.id = n59.lote_id
	where lote.status_id in (1,3)
	  and n59.nu_cpf_av4 is not null and n59.nu_cpf_auditor is null and n59.nu_cpf_av3 is not null
	  and not (((abs(n59.nu_nota_av3   - n59.nu_nota_av2  ) > 100 or
		  abs(n59.nu_nota_comp1_av3 - n59.nu_nota_comp1_av2) > 80 or 
		  abs(n59.nu_nota_comp2_av3 - n59.nu_nota_comp2_av2) > 80 or 
		  abs(n59.nu_nota_comp3_av3 - n59.nu_nota_comp3_av2) > 80 or 
		  abs(n59.nu_nota_comp4_av3 - n59.nu_nota_comp4_av2) > 80 or 
		  abs(n59.nu_nota_comp5_av3 - n59.nu_nota_comp5_av2) > 80 or
			(n59.co_situacao_redacao_av3 <> n59.co_situacao_redacao_av2)) and 
			abs(n59.nu_nota_av3 - n59.nu_nota_av1  ) > 100 or
		  abs(n59.nu_nota_comp1_av3 - n59.nu_nota_comp1_av1) > 80 or 
		  abs(n59.nu_nota_comp2_av3 - n59.nu_nota_comp2_av1) > 80 or 
		  abs(n59.nu_nota_comp3_av3 - n59.nu_nota_comp3_av1) > 80 or 
		  abs(n59.nu_nota_comp4_av3 - n59.nu_nota_comp4_av1) > 80 or 
		  abs(n59.nu_nota_comp5_av3 - n59.nu_nota_comp5_av1) > 80 or
			(n59.co_situacao_redacao_av3 <> n59.co_situacao_redacao_av1)))
	   and n59.lote_id = @lote_id
	) z where disc_av1 + disc_av2 > 0

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

	--Verifica se existe registro com nota_comp5 > 0 e in_fere_dh = 0
	--RESULTADO ESPERADO: 0
	print 'VLD_N59_019'
	select n59.co_inscricao
	  from inep_n59 n59
	       join inep_lote lote on lote.id = n59.lote_id
	 where lote.status_id in (1,3)
	   and n59.in_fere_dh = 0 and n59.nu_nota_media_comp5 > 0
       and lote.id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

	--Verifica se existe registro com nota_comp5 = 0 e in_fere_dh is null
	--RESULTADO ESPERADO: 0
	print 'VLD_N59_020'
	select n59.co_inscricao
	  from inep_n59 n59
	       join inep_lote lote on lote.id = n59.lote_id
	 where lote.status_id in (1,3)
	   and n59.in_fere_dh is null and n59.nu_nota_media_comp5 = 0
	   and n59.co_situacao_redacao_final not in (4,8)
       and lote.id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT



	print 'VLD_N59_021'
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av1 is not null
	   and nu_nota_av1 is null and lote.status_id = 4
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av2 is not null
	   and nu_nota_av2 is null and lote.status_id = 4
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av3 is not null
	   and nu_nota_av3 is null and lote.status_id = 4
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av4 is not null
	   and nu_nota_av4 is null and lote.status_id = 4
	   and lote.id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    print 'Foram encontradas ' + convert(varchar(50), @inconsistencias) + ' inconsistências '

    if @inconsistencias = 0 begin
        update inep_lote set status_id = 8 where id = @lote_id and status_id <> 4 --Liberado
    end
    else begin
        update inep_lote set status_id = 3 where id = @lote_id and status_id <> 4 --Em análise
    end


	-- *** CONSISTENCIA DOS LOTE EM RELACAO AS CORRECOES 

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	exec sp_validacao_n59_ENEM @data_char, @lote_id


end
GO
