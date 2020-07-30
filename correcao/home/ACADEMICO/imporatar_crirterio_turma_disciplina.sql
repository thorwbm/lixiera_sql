/*
-- ########################## CARGA NA ATIVIDADE CRITERIO ###########################

--insert into atividades_criterio (NOME, VALOR, PESO, TIPO_ID, RECUPERACAO, max_atividades, posicao, data_limite_divulgacao, data_limite_divulgacao_bkp,
--                                 criado_em, atualizado_em, criado_por, atualizado_por)
select DISTINCT NOME, VALOR, PESO,TIPO_ID, RECUPERACAO,max_atividades, posicao,data_limite_divulgacao = '2020-01-01',data_limite_divulgacao_bkp = '2020-01-01',
                criado_em = getdate(), atualizado_em = getdate(), criado_por = 11717, atualizado_por = 11717

from atividades_criterio
where nome in ('AVALIACAO PARCIAL', 'AVALIACAO FORMATIVA', 'AVALIACAO SOMATIVA') AND 
      ((NOME = 'AVALIACAO PARCIAL' AND VALOR = 30) OR
	   (NOME = 'AVALIACAO FORMATIVA' AND VALOR = 40)OR
	   (NOME = 'AVALIACAO SOMATIVA' AND VALOR = 30)) AND PESO = 1
*/
-- ################################ CARGA NA ATIVIDADE CRITERIO TURMA DISCIPLINA #######################
with cte_criterio as (
		select id, nome, valor, 
		                     prazoini = case id when 364 then cast( '2020-05-09' as date)
		                                        when 365 then cast( getdate()	 as date)
												when 366 then cast( '2020-06-20' as date) end ,
		                     prazofim = case id when 364 then '2020-06-19'
		                                        when 365 then '2020-08-05'
												when 366 then '2020-07-07' end 
		from atividades_criterio where criado_por = 11717 
) 

	,	cte_turmadisciplina as (
			select tds.id as turma_disciplina_id, tur.nome as turma_nome, dis.nome as disciplina_nome,
			       cat.id as categoria_id, cat.nome as categoria_nome, tdp.professor_id, pro.nome as professor_nome
			  from academico_turmadisciplina tds
			join academico_turma tur on tur.id = tds.turma_id
			join academico_categoriaturma cat on (cat.id = tur.categoria_id)
			join academico_disciplina     dis on (dis.id = tds.disciplina_id)
	        join academico_turmadisciplinaprofessor tdp on (tds.id = tdp.turma_disciplina_id)
	        join academico_professor                pro on (pro.id = tdp.professor_id)
			where dis.nome = 'TREINAMENTO DE HABILIDADES I'
			 and year(tur.inicio_vigencia) = 2020
)
         select distinct * 
		   from cte_turmadisciplina  where categoria_id = 2

		   order by turma_nome, professor_nome








