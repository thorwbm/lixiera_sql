
create view VW_ACD_CURRICULO_GRADE_TURMA_DISCIPLINA_VAGAS as 
  select distinct gra.id as grade_id, crc.id as curriculo_id, gra.nome as grade_nome,
         tur.id as turma_id, tur.nome as turma_nome, 
		 dis.id as disciplina_id, dis.nome as disciplina_nome, tds.maximo_vagas, vag.VAGA_DISPONIVEL
    from curriculos_curriculo crc join curriculos_grade          gra on (crc.id = gra.curriculo_id)
	                              join academico_turma           tur on (gra.id = tur.grade_id)
								  join academico_turmadisciplina tds on (tur.id = tds.turma_id)
								  join academico_disciplina      dis on (dis.id = tds.disciplina_id) 
								  join VW_PRO_TURMA_DISCIPLINA_QUANTIDADE_DISPONIVEL_VAGA vag on (tds.id = vag.turmadisciplina_id)
where tur.categoria_id = 1 and tur.turma_pai_id is null 




