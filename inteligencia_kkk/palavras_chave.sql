--select *
-- from tmp_inteligencia 
-- where category = 'FREE_RESPONSE' and 
--       expected_free_response is not null and id = 405
drop table #temp
DROP TABLE #TEMP_1
DROP TABLE #TEMP_CURSOR

-- crio a tabela temporaria 
select distinct item_id = ITE.id,resposta = dbo.udf_StripHTML(expected_free_response),  
       texto_comparado = replace(replace(replace(replace(replace(replace(dbo.udf_StripHTML(expected_free_response),',', ' '),'.', ' '),' ', '%'),'%%', '%'),')', ''),'(', ''),  
	   texto_base = (select stuff((
	    select distinct '%'+ value from STRING_SPLIT ( replace(replace(replace(replace(dbo.udf_StripHTML(expected_free_response),',', ' '),'.', ' '),')', ''),'(', '') ,' ')
	   where len(value) > 3
	   for xml path('')), 1,1 , '')),
	   peso = 1.0 , qtd_palavras_chave = 0, SENTIDO = 1 into #temp
 from item_item ITE JOIN EXAM_EXAMITEM EXI ON (EXI.item_id = ITE.ID)
 where category = 'FREE_RESPONSE' and 
       expected_free_response is not null and
	   EXI.exam_id = 45

update #temp set qtd_palavras_chave = dbo.fn_conta_caracter(texto_base, '%') WHERE 1 = 1

SELECT * INTO #TEMP_CURSOR FROM #TEMP

DECLARE @TEXTO_RESPOSTA VARCHAR(MAX) 
declare @string_base varchar(max)
declare @string_aux1 varchar(max)
declare @string_aux2 varchar(max)
DECLARE @ITEM_ID INT
declare @contador_seguranca int
declare @tamanho int

declare CUR_ cursor for 
	SELECT ITEM_ID, RESPOSTA, texto_base FROM #TEMP_CURSOR 
	open CUR_ 
		fetch next from CUR_ into @ITEM_ID, @TEXTO_RESPOSTA, @string_base
		while @@FETCH_STATUS = 0
			BEGIN
--#################################################################################################

				SET @contador_seguranca = 0

				SET @tamanho = len(@string_base)
				set @string_aux2 = @string_base

				while (@tamanho > 0)
					begin
						if (charindex('%',@string_aux2) <> 0)
							begin
								set @string_aux1 = left(@string_aux2, charindex('%',@string_aux2))
							end
						else 
							begin
								set @string_aux1 = @string_aux2
							end
						set @string_aux2 = replace (@string_aux2, @string_aux1, '')

						print 'AUX2 -->' + @string_aux2
						print 'AUX1 -->' + @string_aux1
		
						--set identity_insert #temp on
						INSERT INTO #temp (ITEM_ID,RESPOSTA, TEXTO_COMPARADO, TEXTO_BASE, PESO,qtd_palavras_chave, SENTIDO)
						SELECT @ITEM_ID,@TEXTO_RESPOSTA,@string_aux2,@string_base, PESO = 0.10, 0,1
						 WHERE NOT EXISTS (SELECT 1 FROM #TEMP WHERE texto_comparado = @string_aux2 AND item_id = @ITEM_ID) 
		
						--set identity_insert #temp on
						INSERT INTO #temp (ITEM_ID,RESPOSTA, TEXTO_COMPARADO, TEXTO_BASE, PESO,qtd_palavras_chave, SENTIDO)
						SELECT @ITEM_ID,@TEXTO_RESPOSTA,REPLACE(@string_aux1,'%',''),@string_base,PESO =0.09, 0,1
						 WHERE NOT EXISTS (SELECT 1 FROM #TEMP WHERE texto_comparado = @string_aux1 AND item_id = @ITEM_ID)

						set @tamanho = len(@string_aux2)
						set @contador_seguranca = @contador_seguranca + 1

						if(@contador_seguranca = 50)
							begin
								set @tamanho = 0
							end
					end

				---------------------------------------------------------------------------------------------------
				SET @contador_seguranca = 0
				SET @tamanho = len(@string_base)
				set @string_aux2 = REVERSE(@string_base)

				while (@tamanho > 0)
					begin
						if (charindex('%',@string_aux2) <> 0)
							begin
								set @string_aux1 = left(@string_aux2, charindex('%',@string_aux2))
							end
						else 
							begin
								set @string_aux1 = @string_aux2
							end
						set @string_aux2 = replace (@string_aux2, @string_aux1, '')

						print 'AUX2 -->' + @string_aux2
						print 'AUX1 -->' + @string_aux1
		
						--set identity_insert #temp on
						INSERT INTO #temp (ITEM_ID,RESPOSTA, TEXTO_COMPARADO, TEXTO_BASE, PESO,qtd_palavras_chave, SENTIDO)
						SELECT @ITEM_ID,@TEXTO_RESPOSTA,REVERSE(@string_aux2),REVERSE(@string_base), PESO = 0.10, 0,0
						 WHERE NOT EXISTS (SELECT 1 FROM #TEMP WHERE texto_comparado = REVERSE(@string_aux2) AND ITEM_ID = @ITEM_ID)  
		
						--set identity_insert #temp on
						INSERT INTO #temp (ITEM_ID,RESPOSTA, TEXTO_COMPARADO, TEXTO_BASE, PESO,qtd_palavras_chave, SENTIDO)
						SELECT @ITEM_ID,@TEXTO_RESPOSTA,REVERSE(REPLACE(@string_aux1,'%','')),REVERSE(@string_base),PESO =0.09, 0,0
						 WHERE NOT EXISTS (SELECT 1 FROM #TEMP WHERE texto_comparado = REVERSE(@string_aux1) AND ITEM_ID = @ITEM_ID) 

						set @tamanho = len(@string_aux2)
						set @contador_seguranca = @contador_seguranca + 1

						if(@contador_seguranca = 50)
							begin
								set @tamanho = 0
							end
					end
----------------------------------------------------------------------------------------------------

IF (OBJECT_ID('tempdb..#TEMP_1') IS  NULL) 
	BEGIN	
		select item_id, resposta, texto_comparado, texto_base, 
			   peso = 1 - (ROW_NUMBER() OVER (ORDER BY ITEM_ID, LEN(texto_comparado) DESC, SENTIDO)/100.0 - 0.01) , 
			   qtd_palavras_chave
		INTO #TEMP_1
		from #temp 
		WHERE ITEM_ID = @ITEM_ID
	END
ELSE 
	BEGIN
	    INSERT INTO #TEMP_1 
		select item_id, resposta, texto_comparado, texto_base, 
			   peso = 1 - (ROW_NUMBER() OVER (ORDER BY ITEM_ID, LEN(texto_comparado) DESC, SENTIDO)/100.0 - 0.01) , 
			   qtd_palavras_chave
		from #temp 
		WHERE ITEM_ID = @ITEM_ID
	END


DELETE FROM #TEMP_1 WHERE LEN(TEXTO_COMPARADO) = 0


 INSERT INTO tmp_inteligencia (item_id, resposta, texto_compaRado, peso)
 SELECT TMP.ITEM_ID, TMP.RESPOSTA, TMP.texto_comparado,CAST(TMP.PESO AS DECIMAL(5,2))
 FROM #TEMP_1 TMP LEFT JOIN TMP_INTELIGENCIA XXX ON (XXX.item_id = TMP.item_id AND 
                                                     XXX.texto_comparado = TMP.texto_comparado)
 WHERE XXX.ID IS NULL 
--##################################################################################################

			fetch next from CUR_ into @ITEM_ID, @TEXTO_RESPOSTA, @string_base
			END
	close CUR_ 
deallocate CUR_ 





SELECT * --DELETE
FROM tmp_inteligencia





