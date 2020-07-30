
SELECT *
-- DELETE 
 
 FROM atividades_atividade_aluno WHERE id IN (
SELECT LANCAMENTO_ID FROM BKP_atividades_criterio_turmadisciplina_021019__1603
WHERE CAST (CRIADO_EM AS DATE) = '2019-10-01' )  
AND CAST (CRIADO_EM AS DATE) = '2019-10-01' AND 
id <> 66994


SELECT *  FROM atividades_revisao
WHERE nota_id IN (66994)
SELECT ID FROM [bkp_EXCLUSAO_atividades_atividade_aluno_021019__1740])


-- insert into atividades_atividade_aluno
SELECT distinct nota, atividade_id, aluno_id, criado_em, criado_por, atualizado_em, atualizado_por, divulgada_em--, id

 FROM bkp_EXCLUSAO_atividades_atividade_aluno_021019__1740  where isnull(status,1) = 1  
 order by atividade_id, aluno_id



select * from   bkp_EXCLUSAO_atividades_atividade_aluno_021019__1740  
 -- update bkp_EXCLUSAO_atividades_atividade_aluno_021019__1740 set status = 0 
where id = 66994 atividade_id = 5325 and aluno_id = 53331

select * from atividades_atividade_aluno
where id = 66994
1549
select * from protocolos_protocolo
where mensagem = 'Faltei apenas uma aula, respondi os casos com as respostas dadas em sala de aula e tirei 15 em 30. Nao faz o menor sentido. Quero saber o porque tirei uma nota tao baixa.'

--insert into protocolos_protocolo
select '2019-10-01 21:43:50.4053050',	'2019-10-01 21:43:50.4053280',	'Faltei apenas uma aula, respondi os casos com as respostas dadas em sala de aula e tirei 15 em 30. Nao faz o menor sentido. Quero saber o porque tirei uma nota tao baixa.',	2,	5863,	5863,	3,	5863,	NULL,	1,	NULL


select * from atividades_revisao
insert into atividades_revisao
select 	NULL, 	66994,	1549,	NULL,	'2019-10-01 21:43:50.4237200',	5863,	'2019-10-01 21:43:50.4237460',	5863			
