SELECT * FROM   tmp_questionario_curso


select * from	Questionario
select * from Assunto 
select * from Pergunta 
select * from Resposta

-- insert into questionario
select 'Questionario IPG - Curso', GETDATE(), GETDATE(),null


select 'insert into assunto (nome, posicao, createdat, updatedat, questionarioid) '+
        ' select '+CHAR(39) + grupo + CHAR(39) +', ' + 
                  convert(varchar(10),row_number() over(ORDER BY ordem ASC) ) +', ' +
				  'getdate() , ' + 
				  'getdate() , 3'  ,ordem 
   from ( SELECT distinct grupo , MAX( id) ordem
           FROM tmp_questionario_curso 
            group by grupo ) as tab


--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'QUESTIONÁRIO DE AVALIAÇÃO DA INSTITUIÇÃO', 1, getdate() , getdate() , 3
--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'QUESTIONÁRIO DE AVALIAÇÃO DA SECRETARIA', 2, getdate() , getdate() , 3
--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'QUESTIONÁRIO DE AVALIAÇÃO DO NÚCLEO PEDAGÓGICO', 3, getdate() , getdate() , 3
--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'QUESTIONÁRIO DE AVALIAÇÃO DA LOGÍSTICA', 4, getdate() , getdate() , 3
--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'QUESTIONÁRIO DE AVALIAÇÃO DO AMBIENTE VIRTUAL DE APRENDIZAGEM - PLATAFORMA MOODLE', 5, getdate() , getdate() , 3
--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'QUESTIONÁRIO DE AVALIAÇÃO DE COORDENAÇÃO DE CURSO', 6, getdate() , getdate() , 3
--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'QUESTIONÁRIO DE AVALIAÇÃO DE CURSO (PARA CURSOS EAD)', 7, getdate() , getdate() , 3
--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'AUTOAVALIAÇÃO DO ALUNO', 8, getdate() , getdate() , 3
--insert into assunto (nome, posicao, createdat, updatedat, questionarioid)  select 'QUESTIONÁRIO DE AVALIAÇÃO – 3º ENCONTRO PRESENCIAL', 9, getdate() , getdate() , 3

select * from Pergunta order by assuntoId 

--insert into Pergunta (nome, posicao, createdAt, updatedAt, tipoPerguntaId, assuntoId) 
select  tmp.pergunta, ROW_NUMBER() OVER(PARTITION BY ass.id ORDER BY tmp.id asc) , GETDATE(),GETDATE(), 1, ass.id
from Assunto ass join tmp_questionario_curso tmp on (ass.nome = tmp.grupo)
where questionarioId = 3
order by tmp.id 

select * from Alternativa