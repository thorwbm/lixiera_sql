
ALTER view [dbo].[vw_aluno_curriculo_forma_ingresso] as 
select distinct  crc.id as curriculo_id, crc.nome as curriculo_nome, sta.id as statusalunocurriculo_id, sta.nome as statusalunoCurriculo_nome,
        cur.id as curso_id, cur.nome as curso_nome, 
	   alu.id as aluno_id, alu.ra as aluno_ra, alu.nome as aluno_nome,  
	   fig.id as formaIngresso_id, fig.nome as FormaIngresso_nome

	from curriculos_aluno cal with(nolock) join academico_aluno           alu with(nolock) on (alu.id = cal.aluno_id)
                                           join curriculos_curriculo      crc with(nolock) on (crc.id = cal.curriculo_id)
                                           join academico_curso           cur with(nolock) on (cur.id = crc.curso_id)
                                           join curriculos_statusaluno    sta with(nolock) on (sta.id = cal.status_id)
                                           join curriculos_formaingresso  fig with(nolock) on (fig.id = cal.metodo_admissao_id)
GO

