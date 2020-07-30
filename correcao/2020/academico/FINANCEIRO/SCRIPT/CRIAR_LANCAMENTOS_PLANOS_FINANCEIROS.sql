--with cte_planos_sem_parcela as (
--		SELECT distinct pla.id as plano_id, onb.id as processo_id, pla.due_date as dt_vencimento, pla.[name]
--		  FROM planos_de_pagamento_detalhados DET JOIN onboarding_onboarding  ONB ON (DET.curriculum = ONB.curriculum )
--												  JOIN onboarding_financeplan pla on (onb.id = pla.onboarding_id and 
--																					  pla.name = det.nome)
--											 left join onboarding_paymentplan pay on (pla.id = pay.finance_plan_id)								 
--		where pay.id is null 
--)

SELECT distinct pla.id as plano_id, onb.id as processo_id, pla.due_date as dt_vencimento, pla.[name] as plano_nome
		  into #temp 
		  FROM planos_de_pagamento_detalhados DET JOIN onboarding_onboarding  ONB ON (DET.curriculum = ONB.curriculum )
												  JOIN onboarding_financeplan pla on (onb.id = pla.onboarding_id and 
																					  pla.name = det.nome)
											 left join onboarding_paymentplan pay on (pla.id = pay.finance_plan_id)								 
		where pay.id is null 


		begin tran 

		declare @plano_id int, @processo_id int, @dt_vencimento datetime, @plano_nome varchar(50), @menordata datetime
		
		   declare CUR_ cursor for 
				SELECT plano_id,processo_id, dt_vencimento, plano_nome FROM #temp
				open CUR_ 
					fetch next from CUR_ into @plano_id, @processo_id, @dt_vencimento, @plano_nome
					while @@FETCH_STATUS = 0
						BEGIN
							-- **** menor data ****
							select @menordata = min(pay.date)
							  from onboarding_financeplan pla join onboarding_paymentplan pay on (pla.id = pay.finance_plan_id)        
							 where pla.onboarding_id = @processo_id and 
								   pla.name = @plano_nome
							-- **** menor data  fim ****

							insert into onboarding_paymentplan ([name], [date], cash, [value], finance_plan_id, discount_id, [type_id], competency)
							select 
							       pay.[name],pay.[date], pay.cash, pay.[value], finance_plan_id = @plano_id, pay.discount_id, pay.[type_id],
								   pay.competency
							  from onboarding_financeplan pla join onboarding_paymentplan pay on (pla.id = pay.finance_plan_id)        
							 where pla.onboarding_id = @processo_id and 
								   pla.name = @plano_nome
                             
							 -- ***** atualizar a data inicio ********
							 update pay set pay.[date] = @dt_vencimento
							 from onboarding_paymentplan pay
							 where pay.finance_plan_id = @plano_id and 
							       pay.[date] = @menordata
							 -- ***** atualizar a data inicio ********
						fetch next from CUR_ into @plano_id, @processo_id, @dt_vencimento, @plano_nome
						END
				close CUR_ 
			deallocate CUR_ 

select *  from onboarding_paymentplan
where finance_plan_id > 12


select distinct finance_plan_id from onboarding_paymentplan
where finance_plan_id > 12

-- commit 
-- rollback 