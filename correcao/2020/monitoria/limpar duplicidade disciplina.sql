
begin tran
declare  @disciplina varchar(500), @cod_dis_aux int 
declare CUR_ cursor for 
	    select des_dis, min(cod_dis) as des_dis 
		  from disciplina 
		 group by des_dis 
		having count(1) > 1

	open CUR_ 
		fetch next from CUR_ into @disciplina, @cod_dis_aux
		while @@FETCH_STATUS = 0
			BEGIN
				-- ***** EQUIVALENCIA *****
				   -- select * 
					update aux set aux.cod_dis = @cod_dis_aux
					from EQUIVALENCIA aux join disciplina dis on (aux.cod_dis = dis.cod_dis)
					                      join monitoria mon on (mon.cod_mon = aux.cod_mon)  
					 where dis.des_dis = @disciplina and 
					       mon.cod_dis <> @cod_dis_aux
				-- ***** EQUIVALENCIA FIM *****

				-- ***** MONITORIA *****
					--select * 
					update mon set mon.cod_dis = @cod_dis_aux
					from monitoria mon join disciplina dis on (mon.cod_dis = dis.cod_dis)
					 where dis.des_dis = @disciplina
				-- ***** MONITORIA FIM *****

				-- ***** ALUNO_CURSO_DISCIPLINA *****
					--select * 
					update aux set aux.cod_dis = @cod_dis_aux
					from ALUNO_CURSO_DISCIPLINA aux join disciplina dis on (aux.cod_dis = dis.cod_dis)
					 where dis.des_dis =  @disciplina
				-- ***** ALUNO_CURSO_DISCIPLINA FIM *****

				-- ***** DISCIPLINA_UNIVERSO *****
					--select * 
					update aux set aux.cod_dis = @cod_dis_aux
					from DISCIPLINA_UNIVERSO aux join disciplina dis on (aux.cod_dis = dis.cod_dis)
					 where dis.des_dis =  @disciplina
				-- ***** DISCIPLINA_UNIVERSO FIM *****

				-- ***** USUARIO_CURSO_DISCIPLINA *****
					--select * 
					update aux set aux.cod_dis = @cod_dis_aux
					from USUARIO_CURSO_DISCIPLINA aux join disciplina dis on (aux.cod_dis = dis.cod_dis)
					 where dis.des_dis = @disciplina and 
					       not exists (select 1 from usuario_curso_disciplina ucdx 
						                where ucdx.cod_usu = aux.cod_usu and 
						                      ucdx.cod_dis = @cod_dis_aux)

					--select * 
					delete aux
					from USUARIO_CURSO_DISCIPLINA aux join disciplina dis on (aux.cod_dis = dis.cod_dis)
					 where dis.des_dis = @disciplina and 
					       aux.cod_dis <> @cod_dis_aux
				-- ***** USUARIO_CURSO_DISCIPLINA FIM *****

				-- ***** DISCIPLINA *****
				   --select * 
				    delete
				   from disciplina 
				   where des_dis = @disciplina and 
					     cod_dis <> @cod_dis_aux
				-- ***** DISCIPLINA FIM *****


			fetch next from CUR_ into @disciplina, @cod_dis_aux
			END
	close CUR_ 
deallocate CUR_ 



--  rollback 
-- commit 
