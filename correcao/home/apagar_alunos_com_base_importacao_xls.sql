
declare @usuario_id int, @aluno_id int, @censo_id int

begin try
begin tran 
declare CUR_ cursor for 
	select distinct usu.id , alu.id , cen.id 
	from [import_aluno_sem_informacao] imp join auth_user                             usu on (imp.nome = usu.last_name) 
	                                       join academico_aluno                       alu on (alu.nome = imp.nome)
	                                       join censo_censo                           cen on (cen.aluno_id = alu.id)
	                                  left join vw_tabelas_referencia_academico_aluno arf on (arf.aluno_id = alu.id)
	                                  left join vw_tabelas_referencia_auth_user       ref on (ref.usuario_id = usu.id and 
									                                                          ref.tabela not like 'auth_%')
      where    imp.cpf is  null 
	  --------------------------------------------
	open CUR_ 
		fetch next from CUR_ into @usuario_id, @aluno_id, @censo_id
		while @@FETCH_STATUS = 0
			BEGIN
			    delete from censo_censo where id = @censo_id

				delete from academico_aluno where id = @aluno_id

				exec sp_deletar_usuario @usuario_id

			fetch next from CUR_ into @usuario_id, @aluno_id, @censo_id
			END
	close CUR_ 
deallocate CUR_
commit 
end try
begin catch
	rollback 
	print error_message()
end catch


--########################  COMPLEMENTO #########################

select * 
--   delete 
from academico_aluno where id = 59701

select * 
--  delete
from censo_censo where aluno_id = 60182


select * 
--   delete 
from academico_aluno where id = 60182
