declare @redacao_id int, @id_projeto int 
set @redacao_id = 848113
set @id_projeto = 4

if (exists (select 1 from correcoes_fila3 fil3 join correcoes_filapessoal filp on (fil3.redacao_id = filp.redacao_id and 
                                                                                   fil3.id_projeto = filp.id_projeto)
			where fil3.redacao_id = @redacao_id and 
			      fil3.id_projeto = @id_projeto))
	begin 

		delete from correcoes_filapessoal where redacao_id = @redacao_id and id_projeto = @id_projeto
		
		update correcoes_fila3 set consistido = null 
		where redacao_id = @redacao_id and id_projeto = @id_projeto
	end



