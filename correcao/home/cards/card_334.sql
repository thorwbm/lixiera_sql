/****************************************************************
    TABELA tmpimp_etapaAtual FOI CRIADA A PARTIR DE UM EXCEL 
    FORNECIDO PELA STA ROSE (CONTROLE ACADEMICO)
****************************************************************/
 update cra set cra.grade_id = gra.id
-- select * 
  from tmpimp_etapaAtual tmp left join curriculos_curriculo crc on (ltrim(rtrim(tmp.curriculo_nome)) = ltrim(rtrim(crc.nome)))
                                   join academico_aluno      alu on (alu.ra = tmp.ra)
                                   join curriculos_aluno     cra on (crc.id = cra.curriculo_id and 
                                                                     alu.id = cra.aluno_id)
                                   join curriculos_grade     gra on (crc.id = gra.curriculo_id)
                                   join academico_etapa      eta on (eta.id = gra.etapa_id and 
                                                                     eta.etapa = tmp.etapa)
where  gra.id <> cra.grade_id




select * into bkp_curriculos_aluno_2020_06_12__1436 from curriculos_aluno