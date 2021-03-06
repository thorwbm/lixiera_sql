USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_PlanoEnsino_Com_Pendencia]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_PlanoEnsino_Com_Pendencia] as
select pe.id, curso.nome as curso, disc.nome as disciplina, pe.serie, z.mensagem, prof.nome as Professor--into PlanoEnsino_ComPendencia_20092019_1135
  from (
--Planos de ensino de medicina que possuem menos de 3 áreas de formação com DCN selecionada
select pe.id, 'Nenhuma competência geral informada' as mensagem
  from planos_ensino_planoensino pe
       inner join academico_curso curso on curso.id = pe.course_id
       left outer join planos_ensino_planoensino_desempenhodcn dcn on dcn.planoensino_id = pe.id
       left outer join vw_matriz_dcn matriz on matriz.desempenho_id = dcn.desempenho_dcn_id
 where curso.nome = 'MEDICINA'
group by pe.id
having count(distinct matriz.area_formacao) = 0
union all
--Planos de ensino de medicina que possuem menos de 3 áreas de formação com DCN selecionada
select pe.id, 'Falta informar competência DCN para ' + convert(varchar, (3 - count(distinct matriz.area_formacao))) + ' área(s) de formação' as mensagem
  from planos_ensino_planoensino pe
       inner join academico_curso curso on curso.id = pe.course_id
       left outer join planos_ensino_planoensino_desempenhodcn dcn on dcn.planoensino_id = pe.id
       left outer join vw_matriz_dcn matriz on matriz.desempenho_id = dcn.desempenho_dcn_id
 where curso.nome = 'MEDICINA'
group by pe.id
having count(distinct matriz.area_formacao) in (1, 2)
union all
--Planos de ensino dos outros cursos que não possuem competencia geral selecionada
select pe.id, 'Nenhuma competência geral informada' as mensagem
  from planos_ensino_planoensino pe
       inner join academico_curso curso on curso.id = pe.course_id
 where curso.nome <> 'MEDICINA' and not exists(
       select top 1 1
         from planos_ensino_planoensino_competencia co 
              inner join competencias_competencia cop on cop.id = co.competencia_id and cop.category_id = 1  
        where co.planoensino_id = pe.id
 )
union all
--Planos de ensino dos outros cursos que não possuem competencia geral selecionada
select pe.id, 'Nenhuma competência específica informada' as mensagem
  from planos_ensino_planoensino pe
       inner join academico_curso curso on curso.id = pe.course_id
 where not exists(
       select top 1 1
         from planos_ensino_planoensino_competencia co 
              inner join competencias_competencia cop on cop.id = co.competencia_id and cop.category_id = 2 
        where co.planoensino_id = pe.id
 )
 union all
--Verificação do cadastro dos critérios
select pe.id, 'Nenhum critério cadastrado ' as mensagem
  from planos_ensino_planoensino pe
  where not exists (select top 1 1 from planos_ensino_planoensino_criterio pcri where pcri.planoensino_id = pe.id)
 union all
--Problemas de valor dos critérios
select pe.id, 'Critérios cadastrados somam ' + convert(varchar, isnull(sum(cri.valor), 0)) + ' pontos, mas deveriam somar 100' as mensagem
  from planos_ensino_planoensino pe
       inner join planos_ensino_planoensino_criterio pcri on pcri.planoensino_id = pe.id
       inner join atividades_criterio cri on cri.id = pcri.criterio_id 
group by pe.id
having isnull(sum(cri.valor), 0) <> 100
union all
--Problemas de valor das atividades
select pe.id, 'Atividades do critério ' + cri.nome + ' somam ' + convert(varchar, isnull(sum(atv.valor), 0)) + ' pontos, mas deveriam somar ' + convert(varchar, cri.valor) as mensagem
  from planos_ensino_planoensino pe
       inner join planos_ensino_planoensino_criterio pcri on pcri.planoensino_id = pe.id
       inner join atividades_criterio cri on cri.id = pcri.criterio_id
       inner join planos_ensino_atividade atv on atv.planoensino_criterio_id = pcri.id
group by pe.id, cri.nome, cri.valor
having count(atv.id) > 0 and isnull(sum(atv.valor), 0) <> cri.valor
union all
select pe.id, 'Ementa não informada' as mensagem
  from planos_ensino_planoensino pe where ementa is null
union all
select pe.id, 'Métodos de ensino não informados' as mensagem
  from planos_ensino_planoensino pe where metodos_de_ensino is null
) z 
inner join planos_ensino_planoensino pe on pe.id = z.id
inner join academico_curso curso on curso.id = pe.course_id
inner join academico_disciplina disc on disc.id = pe.disciplina_id
inner join academico_responsaveldisciplina respdisc on respdisc.disciplina_id =  pe.disciplina_id
inner join academico_professor prof on prof.id = respdisc.professor_id
GO
