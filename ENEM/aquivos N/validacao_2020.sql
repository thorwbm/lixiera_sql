select ine.redacao_id, errro = 1
from [dbo].[inep_n59_2020] ine with(nolock) 
 where --ine.lote_id in (select id from inep_lote where nome like '%20191108%') and
       not exists(select 1 from [EXT_CORRECOES_CORRECAO] cor 
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
select ine.redacao_id, errro = 2
from [dbo].[inep_n59_2020] ine with(nolock) 
 where --ine.lote_id in (select id from inep_lote where nome like '%20191108%') and
       NOT exists(select 1 from [EXT_CORRECOES_CORRECAO] cor 
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
select ine.redacao_id, errro = 3
from [dbo].[inep_n59_2020] ine with(nolock) 
 where --ine.lote_id in (select id from inep_lote where nome like '%20191108%') and
       NOT exists(select 1 from [EXT_CORRECOES_CORRECAO] cor 
                   where ine.redacao_id = cor.redacao_id and 
				         cor.id_tipo_correcao  = 3                     and 
				         isnull(ine.nu_nota_comp1_av3,-5) = isnull(cor.nota_competencia1,-5) and 
						 isnull(ine.nu_nota_comp2_av3,-5) = isnull(cor.nota_competencia2,-5) and 
						 isnull(ine.nu_nota_comp3_av3,-5) = isnull(cor.nota_competencia3,-5) and 
						 isnull(ine.nu_nota_comp4_av3,-5) = isnull(cor.nota_competencia4,-5) and 
						 isnull(ine.nu_nota_comp5_av3,-5) = isnull(cor.nota_competencia5,-5) and 
						 isnull(      ine.nu_nota_av3,-5) = isnull(       cor.nota_final,-5) AND 
						 ISNULL(     ine.nu_tempo_av3,-5) = ISNULL((CASE WHEN (cor.tempo_em_correcao) > 1200 THEN 1200 ELSE cor.tempo_em_correcao END),-5  )) AND
	ine.nu_cpf_av3 IS NOT NULL 
 UNION 
--***** 4 - VERIFICAR SE AS COMPETENCIAS QUE ESTAO NA N59 BATEM COM O VALOR DA CORRECAO (REDACAO NOTAFINAL)
select ine.redacao_id, errro = 4
from [dbo].[inep_n59_2020] ine with(nolock) 
 where --ine.lote_id in (select id from inep_lote where nome like '%20191108%') and
       NOT exists(select 1 from [EXT_CORRECOES_REDACAO] RED 
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
select ine.redacao_id, errro = 5 --, COR3.ID, COR2.ID, COR1.ID, ine.nu_nota_final, ine.nu_nota_av1,  ine.nu_nota_av2,  ine.nu_nota_av3, diferenca = ABS(ine.nu_nota_av1- ine.nu_nota_av2)
from [dbo].[inep_n59_2020] ine with(nolock) LEFT JOIN [ext_correcoes_correcao] cor1  ON (COR1.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR1.ID_TIPO_CORRECAO = 1 AND 
																									   COR1.ID_STATUS = 3)
									   LEFT JOIN [ext_correcoes_correcao] cor2  ON (COR2.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR2.ID_TIPO_CORRECAO = 2 AND 
																									   COR2.ID_STATUS = 3)
									   LEFT JOIN [ext_correcoes_correcao] cor3  ON (COR3.REDACAO_ID = ine.redacao_id AND 
                                                                                                       COR3.ID_TIPO_CORRECAO = 3 AND 
																									   COR3.ID_STATUS = 3)
  WHERE --ine.lote_id in (select id from inep_lote where nome like '%20191108%') and 
        ( ine.nu_nota_final IS NULL OR  
         ((COR3.ID IS NOT NULL AND  cor3.NOTA_FINAL <> ine.nu_nota_final) OR -- SE TIVER TERCEIRA A NOTA FINAL TEM QUE SER IGUAL 
		  (COR3.ID IS NULL AND COR2.ID IS NOT NULL AND COR1.ID IS NOT NULL AND ine.nu_nota_final <> ((COR2.NOTA_FINAL + COR1.NOTA_FINAL)/2)) OR -- SE SO TIVER PRIMEIRA E SEGUDA A NOTA FINAL TEM QUE SER A MEDIA
		  ((COR2.ID IS NULL OR COR1.ID IS NULL) AND ine.nu_nota_final IS NOT NULL)
		 )) and 
		 ine.co_situacao_redacao_final not in (4,8)

union 
-- ****** 6 - VERIFICA SE A NOTA FINAL DA REDACAO E IGUAL A NOTA FINAL DO ARQUIVO N59
-- ****** VERIFICA SE A NOTA DE CADA COMPETENCIA DA REDACAO E IGUAL A NOTA DE CADA COMPETENCIA DO ARQUIVO N59

select ine.redacao_id, errro = 6
from [dbo].[inep_n59_2020] ine with(nolock) LEFT JOIN [ext_correcoes_redacao] red  ON (red.id = ine.redacao_id )
  WHERE-- ine.lote_id in (select id from inep_lote where nome like '%20191108%') and 
        (ine.nu_nota_final      <> red.nota_final        or  
		ine.nu_nota_media_comp1 <> red.nota_competencia1 or  
		ine.nu_nota_media_comp2 <> red.nota_competencia2 or  
		ine.nu_nota_media_comp3 <> red.nota_competencia3 or  
		ine.nu_nota_media_comp4 <> red.nota_competencia4 or  
		ine.nu_nota_media_comp5 <> red.nota_competencia5)  