
--insert into Alternativa
select * from (
               select * from (
                              select alt.nome,alt.valor, alt.posicao, data = GETDATE(), data1 = GETDATE()
                                from Alternativa alt
                               where alt.perguntaId = 1
				) as tab join  
                        (select distinct id from pergunta alt2
                         where Alt2.id > 28) as tab1 on  1 = 1
						) as tab3
order by 6, posicao



-- update Alternativa set posicao =  case posicao when 1 then 5 
                    when 2 then 4
					when 3 then 3 
					when 4 then 2 
					when 5 then 1  end 
 where perguntaId = 1 
 
 select * from Assunto 


-- insert into Assunto 
 select nome, posicao, GETDATE(), GETDATE(), 3
 from Assunto where id = 10 

-- insert into pergunta
 select nome,posicao, GETDATE(), GETDATE(), tipoPerguntaId, 20, *
 from Pergunta where assuntoId = 10


 select 

 insert into avaliacao
 select  codigoAvaliador, nomeAvaliador, codigoAvaliado, nomeAvaliado, url, dataEnvio = null, dataResposta, 
         idExterno = LOWER(newid()), createdAt = GETDATE(), updatedAt = GETDATE(), questionarioId=3, statusAvaliacaoId, curso, disciplina, turma, email, 
		 telefone, ra

 from Avaliacao
 where ra = '9999.999999'



