select id from academico_turma where nome like '%URGÊNCIA%5MABP02%' --id = 440

select id from academico_turmadisciplina 
where turma_id in (select id from academico_turma where nome like '%URGÊNCIA%5MABP02%' --id = 440
)

select * from academico_turmadisciplinaaluno 
where aluno_id = 38274 and 
      turma_disciplina_id in (select id from academico_turmadisciplina 
where turma_id in (select id from academico_turma where nome like '%URGÊNCIA%5MABP02%' --id = 440
))

select * from atividades_criterio_turmadisciplina
where  turma_disciplina_id in  (10045,
10042,
10037,
10046,
10087,
10036,
10040)

select * from atividades_atividade
where id = 658

select * from atividades_atividade_aluno
where  aluno_id = 38274 


select * from log_atividades_criterio_turmadisciplina
where  turma_disciplina_id in  (10045,
10042,
10037,
10046,
10087,
10036,
10040)

select distinct vw.* --, case when aul.id IS null then 0 else 1 end as tem_aula , aul.professor_id, grp.professor_id
from vw_turma_disciplina_aluno_atividade vw --left join academico_aula aul on (vw.turmadisciplina_id = aul.turma_disciplina_id)
                                            --left join academico_grupoaula grp on (vw.turmadisciplina_id = grp.turma_disciplina_id and 
											--                                      aul.grupo_id          = grp.id)
where  turma_nome like '%urgencia%5mab%'  and --aluno_id = 42344 and 
       --nota_aluno is  null and 
vw.turmadisciplina_id in (10037,10036)

select top 1000 * from academico_frequenciadiaria where aula_id in (select  id from academico_aula where turma_disciplina_id in (10037))

select * from academico_aula where turma_disciplina_id in (10037,10036) and MONTH(data_inicio) = 2 order by data_inicio
select * from atividades_atividade_aluno

select * from academico_turma where ID = 417
select * from academico_disciplina where ID in (4031,4027)
select * from academico_turmadisciplina where id in (5105,5106)
select * from atividades_criterio_turmadisciplina where id in (1406,1422)
select * from atividades_atividade_aluno where aluno_id = 42344
select * from atividades_atividade where id in( 663, 679) 




create view vw_turma_discplina_atividade_aluno as 
select distinct tur.id as turma_id, tur.nome as turma_nome, 
       dis.id as disciplina_id, dis.nome as disciplina_nome, 
	   tds.id as turmadisciplina_id, 
	   crt.id as criterio_turmadisciplina_id, 
	   cri.id as criterio_id, cri.nome as criterio_nome, 
	   ati.id as atividade_id, ati.nome as atividade_nome, 
	   atialu.aluno_id as aluno_id, atialu.nota as aluno_nota,
	   atialu.id as atividade_aluno_id 

  from academico_turmadisciplina tds      join academico_turma                     tur    on (tur.id = tds.turma_id)
                                          join academico_disciplina                dis    on (dis.id = tds.disciplina_id)
                                     left join atividades_criterio_turmadisciplina crt    on (tds.id = crt.turma_disciplina_id)
									 left join atividades_criterio                 cri    on (cri.id = crt.criterio_id)
                                     left join atividades_atividade                ati    on (crt.id = ati.criterio_turma_disciplina_id)   
									 left join atividades_atividade_aluno          atialu on (ati.id = atialu.atividade_id)



select * from vw_turma_discplina_atividade_aluno tds
 where  turma_nome = 'INTERNATO DE MEDICINA DE URGÊNCIA TEÓRICA - 5MABP02'   


10034 *
10037
10036
10035

-- CRIAR UM STATUS MATRICULADISCIPLINA AUXILIAR PARA FLEGAR 
SELECT * FROM academico_statusmatriculadisciplina
INSERT INTO academico_statusmatriculadisciplina SELECT GETDATE(),GETDATE(), NULL, 'DELECAO LOGICA',0,1,1 WHERE NOT EXISTS (SELECT 1 FROM academico_statusmatriculadisciplina WHERE nome = 'DELECAO LOGICA')


-- agrupar aula colocar para turma_disciplina eleita para mudanca NA TURMADISCIPLINA COM ID MENOR PARA A TURMA 597 OU SEJA ID = 10034
   -- trocar a discilina cirurgia geral - 4063 para 4027 (mas neste caso existe duas disciplinas com o mesmo nome id = 4028  **** DESATIVAR) 
      
	  --***** DESATIVAR 4028
	  select * from academico_disciplina 
	  --  UPDATE academico_disciplina SET nome = 'INTERNATO DE MEDICINA DE URGÊNCIA - DESATIVADA' 
	  where id = 4028
	  
	  --**** TROCAR 4063 POR 4027 DISCIPLINAS - TURMADISCIPLINA
	  SELECT * FROM academico_turmadisciplina
	 -- UPDATE ACADEMICO_TURMADISCIPLINA SET disciplina_id = 4027
	   WHERE id = 10034 

	   -- **** TROCAR TODOS OS ALUNOS DA TURMADISCIPLINAALUNO PARA TURMADISCIPLINA_ID = 10034
	
declare @id int, @aluno_id int, @turma_disciplina_id int
declare @destino int
set @destino = 10034
declare abc cursor for 
	SELECT distinct ID, ALUNO_ID, turma_disciplina_id FROM academico_turmadisciplinaaluno 
WHERE turma_disciplina_id IN (10037,10036,10035) and isnull(status_matricula_disciplina_id,0) <> 10 ORDER BY aluno_id, turma_disciplina_id
	open abc 
		fetch next from abc into @id, @aluno_id, @turma_disciplina_id
		while @@FETCH_STATUS = 0
			BEGIN
				if exists (select 1 from academico_turmadisciplinaaluno
				     where aluno_id = @aluno_id and 
					       turma_disciplina_id = @destino)
					begin
						update academico_turmadisciplinaaluno set status_matricula_disciplina_id = 10 where id = @id
					end
				else 
					begin
						update academico_turmadisciplinaaluno set turma_disciplina_id = @destino where id = @id
					end
			fetch next from abc into @id, @aluno_id, @turma_disciplina_id
			END
	close abc 
deallocate abc 

	-- ***** atualizo a tabela grupo aula passando todas as turmasdisciplinasid para 10034	
   SELECT * FROM academico_aula  
	   -- UPDATE academico_aula SET TURMA_DISCIPLINA_ID = 10034
	   WHERE TURMA_DISCIPLINA_ID IN (10037,10036,10035)
-- atualizar atividades_criterio_turmadisciplina se ouver 

   -- ***** atualizo a tabela academico_grupoaula passando todas as turmasdisciplinasid para 10034	
   SELECT * FROM academico_grupoaula  
	   -- UPDATE academico_grupoaula SET TURMA_DISCIPLINA_ID = 10034
	   WHERE TURMA_DISCIPLINA_ID IN (10037,10036,10035)
-- atualizar atividades_criterio_turmadisciplina se ouver 
    

	-- limpar turmadisciplinaaluno para os registros com status_matricula_disciplina_id = 10 
	SELECT *
	-- delete 
	FROM academico_turmadisciplinaaluno 
WHERE turma_disciplina_id IN (10037,10036,10035,10034)  AND status_matricula_disciplina_id = 10 


select * from academico_grupoaula where turma_disciplina_id IN (10037,10036,10035,10034)


SELECT * FROM academico_turmadisciplinaaluno 
WHERE turma_disciplina_id IN (10037,10036,10035,10034)  AND status_matricula_disciplina_id = 10 



select * from academico_disciplina where nome like 'INTERNATO DE MEDICINA DE URGÊNCIA%'
select * from academico_turmadisciplina where disciplina_id = 4027 AND turma_id 


