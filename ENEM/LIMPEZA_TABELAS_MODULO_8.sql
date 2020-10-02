select * from auth_group
select * from auth_group_permissions
select * from auth_permission
select * from auth_user
select * from auth_user_groups
select * from avisos_aviso              ---  ATUALIZAR 
select * from avisos_avisousuario
select * from core_feature             -- VER COM OS MENINOS
select * from core_mensagem            -- VER COM OS MENINOS
select * from core_parametros            -- VER COM OS MENINOS
select * from correcoes_analise       --  LIMPAR
select * from correcoes_correcao       --  LIMPAR
select * from correcoes_corretor --  ATUALIZAR
select * from correcoes_evento     -- NAO MEXER
select * from correcoes_filapessoal --  LIMPAR
select * from correcoes_gabarito --  LIMPAR
select * from correcoes_grupocorretor    -- NAO MEXER
select * from correcoes_historicocorrecao --  LIMPAR
select * from correcoes_redacao --  LIMPAR
select * from correcoes_redacaosituacao   -- NAO MEXER
select * from correcoes_situacao   -- NAO MEXER
select * from correcoes_status  -- NAO MEXER
select * from correcoes_statuscorretor    -- NAO MEXER
select * from correcoes_tipo  -- NAO MEXER
select * from django_admin_log
select * from django_content_type
select * from django_migrations
select * from django_session
select * from external_auth_login    --- VER COM OS MENINOS
select * from external_auth_token     -- VER COM OS MENINOS
select * from projeto_projeto        --- ATUALIZAR
select * from projeto_projeto_usuarios -- ATUALIZAR
select * from reports_controlerelatorio   -- VER COM OS MENINOS
select * from usuarios_hierarquia         -- VER COM OS MENINOS
select * from usuarios_hierarquia_usuarios  -- VER COM OS MENINOS
select * from usuarios_pessoa            -- ATUALIZAR
select * from usuarios_tipohierarquia  -- NAO MEXER 



/*******************************************************************************
			LIMPAR TABELAS DE LOG
*******************************************************************************/
SELECT 'TRUNCATE TABLE ' +  NAME FROM SYS.TABLES 
WHERE NAME LIKE 'LOG_%' AND 
REPLACE(NAME, 'LOG_','') IN (
'correcoes_analise',
'correcoes_correcao',
'correcoes_filapessoal',
'correcoes_gabarito',
'correcoes_historicocorrecao',
'correcoes_redacao',
'correcoes_fila1',
'correcoes_fila2',
'correcoes_fila3',
'correcoes_fila4',
'correcoes_filaauditoria',
'correcoes_correcaoouro',
'correcoes_filaouro',
'correcoes_conclusao_analise',
'correcoes_pendenteanalise',
'correcoes_corretor_indicadores')


/*******************************************************************************
				ZERAR CHAVES PRIMARIAS DAS TABELAS DE LOG
*******************************************************************************/
SELECT ' DBCC CHECKIDENT(' + CHAR(39) + NAME + CHAR(39) + ', RESEED, 0) ;' +  NAME FROM SYS.TABLES 
WHERE NAME LIKE 'LOG_%' AND 
REPLACE(NAME, 'LOG_','') IN (
'correcoes_analise',
'correcoes_correcao',
'correcoes_filapessoal',
'correcoes_gabarito',
'correcoes_historicocorrecao',
'correcoes_redacao',
'correcoes_fila1',
'correcoes_fila2',
'correcoes_fila3',
'correcoes_fila4',
'correcoes_filaauditoria', 
'correcoes_correcaoouro',
'correcoes_filaouro',
'correcoes_conclusao_analise',
'correcoes_pendenteanalise',
'correcoes_corretor_indicadores')


/*******************************************************************************
			LIMPAR TABELAS
*******************************************************************************/
SELECT 'TRUNCATE TABLE ' +  NAME FROM SYS.TABLES 
WHERE NAME IN (
'correcoes_analise',
'correcoes_correcao',
'correcoes_filapessoal',
'correcoes_gabarito',
'correcoes_historicocorrecao',
'correcoes_redacao',
'correcoes_fila1',
'correcoes_fila2',
'correcoes_fila3',
'correcoes_fila4',
'correcoes_filaauditoria',
'correcoes_correcaoouro',
'correcoes_filaouro',
'correcoes_conclusao_analise',
'correcoes_pendenteanalise',
'correcoes_corretor_indicadores')


/*******************************************************************************
			ZERAR CHAVES PRIMARIAS DAS TABELAS
*******************************************************************************/
SELECT ' DBCC CHECKIDENT(' + CHAR(39) + NAME + CHAR(39) + ', RESEED, 0) ;' +  NAME FROM SYS.TABLES 
WHERE NAME IN (
'correcoes_analise',
'correcoes_correcao',
'correcoes_filapessoal',
'correcoes_gabarito',
'correcoes_historicocorrecao',
'correcoes_redacao',
'correcoes_fila1',
'correcoes_fila2',
'correcoes_fila3',
'correcoes_fila4',
'correcoes_filaauditoria',
'correcoes_correcaoouro',
'correcoes_filaouro',
'correcoes_conclusao_analise',
'correcoes_pendenteanalise',
'correcoes_corretor_indicadores')


