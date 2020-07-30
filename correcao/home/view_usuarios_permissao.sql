CREATE OR ALTER VIEW VW_USUARIO_PERMISSAO AS 
select usu.id as usuario_id, usu.last_name as usuario_nome, usu.nome_civil as usuario_nome_civil,
       usu.email as usuario_email, usu.is_active as usuario_status, USU.username AS USUARIO_USERNAME, 
	   usu.person_id as usuario_pessoa_id, 
	   per.id as permissao_id, per.name as permissao_nome, 
	   gru.id as grupo_ID, gru.name as grupo_nome
         from auth_user usu left join auth_user_user_permissions upr on (usu.id = upr.user_id)
                            left join auth_permission            per on (per.id = upr.permission_id)
							left join auth_group_permissions     ugp on (per.id = ugp.permission_id)
							left join auth_group                 gru on (gru.id = ugp.group_id)