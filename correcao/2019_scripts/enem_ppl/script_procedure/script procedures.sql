/****** Object:  StoredProcedure [dbo].[sp_compara_lote_n59]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_compara_lote_n59] @lote_1_id int, @lote_2_id int as
begin
	declare @descricao_comparacao nvarchar(4000)

	declare @comparacao_id int

	declare @resultado nvarchar(4000)
	declare @id_1 int
	declare @id_2 int
	declare @nu_nota_final_1 numeric(10,2)
	declare @nu_nota_final_2 numeric(10,2)
	declare @co_situacao_redacao_final_1 int
	declare @co_situacao_redacao_final_2 int
	declare @nu_cpf_av1_1 char(11)
	declare @nu_cpf_av1_2 char(11)
	declare @nu_cpf_av2_1 char(11)
	declare @nu_cpf_av2_2 char(11)
	declare @nu_cpf_av3_1 char(11)
	declare @nu_cpf_av3_2 char(11)
	declare @nu_cpf_av4_1 char(11)
	declare @nu_cpf_av4_2 char(11)
	declare @nu_cpf_auditor_1 char(11)
	declare @nu_cpf_auditor_2 char(11)
	declare @in_fere_dh_1 int
	declare @in_fere_dh_2 int
	declare @nu_nota_media_comp1_1 numeric(7, 2)
	declare @nu_nota_media_comp2_1 numeric(7, 2)
	declare @nu_nota_media_comp3_1 numeric(7, 2)
	declare @nu_nota_media_comp4_1 numeric(7, 2)
	declare @nu_nota_media_comp5_1 numeric(7, 2)
	declare @nu_nota_media_comp1_2 numeric(7, 2)
	declare @nu_nota_media_comp2_2 numeric(7, 2)
	declare @nu_nota_media_comp3_2 numeric(7, 2)
	declare @nu_nota_media_comp4_2 numeric(7, 2)
	declare @nu_nota_media_comp5_2 numeric(7, 2)
	declare @redacao_id_1 int
	declare @redacao_id_2 int

	insert into comparacao_n59 (descricao, criado_em, lote_1_id, lote_2_id) values (@descricao_comparacao, dbo.getlocaldate(), @lote_1_id, @lote_2_id)
	set @comparacao_id = @@IDENTITY

	declare db_cursor cursor for
	select n59_1.id, n59_2.id, n59_1.redacao_id, n59_2.redacao_id, n59_1.co_situacao_redacao_final, n59_2.co_situacao_redacao_final, n59_1.nu_nota_final, n59_2.nu_nota_final,
	       n59_1.nu_cpf_av1, n59_2.nu_cpf_av1,
	       n59_1.nu_cpf_av2, n59_2.nu_cpf_av2,
	       n59_1.nu_cpf_av3, n59_2.nu_cpf_av3,
	       n59_1.nu_cpf_av4, n59_2.nu_cpf_av4,
	       n59_1.nu_cpf_auditor, n59_2.nu_cpf_auditor,
		   n59_1.nu_nota_media_comp1, n59_2.nu_nota_media_comp1,
		   n59_1.nu_nota_media_comp2, n59_2.nu_nota_media_comp2,
		   n59_1.nu_nota_media_comp3, n59_2.nu_nota_media_comp3,
		   n59_1.nu_nota_media_comp4, n59_2.nu_nota_media_comp4,
		   n59_1.nu_nota_media_comp5, n59_2.nu_nota_media_comp5,
		   n59_1.in_fere_dh, n59_2.in_fere_dh
	  from inep_n59 n59_1
		   left outer join inep_n59 n59_2 on n59_1.co_inscricao = n59_2.co_inscricao
	 where n59_1.lote_id = @lote_1_id
	   and n59_2.lote_id = @lote_2_id

	open db_cursor
	fetch next from db_cursor
	           into @id_1, @id_2, @redacao_id_1, @redacao_id_2, @co_situacao_redacao_final_1, @co_situacao_redacao_final_2, @nu_nota_final_1, @nu_nota_final_2,
	                @nu_cpf_av1_1,@nu_cpf_av1_2,
	                @nu_cpf_av2_1,@nu_cpf_av2_2,
	                @nu_cpf_av3_1,@nu_cpf_av3_2,
	                @nu_cpf_av4_1,@nu_cpf_av4_2,
	                @nu_cpf_auditor_1,@nu_cpf_auditor_2,
		            @nu_nota_media_comp1_1,@nu_nota_media_comp1_2,
		            @nu_nota_media_comp2_1,@nu_nota_media_comp2_2,
		            @nu_nota_media_comp3_1,@nu_nota_media_comp3_2,
		            @nu_nota_media_comp4_1,@nu_nota_media_comp4_2,
		            @nu_nota_media_comp5_1,@nu_nota_media_comp5_2,
					@in_fere_dh_1,@in_fere_dh_2

	while @@fetch_status = 0
	begin
    
		set @resultado = '{}'

		if @redacao_id_1 <> @redacao_id_2 begin
			set @resultado = json_modify(@resultado, '$.redacao_id', json_modify(json_modify('{}', '$.lote_1', @redacao_id_1), '$.lote_2', @redacao_id_2))
		end

		if @nu_nota_final_1 <> @nu_nota_final_2 begin
			set @resultado = json_modify(@resultado, '$.nu_nota_final', json_modify(json_modify('{}', '$.lote_1', @nu_nota_final_1), '$.lote_2', @nu_nota_final_2))
		end

		if @nu_cpf_av1_1 <> @nu_cpf_av1_2 begin
			set @resultado = json_modify(@resultado, '$.nu_cpf_av1', json_modify(json_modify('{}', '$.lote_1', @nu_cpf_av1_1), '$.lote_2', @nu_cpf_av1_2))
		end

		if @nu_cpf_av2_1 <> @nu_cpf_av2_2 begin
			set @resultado = json_modify(@resultado, '$.nu_cpf_av2', json_modify(json_modify('{}', '$.lote_1', @nu_cpf_av2_1), '$.lote_2', @nu_cpf_av2_2))
		end

		if @nu_cpf_av3_1 <> @nu_cpf_av3_2 begin
			set @resultado = json_modify(@resultado, '$.nu_cpf_av3', json_modify(json_modify('{}', '$.lote_1', @nu_cpf_av3_1), '$.lote_2', @nu_cpf_av3_2))
		end

		if @nu_cpf_av4_1 <> @nu_cpf_av4_2 begin
			set @resultado = json_modify(@resultado, '$.nu_cpf_av4', json_modify(json_modify('{}', '$.lote_1', @nu_cpf_av4_1), '$.lote_2', @nu_cpf_av4_2))
		end

		if @nu_nota_media_comp1_1 <> @nu_nota_media_comp1_2 begin
			set @resultado = json_modify(@resultado, '$.nu_nota_media_comp1', json_modify(json_modify('{}', '$.lote_1', @nu_nota_media_comp1_1), '$.lote_2', @nu_nota_media_comp1_2))
		end

		if @nu_nota_media_comp2_1 <> @nu_nota_media_comp2_2 begin
			set @resultado = json_modify(@resultado, '$.nu_nota_media_comp2', json_modify(json_modify('{}', '$.lote_1', @nu_nota_media_comp2_1), '$.lote_2', @nu_nota_media_comp2_2))
		end

		if @nu_nota_media_comp3_1 <> @nu_nota_media_comp3_2 begin
			set @resultado = json_modify(@resultado, '$.nu_nota_media_comp3', json_modify(json_modify('{}', '$.lote_1', @nu_nota_media_comp3_1), '$.lote_2', @nu_nota_media_comp3_2))
		end

		if @nu_nota_media_comp4_1 <> @nu_nota_media_comp4_2 begin
			set @resultado = json_modify(@resultado, '$.nu_nota_media_comp4', json_modify(json_modify('{}', '$.lote_1', @nu_nota_media_comp4_1), '$.lote_2', @nu_nota_media_comp4_2))
		end

		if @nu_nota_media_comp5_1 <> @nu_nota_media_comp5_2 begin
			set @resultado = json_modify(@resultado, '$.nu_nota_media_comp5', json_modify(json_modify('{}', '$.lote_1', @nu_nota_media_comp5_1), '$.lote_2', @nu_nota_media_comp5_2))
		end
		

		if @nu_cpf_auditor_1 <> @nu_cpf_auditor_2 begin
			set @resultado = json_modify(@resultado, '$.nu_cpf_auditor', json_modify(json_modify('{}', '$.lote_1', @nu_cpf_auditor_1), '$.lote_2', @nu_cpf_auditor_2))
		end

		if @co_situacao_redacao_final_1 <> @co_situacao_redacao_final_2 begin
			set @resultado = json_modify(@resultado, '$.co_situacao_redacao_final', json_modify(json_modify('{}', '$.lote_1', @co_situacao_redacao_final_1), '$.lote_2', @co_situacao_redacao_final_2))
		end

		if @in_fere_dh_1 <> @in_fere_dh_2 begin
			set @resultado = json_modify(@resultado, '$.in_fere_dh', json_modify(json_modify('{}', '$.lote_1', @in_fere_dh_1), '$.lote_2', @in_fere_dh_2))
		end

		if @resultado <> '{}' begin
			insert into comparacao_n59_redacao (comparacao_id, id_1, id_2, status_id, resultado)
			values(@comparacao_id, @id_1, @id_2, 1, @resultado)
		end
    
		fetch next from db_cursor
		           into @id_1, @id_2, @redacao_id_1, @redacao_id_2, @co_situacao_redacao_final_1, @co_situacao_redacao_final_2, @nu_nota_final_1, @nu_nota_final_2,
	                    @nu_cpf_av1_1,@nu_cpf_av1_2,
	                    @nu_cpf_av2_1,@nu_cpf_av2_2,
	                    @nu_cpf_av3_1,@nu_cpf_av3_2,
	                    @nu_cpf_av4_1,@nu_cpf_av4_2,
	                    @nu_cpf_auditor_1,@nu_cpf_auditor_2,
		                @nu_nota_media_comp1_1,@nu_nota_media_comp1_2,
		                @nu_nota_media_comp2_1,@nu_nota_media_comp2_2,
		                @nu_nota_media_comp3_1,@nu_nota_media_comp3_2,
		                @nu_nota_media_comp4_1,@nu_nota_media_comp4_2,
		                @nu_nota_media_comp5_1,@nu_nota_media_comp5_2,
				        @in_fere_dh_1,@in_fere_dh_2
	end

	close db_cursor
	deallocate db_cursor

end
GO
/****** Object:  StoredProcedure [dbo].[sp_consiste_lote_n59]    Script Date: 06/01/2020 10:31:37 ******/
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
	   and n59.co_situacao_redacao_final = 1
       and lote.id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT



	print 'VLD_N59_021'
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av1 is not null
	   and nu_nota_av1 is null
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av2 is not null
	   and nu_nota_av2 is null
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av3 is not null
	   and nu_nota_av3 is null
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av4 is not null
	   and nu_nota_av4 is null
	   and lote.id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT


	print 'VLD_N59_022'
	select n59.co_inscricao
	  from inep_n59 n59
	 where n59.nu_nota_final is not null
	       and n59.lote_id = @lote_id
	       and (n59.nu_nota_media_comp1 is null or n59.nu_nota_media_comp2 is null or n59.nu_nota_media_comp3 is null or n59.nu_nota_media_comp4 is null or n59.nu_nota_media_comp5 is null)

	set @inconsistencias = @inconsistencias + @@ROWCOUNT


	--VERIFICA SE EXISTE REDACAO COM SG_UF_PROVA =  'XX'
	print 'VLD_N59_023'
	select n59.co_inscricao
	  from inep_n59 n59
	 where n59.sg_uf_prova = 'XX'

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
/****** Object:  StoredProcedure [dbo].[sp_consiste_lote_n59_avulso]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_consiste_lote_n59_avulso] @lote_id int as
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
    where n59.co_situacao_redacao_final not in (4, 8)
    and (n59.co_situacao_redacao_av1 is null or n59.co_situacao_redacao_av2 is null)
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existe redação com situação de Texto em Branco e Texto Insuficiente que possua avaliador
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_002'
    select n59.co_inscricao
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where n59.co_situacao_redacao_final in (4, 8)
    and (n59.co_situacao_redacao_av1 is not null or n59.co_situacao_redacao_av2 is not null)
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existe redação sem nota
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_003'
    select n59.co_inscricao
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where n59.nu_nota_final is null
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existe redação sem situação
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_004'
    select n59.redacao_id, n59.co_situacao_redacao_av1, n59.co_situacao_redacao_av2, n59.co_situacao_redacao_final
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where n59.co_situacao_redacao_final is null and n59.co_situacao_redacao_av2 <> n59.co_situacao_redacao_av1
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existe redação sem a primeira correção ou segunda correção com situação diferente de Texto em Branco e Texto Insuficiente
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_005'
    select n59.co_inscricao
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where (n59.nu_cpf_av1 is null or nu_cpf_av2 is null)
       and co_situacao_redacao_final not in (4, 8)
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se a média das notas está correta, para as redacoes que não possuem terceiras redações
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_006'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where nu_cpf_av3 is null
    and nu_nota_final <> ((nu_nota_av1 + nu_nota_av2) / 2)
    and n59.lote_id = @lote_id


    --Verifica se a média das notas está correta, para as redacoes que possuem terceiras correções
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_007'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where n59.nu_cpf_av3 is not null and nu_cpf_av4 is null and nu_cpf_auditor is null
    and n59.lote_id = @lote_id
	and (n59.nu_nota_final <> ((nu_nota_av1 + nu_nota_av3) / 2) and n59.nu_nota_final <> ((nu_nota_av2 + nu_nota_av3) / 2))


    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se todas as redações onde a diferença da nota da prova1 e da prova2 é > 100 e não possui terceira
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_008'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id join projeto_projeto proj on proj.id = n59.projeto_id
    where n59.nu_cpf_av3 is null
    and abs(n59.nu_nota_av1 - n59.nu_nota_av2) >= proj.limite_nota_final
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica todas as redações que possuem situações diferentes entre as duas primeiras e não possuem terceira correção, caso a situação não seja PD
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_009'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where n59.nu_cpf_av3 is null
    and n59.co_situacao_redacao_av1 <> n59.co_situacao_redacao_av2
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existem redaçoes com situação = 1 (normal) e nota = 0 
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_010'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where n59.nu_nota_final = 0 and n59.co_situacao_redacao_final = 1
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existem redaçoes com nota e situação nula
    --RESULTADO ESPERADO: Não trazer registros
    print 'VLD_N59_011'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where n59.nu_nota_final is null or n59.co_situacao_redacao_final is null
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se uma redação foi corrigida pelo mesmo avaliador mais de uma vez
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_012'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where n59.nu_cpf_av1 = n59.nu_cpf_av2 or isnull(n59.nu_cpf_av3, 0) = n59.nu_cpf_av1 or isnull(n59.nu_cpf_av3, 0) = n59.nu_cpf_av2
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se a nota da redação bate com a nota baseada nas marcações
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_013'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id join projeto_projeto proj on proj.id = n59.projeto_id
    where (((n59.nu_nota_comp1_av1 + n59.nu_nota_comp2_av1 + n59.nu_nota_comp3_av1 + n59.nu_nota_comp4_av1 + n59.nu_nota_comp5_av1) <> n59.nu_nota_av1)
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
    where n59.nu_nota_final > 0 and n59.co_situacao_redacao_final is not null and n59.co_situacao_redacao_final <> 1
    and n59.lote_id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

    --Verifica se existem correções com data de termino menor que data de início
    --RESULTADO ESPERADO: 0
    print 'VLD_N59_015'
    select n59.redacao_id, n59.co_inscricao, n59.nu_nota_final, n59.nu_nota_av1, n59.nu_nota_av2, n59.nu_nota_av3, n59.co_situacao_redacao_final
    from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
    where (n59.dt_fim_av1 < n59.dt_inicio_av1 or n59.dt_fim_av2 < n59.dt_inicio_av2 or (n59.nu_cpf_av3 is not null and n59.dt_fim_av3 < n59.dt_inicio_av3))
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
	 where n59.nu_cpf_av4 is not null
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
	 where n59.nu_cpf_av4 is not null and n59.nu_cpf_auditor is null
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
	where n59.nu_cpf_av4 is not null and n59.nu_cpf_auditor is null and n59.nu_cpf_av3 is not null
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
	 where n59.in_fere_dh = 0 and n59.nu_nota_media_comp5 > 0
       and lote.id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT

	--Verifica se existe registro com nota_comp5 = 0 e in_fere_dh is null
	--RESULTADO ESPERADO: 0
	print 'VLD_N59_020'
	select n59.co_inscricao
	  from inep_n59 n59
	       join inep_lote lote on lote.id = n59.lote_id
	 where n59.in_fere_dh is null and n59.nu_nota_media_comp5 = 0
	   and n59.co_situacao_redacao_final = 1
       and lote.id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT


	print 'VLD_N59_021'
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av1 is not null
	   and nu_nota_av1 is null
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av2 is not null
	   and nu_nota_av2 is null
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av3 is not null
	   and nu_nota_av3 is null
	   and lote.id = @lote_id
	union
	select n59.co_inscricao
	  from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id
	 where n59.nu_cpf_av4 is not null
	   and nu_nota_av4 is null
	   and lote.id = @lote_id

    set @inconsistencias = @inconsistencias + @@ROWCOUNT


	print 'VLD_N59_022'
	select n59.co_inscricao
	  from inep_n59 n59
	 where n59.nu_nota_final is not null
	       and n59.lote_id = @lote_id
	       and (n59.nu_nota_media_comp1 is null or n59.nu_nota_media_comp2 is null or n59.nu_nota_media_comp3 is null or n59.nu_nota_media_comp4 is null or n59.nu_nota_media_comp5 is null)

	set @inconsistencias = @inconsistencias + @@ROWCOUNT

    print 'Foram encontradas ' + convert(varchar(50), @inconsistencias) + ' inconsistências '


end


GO
/****** Object:  StoredProcedure [dbo].[sp_copia_dados]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_copia_dados] as
begin

	declare @tabela varchar(255)
	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	declare @tabela_completa varchar(255)

	----------------------------------------------------------------------------------------
	--CORRECOES_CORRECAO
	set @tabela = 'correcoes_correcao'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, 'id, data_inicio, data_termino, link_imagem_recortada, nota_final, competencia1, competencia2, competencia3, competencia4, competencia5, nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5, tempo_em_correcao, id_correcao_situacao, id_corretor, id_projeto, co_barra_redacao, id_status, tipo_auditoria_id, id_tipo_correcao, redacao_id'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__redacao_id on ' + @tabela_completa + ' (redacao_id)')
	exec ('create index ix__' + @tabela + '_' + @data_char + '__id_corretor on ' + @tabela_completa + ' (id_corretor)')
	exec ('create index ix__' + @tabela + '_' + @data_char + '__id_correcao_situacao on ' + @tabela_completa + ' (id_correcao_situacao)')
	exec ('create index ix__' + @tabela + '_' + @data_char + '__redacao_id__id_projeto__id_tipo_correcao on ' + @tabela_completa + ' (redacao_id, id_projeto, id_tipo_correcao)')
	----------------------------------------------------------------------------------------



	----------------------------------------------------------------------------------------
	--CORRECOES_REDACAO
	set @tabela = 'correcoes_redacao'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__co_inscricao on ' + @tabela_completa + ' (co_inscricao)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__co_barra_redacao on ' + @tabela_completa + ' (co_barra_redacao)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__nota_final on ' + @tabela_completa + ' (nota_final)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__cancelado__nota_final on ' + @tabela_completa + ' (cancelado, nota_final)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__cancelado__id_status on ' + @tabela_completa + ' (cancelado, id_status)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__cancelado__id_status__id_redacaoouro on ' + @tabela_completa + ' (cancelado, id_status, id_redacaoouro)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__id_redacaoouro on ' + @tabela_completa + ' (id_redacaoouro)' )
	----------------------------------------------------------------------------------------


	----------------------------------------------------------------------------------------
	--CORRECOES_ANALISE
	set @tabela = 'correcoes_analise'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__redacao_id on ' + @tabela_completa + ' (redacao_id)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__redacao_id__id_tipo_correcao_b__aproveitamento on ' + @tabela_completa + ' (redacao_id, id_tipo_correcao_b, aproveitamento)' )
	----------------------------------------------------------------------------------------


	----------------------------------------------------------------------------------------
	--USUARIOS_PESSOA
	set @tabela = 'usuarios_pessoa'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__usuario_id on ' + @tabela_completa + ' (usuario_id)' )
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--PROJETO_PROJETO
	set @tabela = 'projeto_projeto'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------
	--PROJETO_PROJETO_USUARIOS
	set @tabela = 'projeto_projeto_usuarios'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------
	
	----------------------------------------------------------------------------------------
	--AUTH_USER_GROUPS
	set @tabela = 'auth_user_groups'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--AUTH_GROUP
	set @tabela = 'auth_group'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--CORRECOES_CORRETOR
	set @tabela = 'correcoes_corretor'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--correcoes_corretor_indicadores
	set @tabela = 'correcoes_corretor_indicadores'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, 'id,  dsp, data_calculo, tempo_correcao,   projeto_id, usuario_id'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__id on ' + @tabela_completa + ' (id)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__usuario_id on ' + @tabela_completa + ' (usuario_id)')
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--status_corretor_trocastatus
	--select top 1 * from 
	set @tabela = 'status_corretor_trocastatus'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '___id on ' + @tabela_completa + ' (id)' )
	exec ('create index ix__' + @tabela + '_' + @data_char + '__corretor_id on ' + @tabela_completa + ' (corretor_id)')
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--CORRECOES_SUSPENSAO
	set @tabela = 'CORRECOES_SUSPENSAO'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'

	exec ('create index ix__' + @tabela + '_' + @data_char + '__corretor_id on ' + @tabela_completa + ' (id_corretor)')
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--CORRECOES_REDACAOOURO
	set @tabela = 'correcoes_redacaoouro'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'
	
	exec ('create index ix__' + @tabela + '_' + @data_char + '___id on ' + @tabela_completa + ' (id)')
	exec ('create index ix__' + @tabela + '_' + @data_char + '___redacao_id on ' + @tabela_completa + ' (redacao_id)')
	----------------------------------------------------------------------------------------

	----------------------------------------------------------------------------------------
	--LOG_CORRECOES_CORRETOR
	set @tabela = 'log_correcoes_corretor'
	set @tabela_completa = '[' + @data_char + '].' + @tabela
	exec sp_copia_tabela @tabela, '*'
	
	exec ('create index ix__' + @tabela + '_' + @data_char + '___id on ' + @tabela_completa + ' (id)')
	----------------------------------------------------------------------------------------


end


GO
/****** Object:  StoredProcedure [dbo].[sp_copia_tabela]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------------------------------------
--PROCEDURES
--------------------------------------------------------------------------------------------------------------------
create   procedure [dbo].[sp_copia_tabela] @tabela varchar(255), @campos nvarchar(max) as
begin
	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	declare @tabela_completa varchar(255) = '[' + @data_char + '].' + @tabela

	if not exists(select top 1 1 from information_schema.schemata where schema_name = @data_char) begin
		exec('create schema [' + @data_char + ']')
	end

	if object_id(@tabela_completa) is not null begin
		exec('drop table ' + @tabela_completa)
	end

	exec('select ' + @campos + ' into ' + @tabela_completa + ' from ' + @tabela)

end
GO
/****** Object:  StoredProcedure [dbo].[sp_criar_lote_bi_batimento]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_criar_lote_bi_batimento] as
	begin

	DECLARE @co_inscricao NVARCHAR(50), @id_situacao int, @lote_id int
	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_bi int = 3
    declare @interface_n59 int = 1
	
    declare @nota_max_competencia_em int
    declare @nota_max_competencia_ef int

    set @nota_max_competencia_em = 200
    set @nota_max_competencia_ef = 250

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_BI_BATIMENTO', 1, dbo.getlocaldate(), @tipo_bi, @interface_n59)
	set @lote_id = @@IDENTITY

	insert into inep_n59 (lote_id, criado_em, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, 
                          nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5,
                          co_tipo_avaliacao, co_situacao_redacao_final,
                          projeto_id,
                          nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final,
                          co_projeto, in_divulgacao, link_imagem_recortada)
     select @lote_id, dbo.getlocaldate(), 'F', n02.co_inscricao, 2, isnull(n90.SG_UF_MUNICIPIO_PROVA, n02.SG_UF_PROVA),
            200,
            200,
            200,
            200,
            200,
            isnull(pcd.banca, 1) as co_tipo_avaliacao,
            case isnull(s.result, 'blank') when 'blank' then 4 else 8 end co_situacao_redacao_final,
            case isnull(pcd.banca, 1) when 1 then 4 when 2 then 5 when 3 then 6 end projeto_id,
            0, 0, 0, 0, 0, 0, n02.co_projeto, 0, s.processed_key
       from subscriptions_subscription_3 s
	        left outer join inep_n02 n02 on s.enrolment_key = n02.co_inscricao
            left outer join banca_pcd pcd on pcd.CO_INSCRICAO = n02.CO_INSCRICAO
            left outer join inep_n90 n90 on n90.CO_INSCRICAO = n02.CO_INSCRICAO
      where (s.result in ('blank', 'insufficient') or (s.removed = 1 and s.result <> 'essay'))

end
GO
/****** Object:  StoredProcedure [dbo].[SP_CRIAR_VIEW_REDACAO_EQUIDISTANTE]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_CRIAR_VIEW_REDACAO_EQUIDISTANTE] @ESQUEMA VARCHAR(100) AS 

DECLARE @SQL NVARCHAR(MAX) 

SET @SQL = N'
create OR ALTER view [' + @ESQUEMA + '].[vw_redacao_equidistante] as 
select cor3.redacao_id, 
       cor3.id_projeto, 
       cor3.nota_final as nota_final3, 
       cor2.nota_final as nota_final2, 
	   cor1.nota_final as nota_final1 
  from [' + @ESQUEMA + '].correcoes_correcao cor3 join [' + @ESQUEMA + '].correcoes_correcao cor2 on (cor3.redacao_id = cor2.redacao_id and 
                                                                cor3.id_projeto = cor2.id_projeto and 
																cor3.id_tipo_correcao = 3 and
																cor2.id_tipo_correcao = 2)
                               join [' + @ESQUEMA + '].correcoes_correcao cor1 on (cor3.redacao_id = cor1.redacao_id and 
							                                    cor3.id_projeto = cor1.id_projeto and
																cor1.id_tipo_correcao = 1)
where abs(cor1.nota_final - cor3.nota_final) = abs(cor2.nota_final - cor3.nota_final) and 
      cor3.id_correcao_situacao = 1 and 
	  cor2.id_correcao_situacao = 1 and 
	  cor1.id_correcao_situacao = 1 AND 
	  
	  ABS(cor3.competencia1 - COR1.competencia1) <= 2 AND 
	  ABS(cor3.competencia2 - COR1.competencia2) <= 2 AND 
	  ABS(cor3.competencia3 - COR1.competencia3) <= 2 AND 
	  ABS(cor3.competencia4 - COR1.competencia4) <= 2 AND 
	  ABS(cor3.competencia5 - COR1.competencia5) <= 2 AND 
	  
	  ABS(cor3.competencia1 - COR2.competencia1) <= 2 AND 
	  ABS(cor3.competencia2 - COR2.competencia2) <= 2 AND 
	  ABS(cor3.competencia3 - COR2.competencia3) <= 2 AND 
	  ABS(cor3.competencia4 - COR2.competencia4) <= 2 AND 
	  ABS(cor3.competencia5 - COR2.competencia5) <= 2  
'

EXEC(@SQL)


GO
/****** Object:  StoredProcedure [dbo].[SP_CRIAR_VIEW_VALIDACAO_AUDITORIA]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- EXEC SP_CRIAR_VIEW_VALIDACAO_AUDITORIA '20191223'
CREATE   PROCEDURE [dbo].[SP_CRIAR_VIEW_VALIDACAO_AUDITORIA] @ESQUEMA VARCHAR(100) AS 

DECLARE @SQL1 NVARCHAR(MAX)
DECLARE @SQL2 NVARCHAR(MAX) 
DECLARE @SQL3 NVARCHAR(MAX) 
DECLARE @SQL4 NVARCHAR(MAX) 

SET @SQL1 = N'
create OR ALTER view [' + @ESQUEMA + '].[vw_validacao_auditoria] as 
WITH CTE_VALIDACAO_AUDITORIA AS (
		SELECT RED.ID AS REDACAO_ID, TPA.descricao AS TIPO_AUDITORIA, RED.id_projeto AS PROJETO_ID, 
			   COR1.ID AS CORRECAO1, 
			   COR2.ID AS CORRECAO2, 
			   COR3.ID AS CORRECAO3, 
			   COR4.ID AS CORRECAO4, 
			   COR5.ID AS CORRECAO5, 
			   COR6.ID AS CORRECAO6, 
			   COR7.ID AS CORRECAO7,
	   
			   CASE WHEN ISNULL(COR1.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_1, 
			   CASE WHEN ISNULL(COR2.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_2, 
			   CASE WHEN ISNULL(COR3.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_3, 
			   CASE WHEN ISNULL(COR4.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_4, 
			   CASE WHEN ISNULL(COR5.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_5, 
			   CASE WHEN ISNULL(COR6.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_6, 
			   CASE WHEN ISNULL(COR7.NOTA_FINAL,0) = 1000 THEN 1 ELSE 0 END  AS NOTA_FINAL_7,
	   
			   CASE WHEN COR1.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_1, 
			   CASE WHEN COR2.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_2, 
			   CASE WHEN COR3.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_3, 
			   CASE WHEN COR4.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_4, 
			   CASE WHEN COR5.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_5, 
			   CASE WHEN COR6.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_6, 
			   CASE WHEN COR7.competencia5 = -1 THEN ' + CHAR(39) + 'DDH' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS DDH_7,
	   
			   CASE WHEN COR1.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_1, 
			   CASE WHEN COR2.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_2, 
			   CASE WHEN COR3.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_3, 
			   CASE WHEN COR4.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_4, 
			   CASE WHEN COR5.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_5, 
			   CASE WHEN COR6.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_6, 
			   CASE WHEN COR7.id_correcao_situacao = 9 THEN ' + CHAR(39) + 'PD' + CHAR(39) + ' ELSE ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' END AS PD_7

		  FROM [' + @ESQUEMA + '].CORRECOES_REDACAO RED JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR7  ON (RED.ID = COR7.REDACAO_ID AND COR7.ID_TIPO_CORRECAO = 7 AND COR7.id_status = 3)
		                                                JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR1  ON (RED.ID = COR1.REDACAO_ID AND COR1.ID_TIPO_CORRECAO = 1 AND COR1.id_status = 3)
												        JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR2  ON (RED.ID = COR2.REDACAO_ID AND COR2.ID_TIPO_CORRECAO = 2 AND COR2.id_status = 3)
													    JOIN                    CORRECOES_TIPOAUDITORIA TPA   ON (TPA.ID = COR7.tipo_auditoria_id)
												   LEFT JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR3  ON (RED.ID = COR3.REDACAO_ID AND COR3.ID_TIPO_CORRECAO = 3 AND COR3.id_status = 3)
												   LEFT JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR4  ON (RED.ID = COR4.REDACAO_ID AND COR4.ID_TIPO_CORRECAO = 4 AND COR4.id_status = 3)
												   LEFT JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR5  ON (RED.ID = COR5.REDACAO_ID AND COR5.ID_TIPO_CORRECAO = 5 AND COR5.id_status = 3)
												   LEFT JOIN [' + @ESQUEMA + '].CORRECOES_CORRECAO      COR6  ON (RED.ID = COR6.REDACAO_ID AND COR6.ID_TIPO_CORRECAO = 6 AND COR6.id_status = 3)
)'

SET @SQL2 = N'
	SELECT REDACAO_ID, PROJETO_ID, TIPO_AUDITORIA 
	  FROM CTE_VALIDACAO_AUDITORIA 
	  WHERE (TIPO_AUDITORIA = ' + CHAR(39) + 'N. MÁXIMA' + CHAR(39) + ' AND 
				 (	(NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 0) AND
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 0  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 1) AND   
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 1) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 0  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 0  AND NOTA_FINAL_4 = 1) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 0) AND  
				    (NOTA_FINAL_1 = 1  AND NOTA_FINAL_2 = 1  AND NOTA_FINAL_3 = 1  AND NOTA_FINAL_4 = 1)   
				)	 
	        )  OR '
	
SET @SQL3 = N'
			(TIPO_AUDITORIA   = ' + CHAR(39) + 'PD' + CHAR(39) + ' AND 
				NOT (	(PD_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'PD' + CHAR(39) + '    ) OR 
				        (PD_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR   
				        (PD_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR    
				        (PD_1 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR   
				        (PD_1 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_2 = ' + CHAR(39) + 'PD'     + CHAR(39) + ' AND PD_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND PD_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ')				     
				)
			) OR '

SET @SQL4 = N'
			(TIPO_AUDITORIA = ' + CHAR(39) + 'DDH' + CHAR(39) + ' AND 
				NOT	(	(DDH_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'DDH' + CHAR(39) + ') OR 
				        (DDH_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR   
				        (DDH_1 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR    
				        (DDH_1 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ') OR   
				        (DDH_1 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_2 = ' + CHAR(39) + 'DDH'    + CHAR(39) + ' AND DDH_3 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ' AND DDH_4 = ' + CHAR(39) + 'NORMAL' + CHAR(39) + ')				     
				)
			)
'

EXEC (@SQL1 + @SQL2 + @SQL3 + @SQL4)
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_entregas]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_gera_entregas] as
begin
	
	--Copia os dados mais atualizados da correção
    exec sp_copia_dados 

    exec sp_gera_lote_n59

	-- exec sp_gera_lote_n65 -- corretores sem referencia na view do aurelio
	-- exec sp_gera_lote_n67 -- OK
	-- exec sp_gera_lote_n68 -- OK
	-- exec sp_gera_lote_n69 -- OK
	-- exec sp_gera_lote_n70 -- OK
end 
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_gera_lote_n59]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @12_lote_id int
	declare @3_lote_id int
	declare @4_lote_id int
	declare @bi_lote_id int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '5'

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_bi int = 3
    declare @interface_n59 int = 1

	--Copia os dados mais atualizados da correção
	 exec sp_copia_dados -- movido para a procedure 

	
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12
	end

	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_12', 1, dbo.getlocaldate(), @tipo_12, @interface_n59)
	set @12_lote_id = @@IDENTITY

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_3', 1, dbo.getlocaldate(), @tipo_3, @interface_n59)
	set @3_lote_id = @@IDENTITY

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_4', 1, dbo.getlocaldate(), @tipo_4, @interface_n59)
	set @4_lote_id = @@IDENTITY

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_BI_LOGISTICA', 1, dbo.getlocaldate(), @tipo_bi, @interface_n59)
	set @bi_lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(COR1.data_inicio, COR2.data_inicio), COR3.data_inicio), COR4.data_inicio), CORA.data_inicio),
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   sn91.ID_ITEM_ATENDIMENTO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = null,
		   FERE_DH_AVAA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (' + @pcd_surdez + ', ' + @pcd_dislexia + '))
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado = 0 and red.nota_final is not null and red.id_status = 4 and cor1.id_status = 3 and cor2.id_status = 3
	   and ((cor3.id_status = 3 and cor3.id is not null) or cor3.id is null)
	   and ((cor4.id_status = 3 and cor4.id is not null) or cor4.id is null)
	   and red.data_termino is not null
	   and red.data_termino <= dateadd(hour, -1, dbo.getlocaldate()); --seleciona apenas redações que estão finalizadas a mais de 1 hora, para não correr o risco de consultar dados ainda não commitados

	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao)
		 select red.redacao_id, case when red.id_avaliador_av4 is not null then ' + convert(varchar(50), @4_lote_id) + ' when red.id_avaliador_av4 is null and red.id_avaliador_av3 is not null then ' + convert(varchar(50), @3_lote_id) + ' else ' + convert(varchar(50), @12_lote_id) + ' end, red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, case red.id_item_atendimento when ' + @pcd_surdez + ' then 2 when ' + @pcd_dislexia + ' then 3 else 1 end, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
       and red.cpf_avaliador_ava is null --restrição temporária
	   and not exists(select top 1 1 from inep_n59 n59 join inep_lote lote on n59.co_inscricao = red.co_inscricao and lote.id = n59.lote_id and lote.status_id in (4, 2));

	'
	exec (@sql)


	--Atualizar IN_FERE_DH
	update inep_n59 set in_fere_dh = null where nu_nota_media_comp5 > 0 and in_fere_dh = 0 and lote_id in (@12_lote_id, @3_lote_id, @4_lote_id)
	update inep_n59 set in_fere_dh = 0 where nu_nota_media_comp5 = 0 and in_fere_dh is null and lote_id in (@12_lote_id, @3_lote_id, @4_lote_id)


	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    exec sp_consiste_lote_n59 @12_lote_id
    exec sp_consiste_lote_n59 @3_lote_id
    exec sp_consiste_lote_n59 @4_lote_id
    exec sp_consiste_lote_n59 @bi_lote_id


	--consiste lote de redações em branco e texto insuficiente, identificadas no processo do robô/batimento
	declare @lote_id_bi_batimento int
	set @lote_id_bi_batimento = (select id from inep_lote where tipo_id = 3 and status_id = 1 and nome like '%batimento%')

   -- exec sp_consiste_lote_n59 @lote_id_bi_batimento


--   exec sp_gera_lote_n59_com_auditoria


end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_alt_13122019]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_alt_13122019]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '11'

	declare @data_char char(8) = '20191213'
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_bi int = 3
    declare @tipo_avulsos int = 5
    declare @interface_n59 int = 1

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_ALT', 1, dbo.getlocaldate(), @tipo_avulsos, @interface_n59)
	set @lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = RED.data_inicio,
	   DATA_TERMINO = red.data_termino,
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   sn91.ID_ITEM_ATENDIMENTO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = 12,
		   FERE_DH_AVAA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (' + @pcd_surdez + ', ' + @pcd_dislexia + '))
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado=0 and red.id in (select r.redacao_id from TMP_REDACOES_SEGUNDA_REGERAR R)
	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao)
		 select red.redacao_id, ' + convert(varchar(50), @lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, case red.id_item_atendimento when ' + @pcd_surdez + ' then 2 when ' + @pcd_dislexia + ' then 3 else 1 end, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
       and red.cpf_avaliador_ava is null --restrição temporária
	'
	exec (@sql)

	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    --exec sp_consiste_lote_n59 @lote_id


end
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_alt_14122019]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_alt_14122019]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '11'

	declare @data_char char(8) = '20191213'
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_bi int = 3
    declare @tipo_avulsos int = 5
    declare @interface_n59 int = 1

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_ALT', 1, dbo.getlocaldate(), @tipo_avulsos, @interface_n59)
	set @lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = RED.data_inicio,
	   DATA_TERMINO = red.data_termino,
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   sn91.ID_ITEM_ATENDIMENTO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = 12,
		   FERE_DH_AVAA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (' + @pcd_surdez + ', ' + @pcd_dislexia + '))
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado=0 and red.id in (select r.redacao_id from tmp_redacoes_inconsistentes_13122019_2056 R)
	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao)
		 select red.redacao_id, ' + convert(varchar(50), @lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, case red.id_item_atendimento when ' + @pcd_surdez + ' then 2 when ' + @pcd_dislexia + ' then 3 else 1 end, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
       and red.cpf_avaliador_ava is null --restrição temporária
	'
	exec (@sql)

	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    --exec sp_consiste_lote_n59 @lote_id


end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_alt_14122019_quartas]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_gera_lote_n59_alt_14122019_quartas]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '11'

	declare @data_char char(8) = '20191214'
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_bi int = 3
    declare @tipo_avulsos int = 5
    declare @interface_n59 int = 1

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id, observacoes) values (@prefixo + '_' + @data_char + '_ALT_4AS', 1, dbo.getlocaldate(), @tipo_4, @interface_n59, 'Lote para reenvio de todas as quartas, pois os arquivos foram enviados com problema pelo programa do Aurélio')
	set @lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = RED.data_inicio,
	   DATA_TERMINO = red.data_termino,
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   sn91.ID_ITEM_ATENDIMENTO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = 12,
		   FERE_DH_AVAA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (' + @pcd_surdez + ', ' + @pcd_dislexia + '))
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado=0 and red.id in (Select q.redacao_id from tmp_quartas q)
	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao)
		 select red.redacao_id, ' + convert(varchar(50), @lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, case red.id_item_atendimento when ' + @pcd_surdez + ' then 2 when ' + @pcd_dislexia + ' then 3 else 1 end, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
       and red.cpf_avaliador_ava is null --restrição temporária
	'
	exec (@sql)

	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    --exec sp_consiste_lote_n59 @lote_id


end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_alt_30122019]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_alt_30122019]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '5'

	declare @data_char char(8) = '20191230'
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_bi int = 3
    declare @tipo_avulsos int = 5
    declare @interface_n59 int = 1

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_ALT', 1, dbo.getlocaldate(), @tipo_avulsos, @interface_n59)
	set @lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = RED.data_inicio,
	   DATA_TERMINO = red.data_termino,
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   sn91.ID_ITEM_ATENDIMENTO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = 12,
		   FERE_DH_AVAA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (' + @pcd_surdez + ', ' + @pcd_dislexia + '))
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado=0 and red.co_inscricao in (''191044343124'', ''191053055106'', ''191009453181'', ''191058805422'', ''191042686433'', ''191044081294'', ''191044819230'', ''191042500386'', ''191040747195'', ''191046611585'', ''191042387560'', ''191042062197''
)
	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao)
		 select red.redacao_id, ' + convert(varchar(50), @lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, case red.id_item_atendimento when ' + @pcd_surdez + ' then 2 when ' + @pcd_dislexia + ' then 3 else 1 end, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
       and red.cpf_avaliador_ava is null --restrição temporária
	'
	exec (@sql)

	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    --exec sp_consiste_lote_n59 @lote_id


end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_com_auditoria]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_com_auditoria]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @12_lote_id int
	declare @3_lote_id int
	declare @4_lote_id int
	declare @auditoria_lote_id int
	declare @bi_lote_id int

	declare @pcd_surdez char(1) = '8'
	declare @pcd_dislexia char(1) = '5'

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_9 int = 9
    declare @tipo_bi int = 3
    declare @interface_n59 int = 1


	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_9 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_9)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_9
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_AUDITORIA', 1, dbo.getlocaldate(), @tipo_9, @interface_n59)
	set @auditoria_lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(COR1.data_inicio, COR2.data_inicio), COR3.data_inicio), COR4.data_inicio), CORA.data_inicio),
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   sn91.ID_ITEM_ATENDIMENTO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = null,
		   FERE_DH_AVA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (' + @pcd_surdez + ', ' + @pcd_dislexia + '))
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado = 0 and red.nota_final is not null and red.id_status = 4
	   and red.data_termino is not null
	   and red.co_inscricao not in (select n59.co_inscricao from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id and lote.status_id in (4, 2))
	   and CORA.ID_CORRETOR is not null
	   and cor4.id_corretor is null;
	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	CREATE NONCLUSTERED INDEX ix__tmp_redacoes__co_inscricao__CPF_AVALIADOR_AV4__NOTA_FINAL
	ON #tmp_redacoes ([CPF_AVALIADOR_AV4],[NOTA_FINAL])
	INCLUDE ([REDACAO_ID],[PROJETO_ID],[CPF_AVALIADOR_AV1],[NOTA_COMP1_AV1],[NOTA_COMP2_AV1],[NOTA_COMP3_AV1],[NOTA_COMP4_AV1],[NOTA_COMP5_AV1],[NOTA_FINAL_AV1],[ID_SITUACAO_AV1],[SIGLA_SITUACAO_AV1],[FERE_DH_AV1],[DATA_INICIO_AV1],[DATA_TERMINO_AV1],[DURACAO_AV1],[LINK_IMAGEM_AV1],[CPF_AVALIADOR_AV2],[NOTA_COMP1_AV2],[NOTA_COMP2_AV2],[NOTA_COMP3_AV2],[NOTA_COMP4_AV2],[NOTA_COMP5_AV2],[NOTA_FINAL_AV2],[ID_SITUACAO_AV2],[SIGLA_SITUACAO_AV2],[FERE_DH_AV2],[DATA_INICIO_AV2],[DATA_TERMINO_AV2],[DURACAO_AV2],[CPF_AVALIADOR_AV3],[NOTA_COMP1_AV3],[NOTA_COMP2_AV3],[NOTA_COMP3_AV3],[NOTA_COMP4_AV3],[NOTA_COMP5_AV3],[NOTA_FINAL_AV3],[ID_SITUACAO_AV3],[SIGLA_SITUACAO_AV3],[FERE_DH_AV3],[DATA_INICIO_AV3],[DATA_TERMINO_AV3],[DURACAO_AV3],[NOTA_COMP1_AV4],[NOTA_COMP2_AV4],[NOTA_COMP3_AV4],[NOTA_COMP4_AV4],[NOTA_COMP5_AV4],[NOTA_FINAL_AV4],[ID_SITUACAO_AV4],[SIGLA_SITUACAO_AV4],[FERE_DH_AV4],[DATA_INICIO_AV4],[DATA_TERMINO_AV4],[DURACAO_AV4],[CPF_AVALIADOR_AVA],[NOTA_COMP1_AVA],[NOTA_COMP2_AVA],[NOTA_COMP3_AVA],[NOTA_COMP4_AVA],[NOTA_COMP5_AVA],[NOTA_FINAL_AVA],[ID_SITUACAO_AVA],[SIGLA_SITUACAO_AVA],[DATA_INICIO_AVA],[DATA_TERMINO_AVA],[DURACAO_AVA],[CO_INSCRICAO],[ID_CORRECAO_SITUACAO],[FERE_DH_FINAL],[DATA_INICIO],[DATA_TERMINO],[CO_PROJETO],[SG_UF_PROVA],[ID_ITEM_ATENDIMENTO],[NOTA_COMP1],[NOTA_COMP2],[NOTA_COMP3],[NOTA_COMP4],[NOTA_COMP5],[co_justificativa],[FERE_DH_AVAA])

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao, nu_cpf_auditor)
		 select red.redacao_id, ' + convert(varchar(50), @auditoria_lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, case red.id_item_atendimento when ' + @pcd_surdez + ' then 2 when ' + @pcd_dislexia + ' then 3 else 1 end, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.cpf_avaliador_ava else red.cpf_avaliador_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_inicio_ava else red.data_inicio_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_termino_ava else red.data_termino_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.duracao_ava else red.duracao_av3 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.id_situacao_ava else red.id_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.sigla_situacao_ava else red.sigla_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_final_ava else red.nota_final_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp1_ava else red.nota_comp1_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp2_ava else red.nota_comp2_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp3_ava else red.nota_comp3_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp4_ava else red.nota_comp4_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp5_ava else red.nota_comp5_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.fere_dh_ava else red.fere_dh_av3 end,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.cpf_avaliador_ava else red.cpf_avaliador_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_inicio_ava else red.data_inicio_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_termino_ava else red.data_termino_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.duracao_ava else red.duracao_av4 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.id_situacao_ava else red.id_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.sigla_situacao_ava else red.sigla_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_final_ava else red.nota_final_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp1_ava else red.nota_comp1_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp2_ava else red.nota_comp2_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp3_ava else red.nota_comp3_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp4_ava else red.nota_comp4_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp5_ava else red.nota_comp5_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.fere_dh_ava else red.fere_dh_av4 end,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0, red.cpf_avaliador_ava
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
	   and not exists(select top 1 1 from inep_n59 n59 join inep_lote lote on n59.co_inscricao = red.co_inscricao and lote.id = n59.lote_id and lote.status_id in (4, 2));

	'
	exec (@sql)


	--Garante o IN_FERE_DH correto
	update inep_n59 set in_fere_dh = null where nu_nota_media_comp5 > 0 and in_fere_dh = 0 and lote_id in (@auditoria_lote_id)
	update inep_n59 set in_fere_dh = 0 where nu_nota_media_comp5 = 0 and in_fere_dh is null and lote_id in (@auditoria_lote_id)


	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    exec sp_consiste_lote_n59 @auditoria_lote_id


end
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_full]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_full]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id int

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @interface_n59 int = 1
	
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = 5 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = 5)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = 5
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_FULL', 1, dbo.getlocaldate(), 5, @interface_n59)
	set @lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(COR1.data_inicio, COR2.data_inicio), COR3.data_inicio), COR4.data_inicio), CORA.data_inicio),
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   isnull(sn90.SG_UF_MUNICIPIO_PROVA, ''XX'') as SG_UF_PROVA,            
		   isnull(pcd.banca, 1) as CO_TIPO_AVALIACAO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = null,
		   FERE_DH_AVA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into [' + @data_char + '].tmp_redacoes
	  FROM [' + @data_char + '].CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   LEFT JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN BANCA_PCD pcd ON (pcd.CO_INSCRICAO = RED.co_inscricao)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado = 0 and red.id_status = 4 and id_redacaoouro is null
--	   and red.id not in (select n59.redacao_id from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id and lote.status_id in (4, 2))
	 --and cor1.id_status = 3 and cor2.id_status = 3
	 --  and ((cor3.id_status = 3 and cor3.id is not null) or cor3.id is null)
	  -- and ((cor4.id_status = 3 and cor4.id is not null) or cor4.id is null)
	   --and red.data_termino is not null
	   --and red.data_termino <= dateadd(hour, -1, dbo.getlocaldate()); --seleciona apenas redações que estão finalizadas a mais de 1 hora, para não correr o risco de consultar dados ainda não commitados

	
	create index ix__tmp_redacoes_' + @data_char + '__co_inscricao on [' + @data_char + '].tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes_' + @data_char + '__projeto_id__nota_final on [' + @data_char + '].tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao, nu_cpf_auditor)
		 select red.redacao_id, ' + convert(varchar(50), @lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, red.co_tipo_avaliacao, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.cpf_avaliador_ava else red.cpf_avaliador_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_inicio_ava else red.data_inicio_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_termino_ava else red.data_termino_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.duracao_ava else red.duracao_av3 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.id_situacao_ava else red.id_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.sigla_situacao_ava else red.sigla_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_final_ava else red.nota_final_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp1_ava else red.nota_comp1_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp2_ava else red.nota_comp2_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp3_ava else red.nota_comp3_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp4_ava else red.nota_comp4_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp5_ava else red.nota_comp5_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.fere_dh_ava else red.fere_dh_av3 end,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.cpf_avaliador_ava else red.cpf_avaliador_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_inicio_ava else red.data_inicio_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_termino_ava else red.data_termino_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.duracao_ava else red.duracao_av4 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.id_situacao_ava else red.id_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.sigla_situacao_ava else red.sigla_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_final_ava else red.nota_final_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp1_ava else red.nota_comp1_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp2_ava else red.nota_comp2_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp3_ava else red.nota_comp3_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp4_ava else red.nota_comp4_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp5_ava else red.nota_comp5_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.fere_dh_ava else red.fere_dh_av4 end,
--				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
--				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0, cpf_avaliador_ava
	  from [' + @data_char + '].tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
	'
	exec (@sql)


	--Atualizar IN_FERE_DH
	update inep_n59 set in_fere_dh = null where nu_nota_media_comp5 > 0 and in_fere_dh = 0 and lote_id in (@lote_id)
	update inep_n59 set in_fere_dh = 0 where nu_nota_media_comp5 = 0 and co_situacao_redacao_final = 1 and in_fere_dh is null and lote_id in (@lote_id)

    --Consiste os lotes gerados
    exec sp_consiste_lote_n59 @lote_id


end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_individual]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_individual] @lote_id int, @redacao_id int	
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(COR1.data_inicio, COR2.data_inicio), COR3.data_inicio), COR4.data_inicio), CORA.data_inicio),
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   sn02.SG_UF_PROVA as SG_UF_PROVA,            
		   isnull(pcd.banca, 1) as CO_TIPO_AVALIACAO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = null,
		   FERE_DH_AVA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM [' + @data_char + '].CORRECOES_REDACAO RED
	       LEFT OUTER JOIN n02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   LEFT OUTER JOIN BANCA_PCD pcd ON (pcd.CO_INSCRICAO = RED.co_inscricao)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.id = ' + convert(varchar(50), @redacao_id) + '

	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao, nu_cpf_auditor)
		 select red.redacao_id, ' + convert(varchar(50), @lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, red.co_tipo_avaliacao, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.cpf_avaliador_ava else red.cpf_avaliador_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_inicio_ava else red.data_inicio_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_termino_ava else red.data_termino_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.duracao_ava else red.duracao_av3 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.id_situacao_ava else red.id_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.sigla_situacao_ava else red.sigla_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_final_ava else red.nota_final_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp1_ava else red.nota_comp1_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp2_ava else red.nota_comp2_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp3_ava else red.nota_comp3_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp4_ava else red.nota_comp4_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp5_ava else red.nota_comp5_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.fere_dh_ava else red.fere_dh_av3 end,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.cpf_avaliador_ava else red.cpf_avaliador_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_inicio_ava else red.data_inicio_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_termino_ava else red.data_termino_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.duracao_ava else red.duracao_av4 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.id_situacao_ava else red.id_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.sigla_situacao_ava else red.sigla_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_final_ava else red.nota_final_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp1_ava else red.nota_comp1_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp2_ava else red.nota_comp2_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp3_ava else red.nota_comp3_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp4_ava else red.nota_comp4_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp5_ava else red.nota_comp5_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.fere_dh_ava else red.fere_dh_av4 end,
--				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
--				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0, cpf_avaliador_ava
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
	'
	exec (@sql)


	--Atualizar IN_FERE_DH
	update inep_n59 set in_fere_dh = null where nu_nota_media_comp5 > 0 and in_fere_dh = 0 and lote_id in (@lote_id)
	update inep_n59 set in_fere_dh = 0 where nu_nota_media_comp5 = 0 and co_situacao_redacao_final = 1 and in_fere_dh is null and lote_id in (@lote_id)


end
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_residual_v1]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_residual_v1]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id int

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @interface_n59 int = 1

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_RESIDUAL_1', 1, dbo.getlocaldate(), 5, @interface_n59)
	set @lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(COR1.data_inicio, COR2.data_inicio), COR3.data_inicio), COR4.data_inicio), CORA.data_inicio),
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   SNO2.SG_UF_PROVA as SG_UF_PROVA,            
		   isnull(pcd.banca, 1) as CO_TIPO_AVALIACAO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = null,
		   FERE_DH_AVA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM [' + @data_char + '].CORRECOES_REDACAO RED
	       LEFT OUTER JOIN n02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   LEFT OUTER JOIN BANCA_PCD pcd ON (pcd.CO_INSCRICAO = RED.co_inscricao)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT OUTER JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT OUTER JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT OUTER JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado = 0 and red.id_status = 4 and red.id_redacaoouro is null
	   and not exists (select top 1 1 from inep_n59 n59 where red.co_inscricao = n59.co_inscricao)
	 --and cor1.id_status = 3 and cor2.id_status = 3
	 --  and ((cor3.id_status = 3 and cor3.id is not null) or cor3.id is null)
	  -- and ((cor4.id_status = 3 and cor4.id is not null) or cor4.id is null)
	   --and red.data_termino is not null
	   --and red.data_termino <= dateadd(hour, -1, dbo.getlocaldate()); --seleciona apenas redações que estão finalizadas a mais de 1 hora, para não correr o risco de consultar dados ainda não commitados

	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao, nu_cpf_auditor)
		 select red.redacao_id, ' + convert(varchar(50), @lote_id) + ', red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, red.co_tipo_avaliacao, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.cpf_avaliador_ava else red.cpf_avaliador_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_inicio_ava else red.data_inicio_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_termino_ava else red.data_termino_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.duracao_ava else red.duracao_av3 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.id_situacao_ava else red.id_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.sigla_situacao_ava else red.sigla_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_final_ava else red.nota_final_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp1_ava else red.nota_comp1_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp2_ava else red.nota_comp2_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp3_ava else red.nota_comp3_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp4_ava else red.nota_comp4_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp5_ava else red.nota_comp5_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.fere_dh_ava else red.fere_dh_av3 end,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.cpf_avaliador_ava else red.cpf_avaliador_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_inicio_ava else red.data_inicio_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_termino_ava else red.data_termino_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.duracao_ava else red.duracao_av4 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.id_situacao_ava else red.id_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.sigla_situacao_ava else red.sigla_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_final_ava else red.nota_final_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp1_ava else red.nota_comp1_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp2_ava else red.nota_comp2_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp3_ava else red.nota_comp3_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp4_ava else red.nota_comp4_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp5_ava else red.nota_comp5_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.fere_dh_ava else red.fere_dh_av4 end,
--				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
--				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0, cpf_avaliador_ava
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
	'
	exec (@sql)


	--Atualizar IN_FERE_DH
	update inep_n59 set in_fere_dh = null where nu_nota_media_comp5 > 0 and in_fere_dh = 0 and lote_id in (@lote_id)
	update inep_n59 set in_fere_dh = 0 where nu_nota_media_comp5 = 0 and co_situacao_redacao_final = 1 and in_fere_dh is null and lote_id in (@lote_id)

    --Consiste os lotes gerados
--    exec sp_consiste_lote_n59 @lote_id


end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_v2]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_v2]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @12_lote_id int
	declare @3_lote_id int
	declare @4_lote_id int
	declare @bi_lote_id int
	declare @auditoria_lote_id int

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_9 int = 9
    declare @tipo_bi int = 3
    declare @interface_n59 int = 1

	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 

	
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12
	end

	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_12', 1, dbo.getlocaldate(), @tipo_12, @interface_n59)
	set @12_lote_id = @@IDENTITY

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_3', 1, dbo.getlocaldate(), @tipo_3, @interface_n59)
	set @3_lote_id = @@IDENTITY

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_4', 1, dbo.getlocaldate(), @tipo_4, @interface_n59)
	set @4_lote_id = @@IDENTITY

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_AUDITORIA', 1, dbo.getlocaldate(), @tipo_9, @interface_n59)
	set @auditoria_lote_id = @@IDENTITY

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_BI_LOGISTICA', 1, dbo.getlocaldate(), @tipo_bi, @interface_n59)
	set @bi_lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(COR1.data_inicio, COR2.data_inicio), COR3.data_inicio), COR4.data_inicio), CORA.data_inicio),
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   isnull(pcd.banca, 1) as CO_TIPO_AVALIACAO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = null,
		   FERE_DH_AVA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into [' + @data_char + '].tmp_redacoes	
	  FROM [' + @data_char + '].CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN BANCA_PCD pcd ON (pcd.CO_INSCRICAO = RED.co_inscricao)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado = 0 and red.id_status = 4 and id_redacaoouro is null
	   and not exists (select top 1 1 from inep_n59 n59 join inep_lote lote on lote.id = n59.lote_id where red.co_inscricao = n59.co_inscricao and lote.status_id in (4, 2))
	 --and cor1.id_status = 3 and cor2.id_status = 3
	 --  and ((cor3.id_status = 3 and cor3.id is not null) or cor3.id is null)
	  -- and ((cor4.id_status = 3 and cor4.id is not null) or cor4.id is null)
	   --and red.data_termino is not null
	   --and red.data_termino <= dateadd(hour, -1, dbo.getlocaldate()); --seleciona apenas redações que estão finalizadas a mais de 1 hora, para não correr o risco de consultar dados ainda não commitados

	
	create index ix__tmp_redacoes_' + @data_char + '__co_inscricao on [' + @data_char + '].tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes_' + @data_char + '__projeto_id__nota_final on [' + @data_char + '].tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao, nu_cpf_auditor)
		 select red.redacao_id, case when red.id_avaliador_av4 is not null then ' + convert(varchar(50), @4_lote_id) + ' when red.id_avaliador_av4 is null and red.id_avaliador_av3 is not null then ' + convert(varchar(50), @3_lote_id) + ' else ' + convert(varchar(50), @12_lote_id) + ' end, red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, red.co_tipo_avaliacao, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.cpf_avaliador_ava else red.cpf_avaliador_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_inicio_ava else red.data_inicio_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_termino_ava else red.data_termino_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.duracao_ava else red.duracao_av3 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.id_situacao_ava else red.id_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.sigla_situacao_ava else red.sigla_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_final_ava else red.nota_final_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp1_ava else red.nota_comp1_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp2_ava else red.nota_comp2_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp3_ava else red.nota_comp3_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp4_ava else red.nota_comp4_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp5_ava else red.nota_comp5_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.fere_dh_ava else red.fere_dh_av3 end,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.cpf_avaliador_ava else red.cpf_avaliador_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_inicio_ava else red.data_inicio_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_termino_ava else red.data_termino_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.duracao_ava else red.duracao_av4 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.id_situacao_ava else red.id_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.sigla_situacao_ava else red.sigla_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_final_ava else red.nota_final_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp1_ava else red.nota_comp1_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp2_ava else red.nota_comp2_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp3_ava else red.nota_comp3_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp4_ava else red.nota_comp4_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp5_ava else red.nota_comp5_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.fere_dh_ava else red.fere_dh_av4 end,
--				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
--				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0, cpf_avaliador_ava
	  from [' + @data_char + '].tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
	'
	exec (@sql)


	--Atualizar IN_FERE_DH
	update inep_n59 set in_fere_dh = null where nu_nota_media_comp5 > 0 and in_fere_dh = 0 and lote_id in (@12_lote_id, @3_lote_id, @4_lote_id)
	update inep_n59 set in_fere_dh = 0 where nu_nota_media_comp5 = 0 and co_situacao_redacao_final = 1 and in_fere_dh is null and lote_id in (@12_lote_id, @3_lote_id, @4_lote_id)


	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    exec sp_consiste_lote_n59 @12_lote_id
    exec sp_consiste_lote_n59 @3_lote_id
    exec sp_consiste_lote_n59 @4_lote_id
    exec sp_consiste_lote_n59 @bi_lote_id
    exec sp_consiste_lote_n59 @auditoria_lote_id


	--consiste lote de redações em branco e texto insuficiente, identificadas no processo do robô/batimento
	--declare @lote_id_bi_batimento int
--	set @lote_id_bi_batimento = (select id from inep_lote where tipo_id = 3 and status_id = 1 and nome like '%batimento%')

   -- exec sp_consiste_lote_n59 @lote_id_bi_batimento


--   exec sp_gera_lote_n59_com_auditoria


end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59_v2_alt_191021163263]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[sp_gera_lote_n59_v2_alt_191021163263]
as
begin

	declare @sql nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @12_lote_id int
	declare @3_lote_id int
	declare @4_lote_id int
	declare @bi_lote_id int
	declare @auditoria_lote_id int

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACOES'
    declare @tipo_12 int = 1
    declare @tipo_3 int = 2
    declare @tipo_4 int = 4
    declare @tipo_9 int = 9
    declare @tipo_bi int = 3
    declare @interface_n59 int = 1

	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 

	
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12
	end

	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3 and status_id = 1) begin
		delete from inep_n59 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_3
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_AUDITORIA', 1, dbo.getlocaldate(), @tipo_9, @interface_n59)
	set @auditoria_lote_id = @@IDENTITY

	set @sql ='
	SELECT
		   REDACAO_ID               = RED.ID,
		   PROJETO_ID               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = SIT1.sigla,
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = SIT2.sigla,
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = SIT3.sigla,
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AV4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AV4      = PES4.NOME,
		   CPF_AVALIADOR_AV4       = PES4.cpf,  
		   COMP1_AV4               = COR4.COMPETENCIA1,
		   COMP2_AV4               = COR4.COMPETENCIA2,
		   COMP3_AV4               = COR4.COMPETENCIA3,
		   COMP4_AV4               = COR4.COMPETENCIA4,
		   COMP5_AV4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AV4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AV4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV4      = SIT4.sigla,
		   FERE_DH_AV4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV4         = COR4.data_inicio,
		   DATA_TERMINO_AV4        = COR4.data_termino,
		   DURACAO_AV4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4         = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVA      = PESA.NOME,
		   CPF_AVALIADOR_AVA       = PESA.cpf,  
		   COMP1_AVA               = CORA.COMPETENCIA1,
		   COMP2_AVA               = CORA.COMPETENCIA2,
		   COMP3_AVA               = CORA.COMPETENCIA3,
		   COMP4_AVA               = CORA.COMPETENCIA4,
		   COMP5_AVA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA      = SITA.sigla,
		   DATA_INICIO_AVA         = CORA.data_inicio,
		   DATA_TERMINO_AVA        = CORA.data_termino,
		   DURACAO_AVA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is not null and COR3.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_INICIO = dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(dbo.InlineMinDatetime(COR1.data_inicio, COR2.data_inicio), COR3.data_inicio), COR4.data_inicio), CORA.data_inicio),
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   isnull(pcd.banca, 1) as CO_TIPO_AVALIACAO,
		   NOTA_COMP1 = red.NOTA_COMPETENCIA1,
		   NOTA_COMP2 = red.NOTA_COMPETENCIA2,
		   NOTA_COMP3 = red.NOTA_COMPETENCIA3,
		   NOTA_COMP4 = red.NOTA_COMPETENCIA4,
		   NOTA_COMP5 = red.NOTA_COMPETENCIA5,
		   co_justificativa = null,
		   FERE_DH_AVA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	into #tmp_redacoes	
	  FROM CORRECOES_REDACAO RED
	       LEFT JOIN INEP_N02 SNO2 ON (SNO2.CO_INSCRICAO = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN BANCA_PCD pcd ON (pcd.CO_INSCRICAO = RED.co_inscricao)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR1 ON (RED.id = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES1 ON (COR1.id_corretor = PES1.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR2 ON (RED.id = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES2 ON (COR2.id_corretor = PES2.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR3 ON (RED.id = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES3 ON (COR3.id_corretor = PES3.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   COR4 ON (RED.id = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PES4 ON (COR4.id_corretor = PES4.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_CORRECAO   CORA ON (RED.id = CORA.redacao_id AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN [' + @data_char + '].USUARIOS_PESSOA      PESA ON (CORA.id_corretor = PESA.usuario_id)
		   LEFT JOIN [' + @data_char + '].CORRECOES_ANALISE    ANA3 ON (ANA3.redacao_id = RED.id AND ANA3.id_tipo_correcao_B = 3 and ANA3.id_tipo_correcao_A = 1) 
		   LEFT JOIN CORRECOES_SITUACAO   SIT1 ON (SIT1.id = COR1.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT2 ON (SIT2.id = COR2.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT3 ON (SIT3.id = COR3.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SIT4 ON (SIT4.id = COR4.id_correcao_situacao)
		   LEFT JOIN CORRECOES_SITUACAO   SITA ON (SITA.id = CORA.id_correcao_situacao)
	 WHERE red.cancelado = 0 and red.co_inscricao = ''191021163263''

	
	create index ix__tmp_redacoes__co_inscricao on #tmp_redacoes(co_inscricao)
	create index ix__tmp_redacoes__projeto_id__nota_final on #tmp_redacoes(projeto_id, nota_final)

	insert into inep_n59 (redacao_id, lote_id, projeto_id, co_projeto, criado_em, data_inicio, data_termino, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5, co_tipo_avaliacao, link_imagem_recortada, nu_cpf_av1, dt_inicio_av1, dt_fim_av1, nu_tempo_av1, id_lote_av1, co_situacao_redacao_av1, sg_situacao_redacao_av1, nu_nota_av1, nu_nota_comp1_av1, nu_nota_comp2_av1, nu_nota_comp3_av1, nu_nota_comp4_av1, nu_nota_comp5_av1, in_fere_dh_av1, nu_cpf_av2, dt_inicio_av2, dt_fim_av2, nu_tempo_av2, id_lote_av2, co_situacao_redacao_av2, sg_situacao_redacao_av2, nu_nota_av2, nu_nota_comp1_av2, nu_nota_comp2_av2, nu_nota_comp3_av2, nu_nota_comp4_av2, nu_nota_comp5_av2, in_fere_dh_av2, nu_cpf_av3, dt_inicio_av3, dt_fim_av3, nu_tempo_av3, id_lote_av3, co_situacao_redacao_av3, sg_situacao_redacao_av3, nu_nota_av3, nu_nota_comp1_av3, nu_nota_comp2_av3, nu_nota_comp3_av3, nu_nota_comp4_av3, nu_nota_comp5_av3, in_fere_dh_av3, nu_cpf_av4, dt_inicio_av4, dt_fim_av4, nu_tempo_av4, id_lote_av4, co_situacao_redacao_av4, sg_situacao_redacao_av4, nu_nota_av4, nu_nota_comp1_av4, nu_nota_comp2_av4, nu_nota_comp3_av4, nu_nota_comp4_av4, nu_nota_comp5_av4, in_fere_dh_av4, co_situacao_redacao_final, nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final, in_fere_dh, co_justificativa, in_divulgacao)
		 select red.redacao_id, ' + convert(varchar(50), @auditoria_lote_id) + ' , red.projeto_id, red.co_projeto, dbo.getlocaldate(), red.data_inicio, red.data_termino, ''F'', red.co_inscricao, proj.etapa_ensino_id, sg_uf_prova, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, proj.peso_competencia * 5, case proj.etapa_ensino_id when 1 then null else proj.peso_competencia * 5 end, red.co_tipo_avaliacao, red.link_imagem_av1, 
				red.cpf_avaliador_av1, red.data_inicio_av1, red.data_termino_av1, red.duracao_av1, null, red.id_situacao_av1, red.sigla_situacao_av1, red.nota_final_av1, red.nota_comp1_av1, red.nota_comp2_av1, red.nota_comp3_av1, red.nota_comp4_av1, red.nota_comp5_av1, red.fere_dh_av1,
				red.cpf_avaliador_av2, red.data_inicio_av2, red.data_termino_av2, red.duracao_av2, null, red.id_situacao_av2, red.sigla_situacao_av2, red.nota_final_av2, red.nota_comp1_av2, red.nota_comp2_av2, red.nota_comp3_av2, red.nota_comp4_av2, red.nota_comp5_av2, red.fere_dh_av2,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.cpf_avaliador_ava else red.cpf_avaliador_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_inicio_ava else red.data_inicio_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.data_termino_ava else red.data_termino_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.duracao_ava else red.duracao_av3 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.id_situacao_ava else red.id_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.sigla_situacao_ava else red.sigla_situacao_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_final_ava else red.nota_final_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp1_ava else red.nota_comp1_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp2_ava else red.nota_comp2_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp3_ava else red.nota_comp3_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp4_ava else red.nota_comp4_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.nota_comp5_ava else red.nota_comp5_av3 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av3 is null then red.fere_dh_ava else red.fere_dh_av3 end,
				case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.cpf_avaliador_ava else red.cpf_avaliador_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_inicio_ava else red.data_inicio_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.data_termino_ava else red.data_termino_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.duracao_ava else red.duracao_av4 end, null, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.id_situacao_ava else red.id_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.sigla_situacao_ava else red.sigla_situacao_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_final_ava else red.nota_final_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp1_ava else red.nota_comp1_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp2_ava else red.nota_comp2_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp3_ava else red.nota_comp3_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp4_ava else red.nota_comp4_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.nota_comp5_ava else red.nota_comp5_av4 end, case when red.cpf_avaliador_ava is not null and red.cpf_avaliador_av4 is null and red.cpf_avaliador_av3 is not null then red.fere_dh_ava else red.fere_dh_av4 end,
--				red.cpf_avaliador_av3, red.data_inicio_av3, red.data_termino_av3, red.duracao_av3, null, red.id_situacao_av3, red.sigla_situacao_av3, red.nota_final_av3, red.nota_comp1_av3, red.nota_comp2_av3, red.nota_comp3_av3, red.nota_comp4_av3, red.nota_comp5_av3, red.fere_dh_av3,
--				red.cpf_avaliador_av4, red.data_inicio_av4, red.data_termino_av4, red.duracao_av4, null, red.id_situacao_av4, red.sigla_situacao_av4, red.nota_final_av4, red.nota_comp1_av4, red.nota_comp2_av4, red.nota_comp3_av4, red.nota_comp4_av4, red.nota_comp5_av4, red.fere_dh_av4,
				red.id_correcao_situacao, red.nota_comp1, red.nota_comp2, red.nota_comp3, red.nota_comp4, red.nota_comp5, red.nota_final, case when red.nota_comp5 > 0 then null else red.fere_dh_final end, co_justificativa, 0
	  from #tmp_redacoes red join [' + @data_char + '].projeto_projeto proj on proj.id = red.projeto_id where red.nota_final is not null
	'
	exec (@sql)


	--Atualizar IN_FERE_DH
	update inep_n59 set in_fere_dh = null where nu_nota_media_comp5 > 0 and in_fere_dh = 0 and lote_id in (@auditoria_lote_id)
	update inep_n59 set in_fere_dh = 0 where nu_nota_media_comp5 = 0 and in_fere_dh is null and lote_id in (@auditoria_lote_id)


	--exec sp_criar_lote_bi_batimento

    --Consiste os lotes gerados
    exec sp_consiste_lote_n59 @auditoria_lote_id



end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n65]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE    PROCEDURE [dbo].[sp_gera_lote_n65]
as
begin

	declare @sql        nvarchar(max)	
    declare @sql1       nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int


	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'AVALIADORES'
    declare @tipo int = 6
    declare @interface int = 2
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 
	
	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo_12 and status_id = 1

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete from inep_n65 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo  and interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY

	--****************************************************************************************
	DECLARE @SQL_VIEW VARCHAR(MAX) 
	SET @SQL_VIEW = N'
		create OR ALTER view [' + @data_char + '].[vw_corretor_suspensao_desligamento] as 
with cte_corretor_suspensao as (
		select   pes.cpf, count(DISTINCT TRO.ID) as qtd_suspensao, max(COR.history_date) as data_suspensao
		  from [' + @data_char + '].status_corretor_trocastatus tro join [' + @data_char + '].usuarios_pessoa        pes on (tro.corretor_id = pes.usuario_id)		  
		                                                       left join [' + @data_char + '].log_correcoes_corretor COR ON (TRO.corretor_id = COR.ID)
		  where status_atual_id = 3
		       AND  COR.observacao =   ''{'' +  CHAR(39) + ''status''+  CHAR(39) +'': {''+  CHAR(39) +''antigo''+  CHAR(39) + '': 1, ''+  CHAR(39) +''novo''+  CHAR(39) +'': 3}}''
		  group by pes.cpf 
)

    , cte_corretor_motivo_suspensao as (
		select DISTINCT pes.cpf, tro.motivo_id
		  from  [' + @data_char + '].status_corretor_trocastatus tro join [' + @data_char + '].usuarios_pessoa     pes on (tro.corretor_id = pes.usuario_id)
		                                                        left join [' + @data_char + '].CORRECOES_SUSPENSAO sus on (tro.corretor_id = sus.id_corretor)
		                                                        left join cte_corretor_suspensao                   cte on (cte.cpf = pes.cpf)
		 where status_atual_id = 3 and 		       
		       CAST(sus.criado_em AS DATE)  = CAST(cte.data_suspensao AS DATE)
)

	, cte_corretor_desligamento as (
		  select  pes.cpf,  max(COR.history_date) as data_desligamento
		    from  [' + @data_char + '].status_corretor_trocastatus tro join [' + @data_char + '].usuarios_pessoa        pes on (tro.corretor_id = pes.usuario_id)
			                                                           JOIN [' + @data_char + '].log_correcoes_corretor COR ON (TRO.corretor_id = COR.ID)
		  where status_atual_id = 4 AND       
		  (COR.observacao =  ''{'' + CHAR(39) + ''status'' + CHAR(39) + '': {'' + CHAR(39) + ''antigo'' + CHAR(39) +  '': 1, ''  + CHAR(39) + ''novo'' + CHAR(39) + '': 4}}'' OR 
		   COR.observacao =  ''{'' + CHAR(39) + ''status'' + CHAR(39) + '': {'' + CHAR(39) + ''antigo'' + CHAR(39) +  '': 3, ''  + CHAR(39) + ''novo'' + CHAR(39) + '': 4}}'')
		  group by pes.cpf
)

    , cte_corretor_motivo_desligamento as (
		select pes.cpf, motivo_id
		  from  [' + @data_char + '].status_corretor_trocastatus tro join [' + @data_char + '].usuarios_pessoa pes on (tro.corretor_id = pes.usuario_id)
		  where tro.id = (select max(trox.id)
		                    from [' + @data_char + '].status_corretor_trocastatus trox join [' + @data_char + '].usuarios_pessoa pesx on (trox.corretor_id = pesx.usuario_id)
		                   where status_atual_id = 4 and pesx.cpf = pes.cpf)
)

		select distinct pes.cpf, sus.data_suspensao, sus.qtd_suspensao, msu.motivo_id as motivo_id_suspensao, 
		        dsl.data_desligamento, mds.motivo_id as motivo_id_desligamento
		  from [' + @data_char + '].correcoes_corretor cor join [' + @data_char + '].usuarios_pessoa pes on (cor.id = pes.usuario_id)
		                                                   left join cte_corretor_suspensao           sus on (pes.cpf = sus.cpf)
									                       left join cte_corretor_motivo_suspensao    msu on (pes.cpf = msu.cpf)
		                                                   left join cte_corretor_desligamento        dsl on (pes.cpf = dsl.cpf)
									                       left join cte_corretor_motivo_desligamento mds on (pes.cpf = mds.cpf)'
EXEC (@SQL_VIEW)
	--****************************************************************************************

	set @sql ='
	select   
            LOTE_ID = 0, 
		    CRIADO_EM = DBO.getlocaldate(),
		    CO_PROJETO          = pro.codigo,
            TP_ORIGEM           = ' + char(39) + 'F' + char(39) +',  
            NU_CPF              = PES.CPF,  
            NO_CORRETOR         = PES.NOME, 
            NO_MAE_CORRETOR     = TMP.nome_mae,				  
            DT_NASCIMENTO       = TMP.data_nascimento, 
            TP_SEXO             = TMP.sexo,						  
            NO_LOGRADOURO       = TMP.Logradouro,						  
            DS_COMPLEMENTO      = TMP.Complemento,					  
            NO_BAIRRO           = TMP.Bairro,							  
            NO_MUNICIPIO        = TMP.Município,				  
            NU_CEP              = TMP.CEP,							  
            CO_MUNICIPIO        = TMP.CO_MUNICIPIO,
            SG_UF               = TMP.UF,					  
            NU_TEL_RESIDENCIAL  = tmp.tel_res,		  
            NU_TEL_CELULAR      = tmp.celular,			  
            TX_EMAIL            = tmp.email,						  
            TP_TITULACAO        = TMP.CO_TITULACAO,                              
            TP_FUNCAO           = CASE WHEN PES.usuario_id IN (SELECT USER_ID FROM auth_user_user_permissions WHERE permission_id = 320) THEN 5
                                       WHEN GRO.ID = 26 THEN 1 
                                       WHEN GRO.ID = 34 THEN 2
                                       WHEN GRO.ID = 25 THEN 3 
                                       WHEN GRO.ID IN (30,29,27) THEN 4
                                       ELSE NULL END , 
            NU_SUSPENSAO        = csd.qtd_suspensao,
            CO_MOTIVO_SUSPENSAO = csd.motivo_id_suspensao , 
            DT_SUSPENSAO        = csd.data_suspensao, 
            CO_MOTIVO_EXCLUSAO  = csd.motivo_id_desligamento,
            DT_EXCLUSAO         = csd.data_desligamento 

			into #tmp_avaliador 
             from [' + @data_char + '].usuarios_pessoa pes join [' + @data_char + '].projeto_projeto_usuarios           ppu  on (pes.usuario_id  = ppu.USER_ID)  
                                                           JOIN [' + @data_char + '].auth_user_groups                   USG  ON (USG.user_id     = PES.usuario_id)
            									           join [' + @data_char + '].auth_group                         GRO  ON (GRO.id          = USG.group_id)
                                                           join [' + @data_char + '].projeto_projeto                    pro  on (pro.id          = ppu.projeto_id)
            									           JOIN [' + @data_char + '].CORRECOES_CORRETOR                 COR  ON (COR.ID          = PES.USUARIO_ID )
            							              LEFT JOIN tmp_n65                                                 TMP  ON (TMP.cpf         = PES.CPF)		 
            							              LEFT JOIN [' + @data_char + '].vw_corretor_suspensao_desligamento csd  ON (csd.CPF         = PES.CPF)

	create index ix__tmp_avaliador__NU_CPF on #tmp_avaliador(NU_CPF)'

	set @sql1 =N'
	insert into inep_n65 (LOTE_ID, CRIADO_EM,  CO_PROJETO, TP_ORIGEM, NU_CPF, NO_CORRETOR, NO_MAE_CORRETOR, 
                          DT_NASCIMENTO, TP_SEXO, NO_LOGRADOURO, DS_COMPLEMENTO, NO_BAIRRO, NO_MUNICIPIO, NU_CEP, CO_MUNICIPIO, 
		                  SG_UF, NU_TEL_RESIDENCIAL, NU_TEL_CELULAR, TX_EMAIL, TP_TITULACAO, TP_FUNCAO, NU_SUSPENSAO, CO_MOTIVO_SUSPENSAO, 
		                  DT_SUSPENSAO, CO_MOTIVO_EXCLUSAO, DT_EXCLUSAO, status_id)
		 select distinct LOTE_ID = ' + convert(varchar(10), @lote_id) + ', CRIADO_EM,  CO_PROJETO, TP_ORIGEM, NU_CPF, NO_CORRETOR, NO_MAE_CORRETOR, 
                DT_NASCIMENTO, TP_SEXO, NO_LOGRADOURO, DS_COMPLEMENTO, NO_BAIRRO, NO_MUNICIPIO, NU_CEP, CO_MUNICIPIO, 
		        SG_UF, NU_TEL_RESIDENCIAL, NU_TEL_CELULAR, TX_EMAIL, TP_TITULACAO, TP_FUNCAO, NU_SUSPENSAO, CO_MOTIVO_SUSPENSAO, 
		        DT_SUSPENSAO, CO_MOTIVO_EXCLUSAO, DT_EXCLUSAO, status_id = 1
	  from #tmp_avaliador tmp
	  where TP_TITULACAO is not null and 
	        not exists(select top 1 1 from inep_n65 n65 join inep_lote lote on (n65.NU_CPF = tmp.NU_CPF and 
			                                                                    n65.co_projeto = tmp.co_projeto and 
																				n65.tp_funcao  = tmp.tp_funcao  and 
                                                                                lote.id = n65.lote_id and lote.status_id in (4, 2))
				         where  
											(isnull(N65.NU_SUSPENSAO       ,0)            <> isnull(TMP.NU_SUSPENSAO,0)           	OR 
											 isnull(N65.CO_MOTIVO_SUSPENSAO,0)            <> isnull(TMP.CO_MOTIVO_SUSPENSAO,0)      OR      
											 isnull(N65.DT_SUSPENSAO       ,' + CHAR(39) + '2000-01-01' + CHAR(39) + ') <> isnull(TMP.DT_SUSPENSAO,' + CHAR(39) + '2000-01-01' + CHAR(39) + ')	OR 
											 isnull(N65.CO_MOTIVO_EXCLUSAO ,0)            <> isnull(TMP.CO_MOTIVO_EXCLUSAO ,0)      OR      
											 isnull(N65.DT_EXCLUSAO        ,' + CHAR(39) + '2000-01-01' + CHAR(39) + ') <> isnull(TMP.DT_EXCLUSAO ,' + CHAR(39) + '2000-01-01' + CHAR(39) + ')
                                            )
									   )																
																		
	'

	EXEC (@sql + @SQL1)

end
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n67]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      PROCEDURE [dbo].[sp_gera_lote_n67]
as
begin

	declare @sql        nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACAO_REFERENCIA'
    declare @tipo int = 7
    declare @interface int = 3
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 
	
	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_loteINTERFACE

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete from inep_n67 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo  AND interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY
	
	set @sql ='
		SELECT  
	           LOTE_ID = 0, 
			   CRIADO_EM = DBO.GETLOCALDATE(),
			   PROJETO_ID = OUR.id_projeto,
			   our.redacao_id, 
			   our.id                 as redacaoouro_id, 
			   CO_PROJETO             = pro.codigo,
			   TP_ORIGEM              = ' + char(39) + 'F' + char(39) + ',
			   NU_CPF                 = ' + char(39) + '33820018883' + char(39) + ',       
			   CO_PROVA_OURO          = OUR.ID,   
			   TP_REFERENCIA          = OUR.id_redacaotipo,
			   DT_COMPLETA            = our.DATA_CRIACAO, 
			   CO_SITUACAO_REDACAO    = OUR.id_correcao_situacao,
			   VL_RESULTADO_AVALIADOR = OUR.nota_final,
			   VL_NOTA_COMPETENCIA_1  = OUR.nota_competencia1,
			   VL_NOTA_COMPETENCIA_2  = OUR.NOTA_competencia2,
			   VL_NOTA_COMPETENCIA_3  = OUR.NOTA_competencia3,
			   VL_NOTA_COMPETENCIA_4  = OUR.NOTA_competencia4,
			   VL_NOTA_COMPETENCIA_5  = OUR.NOTA_competencia5,
			   CO_ORIGEM_REDACAO      = our.id_origem,
			   CO_JUSTIFICATIVA       = NULL, 
			   IN_FERE_DH             = CASE WHEN OUR.ID_competencia5 = -1 THEN 1 
											 WHEN OUR.ID_competencia5 =  0 THEN 0 ELSE NULL END
			   INTO #TMP_REDOURO
			   FROM [' + @data_char + '].CORRECOES_REDACAOOURO OUR JOIN [' + @data_char + '].projeto_projeto PRO ON (OUR.id_projeto = PRO.ID)

	create index ix__TMP_REDOURO__redacao_id on #TMP_REDOURO(redacao_id)
	create index ix__TMP_REDOURO__redacaoouro_id on #TMP_REDOURO(redacaoouro_id)

	insert into inep_n67 ( LOTE_ID, REDACAO_ID, REDACAOOURO_ID, PROJETO_ID, CRIADO_EM, CO_PROJETO, TP_ORIGEM, NU_CPF, CO_PROVA_OURO, TP_REFERENCIA, 
                          DT_COMPLETA, CO_SITUACAO_REDACAO, VL_RESULTADO_AVALIADOR, VL_NOTA_COMPETENCIA_1, VL_NOTA_COMPETENCIA_2, VL_NOTA_COMPETENCIA_3, 
                          VL_NOTA_COMPETENCIA_4, VL_NOTA_COMPETENCIA_5, CO_ORIGEM_REDACAO, CO_JUSTIFICATIVA, IN_FERE_DH, status_id)
		 select lote_id = ' + convert(varchar(10), @lote_id) + ', REDACAO_ID, REDACAOOURO_ID, PROJETO_ID, CRIADO_EM, CO_PROJETO, TP_ORIGEM, NU_CPF, CO_PROVA_OURO, TP_REFERENCIA, 
                          DT_COMPLETA, CO_SITUACAO_REDACAO, VL_RESULTADO_AVALIADOR, VL_NOTA_COMPETENCIA_1, VL_NOTA_COMPETENCIA_2, VL_NOTA_COMPETENCIA_3, 
                          VL_NOTA_COMPETENCIA_4, VL_NOTA_COMPETENCIA_5, CO_ORIGEM_REDACAO, CO_JUSTIFICATIVA, IN_FERE_DH, status_id = 1
	  from #TMP_REDOURO tmp
	  where not exists(select top 1 1 from inep_n67 n67 join inep_lote lote on (n67.redacaoouro_id = tmp.redacaoouro_id and 
	                                                                            n67.redacao_id     = tmp.redacaO_id     and 
																				N67.CO_PROVA_OURO  = TMP.CO_PROVA_OURO  AND 
																				N67.CO_PROJETO     = TMP.CO_PROJETO     AND
	                                                                            lote.id = n67.lote_id and lote.status_id in (4, 2))
						 WHERE N67.CO_SITUACAO_REDACAO <> TMP.CO_SITUACAO_REDACAO OR 
						       N67.VL_RESULTADO_AVALIADOR <> TMP.VL_RESULTADO_AVALIADOR OR 
							   N67.VL_NOTA_COMPETENCIA_1  <> TMP.VL_NOTA_COMPETENCIA_1  OR 
							   N67.VL_NOTA_COMPETENCIA_2  <> TMP.VL_NOTA_COMPETENCIA_2  OR 
							   N67.VL_NOTA_COMPETENCIA_3  <> TMP.VL_NOTA_COMPETENCIA_3  OR 
							   N67.VL_NOTA_COMPETENCIA_4  <> TMP.VL_NOTA_COMPETENCIA_4  OR 
							   N67.VL_NOTA_COMPETENCIA_5  <> TMP.VL_NOTA_COMPETENCIA_5  
					  )
	'
	EXEC (@sql)

end

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n68]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      PROCEDURE [dbo].[sp_gera_lote_n68]
as
begin

	declare @sql        nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int

	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'REDACAO_REFERENCIA_CORRECAO'
    declare @tipo int = 7
    declare @interface int = 4
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 
	
	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_loteINTERFACE

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete  from inep_n68 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete  from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo AND interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY
	
	set @sql ='
		SELECT 
		   LOTE_ID = 0, 
		   PROJETO_ID = PRO.ID, 
		   CRIADO_EM  = DBO.GETLOCALDATE(), 
		   CORRECAO_ID           = COR.ID,
		   REDACAO_ID            = RED.ID,
		   CORRETOR_ID           = COR.id_corretor,
		   CO_PROJETO            = PRO.CODIGO,
		   TP_ORIGEM             = ' + CHAR(39) + 'F'  + CHAR(39) + ',
		   CO_PROVA_OURO         = ROU.id,
		   NU_CPF                = pes.cpf,
		   TP_REFERENCIA         = rou.id_redacaotipo,
		   DT_INICIO             = COR.data_inicio,
		   DT_FIM                = COR.data_termino,
		   CO_SITUACAO_REDACAO   = COR.id_correcao_situacao,
		   NU_NOTA_REDACAO       = COR.nota_final,
		   NU_NOTA_COMP1_REDACAO = COR.nota_competencia1,
		   NU_NOTA_COMP2_REDACAO = COR.nota_competencia2,
		   NU_NOTA_COMP3_REDACAO = COR.nota_competencia3,
		   NU_NOTA_COMP4_REDACAO = COR.nota_competencia4,
		   NU_NOTA_COMP5_REDACAO = COR.nota_competencia5,
		   CO_JUSTIFICATIVA      = NULL
             INTO #TMP_REDOURO     
		  FROM [' + @data_char + '].CORRECOES_REDACAO RED join [' + @data_char + '].correcoes_redacaoouro rou on (rou.id = red.id_redacaoouro)
									                      JOIN [' + @data_char + '].projeto_projeto       PRO ON (PRO.ID = RED.id_projeto)
									                      JOIN [' + @data_char + '].CORRECOES_CORRECAO    COR ON (RED.ID = COR.REDACAO_ID)
									                      JOIN [' + @data_char + '].usuarios_pessoa       pes ON (COR.id_corretor = pes.usuario_id)
		WHERE  
			  cor.id_status = 3

	create index ix__TMP_REDOURO__redacao_id on #TMP_REDOURO(redacao_id)
	create index ix__TMP_REDOURO__correcao_id on #TMP_REDOURO(correcao_id)
	create index ix__TMP_REDOURO__corretor_id on #TMP_REDOURO(corretor_id)

	insert into inep_n68 (  LOTE_ID, PROJETO_ID, CRIADO_EM, CORRECAO_ID, REDACAO_ID, CORRETOR_ID, CO_PROJETO, TP_ORIGEM, CO_PROVA_OURO, 
                           NU_CPF, TP_REFERENCIA, DT_INICIO, DT_FIM, CO_SITUACAO_REDACAO, NU_NOTA_REDACAO, NU_NOTA_COMP1_REDACAO, 
                           NU_NOTA_COMP2_REDACAO, NU_NOTA_COMP3_REDACAO, NU_NOTA_COMP4_REDACAO, NU_NOTA_COMP5_REDACAO, CO_JUSTIFICATIVA, status_id)
		 select lote_id = ' + convert(varchar(10), @lote_id) + ', PROJETO_ID, CRIADO_EM, CORRECAO_ID, REDACAO_ID, CORRETOR_ID, CO_PROJETO, TP_ORIGEM, CO_PROVA_OURO, 
                           NU_CPF, TP_REFERENCIA, DT_INICIO, DT_FIM, CO_SITUACAO_REDACAO, NU_NOTA_REDACAO, NU_NOTA_COMP1_REDACAO, 
                           NU_NOTA_COMP2_REDACAO, NU_NOTA_COMP3_REDACAO, NU_NOTA_COMP4_REDACAO, NU_NOTA_COMP5_REDACAO, CO_JUSTIFICATIVA, status_id = 1
	           
	  from #TMP_REDOURO tmp
	  where not exists(select top 1 1 from inep_n68 n68 join inep_lote lote on (n68.CO_PROVA_OURO = tmp.CO_PROVA_OURO and 
	                                                                            n68.redacao_id    = tmp.redacao_id    and 
																				N68.NU_CPF        = TMP.NU_CPF        AND 
																				N68.CO_PROJETO    = TMP.CO_PROJETO    AND
	                                                                            lote.id = n68.lote_id and lote.status_id in (4, 2))
						WHERE N68.CO_SITUACAO_REDACAO   <> TMP.CO_SITUACAO_REDACAO   OR 
						      N68.NU_NOTA_REDACAO       <> TMP.NU_NOTA_REDACAO       OR 
							  N68.NU_NOTA_COMP1_REDACAO <> TMP.NU_NOTA_COMP1_REDACAO OR 
							  N68.NU_NOTA_COMP2_REDACAO <> TMP.NU_NOTA_COMP2_REDACAO OR 
							  N68.NU_NOTA_COMP3_REDACAO <> TMP.NU_NOTA_COMP3_REDACAO OR 
							  N68.NU_NOTA_COMP4_REDACAO <> TMP.NU_NOTA_COMP4_REDACAO OR 
							  N68.NU_NOTA_COMP5_REDACAO <> TMP.NU_NOTA_COMP5_REDACAO 
					   )
	'
	exec(@sql)

end
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n69]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      PROCEDURE [dbo].[sp_gera_lote_n69]
as
begin

	declare @sql        nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int


	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'DESEMPENHO_DIARIO'
    declare @tipo int = 6
    declare @interface int = 5
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 
	
	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_loteINTERFACE

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete from inep_n69 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY
	
	set @sql ='
		select  
			   ID                   = 0,
			   LOTE_ID              = 0,
			   PROJETO_ID           = PRO.ID, 
			   USUARIO_ID           = PES.USUARIO_ID, 
			   CRIADO_EM            = DBO.GETLOCALDATE(),
			   CO_PROJETO           = PRO.codigo,
			   TP_ORIGEM            = ' + char(39) + 'F' + char(39) + ',
			   NU_CPF               = pes.cpf,
			   DT_AVALIACAO         = IND.DATA_CALCULO,
			   NU_INDICE_DESEMPENHO = IND.DSP,
			   NU_LOTE              = 999
			   INTO #TMP_DSP
			from [' + @data_char + '].correcoes_corretor_indicadores ind JOIN [' + @data_char + '].projeto_projeto    PRO ON (PRO.ID = IND.projeto_id) 
													                     JOIN [' + @data_char + '].usuarios_pessoa    pes on (ind.usuario_id = pes.usuario_id)
              where pro.id <> 7  --- *** retirando banca especial 

	create index ix__TMP_DSP__usuario_id on #TMP_DSP(usuario_id)

	insert into inep_n69 (LOTE_ID, PROJETO_ID, USUARIO_ID, CRIADO_EM, 
	                      CO_PROJETO, TP_ORIGEM, NU_CPF, DT_AVALIACAO, NU_INDICE_DESEMPENHO, NU_LOTE, status_id)
		 select lote_id = ' + convert(varchar(10), @lote_id) + ', PROJETO_ID, USUARIO_ID, CRIADO_EM, 
	                      CO_PROJETO, TP_ORIGEM, NU_CPF, DT_AVALIACAO, NU_INDICE_DESEMPENHO, NU_LOTE, status_id = 1
	           
	  from #TMP_DSP tmp
	  where not exists(select top 1 1 from inep_n69 n69 join inep_lote lote on (N69.DT_AVALIACAO = TMP.DT_AVALIACAO AND
																				N69.CO_PROJETO   = TMP.CO_PROJETO   AND 
																				N69.NU_CPF       = TMP.NU_CPF       AND 
	                                                                            lote.id = n69.lote_id and lote.status_id in (4, 2))
					     WHERE N69.NU_INDICE_DESEMPENHO <> TMP.NU_INDICE_DESEMPENHO
					   )
	'
	exec(@sql)

end
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n70]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE      PROCEDURE [dbo].[sp_gera_lote_n70]
as
begin

	declare @sql        nvarchar(max)
	declare @sql_insert nvarchar(max)

	declare @admin_user_id int
	declare @lote_id       int
	
	declare @data_char char(8) = format(dbo.getlocaldate(), 'yyyyMMdd')
	
	declare @prefixo varchar(50) = 'DESCARTADA'
    declare @tipo int = 8
    declare @interface int = 6
	
	--Copia os dados mais atualizados da correção
	-- exec sp_copia_dados -- movido para a procedure 


	--select * from inep_lotetipo
	--select * from inep_lotestatus
	--select * from inep_loteINTERFACE

	-- TESTAR SE O LOTE ESTA PENDENTE DE LIBERACAO (STATUS) E É DO TIPO AVULSO (TIPO) 
	if exists(select top 1 1 from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo and status_id = 1) begin
		delete from inep_n70 where lote_id in (select id from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo)
        delete from inep_lote where convert(date, criado_em) = convert(date, dbo.getlocaldate()) and tipo_id = @tipo  and interface_id = @interface
	end

	insert into inep_lote (nome, status_id, criado_em, tipo_id, interface_id) values (@prefixo + '_' + @data_char + '_' + convert(varchar(10),@tipo), 1, dbo.getlocaldate(), @tipo, @interface)
	set @lote_id = @@IDENTITY

	--*****************************************************************************
	DECLARE @SQL_VIEW VARCHAR(MAX)
	SET @SQL_VIEW = N'

	create OR ALTER view [' + @data_char + '].[vw_descartada_n70] as    
		select  aud.redacao_id,     
				cor.id_tipo_correcao,    
		  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and     
								  isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and    
								  isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and    
								  isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and    
								  isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and    
								  isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and    
								  aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end    
		  from [' + @data_char + '].correcoes_correcao aud join [' + @data_char + '].correcoes_correcao cor on (aud.redacao_id = cor.redacao_id and     
																	                                            aud.id_tipo_correcao = 7 ) 
	'
	EXEC(@SQL_VIEW)

	--*****************************************************************************
	
	set @sql ='			   
	select
		ID                    = 0, 
		LOTE_ID               = 0, 
		CRIADO_EM             = DBO.GETLOCALDATE(),
		REDACAO_ID            = cor.redacao_id, 
		CORRECAO_ID           = cor.id,
		CO_PROJETO            = N02.CO_PROJETO,
		CO_INSCRICAO          = RED.co_inscricao,
		SIGLA_UF              = N90.SG_UF_MUNICIPIO_PROVA,
		NU_CPF                = PES.cpf, 
		TP_TIPO_CORRECAO      = tpa.co_tipo_auditoria_n70,
		IN_DESCARTADA         = vw.descartada,
		NU_CORRECAO           = CASE WHEN cor.id_tipo_correcao IN (1,2) THEN 1 
								  WHEN cor.id_tipo_correcao = 3      THEN 3 
								  WHEN cor.id_tipo_correcao = 4      THEN 4 
								  WHEN cor.id_tipo_correcao = 7      THEN 5 ELSE 1000 END ,
		CO_SITUACAO_REDACAO   = cor.id_correcao_situacao,
		NU_NOTA_REDACAO	      = cor.nota_final,
		NU_NOTA_COMP1_REDACAO = cor.NOTA_COMPETENCIA1,
		NU_NOTA_COMP2_REDACAO = cor.NOTA_COMPETENCIA2,
		NU_NOTA_COMP3_REDACAO = cor.NOTA_COMPETENCIA3,
		NU_NOTA_COMP4_REDACAO = cor.NOTA_COMPETENCIA4,
		NU_NOTA_COMP5_REDACAO = cor.NOTA_COMPETENCIA5
		INTO #TMP_DESCARTADA
		  from [' + @data_char + '].correcoes_correcao cor join [' + @data_char + '].correcoes_correcao      aud on (cor.redacao_id = aud.redacao_id and 
																				                                     aud.id_tipo_correcao = 7)
									                       JOIN [' + @data_char + '].CORRECOES_REDACAO       RED  ON (RED.ID = AUD.redacao_id and 
									 	                    								                         RED.cancelado = 0)
									                       JOIN                      inep_N02                N02  ON (N02.CO_INSCRICAO     = RED.co_inscricao)
														   JOIN                      inep_N90                N90  ON (N90.CO_INSCRICAO     = RED.co_inscricao)
									                       JOIN [' + @data_char + '].usuarios_pessoa         PES  ON (PES.usuario_id       = AUD.id_corretor)
									                       join                      correcoes_tipoauditoria tpa  on (tpa.id               = aud.tipo_auditoria_id)
									                       join [' + @data_char + '].vw_descartada_n70       vw   on (vw.redacao_id  = cor.redacao_id and 
																					                                  vw.id_tipo_correcao  = cor.id_tipo_correcao)
           WHERE RED.CANCELADO = 0 AND RED.ID_STATUS = 4
		   
		create index ix__TMP_DESCARTADA__redacao_id on #TMP_DESCARTADA(redacao_id)

	insert into inep_n70 (LOTE_ID, CRIADO_EM, REDACAO_ID, CORRECAO_ID, CO_PROJETO, CO_INSCRICAO, SIGLA_UF, NU_CPF, TP_TIPO_CORRECAO, 
                          IN_DESCARTADA, NU_CORRECAO, CO_SITUACAO_REDACAO, NU_NOTA_REDACAO, NU_NOTA_COMP1_REDACAO, NU_NOTA_COMP2_REDACAO, 
                          NU_NOTA_COMP3_REDACAO, NU_NOTA_COMP4_REDACAO, NU_NOTA_COMP5_REDACAO, status_id)
		 select lote_id = ' + convert(varchar(10), @lote_id) + ', CRIADO_EM, REDACAO_ID, CORRECAO_ID, CO_PROJETO, CO_INSCRICAO, SIGLA_UF, NU_CPF, TP_TIPO_CORRECAO, 
                          IN_DESCARTADA, NU_CORRECAO, CO_SITUACAO_REDACAO, NU_NOTA_REDACAO, NU_NOTA_COMP1_REDACAO, NU_NOTA_COMP2_REDACAO, 
                          NU_NOTA_COMP3_REDACAO, NU_NOTA_COMP4_REDACAO, NU_NOTA_COMP5_REDACAO, status_id = 1
	  from #TMP_DESCARTADA tmp
	  where not exists(select top 1 1 from inep_n70 n70 join inep_lote lote on (n70.redacao_id = tmp.redacao_id and 
	                                                                            lote.id = n70.lote_id and lote.status_id in (4, 2))
					     WHERE N70.CO_SITUACAO_REDACAO <> TMP.CO_SITUACAO_REDACAO OR 
						       N70.NU_NOTA_REDACAO     <> TMP.NU_NOTA_REDACAO     OR 
							   N70.NU_NOTA_COMP1_REDACAO <> TMP.NU_NOTA_COMP1_REDACAO OR 
							   N70.NU_NOTA_COMP2_REDACAO <> TMP.NU_NOTA_COMP2_REDACAO OR
							   N70.NU_NOTA_COMP3_REDACAO <> TMP.NU_NOTA_COMP3_REDACAO OR
							   N70.NU_NOTA_COMP4_REDACAO <> TMP.NU_NOTA_COMP4_REDACAO OR
							   N70.NU_NOTA_COMP5_REDACAO <> TMP.NU_NOTA_COMP5_REDACAO)  
	'
	EXEC(@sql)

end
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_n59_nota_0]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_gera_n59_nota_0] @lote_id int, @co_inscricao varchar(50), @situacao int as
begin


	declare @id int

    begin tran

	insert into inep_n59 (lote_id, criado_em, tp_origem, co_inscricao, co_etapa, sg_uf_prova, nu_conceito_max_competencia1, 
                          nu_conceito_max_competencia2, nu_conceito_max_competencia3, nu_conceito_max_competencia4, nu_conceito_max_competencia5,
                          co_tipo_avaliacao, co_situacao_redacao_final,
                          projeto_id,
                          nu_nota_media_comp1, nu_nota_media_comp2, nu_nota_media_comp3, nu_nota_media_comp4, nu_nota_media_comp5, nu_nota_final,
                          co_projeto, in_divulgacao, link_imagem_recortada, status_id)
     select @lote_id, dbo.getlocaldate(), 'F', @co_inscricao, 2, n02.SG_UF_PROVA,
           200,200,200,200,200,
            case s.disability_id when 8 then 2 when 11 then 3 else 1 end as co_tipo_avaliacao, @situacao,
            case s.disability_id when 11 then 6 when 8 then 5 else 4 end as projeto_id,
            0, 0, 0, 0, 0, 0, n02.co_projeto, 0, s.processed_key, 1
       from inep_n02 n02
            left outer join subscriptions_subscription_3 s on s.enrolment_key = n02.co_inscricao
      where n02.co_inscricao = @co_inscricao

	set @id = @@IDENTITY

    --Caso exista registro da inscrição que será zerada, para os lotes pendentes de análise,
    -- a inscrição antiga é substituida, para garantir que fique apenas o registro zerado.
    update inep_n59 set status_id = 2, substituido_por = @id where co_inscricao = @co_inscricao and id <> @id



    commit

end
GO
/****** Object:  StoredProcedure [dbo].[sp_validacao_n59]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec SP_VALIDACAO_N59 '20191205'
CREATE   PROCEDURE [dbo].[sp_validacao_n59]  @schema nvarchar(50) as 
declare @sql1 nvarchar(max)
declare @sql2 nvarchar(max)

--***** 1 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (PRIMEIRA CORRECAO)
set @sql1 = 
N'select ine.redacao_id, ine.lote_id, errro = 1
from [dbo].[inep_n59] ine with(nolock) 
 where ine.lote_id in (select id from inep_lote where nome like ' + char(39) + '%' +  @schema + '%' + char(39) + ') and
       not exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
                   where ine.redacao_id = cor.redacao_id and 
				         cor.id_tipo_correcao  = 1                     and 
				         isnull(ine.nu_nota_comp1_av1,-5) = isnull(cor.nota_competencia1,-5) and 
						 isnull(ine.nu_nota_comp2_av1,-5) = isnull(cor.nota_competencia2,-5) and 
						 isnull(ine.nu_nota_comp3_av1,-5) = isnull(cor.nota_competencia3,-5) and 
						 isnull(ine.nu_nota_comp4_av1,-5) = isnull(cor.nota_competencia4,-5) and 
						 isnull(ine.nu_nota_comp5_av1,-5) = isnull(cor.nota_competencia5,-5) and 
						 isnull(      ine.nu_nota_av1,-5) = isnull(cor.nota_final,-5       ) AND 
						 ISNULL(     ine.nu_tempo_av1,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )
					)       AND
	ine.nu_cpf_av1 IS NOT NULL 
	  
UNION 
--***** 2 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (SEGUNDA CORRECAO)
select ine.redacao_id, ine.lote_id, errro = 2
from [dbo].[inep_n59] ine with(nolock) 
 where ine.lote_id in (select id from inep_lote where nome like ' + char(39) + '%' +  @schema + '%' + char(39) + ') and
       NOT exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
                   where ine.redacao_id = cor.redacao_id and 
				         cor.id_tipo_correcao  = 2                     and 
				         isnull(ine.nu_nota_comp1_av2,-5) = isnull(cor.nota_competencia1,-5) and 
						 isnull(ine.nu_nota_comp2_av2,-5) = isnull(cor.nota_competencia2,-5) and 
						 isnull(ine.nu_nota_comp3_av2,-5) = isnull(cor.nota_competencia3,-5) and 
						 isnull(ine.nu_nota_comp4_av2,-5) = isnull(cor.nota_competencia4,-5) and 
						 isnull(ine.nu_nota_comp5_av2,-5) = isnull(cor.nota_competencia5,-5) and 
						 isnull(      ine.nu_nota_av2,-5) = isnull(       cor.nota_final,-5) AND 
						 ISNULL(     ine.nu_tempo_av2,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )) AND 
	ine.nu_cpf_av2 IS NOT NULL
						  
UNION 
--***** 3 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (TERCEIRA CORRECAO)
select ine.redacao_id, ine.lote_id, errro = 3
from [dbo].[inep_n59] ine with(nolock) 
 where ine.lote_id in (select id from inep_lote where nome like ' + char(39) + '%' +  @schema + '%' + char(39) + ') and
       NOT exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
                   where ine.redacao_id = cor.redacao_id and 
				         cor.id_tipo_correcao  = 3                     and 
				         isnull(ine.nu_nota_comp1_av3,-5) = isnull(cor.nota_competencia1,-5) and 
						 isnull(ine.nu_nota_comp2_av3,-5) = isnull(cor.nota_competencia2,-5) and 
						 isnull(ine.nu_nota_comp3_av3,-5) = isnull(cor.nota_competencia3,-5) and 
						 isnull(ine.nu_nota_comp4_av3,-5) = isnull(cor.nota_competencia4,-5) and 
						 isnull(ine.nu_nota_comp5_av3,-5) = isnull(cor.nota_competencia5,-5) and 
						 isnull(      ine.nu_nota_av3,-5) = isnull(       cor.nota_final,-5) AND 
						 ISNULL(     ine.nu_tempo_av3,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )) AND
	ine.nu_cpf_av3 IS NOT NULL '

set @sql2 = 							  
N' UNION 
--***** 4 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (REDACAO NOTAFINAL)
select ine.redacao_id, ine.lote_id, errro = 4
from [dbo].[inep_n59] ine with(nolock) 
 where ine.lote_id in (select id from inep_lote where nome like ' + char(39) + '%' +  @schema + '%' + char(39) + ') and
       NOT exists(select 1 from [' + @schema + '].[correcoes_REDACAO] RED 
                   where ine.redacao_id = RED.id and 
				         isnull(ine.nu_nota_media_comp1,-5) = isnull(RED.nota_competencia1,-5) and 
						 isnull(ine.nu_nota_media_comp2,-5) = isnull(RED.nota_competencia2,-5) and 
						 isnull(ine.nu_nota_media_comp3,-5) = isnull(RED.nota_competencia3,-5) and 
						 isnull(ine.nu_nota_media_comp4,-5) = isnull(RED.nota_competencia4,-5) and 
						 isnull(ine.nu_nota_media_comp5,-5) = isnull(RED.nota_competencia5,-5) and 
						 isnull(      ine.nu_nota_FINAL,-5) = isnull(       RED.nota_final,-5)
				 )and
		 ine.co_situacao_redacao_final not in (4,8)


union 
-- ****** 5 - VERIFICAM SE AS A NOTA FINAL DA REDACAO E IGUAL A NOTA DA TERCEIRA (ABSOLUTA) 
-- ****** VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A MEDIA DA PRIMEIRA COM A SEGUNDA E NAO TEM TERCEIRA
-- ****** VERFICA SE TEM NOTA FINAL E NAO POSSUI PRIMEIRA OU SEGUNDA
select ine.redacao_id, ine.lote_id, errro = 5 --, COR3.ID, COR2.ID, COR1.ID, ine.nu_nota_final, ine.nu_nota_av1,  ine.nu_nota_av2,  ine.nu_nota_av3, diferenca = ABS(ine.nu_nota_av1- ine.nu_nota_av2)
from [dbo].[inep_n59] ine with(nolock) LEFT JOIN [' + @schema + '].[correcoes_correcao] cor1 WITH(NOLOCK) ON (COR1.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR1.ID_TIPO_CORRECAO = 1 AND 
																									   COR1.ID_STATUS = 3)
									   LEFT JOIN [' + @schema + '].[correcoes_correcao] cor2 WITH(NOLOCK) ON (COR2.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR2.ID_TIPO_CORRECAO = 2 AND 
																									   COR2.ID_STATUS = 3)
									   LEFT JOIN [' + @schema + '].[correcoes_correcao] cor3 WITH(NOLOCK) ON (COR3.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR3.ID_TIPO_CORRECAO = 3 AND 
																									   COR3.ID_STATUS = 3)
  WHERE ine.lote_id in (select id from inep_lote where nome like ' + char(39) + '%' +  @schema + '%' + char(39) + ') and 
        ( ine.nu_nota_final IS NULL OR  
         ((COR3.ID IS NOT NULL AND  cor3.NOTA_FINAL <> ine.nu_nota_final) OR -- SE TIVER TERCEIRA A NOTA FINAL TEM QUE SER IGUAL 
		  (COR3.ID IS NULL AND COR2.ID IS NOT NULL AND COR1.ID IS NOT NULL AND ine.nu_nota_final <> ((COR2.NOTA_FINAL + COR1.NOTA_FINAL)/2)) OR -- SE SO TIVER PRIMEIRA E SEGUDA A NOTA FINAL TEM QUE SER A MEDIA
		  ((COR2.ID IS NULL OR COR1.ID IS NULL) AND ine.nu_nota_final IS NOT NULL)
		 )) and 
		 ine.co_situacao_redacao_final not in (4,8)

union 
-- ****** 6 - VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A NOTA FINAL DO ARQUIVO N59
-- ****** VERIFICA SE A NOTA DE CADA COMPETENCIA DA REDACAO E IGUAL A NOTA DE CADA COMPETENCIA DO ARQUIVO N59

select ine.redacao_id, ine.lote_id, errro = 6
from [dbo].[inep_n59] ine with(nolock) LEFT JOIN [' + @schema + '].[correcoes_redacao] red WITH(NOLOCK) ON (red.id = ine.redacao_id )
  WHERE ine.lote_id in (select id from inep_lote where nome like ' + char(39) + '%' +  @schema + '%' + char(39) + ') and 
        (ine.nu_nota_final      <> red.nota_final        or  
		ine.nu_nota_media_comp1 <> red.nota_competencia1 or  
		ine.nu_nota_media_comp2 <> red.nota_competencia2 or  
		ine.nu_nota_media_comp3 <> red.nota_competencia3 or  
		ine.nu_nota_media_comp4 <> red.nota_competencia4 or  
		ine.nu_nota_media_comp5 <> red.nota_competencia5)  '

 print @sql1
 print @sql2

--execute (@sql1 + @sql2 )
GO
/****** Object:  StoredProcedure [dbo].[sp_validacao_n59_ENEM]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec sp_validacao_n59_ENEM '20191205',93
CREATE     PROCEDURE [dbo].[sp_validacao_n59_ENEM]  @schema nvarchar(50), @LOTE INT as 
declare @sql0 nvarchar(max)
declare @sql1 nvarchar(max)
declare @sql2 nvarchar(max)
declare @sql3 nvarchar(max)
declare @sql4 nvarchar(max) 
declare @sql5 nvarchar(max)
declare @sql6 nvarchar(max)
declare @sql7 nvarchar(max) 
declare @sql8 nvarchar(max) 
declare @sql9 nvarchar(max) 
declare @sql10 nvarchar(max) 
declare @sql11 nvarchar(max) 
declare @sqlfinal nvarchar(max) 
declare @sqlVIEW nvarchar(max) 

IF(EXISTS (SELECT * FROM inep_lote WHERE STATUS_ID = 8 AND ID = @LOTE ))

	BEGIN 
	
		-- ****  CRIAR VIEWS NO SQUEMA CORRENTE
		SET @sqlVIEW = N' SP_CRIAR_VIEW_REDACAO_EQUIDISTANTE ' + CHAR(39) + @schema + CHAR(39) 
		EXEC (@sqlVIEW)

		SET @sqlVIEW = N' SP_CRIAR_VIEW_VALIDACAO_AUDITORIA ' + CHAR(39) + @schema + CHAR(39) 
		EXEC (@sqlVIEW)
		-- **** CRIAR VIEWS NO SQUEMA CORRENTE - FIM 


		set @sql0 = N'  if (object_id(' + char(39) + 'tempdb..#temp' + char(39) + ') is not null)   drop table #temp
					   select * into #temp from ( '


		set @sql1 = N'
		--***** 1 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (PRIMEIRA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 1
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and
			   not exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
						   where ine.redacao_id = cor.redacao_id and 
								 cor.id_tipo_correcao  = 1                     and 
								 isnull(ine.nu_nota_comp1_av1,-5) = isnull(cor.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_comp2_av1,-5) = isnull(cor.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_comp3_av1,-5) = isnull(cor.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_comp4_av1,-5) = isnull(cor.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_comp5_av1,-5) = isnull(cor.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_av1,-5) = isnull(cor.nota_final,-5       ) AND 
								 ISNULL(     ine.nu_tempo_av1,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )
							)       AND
			ine.nu_cpf_av1 IS NOT NULL '

		SET @sql2 = N'
	  
		UNION 
		--***** 2 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (SEGUNDA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 2
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and
			   NOT exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
						   where ine.redacao_id = cor.redacao_id and 
								 cor.id_tipo_correcao  = 2                     and 
								 isnull(ine.nu_nota_comp1_av2,-5) = isnull(cor.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_comp2_av2,-5) = isnull(cor.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_comp3_av2,-5) = isnull(cor.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_comp4_av2,-5) = isnull(cor.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_comp5_av2,-5) = isnull(cor.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_av2,-5) = isnull(       cor.nota_final,-5) AND 
								 ISNULL(     ine.nu_tempo_av2,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )) AND 
			ine.nu_cpf_av2 IS NOT NULL '

		SET @sql3 = N'
						  
		UNION 
		--***** 3 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (TERCEIRA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, erro = 3 
		  from inep_n59 ine
		where ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and
			  ine.nu_cpf_av1 is not null and 
			  ine.nu_cpf_av2 is not null and 
			  ine.nu_cpf_av3 is not null and 
			  ine.nu_cpf_av4 is null     and 
			  ine.nu_cpf_auditor is null and
			   exists (select 1                   
							  from [' + @schema + '].correcoes_correcao cor1 join [' + @schema + '].correcoes_correcao cor2 on (cor1.redacao_id = cor2.redacao_id and cor1.id_tipo_correcao = 1  and cor2.id_tipo_correcao = 2) 
																			 join [' + @schema + '].correcoes_correcao cor3 on (cor1.redacao_id = cor3.redacao_id and cor3.id_tipo_correcao = 3)
																	   left  join [' + @schema + '].correcoes_analise  ana13 on (cor1.id = ana13.id_correcao_a and cor3.id = ana13.id_correcao_B and ana13.redacao_id = cor1.redacao_id and ana13.aproveitamento = 1)
																	   left  join [' + @schema + '].correcoes_analise  ana23 on (cor2.id = ana23.id_correcao_a and cor3.id = ana23.id_correcao_B and ana23.redacao_id = cor2.redacao_id and ana23.aproveitamento = 1)
							where cor1.redacao_id = ine.redacao_id and   
								  (ine.nu_nota_final <> case when ana13.aproveitamento = 1 then abs(cor1.nota_final + cor3.nota_final)/2
															 when ana23.aproveitamento = 1 then abs(cor2.nota_final + cor3.nota_final)/2 else null end or 
								   ine.nu_nota_media_comp1 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia1 + cor3.nota_competencia1)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia1 + cor3.nota_competencia1)/2  end or
								   ine.nu_nota_media_comp2 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia2 + cor3.nota_competencia2)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia2 + cor3.nota_competencia2)/2  end or
								   ine.nu_nota_media_comp3 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia3 + cor3.nota_competencia3)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia3 + cor3.nota_competencia3)/2  end or
								   ine.nu_nota_media_comp4 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia4 + cor3.nota_competencia4)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia4 + cor3.nota_competencia4)/2  end or
								   ine.nu_nota_media_comp5 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia5 + cor3.nota_competencia5)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia5 + cor3.nota_competencia5)/2  end 
								  )
			) '

		set @sql4 = 							  
		N' UNION 
		--***** 4 -- VERIFICACAO SEGUNDA -- VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (REDACAO NOTAFINAL)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 4
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and
			   NOT exists(select 1 from [' + @schema + '].[correcoes_REDACAO] RED 
						   where ine.redacao_id = RED.id and 
								 isnull(ine.nu_nota_media_comp1,-5) = isnull(RED.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_media_comp2,-5) = isnull(RED.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_media_comp3,-5) = isnull(RED.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_media_comp4,-5) = isnull(RED.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_media_comp5,-5) = isnull(RED.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_FINAL,-5) = isnull(       RED.nota_final,-5)
						 )and
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql5 = N'
		union 
		-- ****** 5 - VERIFICACAO TERCEIRA -- VERIFICAM SE AS A NOTA FINAL DA REDACAO E IGUAL A NOTA DA TERCEIRA (ABSOLUTA) 
		-- ****** VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A MEDIA DA PRIMEIRA COM A SEGUNDA E NAO TEM TERCEIRA
		-- ****** VERFICA SE TEM NOTA FINAL E NAO POSSUI PRIMEIRA OU SEGUNDA
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 5
		from [dbo].[inep_n59] ine with(nolock) left join [' + @schema + '].[correcoes_redacao]       red  WITH(NOLOCK) ON (red.id = ine.redacao_id)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor1 WITH(NOLOCK) ON (COR1.REDACAO_ID = ine.redacao_id AND 
																													COR1.ID_TIPO_CORRECAO = 1 AND 
																				  	   								COR1.ID_STATUS = 3)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor2 WITH(NOLOCK) ON (COR2.REDACAO_ID = ine.redacao_id AND 
																													COR2.ID_TIPO_CORRECAO = 2 AND 
																				  	   								COR2.ID_STATUS = 3)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor3 WITH(NOLOCK) ON (COR3.REDACAO_ID = ine.redacao_id AND 
																													COR3.ID_TIPO_CORRECAO = 3 AND 
																				  	   								COR3.ID_STATUS = 3)
											   left join [' + @schema + '].[correcoes_correcao]      cor4 WITH(NOLOCK) ON (COR4.REDACAO_ID = ine.redacao_id AND 
																													COR4.ID_TIPO_CORRECAO = 4)
											   left join [' + @schema + '].[correcoes_correcao]      corA WITH(NOLOCK) ON (corA.REDACAO_ID = ine.redacao_id AND 
																													corA.ID_TIPO_CORRECAO = 7)
											  left join  [' + @schema + '].[vw_redacao_equidistante] equ  with(nolock) on (equ.redacao_id = ine.redacao_id)
		  WHERE  ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and          
				 ine.nu_cpf_av3 is not null and 
				 ine.nu_cpf_av1 is not null and 
				 ine.nu_cpf_av2 is not null and 
				 ine.nu_cpf_av4 is null     and
				 ine.nu_cpf_auditor is null and 

				 -- *** PRA FECHAR NA TERCEIRA NAO PODE EXISTIR QUARTA, AUDITORIA E NEM SER EQUIDISTANTE
				 (	(cor4.id is not null) or 
					(corA.id is not null) or 
					(equ.redacao_id is not  null ) or 

					-- *** VERIFICAR NOTA FINAL DA REDACAO
					(ine.nu_nota_final <> red.nota_final) or 
			
					-- *** VERIFICAR NOTAS DA PRIMEIRA CORRECAO
					(ine.nu_nota_comp1_av1 <> cor1.nota_competencia1 or 
					 ine.nu_nota_comp2_av1 <> cor1.nota_competencia2 or 
					 ine.nu_nota_comp3_av1 <> cor1.nota_competencia3 or 
					 ine.nu_nota_comp4_av1 <> cor1.nota_competencia4 or 
					 ine.nu_nota_comp5_av1 <> cor1.nota_competencia5)or 
             
					-- *** VERIFICAR NOTAS DA SEGUNDA CORRECAO
					(ine.nu_nota_comp1_av2 <> cor2.nota_competencia1 or 
					 ine.nu_nota_comp2_av2 <> cor2.nota_competencia2 or 
					 ine.nu_nota_comp3_av2 <> cor2.nota_competencia3 or 
					 ine.nu_nota_comp4_av2 <> cor2.nota_competencia4 or
					 ine.nu_nota_comp5_av2 <> cor2.nota_competencia5) or
			  
					-- *** VERIFICAR NOTAS DA TERCEIRA CORRECAO
					(ine.nu_nota_comp1_av3 <> cor3.nota_competencia1 or 
					 ine.nu_nota_comp2_av3 <> cor3.nota_competencia2 or 
					 ine.nu_nota_comp3_av3 <> cor3.nota_competencia3 or 
					 ine.nu_nota_comp4_av3 <> cor3.nota_competencia4 or 
					 ine.nu_nota_comp5_av3 <> cor3.nota_competencia5)  OR  
			 
					-- *** VERIFICAR SITUACAO
					(ine.co_situacao_redacao_final <> red.id_correcao_situacao) or  
					(red.id_correcao_situacao <> cor1.id_correcao_situacao and 
					 red.id_correcao_situacao <> cor2.id_correcao_situacao)  
				 )

				 AND 
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql6 = N' union
		-- ****** 6 - VERIFICACAO DE QUARTA --  VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A NOTA FINAL DO ARQUIVO N59
		-- ****** VERIFICA SE A NOTA DE CADA COMPETENCIA DA REDACAO E IGUAL A NOTA DE CADA COMPETENCIA DO ARQUIVO N59
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 6 
		from [dbo].[inep_n59] ine with(nolock) 
										 left join [' + @schema + '].[correcoes_redacao]  red  WITH(NOLOCK) ON (red.id = ine.redacao_id)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor1 WITH(NOLOCK) ON (COR1.REDACAO_ID = ine.redacao_id AND COR1.ID_TIPO_CORRECAO = 1 AND COR1.ID_STATUS = 3)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor2 WITH(NOLOCK) ON (COR2.REDACAO_ID = ine.redacao_id AND COR2.ID_TIPO_CORRECAO = 2 AND COR2.ID_STATUS = 3)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor3 WITH(NOLOCK) ON (COR3.REDACAO_ID = ine.redacao_id AND COR3.ID_TIPO_CORRECAO = 3 AND COR3.ID_STATUS = 3)
										 left join [' + @schema + '].[correcoes_correcao] cor4 WITH(NOLOCK) ON (COR4.REDACAO_ID = ine.redacao_id AND COR4.ID_TIPO_CORRECAO = 4)
										 left join [' + @schema + '].[correcoes_correcao] corA WITH(NOLOCK) ON (corA.REDACAO_ID = ine.redacao_id AND corA.ID_TIPO_CORRECAO = 7)
										 left join [' + @schema + '].[vw_redacao_equidistante] equ  with(nolock) on (equ.redacao_id = ine.redacao_id)
		  WHERE  ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and               
				 ine.nu_cpf_av3 is not null and
				 ine.nu_cpf_av1 is not null and
				 ine.nu_cpf_av2 is not null and
				 ine.nu_cpf_av4 is not null and
				 ine.nu_cpf_auditor is null and		  
				 -- *** PRA FECHAR NA QUARTA NAO PODE EXISTIR AUDITORIA 
				 (	( corA.id is not null) or 			
					-- *** VERIFICAR NOTA FINAL DA REDACAO
					(ine.nu_nota_final <> red.nota_final) or 			
					-- *** VERIFICAR NOTAS DA PRIMEIRA CORRECAO
					(ine.nu_nota_comp1_av1 <> cor1.nota_competencia1 or 
					 ine.nu_nota_comp2_av1 <> cor1.nota_competencia2 or 
					 ine.nu_nota_comp3_av1 <> cor1.nota_competencia3 or 
					 ine.nu_nota_comp4_av1 <> cor1.nota_competencia4 or 
					 ine.nu_nota_comp5_av1 <> cor1.nota_competencia5)or 
					-- *** VERIFICAR NOTAS DA SEGUNDA CORRECAO
					(ine.nu_nota_comp1_av2 <> cor2.nota_competencia1 or 
					 ine.nu_nota_comp2_av2 <> cor2.nota_competencia2 or 
					 ine.nu_nota_comp3_av2 <> cor2.nota_competencia3 or 
					 ine.nu_nota_comp4_av2 <> cor2.nota_competencia4 or
					 ine.nu_nota_comp5_av2 <> cor2.nota_competencia5) or			  
					-- *** VERIFICAR NOTAS DA TERCEIRA CORRECAO
					(ine.nu_nota_comp1_av3 <> cor3.nota_competencia1 or 
					 ine.nu_nota_comp2_av3 <> cor3.nota_competencia2 or 
					 ine.nu_nota_comp3_av3 <> cor3.nota_competencia3 or 
					 ine.nu_nota_comp4_av3 <> cor3.nota_competencia4 or 
					 ine.nu_nota_comp5_av3 <> cor3.nota_competencia5) or  			  
					-- *** VERIFICAR NOTAS DA QUARTA CORRECAO
					(ine.nu_nota_comp1_av4 <> cor4.nota_competencia1 or 
					 ine.nu_nota_comp2_av4 <> cor4.nota_competencia2 or 
					 ine.nu_nota_comp3_av4 <> cor4.nota_competencia3 or 
					 ine.nu_nota_comp4_av4 <> cor4.nota_competencia4 or 
					 ine.nu_nota_comp5_av4 <> cor4.nota_competencia5) or 
					 -- *** VERIFICAR SITUACAO
					(ine.co_situacao_redacao_final <> red.id_correcao_situacao) OR 
					(ine.nu_nota_final <> COR4.NOTA_FINAL) AND 
					(ine.co_situacao_redacao_final <> COR4.id_correcao_situacao) OR 
					(INE.co_situacao_redacao_final = 1 AND INE.nu_nota_final = 0)
				 ) AND 
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql7 = N'
		union 
		-- ****** 7 - VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A NOTA FINAL DO ARQUIVO N59
		-- ****** VERIFICA SE A NOTA DE CADA COMPETENCIA DA REDACAO E IGUAL A NOTA DE CADA COMPETENCIA DO ARQUIVO N59

		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 7
		from [dbo].[inep_n59] ine with(nolock) LEFT JOIN [' + @schema + '].[correcoes_redacao] red WITH(NOLOCK) ON (red.id = ine.redacao_id )
		  WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and 
				 ine.nu_cpf_auditor is not null and	 
				(ine.nu_nota_final      <> red.nota_final        or  
				ine.nu_nota_media_comp1 <> red.nota_competencia1 or  
				ine.nu_nota_media_comp2 <> red.nota_competencia2 or  
				ine.nu_nota_media_comp3 <> red.nota_competencia3 or  
				ine.nu_nota_media_comp4 <> red.nota_competencia4 or  
				ine.nu_nota_media_comp5 <> red.nota_competencia5)  '

	SET @sql8 = N'
		union 
		-- ****** 8 - SE NO ARQUIVO DO INEP_N59 AS SEGUNDAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 8
		FROM INEP_N59 INE JOIN inep_lote LOT ON (INE.LOTE_ID = LOT.ID)
		WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  
				INE.nu_cpf_av1 IS NOT NULL AND 
				INE.nu_cpf_av2 IS NOT NULL AND
				INE.nu_cpf_av3 IS NULL AND 
				INE.nu_cpf_av4 IS NULL AND 
				INE.nu_cpf_auditor IS NULL  AND 

				( ABS(INE.nu_nota_av1 - NU_NOTA_AV2) > 100 OR 
				ABS(INE.nu_nota_comp1_av1 - INE.nu_nota_comp1_av2) > 80 OR 
				ABS(INE.nu_nota_comp2_av1 - INE.nu_nota_comp2_av2) > 80 OR 
				ABS(INE.nu_nota_comp3_av1 - INE.nu_nota_comp3_av2) > 80 OR 
				ABS(INE.nu_nota_comp4_av1 - INE.nu_nota_comp4_av2) > 80 OR 
				ABS(INE.nu_nota_comp5_av1 - INE.nu_nota_comp5_av2) > 80 
			)  '

	SET @sql9 = N'
		union 
		-- ****** 9 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 9
		FROM INEP_N59 INE JOIN inep_lote LOT ON (INE.LOTE_ID = LOT.ID)
		WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  
				INE.nu_cpf_av1 IS NOT NULL AND 
				INE.nu_cpf_av2 IS NOT NULL AND
				INE.nu_cpf_av3 IS NOT NULL AND 
				INE.nu_cpf_av4 IS NULL AND 
				INE.nu_cpf_auditor IS NULL  AND 

			(  (ABS(INE.nu_nota_av1 - NU_NOTA_AV3) > 100  AND ABS(INE.nu_nota_av2 - NU_NOTA_AV3) > 100)  OR 
				(ABS(INE.nu_nota_comp1_av1 - INE.nu_nota_comp1_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp2_av1 - INE.nu_nota_comp2_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp3_av1 - INE.nu_nota_comp3_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp4_av1 - INE.nu_nota_comp4_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp5_av1 - INE.nu_nota_comp5_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR
				(INE.co_situacao_redacao_av1 <> INE.co_situacao_redacao_av3  AND INE.co_situacao_redacao_av2 <> co_situacao_redacao_av3)
			)  '

	SET @sql10 = N'
		union 		
		-- ****** 10 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 10
		FROM INEP_N59 INE JOIN inep_lote LOT ON (INE.LOTE_ID = LOT.ID)
		WHERE   ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and 
		        lot.status_id = 4 and 
				exists (
					select 1 from vw_conferencia_nota_avaliador con 
					  where con.redacao_id = ine.redacao_id and 
					        con.lote_id    = ine.lote_id
				)  '

	SET @sql11 = N'
		union 		
		-- ****** 11 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT N59.redacao_id, N59.lote_id, N59.projeto_id, ERRRO = 11
		from inep_n59 n59 join inep_lote lot on (n59.lote_id = lot.id)
	                    JOIN [' + @schema + '].CORRECOES_REDACAO       RED ON (RED.ID = N59.redacao_id AND 
						                                                RED.id_projeto = N59.projeto_id)
	               LEFT JOIN [' + @schema + '].CORRECOES_CORRECAO      COR ON (COR.redacao_id = N59.redacao_id AND 
				                                                        COR.id_projeto = N59.projeto_id AND 
																		COR.id_tipo_correcao = 7) 
                   LEFT join [' + @schema + '].VW_VALIDACAO_AUDITORIA  aud on (n59.redacao_id = aud.redacao_id and 
                                                                        n59.projeto_id = aud.projeto_id)
     where lot.status_id in (2,4) and
           n59.nu_cpf_auditor is not null and 
	        N59.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  
			(AUD.REDACAO_ID IS NOT NULL  OR 
				(
					(	(N59.nu_cpf_av3 = N59.nu_cpf_auditor AND N59.nu_cpf_av4 IS NULL AND 
							(ISNULL(N59.nu_nota_comp1_av3,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_comp2_av3,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_comp3_av3,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_comp4_av3,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_comp5_av3,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_av3,-5)       <> ISNULL(RED.nota_final,0)
							)
						) OR 
						(N59.nu_cpf_av3 IS NOT NULL AND N59.nu_cpf_av4 = N59.NU_CPF_AUDITOR AND 
							(ISNULL(N59.nu_nota_comp1_av4,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_comp2_av4,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_comp3_av4,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_comp4_av4,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_comp5_av4,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_av4,-5)       <> ISNULL(RED.nota_final,0)
							)
						) OR 
						(N59.nu_cpf_av4 IS NOT NULL AND N59.nu_cpf_av4 <> N59.NU_CPF_AUDITOR AND 
							(ISNULL(N59.nu_nota_media_comp1,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_media_comp2,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_media_comp3,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_media_comp4,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_media_comp5,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_final,-5)       <> ISNULL(RED.nota_final,0)
							)
						)
					)
				)
			)  '


		set @sqlfinal = N' ) as tab

		        IF EXISTS( select TOP 1 1 from #temp) 
					BEGIN
					   UPDATE INEP_LOTE SET STATUS_ID = 3
					   WHERE ID = ' + CONVERT(VARCHAR(10), @LOTE) + '
					END
				ELSE 
					BEGIN 
					   UPDATE INEP_LOTE SET STATUS_ID = 9
					   WHERE ID = ' + CONVERT(VARCHAR(10), @LOTE)  + '
					END '


		 --print @sql0
		 --print @sql1
		 --print @sql2
		 --PRINT @SQL3
		 --PRINT @SQL4
		 --print @sql5
		 --PRINT @SQL6
		 --PRINT @SQL7
		 --PRINT @SQL8
		 --PRINT @SQL9
		 --PRINT @SQL10
		 --PRINT @SQL11
		 --print @sqlfinal 

		 EXEC (@sql0 +@sql1 +@sql2 +@SQL3 +@SQL4 +@sql5 +@SQL6 +@SQL7 +@SQL8 +@SQL9 +@SQL10 +@SQL11 +@sqlfinal)
	END
ELSE 
	BEGIN
		PRINT 'ESTE LOTE NAO ESTA DISPONIVEL PARA CONSISTENCIA'
	END

GO
/****** Object:  StoredProcedure [dbo].[sp_validacao_n59_ENEM_AUX]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SELECT * FROM INEP_LOTE WHERE ID = 123

-- exec sp_validacao_n59_ENEM_AUX '20191231',123
CREATE     PROCEDURE [dbo].[sp_validacao_n59_ENEM_AUX]  @schema nvarchar(50), @LOTE INT as 
declare @sql0 nvarchar(max)
declare @sql1 nvarchar(max)
declare @sql2 nvarchar(max)
declare @sql3 nvarchar(max)
declare @sql4 nvarchar(max) 
declare @sql5 nvarchar(max)
declare @sql6 nvarchar(max)
declare @sql7 nvarchar(max) 
declare @sql8 nvarchar(max) 
declare @sql9 nvarchar(max) 
declare @sql10 nvarchar(max) 
declare @sql11 nvarchar(max) 
declare @sqlfinal nvarchar(max) 
declare @sqlVIEW nvarchar(max) 

IF(EXISTS (SELECT * FROM inep_lote WHERE STATUS_ID IN (4) AND ID = @LOTE ))

	BEGIN 
	
		-- ****  CRIAR VIEWS NO SQUEMA CORRENTE
		SET @sqlVIEW = N' SP_CRIAR_VIEW_REDACAO_EQUIDISTANTE ' + CHAR(39) + @schema + CHAR(39) 
		EXEC (@sqlVIEW)

		SET @sqlVIEW = N' SP_CRIAR_VIEW_VALIDACAO_AUDITORIA ' + CHAR(39) + @schema + CHAR(39) 
		EXEC (@sqlVIEW)
		-- **** CRIAR VIEWS NO SQUEMA CORRENTE - FIM 


		set @sql0 = N'  if (object_id(' + char(39) + 'tempdb..#temp' + char(39) + ') is not null)   drop table #temp
					   select * into #temp from ( '


		set @sql1 = N'
		--***** 1 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (PRIMEIRA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 1
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and INE.status_id = 1 AND
			   not exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
						   where ine.redacao_id = cor.redacao_id and 
								 cor.id_tipo_correcao  = 1                     and 
								 isnull(ine.nu_nota_comp1_av1,-5) = isnull(cor.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_comp2_av1,-5) = isnull(cor.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_comp3_av1,-5) = isnull(cor.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_comp4_av1,-5) = isnull(cor.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_comp5_av1,-5) = isnull(cor.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_av1,-5) = isnull(cor.nota_final,-5       ) AND 
								 ISNULL(     ine.nu_tempo_av1,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )
							)       AND
			ine.nu_cpf_av1 IS NOT NULL '

		SET @sql2 = N'
	  
		UNION 
		--***** 2 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (SEGUNDA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 2
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and INE.status_id = 1 AND
			   NOT exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
						   where ine.redacao_id = cor.redacao_id and 
								 cor.id_tipo_correcao  = 2                     and 
								 isnull(ine.nu_nota_comp1_av2,-5) = isnull(cor.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_comp2_av2,-5) = isnull(cor.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_comp3_av2,-5) = isnull(cor.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_comp4_av2,-5) = isnull(cor.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_comp5_av2,-5) = isnull(cor.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_av2,-5) = isnull(       cor.nota_final,-5) AND 
								 ISNULL(     ine.nu_tempo_av2,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )) AND 
			ine.nu_cpf_av2 IS NOT NULL '

		SET @sql3 = N'
						  
		UNION 
		--***** 3 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (TERCEIRA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, erro = 3 
		  from inep_n59 ine with(nolock) 
		where ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and INE.status_id = 1 AND
			  ine.nu_cpf_av1 is not null and 
			  ine.nu_cpf_av2 is not null and 
			  ine.nu_cpf_av3 is not null and 
			  ine.nu_cpf_av4 is null     and 
			  ine.nu_cpf_auditor is null and
			   exists (select 1                   
							  from [' + @schema + '].correcoes_correcao cor1 join [' + @schema + '].correcoes_correcao cor2   with(nolock) on (cor1.redacao_id = cor2.redacao_id and cor1.id_tipo_correcao = 1  and cor2.id_tipo_correcao = 2) 
																			 join [' + @schema + '].correcoes_correcao cor3   with(nolock) on (cor1.redacao_id = cor3.redacao_id and cor3.id_tipo_correcao = 3)
																	   left  join [' + @schema + '].correcoes_analise  ana13  with(nolock) on (cor1.id = ana13.id_correcao_a and cor3.id = ana13.id_correcao_B and ana13.redacao_id = cor1.redacao_id and ana13.aproveitamento = 1)
																	   left  join [' + @schema + '].correcoes_analise  ana23  with(nolock) on (cor2.id = ana23.id_correcao_a and cor3.id = ana23.id_correcao_B and ana23.redacao_id = cor2.redacao_id and ana23.aproveitamento = 1)
							where cor1.redacao_id = ine.redacao_id and   
								  (ine.nu_nota_final <> case when ana13.aproveitamento = 1 then abs(cor1.nota_final + cor3.nota_final)/2
															 when ana23.aproveitamento = 1 then abs(cor2.nota_final + cor3.nota_final)/2 else null end or 
								   ine.nu_nota_media_comp1 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia1 + cor3.nota_competencia1)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia1 + cor3.nota_competencia1)/2  end or
								   ine.nu_nota_media_comp2 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia2 + cor3.nota_competencia2)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia2 + cor3.nota_competencia2)/2  end or
								   ine.nu_nota_media_comp3 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia3 + cor3.nota_competencia3)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia3 + cor3.nota_competencia3)/2  end or
								   ine.nu_nota_media_comp4 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia4 + cor3.nota_competencia4)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia4 + cor3.nota_competencia4)/2  end or
								   ine.nu_nota_media_comp5 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia5 + cor3.nota_competencia5)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia5 + cor3.nota_competencia5)/2  end 
								  )
			) '

		set @sql4 = 							  
		N' UNION 
		--***** 4 -- VERIFICACAO SEGUNDA -- VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (REDACAO NOTAFINAL)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 4
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and INE.status_id = 1 AND
			   NOT exists(select 1 from [' + @schema + '].[correcoes_REDACAO] RED 
						   where ine.redacao_id = RED.id and 
								 isnull(ine.nu_nota_media_comp1,-5) = isnull(RED.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_media_comp2,-5) = isnull(RED.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_media_comp3,-5) = isnull(RED.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_media_comp4,-5) = isnull(RED.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_media_comp5,-5) = isnull(RED.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_FINAL,-5) = isnull(       RED.nota_final,-5)
						 )and
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql5 = N'
		union 
		-- ****** 5 - VERIFICACAO TERCEIRA -- VERIFICAM SE AS A NOTA FINAL DA REDACAO E IGUAL A NOTA DA TERCEIRA (ABSOLUTA) 
		-- ****** VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A MEDIA DA PRIMEIRA COM A SEGUNDA E NAO TEM TERCEIRA
		-- ****** VERFICA SE TEM NOTA FINAL E NAO POSSUI PRIMEIRA OU SEGUNDA
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 5
		from [dbo].[inep_n59] ine with(nolock) left join [' + @schema + '].[correcoes_redacao]       red  WITH(NOLOCK) ON (red.id = ine.redacao_id)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor1 WITH(NOLOCK) ON (COR1.REDACAO_ID = ine.redacao_id AND 
																													COR1.ID_TIPO_CORRECAO = 1 AND 
																				  	   								COR1.ID_STATUS = 3)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor2 WITH(NOLOCK) ON (COR2.REDACAO_ID = ine.redacao_id AND 
																													COR2.ID_TIPO_CORRECAO = 2 AND 
																				  	   								COR2.ID_STATUS = 3)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor3 WITH(NOLOCK) ON (COR3.REDACAO_ID = ine.redacao_id AND 
																													COR3.ID_TIPO_CORRECAO = 3 AND 
																				  	   								COR3.ID_STATUS = 3)
											   left join [' + @schema + '].[correcoes_correcao]      cor4 WITH(NOLOCK) ON (COR4.REDACAO_ID = ine.redacao_id AND 
																													COR4.ID_TIPO_CORRECAO = 4)
											   left join [' + @schema + '].[correcoes_correcao]      corA WITH(NOLOCK) ON (corA.REDACAO_ID = ine.redacao_id AND 
																													corA.ID_TIPO_CORRECAO = 7)
											  left join  [' + @schema + '].[vw_redacao_equidistante] equ  with(nolock) on (equ.redacao_id = ine.redacao_id)
		  WHERE  ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  INE.status_id = 1 AND         
				 ine.nu_cpf_av3 is not null and 
				 ine.nu_cpf_av1 is not null and 
				 ine.nu_cpf_av2 is not null and 
				 ine.nu_cpf_av4 is null     and
				 ine.nu_cpf_auditor is null and 

				 -- *** PRA FECHAR NA TERCEIRA NAO PODE EXISTIR QUARTA, AUDITORIA E NEM SER EQUIDISTANTE
				 (	(cor4.id is not null) or 
					(corA.id is not null) or 
					(equ.redacao_id is not  null ) or 

					-- *** VERIFICAR NOTA FINAL DA REDACAO
					(ine.nu_nota_final <> red.nota_final) or 
			
					-- *** VERIFICAR NOTAS DA PRIMEIRA CORRECAO
					(ine.nu_nota_comp1_av1 <> cor1.nota_competencia1 or 
					 ine.nu_nota_comp2_av1 <> cor1.nota_competencia2 or 
					 ine.nu_nota_comp3_av1 <> cor1.nota_competencia3 or 
					 ine.nu_nota_comp4_av1 <> cor1.nota_competencia4 or 
					 ine.nu_nota_comp5_av1 <> cor1.nota_competencia5)or 
             
					-- *** VERIFICAR NOTAS DA SEGUNDA CORRECAO
					(ine.nu_nota_comp1_av2 <> cor2.nota_competencia1 or 
					 ine.nu_nota_comp2_av2 <> cor2.nota_competencia2 or 
					 ine.nu_nota_comp3_av2 <> cor2.nota_competencia3 or 
					 ine.nu_nota_comp4_av2 <> cor2.nota_competencia4 or
					 ine.nu_nota_comp5_av2 <> cor2.nota_competencia5) or
			  
					-- *** VERIFICAR NOTAS DA TERCEIRA CORRECAO
					(ine.nu_nota_comp1_av3 <> cor3.nota_competencia1 or 
					 ine.nu_nota_comp2_av3 <> cor3.nota_competencia2 or 
					 ine.nu_nota_comp3_av3 <> cor3.nota_competencia3 or 
					 ine.nu_nota_comp4_av3 <> cor3.nota_competencia4 or 
					 ine.nu_nota_comp5_av3 <> cor3.nota_competencia5)  OR  
			 
					-- *** VERIFICAR SITUACAO
					(ine.co_situacao_redacao_final <> red.id_correcao_situacao) or  
					(red.id_correcao_situacao <> cor1.id_correcao_situacao and 
					 red.id_correcao_situacao <> cor2.id_correcao_situacao)  
				 )

				 AND 
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql6 = N' union
		-- ****** 6 - VERIFICACAO DE QUARTA --  VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A NOTA FINAL DO ARQUIVO N59
		-- ****** VERIFICA SE A NOTA DE CADA COMPETENCIA DA REDACAO E IGUAL A NOTA DE CADA COMPETENCIA DO ARQUIVO N59
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 6 
		from [dbo].[inep_n59] ine with(nolock) 
										 left join [' + @schema + '].[correcoes_redacao]  red  WITH(NOLOCK) ON (red.id = ine.redacao_id)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor1 WITH(NOLOCK) ON (COR1.REDACAO_ID = ine.redacao_id AND COR1.ID_TIPO_CORRECAO = 1 AND COR1.ID_STATUS = 3)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor2 WITH(NOLOCK) ON (COR2.REDACAO_ID = ine.redacao_id AND COR2.ID_TIPO_CORRECAO = 2 AND COR2.ID_STATUS = 3)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor3 WITH(NOLOCK) ON (COR3.REDACAO_ID = ine.redacao_id AND COR3.ID_TIPO_CORRECAO = 3 AND COR3.ID_STATUS = 3)
										 left join [' + @schema + '].[correcoes_correcao] cor4 WITH(NOLOCK) ON (COR4.REDACAO_ID = ine.redacao_id AND COR4.ID_TIPO_CORRECAO = 4)
										 left join [' + @schema + '].[correcoes_correcao] corA WITH(NOLOCK) ON (corA.REDACAO_ID = ine.redacao_id AND corA.ID_TIPO_CORRECAO = 7)
										 left join [' + @schema + '].[vw_redacao_equidistante] equ  with(nolock) on (equ.redacao_id = ine.redacao_id)
		  WHERE  ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and   INE.status_id = 1 AND             
				 ine.nu_cpf_av3 is not null and
				 ine.nu_cpf_av1 is not null and
				 ine.nu_cpf_av2 is not null and
				 ine.nu_cpf_av4 is not null and
				 ine.nu_cpf_auditor is null and		  
				 -- *** PRA FECHAR NA QUARTA NAO PODE EXISTIR AUDITORIA 
				 (	( corA.id is not null) or 			
					-- *** VERIFICAR NOTA FINAL DA REDACAO
					(ine.nu_nota_final <> red.nota_final) or 			
					-- *** VERIFICAR NOTAS DA PRIMEIRA CORRECAO
					(ine.nu_nota_comp1_av1 <> cor1.nota_competencia1 or 
					 ine.nu_nota_comp2_av1 <> cor1.nota_competencia2 or 
					 ine.nu_nota_comp3_av1 <> cor1.nota_competencia3 or 
					 ine.nu_nota_comp4_av1 <> cor1.nota_competencia4 or 
					 ine.nu_nota_comp5_av1 <> cor1.nota_competencia5)or 
					-- *** VERIFICAR NOTAS DA SEGUNDA CORRECAO
					(ine.nu_nota_comp1_av2 <> cor2.nota_competencia1 or 
					 ine.nu_nota_comp2_av2 <> cor2.nota_competencia2 or 
					 ine.nu_nota_comp3_av2 <> cor2.nota_competencia3 or 
					 ine.nu_nota_comp4_av2 <> cor2.nota_competencia4 or
					 ine.nu_nota_comp5_av2 <> cor2.nota_competencia5) or			  
					-- *** VERIFICAR NOTAS DA TERCEIRA CORRECAO
					(ine.nu_nota_comp1_av3 <> cor3.nota_competencia1 or 
					 ine.nu_nota_comp2_av3 <> cor3.nota_competencia2 or 
					 ine.nu_nota_comp3_av3 <> cor3.nota_competencia3 or 
					 ine.nu_nota_comp4_av3 <> cor3.nota_competencia4 or 
					 ine.nu_nota_comp5_av3 <> cor3.nota_competencia5) or  			  
					-- *** VERIFICAR NOTAS DA QUARTA CORRECAO
					(ine.nu_nota_comp1_av4 <> cor4.nota_competencia1 or 
					 ine.nu_nota_comp2_av4 <> cor4.nota_competencia2 or 
					 ine.nu_nota_comp3_av4 <> cor4.nota_competencia3 or 
					 ine.nu_nota_comp4_av4 <> cor4.nota_competencia4 or 
					 ine.nu_nota_comp5_av4 <> cor4.nota_competencia5) or 
					 -- *** VERIFICAR SITUACAO
					(ine.co_situacao_redacao_final <> red.id_correcao_situacao) OR 
					(ine.nu_nota_final <> COR4.NOTA_FINAL) AND 
					(ine.co_situacao_redacao_final <> COR4.id_correcao_situacao) OR 
					(INE.co_situacao_redacao_final = 1 AND INE.nu_nota_final = 0)
				 ) AND 
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql7 = N'
		union 
		-- ****** 7 - VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A NOTA FINAL DO ARQUIVO N59
		-- ****** VERIFICA SE A NOTA DE CADA COMPETENCIA DA REDACAO E IGUAL A NOTA DE CADA COMPETENCIA DO ARQUIVO N59

		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 7
		from [dbo].[inep_n59] ine with(nolock) LEFT JOIN [' + @schema + '].[correcoes_redacao] red WITH(NOLOCK) ON (red.id = ine.redacao_id )
		  WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  INE.status_id = 1 AND
				 ine.nu_cpf_auditor is not null and	 
				(ine.nu_nota_final      <> red.nota_final        or  
				ine.nu_nota_media_comp1 <> red.nota_competencia1 or  
				ine.nu_nota_media_comp2 <> red.nota_competencia2 or  
				ine.nu_nota_media_comp3 <> red.nota_competencia3 or  
				ine.nu_nota_media_comp4 <> red.nota_competencia4 or  
				ine.nu_nota_media_comp5 <> red.nota_competencia5)  '

	SET @sql8 = N'
		union 
		-- ****** 8 - SE NO ARQUIVO DO INEP_N59 AS SEGUNDAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 8
		FROM INEP_N59 INE with(nolock)  JOIN inep_lote LOT with(nolock)  ON (INE.LOTE_ID = LOT.ID)
		WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and   INE.status_id = 1 AND
				INE.nu_cpf_av1 IS NOT NULL AND 
				INE.nu_cpf_av2 IS NOT NULL AND
				INE.nu_cpf_av3 IS NULL AND 
				INE.nu_cpf_av4 IS NULL AND 
				INE.nu_cpf_auditor IS NULL  AND 

				( ABS(INE.nu_nota_av1 - NU_NOTA_AV2) > 100 OR 
				ABS(INE.nu_nota_comp1_av1 - INE.nu_nota_comp1_av2) > 80 OR 
				ABS(INE.nu_nota_comp2_av1 - INE.nu_nota_comp2_av2) > 80 OR 
				ABS(INE.nu_nota_comp3_av1 - INE.nu_nota_comp3_av2) > 80 OR 
				ABS(INE.nu_nota_comp4_av1 - INE.nu_nota_comp4_av2) > 80 OR 
				ABS(INE.nu_nota_comp5_av1 - INE.nu_nota_comp5_av2) > 80 
			)  '

	SET @sql9 = N'
		union 
		-- ****** 9 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 9
		FROM INEP_N59 INE with(nolock)  JOIN inep_lote LOT with(nolock)  ON (INE.LOTE_ID = LOT.ID)
		WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and   INE.status_id = 1 AND
				INE.nu_cpf_av1 IS NOT NULL AND 
				INE.nu_cpf_av2 IS NOT NULL AND
				INE.nu_cpf_av3 IS NOT NULL AND 
				INE.nu_cpf_av4 IS NULL AND 
				INE.nu_cpf_auditor IS NULL  AND 

			(  (ABS(INE.nu_nota_av1 - NU_NOTA_AV3) > 100  AND ABS(INE.nu_nota_av2 - NU_NOTA_AV3) > 100)  OR 
				(ABS(INE.nu_nota_comp1_av1 - INE.nu_nota_comp1_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp2_av1 - INE.nu_nota_comp2_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp3_av1 - INE.nu_nota_comp3_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp4_av1 - INE.nu_nota_comp4_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp5_av1 - INE.nu_nota_comp5_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR
				(INE.co_situacao_redacao_av1 <> INE.co_situacao_redacao_av3  AND INE.co_situacao_redacao_av2 <> co_situacao_redacao_av3)
			)  '

	SET @sql10 = N'
		union 		
		-- ****** 10 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 10
		FROM INEP_N59 INE with(nolock)  JOIN inep_lote LOT with(nolock)  ON (INE.LOTE_ID = LOT.ID)
		WHERE   ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  INE.status_id = 1 AND
		        lot.status_id = 4 and 
				exists (
					select 1 from vw_conferencia_nota_avaliador con 
					  where con.redacao_id = ine.redacao_id and 
					        con.lote_id    = ine.lote_id
				)  '

	SET @sql11 = N'
		union 		
		-- ****** 11 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT N59.redacao_id, N59.lote_id, N59.projeto_id, ERRRO = 11
		from inep_n59 n59 with(nolock)  join inep_lote lot with(nolock)  on (n59.lote_id = lot.id)
	                    JOIN [' + @schema + '].CORRECOES_REDACAO         RED with(nolock) ON (RED.ID = N59.redacao_id AND 
						                                                RED.id_projeto = N59.projeto_id)
	               LEFT JOIN [' + @schema + '].CORRECOES_CORRECAO      COR with(nolock)  ON (COR.redacao_id = N59.redacao_id AND 
				                                                        COR.id_projeto = N59.projeto_id AND 
																		COR.id_tipo_correcao = 7) 
                   LEFT join [' + @schema + '].VW_VALIDACAO_AUDITORIA   aud with(nolock) on (n59.redacao_id = aud.redacao_id and 
                                                                        n59.projeto_id = aud.projeto_id)
     where lot.status_id in (2,4) and
           n59.nu_cpf_auditor is not null and 
	        N59.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and   N59.status_id = 1 AND
			(AUD.REDACAO_ID IS NOT NULL  OR 
				(
					(	(N59.nu_cpf_av3 = N59.nu_cpf_auditor AND N59.nu_cpf_av4 IS NULL AND 
							(ISNULL(N59.nu_nota_comp1_av3,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_comp2_av3,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_comp3_av3,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_comp4_av3,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_comp5_av3,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_av3,-5)       <> ISNULL(RED.nota_final,0)
							)
						) OR 
						(N59.nu_cpf_av3 IS NOT NULL AND N59.nu_cpf_av4 = N59.NU_CPF_AUDITOR AND 
							(ISNULL(N59.nu_nota_comp1_av4,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_comp2_av4,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_comp3_av4,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_comp4_av4,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_comp5_av4,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_av4,-5)       <> ISNULL(RED.nota_final,0)
							)
						) OR 
						(N59.nu_cpf_av4 IS NOT NULL AND N59.nu_cpf_av4 <> N59.NU_CPF_AUDITOR AND 
							(ISNULL(N59.nu_nota_media_comp1,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_media_comp2,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_media_comp3,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_media_comp4,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_media_comp5,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_final,-5)       <> ISNULL(RED.nota_final,0)
							)
						)
					)
				)
			)  '


		set @sqlfinal = N' ) as tab

		        SELECT * FROM #temp '


		 --print @sql0
		 --print @sql1
		 --print @sql2
		 --PRINT @SQL3
		 --PRINT @SQL4
		 --print @sql5
		 --PRINT @SQL6
		 --PRINT @SQL7
		 --PRINT @SQL8
		 --PRINT @SQL9
		 --PRINT @SQL10
		 --PRINT @SQL11
		 --print @sqlfinal 

		 EXEC (@sql0 +@sql1 +@sql2 +@SQL3 +@SQL4 +@sql5 +@SQL6 +@SQL7 +@SQL8 +@SQL9 +@SQL10 +@SQL11 +@sqlfinal)
	END
ELSE 
	BEGIN
		PRINT 'ESTE LOTE NAO ESTA DISPONIVEL PARA CONSISTENCIA'
	END

GO
/****** Object:  StoredProcedure [dbo].[sp_validacao_n59_ENEM_manual]    Script Date: 06/01/2020 10:31:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec sp_validacao_n59_ENEM_MANUAL '20191223',198
CREATE     PROCEDURE [dbo].[sp_validacao_n59_ENEM_manual]  @schema nvarchar(50), @LOTE INT as 
declare @sql0 nvarchar(max)
declare @sql1 nvarchar(max)
declare @sql2 nvarchar(max)
declare @sql3 nvarchar(max)
declare @sql4 nvarchar(max) 
declare @sql5 nvarchar(max)
declare @sql6 nvarchar(max)
declare @sql7 nvarchar(max) 
declare @sql8 nvarchar(max) 
declare @sql9 nvarchar(max) 
declare @sql10 nvarchar(max) 
declare @sql11 nvarchar(max) 
declare @sqlfinal nvarchar(max) 
declare @sqlVIEW nvarchar(max) 

--IF(EXISTS (SELECT * FROM inep_lote WHERE STATUS_ID = 8 AND ID = @LOTE ))
--
--	BEGIN 
	
		-- ****  CRIAR VIEWS NO SQUEMA CORRENTE
		SET @sqlVIEW = N' SP_CRIAR_VIEW_REDACAO_EQUIDISTANTE ' + CHAR(39) + @schema + CHAR(39) 
		EXEC (@sqlVIEW)

		SET @sqlVIEW = N' SP_CRIAR_VIEW_VALIDACAO_AUDITORIA ' + CHAR(39) + @schema + CHAR(39) 
		EXEC (@sqlVIEW)
		-- **** CRIAR VIEWS NO SQUEMA CORRENTE - FIM 


		set @sql0 = N'  if (object_id(' + char(39) + 'tempdb..#temp' + char(39) + ') is not null)   drop table #temp
					   select * into #temp from ( '


		set @sql1 = N'
		--***** 1 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (PRIMEIRA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 1
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and
			   not exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
						   where ine.redacao_id = cor.redacao_id and 
								 cor.id_tipo_correcao  = 1                     and 
								 isnull(ine.nu_nota_comp1_av1,-5) = isnull(cor.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_comp2_av1,-5) = isnull(cor.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_comp3_av1,-5) = isnull(cor.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_comp4_av1,-5) = isnull(cor.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_comp5_av1,-5) = isnull(cor.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_av1,-5) = isnull(cor.nota_final,-5       ) AND 
								 ISNULL(     ine.nu_tempo_av1,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )
							)       AND
			ine.nu_cpf_av1 IS NOT NULL '

		SET @sql2 = N'
	  
		UNION 
		--***** 2 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (SEGUNDA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 2
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and
			   NOT exists(select 1 from [' + @schema + '].[correcoes_correcao] cor 
						   where ine.redacao_id = cor.redacao_id and 
								 cor.id_tipo_correcao  = 2                     and 
								 isnull(ine.nu_nota_comp1_av2,-5) = isnull(cor.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_comp2_av2,-5) = isnull(cor.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_comp3_av2,-5) = isnull(cor.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_comp4_av2,-5) = isnull(cor.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_comp5_av2,-5) = isnull(cor.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_av2,-5) = isnull(       cor.nota_final,-5) AND 
								 ISNULL(     ine.nu_tempo_av2,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )) AND 
			ine.nu_cpf_av2 IS NOT NULL '

		SET @sql3 = N'
						  
		UNION 
		--***** 3 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (TERCEIRA CORRECAO)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, erro = 3 
		  from inep_n59 ine
		where ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and
			  ine.nu_cpf_av1 is not null and 
			  ine.nu_cpf_av2 is not null and 
			  ine.nu_cpf_av3 is not null and 
			  ine.nu_cpf_av4 is null     and 
			  ine.nu_cpf_auditor is null and
			   exists (select 1                   
							  from [' + @schema + '].correcoes_correcao cor1 join [' + @schema + '].correcoes_correcao cor2 on (cor1.redacao_id = cor2.redacao_id and cor1.id_tipo_correcao = 1  and cor2.id_tipo_correcao = 2) 
																			 join [' + @schema + '].correcoes_correcao cor3 on (cor1.redacao_id = cor3.redacao_id and cor3.id_tipo_correcao = 3)
																	   left  join [' + @schema + '].correcoes_analise  ana13 on (cor1.id = ana13.id_correcao_a and cor3.id = ana13.id_correcao_B and ana13.redacao_id = cor1.redacao_id and ana13.aproveitamento = 1)
																	   left  join [' + @schema + '].correcoes_analise  ana23 on (cor2.id = ana23.id_correcao_a and cor3.id = ana23.id_correcao_B and ana23.redacao_id = cor2.redacao_id and ana23.aproveitamento = 1)
							where cor1.redacao_id = ine.redacao_id and   
								  (ine.nu_nota_final <> case when ana13.aproveitamento = 1 then abs(cor1.nota_final + cor3.nota_final)/2
															 when ana23.aproveitamento = 1 then abs(cor2.nota_final + cor3.nota_final)/2 else null end or 
								   ine.nu_nota_media_comp1 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia1 + cor3.nota_competencia1)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia1 + cor3.nota_competencia1)/2  end or
								   ine.nu_nota_media_comp2 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia2 + cor3.nota_competencia2)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia2 + cor3.nota_competencia2)/2  end or
								   ine.nu_nota_media_comp3 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia3 + cor3.nota_competencia3)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia3 + cor3.nota_competencia3)/2  end or
								   ine.nu_nota_media_comp4 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia4 + cor3.nota_competencia4)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia4 + cor3.nota_competencia4)/2  end or
								   ine.nu_nota_media_comp5 <> case when ana13.aproveitamento = 1 then abs(cor1.nota_competencia5 + cor3.nota_competencia5)/2
																   when ana23.aproveitamento = 1 then abs(cor2.nota_competencia5 + cor3.nota_competencia5)/2  end 
								  )
			) '

		set @sql4 = 							  
		N' UNION 
		--***** 4 -- VERIFICACAO SEGUNDA -- VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (REDACAO NOTAFINAL)
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 4
		from [dbo].[inep_n59] ine with(nolock) 
		 where ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and
			   NOT exists(select 1 from [' + @schema + '].[correcoes_REDACAO] RED 
						   where ine.redacao_id = RED.id and 
								 isnull(ine.nu_nota_media_comp1,-5) = isnull(RED.nota_competencia1,-5) and 
								 isnull(ine.nu_nota_media_comp2,-5) = isnull(RED.nota_competencia2,-5) and 
								 isnull(ine.nu_nota_media_comp3,-5) = isnull(RED.nota_competencia3,-5) and 
								 isnull(ine.nu_nota_media_comp4,-5) = isnull(RED.nota_competencia4,-5) and 
								 isnull(ine.nu_nota_media_comp5,-5) = isnull(RED.nota_competencia5,-5) and 
								 isnull(      ine.nu_nota_FINAL,-5) = isnull(       RED.nota_final,-5)
						 )and
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql5 = N'
		union 
		-- ****** 5 - VERIFICACAO TERCEIRA -- VERIFICAM SE AS A NOTA FINAL DA REDACAO E IGUAL A NOTA DA TERCEIRA (ABSOLUTA) 
		-- ****** VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A MEDIA DA PRIMEIRA COM A SEGUNDA E NAO TEM TERCEIRA
		-- ****** VERFICA SE TEM NOTA FINAL E NAO POSSUI PRIMEIRA OU SEGUNDA
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 5
		from [dbo].[inep_n59] ine with(nolock) left join [' + @schema + '].[correcoes_redacao]       red  WITH(NOLOCK) ON (red.id = ine.redacao_id)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor1 WITH(NOLOCK) ON (COR1.REDACAO_ID = ine.redacao_id AND 
																													COR1.ID_TIPO_CORRECAO = 1 AND 
																				  	   								COR1.ID_STATUS = 3)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor2 WITH(NOLOCK) ON (COR2.REDACAO_ID = ine.redacao_id AND 
																													COR2.ID_TIPO_CORRECAO = 2 AND 
																				  	   								COR2.ID_STATUS = 3)
											   LEFT JOIN [' + @schema + '].[correcoes_correcao]      cor3 WITH(NOLOCK) ON (COR3.REDACAO_ID = ine.redacao_id AND 
																													COR3.ID_TIPO_CORRECAO = 3 AND 
																				  	   								COR3.ID_STATUS = 3)
											   left join [' + @schema + '].[correcoes_correcao]      cor4 WITH(NOLOCK) ON (COR4.REDACAO_ID = ine.redacao_id AND 
																													COR4.ID_TIPO_CORRECAO = 4)
											   left join [' + @schema + '].[correcoes_correcao]      corA WITH(NOLOCK) ON (corA.REDACAO_ID = ine.redacao_id AND 
																													corA.ID_TIPO_CORRECAO = 7)
											  left join  [' + @schema + '].[vw_redacao_equidistante] equ  with(nolock) on (equ.redacao_id = ine.redacao_id)
		  WHERE  ine.lote_id = ' + CONVERT(VARCHAR(10),@LOTE) + '  and          
				 ine.nu_cpf_av3 is not null and 
				 ine.nu_cpf_av1 is not null and 
				 ine.nu_cpf_av2 is not null and 
				 ine.nu_cpf_av4 is null     and
				 ine.nu_cpf_auditor is null and 

				 -- *** PRA FECHAR NA TERCEIRA NAO PODE EXISTIR QUARTA, AUDITORIA E NEM SER EQUIDISTANTE
				 (	(cor4.id is not null) or 
					(corA.id is not null) or 
					(equ.redacao_id is not  null ) or 

					-- *** VERIFICAR NOTA FINAL DA REDACAO
					(ine.nu_nota_final <> red.nota_final) or 
			
					-- *** VERIFICAR NOTAS DA PRIMEIRA CORRECAO
					(ine.nu_nota_comp1_av1 <> cor1.nota_competencia1 or 
					 ine.nu_nota_comp2_av1 <> cor1.nota_competencia2 or 
					 ine.nu_nota_comp3_av1 <> cor1.nota_competencia3 or 
					 ine.nu_nota_comp4_av1 <> cor1.nota_competencia4 or 
					 ine.nu_nota_comp5_av1 <> cor1.nota_competencia5)or 
             
					-- *** VERIFICAR NOTAS DA SEGUNDA CORRECAO
					(ine.nu_nota_comp1_av2 <> cor2.nota_competencia1 or 
					 ine.nu_nota_comp2_av2 <> cor2.nota_competencia2 or 
					 ine.nu_nota_comp3_av2 <> cor2.nota_competencia3 or 
					 ine.nu_nota_comp4_av2 <> cor2.nota_competencia4 or
					 ine.nu_nota_comp5_av2 <> cor2.nota_competencia5) or
			  
					-- *** VERIFICAR NOTAS DA TERCEIRA CORRECAO
					(ine.nu_nota_comp1_av3 <> cor3.nota_competencia1 or 
					 ine.nu_nota_comp2_av3 <> cor3.nota_competencia2 or 
					 ine.nu_nota_comp3_av3 <> cor3.nota_competencia3 or 
					 ine.nu_nota_comp4_av3 <> cor3.nota_competencia4 or 
					 ine.nu_nota_comp5_av3 <> cor3.nota_competencia5)  OR  
			 
					-- *** VERIFICAR SITUACAO
					(ine.co_situacao_redacao_final <> red.id_correcao_situacao) or  
					(red.id_correcao_situacao <> cor1.id_correcao_situacao and 
					 red.id_correcao_situacao <> cor2.id_correcao_situacao)  
				 )

				 AND 
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql6 = N' union
		-- ****** 6 - VERIFICACAO DE QUARTA --  VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A NOTA FINAL DO ARQUIVO N59
		-- ****** VERIFICA SE A NOTA DE CADA COMPETENCIA DA REDACAO E IGUAL A NOTA DE CADA COMPETENCIA DO ARQUIVO N59
		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 6 
		from [dbo].[inep_n59] ine with(nolock) 
										 left join [' + @schema + '].[correcoes_redacao]  red  WITH(NOLOCK) ON (red.id = ine.redacao_id)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor1 WITH(NOLOCK) ON (COR1.REDACAO_ID = ine.redacao_id AND COR1.ID_TIPO_CORRECAO = 1 AND COR1.ID_STATUS = 3)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor2 WITH(NOLOCK) ON (COR2.REDACAO_ID = ine.redacao_id AND COR2.ID_TIPO_CORRECAO = 2 AND COR2.ID_STATUS = 3)
										 LEFT JOIN [' + @schema + '].[correcoes_correcao] cor3 WITH(NOLOCK) ON (COR3.REDACAO_ID = ine.redacao_id AND COR3.ID_TIPO_CORRECAO = 3 AND COR3.ID_STATUS = 3)
										 left join [' + @schema + '].[correcoes_correcao] cor4 WITH(NOLOCK) ON (COR4.REDACAO_ID = ine.redacao_id AND COR4.ID_TIPO_CORRECAO = 4)
										 left join [' + @schema + '].[correcoes_correcao] corA WITH(NOLOCK) ON (corA.REDACAO_ID = ine.redacao_id AND corA.ID_TIPO_CORRECAO = 7)
										 left join [' + @schema + '].[vw_redacao_equidistante] equ  with(nolock) on (equ.redacao_id = ine.redacao_id)
		  WHERE  ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and               
				 ine.nu_cpf_av3 is not null and
				 ine.nu_cpf_av1 is not null and
				 ine.nu_cpf_av2 is not null and
				 ine.nu_cpf_av4 is not null and
				 ine.nu_cpf_auditor is null and		  
				 -- *** PRA FECHAR NA QUARTA NAO PODE EXISTIR AUDITORIA 
				 (	( corA.id is not null) or 			
					-- *** VERIFICAR NOTA FINAL DA REDACAO
					(ine.nu_nota_final <> red.nota_final) or 			
					-- *** VERIFICAR NOTAS DA PRIMEIRA CORRECAO
					(ine.nu_nota_comp1_av1 <> cor1.nota_competencia1 or 
					 ine.nu_nota_comp2_av1 <> cor1.nota_competencia2 or 
					 ine.nu_nota_comp3_av1 <> cor1.nota_competencia3 or 
					 ine.nu_nota_comp4_av1 <> cor1.nota_competencia4 or 
					 ine.nu_nota_comp5_av1 <> cor1.nota_competencia5)or 
					-- *** VERIFICAR NOTAS DA SEGUNDA CORRECAO
					(ine.nu_nota_comp1_av2 <> cor2.nota_competencia1 or 
					 ine.nu_nota_comp2_av2 <> cor2.nota_competencia2 or 
					 ine.nu_nota_comp3_av2 <> cor2.nota_competencia3 or 
					 ine.nu_nota_comp4_av2 <> cor2.nota_competencia4 or
					 ine.nu_nota_comp5_av2 <> cor2.nota_competencia5) or			  
					-- *** VERIFICAR NOTAS DA TERCEIRA CORRECAO
					(ine.nu_nota_comp1_av3 <> cor3.nota_competencia1 or 
					 ine.nu_nota_comp2_av3 <> cor3.nota_competencia2 or 
					 ine.nu_nota_comp3_av3 <> cor3.nota_competencia3 or 
					 ine.nu_nota_comp4_av3 <> cor3.nota_competencia4 or 
					 ine.nu_nota_comp5_av3 <> cor3.nota_competencia5) or  			  
					-- *** VERIFICAR NOTAS DA QUARTA CORRECAO
					(ine.nu_nota_comp1_av4 <> cor4.nota_competencia1 or 
					 ine.nu_nota_comp2_av4 <> cor4.nota_competencia2 or 
					 ine.nu_nota_comp3_av4 <> cor4.nota_competencia3 or 
					 ine.nu_nota_comp4_av4 <> cor4.nota_competencia4 or 
					 ine.nu_nota_comp5_av4 <> cor4.nota_competencia5) or 
					 -- *** VERIFICAR SITUACAO
					(ine.co_situacao_redacao_final <> red.id_correcao_situacao) OR 
					(ine.nu_nota_final <> COR4.NOTA_FINAL) AND 
					(ine.co_situacao_redacao_final <> COR4.id_correcao_situacao) OR 
					(INE.co_situacao_redacao_final = 1 AND INE.nu_nota_final = 0)
				 ) AND 
				 ine.co_situacao_redacao_final not in (4,8) '

		SET @sql7 = N'
		union 
		-- ****** 7 - VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A NOTA FINAL DO ARQUIVO N59
		-- ****** VERIFICA SE A NOTA DE CADA COMPETENCIA DA REDACAO E IGUAL A NOTA DE CADA COMPETENCIA DO ARQUIVO N59

		select ine.redacao_id, ine.lote_id, INE.projeto_id, errro = 7
		from [dbo].[inep_n59] ine with(nolock) LEFT JOIN [' + @schema + '].[correcoes_redacao] red WITH(NOLOCK) ON (red.id = ine.redacao_id )
		  WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and 
				 ine.nu_cpf_auditor is not null and	 
				(ine.nu_nota_final      <> red.nota_final        or  
				ine.nu_nota_media_comp1 <> red.nota_competencia1 or  
				ine.nu_nota_media_comp2 <> red.nota_competencia2 or  
				ine.nu_nota_media_comp3 <> red.nota_competencia3 or  
				ine.nu_nota_media_comp4 <> red.nota_competencia4 or  
				ine.nu_nota_media_comp5 <> red.nota_competencia5)  '

	SET @sql8 = N'
		union 
		-- ****** 8 - SE NO ARQUIVO DO INEP_N59 AS SEGUNDAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 8
		FROM INEP_N59 INE JOIN inep_lote LOT ON (INE.LOTE_ID = LOT.ID)
		WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  
				INE.nu_cpf_av1 IS NOT NULL AND 
				INE.nu_cpf_av2 IS NOT NULL AND
				INE.nu_cpf_av3 IS NULL AND 
				INE.nu_cpf_av4 IS NULL AND 
				INE.nu_cpf_auditor IS NULL  AND 

				( ABS(INE.nu_nota_av1 - NU_NOTA_AV2) > 100 OR 
				ABS(INE.nu_nota_comp1_av1 - INE.nu_nota_comp1_av2) > 80 OR 
				ABS(INE.nu_nota_comp2_av1 - INE.nu_nota_comp2_av2) > 80 OR 
				ABS(INE.nu_nota_comp3_av1 - INE.nu_nota_comp3_av2) > 80 OR 
				ABS(INE.nu_nota_comp4_av1 - INE.nu_nota_comp4_av2) > 80 OR 
				ABS(INE.nu_nota_comp5_av1 - INE.nu_nota_comp5_av2) > 80 
			)  '

	SET @sql9 = N'
		union 
		-- ****** 9 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 9
		FROM INEP_N59 INE JOIN inep_lote LOT ON (INE.LOTE_ID = LOT.ID)
		WHERE ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  
				INE.nu_cpf_av1 IS NOT NULL AND 
				INE.nu_cpf_av2 IS NOT NULL AND
				INE.nu_cpf_av3 IS NOT NULL AND 
				INE.nu_cpf_av4 IS NULL AND 
				INE.nu_cpf_auditor IS NULL  AND 

			(  (ABS(INE.nu_nota_av1 - NU_NOTA_AV3) > 100  AND ABS(INE.nu_nota_av2 - NU_NOTA_AV3) > 100)  OR 
				(ABS(INE.nu_nota_comp1_av1 - INE.nu_nota_comp1_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp2_av1 - INE.nu_nota_comp2_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp3_av1 - INE.nu_nota_comp3_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp4_av1 - INE.nu_nota_comp4_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR 
				(ABS(INE.nu_nota_comp5_av1 - INE.nu_nota_comp5_av3) > 80 and ABS(INE.nu_nota_comp1_av2 - INE.nu_nota_comp1_av3) > 80) OR
				(INE.co_situacao_redacao_av1 <> INE.co_situacao_redacao_av3  AND INE.co_situacao_redacao_av2 <> co_situacao_redacao_av3)
			)  '

	SET @sql10 = N'
		union 		
		-- ****** 10 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 10
		FROM INEP_N59 INE JOIN inep_lote LOT ON (INE.LOTE_ID = LOT.ID)
		WHERE   ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and 
		        lot.status_id = 4 and 
				exists (
					select 1 from vw_conferencia_nota_avaliador con 
					  where con.redacao_id = ine.redacao_id and 
					        con.lote_id    = ine.lote_id
				)  '

	SET @sql11 = N'
		union 		
		-- ****** 11 - SE NO ARQUIVO DO INEP_N59 AS TERCEIRAS FECHARAM CORRETAMENTE 
		SELECT INE.redacao_id, INE.lote_id, INE.projeto_id, ERRRO = 11
		from inep_n59 n59 join inep_lote lot on (n59.lote_id = lot.id)
	                    JOIN [' + @schema + '].CORRECOES_REDACAO       RED ON (RED.ID = N59.redacao_id AND 
						                                                RED.id_projeto = N59.projeto_id)
	               LEFT JOIN [' + @schema + '].CORRECOES_CORRECAO      COR ON (COR.redacao_id = N59.redacao_id AND 
				                                                        COR.id_projeto = N59.projeto_id AND 
																		COR.id_tipo_correcao = 7) 
                   LEFT join [' + @schema + '].VW_VALIDACAO_AUDITORIA  aud on (n59.redacao_id = aud.redacao_id and 
                                                                        n59.projeto_id = aud.projeto_id)
     where lot.status_id in (2,4) and
           n59.nu_cpf_auditor is not null and 
	        ine.lote_id  = ' + CONVERT(VARCHAR(10),@LOTE) + '  and  
			(AUD.REDACAO_ID IS NOT NULL  OR 
				(
					(	(N59.nu_cpf_av3 = N59.nu_cpf_auditor AND N59.nu_cpf_av4 IS NULL AND 
							(ISNULL(N59.nu_nota_comp1_av3,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_comp2_av3,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_comp3_av3,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_comp4_av3,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_comp5_av3,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_av3,-5)       <> ISNULL(RED.nota_final,0)
							)
						) OR 
						(N59.nu_cpf_av3 IS NOT NULL AND N59.nu_cpf_av4 = N59.NU_CPF_AUDITOR AND 
							(ISNULL(N59.nu_nota_comp1_av4,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_comp2_av4,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_comp3_av4,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_comp4_av4,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_comp5_av4,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_av4,-5)       <> ISNULL(RED.nota_final,0)
							)
						) OR 
						(N59.nu_cpf_av4 IS NOT NULL AND N59.nu_cpf_av4 <> N59.NU_CPF_AUDITOR AND 
							(ISNULL(N59.nu_nota_media_comp1,-5) <> ISNULL(RED.nota_competencia1,0) OR  
							 ISNULL(N59.nu_nota_media_comp2,-5) <> ISNULL(RED.nota_competencia2,0) OR  
							 ISNULL(N59.nu_nota_media_comp3,-5) <> ISNULL(RED.nota_competencia3,0) OR  
							 ISNULL(N59.nu_nota_media_comp4,-5) <> ISNULL(RED.nota_competencia4,0) OR  
							 ISNULL(N59.nu_nota_media_comp5,-5) <> ISNULL(RED.nota_competencia5,0) OR 
							 ISNULL(N59.nu_nota_final,-5)       <> ISNULL(RED.nota_final,0)
							)
						)
					)
				)
			)  '


		set @sqlfinal = N' ) as tab

		        IF EXISTS( select TOP 1 1 from #temp) 
					BEGIN
					   UPDATE INEP_LOTE SET STATUS_ID = 3
					   WHERE ID = ' + CONVERT(VARCHAR(10), @LOTE) + '
					END
				ELSE 
					BEGIN 
					   UPDATE INEP_LOTE SET STATUS_ID = 9
					   WHERE ID = ' + CONVERT(VARCHAR(10), @LOTE)  + '
					END '


		 print @sql0
		 print @sql1
		 print @sql2
		 PRINT @SQL3
		 PRINT @SQL4
		 print @sql5
		 PRINT @SQL6
		 PRINT @SQL7
		 PRINT @SQL8
		 PRINT @SQL9
		 PRINT @SQL10
		 PRINT @SQL11
		 print @sqlfinal 

	--	 EXEC (@sql0 +@sql1 +@sql2 +@SQL3 +@SQL4 +@sql5 +@SQL6 +@SQL7 +@SQL8 +@SQL9 +@SQL10 +@SQL11 +@sqlfinal)
--	END
--ELSE 
--	BEGIN
--		PRINT 'ESTE LOTE NAO ESTA DISPONIVEL PARA CONSISTENCIA'
--	END

GO
