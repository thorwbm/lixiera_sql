
--##################################################################################################
-- LEMBRAR DE TROCAR O NOME DA BASE A SER USADA COMO REFERENCIA 
--##################################################################################################


--exec sp_MSforeachtable @command1="DISABLE TRIGGER ALL On ?"
--update projeto_projeto set codigo = '1810401'

--CREATE OR ALTER VIEW [dbo].[VW_N65_DADOS_AVALIADORES_REDACAO_ENEM] AS   
select   
 projeto = pro.codigo,  
 origem  = 'F',  
 CPF     = PES.CPF,  
 NOME    = PES.NOME, 
 NOME_MAE = 'NOME DA MAE DO CORRETOR',				  --  ########################################
 DT_NASCIMENTO = 'DATADENASCIMENTO',				  --  ########################################
 TP_SEXO       = 'TIPO SEXO',						  --  ########################################
 NO_LOGRADOURO = 'LOGRADOURO',						  --  ########################################
 DS_COMPLEMENTO = 'COMPLEMENTO',					  --  ########################################
 NO_BAIRRO      = 'BAIRRO',							  --  ########################################
 NO_CEP         = 'CEP',							  --  ########################################
 CO_MUNICIPIO   = 'CODIGO MUNICIPIO',				  --  ########################################
 SG_UF          = 'SIGLA ESTADO',					  --  ########################################
 NU_TEL_RESIDENCIAL = 'TELEFONE RESIDENCIAL',		  --  ########################################
 NU_TEL_CELULAR     = 'TELEFONE CELULAR',			  --  ########################################
 TX_EMAIL           = 'EMAIL',						  --  ########################################
 TP_TITULACAO       = 0,                              --  ########################################
 FUNCAO  = CASE WHEN PES.usuario_id IN (SELECT USER_ID FROM auth_user_user_permissions WHERE permission_id = 320) THEN 5
                WHEN GRO.ID = 26 THEN 1 
                WHEN GRO.ID = 34 THEN 2
                WHEN GRO.ID = 25 THEN 3 
                WHEN GRO.ID IN (30,29,27) THEN 4
                ELSE NULL END , 
 QTD_SUSPENSAO     = COUNT(SUS.ID),
 MOTIVO_SUSPENSAO  = CASE WHEN MAX(SUS.CRIADO_EM) IS NULL THEN null ELSE  1 END , 
 DATA_SUSPENSAO    = MAX(SUS.CRIADO_EM),
 MOTIVO_DESLIGADO  = NULL,
 DATA_DESLIGADO    = MAX(CRT.data_log),
 id_status         = cor.status_id
  from usuarios_pessoa pes with (nolock) join projeto_projeto_usuarios ppu with (nolock) on (pes.usuario_id = ppu.USER_ID)  
                                         JOIN auth_user_groups         USG WITH (NOLOCK) ON (USG.user_id = PES.usuario_id)
										 JOIN auth_group               GRO WITH (NOLOCK) ON (GRO.id      = USG.group_id)
                                         join projeto_projeto          pro with (nolock) on (pro.id = ppu.projeto_id)
									     JOIN CORRECOES_CORRETOR       COR WITH (NOLOCK) ON (COR.ID = PES.USUARIO_ID )
									LEFT JOIN CORRECOES_SUSPENSAO      SUS WITH (NOLOCK) ON (SUS.ID_CORRETOR = PES.usuario_id)
									LEFT JOIN CORRECOES_CORRETOR_LOG   CRT WITH (NOLOCK) ON (CRT.ID = COR.id and cor.status_id = 4)

GROUP BY PRO.CODIGO,PES.CPF,PES.NOME, PES.USUARIO_ID, GRO.id, cor.status_id
GO
SELECT * FROM  USUARIOS_PESSOA
-------------------------------------------------------------------------------------------------------------------------
-- REGISTROS SEM CONTAR COM CORRETORES DESLIGADOS
-------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW VW_N65_DADOS_AVALIADORES_REDACAO_ENEM_29122018_001 AS /* REFERENCIA A BASE A SER GERADA */
SELECT * FROM VW_N65_DADOS_AVALIADORES_REDACAO_ENEM  VW WITH (NOLOCK)
where id_status <> 4 and 
      funcao is not null  AND 
	  not exists (select top 1 1
                    from entregas_regular.dbo.N65_19122018_001 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO       and 
				         tmp.origem                              = VW.ORIGEM        AND
						 TMP.CPF                                 = VW.CPF           AND
						 TMP.NOME                                = VW.NOME          AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) AND 
	  not exists (select top 1 1
                    from entregas_regular.dbo.N65_18122018_001 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO       and 
				         tmp.origem                              = VW.ORIGEM        AND
						 TMP.CPF                                 = VW.CPF           AND
						 TMP.NOME                                = VW.NOME          AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) AND 
	  not exists (select top 1 1
                    from entregas_regular.dbo.N65_20122018_001 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO       and 
				         tmp.origem                              = VW.ORIGEM        AND
						 TMP.CPF                                 = VW.CPF           AND
						 TMP.NOME                                = VW.NOME          AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) AND 
	  not exists (select top 1 1
                    from entregas_regular.dbo.N65_21122018_001 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO       and 
				         tmp.origem                              = VW.ORIGEM        AND
						 TMP.CPF                                 = VW.CPF           AND
						 TMP.NOME                                = VW.NOME          AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) 



GO
SELECT projeto, origem, cpf, nome, funcao, qtd_suspensao, motivo_suspensao, data_suspensao, motivo_desligado, data_desligado
  INTO entregas_regular.dbo.N65_29122018_001 
  FROM VW_N65_DADOS_AVALIADORES_REDACAO_ENEM_29122018_001
  
GO

-------------------------------------------------------------------------------------------------------------------------
-- REGISTROS  COM CORRETORES DESLIGADOS
-------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW VW_N65_DADOS_AVALIADORES_REDACAO_ENEM_29122018_002 AS
SELECT * FROM VW_N65_DADOS_AVALIADORES_REDACAO_ENEM vw WITH (NOLOCK)
where id_status= 4 and 
      funcao is not null  and
	  not exists (select top 1 * 
                    from entregas_regular.dbo.N65_18122018_002 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO       and 
				         tmp.origem                              = VW.ORIGEM        AND
						 TMP.CPF                                 = VW.CPF           AND
						 TMP.NOME                                = VW.NOME          AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) and
	  not exists (select top 1 * 
                    from entregas_regular.dbo.N65_19122018_002 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO       and 
				         tmp.origem                              = VW.ORIGEM        AND
						 TMP.CPF                                 = VW.CPF           AND
						 TMP.NOME                                = VW.NOME          AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) and
	  not exists (select top 1 * 
                    from entregas_regular.dbo.N65_20122018_002 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO       and 
				         tmp.origem                              = VW.ORIGEM        AND
						 TMP.CPF                                 = VW.CPF           AND
						 TMP.NOME                                = VW.NOME          AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						)  
GO
SELECT projeto, origem, cpf, nome, funcao, qtd_suspensao, motivo_suspensao, data_suspensao, motivo_desligado, data_desligado
  --INTO entregas_regular.dbo.N65_29122018_002 
  FROM VW_N65_DADOS_AVALIADORES_REDACAO_ENEM_29122018_002
  

GO

-------------------------------------------------------------------------------------------------------------------------
-- REGISTROS  COM CORRETORES DESLIGADOS
-------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER VIEW VW_N65_DADOS_AVALIADORES_REDACAO_ENEM_29122018_003 AS
SELECT * FROM VW_N65_DADOS_AVALIADORES_REDACAO_ENEM vw WITH (NOLOCK)
where 
      funcao is  null and
	  not exists (select top 1 * 
                    from entregas_regular.dbo.N65_18122018_003 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO          and 
				         tmp.origem                              = VW.ORIGEM           AND
						 TMP.CPF                                 = VW.CPF              AND
						 TMP.NOME                                = VW.NOME             AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO    AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) and
	  not exists (select top 1 * 
                    from entregas_regular.dbo.N65_19122018_003 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO          and 
				         tmp.origem                              = VW.ORIGEM           AND
						 TMP.CPF                                 = VW.CPF              AND
						 TMP.NOME                                = VW.NOME             AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO    AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) and
	  not exists (select top 1 * 
                    from entregas_regular.dbo.N65_20122018_003 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO          and 
				         tmp.origem                              = VW.ORIGEM           AND
						 TMP.CPF                                 = VW.CPF              AND
						 TMP.NOME                                = VW.NOME             AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO    AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) and
	  not exists (select top 1 * 
                    from entregas_regular.dbo.N65_21122018_003 tmp /* BASE PARA REFERENCIA DE COMPARACAO */
				   where tmp.projeto                             = VW.PROJETO          and 
				         tmp.origem                              = VW.ORIGEM           AND
						 TMP.CPF                                 = VW.CPF              AND
						 TMP.NOME                                = VW.NOME             AND 
						 isnull(TMP.FUNCAO,0)                    = isnull(VW.FUNCAO,0) AND 
						 TMP.QTD_SUSPENSAO                       = VW.QTD_SUSPENSAO    AND 
						 ISNULL(TMP.MOTIVO_SUSPENSAO, 0)         = ISNULL(VW.MOTIVO_SUSPENSAO,0)          AND 
						 ISNULL(TMP.DATA_SUSPENSAO,'1970-08-03') = ISNULL(VW.DATA_SUSPENSAO,'1970-08-03') AND 
						 ISNULL(TMP.MOTIVO_DESLIGADO,0)          = ISNULL(VW.MOTIVO_DESLIGADO,0)          AND
						 ISNULL(TMP.DATA_DESLIGADO,'1970-08-03') = ISNULL(VW.DATA_DESLIGADO,'1970-08-03')
						) 
GO
SELECT projeto, origem, cpf, nome, funcao, qtd_suspensao, motivo_suspensao, data_suspensao, motivo_desligado, data_desligado
  INTO entregas_regular.dbo.N65_29122018_003 
  FROM VW_N65_DADOS_AVALIADORES_REDACAO_ENEM_29122018_003
  

GO

-------------------------------------------------------------------------------------------------------------------------------------------
-- VALIDACAO 
-------------------------------------------------------------------------------------------------------------------------------------------
/* TESTA SE OS DESLIGADOS POSSSUEM DATA DE DESLIGAMENTO MENOR QUE A A MAIOR DATA DE CORRECAO 
RESULTADO ESPERADO = 0 */
SELECT * FROM (
SELECT  COR.ID_CORRETOR, MAIOR_CORRECAO = MAX(COR.DATA_TERMINO) , DESLIGAMENTO = VW.DATA_DESLIGADO
  FROM CORRECOES_CORRECAO COR WITH (NOLOCK) JOIN  VW_N65_DADOS_AVALIADORES_REDACAO_ENEM VW WITH (NOLOCK) ON (COR.id_corretor = VW.ID_CORRETOR)
  WHERE VW.DATA_DESLIGADO IS NOT NULL 
  GROUP BY COR.ID_CORRETOR, VW.DATA_DESLIGADO) AS TAB
  WHERE MAIOR_CORRECAO > DESLIGAMENTO


/*MAIS DE UMA FUNCAO PARA A MESMA PESSOA*/
SELECT * FROM auth_group
SELECT * FROM AUTH_USER_GROUPS USG
WHERE USG.user_id = 7653