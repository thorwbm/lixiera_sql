USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_curso_turma_disciplina_aluno]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create     view [dbo].[vw_curso_turma_disciplina_aluno] as     
select distinct cur.id as curso_id, cur.nome as curso_nome,     
       tur.id as turma_id, tur.nome as turma_nome,     
    dis.id as disciplina_id, dis.nome as disciplina_nome,     
    alu.id as aluno_id, alu.nome as aluno_nome,  alu.ra as aluno_ra,  pes.cpf as aluno_cpf, 
    usu.id as usuario_id, trd.id as turmaDisciplina_id, tda.id as turmaDisciplinaAluno_id,     
    tur.grade_id, tur.etapa_ano_id    
  from academico_turmadisciplina trd with(nolock) join academico_turma      tur with(nolock) on (tur.id = trd.turma_id)    
                                                  join academico_disciplina dis with(nolock) on (dis.id = trd.disciplina_id)     
                                                  join academico_curso      cur with(nolock) on (cur.id = tur.curso_id)    
                                             left join academico_turmadisciplinaaluno tda with(nolock) on (trd.id = tda.turma_disciplina_id)    
                                             left join academico_aluno                alu with(nolock) on (alu.id = tda.aluno_id)    
                                             left join auth_user                      usu with(nolock) on (usu.id = alu.user_id)   
											 left join pessoas_pessoa                 pes with(nolock) on (pes.id = alu.pessoa_id) 
GO
