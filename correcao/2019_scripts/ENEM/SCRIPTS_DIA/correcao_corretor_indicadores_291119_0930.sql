-- exec sp_correcoes_corretor_indicadores '2019-11-28',4

select usuario_id,* from correcoes_corretor_indicadores with(nolock)
where data_calculo = '2019-11-28' and dsp =0

select cor.* --cci.dsp, cor.dsp, cci.usuario_id, cci.data_calculo 
--into tmp_correcoes_corretor_dsp_null_zero_291119__0930
-- begin tran update cor set cor.dsp = null
from correcoes_corretor cor with(nolock) join  correcoes_corretor_indicadores cci with(nolock) on (cor.id = cci.usuario_id)
where cci.data_calculo = '2019-11-28' and cci.dsp = 0 and cci.ouros_corrigidas = 0 and cci.modas_corrigidas = 0 and cor.dsp =0

-- commit 
-- rollback 

select usuario_id,*  from correcoes_corretor_indicadores with(nolock)
where data_calculo = '2019-11-28' and dsp =0 and usuario_id = 416

select * from correcoes_corretor where id = 416

