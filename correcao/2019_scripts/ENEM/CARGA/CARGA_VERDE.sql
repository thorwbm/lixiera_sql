-- *********************************************************
SELECT 'INSERT INTO auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) VALUES (' + 
        CONVERT(VARCHAR(10),ID) + ', ' + ISNULL(CHAR(39) + password + CHAR(39), 'NULL') + ', ' + ISNULL(CHAR(39) + CONVERT(VARCHAR(30),last_login) + CHAR(39), 'NULL') + ', ' + 
		ISNULL(CONVERT(VARCHAR(10),is_superuser),'NULL') + ', ' + ISNULL(CHAR(39) + username + CHAR(39), 'NULL') + ', ' + ISNULL(CHAR(39) + first_name + CHAR(39), 'NULL') + ', ' + 
		ISNULL(CHAR(39) + last_name + CHAR(39), 'NULL') + ', ' + ISNULL(CHAR(39) + email + CHAR(39), 'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),is_staff),'NULL') + ', ' +
		ISNULL(CONVERT(VARCHAR(10),is_active),'NULL') + ', ' + ISNULL(CHAR(39) + CONVERT(VARCHAR(30),date_joined) + CHAR(39), 'NULL') + ') '
-- SELECT top 10 * 
FROM auth_user 
WHERE id IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))

-- *********************************************************
SELECT 'INSERT INTO auth_user_groups (id, user_id, group_id) VALUES (' + 
        CONVERT(VARCHAR(10),ID) + ', ' +  ISNULL(CONVERT(VARCHAR(10),user_id),'NULL') + ', ' +  ISNULL(CONVERT(VARCHAR(10),group_id),'NULL') + ') '  
-- SELECT TOP 10* 
  FROM auth_user_groups
  WHERE user_id IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))

-- ********************************************************
SELECT 'INSERT INTO PROJETO_PROJETO (id, descricao, max_correcoes_dia, subtitulo, titulo, fila_prioritaria, fila_supervisor, limite_nota_competencia, limite_nota_final, '+ 
       'data_inicio, data_termino, ouro_frequencia, ouro_quantidade, peso_aproveitamento_individual, peso_aproveitamento_coletivo, peso_prova_ouro, codigo, etapa_ensino_id, '+
	   'peso_competencia) VALUES (' + 
	    CONVERT(VARCHAR(10),ID) + ', ' + ISNULL(CHAR(39) + descricao + CHAR(39), 'NULL') + ', ' +  ISNULL(CONVERT(VARCHAR(10),max_correcoes_dia),'NULL') + ', ' + 
		ISNULL(CHAR(39) + subtitulo + CHAR(39), 'NULL') + ', ' + ISNULL(CHAR(39) + titulo + CHAR(39), 'NULL') + ', ' +  ISNULL(CONVERT(VARCHAR(10),fila_prioritaria),'NULL') + ', ' + 
		ISNULL(CONVERT(VARCHAR(10),fila_supervisor),'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),limite_nota_competencia),'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),limite_nota_final),'NULL') + ', ' + 
		ISNULL(CHAR(39) + CONVERT(VARCHAR(30),data_inicio) + CHAR(39),'NULL') + ', ' + ISNULL(CHAR(39) + CONVERT(VARCHAR(30),data_termino) + CHAR(39),'NULL') + ', ' + 
		ISNULL(CONVERT(VARCHAR(10),ouro_frequencia),'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),ouro_quantidade),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),peso_aproveitamento_individual),'NULL') + ', ' + 
		ISNULL(CONVERT(VARCHAR(10),peso_aproveitamento_coletivo),'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),peso_prova_ouro),'NULL') + ', '+ 
		ISNULL(CHAR(39) + CONVERT(VARCHAR(10),CODIGO) + CHAR(39),'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),etapa_ensino_id),'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),peso_competencia),'NULL') + ')'
-- SELECT TOP 10 * 
FROM PROJETO_PROJETO 
SELECT TOP 10 * 
FROM PROJETO_PROJETO 

-- ***********************************************************

SELECT 'INSERT INTO usuarios_hierarquia (id, descricao, id_hierarquia_usuario_pai, id_tipo_hierarquia_usuario, id_usuario_responsavel, indice) VALUES (' + 
        CONVERT(VARCHAR(10),ID) + ', ' + ISNULL(CHAR(39) + descricao + CHAR(39),'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),ID_HIERARQUIA_USUARIO_PAI) , 'NULL') + ', ' 
           + ISNULL(CONVERT(VARCHAR(10),id_tipo_hierarquia_usuario) , 'NULL') + ', ' +  ISNULL(CONVERT(VARCHAR(10),id_usuario_responsavel) , 'NULL') + ', '  
		   + ISNULL(CHAR(39) + INDICE + CHAR(39),'NULL') + ')'
-- SELECT TOP 10 * 
 FROM usuarios_hierarquia 
WHERE  indice LIKE  '%.401.%' 
SELECT TOP 10 * 
 FROM usuarios_hierarquia 
WHERE  indice LIKE  '%.401.%' 

--**********************************************************
SELECT 'INSERT INTO usuarios_hierarquia_usuarios (' + CONVERT(VARCHAR(10),ID) + ', '  + CONVERT(VARCHAR(10),hierarquia_id) + ', '+ CONVERT(VARCHAR(10),user_id) + ')'
-- SELECT * 
  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%')

-- *********************************************************
SELECT 'INSERT INTO usuarios_pessoa (ID, NOME, CPF, EMAIL, USUARIO_ID, SECRET) VALUES (' + CONVERT(VARCHAR(10),ID) + ', ' + CHAR(39) + cpf + CHAR(39)+ ', ' + CHAR(39) + EMAIL + CHAR(39)
       + ', ' + CONVERT(VARCHAR(10),USUARIO_ID) + ', '+ISNULL( CHAR(39) + SECRET + CHAR(39), 'NULL') + ')'
-- SELECT *
FROM usuarios_pessoa
WHERE USUARIO_ID IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))

-- *********************************************************
SELECT 'INSERT INTO projeto_projeto_usuarios (' + CONVERT(VARCHAR(10),ID) + ', ' +  CONVERT(VARCHAR(10),projeto_id) + ', ' +  CONVERT(VARCHAR(10),user_id) + ') '
-- SELECT * 
FROM projeto_projeto_usuarios
WHERE USER_ID IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%')) 

-- ********************************************************

SELECT 'INSERT INTO correcoes_corretor (' + CONVERT(VARCHAR(10),ID) + ', ' +  CONVERT(VARCHAR(10),max_correcoes_dia) + ', ' +  CONVERT(VARCHAR(10),id_grupo) + ', ' +
         CONVERT(VARCHAR(10),pode_corrigir_1) + ', ' +  CONVERT(VARCHAR(10),pode_corrigir_2) + ', ' +  CONVERT(VARCHAR(10),pode_corrigir_3) + ', ' +  CONVERT(VARCHAR(10),status_id) + ', ' +
		   ISNULL(CONVERT(VARCHAR(10),nota_corretor),'NULL') + ',  NULL, ' + CHAR(39) + tipo_cota + CHAR(39)+ ', ' + ISNULL(CONVERT(VARCHAR(10),DSP),'NULL') + ', ' + ISNULL(CONVERT(VARCHAR(10),tempo_medio_correcao),'NULL') + 
		    ', ' + ISNULL(CONVERT(VARCHAR(10),supervisor_em_banca),'NULL') + ') '
-- SELECT * 
FROM correcoes_corretor
WHERE ID IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%')) 

-- *******************************************************************
SELECT 'INSERT INTO correcoes_redacao (' + CHAR(39) + link_imagem_recortada + CHAR(39)+ ', ' + ISNULL(CHAR(39) + link_imagem_recortada + CHAR(39),'null')  + ', '  + ISNULL(CONVERT(VARCHAR(10),nota_final),'NULL') + ', '  + ISNULL(CONVERT(VARCHAR(10),id_redacao_situacao),'NULL') + ', '
        + CHAR(39) + co_barra_redacao + CHAR(39)+ ', '  + CHAR(39) + co_inscricao + CHAR(39) + ', ' + ISNULL(CONVERT(VARCHAR(10),co_formulario),'NULL') +  ', ' +
		 ISNULL(CONVERT(VARCHAR(10),id_prova),'NULL') +  ', ' +  ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id),'NULL') +  ', ' +
		  ISNULL(CONVERT(VARCHAR(10),id_redacaoouro),'NULL') +  ', ' +  ISNULL(CONVERT(VARCHAR(10),id_correcao_situacao),'NULL') +  ', ' +  ISNULL(CONVERT(VARCHAR(10),id_status),'NULL') +  ', ' +
		   ISNULL(CONVERT(VARCHAR(10),cancelado),'NULL') +  ', null, ' +  ISNULL(CONVERT(VARCHAR(10),motivo_id),'NULL') +  ') ' 

-- SELECT top 10 * 
FROM correcoes_redacao RED 
WHERE id IN (
SELECT REDACAO_ID FROM (
SELECT REDACAO_ID FROM correcoes_correcao 
WHERE id_corretor IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))  

UNION 
SELECT REDACAO_ID  FROM correcoes_FILA1 

UNION 
SELECT REDACAO_ID  FROM correcoes_FILA2 
WHERE REPLACE(corrigido_por,',','') IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))  

UNION 
SELECT REDACAO_ID  FROM correcoes_FILA3 
WHERE REPLACE(corrigido_por,',','') IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))  

UNION 
SELECT REDACAO_ID  FROM correcoes_FILA4 

UNION 
SELECT REDACAO_ID  FROM correcoes_FILAPESSOAL 
WHERE ID_CORRETOR IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))  
) AS TAB 
)

  
--  **************************************************************************
select  'INSERT INTO correcoes_correcao (' + CONVERT(VARCHAR(10),ID) + ', ' + ISNULL( CHAR(39) + CONVERT(VARCHAR(30),data_inicio) + CHAR(39), 'null') +  ', ' +  isnull(CHAR(39) + CONVERT(VARCHAR(30),data_termino) + CHAR(39),'null') +  ', ' +
          + ISNULL( CHAR(39) + correcao + CHAR(39), 'null') +  ', ' + ISNULL( CHAR(39) + link_imagem_recortada + CHAR(39), 'null') +  ', '  + ISNULL( CHAR(39) + link_imagem_original + CHAR(39), 'null') +  ', ' +  ISNULL(CONVERT(VARCHAR(10),nota_final),'NULL') +  ', '+  
		    ISNULL(CONVERT(VARCHAR(10),competencia1),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),competencia2),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),competencia3),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),competencia4),'NULL') +  ', '
		 +  ISNULL(CONVERT(VARCHAR(10),competencia5),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),nota_competencia1),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),nota_competencia2),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),nota_competencia3),'NULL') +  ', '
		 +  ISNULL(CONVERT(VARCHAR(10),nota_competencia4),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),nota_competencia5),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),id_auxiliar1),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),id_auxiliar2),'NULL') +  ', '
		 +  ISNULL(CONVERT(VARCHAR(10),id_correcao_situacao),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),id_corretor),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),id_status),'NULL') +  ', '
		 +  ISNULL(CONVERT(VARCHAR(10),id_tipo_correcao),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', ' + ISNULL( CHAR(39) + co_barra_redacao + CHAR(39), 'null') +  ', '+  ISNULL(CONVERT(VARCHAR(10),tempo_em_correcao),'NULL') +  ', '
		 +  ISNULL(CONVERT(VARCHAR(10),tipo_auditoria_id),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),atualizado_por),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),angulo_imagem),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),token_auxiliar1),'NULL') +  ', '
		 +  ISNULL(CONVERT(VARCHAR(10),token_auxiliar2),'NULL') +  ', '+  ISNULL(CONVERT(VARCHAR(10),redacao_id),'NULL') +  ') '

--  select * 
from correcoes_correcao
where id_corretor IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%')) 

  select * 
from correcoes_correcao
where id_corretor IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))
  
--  ****************************************************************************************************
select 'INSERT INTO correcoes_analise (' + CONVERT(VARCHAR(10),ID) + ', ' + ISNULL( CHAR(39) + CONVERT(VARCHAR(30),data_inicio_A) + CHAR(39), 'null') +  ', ' +  isnull(CHAR(39) + CONVERT(VARCHAR(30),data_inicio_B) + CHAR(39),'null') +  ', ' +
          ISNULL( CHAR(39) + CONVERT(VARCHAR(30),data_termino_A) + CHAR(39), 'null') +  ', ' +  isnull(CHAR(39) + CONVERT(VARCHAR(30),data_termino_B) + CHAR(39),'null') +  ', ' +  + ISNULL( CHAR(39) + link_imagem_recortada + CHAR(39), 'null') +  ', '  + 
		  ISNULL( CHAR(39) + link_imagem_original + CHAR(39), 'null') +  ', ' +  ISNULL(CONVERT(VARCHAR(10),nota_final_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),nota_final_B),'NULL') +  ', '+  
		  ISNULL(CONVERT(VARCHAR(10),competencia1_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),competencia1_B),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),competencia2_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),competencia2_B),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),competencia3_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),competencia3_B),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),competencia4_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),competencia4_B),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),competencia5_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),competencia5_B),'NULL') +  ', '+
		  ISNULL(CONVERT(VARCHAR(10),nota_competencia1_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),nota_competencia1_B),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),diferenca_competencia1),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),situacao_competencia1),'NULL') +  ', '+
		  ISNULL(CONVERT(VARCHAR(10),nota_competencia2_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),nota_competencia2_B),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),diferenca_competencia2),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),situacao_competencia2),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),nota_competencia3_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),nota_competencia3_B),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),diferenca_competencia3),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),situacao_competencia3),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),nota_competencia4_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),nota_competencia4_B),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),diferenca_competencia4),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),situacao_competencia4),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),nota_competencia5_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),nota_competencia5_B),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),diferenca_competencia5),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),situacao_competencia5),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),id_auxiliar1_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_auxiliar2_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_auxiliar1_B),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_auxiliar2_B),'NULL') +  ', '+ 
	      ISNULL(CONVERT(VARCHAR(10),id_status_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_status_B),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_tipo_correcao_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_tipo_correcao_B),'NULL') +  ', '+ 
	      ISNULL(CONVERT(VARCHAR(10),diferenca_situacao),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),situacao_nota_final),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_corretor_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_corretor_B),'NULL') +  ', '+ 
		  ISNULL( CHAR(39) + co_barra_redacao + CHAR(39), 'null') +  ', '+ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', '+ISNULL(CONVERT(VARCHAR(10),id_correcao_situacao_A),'NULL') +  ', '+ISNULL(CONVERT(VARCHAR(10),id_correcao_situacao_B),'NULL') +  ', '+
	      ISNULL(CONVERT(VARCHAR(10),diferenca_nota_final),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_correcao_A),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),id_correcao_B),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),conclusao_analise),'NULL') +  ', '+ 
	      ISNULL(CONVERT(VARCHAR(10),fila),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),nota_corretor),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),aproveitamento),'NULL') +  ', '+ ISNULL(CONVERT(VARCHAR(10),nota_desempenho),'NULL') +  ', '+ 
		  ISNULL(CONVERT(VARCHAR(10),redacao_id),'NULL') +  ', '+ ISNULL( CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'null') +  ') ' 
-- select * 
from (select * 
from correcoes_analise   
where id_corretor_A IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))
union 
select * 
from correcoes_analise   
where id_corretor_b IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))
 ) as tab   

 --*****************************************************************************************
select 'INSERT INTO correcoes_fila1 (id, corrigido_por, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, criado_em, redacao_id) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL( CHAR(39) + corrigido_por + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_correcao),'NULL') +  ', ' +
         ISNULL(CONVERT(VARCHAR(10),id_grupo_corretor),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', ' + ISNULL( CHAR(39) + co_barra_redacao + CHAR(39), 'null') +  ', ' +
		 ISNULL( CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'null') +  ', ' + ISNULL(CONVERT(VARCHAR(10),redacao_id),'NULL') +  ')'
 -- select * 
 from correcoes_fila1
 
 --*****************************************************************************************
 select 'INSERT INTO correcoes_fila2 (id, corrigido_por, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, criado_em, redacao_id) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL( CHAR(39) + corrigido_por + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_correcao),'NULL') +  ', ' +
         ISNULL(CONVERT(VARCHAR(10),id_grupo_corretor),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', ' + ISNULL( CHAR(39) + co_barra_redacao + CHAR(39), 'null') +  ', ' +
		 ISNULL( CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'null') +  ', ' + ISNULL(CONVERT(VARCHAR(10),redacao_id),'NULL') +  ')'
 -- select * 
 from correcoes_fila2

 --*****************************************************************************************
 select 'INSERT INTO correcoes_fila3 (id, corrigido_por, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, criado_em, redacao_id) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL( CHAR(39) + corrigido_por + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_correcao),'NULL') +  ', ' +
         ISNULL(CONVERT(VARCHAR(10),id_grupo_corretor),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', ' + ISNULL( CHAR(39) + co_barra_redacao + CHAR(39), 'null') +  ', ' +
		 ISNULL( CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'null') +  ', ' + ISNULL(CONVERT(VARCHAR(10),redacao_id),'NULL') +  ')'
 -- select * 
 from correcoes_fila3
 
 --*****************************************************************************************
 select 'INSERT INTO correcoes_fila4 (id, corrigido_por, id_correcao, id_grupo_corretor, id_projeto, co_barra_redacao, criado_em, redacao_id) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL( CHAR(39) + corrigido_por + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_correcao),'NULL') +  ', ' +
         ISNULL(CONVERT(VARCHAR(10),id_grupo_corretor),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', ' + ISNULL( CHAR(39) + co_barra_redacao + CHAR(39), 'null') +  ', ' +
		 ISNULL( CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'null') +  ', ' + ISNULL(CONVERT(VARCHAR(10),redacao_id),'NULL') +  ')'
 -- select * 
 from correcoes_fila4
 
 --*****************************************************************************************
 select 'INSERT INTO correcoes_filaauditoria (id, id_projeto, co_barra_redacao, id_correcao, corrigido_por, pendente, tipo_id, id_corretor, criado_em, redacao_id) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', ' + ISNULL( CHAR(39) + co_barra_redacao + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_correcao),'NULL') +  ', ' +
         ISNULL( CHAR(39) + corrigido_por + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),pendente),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),tipo_id),'NULL') +  ', ' +
		 ISNULL(CONVERT(VARCHAR(10),id_corretor),'NULL') +  ', ' + ISNULL( CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'null') +  ', ' + ISNULL(CONVERT(VARCHAR(10),redacao_id),'NULL') +  ')'
 -- select  top 10 * 
 from correcoes_filaauditoria
 

 --*****************************************************************************************
 select 'INSERT INTO correcoes_filapessoal (id, corrigido_por, atual, id_correcao, id_corretor, id_grupo_corretor, id_projeto, co_barra_redacao, id_tipo_correcao, criado_em, redacao_id) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL( CHAR(39) + corrigido_por + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),atual),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_correcao),'NULL') +  ', ' +
         ISNULL(CONVERT(VARCHAR(10),id_corretor),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_grupo_corretor),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_projeto),'NULL') +  ', ' + ISNULL( CHAR(39) + co_barra_redacao + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_tipo_correcao),'NULL') +  ', ' + 
		 ISNULL( CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'null') +  ', ' + ISNULL(CONVERT(VARCHAR(10),redacao_id),'NULL') +  ')'
 -- select  top 10 * 
 from correcoes_filapessoal

 --*****************************************************************************************
 select 'INSERT INTO alerta_alerta (id, criado_em, excluido_em, id_tipo, id_usuario) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL(  CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'NULL') +  ', ' + ISNULL(  CHAR(39) + CONVERT(VARCHAR(30),excluido_em) + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_tipo),'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_usuario),'NULL') +  ')'
 -- select  top 10 * 
 from alerta_alerta
  where id_usuario  IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))
  
 --*****************************************************************************************
 select 'INSERT INTO alerta_parametro (id, descricao, valor) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL(  CHAR(39) + descricao + CHAR(39), 'NULL') +  ', ' +  ISNULL(CONVERT(VARCHAR(10),valor),'NULL') +  ') '
 -- select  top 10 * 
 from alerta_parametro


 --*****************************************************************************************
 select 'INSERT INTO alerta_parametro (id, descricao, valor) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL(  CHAR(39) + descricao + CHAR(39), 'NULL') +  ', ' +  ISNULL(CONVERT(VARCHAR(10),valor),'NULL') +  ') -- ????????????????????????????'
 -- select  top 10 * 
 from alerta_parametro

 --*****************************************************************************************
 select 'INSERT INTO correcoes_suspensao (id, criado_em, excluido_em, id_corretor) values (' + 
         CONVERT(VARCHAR(10),ID) + ', ' + ISNULL(  CHAR(39) + CONVERT(VARCHAR(30),criado_em) + CHAR(39), 'NULL') +  ', ' + ISNULL(  CHAR(39) + CONVERT(VARCHAR(30),excluido_em) + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),id_corretor),'NULL') +  ')'
 -- select  top 10 * 
 from correcoes_suspensao
  where id_corretor  IN (SELECT USER_ID  FROM usuarios_hierarquia_usuarios USU
  WHERE hierarquia_id IN (SELECT id FROM usuarios_hierarquia WHERE  indice LIKE  '%.401.%'))

  
 --*****************************************************************************************
 select 'INSERT INTO parametro (nome, valor) values (' + 
          ISNULL(  CHAR(39) + nome + CHAR(39), 'NULL') +  ', ' + ISNULL(CONVERT(VARCHAR(10),valor),'NULL') +  ')  -- ????????????????????????????'
 -- select  top 10 * 
 from parametro

  