
--##################################################################################################
-- LEMBRAR DE TROCAR O NOME DA BASE A SER USADA COMO REFERENCIA 
--##################################################################################################


--exec sp_MSforeachtable @command1="DISABLE TRIGGER ALL On ?"
--update projeto_projeto set codigo = '1810401'

CREATE OR ALTER VIEW [dbo].[VW_N65_DADOS_AVALIADORES_REDACAO_ENEM] AS   
select   
 COR.ID              AS CORRETOR_ID, 
 PRO.ID              AS PROJETO_ID, 
 CO_PROJETO          = pro.codigo,  
 TP_ORIGEM           = 'F',  
 NU_CPF              = PES.CPF,  
 NO_CORRETOR         = PES.NOME, 
 NO_MAE_CORRETOR     = TMP.nome,				  --  ########################################
 DT_NASCIMENTO       = TMP.data_nascimento,				  --  ########################################
 TP_SEXO             = TMP.sexo,						  --  ########################################
 NO_LOGRADOURO       = TMP.Logradouro,						  --  ########################################
 DS_COMPLEMENTO      = TMP.Complemento,					  --  ########################################
 NO_BAIRRO           = TMP.Bairro,							  --  ########################################
 NO_MUNICIPIO        = TMP.Município,				  --  ########################################
 NU_CEP              = TMP.CEP,							  --  ########################################
 CO_MUNICIPIO        = TMP.CEP,
 SG_UF               = TMP.UF,					  --  ########################################
 NU_TEL_RESIDENCIAL  = tmp.[Telefone residencial],		  --  ########################################
 NU_TEL_CELULAR      = tmp.celular,			  --  ########################################
 TX_EMAIL            = tmp.email,						  --  ########################################
 TP_TITULACAO        = 0,                              --  ########################################
 TP_FUNCAO           = CASE WHEN PES.usuario_id IN (SELECT USER_ID FROM auth_user_user_permissions WHERE permission_id = 320) THEN 5
                            WHEN GRO.ID = 26 THEN 1 
                            WHEN GRO.ID = 34 THEN 2
                            WHEN GRO.ID = 25 THEN 3 
                            WHEN GRO.ID IN (30,29,27) THEN 4
                            ELSE NULL END , 
 NU_SUSPENSAO        = csd.qtd_suspensao,
 CO_MOTIVO_SUSPENSAO = csd.motivo_id_suspensao , 
 DT_SUSPENSAO        = csd.data_suspensao,
 CO_MOTIVO_EXCLUSAO  = csd.motivo_id_desligamento,
 DT_EXCLUSAO         = csd.data_desligamento
  from usuarios_pessoa pes           join projeto_projeto_usuarios           ppu  on (pes.usuario_id = ppu.USER_ID)  
                                     JOIN auth_user_groups                   USG  ON (USG.user_id = PES.usuario_id)
									 join auth_group                         GRO  ON (GRO.id      = USG.group_id)
                                     join projeto_projeto                    pro  on (pro.id = ppu.projeto_id)
									 JOIN CORRECOES_CORRETOR                 COR  ON (COR.ID = PES.USUARIO_ID )
							    LEFT JOIN tmp_n65                            TMP  ON (TMP.cpf = PES.CPF)		 
								LEFT JOIN vw_corretor_suspensao_desligamento csd  ON (csd.corretor_id = PES.usuario_id)



-------------------------------------------------------------------------------------------------------------------------
-- REGISTROS SEM CONTAR COM CORRETORES DESLIGADOS
-------------------------------------------------------------------------------------------------------------------------
