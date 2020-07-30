with    cte_dados as (
            select distinct 
                   cra.curso_nome, cra.curriculo_nome, cra.curriculo_aluno_status_nome,
                   cra.aluno_nome, cra.forma_ingresso_nome, 
                   dis.nome as disciplina_nome, sts.nome as aluno_disciplina_status, 
                   eta.ano, eta.periodo, 
                   cra.curriculo_aluno_id, cra.aluno_id, dis.id as disciplina_id, sts.id as aluno_disciplina_status_id, dsc.nota 
              from academico_turmadisciplinaaluno tda join academico_turmadisciplina           tds on (tds.id = tda.turma_disciplina_id)
                                                      join academico_disciplina                dis on (dis.id = tds.disciplina_id)
                                                      join academico_turma                     tur on (tur.id = tds.turma_id)
                                                      join academico_etapaano                  eta on (eta.id = tur.etapa_ano_id)
                                                      join vw_curriculo_aluno                  cra on (cra.aluno_id = tda.aluno_id and 
                                                                                                       cra.curriculo_aluno_id = tda.curriculo_aluno_id)
                                                      join academico_statusmatriculadisciplina sts on (sts.id = tda.status_matricula_disciplina_id)
                                                 left join curriculos_disciplinaconcluida      dsc on (dis.id = dsc.disciplina_id and 
                                                                                                       cra.curriculo_aluno_id = dsc.curriculo_aluno_id)
             where --eta.ano = 2019 and 
                   --eta.periodo in (0,2) and 
                   sts.id in (6,7,9) and 
                   tda.exigencia_matricula_disciplina_id = 2 and
                   cra.forma_ingresso_nome like '%PROUNI%' 
)
    ,   cte_quantidade_aprovacao_ano_periodo as (
            select curriculo_aluno_id, ano, periodo, 
                   aprovado_ano_periodo  = sum (case when aluno_disciplina_status_id = 6 then 1 else 0 end), 
                   reprovado_ano_periodo = sum (case when aluno_disciplina_status_id in (7,9) then 1 else 0 end), 
                   total_ano_periodo     = count(1)
              from cte_dados dad
              group by curriculo_aluno_id, ano, periodo
)  

            select distinct 
                   dad.curriculo_nome, dad.curso_nome,dad.aluno_nome, dad.forma_ingresso_nome, 
                   --dad.aluno_disciplina_status, nota, dad.disciplina_nome, 
                   dad.ano, dad.periodo,
                   apr.aprovado_ano_periodo, apr.reprovado_ano_periodo, apr.total_ano_periodo, 
                   percentual_aprovacao =  cast(round(apr.aprovado_ano_periodo * 100 / (apr.total_ano_periodo * 1.0),2) as decimal(10,2)),
                   dad.curriculo_aluno_status_nome
                   
              from cte_dados dad join cte_quantidade_aprovacao_ano_periodo apr on (dad.curriculo_aluno_id = apr.curriculo_aluno_id and
                                                                                   dad.ano                = apr.ano and
                                                                                   dad.periodo            = apr.periodo)

order by 1, 2, 3,6