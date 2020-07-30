--CREATE OR ALTER VIEW VW_TURMA_DISCIPLINA_DUPLICADA AS 
WITH CTE_DUPLICIDADE_TURMA_DISCIPLINA AS (
		 select  turma.nome AS TURMA_NOME, disc.nome DISCIPLINA_NOME
		from academico_turmadisciplina    td  join academico_turma           turma on (turma.id = td.turma_id)
		                                      join academico_disciplina      disc  on (disc.id = td.disciplina_id)
		group by  turma.nome, disc.nome
		having count(1) > 1
)
	, CTE_OCORRENCIAS_TABELAS AS (
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaaluno' FROM academico_turmadisciplinaaluno                                 GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaprofessor' FROM academico_turmadisciplinaprofessor						  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_grupoaula' FROM academico_grupoaula														  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'materiais_didaticos_publicacao_turmadisciplina' FROM materiais_didaticos_publicacao_turmadisciplina GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'aulas_agendamento' FROM aulas_agendamento															  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'atividades_protocolosegundachamadaprova' FROM atividades_protocolosegundachamadaprova				  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'atividades_criterio_turmadisciplina' FROM atividades_criterio_turmadisciplina						  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_excecaofrequenciaforaprazo' FROM frequencias_excecaofrequenciaforaprazo				  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_protocolofrequenciaforaprazo' FROM frequencias_protocolofrequenciaforaprazo			  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_complementacaocargahoraria' FROM academico_complementacaocargahoraria					  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'aulas_pendentes' FROM aulas_pendentes																  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'frequencias_revisao' FROM frequencias_revisao														  GROUP BY TURMA_DISCIPLINA_ID UNION 
		SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_aula' FROM academico_aula																  GROUP BY TURMA_DISCIPLINA_ID  
)
    ,  CTE_POSSUI_ALUNO AS (
			SELECT TURMA_DISCIPLINA_ID, QTD = COUNT(1), TABELA = 'academico_turmadisciplinaaluno' FROM academico_turmadisciplinaaluno                                 GROUP BY TURMA_DISCIPLINA_ID
)
	,  CTE_TURMADISCIPLINA AS (
        SELECT DISTINCT tds.id as turma_disciplina_id,
		       tur.id as turma_id, tur.nome as turma_nome, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome, 
		       disc_pertence_curriculo_ativo = case when cgd.curriculo_id is null then 'NAO' ELSE 'SIM' END,
			   TEM_LANCAMENTO = CASE WHEN OCO.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END, 
			   TEM_ALUNO_LANC = CASE WHEN PAL.TURMA_DISCIPLINA_ID IS NULL THEN 'NAO' ELSE 'SIM'END,
			   CGD.curriculo_nome
		FROM  academico_turmadisciplina tds  join academico_turma                  tur on (tur.id              = tds.turma_id)
		                                     join academico_disciplina             dis on (dis.id              = tds.disciplina_id)
											 join CTE_DUPLICIDADE_TURMA_DISCIPLINA cte on (cte.turma_nome      = tur.nome and 
																						   cte.disciplina_nome = dis.nome)
										left join vw_curriculo_grade_disciplina    cgd on (tur.grade_id        = cgd.grade_id and 
													                                       cgd.disciplina_id   = dis.id)
										LEFT JOIN CTE_OCORRENCIAS_TABELAS OCO ON (TDS.id = OCO.turma_disciplina_id)
										LEFT JOIN CTE_POSSUI_ALUNO        PAL ON (TDS.ID = PAL.turma_disciplina_id)
) 
		select * from CTE_TURMADISCIPLINA TDS 
		order by 3,5

	declare @turmaDisciplina_id_origem int, @turmaDisciplina_id_destino int
	set @turmaDisciplina_id_origem  = 10134   
	set @turmaDisciplina_id_destino = 10233
	exec sp_transportar_turmadisciplina_id @turmaDisciplina_id_origem , @turmaDisciplina_id_destino


/*
11350
11357
11359
11361
11363
14243
10263
10264
5111
10305
10416
10549
*/

select *
--  begin tran delete 
from academico_turmadisciplina
where id in (11351,
11357,
11359,
11361,
11363,
14243,
10263,
10264,
5111 ,
10305,
10416,
10549)

--rollback 
--commit 

select * 
  -- BEGIN TRAN delete tur
  from academico_turma tur left join academico_turmadisciplina tds on (tur.id = tds.turma_id)
  where tds.id is null 

    SELECT NOME FROM ACADEMICO_TURMA
  GROUP BY NOME HAVING COUNT(1)> 1


  select * 
  -- BEGIN TRAN delete DIS
  from academico_DISCIPLINA DIS  left join academico_turmadisciplina tds on (DIS.id = tds.DISCIPLINA_id)
  where tds.id is null 

    SELECT NOME FROM ACADEMICO_TURMA
  GROUP BY NOME HAVING COUNT(1)> 1


  SELECT DIS.NOME, DIS.ID
  FROM ACADEMICO_DISCIPLINA DIS JOIN curriculos_gradedisciplina GDS ON (DIS.ID = GDS.disciplina_id)
  GROUP BY DIS.NOME , DIS.ID
  HAVING COUNT(1) > 1 ORDER BY 1



  
  SELECT  DIS.NOME
  FROM ACADEMICO_DISCIPLINA DIS JOIN curriculos_gradedisciplina GDS ON (DIS.ID = GDS.disciplina_id)
    GROUP BY DIS.NOME
  HAVING COUNT(DISTINCT GDS.disciplina_id) > 1


    SELECT DIS.NOME
  FROM ACADEMICO_DISCIPLINA DIS JOIN academico_turmadisciplina TDS ON (DIS.ID = TDS.disciplina_id)
  GROUP BY DIS.NOME
  HAVING COUNT(DISTINCT TDS.disciplina_id) > 1

  select * from academico_disciplina where nome like 'PRÁTICAS EM SAÚDE COLETIVA I'

  SELECT * FROM vw_tabela_coluna WHERE COLUNA = 'DISCIPLINA_ID'
  
  SELECT * FROM materiais_didaticos_publicacao
  SELECT * FROM planos_ensino_planoensinoli

SELECT TOP 10 * FROM academico_turmadisciplina
SELECT TOP 10 * FROM materiais_didaticos_publicacao --OK
SELECT TOP 10 * FROM historicos_historicodisciplina --OK
SELECT TOP 10 * FROM curriculos_gradedisciplina     --OK
SELECT TOP 10 * FROM historicos_historico             --OK
SELECT TOP 10 * FROM ofertas_disciplina_ofertadisciplina --?????????????????????
SELECT TOP 10 * FROM curriculos_solicitacaodiscinformada  -- VAZIA
SELECT TOP 10 * FROM academico_responsaveldisciplina --OK
SELECT TOP 10 * FROM cronogramas_cronograma   --OK
SELECT TOP 10 * FROM curriculos_disciplinaconcluida  --OK
SELECT TOP 10 * FROM planos_ensino_planoensino  --OK      TEM GRADEDISCIPLINA_ID MAS NAO E USADA
SELECT TOP 10 * FROM curriculos_errofechamentodisciplina  --OK