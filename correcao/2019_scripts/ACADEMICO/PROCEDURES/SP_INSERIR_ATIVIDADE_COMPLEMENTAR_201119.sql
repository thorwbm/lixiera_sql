/**********************************************************************************************************************************
*                                              [SP_INSERIR_ATIVIDADE_COMPLEMENTAR]                                                *
*                                                                                                                                 *
*  PROCEDURE QUE FAZ O INSERT DE ATIVIDADES COMPLEMENTARES DEFERIDAS NO SISTEMA "ATIVIDADE COMPLEMENTAR" NO SISTEMA EDUCAT        *
*  TENDO COMO RETORNO 0 PARA NAO INSERIDO E 1 PARA INSERIDO                                                                       *
*                                                                                                                                 *
*  É NECESSARIO CRIAR UM LINKED SERVER NO SERVIDOR DO SISTEMA DE ATIVIDADES COM PERMICAO DE EXECUCAO PARA ESTA PROCEDURE          *
*                                                                                                                                 *
* BANCO_SISTEMA : ATIVIDADE COMPLEMENTAR/EDUCAT                                                                                   *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:20/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:20/11/2019 *
**********************************************************************************************************************************/


create OR ALTER procedure sp_inserir_atividade_complementar
   @cpf        varchar(20),
   @modalidade varchar(500), -- @funcao
   @tipo       varchar(500) ,-- @grupo 
   @curso      varchar(500),
   @HORACOMPUTADA float ,
   @DATACERTIFICADO DATETIME,
   @OBS VARCHAR(8000),
   @RETORNO INT OUTPUT  as 
 
   declare @tipoid       int
   declare @modalidadeid int
   declare @curriculoalunoid int 
   declare @PERIODO INT

set @periodo = CASE WHEN MONTH(@DATACERTIFICADO) <7 THEN 1 ELSE 2 END
set @RETORNO = 0

-- **** BUSCO OS CODIGOS DA MODALIDADE E DO TIPO  ****
select @modalidadeid = min(id) from atividades_complementares_modalidade where replace(LTRIM(rtrim(@modalidade)),' ','') = replace(LTRIM(rtrim(nome)),' ','')
select @tipoid = MIN(id) from atividades_complementares_tipo where replace(LTRIM(rtrim(@tipo)),' ','') = replace(LTRIM(rtrim(nome)),' ','')
-- ****

if(@modalidadeid is not null and @tipoid is not null)
	begin 
		-- **** encontrar o curriculo aluno id do aluno no educat
		select DISTINCT @curriculoalunoid =  CURRICULOALUNO_ID
		  from vw_aluno_curriculo_curso_turma_etapa_discplina 
		 WHERE REPLACE(REPLACE(ALUNO_CPF,'.',''),'-','') = REPLACE(REPLACE(@cpf,'.',''),'-','')       AND 
			  STATUSCURRICULO_ID = 13 and 
			  CURSO_NOME = @curso
			  
		insert into atividades_complementares_atividade (criado_em, atualizado_em, atributos,
		       carga_horaria, data_realizacao, observacoes, periodo,
			   ano, criado_por, modalidade_id, curriculo_aluno_id, tipo_id, atualizado_por)
		select criado_em = GETDATE(), atualizado_em = GETDATE(), atributos = 'origem:Sistema Atividade Complementar',
		       carga_horaria = @HORACOMPUTADA,data_realizacao = @DATACERTIFICADO, observacoes = @OBS, periodo = @PERIODO,
			   ano = YEAR(@DATACERTIFICADO), criado_por = null, modalidade_id = @modalidadeid, curriculo_aluno_id = @curriculoalunoid, 
			   tipo_id = @tipoid, atualizado_por = null 
			   
			   where not exists (select 1
			   from atividades_complementares_atividade aca 
			   where aca.data_realizacao = @DATACERTIFICADO and 
			         modalidade_id = @modalidadeid and 
					 tipo_id       = @tipoid and 
					 observacoes   = @OBS    and
					 curriculo_aluno_id = @curriculoalunoid) 

				SET @RETORNO = @@IDENTITY
	end
	
--#######################################################################################################################################

/*                         ### SCRIPT DO LADO DO SISTEMA DE ATIVIDADE COMPLEMENTAR ###


/*****************************************************************************************************************
*                              IMPORTACAO ATIVIDADES COMPLEMENTARES PARA UNIVERSUS                               *
*                                                                                                                *
* ESTRUTURA QUE BUSCA AS ATIVIDADES COMPLEMENTARES DO SISTEMAS ATIVIDADE QUE ESTAO COM O STATUS DEFERIDO OU EXCE *
* DIDO E OS INSERE NA BASE DE DADOS DO SISTEMA UNIVERSUS.                                                        *
*                                                                                                                *
* BANCO_SISTEMA: ATIVIDADE - UNIVERSUS                                                                           *
* AUTOR: WEMERSON BITTORI MADURO                                                                 DATA:23/11/2015 *
******************************************************************************************************************/
--exec SP_EXPORTA_PARTICIPACAO_UNIVERSUS

ALTER  PROCEDURE [dbo].[SP_EXPORTA_PARTICIPACAO_EDUCAT_JOB] AS 
--  **************** DECLARAÇAO DAS VARIAVEIS NECESSARIAS ************************
DECLARE @CPFALUNO VARCHAR(20),@CODPARTICIPACAO INT, @HORACOMPUTADA FLOAT, @DATACERTIFICADO DATETIME, @OBS VARCHAR(8000),
        @FUNCAO VARCHAR(255), @CATEGORIA VARCHAR(255), @CURSO_NOME VARCHAR(500), @RETORNO INT 
 
     
-- **************** CURSOR QUE CORRE AS ATIVIDADES APROVADAS QUE AINDA NAO FORAM EXPORTADAS ****************
declare abc cursor for 

SELECT distinct 
       CPFALUNO        = USU.CPF_USU,  
       CODPARTICIPACAO = PAR.COD_PAR, 
       HORCOMPUTADA    = CAST(PAR.HOR_CON AS float), 
       DATACERTIFICADO = PAR.DAT_CER,
       OBSERVACAO      = ISNULL(PAR.DES_PAR,' - * - ') ,
       FUNCAO          = ' ' + UPPER(DES_FUN),
       CURSO_NOME      = CUR.DES_CUR,
       CATEGORIA       = cat.des_cat

  FROM PARTICIPACAO PAR with(nolock) JOIN ATIVIDADE  ATI with(nolock) ON (PAR.COD_ATI = ATI.COD_ATI)
                                     JOIN FUNCAO     FUN with(nolock) ON (FUN.COD_FUN = ATI.COD_FUN)
                                     JOIN CATEGORIA  CAT with(nolock) ON (CAT.COD_CAT = ATI.COD_CAT)
                                     JOIN GRUPO      GRU with(nolock) ON (GRU.COD_GRU = CAT.COD_GRU)
                                     JOIN USUARIO    USU with(nolock) ON (USU.COD_USU = PAR.COD_USU)
                                LEFT JOIN CURSO      CUR with(nolock) ON (CUR.COD_CUR = USU.COD_CUR)
  WHERE des_sta IN ('DEFERIDO') AND  PAR.FLG_EXP = 0
  ORDER BY CPFALUNO,DATACERTIFICADO
        
open abc 
fetch next from abc into @CPFALUNO, @CODPARTICIPACAO, @HORACOMPUTADA, @DATACERTIFICADO, @OBS, @FUNCAO, @CURSO_NOME, @CATEGORIA
while @@FETCH_STATUS = 0
BEGIN

	SET @RETORNO = 0
	Exec [EDUCAT_ATIVIDADE_COMPLEMENTAR].erp_hmg.DBO.sp_inserir_atividade_complementar @CPFALUNO, @FUNCAO, @CATEGORIA, @CURSO_NOME, @HORACOMPUTADA, @DATACERTIFICADO, @OBS, @RETORNO OUTPUT
	
	IF(@RETORNO > 0) 
		BEGIN
           UPDATE participacao SET flg_exp = 1, int_uni = @RETORNO WHERE cod_par = @CODPARTICIPACAO 
		END
          
	fetch next from abc into @CPFALUNO, @CODPARTICIPACAO, @HORACOMPUTADA, @DATACERTIFICADO, @OBS, @FUNCAO, @CURSO_NOME, @CATEGORIA
END
close abc 
deallocate abc 
-- **************** FIM  CURSOR QUE CORRE AS ATIVIDADES APROVADAS QUE AINDA NAO FORAM EXPORTADAS ****************

*/


--#######################################################################################################################################
