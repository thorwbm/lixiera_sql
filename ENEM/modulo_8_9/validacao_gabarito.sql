select *,
id_competencia1 * 40 as nota_1, 
id_competencia2 * 40 as nota_2, 
id_competencia3 * 40 as nota_3, 
id_competencia4 * 40 as nota_4, 
id_competencia5 * 40 as nota_5, 
nota_final
from correcoes_gabarito
where id_correcao_situacao = 1 and 
(id_competencia1 * 40  <> nota_competencia1  or 
id_competencia2 * 40 <> nota_competencia2  or 
id_competencia3 * 40 <> nota_competencia3  or 
id_competencia4 * 40 <> nota_competencia4  or 
id_competencia5 * 40 <> nota_competencia5  ) and 
nota_final <> (
id_competencia1 * 40 + 
id_competencia2 * 40 +
id_competencia3 * 40 +
id_competencia4 * 40 +
id_competencia5 * 40  )



select * from correcoes_redacao red join correcoes_gabarito gab on (gab.redacao_id = red.id)
where red.nota_final <> gab.nota_final or 
      red.nota_competencia1 <> gab.nota_competencia1 or 
      red.nota_competencia2 <> gab.nota_competencia2 or 
      red.nota_competencia3 <> gab.nota_competencia3 or 
      red.nota_competencia4 <> gab.nota_competencia4 or 
      red.nota_competencia5 <> gab.nota_competencia5 or 
	  red.id_correcao_situacao <> gab.id_correcao_situacao

