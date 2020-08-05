with cte_alunos_enturmar as (
select cur.id as curriculo_id, cur.nome as curriculo, 
       aluno.id as aluno_id, aluno.nome as aluno, 	   
	   grade.id as grade_id, etapa.etapa as etapanatural, 
	   disc.id as disciplianaid, disc.nome as disciplina, 
	   ca.id as curriculoalunoid, aluno.id as alunoid
from curriculos_aluno ca
join academico_aluno aluno on aluno.id = ca.aluno_id
join curriculos_grade grade on grade.id = ca.grade_id
join academico_etapa etapa on etapa.id = grade.etapa_id
join curriculos_curriculo cur on cur.id = ca.curriculo_id
join curriculos_grade grade2 on grade2.curriculo_id = cur.id
join curriculos_gradedisciplina gd on gd.grade_id = grade2.id
join academico_disciplina disc on disc.id = gd.disciplina_id
where ca.status_id = 13
  and grade2.etapa_id = etapa.etapa 
  --and aluno.nome = 'RICARDO AUGUSTO ARCANJO OLIVEIRA'
  and cur.nome = 'MEDICINA 2017/6-4 (1-2017)'
  and gd.disciplina_id not in (select disciplina_id 
                               from academico_turmadisciplina td
							   join academico_turmadisciplinaaluno tda on tda.turma_disciplina_id = td.id and
							                                              tda.curriculo_aluno_id  = ca.id and 
																		  tda.aluno_id            = ca.aluno_id)
  and disc.nome not like '%internato%'
), 
	cte_turmadisciplina as (
	select turma_id, turma_nome, disciplina_id, disciplina_nome, turma_disciplina_id
	  from vw_turma_disciplina_grade
	  where turma_nome in ('M067A04I202P','M067A04j202P','M067A04k202P','M067A04l202P') and 
	        --turma_nome like 'M067A04I202P' and 
	        disciplina_nome = 'TREINAMENTO DE HABILIDADES VII'
	   
)

select DISCIPLINA_ID, TURMA_ID,TURMA_DISCIPLINA_ID, ent.curriculoalunoid as CURRICULO_ALUNO_ID, ALUNO_ID,
       curriculo as curriculo_nome, aluno as aluno_nome, DISCIPLINA_NOME, TURMA_NOME
into #temp_insert
from cte_alunos_enturmar ent join cte_turmadisciplina tds on (ent.disciplianaid = tds.disciplina_id)
where disciplina =  'TREINAMENTO DE HABILIDADES VII'
order by curriculo_nome,aluno_nome, DISCIPLINA_NOME, TURMA_NOME

-- drop table  #temp_insert




DECLARE @DISCIPLINA_ID INT 
DECLARE @TURMA_ID INT 
DECLARE @TURMADISCIPLINA_ID INT 
DECLARE @CURRICULO_ALUNO_ID INT 
DECLARE @ALUNO_ID INT

declare CUR_ESP cursor for 
    -------------------------------------------------------------------------------------------------
	SELECT DISCIPLINA_ID, TURMA_ID,TURMA_DISCIPLINA_ID, CURRICULO_ALUNO_ID, ALUNO_ID 
	  FROM #temp_insert
	 order by curriculo_nome, aluno_nome, DISCIPLINA_NOME, TURMA_NOME
	-------------------------------------------------------------------------------------------------
	open CUR_ESP 
		fetch next from CUR_ESP into @DISCIPLINA_ID, @TURMA_ID, @TURMADISCIPLINA_ID, @CURRICULO_ALUNO_ID, @ALUNO_ID
		while @@FETCH_STATUS = 0
			BEGIN
			----------------------------------------------------------------------------------------
				IF ((SELECT VAGA_DISPONIVEL 
				      FROM VW_PRO_TURMA_DISCIPLINA_QUANTIDADE_DISPONIVEL_VAGA VAG 
					 WHERE VAG.turmadisciplina_id = @TURMADISCIPLINA_ID) > 0)
					BEGIN
						INSERT INTO academico_turmadisciplinaaluno (
							   ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
							   exigencia_matricula_disciplina_id,TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, 
							   FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)

						SELECT distinct ALUNO_ID = tem.ALUNO_ID, TURMA_DISCIPLINA_ID = tem.turma_disciplina_id, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, 
							   ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, 
							   STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = tem.CURRICULO_ALUNO_ID
						  FROM #temp_insert tem LEFT JOIN academico_turmadisciplinaaluno XXX ON (XXX.aluno_id = tem.ALUNO_ID AND 
																									 XXX.turma_disciplina_id = tem.turma_disciplina_id AND
																									 XXX.curriculo_aluno_id  = tem.CURRICULO_ALUNO_ID)
                         WHERE XXX.id IS NULL AND 
						       tem.TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID AND
							   tem.CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID


					    DELETE FROM #temp_insert 
						 WHERE CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID AND
						       DISCIPLINA_ID      = @DISCIPLINA_ID
					END
			----------------------------------------------------------------------------------------



			fetch next from CUR_ESP into @DISCIPLINA_ID, @TURMA_ID, @TURMADISCIPLINA_ID, @CURRICULO_ALUNO_ID, @ALUNO_ID
			END
	close CUR_ESP 
deallocate CUR_ESP 



select * from vw_curriculo_curso_turma_disciplina_aluno_grade
where status_mat_dis_id = 14 

      and disciplina_nome =  'TREINAMENTO DE HABILIDADES VII'
order by aluno_nome


select * from academico_turmadisciplina where id = 24969


select * 
update tda set tda.status_matricula_disciplina_id = 2
from academico_turmadisciplinaaluno tda
where status_matricula_disciplina_id = 14