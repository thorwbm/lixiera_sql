/**********************************************************************************************************************************
*                                              [SP_EXCLUIR_ATIVIDADE_COMPLEMENTAR]                                                *
*                                                                                                                                 *
*  PROCEDURE QUE APAGA OS LANCAMENTOS FEITOS PELO SISTEMA DE ATIVIDADE COMPLEMENTAR PARA UM ALUNO EM UM CURRICULO                 *
*                                                                                                                                 *
*  DEVERA SER CRIADO UM LINKED SERVER NO SERVIDOR DO SISTEMA DE ATIVIDADES APONTANDO PARA O EDUCAT E DADO PERMICAO DE EXECUCAO    *
*  PARA ESTA PROCEDURE                                                                                                            *
*                                                                                                                                 *
* BANCO_SISTEMA : ATIVIDADE COMPLEMENTAR - EDUCAT                                                                                 *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:20/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:20/11/2019 *
**********************************************************************************************************************************/

-- EXEC sp_excluir_atividade_complementar '12901375600', 'psicologia'

create or alter procedure sp_excluir_atividade_complementar 
    @aluno_cpf varchar(20), @curso_nome varchar(500) as
	
	declare @curriculoalunoid int

	-- **** encontrar o curriculo aluno id do aluno no educat
	select DISTINCT @curriculoalunoid =  CURRICULOALUNO_ID
	  from vw_aluno_curriculo_curso_turma_etapa_discplina 
	 WHERE REPLACE(REPLACE(ALUNO_CPF,'.',''),'-','') = REPLACE(REPLACE(@aluno_cpf,'.',''),'-','') AND  
		   STATUSCURRICULO_ID = 13 and 
		   CURSO_NOME = @curso_nome

delete from atividades_complementares_atividade 
where curriculo_aluno_id = @curriculoalunoid and 
      atributos = 'origem:Sistema Atividade Complementar' and criado_por is null 