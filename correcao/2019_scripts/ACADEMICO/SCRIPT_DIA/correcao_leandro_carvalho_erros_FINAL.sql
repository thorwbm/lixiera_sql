--##################################################################################
--     SCRIPT PARA CORRECAO DE LANCAMENTO INCORRETO DO USUARIO LEANDRO.CARVALHO

--##################################################################################

-- drop table #temp_aula
select aul.* 
 into #temp_aula
  from academico_aula aul with(nolock) join academico_turmadisciplina trd with(nolock) on (trd.id = aul.turma_disciplina_id)
                                       join auth_user usu on (aul.atualizado_por = usu.id)
                                       join academico_turma           tur with(nolock) on (tur.id = trd.turma_id) 
 where cast(aul.atualizado_em as date) = '2019-10-14' and 
       usu.username = 'leandro.carvalho' and 
       tur.nome in (
'1MA2º2019-2',
'1MAP022º2019-2',
'1MAP012º2019-2',
'1MAP01.22º2019-2',
'1MAP02.22º2019-2',
'1MAP02.12º2019-2',
'1MAP01.12º2019-2'
	   )


-- select * from #temp_aula
--###############################################

--  SELECT * INTO TMP_academico_aula_221019__1058 FROM #temp_aula 

BEGIN TRAN
declare @id int , @professor_id_atual int, @professor_id_anterior int, @obs varchar(8000), @DATAUPDATE VARCHAR(30), @DATAATUAL VARCHAR(30)
declare abc cursor for 
	SELECT id FROM #temp_aula 
	open abc 
		fetch next from abc into @id
		while @@FETCH_STATUS = 0
			BEGIN
				select top 1 @professor_id_atual = tem.professor_id, @professor_id_anterior = lga.professor_id, 
				    @DATAUPDATE = convert(varchar(4),year(tem.atualizado_em)) + '-' + right('0'+convert(varchar(2),month(tem.atualizado_em)),2) + '-' + right('0'+convert(varchar(2),day(tem.atualizado_em)),2) + ' '+ CONVERT(VARCHAR(30),tem.atualizado_em,(114)) 
				  from #temp_aula tem join log_academico_aula lga on (tem.id = lga.id)
					where cast(tem.atualizado_em as date) > CAST(lga.atualizado_em as date)  and 
						  tem.id = @id
					order by lga.atualizado_em desc 
					      if (@professor_id_anterior <> @professor_id_atual)
								begin 
                                   select @DATAATUAL  = convert(varchar(4),year(getdate())) + '-' + right('0'+convert(varchar(2),month(getdate())),2) + '-' + right('0'+convert(varchar(2),day(getdate())),2) + ' '+ CONVERT(VARCHAR(30),GETDATE(),(114))

								     set @obs =  '{'+ char(39) +'updated_at'+ char(39) +': {'+ char(39) + 'antigo' + char(39) + ': '+ char(39) + @DATAUPDATE + char(39) + ', '+ char(39) + 'novo' + char(39) + ': '+ char(39) + @DATAATUAL + char(39) + '}, ' + 
									                + char(39) +'professor_id'+ char(39) +': {'+ char(39) + 'antigo' + char(39) + ': ' + convert(varchar(30), @professor_id_atual)  + ', '+ char(39) + 'novo' + char(39) + ': '+ convert(varchar(30),@professor_id_anterior)+  + '}} ' 
									    
									  -- ******** INSERIR NO LOG  *******
									   INSERT INTO log_academico_aula (atributos_log, observacao,  history_date, history_change_reason, history_type, history_user_id, 
                                                                       id, atributos, criado_em, atualizado_em, data_inicio, data_termino, duracao, conteudo, data_envio_frequencia,
                                                                       agendamento_id, criado_por, professor_id, status_id, turma_disciplina_id, atualizado_por, user_envio_frequencia_id, 
                                                                       sala_id, metodologia_id, plano, tipo_id, grupo_id, data_envio_conteudo, user_envio_conteudo_id)
									   
									   SELECT atributos_log = null , observacao = @obs, history_date = GETDATE(), 
                                              history_change_reason = null, history_type = '~', history_user_id = null,
                                              id,  atributos, criado_em, atualizado_em, data_inicio, data_termino, duracao, conteudo, data_envio_frequencia, agendamento_id, 
                                              criado_por,  professor_id, status_id, turma_disciplina_id, atualizado_por, user_envio_frequencia_id, sala_id, metodologia_id, 
                                              plano, tipo_id, grupo_id, data_envio_conteudo, user_envio_conteudo_id 
										FROM academico_aula WHERE id = @ID
									   
									   --******** ALTERAR NA TABELA REAL ****
									   -- SELECT id, professor_id, @professor_id_atual, @professor_id_anterior FROM academico_aula 
										UPDATE academico_aula SET professor_id = @professor_id_anterior, atualizado_em = GETDATE(), atualizado_POR = NULL
										WHERE id = @id 
								end
			fetch next from abc into @id
			END
	close abc 
deallocate abc 

-- COMMIT 
-- ROLLBACK 
