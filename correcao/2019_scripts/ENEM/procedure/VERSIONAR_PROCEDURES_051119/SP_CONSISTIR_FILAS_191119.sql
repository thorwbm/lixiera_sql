
create or alter procedure sp_consistir_filas 
    @redacao_id int, @ID_PROJETO INT,@fila int as


-- *** CONSISTENCIA DA FILA 3
--		VALIDAR SE NAO EXISTE INSERCAO EM OUTRA FILA
--		VALIDAR SE AS COMPETENCIAS VEZES O PESO E IGUAL A NOTA GRAVADA
--		VALIDAR SE A NOTA FINAL E IGUAL AO SOMATORIO DAS NOTAS DE CADA COMPETENCIA
--		VALIDAR SE EXISTEM CORRECOES DE PRIMEIRA E SEGUNDA 
if (@fila = 3) -- VALIDACAO DA TERCEIRA FILA
	begin
		 update fil3 set fil3.consistido = abs(1 -
			(select COUNT(DISTINCT 1)
						 from correcoes_fila3 FIL3    join projeto_projeto     pro  on (pro.id = FIL3.id_projeto) 
													  join VW_FILAS_DA_REDACAO fils  on (FIL3.redacao_id  = fils.REDACAO_ID and FIL3.id_projeto = fils.id_projeto)
												 LEFT join correcoes_correcao  cor1 on (cor1.redacao_id = FIL3.redacao_id and cor1.id_tipo_correcao = 1 AND FIL3.id_PROJETO = COR1.ID_PROJETO ) 
												 LEFT join correcoes_correcao  cor2 on (cor2.redacao_id = FIL3.redacao_id and cor2.id_tipo_correcao = 2 AND FIL3.id_projeto = COR2.ID_PROJETO )
												 LEFT join correcoes_correcao  cor3 on (cor3.redacao_id = FIL3.redacao_id and cor3.id_tipo_correcao = 3 AND FIL3.id_projeto = COR3.ID_PROJETO )  
						where  
						       (	
						           -- **** testar se as notas da correcao1 estao corretas e se o somatorio das mesmas bate com a nota final 
						           (cor1.id_correcao_situacao = 1 and 
										(isnull(cor1.competencia1,-5) * pro.peso_competencia <> cor1.nota_competencia1 or  
										 isnull(cor1.competencia2,-5) * pro.peso_competencia <> cor1.nota_competencia2 or  
										 isnull(cor1.competencia3,-5) * pro.peso_competencia <> cor1.nota_competencia3 or  
										 isnull(cor1.competencia4,-5) * pro.peso_competencia <> cor1.nota_competencia4 or  
										 case cor1.competencia5 when -1 then 0 else isnull(cor1.competencia5,-5) end * pro.peso_competencia <> cor1.nota_competencia5 or 
										 cor1.nota_final <> cor1.nota_competencia1 + cor1.nota_competencia2 + cor1.nota_competencia3 + cor1.nota_competencia4 + cor1.nota_competencia5)
									) or 

									-- **** testar se as notas da correcao2 estao corretas e se o somatorio das mesmas bate com a nota final 
						           (cor2.id_correcao_situacao = 1 and 
										(isnull(cor2.competencia1,-5) * pro.peso_competencia <> cor2.nota_competencia1 or  
										 isnull(cor2.competencia2,-5) * pro.peso_competencia <> cor2.nota_competencia2 or  
										 isnull(cor2.competencia3,-5) * pro.peso_competencia <> cor2.nota_competencia3 or  
										 isnull(cor2.competencia4,-5) * pro.peso_competencia <> cor2.nota_competencia4 or  
										 case cor2.competencia5 when -1 then 0 else isnull(cor2.competencia5,-5) end * pro.peso_competencia <> cor2.nota_competencia5 or 
										 cor2.nota_final <> cor2.nota_competencia1 + cor2.nota_competencia2 + cor2.nota_competencia3 + cor2.nota_competencia4 + cor2.nota_competencia5)
									) or 

									-- **** testar as notas finais da primeira e segunda correcao discrepam quando a situacao for 1
						           (cor1.id_correcao_situacao = 1 and
									cor2.id_correcao_situacao = 1 and
									abs(cor1.nota_final - cor2.nota_final) < pro.limite_nota_final ) or 

									-- **** testar se quando for dado situacao diferente de 1 se as situacoes discrepam
									(	(cor1.id_correcao_situacao <> 1 and cor2.id_correcao_situacao = cor1.id_correcao_situacao) or 
									    (cor1.id_correcao_situacao <> 2 and cor2.id_correcao_situacao = cor1.id_correcao_situacao)
									) or 

									-- **** testar caso a situacao for direrente de 1 as notas das competencias tem que ser zero (0)
									(cor1.id_correcao_situacao <> 1 and (cor1.nota_competencia1 <> 0 or cor1.nota_competencia2 <> 0 or cor1.nota_competencia3 <> 0 or cor1.nota_competencia4 <> 0 or cor1.nota_competencia5 <> 0)) or 
									(cor2.id_correcao_situacao <> 1 and (cor2.nota_competencia1 <> 0 or cor2.nota_competencia2 <> 0 or cor2.nota_competencia3 <> 0 or cor2.nota_competencia4 <> 0 or cor2.nota_competencia5 <> 0)) or 
									
									(COR1.ID IS NULL)     OR -- *** para existir fila3 deve exitir correcao (1,2)
									(COR2.ID IS NULL)     OR -- *** para existir fila3 deve exitir correcao (1,2)
									(COR3.ID IS NOT NULL) OR -- *** para existir fila3 nao deve exitir correcao 3
									(fils.FILA <> 3)		 -- *** para existir fila3 nao deve exitir fila	diferente de 3
								)  
				)
					  
					  ) -- final do pareteses do ABS

		from correcoes_fila3 fil3 
		 where fil3.redacao_id = @redacao_id  AND 
		       fil3.id_projeto = @ID_PROJETO

	end -- (FIM IF @FILA = 3)

--  ###################################################################################################################

-- *** CONSISTENCIA DA FILA 4 
--		VALIDAR SE NAO EXISTE INSERCAO EM OUTRA FILA
--		VALIDAR SE AS COMPETENCIAS VEZES O PESO E IGUAL A NOTA GRAVADA (1,2,3)
--		VALIDAR SE A NOTA FINAL E IGUAL AO SOMATORIO DAS NOTAS DE CADA COMPETENCIA
--		VALIDAR SE EXISTEM CORRECOES DE PRIMEIRA E SEGUNDA 
if (@FILA = 4)
	BEGIN
		update fil4 set fil4.consistido = abs(1 -
			(select COUNT(DISTINCT 1) 
			  FROM correcoes_fila4 FIL4 join projeto_projeto         pro  on (pro.id = FIL4.id_projeto) 
										join VW_FILAS_DA_REDACAO     fils on (FIL4.redacao_id  = fils.REDACAO_ID and FIL4.id_projeto = fils.id_projeto)
								   LEFT join correcoes_correcao      cor1 on (cor1.redacao_id = FIL4.redacao_id and cor1.id_tipo_correcao = 1 AND FIL4.id_PROJETO = COR1.ID_PROJETO ) 
								   LEFT join correcoes_correcao      cor2 on (cor2.redacao_id = FIL4.redacao_id and cor2.id_tipo_correcao = 2 AND FIL4.id_projeto = COR2.ID_PROJETO ) 
								   LEFT join correcoes_correcao      cor3 on (cor3.redacao_id = FIL4.redacao_id and cor3.id_tipo_correcao = 3 AND FIL4.id_projeto = COR3.ID_PROJETO ) 
								   LEFT join correcoes_correcao      cor4 on (cor4.redacao_id = FIL4.redacao_id and cor4.id_tipo_correcao = 4 AND FIL4.id_projeto = COR4.ID_PROJETO ) 
								   LEFT JOIN vw_redacao_equidistante EQU  ON (EQU.redacao_id  = fil4.redacao_id AND EQU.id_projeto = FIL4.id_projeto )
			 WHERE  
				   (	(fils.FILA <> 4) or -- *** nao pode existir fila diferente de 4 

						(COR1.ID IS  NULL)    OR  -- *** para existir fila4 e necessario que existam correcoes (1,2,3) 
						(COR2.ID IS  NULL)    OR  -- *** para existir fila4 e necessario que existam correcoes (1,2,3) 
						(COR3.ID IS  NULL)    OR  -- *** para existir fila4 e necessario que existam correcoes (1,2,3) 
						(COR4.ID IS NOT NULL) OR  -- *** testar se existe correcoes  em correcoes_correcao para tipo 4 

						-- **** testar se as notas da correcao1 estao corretas e se o somatorio das mesmas bate com a nota final 
						(cor1.id_correcao_situacao = 1 and 
							(isnull(cor1.competencia1,-5) * pro.peso_competencia <> cor1.nota_competencia1 or  
							 isnull(cor1.competencia2,-5) * pro.peso_competencia <> cor1.nota_competencia2 or  
							 isnull(cor1.competencia3,-5) * pro.peso_competencia <> cor1.nota_competencia3 or  
							 isnull(cor1.competencia4,-5) * pro.peso_competencia <> cor1.nota_competencia4 or  
							 case cor1.competencia5 when -1 then 0 else isnull(cor1.competencia5,-5) end * pro.peso_competencia <> cor1.nota_competencia5 or 
							 cor1.nota_final <> cor1.nota_competencia1 + cor1.nota_competencia2 + cor1.nota_competencia3 + cor1.nota_competencia4 + cor1.nota_competencia5)
						) or 

						-- **** testar se as notas da correcao2 estao corretas e se o somatorio das mesmas bate com a nota final 
						(cor2.id_correcao_situacao = 1 and 
							(isnull(cor2.competencia1,-5) * pro.peso_competencia <> cor2.nota_competencia1 or  
							 isnull(cor2.competencia2,-5) * pro.peso_competencia <> cor2.nota_competencia2 or  
							 isnull(cor2.competencia3,-5) * pro.peso_competencia <> cor2.nota_competencia3 or  
							 isnull(cor2.competencia4,-5) * pro.peso_competencia <> cor2.nota_competencia4 or  
							 case cor2.competencia5 when -1 then 0 else isnull(cor2.competencia5,-5) end * pro.peso_competencia <> cor2.nota_competencia5 or 
							 cor2.nota_final <> cor2.nota_competencia1 + cor2.nota_competencia2 + cor2.nota_competencia3 + cor2.nota_competencia4 + cor2.nota_competencia5)
						) or

					    -- **** testar se as notas da correcao3 estao corretas e se o somatorio das mesmas bate com a nota final 
						(cor3.id_correcao_situacao = 1 and 
							(isnull(cor3.competencia1,-5) * pro.peso_competencia <> cor3.nota_competencia1 or  
							 isnull(cor3.competencia2,-5) * pro.peso_competencia <> cor3.nota_competencia2 or  
							 isnull(cor3.competencia3,-5) * pro.peso_competencia <> cor3.nota_competencia3 or  
							 isnull(cor3.competencia4,-5) * pro.peso_competencia <> cor3.nota_competencia4 or  
							 case cor3.competencia5 when -1 then 0 else isnull(cor3.competencia5,-5) end * pro.peso_competencia <> cor3.nota_competencia5 or 
							 cor3.nota_final <> cor3.nota_competencia1 + cor3.nota_competencia2 + cor3.nota_competencia3 + cor3.nota_competencia4 + cor3.nota_competencia5)
						) OR 

						-- **** testar caso a situacao for direrente de 1 as notas das competencias tem que ser zero (0)
						(cor1.id_correcao_situacao <> 1 and (cor1.nota_competencia1 <> 0 or cor1.nota_competencia2 <> 0 or cor1.nota_competencia3 <> 0 or cor1.nota_competencia4 <> 0 or cor1.nota_competencia5 <> 0)) or 
						(cor2.id_correcao_situacao <> 1 and (cor2.nota_competencia1 <> 0 or cor2.nota_competencia2 <> 0 or cor2.nota_competencia3 <> 0 or cor2.nota_competencia4 <> 0 or cor2.nota_competencia5 <> 0)) or 
						(cor3.id_correcao_situacao <> 1 and (cor3.nota_competencia1 <> 0 or cor3.nota_competencia2 <> 0 or cor3.nota_competencia3 <> 0 or cor3.nota_competencia4 <> 0 or cor3.nota_competencia5 <> 0)) or
				        
						-- *** testar condicoes para estar na fila4 -* discrepancia da terceira coma primeira e segunda ou equidistante  
						-- *** equidistante
						(	(cor1.id_correcao_situacao = 1 and 
						     cor2.id_correcao_situacao = 1 and 
						     cor3.id_correcao_situacao = 1 and 
							 (abs(cor1.nota_final - cor3.nota_final) > pro.limite_nota_final OR  
							  abs(cor2.nota_final - cor3.nota_final) > pro.limite_nota_final) and 

							 EQU.redacao_id IS NOT NULL )
						) OR 

						-- *** SE NAO FOR EQUIDISTANTE DEVERA HAVER DISCREPANCIA ENTRE TERCEIRA COM COM PRIMEIRA E SEGUNDA
						(	(cor1.id_correcao_situacao <> 1 OR 
						     cor2.id_correcao_situacao <> 1 OR 
						     cor3.id_correcao_situacao <> 1) and 
							 EQU.redacao_id IS NULL and
							 (	(COR1.id_correcao_situacao = 1 AND 
							     COR3.id_correcao_situacao = 1 AND
							     abs(cor1.nota_final - cor3.nota_final) < pro.limite_nota_final)  OR
								(COR2.id_correcao_situacao = 1 AND 
							     COR3.id_correcao_situacao = 1 AND
							     abs(cor2.nota_final - cor3.nota_final) < pro.limite_nota_final)  OR 
								(cor1.id_correcao_situacao = cor3.id_correcao_situacao) OR
								(cor2.id_correcao_situacao = cor3.id_correcao_situacao)
							)
						)  

				   )
			)
				) -- final do pareteses do ABS
		from correcoes_fila4 fil4 
		 where fil4.redacao_id = @redacao_id  AND 
		       fil4.id_projeto = @ID_PROJETO
	END -- FIM FILA4

--  ###################################################################################################################			
			
-- *** AUDITORIA
	-- NOTA 1000
	-- PD TENDO UM PD -9
	-- DDH COMPETENCIA 5 = -1 - TENDO 1
if (@FILA = 7)
	BEGIN
		update filaud set filaud.consistido = abs(1 -
			(select COUNT(DISTINCT 1) 
			  FROM correcoes_filaauditoria AUD join projeto_projeto         pro    on (pro.id          = AUD.id_projeto) 
										       join VW_FILAS_DA_REDACAO     fils   on (AUD.redacao_id  = fils.REDACAO_ID and AUD.id_projeto = fils.id_projeto)
								          LEFT join correcoes_correcao      cor1   on (cor1.redacao_id = AUD.redacao_id and cor1.id_tipo_correcao = 1 AND AUD.id_PROJETO = COR1.ID_PROJETO ) 
								          LEFT join correcoes_correcao      cor2   on (cor2.redacao_id = AUD.redacao_id and cor2.id_tipo_correcao = 2 AND AUD.id_projeto = COR2.ID_PROJETO ) 
								          LEFT join correcoes_correcao      cor3   on (cor3.redacao_id = AUD.redacao_id and cor3.id_tipo_correcao = 3 AND AUD.id_projeto = COR3.ID_PROJETO ) 
								          LEFT join correcoes_correcao      cor4   on (cor4.redacao_id = AUD.redacao_id and cor4.id_tipo_correcao = 4 AND AUD.id_projeto = COR4.ID_PROJETO ) 
								          LEFT join correcoes_correcao      corAUD on (AUD.redacao_id  = corAUD.redacao_id and corAUD.id_tipo_correcao = 7 AND AUD.id_projeto = corAUD.ID_PROJETO ) 
								  
			 WHERE  AUD.redacao_id = @redacao_id and 
			        AUD.id_projeto = @ID_PROJETO and 
						-- **** nao pode existir em outras filas
					(	(fils.fila <> 7) or   
						-- **** parte desconectada
					    (	(aud.tipo_id = 2) and
							(	(cor1.id_correcao_situacao <> 9 and cor2.id_correcao_situacao <> 9) and                        -- *** pd na primeira ou segunda correcao
								(cor3.id is null and cor4.id is null)) or								                       -- *** pd na primeira ou segunda correcao
							(	(cor3.id_correcao_situacao <> 9 and  														   -- pd na terceira correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is null)) or  -- pd na terceira correcao
							(	(cor4.id_correcao_situacao <> 9 and  														   -- pd na quarta correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is not null)) -- pd na quarta correcao   
					    )  or 
						-- **** DDH 
						(	(aud.tipo_id = 3) and
							(	(cor1.competencia5 <> -1 and cor2.competencia5 <> -1) and                                      -- *** DDH na primeira ou segunda correcao
								(cor3.id is null and cor4.id is null)) or								                       -- *** DDH na primeira ou segunda correcao
							(	(cor3.competencia5 <> -1 and  														           -- DDH na terceira correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is null)) or  -- DDH na terceira correcao
							(	(cor4.competencia5 <> -1 and  															       -- DDH na quarta correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is not null)) -- DDH na quarta correcao   
					    ) or 
						-- **** NOTA MIL 
						(	(aud.tipo_id = 1) and
							(	(cor1.nota_final <> 1000 OR cor2.nota_final <> 1000) and                                       -- *** MIL na primeira ou segunda correcao
								(cor3.id is null and cor4.id is null)) or								                       -- *** MIL na primeira ou segunda correcao
							(	(((cor1.nota_final <> 1000 AND cor2.nota_final <> 1000) OR                                     -- *** MIL na primeira ou segunda com a terceira
							      (cor3.nota_final <> 1000)) and  				    			                               -- *** MIL na primeira ou segunda com a terceira
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is null)) or  -- MIL na terceira correcao
							(	(cor4.nota_final <> 1000 and  															       -- MIL na quarta correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is not null)) -- MIL na quarta correcao   
					    )					
					)
				)
			) -- final do pareteses do ABS
		from correcoes_filaauditoria filaud 
		 where filaud.redacao_id = @redacao_id  AND 
		       filaud.id_projeto = @ID_PROJETO
	END -- FIM FILAUD
	
--SELECT * FROM correcoes_correcao WHERE id_correcao_situacao = 9 and id_tipo_correcao = 4			
				
	--	SELECT id_tipo_correcao, * FROM correcoes_correcao WHERE redacao_id = @redacao_id	 ORDER BY 1 
	--	SELECT * FROM correcoes_filaauditoria WHERE redacao_id = @redacao_id	

 /*         
		  
     select * from correcoes_tipoauditoria                              
SELECT * FROM correcoes_fila4		
INSERT INTO correcoes_fila4 (corrigido_por, criado_em, id_correcao, id_grupo_corretor,id_projeto,co_barra_redacao,redacao_id)                      
select NULL, DBO.getlocaldate(), id, NULL, id_projeto, co_barra_redacao, redacao_id
from correcoes_correcao 
where id_tipo_correcao = 4 AND REDACAO_id = 270396

*/

-- validacao com 4
	-- finalizada

	-- nao finalizada

-- validacao auditoria
	-- finalizada

	-- nao finalizada

-- 

/*
select * from correcoes_correcao where  id_correcao_situacao <> 1 and 
  nota_competencia2 > 0

select * from correcoes_situacao

select * from correcoes_fila3
select *   from correcoes_fila4
select * from correcoes_filaauditoria
update correcoes_fila3 set consistido = null
update correcoes_filaauditoria set consistido = 0

insert into correcoes_fila4 (corrigido_por, criado_em, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, redacao_id)
select null, GETDATE(), null, null, 4, '029218100017848105',273456
*/



