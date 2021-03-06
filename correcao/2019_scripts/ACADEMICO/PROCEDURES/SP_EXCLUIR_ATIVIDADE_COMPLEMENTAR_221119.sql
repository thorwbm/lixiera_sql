
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

-- EXEC sp_excluir_atividade_complementar '13450793624', 'psicologia'

ALTER   procedure [dbo].[sp_excluir_atividade_complementar] 
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


--#######################################################################################################



/*****************************************************************************************************************
*                         EXCLUSAO ATIVIDADES COMPLEMENTARES EXPORTADAS PARA EDUCAT                              *
*                                                                                                                *
* PROCEDURE QUE RECEBE DOIS PARAMETROS (CPF E CURSO DO ALUNO) PARA EXCLUIR OS LANCAMENTOS DE ATIVIDADES COMPLEME *
* NTARES NO E EDUCAT SETAR O FLAG DE EXPORTADO NO SISTEMA DE ATIVIDADES.                                         *
*                                                                                                                *
* BANCO_SISTEMA: ATIVIDADE - EDUCAT                                                                              *
* AUTOR:         WEMERSON BITTORI MADURO                                                         DATA:20/11/2019 *
******************************************************************************************************************/
/*-- exec sp_exclui_participacao_educat '13731204606', 5
ALTER PROCEDURE [dbo].[SP_EXCLUI_PARTICIPACAO_EDUCAT] @cpfAluno varchar(20),@curso int 
	AS 
declare @curoNome varchar(500)
-- **************** SELECT * BUSCA O CURSO REFERENTE NO UNIVERSO ****************       
select  @curoNome = cur.des_cur
from curso cur 
where cur.cod_cur =  @curso

-- **************** DELECAO DOS REGISTROS NO UNIVERSUS **************** 
	exec [EDUCAT_ATIVIDADE_COMPLEMENTAR].erp_hmg.DBO.sp_excluir_atividade_complementar @CPFALUNO, @curoNome

-- **************** FIM CURSOR QUE CORRE AS REFERENCIAS DO ALUNO PASSADO POR PARAMENTRO (CPF, CURSO) ****************
*/
-- **************** SETAR O FLAG DE EXPORTADO NA TABELA PARTICIPACAO PARA ZERO ****************
/*update par set par.flg_exp = 0, par.int_uni = null
  from usuario usu with(nolock) join participacao par with(nolock) on (usu.cod_usu = par.cod_usu)
 where par.flg_exp = 1 and usu.cpf_usu = @cpfAluno*/

 --################################################################################################