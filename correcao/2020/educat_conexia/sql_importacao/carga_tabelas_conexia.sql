WITH CTE_NIVEL_5 AS (
			select DISTINCT   *, 
			          nivel_01 = cast(REPLACE(LEFT(NIVEL01, CHARINDEX(' ',NIVEL01)),'.','') as int),
                      NIVEL_02 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))), CHARINDEX('.',REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))))-1)) as int),
                      NIVEL_03 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))), CHARINDEX('.',REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))))-1)) as int),
                      NIVEL_04 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))), CHARINDEX('.',REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))))-1)) as int),
                      NIVEL_05 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))), CHARINDEX('.',REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))))-1)) as int),
			          TITULO_NIVEL =  RTRIM(LTRIM(RIGHT(NIVEL05, LEN(NIVEL05) - CHARINDEX(' ',NIVEL05)))) 
					 from import_historia_1ano 
			WHERE NIVEL05 IS NOT NULL AND 
			      NIVEL04 IS NOT NULL AND 
			      NIVEL03 IS NOT NULL AND 
			      NIVEL02 IS NOT NULL AND 
			      NIVEL01 IS NOT NULL
)   
	,	CTE_NIVEL_4 AS (
			select DISTINCT   *, 
			          nivel_01 = cast(REPLACE(LEFT(NIVEL01, CHARINDEX(' ',NIVEL01)),'.','') as int),
                      NIVEL_02 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))), CHARINDEX('.',REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))))-1)) as int),
                      NIVEL_03 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))), CHARINDEX('.',REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))))-1)) as int),
                      NIVEL_04 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))), CHARINDEX('.',REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))))-1)) as int),
                      NIVEL_05 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))), CHARINDEX('.',REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))))-1)) as int),
			          TITULO_NIVEL =  RTRIM(LTRIM(RIGHT(NIVEL04, LEN(NIVEL04) - CHARINDEX(' ',NIVEL04)))) 
					 from import_historia_1ano
			WHERE NIVEL05 IS     NULL AND 
			      NIVEL04 IS NOT NULL AND 
			      NIVEL03 IS NOT NULL AND 
			      NIVEL02 IS NOT NULL AND 
			      NIVEL01 IS NOT NULL
)
	,	CTE_NIVEL_3 AS (
			select DISTINCT   *, 
			          nivel_01 = cast(REPLACE(LEFT(NIVEL01, CHARINDEX(' ',NIVEL01)),'.','') as int),
                      NIVEL_02 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))), CHARINDEX('.',REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))))-1)) as int),
                      NIVEL_03 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))), CHARINDEX('.',REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))))-1)) as int),
                      NIVEL_04 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))), CHARINDEX('.',REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))))-1)) as int),
                      NIVEL_05 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))), CHARINDEX('.',REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))))-1)) as int),
			          TITULO_NIVEL =  RTRIM(LTRIM(RIGHT(NIVEL03, LEN(NIVEL03) - CHARINDEX(' ',NIVEL03)))) 
					 from import_historia_1ano
			WHERE NIVEL05 IS     NULL AND 
			      NIVEL04 IS     NULL AND 
			      NIVEL03 IS NOT NULL AND 
			      NIVEL02 IS NOT NULL AND 
			      NIVEL01 IS NOT NULL
)
	,	CTE_NIVEL_2 AS (
			select DISTINCT   *, 
			          nivel_01 = cast(REPLACE(LEFT(NIVEL01, CHARINDEX(' ',NIVEL01)),'.','') as int),
                      NIVEL_02 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))), CHARINDEX('.',REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))))-1)) as int),
                      NIVEL_03 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))), CHARINDEX('.',REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))))-1)) as int),
                      NIVEL_04 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))), CHARINDEX('.',REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))))-1)) as int),
                      NIVEL_05 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))), CHARINDEX('.',REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))))-1)) as int),
			          TITULO_NIVEL =  RTRIM(LTRIM(RIGHT(NIVEL02, LEN(NIVEL02) - CHARINDEX(' ',NIVEL02)))) 
					 from import_historia_1ano
			WHERE NIVEL05 IS     NULL AND 
			      NIVEL04 IS     NULL AND 
			      NIVEL03 IS     NULL AND 
			      NIVEL02 IS NOT NULL AND 
			      NIVEL01 IS NOT NULL
)
	,	CTE_NIVEL_1 AS (
			select DISTINCT   *, 
			          nivel_01 = cast(REPLACE(LEFT(NIVEL01, CHARINDEX(' ',NIVEL01)),'.','') as int),
                      NIVEL_02 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))), CHARINDEX('.',REVERSE(LEFT(Nivel02, CHARINDEX(' ',Nivel02))))-1)) as int),
                      NIVEL_03 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))), CHARINDEX('.',REVERSE(LEFT(Nivel03, CHARINDEX(' ',Nivel03))))-1)) as int),
                      NIVEL_04 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))), CHARINDEX('.',REVERSE(LEFT(Nivel04, CHARINDEX(' ',Nivel04))))-1)) as int),
                      NIVEL_05 = cast(REVERSE(LEFT(REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))), CHARINDEX('.',REVERSE(LEFT(Nivel05, CHARINDEX(' ',Nivel05))))-1)) as int),
			          TITULO_NIVEL =  RTRIM(LTRIM(RIGHT(NIVEL01, LEN(NIVEL01) - CHARINDEX(' ',NIVEL01)))) 
					 from import_historia_1ano 
			WHERE NIVEL05 IS     NULL AND 
			      NIVEL04 IS     NULL AND 
			      NIVEL03 IS     NULL AND 
			      NIVEL02 IS     NULL AND 
			      NIVEL01 IS NOT NULL
)
-- ####### INSERT NA TABELA MATRIZ_MATRIZ  #########
      --    INSERT INTO MATRIZ_MATRIZ (Descritor, Area_id, Grau_id, Serie_id, Disciplina_id, SubDisciplina_id, n1, n2, n3, n4, n5, n6, criado_em)
			SELECT  Descritor, Area_id, Grau_id, Serie_id, Disciplina_id, SubDisciplina_id, nivel01, nivel02, nivel03, nivel04, nivel05, nivel06, getdate() 
			  FROM (
			--	#### NIVEL 1 ####
                 select distinct  DESCRITOR = CTE.titulo, 
				      are.id as area_id, gra.id as grau_id, ser.id as serie_id,
	                  dis.id as disciplina_id, --dis.DISCIPLINA ,
	                  sbd.id as subDisciplina_id,-- sbd.SubDisciplina, 
					  nivel01 = CTE.capitulo,
					  nivel02 = NULL, 
					  nivel03 = CTE.Nivel_02,
					  nivel04 = CTE.Nivel_03, 
					  nivel05 = CTE.Nivel_04, 
					  nivel06 = CTE.Nivel_05							  
				   from CTE_NIVEL_1 CTE join matriz_disciplina    dis on (CTE.Disciplina like (dis.Disciplina+'%'))
	                                       join matriz_area          ARE on (are.id = dis.Area_id)
						                   join matriz_grau          gra on (gra.id =dis.Grau_id) 
						                   join matriz_serie         ser on (ser.id =dis.Serie_id)
	                                  left join matriz_subdisciplina sbd on (dis.id =  sbd.disciplina_id and 
					                                                         CTE.Disciplina = sbd.SubDisciplina)

			--	#### NIVEL 2 ####
			    UNION
                 select distinct DESCRITOR =CTE.TITULO_NIVEL,
				              are.id as area_id, gra.id as grau_id, ser.id as serie_id,
	                  dis.id as disciplina_id, --dis.DISCIPLINA ,
	                  sbd.id as subDisciplina_id,-- sbd.SubDisciplina, 
					  nivel01 = CTE.capitulo,
					  nivel02 = CTE.Nivel_01, 
					  nivel03 = CTE.Nivel_02,
					  nivel04 = CTE.Nivel_03, 
					  nivel05 = CTE.Nivel_04, 
					  nivel06 = CTE.Nivel_05					  
				   from CTE_NIVEL_1 CTE join matriz_disciplina    dis on (CTE.Disciplina like (dis.Disciplina+'%'))
	                                       join matriz_area          ARE on (are.id = dis.Area_id)
						                   join matriz_grau          gra on (gra.id =dis.Grau_id) 
						                   join matriz_serie         ser on (ser.id =dis.Serie_id)
	                                  left join matriz_subdisciplina sbd on (dis.id =  sbd.disciplina_id and 
					                                                         CTE.Disciplina = sbd.SubDisciplina)

			--	#### NIVEL 3 ####
			    UNION
                 select distinct DESCRICTOR =CTE.TITULO_NIVEL,
				              are.id as area_id, gra.id as grau_id, ser.id as serie_id,
	                  dis.id as disciplina_id, --dis.DISCIPLINA ,
	                  sbd.id as subDisciplina_id,-- sbd.SubDisciplina, 
					  nivel01 = CTE.capitulo,
					  nivel02 = CTE.Nivel_01, 
					  nivel03 = CTE.Nivel_02,
					  nivel04 = CTE.Nivel_03, 
					  nivel05 = CTE.Nivel_04, 
					  nivel06 = CTE.Nivel_05						  
				   from CTE_NIVEL_2 CTE join matriz_disciplina       dis on (CTE.Disciplina like (dis.Disciplina+'%'))
	                                       join matriz_area          ARE on (are.id = dis.Area_id)
						                   join matriz_grau          gra on (gra.id =dis.Grau_id) 
						                   join matriz_serie         ser on (ser.id =dis.Serie_id)
	                                  left join matriz_subdisciplina sbd on (dis.id =  sbd.disciplina_id and 
					                                                         CTE.Disciplina = sbd.SubDisciplina)

			--	#### NIVEL 4 ####
			    UNION
                 select distinct DESCRICTOR =CTE.TITULO_NIVEL,
				              are.id as area_id, gra.id as grau_id, ser.id as serie_id,
	                  dis.id as disciplina_id, --dis.DISCIPLINA ,
	                  sbd.id as subDisciplina_id,-- sbd.SubDisciplina, 
					  nivel01 = CTE.capitulo,
					  nivel02 = CTE.Nivel_01, 
					  nivel03 = CTE.Nivel_02,
					  nivel04 = CTE.Nivel_03, 
					  nivel05 = CTE.Nivel_04, 
					  nivel06 = CTE.Nivel_05					  
				   from CTE_NIVEL_3 CTE join matriz_disciplina       dis on (CTE.Disciplina like (dis.Disciplina+'%'))
	                                       join matriz_area          ARE on (are.id = dis.Area_id)
						                   join matriz_grau          gra on (gra.id =dis.Grau_id) 
						                   join matriz_serie         ser on (ser.id =dis.Serie_id)
	                                  left join matriz_subdisciplina sbd on (dis.id =  sbd.disciplina_id and 
					                                                         CTE.Disciplina = sbd.SubDisciplina)

			--	#### NIVEL 5 ####
			    UNION
                 select distinct DESCRICTOR =CTE.TITULO_NIVEL,
				              are.id as area_id, gra.id as grau_id, ser.id as serie_id,
	                  dis.id as disciplina_id, --dis.DISCIPLINA ,
	                  sbd.id as subDisciplina_id,-- sbd.SubDisciplina, 
					  nivel01 = CTE.capitulo,
					  nivel02 = CTE.Nivel_01, 
					  nivel03 = CTE.Nivel_02,
					  nivel04 = CTE.Nivel_03, 
					  nivel05 = CTE.Nivel_04, 
					  nivel06 = CTE.Nivel_05					  
				   from CTE_NIVEL_4 CTE join matriz_disciplina       dis on (CTE.Disciplina like (dis.Disciplina+'%'))
	                                       join matriz_area          ARE on (are.id = dis.Area_id)
						                   join matriz_grau          gra on (gra.id =dis.Grau_id) 
						                   join matriz_serie         ser on (ser.id =dis.Serie_id)
	                                  left join matriz_subdisciplina sbd on (dis.id =  sbd.disciplina_id and 
					                                                         CTE.Disciplina = sbd.SubDisciplina)

			--	#### NIVEL 6 ####
			    UNION
                 select distinct DESCRICTOR =CTE.TITULO_NIVEL,
				              are.id as area_id, gra.id as grau_id, ser.id as serie_id,
	                  dis.id as disciplina_id, --dis.DISCIPLINA ,
	                  sbd.id as subDisciplina_id,-- sbd.SubDisciplina, 
					  nivel01 = CTE.capitulo,
					  nivel02 = CTE.Nivel_01, 
					  nivel03 = CTE.Nivel_02,
					  nivel04 = CTE.Nivel_03, 
					  nivel05 = CTE.Nivel_04, 
					  nivel06 = CTE.Nivel_05						  
				   from CTE_NIVEL_5 CTE join matriz_disciplina       dis on (CTE.Disciplina like (dis.Disciplina+'%'))
	                                       join matriz_area          ARE on (are.id = dis.Area_id)
						                   join matriz_grau          gra on (gra.id =dis.Grau_id) 
						                   join matriz_serie         ser on (ser.id =dis.Serie_id)
	                                  left join matriz_subdisciplina sbd on (dis.id =  sbd.disciplina_id and 
					                                                         CTE.Disciplina = sbd.SubDisciplina)
) AS TAB 
WHERE NOT EXISTS (SELECT TOP 1 1 FROM MATRIZ_MATRIZ MAT 
                   WHERE MAT.DESCRITOR     = TAB.DESCRITOR AND 
				         MAT.Area_id       = TAB.area_id   AND 
						 MAT.Grau_id       = TAB.grau_id   AND 
						 MAT.Serie_id      = TAB.serie_id  AND
						 MAT.disciplina_id = TAB.disciplina_id AND
						 ISNULL(MAT.SubDisciplina_id,0) = ISNULL(TAB.subDisciplina_id,0) AND 
						 ISNULL(MAT.n1,0)               = ISNULL(TAB.nivel01,0) AND 
						 ISNULL(MAT.n2,0)               = ISNULL(TAB.nivel02,0) AND 
						 ISNULL(MAT.n3,0)               = ISNULL(TAB.nivel03,0) AND 
						 ISNULL(MAT.n4,0)               = ISNULL(TAB.nivel04,0) AND 
						 ISNULL(MAT.n5,0)               = ISNULL(TAB.nivel05,0) AND 
						 ISNULL(MAT.n6,0)               = ISNULL(TAB.nivel06,0))
ORDER BY AREA_ID, disciplina_id, subDisciplina_id, nivel01, nivel02, nivel03, NIVEL04, NIVEL05, nivel06
 -- select * from matriz_matriz 
/*
-- #####################################################################################
----------------------------------------------------------------------------------------
-- CARGA SUBDISCIPLINAS NAO EXISTENTES
----------------------------------------------------------------------------------------
-- SELECT * FROM matriz_subdisciplina
-- SELECT * FROM matriz_disciplina
INSERT INTO matriz_subdisciplina (disciplina_id, SubDisciplina)
select distinct DIS.ID, tab1.disciplina from import_historia_1ano tab1 join matriz_disciplina dis on (tab1.disciplina like (DIS.DISCIPLINA + '%') and 
                                                                                                    tab1.disciplina <> dis.Disciplina)
                                                                 left join matriz_subdisciplina sbd on (sbd.SubDisciplina = tab1.Disciplina)
where sbd.id is null 

select * from matriz_area
select * from matriz_grau
select * from import_historia_1ano
select * from matriz_MATRIZ
-- #####################################################################################
--insert into matriz_disciplina 
select area_id = 1, grau_id = 2, serie_id = 3, disciplina = 'Artes',null   union 
select area_id = 1, grau_id = 2, serie_id = 3, disciplina = 'Espanhol',null   union
select area_id = 1, grau_id = 2, serie_id = 3, disciplina = 'Língua Portuguesa',null    union
select area_id = 1, grau_id = 2, serie_id = 3, disciplina = 'Literatura',null  union
select area_id = 1, grau_id = 2, serie_id = 3, disciplina = 'Redação',null  


select *   from matriz_disciplina 

select distinct disciplina from import_historia_1ano  where disciplina not in (
select distinct disciplina from  matriz_disciplina)

select distinct *  from import_historia_1ano 
--update import_historia_1ano set NIVEL03 ='1.3.5 Pressão'
WHERE ID = 420

select distinct *  from import_historia_1ano where  nivel01 like '%Comprensión%'

select distinct *  from import_historia_1ano
--   update import_historia_1ano set  nivel01 = '2. Comprensión global y puntual'
where id in (175)


*/