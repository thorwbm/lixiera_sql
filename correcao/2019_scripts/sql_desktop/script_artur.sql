/*
update turma
   set turma.etapa_ano_id = ea.id
  from academico_turma turma
       join academico_etapaano ea on ea.ano = 2019 and ea.periodo = 2
	   join academico_etapa etapa on etapa.id = ea.etapa_id and etapa.etapa = 10 
	   join academico_cursooferta co on co.id = etapa.curso_oferta_id and co.num_etapas = 10
	   join academico_curso curso on curso.id = co.curso_id
 where turma.nome IN('10EPC102�', '10EPC112�', '10EPC122�', '10EPC132�', '10EPC142�', '10EPC152�', '10EPC162�', '10EPC172�', 
                      '10EPC182�', '10EPC192�', '10EPC202�', '10EPC212�', '10EPC222�', '10EPC232�', '10EPC242�')
   and curso.nome = 'ENFERMAGEM'
*/

if object_id('tempdb..#tmp1') is not null begin 
    drop table #tmp1
end

--CRIA TABELA TEMPOR�RIA COM OS CRIT�RIOS
select distinct pec.planoensino_id, pec.id as planoensino_criterio_id, cri.nome as criterio, cri.posicao, td.id as turma_disciplina_id, 
                pec.criterio_id, getdate() as criado_em, 2137 as criado_por, getdate() as atualizado_em, 2137 as atualizado_por, 
				isnull(tdp.professor_id, rd.professor_id) as professor_id 
into #tmp1
--select turma.inicio_vigencia, turma.termino_vigencia, plano.id as plano_id, td.id as turma_disciplina_id, cri.nome as criterio, 
--turma.nome as turma, disc.nome as disciplina, json_value(td.atributos, '$.universus_key.codtipoaula'), cri.valor
  from planos_ensino_planoensino_criterio pec
       join atividades_criterio cri on cri.id = pec.criterio_id
       join planos_ensino_planoensino plano on plano.id = pec.planoensino_id
	   join academico_curso curso on curso.id = plano.course_id
       join academico_etapaano ea on ea.id = plano.etapa_ano_id
       join academico_etapa etapa on etapa.id = ea.etapa_id
	   join academico_turma turma on turma.etapa_ano_id = plano.etapa_ano_id
	   join academico_turmadisciplina td on td.turma_id = turma.id and td.disciplina_id = plano.disciplina_id
	   join academico_disciplina disc on disc.id = td.disciplina_id
	   left outer join academico_turmadisciplinaprofessor tdp on tdp.turma_disciplina_id = td.id and ((select count(1) from academico_turmadisciplinaprofessor tdp2 where tdp2.turma_disciplina_id = td.id) = 1)
	   left outer join academico_responsaveldisciplina rd on rd.curso_id = turma.curso_id and rd.disciplina_id = td.disciplina_id and ((select count(1) from academico_responsaveldisciplina rd2 where rd2.curso_id = turma.curso_id and rd2.disciplina_id = disc.id) = 1 )
 where 1 = 1
   and plano.etapa_ano_id is not null
   
   --REPLICA OS CRIT�RIOS APENAS PARA TURMAS IMPORTADAS DO UNIVERSUS, POIS NO EDUCAT AINDA N�O TEM A INDICA�AO SE A TURMA E TE�RICA OU PR�TICA
   --and json_query(turma.atributos, '$.universus_key') is not null
   
   --INDICA UMA TURMA ESPEC�FICA PARA REPLICAR OS CRIT�RIOS
 --  and turma.nome in ('10EPC102�', '10EPC112�', '10EPC122�', '10EPC132�', '10EPC142�', '10EPC152�', '10EPC162�', '10EPC172�')

   --CONSIDERA TURMA DE UMA DETERMINADA ETAPA
   and etapa.etapa = 8

   --BLOQUEIA A INSER��O DE CRIT�RIOS NA TURMA/DISCIPLINA SE J� EXISTIR ALGUM CRIT�RIO CADASTRADO NESSA TURMA/DISCIPLINA
   -- and not exists (select top 1 1 from atividades_criterio_turmadisciplina actd where actd.turma_disciplina_id = td.id)

   --INDICA A DISCIPLINA E CURSO DO PLANO DE ENSINO QUE TER� OS CRIT�RIOS REPLICADOS
   and disc.nome in ('EST�GIO SUPERVISIONADO I')
   and curso.nome = 'ENFERMAGEM'
   
   --CONSIDERA APENAS TURMAS DO SEGUNDO SEMESTRE
   and turma.inicio_vigencia  >= '2019-02-01'
   and turma.termino_vigencia >= '2019-07-16'
   
   AND json_value(td.atributos, '$.universus_key.codtipoaula') = 5 --Pr�tica

   --RESTRINGE O TIPO DE TURMA (TE�RICA E PR�TICA), PARA REGRAS ESPEC�FICAS
/*   and (json_value(td.atributos, '$.universus_key.codtipoaula') is null
        or (json_value(td.atributos, '$.universus_key.codtipoaula') is not null
		    and (json_value(td.atributos, '$.universus_key.codtipoaula') = 1 --Te�rica
			     or (json_value(td.atributos, '$.universus_key.codtipoaula') = 2 --Pr�tica
				     and disc.id in (7050,7143,7077,7087,7089,7099,7101,7378, --Treinamento de habilidades I...VII
					                 4079,4080,5718,4081,5728 --Pr�ticas em Sa�de Coletiva I e II
									)
				     )
			    )
		    ) 
	    )
*/

if ( NOT exists (select top 1 1 from #tmp1 tmp join vw_curso_turma_disciplina_qtd_atividade vw on (tmp.turma_disciplina_id = vw.turma_disciplina_id)
                  WHERE VW.ALUNOS_COM_NOTA_ATIVIDADE > 0)
	)
	BEGIN

		--BACKUP DOS DADOS
		DECLARE @SQL1 NVARCHAR(500), @SQL2 NVARCHAR(500)
		
		SET @SQL1 = 'select * into tmp_atividades_atividade_' + REPLACE(CONVERT(VARCHAR(10),GETDATE(), 105),'-','') + '_' + REPLACE(CONVERT(VARCHAR(10),GETDATE(), 108),':','') + '  from atividades_atividade'
		PRINT @SQL1
		 
		SET @SQL2 = 'select * into tmp_atividades_criterio_turmadisciplina_' + REPLACE(CONVERT(VARCHAR(10),GETDATE(), 105),'-','') + '_' + REPLACE(CONVERT(VARCHAR(10),GETDATE(), 108),':','') + '  from atividades_criterio_turmadisciplina'
		PRINT @SQL2 

		EXEC SP_EXECUTESQL @SQL1
		EXEC SP_EXECUTESQL @SQL2

		begin tran


		--APAGA AS ATIVIDADES E CRIT�RIOS DA TURMA/DISCIPLINA, PARA GARANTIR QUE TODOS OS CRIT�RIOS E ATIVIDADES QUE EST�O NO PLANO DE ENSINO SER�O REPLICADOS PARA AS TURMAS
		delete from atividades_atividade where criterio_turma_disciplina_id in (select id from atividades_criterio_turmadisciplina where turma_disciplina_id in (select turma_disciplina_id from #tmp1))
		delete from atividades_criterio_turmadisciplina where turma_disciplina_id in (select turma_disciplina_id from #tmp1)

		--COPIA OS CRIT�RIOS PARA AS TURMAS
		insert into atividades_criterio_turmadisciplina (turma_disciplina_id, criterio_id, criado_em, criado_por, atualizado_em, atualizado_por, professor_id, inicio_janela_lancamento, termino_janela_lancamento, atributos)
		select turma_disciplina_id, criterio_id, criado_em, criado_por, atualizado_em, atualizado_por, professor_id,
			   case
				  when criterio = 'AVALIA��O PARCIAL' then '2019-09-23'
				  when criterio = 'AVALIA��O FORMATIVA' then '2019-11-11'
				  when criterio = 'APIC - AVALIA��O PARCIAL INTEGRADORA DE CONTE�DOS' then '2019-11-11'
				  when criterio = 'AVALIA��O SOMATIVA' then '2019-11-19'
				  else null
			   end as inicio_janela_lancamento,
			   case
				  when criterio = 'AVALIA��O PARCIAL' then '2019-10-07'
				  when criterio = 'AVALIA��O FORMATIVA' then '2019-11-18'
				  when criterio = 'APIC - AVALIA��O PARCIAL INTEGRADORA DE CONTE�DOS' then '2019-11-18'
				  when criterio = 'AVALIA��O SOMATIVA' then '2019-12-13'
				  else null
			   end as termino_janela_lancamento,
			   '{"planoensino_id":' + convert(varchar(100), planoensino_id) + '}'
		  from #tmp1
		



		--COPIA AS ATIVIDADES PARA AS TURMAS
		insert into atividades_atividade (criado_em, criado_por, atualizado_em, atualizado_por, nome, valor, peso, criterio_turma_disciplina_id, status_id)
		select getdate() as criado_em, 2137 as criado_por, getdate() as atualizado_em, 2137 as atualizado_por, patv.nome, patv.valor, 1,
			   (select ctd.id from atividades_criterio_turmadisciplina ctd where ctd.criterio_id = t.criterio_id and ctd.turma_disciplina_id = t.turma_disciplina_id), 1
		  from planos_ensino_atividade patv
			   join #tmp1 t on t.planoensino_criterio_id = patv.planoensino_criterio_id

	END
ELSE 
	BEGIN
		select DISTINCT   VW.TURMA_NOME,  VW.CURSO_NOME + ' - ' + VW.TURMA_NOME  + ' - ' + VW.DISCIPLINA_NOME  + ' - ' +  'TURMA DISCIPLINA JA POSSUI NOTA DE ATIVIDADE' 
		 from #tmp1 tmp join vw_curso_turma_disciplina_qtd_atividade vw on (tmp.turma_disciplina_id = vw.turma_disciplina_id)
                  WHERE VW.ALUNOS_COM_NOTA_ATIVIDADE > 0
	END
--commit
-- ROLLBACK