USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_disciplina_cursada_aluno_monitoria]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
curso_id, curso_nome, disciplina_id, disciplina_nome, disciplina_sigla, professor_nome, professor_cpf, professor_email, 
professor_telefone,professor_dtnascimento,
aluno_nome, aluno_cpf, aluno_ra, aluno_email, aluno_telefone, aluno_dtanscimento, ANO, ETAPA, NOTA
*/
CREATE   view [dbo].[vw_disciplina_cursada_aluno_monitoria] as  
select turma.curso_id, curso.nome as curso, disc.id as disciplina_id, disc.nome as disciplina, 
       prof.nome as professor, pes.cpf as cpf_professor, usprof.email, pes.data_nascimento,
       aluno.nome aluno_nome, aluno.ra as aluno_ra, psalu.cpf as aluno_cpf, psalu.data_nascimento as aluno_dtnasc, dc.nota, 
	   year(turma.inicio_vigencia) as ano, sd.id as situacao_id, sd.nome as situacao, etp.etapa
	   
--select count(1)  
  from curriculos_disciplinaconcluida      dc  
       join curriculos_aluno               ca     on ca.id = dc.curriculo_aluno_id  
       join curriculos_curriculo           cur    on cur.id = ca.curriculo_id  
       join academico_disciplina           disc   on disc.id = dc.disciplina_id  
       join curriculos_statusdisciplina    sd     on sd.id = dc.status_id  
       join academico_etapaano             ea     on ea.id = dc.etapa_ano_id  
	   join academico_etapa                etp    on (etp.id = ea.etapa_id)
       join academico_aluno                aluno  on aluno.id = ca.aluno_id  
       join curriculos_statusaluno         sa     on sa.id = ca.status_id  
       join academico_turmadisciplinaaluno tda    on tda.aluno_id = aluno.id  
       join academico_turmadisciplina      td     on td.id = tda.turma_disciplina_id and td.disciplina_id = disc.id  
       join academico_turma                turma  on turma.id = td.turma_id and turma.turma_pai_id is null  
       join academico_curso                curso  on curso.id = turma.curso_id  
       left outer join academico_professor prof   on prof.id = dc.professor_id  
       left outer join pessoas_pessoa      pes    on pes.id = prof.pessoa_id  
       left outer join auth_user           usprof on usprof.id = prof.user_id  
	   
       left outer join pessoas_pessoa      psalu  on (psalu.id = aluno.pessoa_id)
       left outer join auth_user           usalu  on (usalu.id = psalu.id)  
 where   
    sa.curso_atual = 1  
GO
