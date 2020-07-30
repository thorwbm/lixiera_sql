select * from vw_entregas

select * from [20191016].[correcoes_correcao] WHERE redacao_id = 396548

select TOP 100 * from  [dbo].[inep_n59]WHERE redacao_id = 396548

 
declare @data_char char(8) = '20191015' --format(dbo.getlocaldate(), 'yyyyMMdd')
declare @sql nvarchar(max) = 'select * into #tmp_correcoes_correcao from ['+ @data_char + '].correcoes_correcao'
exec sp_executesql @sql

select * from #tmp_correcoes_correcao

select ine.redacao_id
from [dbo].[inep_n59] ine with(nolock) 
 where not exists(select 1 from [20191016].[correcoes_correcao] cor 
                   where ine.redacao_id = cor.redacao_id and 
				         cor.id_tipo_correcao  = 1                     and 
				         isnull(ine.nu_nota_comp1_av1,-5) = isnull(cor.nota_competencia1,-5) and 
						 isnull(ine.nu_nota_comp2_av1,-5) = isnull(cor.nota_competencia2,-5) and 
						 isnull(ine.nu_nota_comp3_av1,-5) = isnull(cor.nota_competencia3,-5) and 
						 isnull(ine.nu_nota_comp4_av1,-5) = isnull(cor.nota_competencia4,-5) and 
						 isnull(ine.nu_nota_comp5_av1,-5) = isnull(cor.nota_competencia5,-5) and 
						 isnull(      ine.nu_nota_av1,-5) = isnull(cor.nota_final,-5       ) AND 
						 ISNULL(     ine.nu_tempo_av1,-5)      = ISNULL(COR.TEMPO_EM_CORRECAO,-5  ))       AND
	ine.nu_cpf_av1 IS NOT NULL  
UNION 
select ine.redacao_id
from [dbo].[inep_n59] ine with(nolock) 
 where NOT exists(select 1 from [20191016].[correcoes_correcao] cor 
                   where ine.redacao_id = cor.redacao_id and 
				         cor.id_tipo_correcao  = 2                     and 
				         isnull(ine.nu_nota_comp1_av2,-5) = isnull(cor.nota_competencia1,-5) and 
						 isnull(ine.nu_nota_comp2_av2,-5) = isnull(cor.nota_competencia2,-5) and 
						 isnull(ine.nu_nota_comp3_av2,-5) = isnull(cor.nota_competencia3,-5) and 
						 isnull(ine.nu_nota_comp4_av2,-5) = isnull(cor.nota_competencia4,-5) and 
						 isnull(ine.nu_nota_comp5_av2,-5) = isnull(cor.nota_competencia5,-5) and 
						 isnull(      ine.nu_nota_av2,-5) = isnull(cor.nota_final,-5))       AND
	ine.nu_cpf_av2 IS NOT NULL
						  
UNION 
select ine.redacao_id
from [dbo].[inep_n59] ine with(nolock) 
 where NOT exists(select 1 from [20191016].[correcoes_correcao] cor 
                   where ine.redacao_id = cor.redacao_id and 
				         cor.id_tipo_correcao  = 3                     and 
				         isnull(ine.nu_nota_comp1_av3,-5) = isnull(cor.nota_competencia1,-5) and 
						 isnull(ine.nu_nota_comp2_av3,-5) = isnull(cor.nota_competencia2,-5) and 
						 isnull(ine.nu_nota_comp3_av3,-5) = isnull(cor.nota_competencia3,-5) and 
						 isnull(ine.nu_nota_comp4_av3,-5) = isnull(cor.nota_competencia4,-5) and 
						 isnull(ine.nu_nota_comp5_av3,-5) = isnull(cor.nota_competencia5,-5) and 
						 isnull(      ine.nu_nota_av3,-5) = isnull(cor.nota_final,-5))       AND
	ine.nu_cpf_av3 IS NOT NULL


select * from [20191016].[correcoes_correcao] where redacao_id = 396548 and id_tipo_correcao = 3

join [20191015].[correcoes_correcao] cor15 with(nolock)  on (ine.redacao_id = cor15.redacao_id and 
                                                                                                             cor15.id_tipo_correcao = 1        and 
																											 cor15.nota_competencia1    = ine.nu_nota_comp1_av1) 
where ine.redacao_id = 403876