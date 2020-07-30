create or alter view vw_rel_historico_comparativo as
with cte_disciplina_concluida as (
            select 
                   csa.sigla as disciplina_status_sigla, 
                   eta.ano as etapa_ano, eta.periodo as etapa_periodo, cdc.curriculo_aluno_id,cdc.disciplina_informada_id, 
                   cdc.disciplina_id, cdc.nota, cdc.frequencia, dbo.fu_time_number_to_text(cdc.carga_horaria) as carga_horaria,
                   cap.curriculo_id, cap.curriculo_nome
              from 
                   curriculos_disciplinaconcluida cdc join curriculos_statusdisciplina csa on (cdc.status_id = csa.id)
                                                      join academico_etapaano          eta on (eta.id = cdc.etapa_ano_id)
                                                      join vw_Curriculo_aluno_pessoa   cap on (cap.curriculo_aluno_id = cdc.curriculo_aluno_id)
             where cap.curriculo_aluno_status_id = 13
)
            
    ,   cte_disciplina_cursando as (    
            select distinct 
                   'CRS' as disciplina_status_sigla, tds.disciplina_id,
                   eta.ano as etapa_ano , eta.periodo as etapa_periodo, cap.id AS curriculo_aluno_id,
                   cap.curriculo_id, crc.nome as curriculo_nome
              from 
                   academico_turmadisciplinaaluno tda join academico_turmadisciplina tds on (tds.id = tda.turma_disciplina_id)
                                                      join academico_turma           tur on (tur.id = tds.turma_id )
                                                      JOIN curriculos_grade          GRA ON (GRA.id = tur.grade_id)
                                                      join curriculos_aluno          cap on (cap.curriculo_id = gra.curriculo_id and 
                                                                                             cap.aluno_id     = tda.aluno_id)
                                                      join curriculos_curriculo      crc on (crc.id = gra.curriculo_id)
                                                      JOIN academico_etapa           ETP ON (ETP.id = GRA.etapa_id)
                                                      JOIN academico_etapaano        ETA ON (ETP.id = ETA.etapa_id AND 
                                                                                             ETA.id = tur.etapa_ano_id)
             where 
                   getdate() between tur.inicio_vigencia and tur.termino_vigencia 
)      

select distinct cra.id AS curriculo_aluno_id, alu.ra as aluno_ra, alu.nome as aluno_nome, 
       crc.id as curriculo_id, crc.nome as curriculo_nome, csa.nome as curriculo_aluno_status_nome, 
       cur.id as curso_id, cur.nome as curso_nome , tpo.nome, dis.nome as disciplina_nome, 
       tds.disciplina_id, eta.nome as etapa_nome, cdsc.nota, cdsc.frequencia, 
       dbo.fu_time_number_to_text(cgd.carga_horaria) as carga_horaria,
       ISNULL(cdsc.disciplina_status_sigla, isnull(cdcs.disciplina_status_sigla, 'NC')) as disciplina_status_sigla, 
       cra.status_id as curriculo_aluno_status_id 
  from curriculos_aluno cra join academico_aluno                       alu  on (alu.id  = cra.aluno_id)
                            join curriculos_statusaluno                csa  on (csa.id  = cra.status_id)
                            join curriculos_curriculo                  crc  on (crc.id  = cra.curriculo_id)
                            join academico_cursooferta                 cro  on (cro.id  = crc.curso_oferta_id)
                            join academico_tipooferta                  tpo  on (tpo.id  = cro.tipo_oferta_id)
                            join academico_curso                       cur  on (cur.id  = crc.curso_id)
                            join curriculos_grade                      gra  on (crc.id  = gra.curriculo_id)
                            join academico_etapa                       eta  on (eta.id  = gra.etapa_id)
                            join curriculos_gradedisciplina            cgd  on (gra.id  = cgd.grade_id)
                            join academico_disciplina                  dis  on (dis.id  = cgd.disciplina_id)
                       left join academico_turmadisciplina             tds  on (dis.id  = tds.disciplina_id)
                       left join academico_turmadisciplinaaluno        tda  on (cra.id  = tda.curriculo_aluno_id and 
                                                                                tds.id  = tda.turma_disciplina_id)
                       left join cte_disciplina_concluida              cdsc on (cra.id  = cdsc.curriculo_aluno_id and 
                                                                                dis.id  = cdsc.disciplina_id)
                       left join cte_disciplina_cursando               cdcs on (dis.id  = cdcs.disciplina_id and 
                                                                                cra.id  = cdcs.curriculo_aluno_id)
                       --left join curriculos_gradedisciplinaequivalente gde  on (cgd.id  = gde.grade_disciplina_id)
                       --left join curriculos_gradedisciplina            ecgd on (ecgd.id = gde.grade_disciplina_equivalente_id)
                       --left join academico_disciplina                  edis on (edis.id = ecgd.disciplina_id)

 select * from vw_rel_historico_comparativo
 where
       aluno_nome = 'VIVIAN APARECIDA CAMPOS DA SILVA' and 
       curriculo_aluno_status_id = 13

       order by eta.nome, dis.nome

--  select * from curriculos_gradedisciplinaequivalente where grade_disciplina_id = 69628

-- select * from academico_turmadisciplina 







