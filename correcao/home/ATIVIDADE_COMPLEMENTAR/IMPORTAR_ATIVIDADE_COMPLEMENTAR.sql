/*
--#########################################################################################
-- ALINHAR AS TABELAS TIPO E MODALIDADE 
-------------------------------------------------------------------------------------------
insert into atividades_complementares_tipo (criado_em , atualizado_em, criado_por, atualizado_por, nome, atributos)
select criado_em = getdate(), atualizado_em = getdate(), criado_por = 11717, atualizado_por = 11717, nome = ltrim(rtrim(edu.categoria)) collate database_default, atributos = null 
  from atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO edu left join atividades_complementares_tipo tip on (ltrim(rtrim(tip.nome)) collate database_default = ltrim(rtrim(edu.categoria)) collate database_default)
 where tip.id is null 
-------------------------------------------------------------------------------------------
insert into atividades_complementares_modalidade(criado_em , atualizado_em, criado_por, atualizado_por, nome, atributos)
select criado_em = getdate(), atualizado_em = getdate(), criado_por = 11717, atualizado_por = 11717, nome = ltrim(rtrim(edu.funcao)) collate database_default, atributos = null 
  from atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO edu left join atividades_complementares_modalidade mdl on (ltrim(rtrim(mdl.nome)) collate database_default = ltrim(rtrim(edu.funcao)) collate database_default)
 where mdl.id is null 
-------------------------------------------------------------------------------------------
*/

WITH CTE_EDUCAT AS (
			select  
			       ALUNO_CPF       = ALUNO_CPF      COLLATE DATABASE_DEFAULT, 
			       DATA_REALIZACAO = CAST( DATA_REALIZACAO AS DATE), 
				   OBSERVACOES     = ltrim(rtrim(OBSERVACOES))    COLLATE DATABASE_DEFAULT, 
				   FUNCAO_NOME     = ltrim(rtrim(FUNCAO_NOME))    COLLATE DATABASE_DEFAULT, 
				   CATEGORIA_NOME  = ltrim(rtrim(CATEGORIA_NOME)) COLLATE DATABASE_DEFAULT,
				   CURSO_NOME      = ltrim(rtrim(CURSO_NOME)) COLLATE DATABASE_DEFAULT
			  from VW_ATIVIDADE_COMPLEMENTAR_ALUNO EDU
			 WHERE EDU.ALUNO_CPF IN (select DISTINCT CPFALUNO COLLATE DATABASE_DEFAULT 
			                           from atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO) 
) 
	,	cte_diferenca as (
			SELECT DISTINCT * FROM CTE_EDUCAt		
		EXCEPT 
			SELECT DISTINCT CPFALUNO, 
			       CAST (DATACERTIFICADO AS DATE), 
				   ltrim(rtrim(OBSERVACAO)) COLLATE DATABASE_DEFAULT, 
				   ltrim(rtrim(FUNCAO)) COLLATE DATABASE_DEFAULT , 
				   ltrim(rtrim(CATEGORIA)) COLLATE DATABASE_DEFAULT , 
				   ltrim(rtrim(CURSO_NOME)) COLLATE DATABASE_DEFAULT
			  FROM atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO
)

     select * from cte_diferenca
	 select distinct cpfaluno from atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO
-- #### DELETAR ATIVIDADES IMPORTADAS ########
	 select distinct  ati.*
    	--  delete ati 
	  from atividades_complementares_atividade ati join curriculos_aluno     cra on (cra.id = ati.curriculo_aluno_id AND 
	                                                                                 CRA.STATUS_ID IN (13,16,14,18))
												   JOIN curriculos_curriculo CRC ON (CRC.ID = CRA.curriculo_id)
												   JOIN ACADEMICO_CURSO      CUR ON (CUR.ID = CRC.curso_id)
	                                               join academico_aluno      alu on (alu.id = cra.aluno_id)
												   join pessoas_pessoa       pes on (pes.id = alu.pessoa_id)
												   JOIN atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO PAR ON (replace(replace(pes.cpf,'.',''),'-','') collate database_default = PAR.cpfaluno collate database_default )

SELECT *  FROM atividades_complementares_atividade WHERE CRIADO_POR = 11717
-- ##### INSERIR ATIVIDADES COMPLEMENTARES ######
insert into atividades_complementares_atividade (criado_em, atualizado_em, criado_por, atualizado_por, atributos, carga_horaria, data_realizacao, observacoes, periodo, ano, modalidade_id, curriculo_aluno_id, tipo_id)
select criado_em = getdate(), atualizado_em = getdate(), criado_por = 11717, atualizado_por = 11717,  atributos = '{{"tipo":"integracao atividade"}}',
       carga_horaria = horcomputada, data_realizacao = datacertificado, observacoes = rtrim(ltrim(observacao)), 
	   periodo = CASE WHEN MONTH(datacertificado) <7 THEN 1 ELSE 2 END, ano = year(datacertificado), 
			 modalidade_id = mdl.id, curriculo_aluno_id = pes.curriculo_aluno_id, tipo_id = tip.id 
from atividade..VW_INTEGRACAO_EDUCAT_PARTICIPACAO edu join atividades_complementares_modalidade mdl on (mdl.nome collate database_default = edu.funcao collate database_default)
                                                      join atividades_complementares_tipo       tip on (tip.nome collate database_default = edu.categoria collate database_default)
										              join vw_Curriculo_aluno_pessoa            pes on (edu.CPFALUNO collate database_default = pes.aluno_cpf collate database_default and 
										                                                                pes.curriculo_aluno_status_id in (13,16,14,18) and
										   												                ltrim(rtrim(PES.CURSO_NOME)) COLLATE DATABASE_DEFAULT = ltrim(rtrim(EDU.CURSO_NOME)) COLLATE DATABASE_DEFAULT)
				
WHERE EDU.EXPORTADO = 1 and edu.cpfaluno = '02084633648'
order by 2,3





