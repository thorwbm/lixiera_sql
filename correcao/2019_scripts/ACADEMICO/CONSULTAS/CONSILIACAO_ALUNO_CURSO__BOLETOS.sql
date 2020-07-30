USE boletos_service
GO 
   
  select  DISTINCT con.boleto_id, 
con.nosso_numero,
con.payer_name as nome,
con.natureza_recebimento_parsed,
con.data_vencimento,
con.data_liquidacao,
con.valor_boleto,
con.desconto_concedido,
con.juros_de_mora,
con.valor_lancamento,
con.valor_recebido,
--rem.name as curso, 
ctda.curso_nome,
ctda.aluno_cpf,
erros = case when rem.name COLLATE DATABASE_DEFAULT <> ctda.curso_nome COLLATE DATABASE_DEFAULT then 'DIVERGENCIA DE CURSO: ' + rem.name COLLATE DATABASE_DEFAULT +' <--> '+ ctda.curso_nome COLLATE DATABASE_DEFAULT else null end
--select distinct  con.*
   FROM [db_owner].[conciliacao_cbr643] con  left join rem_prd..vw_remessa_boleto_curso rem  on (con.boleto_id = rem.boleto_id)    
                                             left join erp_prd..vw_curriculo_curso_aluno ctda on (ctda.aluno_cpf COLLATE DATABASE_DEFAULT = payer_id_number COLLATE DATABASE_DEFAULT and 
											                                                      CTDA.CURSO_ATUAL = 1)

--where isnull(rem.name,'') COLLATE DATABASE_DEFAULT <> ctda.curso_nome COLLATE DATABASE_DEFAULT

order by 3