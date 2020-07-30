select 
	   cur.nome as curso_nome, 
       crc.nome as curriculo_nome, 
       alu.nome as aluno_nome, alu.ra as aluno_ra, 
       -- crc.id as curriculo_id, 
       -- cur.id as curso_id, 
	   -- dis.id as disciplina_id, 
	   sta.nome as status_aluno,
	   dis.nome as disciplina_nome, 
	   std.nome as status_disciplina, 
	   con.nota as nota_disciplina, 
	   -- eta.id as etapaano_id, 
	   eta.ano as etapaano_disciplina_ano, 
	   etp.etapa as etapa, etp.nome as etapa_disciplina_nome, 
	   etpa.nome as etapa_atual

  from curriculos_disciplinaconcluida con join curriculos_aluno            cra  on (cra.id = con.curriculo_aluno_id)
                                          join academico_aluno             alu  on (alu.id = cra.aluno_id)
                                          join academico_disciplina        dis  on (dis.id = con.disciplina_id)
										  join curriculos_curriculo        crc  on (crc.id = cra.curriculo_id)
										  join academico_curso             cur  on (cur.id = crc.curso_id)
										  join curriculos_statusdisciplina std  on (std.id = con.status_id)
										  join academico_etapaano          eta  on (eta.id = con.etapa_ano_id)
										  join academico_etapa             etp  on (etp.id = eta.etapa_id)
										  join curriculos_etapaatual       tal  on (cra.id = tal.curriculo_aluno_id)
										  join academico_etapa             etpa on (etpa.id = tal.etapa_id)
										  join curriculos_statusaluno      sta  on (sta.id  = cra.status_id)
  where std.id in (9,10) and  -- reprovado (faltas e notas) 
        cra.status_id = 13  -- cursando

order by 1,2,3,5


