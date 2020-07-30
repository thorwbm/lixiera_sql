select top 1000  red.id,
        nota1 = (nota_competencia1_A + nota_competencia1_B)/2.0,
        nota2 = (nota_competencia2_A + nota_competencia2_B)/2.0,
        nota3 = (nota_competencia3_A + nota_competencia3_B)/2.0,
        nota4 = (nota_competencia4_A + nota_competencia4_B)/2.0,
        nota5 = (nota_competencia5_A + nota_competencia5_B)/2.0,
        nota_final_ana = (ana.nota_final_A + nota_final_b)/2.0, 
		red.nota_final

/*update red set red.nota_competencia1 = (nota_competencia1_A + nota_competencia1_B)/2.0,
               red.nota_competencia2 = (nota_competencia2_A + nota_competencia2_B)/2.0,
               red.nota_competencia3 = (nota_competencia3_A + nota_competencia3_B)/2.0,
               red.nota_competencia4 = (nota_competencia4_A + nota_competencia4_B)/2.0,
               red.nota_competencia5 = (nota_competencia5_A + nota_competencia5_B)/2.0*/
from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id)
where ana.id_tipo_correcao_B = 2 and conclusao_analise <= 2 and 
      red.nota_competencia1 is null and 
      red.nota_competencia1 is null and 
	  red.nota_competencia2 is null and 
	  red.nota_competencia3 is null and 
	  red.nota_competencia4 is null and 
	  red.nota_competencia5 is null 

select top 1000  red.id,
        nota1 = (nota_competencia1_A + nota_competencia1_B)/2.0,
        nota2 = (nota_competencia2_A + nota_competencia2_B)/2.0,
        nota3 = (nota_competencia3_A + nota_competencia3_B)/2.0,
        nota4 = (nota_competencia4_A + nota_competencia4_B)/2.0,
        nota5 = (nota_competencia5_A + nota_competencia5_B)/2.0,
        nota_final_ana = (ana.nota_final_A + nota_final_b)/2.0, 
		red.nota_final

/*update red set red.nota_competencia1 = nota_competencia1_B,
                 red.nota_competencia2 = nota_competencia2_B,
                 red.nota_competencia3 = nota_competencia3_B,
                 red.nota_competencia4 = nota_competencia4_B,
                 red.nota_competencia5 = nota_competencia5_B*/
from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id)
where ana.id_tipo_correcao_B = 3 and 
      red.nota_competencia1 is null and 
	  red.nota_competencia2 is null and 
	  red.nota_competencia3 is null and 
	  red.nota_competencia4 is null and 
	  red.nota_competencia5 is null 


select COUNT(distinct red.id), 'total' from correcoes_redacao red 

select distinct red.id, 'nao corrigidas' from correcoes_redacao red where nota_competencia1 is null 

select COUNT(distinct red.id), 'segundas' from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id)
where ana.id_tipo_correcao_B = 2 and conclusao_analise <= 2

select COUNT(distinct red.id), 'terceiras' from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id)
where ana.id_tipo_correcao_B = 3



select 

select  * from correcoes_situacao
select * from correcoes_redacao where nota_competencia2 is null

select id_status, redacao_id,* from correcoes_correcao 
where redacao_id in (select id from correcoes_redacao where nota_final is null)


select id_projeto, * from correcoes_correcao where redacao_id = 14219

select id_projeto,* from correcoes_analise where redacao_id = 14219




select id_projeto, * from correcoes_correcao where redacao_id = 14219

select * from correcoes_fila3  
--insert into correcoes_fila3
select ',4429,4465,', dbo.getlocaldate(), null, 1, 1, '2911910605221149', 14219


select * from correcoes_analise where redacao_id = 14264
select * from correcoes_redacao where id = 14264

select * from correcoes_redacao 
--update correcoes_redacao set nota_final = 840.0, id_correcao_situacao = 1 
where id = 14264

