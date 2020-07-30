

--------------------------------------------------------------------------------------------------------------------------------------------
-- VALIDAÇÕES
--------------------------------------------------------------------------------------------------------------------------------------------
 --Verifica se existe redação sem nota
--RESULTADO ESPERADO: Não trazer registros
select * from vw_tabelas where nota_final is null

 --Verifica se existe redação sem situação
--RESULTADO ESPERADO: Não trazer registros
select * from vw_tabelas where id_correcao_situacao is null

--Verifica se existe redação sem a primeira correção
--RESULTADO ESPERADO: Não trazer registros
select * from vw_tabelas where id_avaliador_ava1 is null

--Verifica se existe redação sem a segunda correção
--RESULTADO ESPERADO: Não trazer registros
select * from vw_tabelas where id_avaliador_ava2 is null

--Verifica se a média das notas está correta, para as redacoes que não possuem terceiras redações
--RESULTADO ESPERADO: Não trazer registros
select sg_uf_prova, data_termino, co_barra_redacao, nota_final_ava1, nota_final_ava2, nota_final, nota_final_avaa, *
  from vw_tabelas
 where id_avaliador_ava3 is null
   and id_avaliador_avaa is null
   and nota_final <> (nota_final_ava1 + nota_final_ava2) / 2


--Verifica se a média das notas está correta, para as redacoes que possuem terceiras correções e aproximaram de uma correção
--RESULTADO ESPERADO: Não trazer registros
select tabela, sg_uf_prova, data_termino, co_barra_redacao, nota_final_ava1, nota_final_ava2, nota_final_ava3, nota_final_ava4, nota_final_avaa, nota_final, *
  from vw_tabelas
 where id_avaliador_ava3 is not null and id_avaliador_ava4 is null
   and id_avaliador_avaa is null
   and (nota_final <> (nota_final_ava1 + nota_final_ava3) / 2) and (nota_final <> (nota_final_ava2 + nota_final_ava3) / 2)


--Verifica se alguma redação que está considerada como final, mas possui pendências de correção
--RESULTADO ESPERADO: 0
select count(*)
  from entregas_regular.dbo.vw_tabelas red
 where exists (select top 1 1 from correcao_redacao_regular_09122018.dbo.correcoes_fila1 tab where tab.co_barra_redacao = red.co_barra_redacao)
   and exists (select top 1 1 from correcao_redacao_regular_09122018.dbo.correcoes_fila2 tab where tab.co_barra_redacao = red.co_barra_redacao)
   and exists (select top 1 1 from correcao_redacao_regular_09122018.dbo.correcoes_fila3 tab where tab.co_barra_redacao = red.co_barra_redacao)
   and exists (select top 1 1 from correcao_redacao_regular_09122018.dbo.correcoes_fila4 tab where tab.co_barra_redacao = red.co_barra_redacao)
   and exists (select top 1 1 from correcao_redacao_regular_09122018.dbo.correcoes_filaauditoria tab where tab.co_barra_redacao = red.co_barra_redacao)
   and exists (select top 1 1 from correcao_redacao_regular_09122018.dbo.correcoes_correcao tab where tab.co_barra_redacao = red.co_barra_redacao and data_termino is null)


--Verifica se todas as redações onde a diferença da nota da prova1 e da prova2 é > 100 e não possui terceira
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where abs(nota_final_ava1 - nota_final_ava2) > 100 and id_avaliador_ava3 is null and comp5_ava1 != -1 and comp5_ava2 != -1 and id_situacao_ava1 != 9 and id_situacao_ava2 != 9


-------------------------------------------------------------------------------------------
---REGRAS DE QUARTA
-------------------------------------------------------------------------------------------
--Verifica se a nota das redações que possuem quarta, está igual a nota da quarta correção. Desde que não exista auditoria.
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where id_avaliador_ava4 is not null and id_avaliador_avaa is null and nota_final <> nota_final_ava4


--Verifica se as notas finais das competências das redações que possuem quarta batem com as notas das competencias de quarta
--RESULTADO ESPERADO: 0
select count(*)
  from vw_tabelas
 where id_avaliador_ava4 is not null and id_avaliador_avaa is null
   and (nota_comp1_ava4 <> nota_comp1 or nota_comp2_ava4 <> nota_comp2 or nota_comp3_ava4 <> nota_comp3 or nota_comp4_ava4 <> nota_comp4 or nota_comp5_ava4 <> nota_comp5)


--Verifica se existe quarta respondida junto com auditoria
--RESULTADO ESPERADO: Não trazer registros
select co_barra_redacao, * 
--select tabela, count(*)
 from vw_tabelas tab
where id_avaliador_ava4 is not null and id_avaliador_avaa is not null and id_avaliador_ava3 is not null
  and (nota_final = 1000 or (comp5_ava1 = -1 or comp5_ava2 = -1 or isnull(comp5_ava3, 0) = -1 or (id_situacao_ava1 = 9 or id_situacao_ava2 = 9 or isnull(id_situacao_ava3, 0) = 9) ))
  and ((abs(nota_final_ava3   - nota_final_ava2  ) > 100 or
	  abs(comp1_ava3 - comp1_ava2) > 2   or 
	  abs(comp2_ava3 - comp2_ava2) > 2   or 
	  abs(comp3_ava3 - comp3_ava2) > 2   or 
	  abs(comp4_ava3 - comp4_ava2) > 2   or 
	  abs(comp5_ava3 - comp5_ava2) > 2   or
		(id_situacao_ava3 <> id_situacao_ava2)) and 
		abs(nota_final_ava3   - nota_final_ava1  ) > 100 or
	  abs(comp1_ava3 - comp1_ava1) > 2   or 
	  abs(comp2_ava3 - comp2_ava1) > 2   or 
	  abs(comp3_ava3 - comp3_ava1) > 2   or 
	  abs(comp4_ava3 - comp4_ava1) > 2   or 
	  abs(comp5_ava3 - comp5_ava1) > 2   or
		(id_situacao_ava3 <> id_situacao_ava1))
group by tabela



--Verifica se existe quarta gerada sem necessidade
--RESULTADO ESPERADO: Não trazer registros
select *
--select tabela, count(*)
 from vw_tabelas tab
where id_avaliador_ava4 is not null and id_avaliador_avaa is null and id_avaliador_ava3 is not null
  and not (((abs(nota_final_ava3   - nota_final_ava2  ) > 100 or
	  abs(comp1_ava3 - comp1_ava2) > 2   or 
	  abs(comp2_ava3 - comp2_ava2) > 2   or 
	  abs(comp3_ava3 - comp3_ava2) > 2   or 
	  abs(comp4_ava3 - comp4_ava2) > 2   or 
	  abs(comp5_ava3 - comp5_ava2) > 2   or
		(id_situacao_ava3 <> id_situacao_ava2)) and 
		abs(nota_final_ava3   - nota_final_ava1  ) > 100 or
	  abs(comp1_ava3 - comp1_ava1) > 2   or 
	  abs(comp2_ava3 - comp2_ava1) > 2   or 
	  abs(comp3_ava3 - comp3_ava1) > 2   or 
	  abs(comp4_ava3 - comp4_ava1) > 2   or 
	  abs(comp5_ava3 - comp5_ava1) > 2   or
		(id_situacao_ava3 <> id_situacao_ava1)))

		 
--Verifica se existe quarta respondida junto com auditoria
--RESULTADO ESPERADO: Não trazer registros
select co_barra_redacao, * 
--select tabela, count(*)
 from vw_tabelas tab
where id_avaliador_ava4 is not null and id_avaliador_avaa is not null and id_avaliador_ava3 is not null
  and (nota_final = 1000 or (comp5_ava1 = -1 or comp5_ava2 = -1 or isnull(comp5_ava3, 0) = -1 or (id_situacao_ava1 = 9 or id_situacao_ava2 = 9 or isnull(id_situacao_ava3, 0) = 9) ))
  and ((abs(nota_final_ava3   - nota_final_ava2  ) > 100 or
	  abs(comp1_ava3 - comp1_ava2) > 2   or 
	  abs(comp2_ava3 - comp2_ava2) > 2   or 
	  abs(comp3_ava3 - comp3_ava2) > 2   or 
	  abs(comp4_ava3 - comp4_ava2) > 2   or 
	  abs(comp5_ava3 - comp5_ava2) > 2   or
		(id_situacao_ava3 <> id_situacao_ava2)) and 
		abs(nota_final_ava3   - nota_final_ava1  ) > 100 or
	  abs(comp1_ava3 - comp1_ava1) > 2   or 
	  abs(comp2_ava3 - comp2_ava1) > 2   or 
	  abs(comp3_ava3 - comp3_ava1) > 2   or 
	  abs(comp4_ava3 - comp4_ava1) > 2   or 
	  abs(comp5_ava3 - comp5_ava1) > 2   or
		(id_situacao_ava3 <> id_situacao_ava1))
group by tabela



--Verifica se existe quarta gerada com equidistância
--RESULTADO ESPERADO: (em avaliação)
select data_termino, tabela, nota_final_ava1, nota_final_ava2, nota_final_ava3, nota_final_ava4
  from vw_tabelas tab 
 where id_avaliador_ava4 is not null
   and id_avaliador_avaa is null
   and id_situacao_ava3 = 1
   and id_situacao_ava2 = 1
   and id_situacao_ava1 = 1
   and abs(nota_final_ava3 - nota_final_ava1) = abs(nota_final_ava3 - nota_final_ava2) --and (nota_final_ava1 = nota_final_ava2)

   
-- **** wemerson
/* verifica se redacoes que possuem 4ª e auditoria e a nota final seja diferente da auditoria */
--RESULTADO ESPERADO: (ZERO)
select * from vw_tabelas tab with (nolock) 
 where ID_AVALIADOR_AVA4 is not null and ID_AVALIADOR_AVAA is not null and (nota_final <> NOTA_FINAL_AVAA OR ID_SITUACAO_AVAA <> id_correcao_situacao)

 
-- **** wemerson
/* verifica se redacoes que possuem 4ª como final e a nota final seja diferente da 4ª */
--RESULTADO ESPERADO: (ZERO)
select * from vw_tabelas tab with (nolock) 
 where ID_AVALIADOR_AVA4 is not null and ID_AVALIADOR_AVAA is null and  -- finaliza na quarta
 (nota_final <> NOTA_FINAL_AVA4 )

 -- **** wemerson
 /* verifica se redacoes que deveriam ter 4ª mas nao possuem  */
--RESULTADO ESPERADO: (ZERO)
select * from vw_tabelas tab with (nolock) 
 where ID_AVALIADOR_AVA4 is null and
       ID_AVALIADOR_AVAA IS NULL AND 
       ID_AVALIADOR_AVA3 IS NOT NULL AND 
       (abs(NOTA_FINAL_AVA3 - NOTA_FINAL_AVA1) > 100 OR 
	    ABS(NOTA_COMP1_AVA3 - NOTA_COMP1_AVA1) >  80 OR 
	    ABS(NOTA_COMP2_AVA3 - NOTA_COMP2_AVA1) >  80 OR 
	    ABS(NOTA_COMP3_AVA3 - NOTA_COMP3_AVA1) >  80 OR 
	    ABS(NOTA_COMP4_AVA3 - NOTA_COMP4_AVA1) >  80 OR 
	    ABS(NOTA_COMP5_AVA3 - NOTA_COMP5_AVA1) >  80 OR 
	 	   ID_SITUACAO_AVA3 <> ID_SITUACAO_AVA1)  AND 
       (abs(NOTA_FINAL_AVA3 - NOTA_FINAL_AVA2) > 100 OR 
	    ABS(NOTA_COMP1_AVA3 - NOTA_COMP1_AVA2) >  80 OR 
	    ABS(NOTA_COMP2_AVA3 - NOTA_COMP2_AVA2) >  80 OR 
	    ABS(NOTA_COMP3_AVA3 - NOTA_COMP3_AVA2) >  80 OR 
	    ABS(NOTA_COMP4_AVA3 - NOTA_COMP4_AVA2) >  80 OR 
	    ABS(NOTA_COMP5_AVA3 - NOTA_COMP5_AVA2) >  80 OR 
	 	   ID_SITUACAO_AVA3 <> ID_SITUACAO_AVA2) 



--Verifica se não existe quarta gerada com equidistância
--RESULTADO ESPERADO: (em avaliação)
select data_termino, tabela, nota_final_ava1, nota_final_ava2, nota_final_ava3, nota_final_ava4, abs(nota_final_ava3 - nota_final_ava1) as dif_ava1, abs(nota_final_ava3 - nota_final_ava2) as dif_ava2
/*
select 'insert into ' + replace(tabela, '_005', '_007') + ' select * from ' + tabela + ' where co_barra_redacao = ''' + co_barra_redacao + ''''
  from vw_tabelas tab
 where id_avaliador_ava4 is not null
   and id_avaliador_ava3 is not null
   and id_avaliador_avaa is null
   and id_situacao_ava3 = 1
   and id_situacao_ava2 = 1
   and id_situacao_ava1 = 1
   and abs(nota_final_ava3 - nota_final_ava1) = abs(nota_final_ava3 - nota_final_ava2) --and (nota_final_ava1 = nota_final_ava2)

*/


   



--Verifica se todas as redações onde a diferença das competências é > 80 e não possui terceira
--RESULTADO ESPERADO: Não trazer registros
--TODO: FINALIZAR ESSE SQL AINDA, ESTÁ INCOMPLETO
/*
select count(*) from vw_tabelas
 where id_avaliador_ava4 is not null
   and (abs(comp1_ava3 - comp1_ava2) > 2
        or abs(comp2_ava3 - comp2_ava2) > 2
        or abs(comp3_ava3 - comp3_ava2) > 2
        or abs(comp4_ava3 - comp4_ava2) > 2
        or abs(comp5_ava3 - comp5_ava2) > 2)
   and (abs(comp1_ava1 - comp1_ava3) > 2
        or abs(comp2_ava1 - comp2_ava3) > 2
        or abs(comp3_ava1 - comp3_ava3) > 2
        or abs(comp4_ava1 - comp4_ava3) > 2
        or abs(comp5_ava1 - comp5_ava3) > 2)
*/
-------------------------------------------------------------------------------------------




-------------------------------------------------------------------------------------------
---REGRAS DE AUDITORIAS
-------------------------------------------------------------------------------------------
--Verifica se a nota das redações que possuem auditoria, está igual a nota da auditoria.
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where id_avaliador_avaa is not null and nota_final <> nota_final_avaa


--Verifica se todas as redações onde foi marcado DDH ou PD na primeira, segunda, terceira ou quarta possui auditoria
--RESULTADO ESPERADO: Não trazer registros
select count(*) 
--select *
  from vw_tabelas
 where ((comp5_ava1 = -1 or comp5_ava2 = -1 or isnull(comp5_ava3, 0) = -1 or isnull(comp5_ava4, 0) = -1) or (id_situacao_ava1 = 9 or id_situacao_ava2 = 9 or isnull(id_situacao_ava3, 0) = 9 or isnull(id_situacao_ava4, 0) = 9))
   and id_avaliador_avaa is null

--Verifica se todas as redações que possuem nota 1000 na primeira e segunda correção possuem também auditoria
--RESULTADO ESPERADO: Não trazer registros
select * from vw_tabelas where nota_final_ava1 = 1000 and nota_final_ava2 = 1000 and id_avaliador_avaa is null

--Verifica se todas as redações que possuem nota 1000 na primeira e segunda correção possuem também auditoria
--RESULTADO ESPERADO: Não trazer registros
select * from vw_tabelas where ((nota_final_ava3 = 1000 and nota_final_ava1 = 1000) or (nota_final_ava3 = 1000 and nota_final_ava2 = 1000)) and id_avaliador_avaa is null


--Verifica se todas as redações que possuem nota 1000 na quarta correção possuem auditoria
--RESULTADO ESPERADO: Não trazer registros
select * from vw_tabelas where nota_final_ava4 = 1000 and id_avaliador_avaa is null


--Verifica se todas as redações que possuem nota 1000 na nota final possuem auditoria
--RESULTADO ESPERADO: Não trazer registros
select * from vw_tabelas where nota_final = 1000 and id_avaliador_avaa is null


--Verifica se todas as auditorias geradas estão atendendo os critérios de auditoria
--RESULTADO ESPERADO: 0
select (
select count(*) from vw_tabelas
 where ((comp5_ava1 = -1 or comp5_ava2 = -1 or isnull(comp5_ava3, 0) = -1 or isnull(comp5_ava4, 0) = -1) or (id_situacao_ava1 = 9 or id_situacao_ava2 = 9 or isnull(id_situacao_ava3, 0) = 9 or isnull(id_situacao_ava4, 0) = 9))
   and id_avaliador_avaa is not null
)+(
--Verifica se todas as redações que possuem nota 1000 na primeira e segunda correção possuem também auditoria
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where nota_final_ava1 = 1000 and nota_final_ava2 = 1000 and id_avaliador_ava3 is null and id_avaliador_avaa is not null
)+(
--Verifica se todas as redações que possuem nota 1000 na primeira e segunda correção possuem também auditoria
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where ((nota_final_ava3 = 1000 and nota_final_ava1 = 1000) or (nota_final_ava3 = 1000 and nota_final_ava2 = 1000)) and id_avaliador_ava3 is not null and id_avaliador_avaa is not null
)+(
--Verifica se todas as redações que possuem nota 1000 na quarta correção possuem auditoria
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where id_avaliador_ava4 is not null and nota_final_ava4 = 1000 and id_avaliador_avaa is not null
) - (
select count(*) from vw_tabelas where id_avaliador_avaa is not null
)


--Verifica se todas as redações nota 1000 possuem auditoria
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where nota_final = 1000 and id_avaliador_avaa is null


--Verifica todas as redações que possuem situações diferentes entre as duas primeiras e não possuem terceira correção, caso a situação não seja PD
--RESULTADO ESPERADO: 0
select count(*) from vw_tabelas where id_situacao_ava1 <> id_situacao_ava2 and id_avaliador_ava3 is null and id_situacao_ava1 <> 9 and id_situacao_ava2 <> 9
-------------------------------------------------------------------------------------------


--Verifica se todas as redações onde a diferença das competências é > 80 e não possui terceira
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas
 where id_avaliador_ava3 is null
   and (abs(comp1_ava1 - comp1_ava2) > 2
        or abs(comp2_ava1 - comp2_ava2) > 2
        or abs(comp3_ava1 - comp3_ava2) > 2
        or abs(comp4_ava1 - comp4_ava2) > 2
        or abs(comp5_ava1 - comp5_ava2) > 2)


--Verifica se todas as redações onde a diferença das competências é <= 80 e possui terceira
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas
 where id_avaliador_ava3 is not null
   and abs(comp1_ava1 - comp1_ava2) <= 2
   and abs(comp2_ava1 - comp2_ava2) <= 2
   and abs(comp3_ava1 - comp3_ava2) <= 2
   and abs(comp4_ava1 - comp4_ava2) <= 2
   and abs(comp5_ava1 - comp5_ava2) <= 2
   and abs(nota_final_ava1 - nota_final_ava2) <= 100
   and id_situacao_ava1 = id_situacao_ava2



--Verifica se existem redaçoes com situação = 1 (normal) e nota = 0 
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where (id_situacao_ava1 = 1 and nota_final_ava1 = 0) or (id_situacao_ava2 = 1 and nota_final_ava2 = 0)


--Verifica se existem redaçoes com nota e situação nula
--RESULTADO ESPERADO: Não trazer registros
select count(*) from vw_tabelas where nota_final is not null and id_correcao_situacao is null


--Verifica se uma redação foi corrigida pelo mesmo avaliador mais de uma vez
--RESULTADO ESPERADO: 0
select count(*) from vw_tabelas where id_avaliador_ava1 = id_avaliador_ava2 or isnull(id_avaliador_ava3, 0) = id_avaliador_ava1  or isnull(id_avaliador_ava3, 0) = id_avaliador_ava2


--Verifica se a nota da redação bate com a nota baseada nas marcações
--RESULTADO ESPERADO: 0
select count(*)
  from vw_tabelas
 where ((nota_comp1_ava1 + nota_comp2_ava1 + nota_comp3_ava1 + nota_comp4_ava1 + nota_comp5_ava1) <> nota_final_ava1)
       or (nota_comp1_ava2 + nota_comp2_ava2 + nota_comp3_ava2 + nota_comp4_ava2 + nota_comp5_ava2) <> nota_final_ava2
	   or (id_avaliador_ava3 is not null and ((nota_comp1_ava3 + nota_comp2_ava3 + nota_comp3_ava3 + nota_comp4_ava3 + nota_comp5_ava3) <> nota_final_ava3))
	   or (id_avaliador_ava4 is not null and ((nota_comp1_ava4 + nota_comp2_ava4 + nota_comp3_ava4 + nota_comp4_ava4 + nota_comp5_ava4) <> nota_final_ava4))
	   or (id_avaliador_avaa is not null and ((nota_comp1_avaa + nota_comp2_avaa + nota_comp3_avaa + nota_comp4_avaa + nota_comp5_avaa) <> nota_final_avaa))


--Verifica correções que estão anuladas (possuem situação <> 1), mas possuem nota > 0
--RESULTADO ESPERADO: 0
select count(*)
  from vw_tabelas
 where (id_situacao_ava1 <> 1 and nota_final_ava1 > 0) or (id_situacao_ava2 <> 1 and nota_final_ava2 > 0)
        or (id_avaliador_ava3 is not null and (id_situacao_ava3 <> 1 and nota_final_ava3 > 0))
        or (id_avaliador_ava4 is not null and (id_situacao_ava4 <> 1 and nota_final_ava4 > 0))
        or (id_avaliador_avaa is not null and (id_situacao_avaa <> 1 and nota_final_avaa > 0))



--Verifica se existem correções com data de termino menor que data de início
--RESULTADO ESPERADO: 0
select count(*)
  from vw_tabelas
 where (data_termino_ava1 < data_inicio_ava1) or (data_termino_ava2 < data_inicio_ava2)
    or (id_avaliador_ava3 is not null and (data_termino_ava3 < data_inicio_ava3))
    or (id_avaliador_ava4 is not null and (data_termino_ava4 < data_inicio_ava4))
    or (id_avaliador_avaa is not null and (data_termino_avaa < data_inicio_avaa))

--------------------------------------------------------------------------------------------
-- validacoes extras wemerson
--------------------------------------------------------------------------------------------
 -- **** wemerson
/* verifica se redacoes posseuem somatorio de nota diferente da nota final  */
--RESULTADO ESPERADO: (ZERO)
select * from vw_tabelas tab with (nolock) 
 where (((NOTA_COMP1_AVA1 + NOTA_COMP2_AVA1 + NOTA_COMP3_AVA1 + NOTA_COMP4_AVA1 + NOTA_COMP5_AVA1) <> NOTA_FINAL_AVA1) or
        ((NOTA_COMP1_AVA2 + NOTA_COMP2_AVA2 + NOTA_COMP3_AVA2 + NOTA_COMP4_AVA2 + NOTA_COMP5_AVA2) <> NOTA_FINAL_AVA2) or
        ((NOTA_COMP1_AVA3 + NOTA_COMP2_AVA3 + NOTA_COMP3_AVA3 + NOTA_COMP4_AVA3 + NOTA_COMP5_AVA3) <> NOTA_FINAL_AVA3) or
        ((NOTA_COMP1_AVA4 + NOTA_COMP2_AVA4 + NOTA_COMP3_AVA4 + NOTA_COMP4_AVA4 + NOTA_COMP5_AVA4) <> NOTA_FINAL_AVA4) or
        ((NOTA_COMP1_AVAA + NOTA_COMP2_AVAA + NOTA_COMP3_AVAA + NOTA_COMP4_AVAA + NOTA_COMP5_AVAA) <> NOTA_FINAL_AVAA))