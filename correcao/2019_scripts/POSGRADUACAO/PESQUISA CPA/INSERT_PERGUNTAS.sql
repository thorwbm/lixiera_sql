select * from Questionario 

insert into Questionario 
select 'Questionario IPG - Alunos', GETDATE(), GETDATE(), null
select * from Pergunta


select * from   

--insert into Assunto 
--select nome = 'AVALIA��O DE DISCIPLINA', 4, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIA��O DA ATIVIDADE', 5, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIA��O DE DESIGN E MATERIAL DID�TICO', 6, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIA��O DO SUPORTE T�CNICO', 7, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIA��O DE DOCENTE', 8, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIA��O DO TUTOR', 9, GETDATE(), GETDATE(), 1 

 -- insert into pergunta ( posicao, createdAt, updatedAt, tipoPerguntaId, assuntoId, nome)
select  1, GETDATE(), GETDATE(), 1, 9, 'O tutor foi cordial e manteve bom relacionamento com os alunos, procurando atend�-los da melhor forma.' union 
select  2, GETDATE(), GETDATE(), 1, 9, 'Respostas dentro do prazo.'   union 
select  3, GETDATE(), GETDATE(), 1, 9, 'O tutor solucionou as d�vidas de forma favor�vel.'    union 
select  4, GETDATE(), GETDATE(), 1, 9, 'O tutor favoreceu e estimulou a participa��o dos alunos na disciplina.'     union 


select  5, GETDATE(), GETDATE(), 1, 9, 'Demonstra dom�nio do conte�do da disciplina e tem habilidade de transmitir o conhecimento.'


O tutor foi cordial e manteve bom relacionamento com os alunos, procurando atend�-los da melhor forma. 
Respostas dentro do prazo.
O tutor solucionou as d�vidas de forma favor�vel.
O tutor favoreceu e estimulou a participa��o dos alunos na disciplina.
