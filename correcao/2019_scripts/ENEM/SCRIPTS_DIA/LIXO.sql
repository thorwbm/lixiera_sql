select gab.*
/*
BEGIN TRAN
 update gab set gab.nota_competencia1 = gab.id_competencia1 * 50,
                gab.nota_competencia2 = gab.id_competencia2 * 50, 
                gab.nota_competencia3 = gab.id_competencia3 * 50, 
                gab.nota_competencia4 = gab.id_competencia4 * 50 
  */             
 from correcoes_gabarito gab join correcoes_redacao red on (gab.redacao_id = red.id)
where id_projeto in (1,2,3) and 
      nota_competencia1 + nota_competencia2 + nota_competencia3 + nota_competencia4 <> GAB.nota_final


	  COMMIT 

