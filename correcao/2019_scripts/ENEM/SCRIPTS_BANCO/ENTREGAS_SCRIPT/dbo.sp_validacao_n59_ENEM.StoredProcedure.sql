/****** Object:  StoredProcedure [dbo].[sp_validacao_n59_ENEM]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_validacao_n59_ENEM]
GO
/****** Object:  StoredProcedure [dbo].[sp_validacao_n59_ENEM]    Script Date: 26/12/2019 13:14:39 ******/
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
