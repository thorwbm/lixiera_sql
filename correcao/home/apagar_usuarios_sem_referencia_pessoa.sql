declare @usuario_id int 

declare CUR_ cursor for 
	select distinct usu.id
		from auth_user usu left join vw_tabelas_referencia_auth_user ref on (ref.usuario_id = usu.id and 
																					  ref.tabela not like 'auth_%')
		where person_id is null  and 
			  ref.usuario_id is  null
	  --------------------------------------------
	open CUR_ 
		fetch next from CUR_ into @usuario_id
		while @@FETCH_STATUS = 0
			BEGIN
			   
				exec sp_deletar_usuario @usuario_id

			fetch next from CUR_ into @usuario_id
			END
	close CUR_ 
deallocate CUR_


  --       exec sp_deletar_usuario


-- ############ usuarios sem referencia a nao ser nas tabelas de controle de permissao #######
select distinct usu.id
from auth_user usu left join vw_tabelas_referencia_auth_user ref on (ref.usuario_id = usu.id and 
                                                                              ref.tabela not like 'auth_%')
where person_id is null  and 
      ref.usuario_id is null

-- ############ usuarios com referencia alem das referencias nas tabelas de controle de permissao #######
select distinct usu.id
from auth_user usu left join vw_tabelas_referencia_auth_user ref on (ref.usuario_id = usu.id and 
                                                                              ref.tabela not like 'auth_%')
where person_id is null  and 
      ref.usuario_id is not null