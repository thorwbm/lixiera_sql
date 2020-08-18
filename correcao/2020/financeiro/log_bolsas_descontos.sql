select lfd.*, tpd.descricao as tipo_desconto, cri.nome_civil as criado_por, alt.nome_civil as atualizado_por
  from financeiro_desconto des join financeiro_lancamento lan on (lan.id = des.lancamento_id)
                               join VW_ACD_CURRICULO_ALUNO_PESSOA cap on (cap.curriculo_aluno_id = lan.curriculo_aluno_id)
							   join log_financeiro_desconto lfd on (lfd.id = des.id)
							   join contratos_tipodesconto  tpd on (tpd.id = lfd.tipo_id)
							left join auth_user             cri on (cri.id = lfd.criado_por)
							left join auth_user             alt on (alt.id = lfd.atualizado_por)
 where cap.aluno_nome = 'RAQUEL RAMOS SCHETTINO'

