
SELECT PES.NOME, LAN.ano_competencia, LAN.mes_competencia, LAN.valor_liquido, LAN.valor_pago,
       LAN.ID AS LANCAMENTO_ID, BOL.ID AS LANC_BOLETO_ID,
       BOL.valor_pago AS VALOR_PAGO_BOLETO, BOL.valor_descontos, STL.NOME AS STATUS_LANCAMENTO_NOME, 
	   blt.valor_pago as boleto_valor_pago, blt.data_vencimento as boleto_data_venc, blt.data_pagamento boleto_data_pag, blt.boleto_status
  FROM financeiro_conta CON JOIN PESSOAS_PESSOA              PES ON (PES.ID = CON.pessoa_id)
                            JOIN FINANCEIRO_LANCAMENTO       LAN ON (CON.ID = LAN.conta_id)
							JOIN financeiro_lancamentoboleto BOL ON (LAN.ID = BOL.lancamento_id)
							JOIN financeiro_statuslancamento STL ON (STL.ID = LAN.status_id)
					   left join vw_fnc_boleto               blt on (blt.boleto_id = bol.boleto_id) 
 WHERE PES.NOME = 'DANIELA SOBRAL PEREIRA'  AND 
       BOL.VALOR_PAGO <> LAN.VALOR_PAGO

/*
ALUNA 'DANIELA SOBRAL PEREIRA' possui 2 lancamentos incosistentes, 
1661 -> mes competencia 4 -> valor pago = 1546.38 porem boleto zerado e status pago.
1664 -> mes competencia 7 -> valor pago = 3092.76 porem o lancamento tem dois lancamentos boletos cada um no valor de 1546.38 com os respectivos ids (11326, 11327) sendo que o boleto de pagamento referenciado e  o mesmo.
*/

----------------------------------------------------------------------------------------------------
SELECT PES.NOME, LAN.ano_competencia, LAN.mes_competencia, LAN.valor_liquido, LAN.valor_pago,
       LAN.ID AS LANCAMENTO_ID, BOL.ID AS LANC_BOLETO_ID,
       BOL.valor_pago AS VALOR_PAGO_BOLETO, BOL.valor_descontos, STL.NOME AS STATUS_LANCAMENTO_NOME, 
	   blt.valor_pago as boleto_valor_pago, blt.data_vencimento as boleto_data_venc, blt.data_pagamento boleto_data_pag, blt.boleto_status
  FROM financeiro_conta CON JOIN PESSOAS_PESSOA              PES ON (PES.ID = CON.pessoa_id)
                            JOIN FINANCEIRO_LANCAMENTO       LAN ON (CON.ID = LAN.conta_id)
							JOIN financeiro_lancamentoboleto BOL ON (LAN.ID = BOL.lancamento_id)
							JOIN financeiro_statuslancamento STL ON (STL.ID = LAN.status_id)
					   left join vw_fnc_boleto               blt on (blt.boleto_id = bol.boleto_id) 
 WHERE PES.NOME = 'Dianne Pereira Gonçalves Melo'  AND 
       BOL.VALOR_PAGO <> LAN.VALOR_PAGO
	   
/*
ALUNA 'Dianne Pereira Gonçalves Melo' possui 2 lancamentos incosistentes, 
3634 -> mes competencia 4 -> valor pago = 379.60 porem boleto zerado e status pago.
3637 -> mes competencia 7 -> valor pago = 759.20 porem o lancamento tem dois lancamentos boletos cada um no valor de 1546.38 com os respectivos ids (11504, 11505) sendo que o boleto de pagamento referenciado e  o mesmo.
*/

----------------------------------------------------------------------------------------------------
 

/*
ALUNA 'Lorena Roberta Estevam de Souza' possui 2 lancamentos incosistentes, 
1597 -> mes competencia 4 -> valor pago = 773.98 porem boleto zerado e status pago.(o boleto esta pendente)
26007 -> mes competencia 8 -> valor pago = 781.80 porem boleto zerado e status pago.(o boleto esta pendente)
*/



	   select * from financeiro_desconto where lancamento_id in (3415, 16797)

	   select * from financeiro_metodopagamento where id = 5
	   
	   select * from financeiro_lancamentoboleto where lancamento_id = 3415
	   
	   select * from financeiro_lancamento where id = 3415





create view vw_fnc_descontos_por_lancamento as 
select lancamento_id, sum(valor) as desconto_por_lancamento
  from financeiro_desconto 
 group by lancamento_id

