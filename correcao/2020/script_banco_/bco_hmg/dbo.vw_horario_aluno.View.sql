USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_horario_aluno]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_horario_aluno] as   
select  crc.id as curriculo_id, crc.nome as curriculo_nome, 
        cur.id as curso_id, cur.nome as curso_nome,
        tur.id as turma_id, tur.nome as turma_nome, 
        alu.id as aluno_id, alu.nome as aluno_nome, 
        dis.id as disciplina_id, dis.nome as disciplina_nome,   
        pro.id as professor_id, pro.nome as professor_nome,  
        sal.id as sala_id, sal.nome as sala_nome,   
        aul.conteudo,  
        aul.data_inicio, aul.data_termino, 
		sta.nome aula_status, 
		tds.id as turma_disciplina_id
  
         from academico_turmadisciplinaaluno tda join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id) 
                                                 join academico_turma           tur on (tur.id = tds.turma_id)
												 join academico_curso           cur on (cur.id = tur.curso_id)
												 join curriculos_grade          gra on (gra.id = tur.grade_id)
												 join curriculos_curriculo      crc on (crc.id = gra.curriculo_id)
                                                 join academico_disciplina      dis on (dis.id = tds.disciplina_id)  
                                                 join academico_aluno           alu on (alu.id = tda.aluno_id)  
                                            left join academico_aula            aul on (tds.id = aul.turma_disciplina_id)  
                                            left join salas_sala                sal on (sal.id = aul.sala_id)  
                                            left join academico_statusaula      sta on (sta.id = aul.status_id)
                                            left join academico_professor       pro on (pro.id = aul.professor_id)   

									
GO
