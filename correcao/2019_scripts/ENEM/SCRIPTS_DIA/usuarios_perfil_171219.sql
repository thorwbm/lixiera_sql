select usu.id as usuario_id,
       pes.nome as pessoa_nome, pes.cpf as pessoa_cpf, 
	   gru.name as perfil, TIPO = 'PPL'
  from auth_user usu join auth_user_groups aug on (usu.id = aug.user_id)
                     join auth_group       gru on (gru.id = aug.group_id)
					 join usuarios_pessoa  pes on (usu.id = pes.usuario_id)
