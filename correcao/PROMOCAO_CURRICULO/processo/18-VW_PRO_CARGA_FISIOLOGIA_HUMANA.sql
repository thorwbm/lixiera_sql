
create view [dbo].[VW_PRO_CARGA_FISIOLOGIA_HUMANA] as 
select car.pai, pai.turma_disciplina_max_vaga as pai_max_carga, 
       car.filha, fil.turma_disciplina_max_vaga as filha_max_carga, 
       car.subfilha, sub.turma_disciplina_max_vaga as subfilha_max_carga 
  from TMP_PRO_CARGA_FISIOLOGIA_HUMANA car join VW_ACD_CURRICULO_TURMA_DISCIPLINA pai   on (pai.turma_nome = car.pai and
                                                                                            pai.disciplina_id = 7285)
							               join VW_ACD_CURRICULO_TURMA_DISCIPLINA fil on (fil.turma_nome = car.filha and
                                                                                            fil.disciplina_id = 7285)
							               join VW_ACD_CURRICULO_TURMA_DISCIPLINA sub   on (sub.turma_nome = car.subfilha and
                                                                                            sub.disciplina_id = 7285)