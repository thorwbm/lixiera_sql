if object_id('tempdb..#tmp1') is not null begin 
    drop table #tmp1
end


--CRIA TABELA TEMPORÁRIA COM OS CRITÉRIOS
select distinct pec.planoensino_id, pec.id as planoensino_criterio_id, cri.nome as criterio, cri.posicao, td.id as turma_disciplina_id, 
                pec.criterio_id, getdate() as criado_em, 2137 as criado_por, getdate() as atualizado_em, 2137 as atualizado_por, 
				isnull(tdp.professor_id, rd.professor_id) as professor_id 
--into #tmp1
--select turma.inicio_vigencia, turma.termino_vigencia, plano.id as plano_id, td.id as turma_disciplina_id, cri.nome as criterio, turma.nome as turma, disc.nome as disciplina, json_value(td.atributos, '$.universus_key.codtipoaula'), cri.valor
--select distinct turma.nome
  from planos_ensino_planoensino_criterio pec
       join atividades_criterio cri on cri.id = pec.criterio_id
       join planos_ensino_planoensino plano on plano.id = pec.planoensino_id
	   join academico_curso curso on curso.id = plano.curso_id
       join academico_etapaano ea on ea.id = plano.etapa_ano_id
       join academico_etapa etapa on etapa.id = ea.etapa_id
	   join academico_turma turma on turma.etapa_ano_id = plano.etapa_ano_id
	   join academico_turmadisciplina td on td.turma_id = turma.id and td.disciplina_id = plano.disciplina_id
	   join academico_disciplina disc on disc.id = td.disciplina_id
	   left outer join academico_turmadisciplinaprofessor tdp on tdp.turma_disciplina_id = td.id and ((select count(1) from academico_turmadisciplinaprofessor tdp2 where tdp2.turma_disciplina_id = td.id) = 1)
	   left outer join academico_responsaveldisciplina rd on rd.curso_id = turma.curso_id and rd.disciplina_id = td.disciplina_id and ((select count(1) from academico_responsaveldisciplina rd2 where rd2.curso_id = turma.curso_id and rd2.disciplina_id = disc.id) = 1 )
 where 1 = 1
   and plano.etapa_ano_id is not null  

--CRIA TABELA TEMPORÁRIA COM OS CRITÉRIOS

   --REPLICA OS CRITÉRIOS APENAS PARA TURMAS IMPORTADAS DO UNIVERSUS, POIS NO EDUCAT AINDA NÃO TEM A INDICAÇAO SE A TURMA E TEÓRICA OU PRÁTICA
   and json_query(turma.atributos, '$.universus_key') is not null
   
   --INDICA UMA TURMA ESPECÍFICA PARA REPLICAR OS CRITÉRIOS
  -- and turma.nome in ('8EPC012º')

   --CONSIDERA TURMA DE UMA DETERMINADA ETAPA
--   and etapa.etapa = 3


   --BLOQUEIA A INSERÇÃO DE CRITÉRIOS NA TURMA/DISCIPLINA SE JÁ EXISTIR ALGUM CRITÉRIO CADASTRADO NESSA TURMA/DISCIPLINA
--   and not exists (select top 1 1 from atividades_criterio_turmadisciplina actd where actd.turma_disciplina_id = td.id)

   --INDICA A DISCIPLINA E CURSO DO PLANO DE ENSINO QUE TERÁ OS CRITÉRIOS REPLICADOS
   and disc.nome in ('Estágio Supervisionado I')
   and curso.nome = 'ENFERMAGEM'
   
   --CONSIDERA APENAS TURMAS DO SEGUNDO SEMESTRE
   and turma.inicio_vigencia >= '2019-02-01'
   and turma.termino_vigencia >= '2019-07-16'
   
   --RESTRINGE O TIPO DE TURMA (TEÓRICA E PRÁTICA), PARA REGRAS ESPECÍFICAS
/*   and (json_value(td.atributos, '$.universus_key.codtipoaula') is null
        or (json_value(td.atributos, '$.universus_key.codtipoaula') is not null
		    and (json_value(td.atributos, '$.universus_key.codtipoaula') = 1 --Teórica
			     or (json_value(td.atributos, '$.universus_key.codtipoaula') = 2 --Prática
				     and disc.id in (7050,7143,7077,7087,7089,7099,7101,7378, --Treinamento de habilidades I...VII
					                 4079,4080,5718,4081,5728 --Práticas em Saúde Coletiva I e II
									)
				     )
			    )
		    ) 
	    )*/
go




begin tran

--APAGA AS ATIVIDADES E CRITÉRIOS DA TURMA/DISCIPLINA, PARA GARANTIR QUE TODOS OS CRITÉRIOS E ATIVIDADES QUE ESTÃO NO PLANO DE ENSINO SERÃO REPLICADOS PARA AS TURMAS
delete from atividades_atividade where criterio_turma_disciplina_id in (select id from atividades_criterio_turmadisciplina where turma_disciplina_id in (select turma_disciplina_id from #tmp1))
delete from atividades_criterio_turmadisciplina where turma_disciplina_id in (select turma_disciplina_id from #tmp1)

--COPIA OS CRITÉRIOS PARA AS TURMAS
insert into atividades_criterio_turmadisciplina (turma_disciplina_id, criterio_id, criado_em, criado_por, atualizado_em, atualizado_por, professor_id, inicio_janela_lancamento, termino_janela_lancamento, atributos)
select turma_disciplina_id, criterio_id, criado_em, criado_por, atualizado_em, atualizado_por, professor_id,
       case
          when criterio = 'AVALIAÇÃO PARCIAL' then '2019-09-23'
          when criterio = 'AVALIAÇÃO FORMATIVA' then '2019-11-11'
          when criterio = 'APIC - AVALIAÇÃO PARCIAL INTEGRADORA DE CONTEÚDOS' then '2019-11-11'
          when criterio = 'AVALIAÇÃO SOMATIVA' then '2019-11-19'
          else null
       end as inicio_janela_lancamento,
       case
          when criterio = 'AVALIAÇÃO PARCIAL' then '2019-10-07'
          when criterio = 'AVALIAÇÃO FORMATIVA' then '2019-11-18'
          when criterio = 'APIC - AVALIAÇÃO PARCIAL INTEGRADORA DE CONTEÚDOS' then '2019-11-18'
          when criterio = 'AVALIAÇÃO SOMATIVA' then '2019-12-13'
          else null
       end as termino_janela_lancamento,
       '{"planoensino_id":' + convert(varchar(100), planoensino_id) + '}'
  from #tmp1
go



--COPIA AS ATIVIDADES PARA AS TURMAS
insert into atividades_atividade (criado_em, criado_por, atualizado_em, atualizado_por, nome, valor, peso, criterio_turma_disciplina_id, status_id)
select getdate() as criado_em, 2137 as criado_por, getdate() as atualizado_em, 2137 as atualizado_por, patv.nome, patv.valor, 1,
       (select ctd.id from atividades_criterio_turmadisciplina ctd where ctd.criterio_id = t.criterio_id and ctd.turma_disciplina_id = t.turma_disciplina_id), 1
  from planos_ensino_atividade patv
       join #tmp1 t on t.planoensino_criterio_id = patv.planoensino_criterio_id

-- commit
-- ROLLBACK 