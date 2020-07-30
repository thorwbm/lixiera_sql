-- ******** INSERTE OURO NO BANCO
-- drop table #tmp_redacoes_ouro
select link_imagem_recortada = co_barra_redacao + '.tif', 
       link_imagem_original = co_barra_redacao + '.tif', 
	   comp1, comp2, comp3, comp4, comp5, nota, 
	   id_correcao_situacao = 1, 
	   co_barra_redacao, 
	   co_inscricao = substring(co_barra_redacao,charindex('181',co_barra_redacao),12),
	   co_formulario = left(co_barra_redacao,2), 
	   id_prova = substring(co_barra_redacao, 3, 1),
	   id_projeto = 4, 
	   id_redacaotipo = 2,
	   data_criacao = getdate(),
	   id_origem = 1, ordem
--into #tmp_redacoes_ouro   
 from (
select CO_BARRA_REDACAO = '181000001402051170234', COMP1 = 3, COMP2 = 	3, COMP3 = 	3, COMP4 = 	3, COMP5 = 	0, nota = 480.0, ordem =1  union
select CO_BARRA_REDACAO = '181000001600052040558', COMP1 = 3, COMP2 = 	3, COMP3 = 	3, COMP4 = 	3, COMP5 = 	2, nota = 560.0, ordem =2  union
select CO_BARRA_REDACAO = '181000002632051295993', COMP1 = 3, COMP2 = 	3, COMP3 = 	3, COMP4 = 	3, COMP5 = 	0, nota = 480.0, ordem =3  union
select CO_BARRA_REDACAO = '181000002830050965008', COMP1 = 3, COMP2 = 	3, COMP3 = 	3, COMP4 = 	3, COMP5 = 	2, nota = 560.0, ordem =4  union
select CO_BARRA_REDACAO = '181000004661051072781', COMP1 = 3, COMP2 = 	1, COMP3 = 	1, COMP4 = 	2, COMP5 = 	1, nota = 320.0, ordem =5  union
select CO_BARRA_REDACAO = '181000024800050981526', COMP1 = 4, COMP2 = 	5, COMP3 = 	4, COMP4 = 	4, COMP5 = 	4, nota = 840.0, ordem =6  
) as tab  order by ordem



 -- insert into correcoes_redacaoouro (link_imagem_recortada, link_imagem_original, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5, nota_final, 
    id_correcao_situacao, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaotipo, data_criacao, id_origem)
  select link_imagem_recortada, link_imagem_original, comp1, comp2, comp3, comp4, comp5, nota, 
    id_correcao_situacao, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaotipo, data_criacao from #tmp_redacoes_ouro 
  order by ordem



select nota_competencia1, *  from correcoes_redacaoouro where data_criacao > '2018-12-03 23:00'

---- ****** CALCULA AS NOTAS 
UPDATE correcoes_redacaoouro SET
       link_imagem_recortada = 'ouro/' + co_barra_redacao + '.gif', 
       link_imagem_original  = 'ouro/' + co_barra_redacao + '.gif', 
       nota_competencia1 = id_competencia1 * 40,
       nota_competencia2 = id_competencia2 * 40,
       nota_competencia3 = id_competencia3 * 40,
       nota_competencia4 = id_competencia4 * 40,
       nota_competencia5 = id_competencia5 * 40
 where data_criacao > '2018-12-03 23:00'
-- **** verifica se estao com notas corretas 
SELECT * FROM correcoes_redacaoouro 
WHERE nota_competencia1 + nota_competencia2 + nota_competencia3 + nota_competencia4 + nota_competencia5 <> NOTA_FINAL



/**********************************************
       CARGA NA TABELA CORRECOES_REDACAO
	   COM O CODIGO DE BARRA NOVO
***********************************************/
 drop table #tmp_correcoes_redacao
 --  ########################################################################################################################################################

-- **** inserir na tabela redacao as redacoes ouro para o candidato 
	 select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
	        co_barra_redacao = '001' + right('000000' +convert(varchar(6),our.id),6) + right('000000' +convert(varchar(6),cor.id),6),
	        co_inscricao     = '001' + right('000000' +convert(varchar(6),our.id),6) + right('000000' +convert(varchar(6),cor.id),6),
	        co_formulario,id_prova, id_projeto,our.id, id_corretor = cor.id
	   into #tmp_correcoes_redacao
	   from correcoes_redacaoouro OUR join correcoes_corretor cor on (1=1)
	                                  join projeto_projeto_usuarios usu on (cor.id = usu.user_id)
		where data_criacao >  '2018-12-03 23:00' and  
		      id_redacaotipo = 2 and 
		      usu.projeto_id = 4 and 
		      our.id_redacaotipo = 2 and 
		      usu.user_id in (select usuario_id from vw_usuario_hierarquia
			                   where perfil in ('AUXILIAR', 'avaliador') and id_projeto = usu.projeto_id )
	  order by co_barra_redacao

	  select * from #tmp_correcoes_redacao
	  SELECT COUNT(*) FROM vw_usuario_hierarquia 
	  WHERE perfil in ('AUXILIAR', 'avaliador') and PROJETO_ID = 4

select * from #tmp_correcoes_redacao
	  -- *** inserir na tabela redacao com o codigo de barra alterado para o padrao moda ou ouro dependendo do tipo_redacao escolhido e levando o id da redacao referencia 
	--insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
	select top 5000 link_imagem_recortada, link_imagem_original, nota_final = null, 1, 
		   co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
	  from #tmp_correcoes_redacao tmp
	 where not exists (select top 1 1 from correcoes_redacao redx 
	                    where redx.co_barra_redacao = tmp.co_barra_redacao AND
						      REDX.id_projeto = TMP.id_projeto)


	--- INSERE NA CORRECOES GABARITO
	-- insert correcoes_gabarito (nota_final, id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
		   nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5, co_barra_redacao)
	select our.nota_final, our.id_correcao_situacao, OUR.id_competencia1, OUR.id_competencia2, OUR.id_competencia3, OUR.id_competencia4, OUR.id_competencia5,
		   OUR.nota_competencia1, OUR.nota_competencia2, OUR.nota_competencia3, OUR.nota_competencia4, OUR.nota_competencia5,
		   red.co_barra_redacao
	 frOM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
	 where not exists (select 1 from correcoes_gabarito gabx
	                    where gabx.co_barra_redacao = red.co_barra_redacao) and
		   our.id_projeto = 4
		   and data_criacao > '2018-12-03 23:00'



	-- **** inserir na tabela filaOURO
	-- **** select * from correcoes_filaouro where posicao is null 
	insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto, criado_em)
	SELECT top 5000 tem.co_barra_redacao, tem.id_corretor, null, tem.id_projeto, GETDATE()
	  FROM #tmp_correcoes_redacao tem
	 where not exists (select top 1 1 from correcoes_filaouro flox 
						where flox.co_barra_redacao = tem.co_barra_redacao and 
							  flox.id_corretor      = tem.id_corretor AND 
							  FLOX.id_projeto       = 4)
 and data_criacao > '2018-12-03 23:00'

 
  -- ***** monto a ordenacao de busca das redacoes para o busca mais um 

 declare @id_corretor int 
 declare @id_projeto  int
 declare CUR_DIS_ORD_OUR_MOD cursor for 
	   select id_corretor, id_projeto from correcoes_filaouro where posicao is null 
	open CUR_DIS_ORD_OUR_MOD 
		fetch next from CUR_DIS_ORD_OUR_MOD into @id_corretor, @id_projeto
		while @@FETCH_STATUS = 0
			BEGIN
				 exec sp_distribuir_ordem  @id_corretor, @id_projeto, 2

			fetch next from CUR_DIS_ORD_OUR_MOD into @id_corretor, @id_projeto
			END
	close CUR_DIS_ORD_OUR_MOD 
deallocate CUR_DIS_ORD_OUR_MOD 


