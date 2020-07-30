select * from Questionario 

insert into Questionario 
select 'Questionario IPG - Alunos', GETDATE(), GETDATE(), null
select * from Pergunta


select * from   

--insert into Assunto 
--select nome = 'AVALIAÇÃO DE DISCIPLINA', 4, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIAÇÃO DA ATIVIDADE', 5, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIAÇÃO DE DESIGN E MATERIAL DIDÁTICO', 6, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIAÇÃO DO SUPORTE TÉCNICO', 7, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIAÇÃO DE DOCENTE', 8, GETDATE(), GETDATE(), 1 union 
--select nome = 'AVALIAÇÃO DO TUTOR', 9, GETDATE(), GETDATE(), 1 

 -- insert into pergunta ( posicao, createdAt, updatedAt, tipoPerguntaId, assuntoId, nome)
select  1, GETDATE(), GETDATE(), 1, 9, 'O tutor foi cordial e manteve bom relacionamento com os alunos, procurando atendê-los da melhor forma.' union 
select  2, GETDATE(), GETDATE(), 1, 9, 'Respostas dentro do prazo.'   union 
select  3, GETDATE(), GETDATE(), 1, 9, 'O tutor solucionou as dúvidas de forma favorável.'    union 
select  4, GETDATE(), GETDATE(), 1, 9, 'O tutor favoreceu e estimulou a participação dos alunos na disciplina.'     union 


select  5, GETDATE(), GETDATE(), 1, 9, 'Demonstra domínio do conteúdo da disciplina e tem habilidade de transmitir o conhecimento.'


O tutor foi cordial e manteve bom relacionamento com os alunos, procurando atendê-los da melhor forma. 
Respostas dentro do prazo.
O tutor solucionou as dúvidas de forma favorável.
O tutor favoreceu e estimulou a participação dos alunos na disciplina.
