begin tran
delete planEnsAti
from planos_ensino_planoensino planEns join planos_ensino_planoensino_criterio planEnsCri on planEnsCri.planoensino_id = planEns.id 
                                       join planos_ensino_atividade planEnsAti on planEnsAti.planoensino_criterio_id = planEnsCri.id 
where planEns.ano = 2020

-- rollback
-- commit