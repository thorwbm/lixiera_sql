/****** Object:  UserDefinedFunction [dbo].[vwf_relatorios_responsabilidadeavaliador_aux]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[vwf_relatorios_responsabilidadeavaliador_aux]
GO
/****** Object:  UserDefinedFunction [dbo].[vwf_relatorios_responsabilidadeavaliador]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[vwf_relatorios_responsabilidadeavaliador]
GO
/****** Object:  UserDefinedFunction [dbo].[u_emp]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[u_emp]
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate3]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[getlocaldate3]
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate_table]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[getlocaldate_table]
GO
/****** Object:  UserDefinedFunction [dbo].[udfRetornaComandoSQL]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[udfRetornaComandoSQL]
GO
/****** Object:  UserDefinedFunction [dbo].[InlineMaxDatetime]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[InlineMaxDatetime]
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate2]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[getlocaldate2]
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[getlocaldate]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_duracao_correcao]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[fn_duracao_correcao]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_cor_monta_indice_hierarquia]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[fn_cor_monta_indice_hierarquia]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_cor_corretor_redacao_por_id]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[fn_cor_corretor_redacao_por_id]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_cor_corretor_redacao]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[fn_cor_corretor_redacao]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_calcula_nota_desempenho_ouro_moda_preteste_enem]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[fn_calcula_nota_desempenho_ouro_moda_preteste_enem]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_calcula_nota_desempenho_ouro_moda]    Script Date: 16/10/2019 10:23:26 ******/
DROP FUNCTION [dbo].[fn_calcula_nota_desempenho_ouro_moda]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_calcula_nota_desempenho_ouro_moda]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---------------------------------------------------------------------------
-- FUNÇÕES
---------------------------------------------------------------------------

CREATE FUNCTION [dbo].[fn_calcula_nota_desempenho_ouro_moda]
	(@id_analise int)
RETURNS numeric(10,2)
BEGIN
	DECLARE @RETORNO numeric(10,2)
	DECLARE @SITUACAO_CORRETOR INT
	DECLARE @SITUACAO_GABARITO INT

	set @retorno = 0.0

	select @SITUACAO_CORRETOR = id_correcao_situacao_A, @SITUACAO_GABARITO = id_correcao_situacao_B 	
	 from correcoes_analise ana
	where id = @id_analise

IF(@SITUACAO_CORRETOR = 1 and @SITUACAO_GABARITO = 1)
	BEGIN
		select @retorno = 
			-- nota1 =
					cast(round(2 - (abs(competencia1_B - competencia1_A) * 2)/
						(case when competencia1_B < 3 then 5 - competencia1_B else competencia1_B end * 1.0),2) as numeric (4,2)) +
			-- nota2 = 
					cast(round(2 - (abs(competencia2_B - competencia2_A) * 2)/
						(case when competencia2_B < 3 then 5 - competencia2_B else competencia2_B end * 1.0),2) as numeric (4,2)) +
			-- nota3 = 
					cast(round(2 - (abs(competencia3_B - competencia3_A) * 2)/
						(case when competencia3_B < 3 then 5 - competencia3_B else competencia3_B end * 1.0),2) as numeric (4,2)) +
			-- nota4 = 
					cast(round(2 - (abs(competencia4_B - competencia4_A) * 2)/
						(case when competencia4_B < 3 then 5 - competencia4_B else competencia4_B end * 1.0),2) as numeric (4,2)) +
			--nota5 = 
					cast(round(2 - (abs(case competencia5_B when -1 then 0 else competencia5_B end  - case competencia5_a when -1 then 0 else competencia5_a end) * 2)/
						(case when case competencia5_B when -1 then 0 else competencia5_B end < 3 then 5 - case competencia5_B when -1 then 0 else competencia5_B end else case competencia5_B when -1 then 0 else competencia5_B end end * 1.0),2) as numeric (4,2))

		  from correcoes_analise ana 
		 where id_tipo_correcao_A in(5,6) and 
			   id =  @id_analise
	END 
ELSE 
	BEGIN
		IF(@SITUACAO_CORRETOR = @SITUACAO_GABARITO)
			BEGIN
				SET @retorno = 10
			END
		ELSE 
			BEGIN
				SET @retorno = 0
			END
	END

return (@retorno)
end
GO
/****** Object:  UserDefinedFunction [dbo].[fn_calcula_nota_desempenho_ouro_moda_preteste_enem]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_calcula_nota_desempenho_ouro_moda_preteste_enem]
    (@id_analise int)
RETURNS numeric(10,1)
BEGIN
    DECLARE @RETORNO numeric(10,1)
    DECLARE @SITUACAO_CORRETOR INT
    DECLARE @SITUACAO_GABARITO INT

    set @retorno = 0.0

    select @SITUACAO_CORRETOR = id_correcao_situacao_A, @SITUACAO_GABARITO = id_correcao_situacao_B     
     from correcoes_analise ana
    where id = @id_analise

IF(@SITUACAO_CORRETOR = 1 and @SITUACAO_GABARITO = 1)
    BEGIN
        select @retorno = 
            -- nota1 =
                    cast(round(2 - (abs(competencia1_B - competencia1_A) * 2)/
                        (case when competencia1_B < 3 then 5 - competencia1_B else competencia1_B end * 1.0),1) as numeric (4,2)) +
            -- nota2 = 
                    cast(round(2 - (abs(competencia2_B - competencia2_A) * 2)/
                        (case when competencia2_B < 3 then 5 - competencia2_B else competencia2_B end * 1.0),1) as numeric (4,2)) +
            -- nota3 = 
                    cast(round(2 - (abs(competencia3_B - competencia3_A) * 2)/
                        (case when competencia3_B < 3 then 5 - competencia3_B else competencia3_B end * 1.0),1) as numeric (4,2)) +
            -- nota4 = 
                    cast(round(2 - (abs(competencia4_B - competencia4_A) * 2)/
                        (case when competencia4_B < 3 then 5 - competencia4_B else competencia4_B end * 1.0),1) as numeric (4,2)) +
            --nota5 = 
                    cast(round(2 - (abs(case competencia5_B when -1 then 0 else competencia5_B end  - case competencia5_a when -1 then 0 else competencia5_a end) * 2)/
                        (case when case competencia5_B when -1 then 0 else competencia5_B end < 3 then 5 - case competencia5_B when -1 then 0 else competencia5_B end else case competencia5_B when -1 then 0 else competencia5_B end end * 1.0),1) as numeric (4,2))

          from correcoes_analise ana 
         where id_tipo_correcao_A in(5) and 
               id =  @id_analise
    END 
ELSE 
    BEGIN
        IF(@SITUACAO_CORRETOR = @SITUACAO_GABARITO)
            BEGIN
                SET @retorno = 10
            END
        ELSE 
            BEGIN
                SET @retorno = 0
            END
    END

return (@retorno)
end

GO
/****** Object:  UserDefinedFunction [dbo].[fn_cor_corretor_redacao]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_cor_corretor_redacao](@co_barra_redacao VARCHAR(1000))
RETURNS VARCHAR(1000)
BEGIN
	DECLARE @RETORNO varchar(1000)
	declare @id_corretor int

	set @retorno = ''

declare abc cursor for
	select id_corretor from correcoes_correcao
	 where co_barra_redacao = @co_barra_redacao
	open abc
		fetch next from abc into @id_corretor
		while @@FETCH_STATUS = 0
			BEGIN

				set @retorno = @retorno + ',' + convert(varchar(20), @id_corretor) + ','

			fetch next from abc into @id_corretor
			END
	close abc
deallocate abc

return (@retorno)

END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_cor_corretor_redacao_por_id]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_cor_corretor_redacao_por_id](@redacao_id int)
RETURNS VARCHAR(1000)
BEGIN
	DECLARE @RETORNO varchar(1000)
	declare @id_corretor int

	set @retorno = ''

declare abc cursor for
	select id_corretor from correcoes_correcao
	 where redacao_id = @redacao_id
	open abc
		fetch next from abc into @id_corretor
		while @@FETCH_STATUS = 0
			BEGIN

				set @retorno = @retorno + ',' + convert(varchar(20), @id_corretor) + ','

			fetch next from abc into @id_corretor
			END
	close abc
deallocate abc

return (@retorno)

END

GO
/****** Object:  UserDefinedFunction [dbo].[fn_cor_monta_indice_hierarquia]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[fn_cor_monta_indice_hierarquia]
	(@id int)
RETURNS VARCHAR(1000)
BEGIN

declare	@indice varchar(1000)  
   

declare @id_pai int
set @id_pai = 1000

set @indice = '.' + convert(varchar(50),@id) + '.'
while (@id_pai > 0) 
	begin 
		select @id_pai = isnull(id_hierarquia_usuario_pai,0) from usuarios_hierarquia where id = @id
		if (@id_pai > 0 and 
		    @id_pai <> 1000) 
			begin 
				set @indice = '.' + convert(varchar(50),@id_pai) + @indice
				set @id = @id_pai
			end 
		else 
			begin 
				set @id_pai = 0
			end 
	end
	
return (@indice)

END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_duracao_correcao]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE function [dbo].[fn_duracao_correcao] (@id_correcao int)
returns int
begin
declare @segundos int 

select  @segundos = case WHEN DIFERENCA < 0 THEN 0 
                         when diferenca >= 1200 then 1200 else diferenca end  from (
select  id, data_inicio, data_termino , diferenca = datediff(second, data_inicio, data_termino)
from correcoes_correcao 
where id = @id_correcao) as tab 

	return @segundos/60.0

end
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CRIAÇÃO DE FUNÇÃO PARA RETORNAR A DATA EM DETERMINADO TIMEZONE
create   function [dbo].[getlocaldate]()
returns datetime2
as
begin
   return convert(datetime2, CONVERT(datetimeoffset, getdate()) AT TIME ZONE (select isnull(valor, valor_padrao) from core_parametros where nome = 'TIMEZONE_NAME'));
end

GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate2]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[getlocaldate2]()
returns datetime2
as
begin
--   return convert(datetime2, CONVERT(datetimeoffset, CURRENT_TIMESTAMP) AT TIME ZONE (select isnull(valor, valor_padrao) from core_parametros where nome = 'TIMEZONE_NAME'));
   return convert(datetime2, CONVERT(datetimeoffset, CURRENT_TIMESTAMP) AT TIME ZONE 'E. South America Standard Time');
end
GO
/****** Object:  UserDefinedFunction [dbo].[InlineMaxDatetime]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[InlineMaxDatetime](@val1 datetime2, @val2 datetime2)
returns datetime2
as
begin
  if @val1 > @val2
    return @val1
  return isnull(@val2,@val1)
end
GO
/****** Object:  UserDefinedFunction [dbo].[udfRetornaComandoSQL]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[udfRetornaComandoSQL](@spid AS INT)

RETURNS VARCHAR(8000)

AS

BEGIN

DECLARE @comandoSQL VARCHAR(8000)

SET @comandoSQL = (SELECT CAST([TEXT] AS VARCHAR(8000))

FROM ::fn_get_sql((SELECT [sql_handle] FROM sysprocesses where spid = @spid)))

RETURN @comandoSQL

END
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate_table]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[getlocaldate_table]()
returns table
as return (
  select top 1 convert(datetime2, CONVERT(datetimeoffset, getdate()) AT TIME ZONE (select isnull(valor, valor_padrao) as dt from core_parametros where nome = 'TIMEZONE_NAME')) as [datetime]
);
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate3]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[getlocaldate3]()
returns table
as return (
  select top 1 convert(datetime2, CONVERT(datetimeoffset, getdate()) AT TIME ZONE (select isnull(valor, valor_padrao) as dt from core_parametros where nome = 'TIMEZONE_NAME')) as dt
);
GO
/****** Object:  UserDefinedFunction [dbo].[u_emp]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[u_emp]
(   
    @enoNumber INT
)
RETURNS TABLE 
AS
RETURN 
(
    SELECT    
        * 
    FROM    
        sysobjects
)
GO
/****** Object:  UserDefinedFunction [dbo].[vwf_relatorios_responsabilidadeavaliador]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE   FUNCTION [dbo].[vwf_relatorios_responsabilidadeavaliador]
(
    @usuario INT, @data_inicio date, @data_fim date
)
RETURNS TABLE
AS
RETURN
(

with cte_primeira as (
        select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
                hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
                hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
                convert(int, ana3.aproveitamento) as aproveitamento,
                situacao_ava.sigla as avaliador_situacao, ana3.competencia1_A as avaliador_c1, ana3.competencia2_A as avaliador_c2,
                ana3.competencia3_A as avaliador_c3, ana3.competencia4_A as avaliador_c4, ana3.competencia5_A as avaliador_c5, case when ana3.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
                ana3.nota_final_A as avaliador_soma,
                situacao_espelho.sigla as espelho_situacao, cor_espelho.competencia1_A as espelho_c1, cor_espelho.competencia2_A as espelho_c2, cor_espelho.competencia3_A as espelho_c3, cor_espelho.competencia4_A as espelho_c4, cor_espelho.competencia5_A as espelho_c5, case when cor_espelho.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
                cor_espelho.nota_final_A as espelho_soma,
                situacao_terceiro.sigla as terceiro_situacao, ana3.competencia1_B as terceiro_c1, ana3.competencia2_B as terceiro_c2, ana3.competencia3_B as terceiro_c3, ana3.competencia4_B as terceiro_c4, ana3.competencia5_B as terceiro_c5, case when ana3.competencia5_B = -1 then 1 else 0 end as terceiro_is_ddh,
                ana3.nota_final_B as terceiro_soma,
                conc_ana3.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
           from correcoes_analise                         ana3              with(NoLock)
                inner join correcoes_correcao             cor               with(NoLock) on (cor.id = ana3.id_correcao_A)
                inner join vw_usuario_hierarquia_completa hie               with(NoLock) on (hie.usuario_id = cor.id_corretor)
                inner join usuarios_hierarquia            hie_usu           with(NoLock) on (hie_usu.id = hie.time_id)
                inner join correcoes_situacao             situacao_terceiro with(NoLock) on (situacao_terceiro.id = ana3.id_correcao_situacao_B)
                inner join correcoes_situacao             situacao_ava      with(NoLock) on (situacao_ava.id = ana3.id_correcao_situacao_A)
                inner join correcoes_conclusao_analise    conc_ana3         with(NoLock) on conc_ana3.id = ana3.conclusao_analise and ana3.id_tipo_correcao_B = 3
                inner join correcoes_redacao              red               with(NoLock) on (red.ID = cor.redacao_id)
                inner join correcoes_analise              cor_espelho       with(NoLock) on (cor_espelho.redacao_id = ana3.redacao_id and 
                                                                                             cor_espelho.id_tipo_correcao_A <> ana3.id_tipo_correcao_A and 
                                                                                             cor_espelho.id_tipo_correcao_B = 3)
                inner join correcoes_situacao             situacao_espelho  with(NoLock) on (situacao_espelho.id = cor_espelho.id_correcao_situacao_A)
    where  usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim 
),
    cte_segunda as (
        select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
        hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
        convert(int, ana2.aproveitamento) as aproveitamento,
       situacao_ava.sigla as avaliador_situacao, ana2.competencia1_A as avaliador_c1, ana2.competencia2_A as avaliador_c2,
       ana2.competencia3_A as avaliador_c3, ana2.competencia4_A as avaliador_c4, ana2.competencia5_A as avaliador_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
       ana2.nota_final_A as avaliador_soma,
       situacao_espelho.sigla as espelho_situacao, ana2.competencia1_B as espelho_c1, ana2.competencia2_B as espelho_c2, ana2.competencia3_B as espelho_c3, ana2.competencia4_B as espelho_c4, ana2.competencia5_B as espelho_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as espelho_is_ddh,
       ana2.nota_final_B as espelho_soma,
       NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
       NULL as terceiro_soma,
       conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(NoLock)
        inner join correcoes_correcao             cor              with(NoLock) on (cor.id = ana2.id_correcao_A)
        inner join vw_usuario_hierarquia_completa hie              with(NoLock) on (hie.usuario_id = cor.id_corretor)
        inner join usuarios_hierarquia            hie_usu          with(NoLock) on (hie_usu.id = hie.time_id)
        inner join correcoes_situacao             situacao_ava     with(NoLock) on (situacao_ava.id = ana2.id_correcao_situacao_A)
        inner join correcoes_situacao             situacao_espelho with(NoLock) on (situacao_espelho.id = ana2.id_correcao_situacao_B)
        inner join correcoes_conclusao_analise    conc_ana2        with(NoLock) on (conc_ana2.id = ana2.conclusao_analise and 
                                                                                    ana2.id_tipo_correcao_B = 2)
        inner join correcoes_redacao              red              with(NoLock) on (red.ID = cor.redacao_id)
  where usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim and 
        conc_ana2.discrepou = 1 and 
        not exists (select top 1 1 from correcoes_analise ana3 with(NoLock)  
                     where ana3.redacao_id = ana2.redacao_id and ana3.id_tipo_correcao_B = 3)
      
  ), 
    cte_terceira as (
        select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
        hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
        aproveitamento = null,
        situacao_ava.sigla as avaliador_situacao, ana2.competencia1_B as avaliador_c1, ana2.competencia2_B as avaliador_c2,
        ana2.competencia3_B as avaliador_c3, ana2.competencia4_B as avaliador_c4, ana2.competencia5_B as avaliador_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as avaliador_is_ddh,
        ana2.nota_final_B as avaliador_soma,
        situacao_espelho.sigla as espelho_situacao, ana2.competencia1_A as espelho_c1, ana2.competencia2_A as espelho_c2, ana2.competencia3_A as espelho_c3, ana2.competencia4_A as espelho_c4, ana2.competencia5_A as espelho_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
        ana2.nota_final_A as espelho_soma,
        NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
        NULL as terceiro_soma,
        conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise                         ana2             with(NoLock)
        inner join correcoes_correcao             cor              with(NoLock) on (cor.id = ana2.id_correcao_B)
        inner join vw_usuario_hierarquia_completa hie              with(NoLock) on (hie.usuario_id = cor.id_corretor)
        inner join usuarios_hierarquia            hie_usu          with(NoLock) on (hie_usu.id = hie.time_id)
        inner join correcoes_conclusao_analise    conc_ana2        with(NoLock) on (conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2)
        inner join correcoes_redacao              red              with(NoLock) on (red.ID = cor.redacao_id)
        inner join correcoes_situacao             situacao_ava     with(NoLock) on (situacao_ava.id = ana2.id_correcao_situacao_B)
        inner join correcoes_situacao             situacao_espelho with(NoLock) on (situacao_espelho.id = ana2.id_correcao_situacao_A)
  where usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim and 
        conc_ana2.discrepou = 1 and 
        not exists (select top 1 1 from correcoes_analise ana3 with(NoLock) 
                     where ana3.redacao_id = ana2.redacao_id and ana3.id_tipo_correcao_B = 3)
    )

     select * from cte_primeira
     union 
     select * from cte_segunda
     union 
     select * from cte_terceira
)

GO
/****** Object:  UserDefinedFunction [dbo].[vwf_relatorios_responsabilidadeavaliador_aux]    Script Date: 16/10/2019 10:23:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE   FUNCTION [dbo].[vwf_relatorios_responsabilidadeavaliador_aux]
(
    @usuario INT, @data_inicio date, @data_fim date
)
RETURNS TABLE
AS
RETURN
(

with cte_primeira as (
		select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
				hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
				hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
				convert(int, ana3.aproveitamento) as aproveitamento,
				situacao_ava.sigla as avaliador_situacao, ana3.competencia1_A as avaliador_c1, ana3.competencia2_A as avaliador_c2,
				ana3.competencia3_A as avaliador_c3, ana3.competencia4_A as avaliador_c4, ana3.competencia5_A as avaliador_c5, case when ana3.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
				ana3.nota_final_A as avaliador_soma,
				situacao_espelho.sigla as espelho_situacao, cor_espelho.competencia1_A as espelho_c1, cor_espelho.competencia2_A as espelho_c2, cor_espelho.competencia3_A as espelho_c3, cor_espelho.competencia4_A as espelho_c4, cor_espelho.competencia5_A as espelho_c5, case when cor_espelho.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
				cor_espelho.nota_final_A as espelho_soma,
				situacao_terceiro.sigla as terceiro_situacao, ana3.competencia1_B as terceiro_c1, ana3.competencia2_B as terceiro_c2, ana3.competencia3_B as terceiro_c3, ana3.competencia4_B as terceiro_c4, ana3.competencia5_B as terceiro_c5, case when ana3.competencia5_B = -1 then 1 else 0 end as terceiro_is_ddh,
				ana3.nota_final_B as terceiro_soma,
				conc_ana3.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
		   from correcoes_analise                         ana3              with(NoLock)
				inner join correcoes_correcao             cor               with(NoLock) on (cor.id = ana3.id_correcao_A)
				inner join vw_usuario_hierarquia_completa hie               with(NoLock) on (hie.usuario_id = cor.id_corretor)
				inner join usuarios_hierarquia            hie_usu           with(NoLock) on (hie_usu.id = hie.time_id)
				inner join correcoes_situacao             situacao_terceiro with(NoLock) on (situacao_terceiro.id = ana3.id_correcao_situacao_B)
				inner join correcoes_situacao             situacao_ava      with(NoLock) on (situacao_ava.id = ana3.id_correcao_situacao_A)
				inner join correcoes_conclusao_analise    conc_ana3         with(NoLock) on conc_ana3.id = ana3.conclusao_analise and ana3.id_tipo_correcao_B = 3
				inner join correcoes_redacao              red               with(NoLock) on (red.ID = cor.redacao_id)
				inner join correcoes_analise              cor_espelho       with(NoLock) on (cor_espelho.redacao_id = ana3.redacao_id and 
				                                                                             cor_espelho.id_tipo_correcao_A <> ana3.id_tipo_correcao_A and 
																							 cor_espelho.id_tipo_correcao_B = 3)
				inner join correcoes_situacao             situacao_espelho  with(NoLock) on (situacao_espelho.id = cor_espelho.id_correcao_situacao_A)
	where  usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim 
),
	cte_segunda as (
		select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
		convert(int, ana2.aproveitamento) as aproveitamento,
	   situacao_ava.sigla as avaliador_situacao, ana2.competencia1_A as avaliador_c1, ana2.competencia2_A as avaliador_c2,
	   ana2.competencia3_A as avaliador_c3, ana2.competencia4_A as avaliador_c4, ana2.competencia5_A as avaliador_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
	   ana2.nota_final_A as avaliador_soma,
	   situacao_espelho.sigla as espelho_situacao, ana2.competencia1_B as espelho_c1, ana2.competencia2_B as espelho_c2, ana2.competencia3_B as espelho_c3, ana2.competencia4_B as espelho_c4, ana2.competencia5_B as espelho_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as espelho_is_ddh,
	   ana2.nota_final_B as espelho_soma,
	   NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
	   NULL as terceiro_soma,
	   conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(NoLock)
	    inner join correcoes_correcao             cor              with(NoLock) on (cor.id = ana2.id_correcao_A)
		inner join vw_usuario_hierarquia_completa hie              with(NoLock) on (hie.usuario_id = cor.id_corretor)
		inner join usuarios_hierarquia            hie_usu          with(NoLock) on (hie_usu.id = hie.time_id)
        inner join correcoes_situacao             situacao_ava     with(NoLock) on (situacao_ava.id = ana2.id_correcao_situacao_A)
        inner join correcoes_situacao             situacao_espelho with(NoLock) on (situacao_espelho.id = ana2.id_correcao_situacao_B)
        inner join correcoes_conclusao_analise    conc_ana2        with(NoLock) on (conc_ana2.id = ana2.conclusao_analise and 
		                                                                            ana2.id_tipo_correcao_B = 2)
		inner join correcoes_redacao              red              with(NoLock) on (red.ID = cor.redacao_id)
  where usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim and 
        conc_ana2.discrepou = 1 and 
        not exists (select top 1 1 from correcoes_analise ana3 with(NoLock)  
		             where ana3.redacao_id = ana2.redacao_id and ana3.id_tipo_correcao_B = 3)
	  
  ), 
	cte_terceira as (
		select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
	    aproveitamento = null,
	    situacao_ava.sigla as avaliador_situacao, ana2.competencia1_B as avaliador_c1, ana2.competencia2_B as avaliador_c2,
	    ana2.competencia3_B as avaliador_c3, ana2.competencia4_B as avaliador_c4, ana2.competencia5_B as avaliador_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as avaliador_is_ddh,
	    ana2.nota_final_B as avaliador_soma,
	    situacao_espelho.sigla as espelho_situacao, ana2.competencia1_A as espelho_c1, ana2.competencia2_A as espelho_c2, ana2.competencia3_A as espelho_c3, ana2.competencia4_A as espelho_c4, ana2.competencia5_A as espelho_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
	    ana2.nota_final_A as espelho_soma,
	    NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
	    NULL as terceiro_soma,
	    conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise                         ana2             with(NoLock)
	    inner join correcoes_correcao             cor              with(NoLock) on (cor.id = ana2.id_correcao_B)
		inner join vw_usuario_hierarquia_completa hie              with(NoLock) on (hie.usuario_id = cor.id_corretor)
		inner join usuarios_hierarquia            hie_usu          with(NoLock) on (hie_usu.id = hie.time_id)
        inner join correcoes_conclusao_analise    conc_ana2        with(NoLock) on (conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2)
		inner join correcoes_redacao              red              with(NoLock) on (red.ID = cor.redacao_id)
        inner join correcoes_situacao             situacao_ava     with(NoLock) on (situacao_ava.id = ana2.id_correcao_situacao_B)
        inner join correcoes_situacao             situacao_espelho with(NoLock) on (situacao_espelho.id = ana2.id_correcao_situacao_A)
  where usuario_id = @usuario and cor.data_inicio between @data_inicio and @data_fim and 
        conc_ana2.discrepou = 1 and 
        not exists (select top 1 1 from correcoes_analise ana3 with(NoLock) 
		             where ana3.redacao_id = ana2.redacao_id and ana3.id_tipo_correcao_B = 3)
	)

     select * from cte_primeira
	 union 
	 select * from cte_segunda
	 union 
	 select * from cte_terceira
)



GO
