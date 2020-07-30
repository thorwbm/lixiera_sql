
with cte_reporvados_falta as (
		select alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra, sta.nome as status_curriculo, std.nome as status_disciplina, 
			   dis.id as disciplina_id, dis.nome as disciplina_nome,
			   crc.id as curriculo_id, crc.nome as curriculo_nome

		  from curriculos_disciplinaconcluida con join curriculos_aluno cal on (cal.id = con.curriculo_aluno_id)
												  join academico_disciplina   dis on (dis.id = con.disciplina_id)
												  join curriculos_statusaluno sta on (sta.id = cal.status_id)
												  join curriculos_statusdisciplina std on (std.id = con.status_id)
												  join curriculos_curriculo crc on (crc.id = cal.curriculo_id)
												  join atividades_atividade_aluno ati on (ati.aluno_id = cal.aluno_id)
												  join academico_aluno            alu on (alu.id = ati.aluno_id)
		where con.status_id = 10 and 
			  sta.curso_atual = 1
)

select distinct fal.aluno_id, fal.aluno_nome, fal.aluno_ra, 
                cur.id as curso_id, cur.nome as curso_nome, 
				tur.id as turma_id, tur.nome as turma_nome, 
				dis.id as disciplina_id, dis.nome as disciplina_nome, 
				fal.curriculo_nome

 from atividades_atividade_aluno alu join cte_reporvados_falta fal on (alu.aluno_id = fal.aluno_id)
                                     join atividades_atividade ati on (ati.id = alu.atividade_id)
									 join atividades_criterio_turmadisciplina ctd on (ctd.id = ati.criterio_turma_disciplina_id)
									 join academico_turmadisciplina tds on (tds.id = ctd.turma_disciplina_id)
									 join academico_turma           tur on (tur.id = tds.turma_id)
									 join academico_disciplina      dis on (dis.id = tds.disciplina_id)
									 join academico_curso           cur on (cur.id = tur.curso_id)

