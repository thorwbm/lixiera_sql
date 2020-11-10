declare @area varchar(200)
declare @nome varchar(200)
declare @EXAM_ID  INT
declare @EXISTE int 

declare CUR_ cursor for 
	SELECT AREAATUACAO, nome, EXA.EXAM_ID 
	  FROM IMP_SBP_CONSOLIDADA CON JOIN TMP_AUX_EXAM_EXAM EXA ON (CON.AREAATUACAO = EXA.BASE)
	--where nome = 'ALESSANDRA SOUSA MARQUES'
	open CUR_ 
		fetch next from CUR_ into @area, @nome, @EXAM_ID
		while @@FETCH_STATUS = 0  
			BEGIN	

				select @EXISTE = COUNT(APP.ID)
				  from application_application app join auth_user usu on (usu.id = app.user_id) 
					where usu.name = @nome and 
						  APP.exam_id = @EXAM_ID
   
          print @nome + '--- nome'
		  print @area + '--- area' 
		  print CONVERT(VARCHAR(10),@EXAM_ID) + '--- ID DO EXAM' 	  
		  
		  print ''
		  if (@EXISTE = 0)
			begin
				PRINT'DEU ERRADO   xxxxxxxxxxxxxxx'
			end 
		 else 
		    begin
				print 'DEU CERTO'
			end
			
		  print ''
		  print '###################################################################'

		  INSERT INTO TMP_IMP_VALIDACAO_CONSOLIDADO
		  SELECT @NOME, @area, @EXAM_ID, VALIDACAO = CASE WHEN @EXISTE = 1 THEN 'VALIDO' ELSE 'NAO VALIDO' END 

			fetch next from CUR_ into @area, @nome, @EXAM_ID
			END
	close CUR_ 
deallocate CUR_ 

--SELECT * FROM tmp_aux_exam_exam WHERE BASE = 'TEP SERIADO CICLO 4 - PROVA R3'

--DROP TABLE TMP_IMP_VALIDACAO_CONSOLIDADO
--DELETE FROM  TMP_IMP_VALIDACAO_CONSOLIDADO
--SELECT USUARIO_NOME= REPLICATE('X',200), AREA = REPLICATE('X',200), EXAM_ID = 0, VALIDACAO = 'NAO VALIDO' INTO TMP_IMP_VALIDACAO_CONSOLIDADO

--SELECT * FROM  TMP_IMP_VALIDACAO_CONSOLIDADO  WHERE VALIDACAO = 'NAO VALIDO'





