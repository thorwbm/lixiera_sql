/*
-- ***** alunos  **********
select * from academico_aluno 
where pessoa_id in (
select id from pessoas_pessoa where nome in (
select nome
from pessoas_pessoa 
group by nome 
having count(1) > 1))
order by 2 


select nome from academico_aluno 
group by nome 
having count(1) > 1
-- **** fim alunos      */

/*     -- 0
-- *** cursos ****
select nome from academico_curso group by nome having count(1) > 1
-- *** fim cursos ****     */

/*     -- 103
-- *** disciplinas ****
select nome from academico_disciplina group by nome having count(1) > 1
-- *** fim disciplinas ****    */

/*     -- 33
-- *** turmas ****
select nome from academico_turma group by nome having count(1) > 1 order by 1
-- *** fim turmas ****    */

/*     -- 23
-- *** turma disciplina curso ****
select cur.nome, tur.nome, dis.nome
         from academico_turmadisciplina tda join academico_turma      tur on (tur.id = tda.turma_id)
                                            join academico_curso      cur on (cur.id = tur.curso_id)
											join academico_disciplina dis on (dis.id = tda.disciplina_id)
 group by cur.nome, tur.nome, dis.nome
 having count(1) > 1 order by tur.nome

select * from academico_turmadisciplina tda join academico_turma      tur on (tur.id = tda.turma_id)
                                            join academico_curso      cur on (cur.id = tur.curso_id)
											join academico_disciplina dis on (dis.id = tda.disciplina_id)
  where cur.nome = 'PSICOLOGIA' and 
        tur.nome = '10P1º(PS)' and 
		dis.nome = 'ESTÁGIO SUPERVISIONADO IX'
  order by tur.nome
-- *** fim turma disciplina curso ****    */


/*     -- 0SELEC
-- *** CRITERIOS ****
select * from vw_criterios_duplicados
-- *** fim turmas ****    */

/*     -- 0
-- *** professores ****
select nome from academico_professor group by nome having count(1) > 1
-- *** fim turmas ****    */

/*     -- 46
-- *** instituicoes ****
select nome ,count(1)
from core_instituicao group by nome, cidade_id 
having count(1) > 1 
order by count(1)  desc

-- obs select * from  core_instituicao where nome like '%rui barbosa%'
*/



/*
--- ######## EXECUTAR A LIMPEZA DE DUPLICIDADE DE INSTITUICOES ##########
-- drop table #tmp
select nome, cidade_id -- into #tmp
from core_instituicao 
group by nome, cidade_id 
having count(1) > 1 

declare @nome varchar(500) , @cidade_id int		
declare abc cursor for 
	SELECT nome, cidade_id FROM #tmp
	open abc 
		fetch next from abc into @nome, @cidade_id 
		while @@FETCH_STATUS = 0
			BEGIN
		EXEC sp_corrigir_duplicidade_instituicao  @nome, @cidade_id 
			fetch next from abc into  @nome, @cidade_id 
			END
	close abc 
deallocate abc 
*/

