with    cte_maior_etapa as (
            select curriculo_id, max(etp.etapa) maior_etapa
              from curriculos_grade gra join academico_etapa etp on (etp.id = gra.etapa_id)
                                        join academico_etapaano eta on (etp.id = eta.etapa_id)
            where eta.ano = 2020 --and curriculo_id = 2363
            group by curriculo_id 
)

    ,   cte_curriculo_disciplina as (
            select distinct gra.curriculo_id, grd.disciplina_id, gra.id as grade_id, met.maior_etapa, crc.nome 
            from curriculos_gradedisciplina grd join curriculos_grade   gra on (gra.id = grd.grade_id)
                                                join curriculos_curriculo crc on (crc.id = gra.curriculo_id)
                                                join academico_etapa    etp on (etp.id = gra.etapa_id)
                                                join academico_etapaano eta on (etp.id = eta.etapa_id)
                                                join cte_maior_etapa    met on (met.curriculo_id = gra.curriculo_id and
                                                                                met.maior_etapa   = etp.etapa)
) 

            select distinct 
                   cur.id as curso_id, cur.nome as curso_nome,
                   cap.aluno_id, cap.aluno_ra, cap.aluno_nome, cap.curriculo_nome, cte.maior_etapa, etp.nome
              from academico_turmadisciplinaaluno tda join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id)                                          
                                                      join academico_disciplina      dis on (dis.id = tds.disciplina_id)
                                                      join academico_turma           tur on (tur.id = tds.turma_id)
                                                      join academico_curso           cur on (cur.id = tur.curso_id)
                                                      join curriculos_grade          gra on (gra.id = tur.grade_id)
                                                      join academico_etapa           etp on (etp.id = gra.etapa_id)
                                                      join vw_Curriculo_aluno_pessoa cap on (cap.aluno_id = tda.aluno_id and 
                                                                                             gra.curriculo_id = cap.curriculo_id)
                                                      join cte_curriculo_disciplina  cte on (gra.id = cte.grade_id and 
                                                                                             dis.id = cte.disciplina_id and 
                                                                                             cte.curriculo_id = gra.curriculo_id)
             where tda.status_matricula_disciplina_id = 1 and 
                   year(tur.inicio_vigencia) = 2020 and 
                   cur.nome not in ('CURSO DE EXTENSÃO EM ORATÓRIA')
order by cur.nome, cap.aluno_nome

