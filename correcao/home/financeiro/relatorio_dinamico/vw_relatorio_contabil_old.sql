create   view vw_rel_relatorio_contabil as   
with cte_rel_financ as (  
   SELECT alu.ra as aluno_ra, alu.nome as aluno_nome,   
       escola = 'FACULDADE CIÊNCIAS MÉDICAS DE MINAS GERAIS', campus = 'CAMPUS BELO HORIZONTE', cur.nome as CURSO,   
       CRC.NOME AS CURRICULO, CSA.NOME AS STATUS_ALUNO_CURRICULO, ANO_PERIODO = eta.etapa,   
       par.valor as valor_bruto,  valor_fies = '?????', valor_prouni  = '?????', valor_bolsa  = '?????', valor_liquido  = '?????', valor_liquidado  = '?????',  
       valor_juros = '?????',  VALOR_MULTA  = '?????', VALOR_CORRECAO = '?????', VALOR_MORA = '?????', VALOR_DESCONTO = '?????', VALORACRESCIMO = '?????',   
       OUTROS_DESCONTOS = '?????',par.ano_competencia, par.mes_competencia,con.data_matricula, data_vencimento = par.data_vencimento,   
       data_liquidacao = '?????', data_credito_bancario = '?????', banco_conta = '?????',   
       con.id as contrato_id, tpr.descricao as servico  
     FROM ACADEMICO_ALUNO ALU join curriculos_aluno        cra on (alu.id = cra.aluno_id)             
            JOIN curriculos_statusaluno  CSA ON (CSA.ID = CRA.status_id)  
            join curriculos_curriculo    crc on (crc.id = cra.curriculo_id)  
                              join curriculos_grade        gra on (gra.id = cra.grade_id and   
                                                 crc.id = gra.curriculo_id)  
            join academico_etapa         eta on (eta.id = gra.etapa_id)  
            join academico_curso         cur on (cur.id = crc.curso_id)  
            join contratos_contrato      con on (cra.aluno_id     = con.aluno_id and   
                           cra.curriculo_id = con.curriculo_id)  
            join contratos_parcela       par on (con.id = par.contrato_id)  
            join contratos_tipopagamento tpr on (tpr.id = par.tipo_id)  
)  
  
 , cte_fies as (  
  select fin.ALUNO_RA, fin.contrato_id, fin.ano_competencia, fin.mes_competencia, fin.valor_bruto as valor_fies,  
         fin.responsavel_id  
    from VW_REL_EXTRATO_FINANCEIRO fin  
  where fin.responsavel_id = 782928  
)  
  
select distinct cte.aluno_ra,cte.aluno_nome, fin.RESPONSAVEL, cte.escola, cte.campus, cte.CURSO, cte.CURRICULO, cte.STATUS_ALUNO_CURRICULO, cte.ANO_PERIODO, cte.servico,  
                CLASSIFICACAO = fin.classificacao, FIN.STATUS_LANCAMENTO, CTE.ano_competencia, CTE.mes_competencia,  cte.data_vencimento, cte.valor_bruto,   
    isnull(ctf.valor_fies,0.0) as valor_fies, VALOR_FIES_CAIXA = 0,VALOR_PROUNI = FIN.[VALOR PROUNI], VALOR_BOLSA = FIN.[VALOR BOLSA],  
    CREDITO_FINANCEIRO = FIN.[CRÉDITO FINANCEIRO], VALOR_LIQUIDO = FIN.valor_liquido, VALOR_LIQUIDADO = FIN.valor_pago, VALOR_JUROS = FIN.JUROS,  
    VALOR_MULTA = FIN.MULTA, VALOR_CORRECAO = 0,VALOR_MORA = 0, VALOR_DESCONTO = FIN.[VALOR DESCONTO], VALOR_ACRESCIMO = FIN.VALOR_ACRESCIMOS,  
    OUTROS_DESCONTOS = FIN.[OUTROS DESCONTOS], DATA_MATRICULA = FIN.DATA_MATRICULA,   
    DATA_CREDITO_BANCARIO = FIN.creditado_em, BANCO  
  from  cte_rel_financ cte join VW_REL_EXTRATO_FINANCEIRO fin on (fin.ALUNO_RA = cte.aluno_ra and   
                                                                 fin.contrato_id = cte.contrato_id and  
                                                                 fin.ano_competencia = cte.ano_competencia and   
                 fin.mes_competencia = cte.mes_competencia)  
      left  join cte_fies                  ctf on (ctf.ALUNO_RA = fin.ALUNO_RA and  
                                               ctf.contrato_id = fin.contrato_id and  
                 ctf.ano_competencia = fin.ano_competencia and  
                 ctf.mes_competencia = fin.mes_competencia and  
                 ctf.responsavel_id = fin.responsavel_id)