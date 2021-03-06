USE [correcao_regular]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_calcula_nota_desempenho_ouro_moda]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_calcula_nota_desempenho_ouro_moda]
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
/****** Object:  UserDefinedFunction [dbo].[fn_calcula_nota_desempenho_ouro_moda_preteste_enem]    Script Date: 23/11/2019 09:23:03 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fn_cor_corretor_redacao]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_cor_corretor_redacao](@co_barra_redacao VARCHAR(1000))
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
/****** Object:  UserDefinedFunction [dbo].[fn_cor_corretor_redacao_por_id]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     FUNCTION [dbo].[fn_cor_corretor_redacao_por_id](@redacao_id int)
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
/****** Object:  UserDefinedFunction [dbo].[fn_cor_monta_indice_hierarquia]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_cor_monta_indice_hierarquia]
    (@id int)
RETURNS VARCHAR(1000)
BEGIN

declare @indice varchar(1000)  
   

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
/****** Object:  UserDefinedFunction [dbo].[fn_duracao_correcao]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[fn_duracao_correcao] (@id_correcao int)
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
/****** Object:  UserDefinedFunction [dbo].[fu_time_number_to_text]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[fu_time_number_to_text] (@time decimal(10, 2)) 
returns varchar(50) as
begin
  declare @hour_part int
  declare @dec_part int

  if not @time is null begin

    set @hour_part = convert(int, @time)
    set @dec_part = convert(decimal(10, 2), (@time - @hour_part)) * 60

    return convert(varchar(10), @hour_part) + ':' + right('00' + convert(varchar(10), @dec_part), 2)
  end

  return null
end

GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate]    Script Date: 23/11/2019 09:23:03 ******/
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
/****** Object:  UserDefinedFunction [dbo].[getlocaldate2]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[getlocaldate2]()
returns datetime2
as
begin
--   return convert(datetime2, CONVERT(datetimeoffset, CURRENT_TIMESTAMP) AT TIME ZONE (select isnull(valor, valor_padrao) from core_parametros where nome = 'TIMEZONE_NAME'));
   return convert(datetime2, CONVERT(datetimeoffset, CURRENT_TIMESTAMP) AT TIME ZONE 'E. South America Standard Time');
end
GO
/****** Object:  UserDefinedFunction [dbo].[InlineMaxDatetime]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   function [dbo].[InlineMaxDatetime](@val1 datetime2, @val2 datetime2)
returns datetime2
as
begin
  if @val1 > @val2
    return @val1
  return isnull(@val2,@val1)
end

GO
/****** Object:  UserDefinedFunction [dbo].[udfContacts]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[udfContacts]()
    RETURNS @contacts TABLE (
        first_name VARCHAR(50)
    )
AS
BEGIN
    INSERT INTO @contacts
    SELECT 
        'artur'
 
    INSERT INTO @contacts
    SELECT 
        'Pedro'
 
    RETURN;
END;

GO
/****** Object:  UserDefinedFunction [dbo].[udfRetornaComandoSQL]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[udfRetornaComandoSQL](@spid AS INT)

RETURNS VARCHAR(8000)

AS

BEGIN

DECLARE @comandoSQL VARCHAR(8000)

SET @comandoSQL = (SELECT CAST([TEXT] AS VARCHAR(8000))

FROM ::fn_get_sql((SELECT [sql_handle] FROM sysprocesses where spid = @spid)))

RETURN @comandoSQL

END

GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate_table]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[getlocaldate_table]()
returns table
as return (
  select top 1 convert(datetime2, CONVERT(datetimeoffset, getdate()) AT TIME ZONE (select isnull(valor, valor_padrao) as dt from core_parametros where nome = 'TIMEZONE_NAME')) as [datetime]
);
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate3]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[getlocaldate3]()
returns table
as return (
  select top 1 convert(datetime2, CONVERT(datetimeoffset, getdate()) AT TIME ZONE (select isnull(valor, valor_padrao) as dt from core_parametros where nome = 'TIMEZONE_NAME')) as dt
);
GO
/****** Object:  UserDefinedFunction [dbo].[u_emp]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[u_emp]
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
/****** Object:  UserDefinedFunction [dbo].[vwf_relatorios_responsabilidadeavaliador]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    FUNCTION [dbo].[vwf_relatorios_responsabilidadeavaliador]
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
/****** Object:  UserDefinedFunction [dbo].[vwf_relatorios_responsabilidadeavaliador_aux]    Script Date: 23/11/2019 09:23:03 ******/
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
/****** Object:  UserDefinedFunction [dbo].[vwf_relatorios_responsabilidadeavaliador_auxvwf_relatorios_responsabilidadeavaliador_aux]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[vwf_relatorios_responsabilidadeavaliador_auxvwf_relatorios_responsabilidadeavaliador_aux]
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
/****** Object:  View [dbo].[correcoes_analise2019]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[correcoes_analise2019] as select * from correcoes_analise

GO
/****** Object:  View [dbo].[correcoes_analise2019_back]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[correcoes_analise2019_back] as select * from correcoes_analise where id_corretor_A in (select user_id from usuarios_hierarquia_usuarios where hierarquia_id > 400) or id_correcao_B in (select user_id from usuarios_hierarquia_usuarios where id > 400)

GO
/****** Object:  View [dbo].[correcoes_correcao2019]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[correcoes_correcao2019] as select * from correcoes_correcao

GO
/****** Object:  View [dbo].[correcoes_correcao2019_back]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[correcoes_correcao2019_back] as select * from correcoes_correcao where id_corretor in (select user_id from usuarios_hierarquia_usuarios where hierarquia_id > 400)

GO
/****** Object:  View [dbo].[correcoes_redacao2019]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[correcoes_redacao2019] as
select * from correcoes_redacao

GO
/****** Object:  View [dbo].[correcoes_redacao2019_back]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[correcoes_redacao2019_back] as
select * from correcoes_redacao where co_barra_redacao like '%EVT%' or link_imagem_recortada like '%evento_teste2%'
union
select * from correcoes_redacao red where exists (select top 1 1 from correcoes_correcao corr join auth_user us on us.id = corr.id_corretor where red.id = corr.redacao_id and us.username in (
'02801198528',
'05075837522',
'03918462560',
'99311925500',
'50934015520',
'79357652515'
))

GO
/****** Object:  View [dbo].[relatorios_responsabilidadeavaliador]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE     VIEW [dbo].[relatorios_responsabilidadeavaliador] as

 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel, 
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data, 
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario, 

		convert(int, ana3.aproveitamento) as aproveitamento,

	    ana3.id_correcao_situacao_A as avaliador_situacao, ana3.competencia1_A as avaliador_c1, ana3.competencia2_A as avaliador_c2, 
	    ana3.competencia3_A as avaliador_c3, ana3.competencia4_A as avaliador_c4, ana3.competencia5_A as avaliador_c5, case when ana3.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh, 
	    ana3.nota_final_A as avaliador_soma,
	    cor_espelho.id_correcao_situacao_A as espelho_situacao, cor_espelho.competencia1_A as espelho_c1, cor_espelho.competencia2_A as espelho_c2, cor_espelho.competencia3_A as espelho_c3, cor_espelho.competencia4_A as espelho_c4, cor_espelho.competencia5_A as espelho_c5, case when cor_espelho.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh, 
	    cor_espelho.nota_final_A as espelho_soma,
	    ana3.id_correcao_situacao_B as terceiro_situacao, ana3.competencia1_B as terceiro_c1, ana3.competencia2_B as terceiro_c2, ana3.competencia3_B as terceiro_c3, ana3.competencia4_B as terceiro_c4, ana3.competencia5_B as terceiro_c5, case when ana3.competencia5_B = -1 then 1 else 0 end as terceiro_is_ddh,
	    ana3.nota_final_B as terceiro_soma,
	    conc_ana3.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana3 with(NoLock)
        inner join correcoes_conclusao_analise conc_ana3 with(NoLock) on conc_ana3.id = ana3.conclusao_analise and ana3.id_tipo_correcao_B = 3
	    inner join correcoes_correcao cor with(NoLock) on cor.id = ana3.id_correcao_A
		inner join correcoes_redacao red with(NoLock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(NoLock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(NoLock) on hie_usu.id = hie.time_id
		inner join correcoes_analise cor_espelho with(NoLock) on cor_espelho.co_barra_redacao = ana3.co_barra_redacao and cor_espelho.id_tipo_correcao_A <> ana3.id_tipo_correcao_A and cor_espelho.id_tipo_correcao_B = 3
		left outer join correcoes_filaauditoria aud with(NoLock) on (aud.co_barra_redacao = red.co_barra_redacao)
	    left outer join correcoes_correcao corQua with(NoLock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
	    left outer join correcoes_correcao corAud with(NoLock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
	    left outer join correcoes_fila3 fil3 with(NoLock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
	    left outer join correcoes_fila4 fil4 with(NoLock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4 
	    left outer join correcoes_filaauditoria filaud with(NoLock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
union all
 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel, 
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data, 
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario, 

		convert(int, ana2.aproveitamento) as aproveitamento,

	   ana2.id_correcao_situacao_A as avaliador_situacao, ana2.competencia1_A as avaliador_c1, ana2.competencia2_A as avaliador_c2, 
	   ana2.competencia3_A as avaliador_c3, ana2.competencia4_A as avaliador_c4, ana2.competencia5_A as avaliador_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh, 
	   ana2.nota_final_A as avaliador_soma,
	   ana2.id_correcao_situacao_B as espelho_situacao, ana2.competencia1_B as espelho_c1, ana2.competencia2_B as espelho_c2, ana2.competencia3_B as espelho_c3, ana2.competencia4_B as espelho_c4, ana2.competencia5_B as espelho_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as espelho_is_ddh, 
	   ana2.nota_final_B as espelho_soma,
	   NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
	   NULL as terceiro_soma,
	   conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(NoLock) 
        inner join correcoes_conclusao_analise conc_ana2 with(NoLock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
	    inner join correcoes_correcao cor with(NoLock) on cor.id = ana2.id_correcao_A
		inner join correcoes_redacao red with(NoLock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(NoLock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(NoLock) on hie_usu.id = hie.time_id
		left outer join correcoes_filaauditoria aud with(NoLock) on (aud.co_barra_redacao = red.co_barra_redacao)
	    left outer join correcoes_correcao corQua with(NoLock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
	    left outer join correcoes_correcao corAud with(NoLock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
	    left outer join correcoes_fila3 fil3 with(NoLock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
	    left outer join correcoes_fila4 fil4 with(NoLock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4 
	    left outer join correcoes_filaauditoria filaud with(NoLock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise ana3 with(NoLock)  where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)

union all

 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel, 
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data, 
	    hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario, 
	    aproveitamento = null,
	   
	    ana2.id_correcao_situacao_B as avaliador_situacao, ana2.competencia1_B as avaliador_c1, ana2.competencia2_B as avaliador_c2, 
	    ana2.competencia3_B as avaliador_c3, ana2.competencia4_B as avaliador_c4, ana2.competencia5_B as avaliador_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as avaliador_is_ddh, 
	    ana2.nota_final_B as avaliador_soma,
	    ana2.id_correcao_situacao_A as espelho_situacao, ana2.competencia1_A as espelho_c1, ana2.competencia2_A as espelho_c2, ana2.competencia3_A as espelho_c3, ana2.competencia4_A as espelho_c4, ana2.competencia5_A as espelho_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh, 
	    ana2.nota_final_A as espelho_soma,
	    NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
	    NULL as terceiro_soma,
	    conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(NoLock)
        inner join correcoes_conclusao_analise conc_ana2 with(NoLock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
	    inner join correcoes_correcao cor with(NoLock) on cor.id = ana2.id_correcao_B
		inner join correcoes_redacao red with(NoLock) on red.co_barra_redacao = cor.co_barra_redacao
		inner join vw_usuario_hierarquia_completa hie with(NoLock) on hie.usuario_id = cor.id_corretor
		inner join usuarios_hierarquia hie_usu with(NoLock) on hie_usu.id = hie.time_id
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise ana3 with(NoLock) where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)



GO
/****** Object:  View [dbo].[relatorios_responsabilidadeavaliadorcomdata]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[relatorios_responsabilidadeavaliadorcomdata] as
 select red.id as id_redacao, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
        cor.id as id_correcao,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
        hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,

        convert(int, ana3.aproveitamento) as aproveitamento,

        ana3.id_correcao_situacao_A as avaliador_situacao, ana3.competencia1_A as avaliador_c1, ana3.competencia2_A as avaliador_c2,
        ana3.competencia3_A as avaliador_c3, ana3.competencia4_A as avaliador_c4, ana3.competencia5_A as avaliador_c5, case when ana3.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
        ana3.nota_final_A as avaliador_soma,
        cor_espelho.id_correcao_situacao_A as espelho_situacao, cor_espelho.competencia1_A as espelho_c1, cor_espelho.competencia2_A as espelho_c2, cor_espelho.competencia3_A as espelho_c3, cor_espelho.competencia4_A as espelho_c4, cor_espelho.competencia5_A as espelho_c5, case when cor_espelho.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
        cor_espelho.nota_final_A as espelho_soma, cor_espelho.data_termino_A as espelho_data,
        ana3.id_correcao_situacao_B as terceiro_situacao, ana3.competencia1_B as terceiro_c1, ana3.competencia2_B as terceiro_c2, ana3.competencia3_B as terceiro_c3, ana3.competencia4_B as terceiro_c4, ana3.competencia5_B as terceiro_c5, case when ana3.competencia5_B = -1 then 1 else 0 end as terceiro_is_ddh,
        ana3.nota_final_B as terceiro_soma, ana3.data_termino_b as terceiro_data,
        conc_ana3.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana3 with(nolock)
        inner join correcoes_conclusao_analise conc_ana3 with(nolock) on conc_ana3.id = ana3.conclusao_analise and ana3.id_tipo_correcao_B = 3
        inner join correcoes_correcao cor with(nolock) on cor.id = ana3.id_correcao_A
        inner join correcoes_redacao red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
        inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
        inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
        inner join correcoes_analise cor_espelho with(nolock) on cor_espelho.co_barra_redacao = ana3.co_barra_redacao and cor_espelho.id_tipo_correcao_A <> ana3.id_tipo_correcao_A and cor_espelho.id_tipo_correcao_B = 3
        left outer join correcoes_filaauditoria aud with(nolock) on (aud.co_barra_redacao = red.co_barra_redacao)
        left outer join correcoes_correcao corQua with(nolock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
        left outer join correcoes_correcao corAud with(nolock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
        left outer join correcoes_fila3 fil3 with(nolock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
        left outer join correcoes_fila4 fil4 with(nolock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4
        left outer join correcoes_filaauditoria filaud with(nolock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
union all
 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
 cor.id as id_correcao,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
        hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,

        convert(int, ana2.aproveitamento) as aproveitamento,

       ana2.id_correcao_situacao_A as avaliador_situacao, ana2.competencia1_A as avaliador_c1, ana2.competencia2_A as avaliador_c2,
       ana2.competencia3_A as avaliador_c3, ana2.competencia4_A as avaliador_c4, ana2.competencia5_A as avaliador_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as avaliador_is_ddh,
       ana2.nota_final_A as avaliador_soma,
       ana2.id_correcao_situacao_B as espelho_situacao, ana2.competencia1_B as espelho_c1, ana2.competencia2_B as espelho_c2, ana2.competencia3_B as espelho_c3, ana2.competencia4_B as espelho_c4, ana2.competencia5_B as espelho_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as espelho_is_ddh,
       ana2.nota_final_B as espelho_soma, ana2.data_termino_B as espelho_data,
       NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
       NULL as terceiro_soma, NULL as terceiro_data,
       conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(nolock)
        inner join correcoes_conclusao_analise conc_ana2 with(nolock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
        inner join correcoes_correcao cor with(nolock) on cor.id = ana2.id_correcao_A
        inner join correcoes_redacao red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
        inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
        inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
        left outer join correcoes_filaauditoria aud with(nolock) on (aud.co_barra_redacao = red.co_barra_redacao)
        left outer join correcoes_correcao corQua with(nolock) on (corQua.co_barra_redacao = red.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
        left outer join correcoes_correcao corAud with(nolock) on (corAud.co_barra_redacao = red.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
        left outer join correcoes_fila3 fil3 with(nolock) on (fil3.co_barra_redacao = red.co_barra_redacao)  -- fila 3
        left outer join correcoes_fila4 fil4 with(nolock) on (fil4.co_barra_redacao = red.co_barra_redacao) -- fila 4
        left outer join correcoes_filaauditoria filaud with(nolock) on (filaud.co_barra_redacao = red.co_barra_redacao) -- fila auditoria
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise ana3 with(nolock) where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)

union all

 select red.id as id, hie.time_id as id_hierarquia, hie_usu.id_usuario_responsavel,
 cor.id as id_correcao,
        hie.usuario_id as id_corretor, hie.nome as corretor, red.id as redacao, cor.data_termino as data,
        hie.time_indice as indice, hie.usuario_id, hie.nome, hie_usu.id_hierarquia_usuario_pai, hie_usu.id_tipo_hierarquia_usuario,
        aproveitamento = null,
        ana2.id_correcao_situacao_B as avaliador_situacao, ana2.competencia1_B as avaliador_c1, ana2.competencia2_B as avaliador_c2,
        ana2.competencia3_B as avaliador_c3, ana2.competencia4_B as avaliador_c4, ana2.competencia5_B as avaliador_c5, case when ana2.competencia5_B = -1 then 1 else 0 end as avaliador_is_ddh,
        ana2.nota_final_B as avaliador_soma,
        ana2.id_correcao_situacao_A as espelho_situacao, ana2.competencia1_A as espelho_c1, ana2.competencia2_A as espelho_c2, ana2.competencia3_A as espelho_c3, ana2.competencia4_A as espelho_c4, ana2.competencia5_A as espelho_c5, case when ana2.competencia5_A = -1 then 1 else 0 end as espelho_is_ddh,
        ana2.nota_final_A as espelho_soma, ana2.data_termino_A as data,
        NULL as terceiro_situacao, NULL as terceiro_c1, NULL as terceiro_c2, NULL as terceiro_c3, NULL as terceiro_c4, NULL as terceiro_c5, case when NULL = -1 then 1 else 0 end as terceiro_is_ddh,
        NULL as terceiro_soma, NULL as terceiro_data,
        conc_ana2.discrepou, 1 as flg_dado_atual, null as total_correcoes_time, cor.id_projeto
   from correcoes_analise ana2 with(nolock)
        inner join correcoes_conclusao_analise conc_ana2 with(nolock) on conc_ana2.id = ana2.conclusao_analise and ana2.id_tipo_correcao_B = 2
        inner join correcoes_correcao cor with(nolock) on cor.id = ana2.id_correcao_B
        inner join correcoes_redacao red with(nolock) on red.co_barra_redacao = cor.co_barra_redacao
        inner join vw_usuario_hierarquia_completa hie with(nolock) on hie.usuario_id = cor.id_corretor
        inner join usuarios_hierarquia hie_usu with(nolock) on hie_usu.id = hie.time_id
  where conc_ana2.discrepou = 1 and not exists (select top 1 1 from correcoes_analise ana3 with(nolock) where co_barra_redacao = ana2.co_barra_redacao and ana3.id_tipo_correcao_B = 3)

GO
/****** Object:  View [dbo].[vw_analise_terceira_finalizadas]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                       [VW_ANALISE_TERCEIRA_FINALIZADAS]                                        *
*                                                                                                                *
*  VIEW QUE AGRUPA INFORMACOES SOBRE UMA CORRECAO QUE POSSUI TERCEIRA CORRECAO E NAO POSSUI CORRECOES NA FILA4,  *
* FILAAUDITORIA, FILAPESSOAL E TAMBEM NAS CORRECOES COM TIPO AUDITORIA E TIPO 4                                  *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/
CREATE   view [dbo].[vw_analise_terceira_finalizadas] as 
SELECT RED.ID, RED.id_projeto, red.nota_final as nota_final_red, red.id_correcao_situacao as id_redacao_situacao_red, 
       COR1.ID_CORRECAO_SITUACAO AS SITUACAO1, COR2.ID_CORRECAO_SITUACAO AS SITUACAO2, COR3.ID_CORRECAO_SITUACAO AS SITUACAO3, 
       COR1.id AS CORRECAO1_ID, COR2.id AS CORRECAO2_ID, COR3.id AS CORRECAO3_ID, 
       ANA13.conclusao_analise as conclusao_analise13, ANA23.conclusao_analise as conclusao_analise23, 	   
	   
	   COR1.NOTA_FINAL as nota_final_cor1, COR1.ID_CORRECAO_SITUACAO as situacao_cor1, COR1.competencia1 as comp11, COR1.competencia2 as comp12, COR1.competencia3 as comp13, COR1.competencia4 as comp14, COR1.competencia5 as comp15,
	   COR2.NOTA_FINAL as nota_final_cor2, COR2.ID_CORRECAO_SITUACAO as situacao_cor2, COR2.competencia1 as comp21, COR2.competencia2 as comp22, COR2.competencia3 as comp23, COR2.competencia4 as comp24, COR2.competencia5 as comp25,
	   COR3.NOTA_FINAL as nota_final_cor3, COR3.ID_CORRECAO_SITUACAO as situacao_cor3, COR3.competencia1 as comp31, COR3.competencia2 as comp32, COR3.competencia3 as comp33, COR3.competencia4 as comp34, COR3.competencia5 as comp35,

	   COR1.nota_competencia1 AS nota_COMP11, COR1.nota_competencia2 AS nota_COMP12, COR1.nota_competencia3 AS nota_COMP13, COR1.nota_competencia4 AS nota_COMP14, COR1.nota_COMPETENCIA5 AS nota_COMP15,
	   COR2.nota_competencia1 AS nota_COMP21, COR2.nota_competencia2 AS nota_COMP22, COR2.nota_competencia3 AS nota_COMP23, COR2.nota_competencia4 AS nota_COMP24, COR1.nota_COMPETENCIA5 AS nota_COMP25,
	   COR3.nota_competencia1 AS nota_COMP31, COR3.nota_competencia2 AS nota_COMP32, COR3.nota_competencia3 AS nota_COMP33, COR3.nota_competencia4 AS nota_COMP34, COR1.nota_COMPETENCIA5 AS nota_COMP35,

	   SOBERANA3 = CRT.flag_soberano 
  FROM CORRECOES_REDACAO RED JOIN correcoes_correcao COR1  ON (RED.ID = COR1.redacao_id AND RED.id_projeto = COR1.id_projeto AND COR1.ID_TIPO_CORRECAO = 1)
                             JOIN correcoes_correcao COR2  ON (RED.ID = COR2.redacao_id AND RED.id_projeto = COR2.id_projeto AND COR2.ID_TIPO_CORRECAO = 2)
							 JOIN correcoes_correcao COR3  ON (RED.ID = COR3.redacao_id AND RED.id_projeto = COR3.id_projeto AND COR3.ID_TIPO_CORRECAO = 3)
							 JOIN CORRECOES_TIPO     CRT   ON (CRT.id = COR3.id_tipo_correcao)
							 JOIN correcoes_analise  ANA13 ON (RED.id = ANA13.REDACAO_ID AND ANA13.id_correcao_A = COR1.ID AND ANA13.ID_CORRECAO_B = COR3.ID)
							 JOIN correcoes_analise  ANA23 ON (RED.ID = ANA23.REDACAO_ID AND ANA23.id_correcao_A = COR2.ID AND ANA23.ID_CORRECAO_B = COR3.ID)
						LEFT JOIN correcoes_correcao COR4  ON (RED.ID = COR4.redacao_id AND RED.id_projeto = COR4.id_projeto AND COR4.ID_TIPO_CORRECAO = 4)
						LEFT JOIN correcoes_correcao COR5  ON (RED.ID = COR5.redacao_id AND RED.id_projeto = COR5.id_projeto AND COR5.ID_TIPO_CORRECAO = 7)
						LEFT JOIN VW_FILAS_DA_REDACAO FILS ON (RED.ID = FILS.REDACAO_ID AND RED.id_projeto = FILS.ID_PROJETO)
WHERE COR4.id IS NULL AND  
      COR5.id IS NULL AND 
	  ISNULL(FILS.REDACAO_ID,0) <> 0
GO
/****** Object:  View [dbo].[vw_aproveitamento_notas_time]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_aproveitamento_notas_time] as
select
    polo.id as polo_id,
    polo.descricao as polo_descricao,
    time.id as time_id,
    time.descricao as time_descricao,
    time.indice as indice,
    p.nome as avaliador,
    ultima_correcao,
    isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor) usuario_id,
    isnull(discrepantes.data, total_correcoes_1a_2a.data) data,
    isnull(total_correcoes_1a_2a.nr_corrigidas, 0 ) nr_corrigidas,
    isnull(nr_aproveitadas, 0) nr_aproveitadas,
    isnull(nr_nao_aproveitadas, 0) nr_nao_aproveitadas,
    isnull(nr_discrepantes, 0) nr_discrepantes
from (
    select
        id_corretor,
        cast(data as date) data,
        count(1) nr_discrepantes,
        sum(case when aproveitamento = 1 then 1 else 0 end) as nr_aproveitadas,
        sum(case when (aproveitamento = 0 or aproveitamento is null) and terceiro_situacao is not null then 1 else 0 end) as nr_nao_aproveitadas
    from  relatorios_responsabilidadeavaliadorcomdata
    group by id_corretor, cast(data as date)
) discrepantes
right join (
    select
        id_corretor,
        cast(data_termino as date) [data],
        COUNT(1) nr_corrigidas,
        MAX(data_termino) as ultima_correcao
    from correcoes_correcao
    where data_termino is not null and id_tipo_correcao in (1, 2)
    GROUP by id_corretor, cast(data_termino as date)
) total_correcoes_1a_2a on total_correcoes_1a_2a.id_corretor = discrepantes.id_corretor
    and discrepantes.data = total_correcoes_1a_2a.[data]
inner join dbo.usuarios_pessoa p on p.usuario_id = isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor)
inner join dbo.usuarios_hierarquia_usuarios b on b.user_id = isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor)
inner join dbo.usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
inner join dbo.usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
inner join dbo.usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
inner join dbo.usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai

GO
/****** Object:  View [dbo].[vw_avaliadores]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_avaliadores] as
select 
       a.geral_descricao as geral,
       a.fgv_descricao as fgv,
       a.polo_descricao as polo,
       a.time_descricao as time, 
       a.indice,
       b.cpf,
       b.email,
       b.telefone_celular,
       b.municipio,
       b.dddtelefone_celular,
       b.uf,
       b.nome,
       f.id_usuario_responsavel,
       f.descricao as hierarquia,
       b.usuario_id as id,
       b.cep,
       b.bairro,
       b.complemento,
       b.dddtelefone_residencial,
       b.logradouro,
       b.numero,
       b.telefone_residencial,
       a.time_id as hierarquia_id,
       c.max_correcoes_dia,
       c.status_id,
       e.id as group_id,
       e.name as group_name,
       c.pode_corrigir_1,
       c.pode_corrigir_2,
       c.pode_corrigir_3,
        (( CASE WHEN c.pode_corrigir_1 = 1
                        AND (c.pode_corrigir_2 = 1
                            OR c.pode_corrigir_3 = 1) THEN
                        '1ª, '
                        WHEN c.pode_corrigir_1 = 1 THEN
                        '1ª'
                    ELSE
                        ''
        END) + ( CASE WHEN c.pode_corrigir_2 = 1
                AND c.pode_corrigir_3 = 1 THEN
                '2ª, '
                WHEN c.pode_corrigir_2 = 1 THEN
                '2ª'
            ELSE
                ''
        END) + ( CASE WHEN c.pode_corrigir_3 = 1 THEN
                '3ª'
            ELSE
                ''
        END)) AS tipo_correcao,
        count(g.data_termino) as total_correcoes,
        (SELECT
            COUNT(j.id)
        FROM
            dbo.correcoes_suspensao j
        WHERE (j.id_corretor = c.id)) AS total_suspensoes,
        h.max_correcoes_dia as projeto_max_correcoes_dia,
        h.id AS projeto_id

  from vw_usuarios_hierarquia_para_vw_avaliadores a
       inner join usuarios_pessoa b on b.usuario_id = a.usuario_id
       inner join correcoes_corretor c on c.id = a.usuario_id
       inner join auth_user_groups d on c.id = d.user_id
       inner join auth_group e on e.id = d.group_id
       left outer join usuarios_hierarquia f on f.id = a.time_id
       left outer join projeto_projeto_usuarios i on i.user_id = c.id
       left outer join projeto_projeto h on h.id = i.projeto_id
       left outer join correcoes_correcao g on g.id_corretor = c.id
group by
       a.geral_descricao,
       a.fgv_descricao,
       a.polo_descricao,
       a.time_descricao, 
       a.indice,
       b.cpf,
       b.email,
       b.telefone_celular,
       b.municipio,
       b.dddtelefone_celular,
       b.uf,
       b.nome,
       f.id_usuario_responsavel,
       f.descricao,
       b.usuario_id,
       b.cep,
       b.bairro,
       b.complemento,
       b.dddtelefone_residencial,
       b.logradouro,
       b.numero,
       b.telefone_residencial,
       a.time_id,
       c.max_correcoes_dia,
       c.status_id,
       e.id,
       e.name,
       c.pode_corrigir_1,
       c.pode_corrigir_2,
       c.pode_corrigir_3,
       c.id,
       h.max_correcoes_dia,
       h.id

GO
/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_2]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_2] as
select red.id, red.co_barra_redacao, red.id_projeto, cor1.id_corretor as id_corretor1, cor2.id_corretor as id_corretor2, cor1.id as correcao1, cor2.id as correcao2,
       cor1.id_correcao_situacao as situacao1, cor2.id_correcao_situacao as situacao2,
       abs(cor1.nota_final - cor2.nota_final) as notaTotal,
       abs(cor1.nota_competencia1 - cor2.nota_competencia1) as competencia1,
       abs(cor1.nota_competencia2 - cor2.nota_competencia2) as competencia2,
       abs(cor1.nota_competencia3 - cor2.nota_competencia3) as competencia3,
       abs(cor1.nota_competencia4 - cor2.nota_competencia4) as competencia4,
       abs(cor1.nota_competencia5 - cor2.nota_competencia5) as competencia5,
       case when abs(isnull(cor1.id_correcao_situacao, 0) - isnull(cor2.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor1 on cor1.redacao_id = red.id and cor1.id_tipo_correcao = 1 and cor1.id_status = 3
       inner join correcoes_correcao cor2 on cor2.redacao_id = red.id and cor2.id_tipo_correcao = 2 and cor2.id_status = 3
 where red.id_redacaoouro is null


GO
/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_3]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_1_3] as
select red.id, red.co_barra_redacao, red.id_projeto, cor1.id_corretor as id_corretor1, cor3.id_corretor as id_corretor2, cor1.id as correcao1, cor3.id as correcao2,
       cor1.id_correcao_situacao as situacao1, cor3.id_correcao_situacao as situacao2,
       abs(cor1.nota_final -   cor3.nota_final) as notaTotal,
       abs(cor1.nota_competencia1 - cor3.nota_competencia1) as competencia1,
       abs(cor1.nota_competencia2 - cor3.nota_competencia2) as competencia2,
       abs(cor1.nota_competencia3 - cor3.nota_competencia3) as competencia3,
       abs(cor1.nota_competencia4 - cor3.nota_competencia4) as competencia4,
       abs(cor1.nota_competencia5 - cor3.nota_competencia5) as competencia5,
       case when abs(isnull(cor1.id_correcao_situacao, 0) - isnull(cor3.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor1 on cor1.redacao_id = red.id and cor1.id_tipo_correcao = 1 and cor1.id_status = 3
       inner join correcoes_correcao cor3 on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
 where red.id_redacaoouro is null


GO
/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_2_3]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_2_3] as
select red.id, red.co_barra_redacao, red.id_projeto, cor2.id_corretor as id_corretor1, cor3.id_corretor as id_corretor2, cor2.id as correcao1, cor3.id as correcao2,
       cor2.id_correcao_situacao as situacao1, cor3.id_correcao_situacao as situacao2,
       abs(cor2.nota_final -   cor3.nota_final) as notaTotal,
       abs(cor2.nota_competencia1 - cor3.nota_competencia1) as competencia1,
       abs(cor2.nota_competencia2 - cor3.nota_competencia2) as competencia2,
       abs(cor2.nota_competencia3 - cor3.nota_competencia3) as competencia3,
       abs(cor2.nota_competencia4 - cor3.nota_competencia4) as competencia4,
       abs(cor2.nota_competencia5 - cor3.nota_competencia5) as competencia5,
       case when abs(isnull(cor2.id_correcao_situacao, 0) - isnull(cor3.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor2 on cor2.redacao_id = red.id and cor2.id_tipo_correcao = 2 and cor2.id_status = 3
       inner join correcoes_correcao cor3 on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
 where red.id_redacaoouro is null


GO
/****** Object:  View [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_3_4]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_cor_avalia_discrepancia_divergencia_correcao_3_4] as
select red.id, red.co_barra_redacao, red.id_projeto, cor3.id_corretor as id_corretor1, cor4.id_corretor as id_corretor2, cor3.id as correcao1, cor4.id as correcao2,
       cor3.id_correcao_situacao as situacao1, cor4.id_correcao_situacao as situacao2,
       abs(cor3.nota_final -   cor4.nota_final) as notaTotal,
       abs(cor3.competencia1 - cor4.competencia1) as competencia1,
       abs(cor3.competencia2 - cor4.competencia2) as competencia2,
       abs(cor3.competencia3 - cor4.competencia3) as competencia3,
       abs(cor3.competencia4 - cor4.competencia4) as competencia4,
       abs(cor3.competencia5 - cor4.competencia5) as competencia5,
       case when abs(isnull(cor3.id_correcao_situacao, 0) - isnull(cor4.id_correcao_situacao, 0)) > 0 then 'SIM' else 'NÃO' end as divergenciaSituacao
  from correcoes_redacao red
       inner join correcoes_correcao cor3 on cor3.redacao_id = red.id and cor3.id_tipo_correcao = 3 and cor3.id_status = 3
       inner join correcoes_correcao cor4 on cor4.redacao_id = red.id and cor4.id_tipo_correcao = 4 and cor4.id_status = 3
 where red.id_redacaoouro is null


GO
/****** Object:  View [dbo].[vw_cor_batimento_gabarito]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_cor_batimento_gabarito] as

select cor.co_barra_redacao,
       cor.redacao_id,
       cor.id_projeto,
       cor.id_corretor,
       cor.id as id_correcao,
       cor.link_imagem_recortada,
       cor.link_imagem_original,
       cor.data_inicio as data_inicio_correcao,
       cor.data_termino as data_termino_correcao,
       cor.nota_final as nota_final_correcao,
       cor.id_auxiliar1,
       cor.id_auxiliar2,
       cor.id_status,
       cor.id_tipo_correcao,
       cor.competencia1 as id_competencia1_correcao,
       cor.competencia2 as id_competencia2_correcao,
       cor.competencia3 as id_competencia3_correcao,
       cor.competencia4 as id_competencia4_correcao,
       cor.competencia5 as id_competencia5_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia1 end as nota_competencia1_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia2 end as nota_competencia2_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia3 end as nota_competencia3_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia4 end as nota_competencia4_correcao,
       case when cor.id_correcao_situacao <> 1 then null else cor.nota_competencia5 end as nota_competencia5_correcao,
       cor.id_correcao_situacao as id_correcao_situacao_correcao,
       gab.nota_final as nota_final_gabarito,
       gab.id_competencia1 as id_competencia1_gabarito,
       gab.id_competencia2 as id_competencia2_gabarito,
       gab.id_competencia3 as id_competencia3_gabarito,
       gab.id_competencia4 as id_competencia4_gabarito,
       gab.id_competencia5 as id_competencia5_gabarito,
       gab.nota_competencia1 as nota_competencia1_gabarito,
       gab.nota_competencia2 as nota_competencia2_gabarito,
       gab.nota_competencia3 as nota_competencia3_gabarito,
       gab.nota_competencia4 as nota_competencia4_gabarito,
       gab.nota_competencia5 as nota_competencia5_gabarito,
       gab.id_correcao_situacao as id_correcao_situacao_gabarito,
       abs(isnull(cor.nota_final, 0) - isnull(gab.nota_final, 0)) as nota_final_diferenca,
       abs(isnull(cor.nota_competencia1, 0) - isnull(gab.nota_competencia1, 0)) as competencia1_diferenca,
       abs(isnull(cor.nota_competencia2, 0) - isnull(gab.nota_competencia2, 0)) as competencia2_diferenca,
       abs(isnull(cor.nota_competencia3, 0) - isnull(gab.nota_competencia3, 0)) as competencia3_diferenca,
       abs(isnull(cor.nota_competencia4, 0) - isnull(gab.nota_competencia4, 0)) as competencia4_diferenca,
       abs(isnull(cor.nota_competencia5, 0) - isnull(gab.nota_competencia5, 0)) as competencia5_diferenca,
       case when cor.id_correcao_situacao <> gab.id_correcao_situacao then 'SIM' else 'NAO' end as divergencia_situacao
from correcoes_correcao cor with(nolock)
     join correcoes_gabarito gab with(nolock) on cor.redacao_id = gab.redacao_id
where cor.id_status = 3

GO
/****** Object:  View [dbo].[vw_cor_usuario_grupo]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_cor_usuario_grupo] as
select id_usuario = usr.id, usr.first_name, usr.last_name, usr.is_superuser, ugr.group_id,  
       grupo = gro.name, cor.max_correcoes_dia, grupo_corretor = cor.id_grupo ,  
    cor.pode_corrigir_1, cor.pode_corrigir_2, cor.pode_corrigir_3, cor.pode_corrigir_4, cor.status_id  
  from auth_user usr join auth_user_groups ugr on (ugr.user_id = usr.id)  
                     join auth_group       gro on (gro.id = ugr.group_id)  
      join correcoes_corretor cor on (cor.id = usr.id);  

GO
/****** Object:  View [dbo].[vw_correcao_correcoes]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_correcao_correcoes]
AS
SELECT        TOP (100) PERCENT dbo.correcoes_correcao.id, dbo.correcoes_correcao.data_inicio, dbo.correcoes_correcao.data_termino, dbo.correcoes_correcao.correcao, dbo.correcoes_correcao.link_imagem_recortada, 
                         dbo.correcoes_correcao.link_imagem_original, dbo.correcoes_correcao.nota_final, dbo.correcoes_correcao.competencia1, dbo.correcoes_correcao.competencia2, dbo.correcoes_correcao.competencia3, 
                         dbo.correcoes_correcao.competencia4, dbo.correcoes_correcao.competencia5, dbo.correcoes_correcao.nota_competencia1, dbo.correcoes_correcao.nota_competencia2, dbo.correcoes_correcao.nota_competencia3, 
                         dbo.correcoes_correcao.nota_competencia4, dbo.correcoes_correcao.nota_competencia5, dbo.correcoes_correcao.id_auxiliar1, dbo.correcoes_correcao.id_auxiliar2, dbo.correcoes_correcao.id_correcao_situacao, 
                         dbo.correcoes_situacao.descricao, dbo.correcoes_correcao.id_corretor, dbo.correcoes_correcao.id_status, dbo.correcoes_status.descricao AS status_correcao, dbo.correcoes_correcao.id_tipo_correcao, 
                         dbo.correcoes_tipo.descricao AS tipo_correcao, dbo.correcoes_correcao.id_projeto, dbo.projeto_projeto.descricao AS Projeto, dbo.correcoes_correcao.co_barra_redacao, dbo.correcoes_corretor.id AS IdCorretor, 
                         dbo.correcoes_corretor.id_grupo, dbo.correcoes_grupocorretor.grupo, dbo.correcoes_grupocorretor.proficiencia, dbo.auth_user.username, dbo.auth_user.first_name, dbo.auth_user.last_name
FROM            dbo.correcoes_corretor INNER JOIN
                         dbo.correcoes_grupocorretor ON dbo.correcoes_corretor.id_grupo = dbo.correcoes_grupocorretor.id INNER JOIN
                         dbo.auth_user ON dbo.correcoes_corretor.id = dbo.auth_user.id RIGHT OUTER JOIN
                         dbo.correcoes_correcao ON dbo.correcoes_corretor.id = dbo.correcoes_correcao.id_corretor LEFT OUTER JOIN
                         dbo.projeto_projeto ON dbo.correcoes_correcao.id_projeto = dbo.projeto_projeto.id LEFT OUTER JOIN
                         dbo.correcoes_tipo ON dbo.correcoes_correcao.id_tipo_correcao = dbo.correcoes_tipo.id LEFT OUTER JOIN
                         dbo.correcoes_situacao ON dbo.correcoes_correcao.id_correcao_situacao = dbo.correcoes_situacao.id LEFT OUTER JOIN
                         dbo.correcoes_status ON dbo.correcoes_correcao.id_status = dbo.correcoes_status.id

GO
/****** Object:  View [dbo].[VW_CORRECAO_DIA]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW  [dbo].[VW_CORRECAO_DIA] AS
SELECT COR.ID, CORRECOES = ISNULL(COR.max_correcoes_dia,PRO.max_correcoes_dia), id_projeto = pro.id
FROM CORRECOES_CORRETOR COR JOIN PROJETO_PROJETO PRO ON (1=1)

GO
/****** Object:  View [dbo].[vw_correcao_resumo]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_correcao_resumo] as
SELECT correcoes_analise.id_corretor_A as id, usuarios_pessoa.cpf, usuarios_pessoa.nome, usuarios_pessoa.email, vw_corretor_analise.nota, vw_corretor_analise.QTD_CORRECOES as correcoes, correcoes_contador.data_inicio_correcao as data_inicio,MAX(correcoes_analise.data_termino_A) AS data_termino
FROM correcoes_analise
inner join usuarios_pessoa on correcoes_analise.id_corretor_A = usuarios_pessoa.usuario_id
LEFT OUTER JOIN vw_corretor_analise on correcoes_analise.id_corretor_A = vw_corretor_analise.id_corretor
LEFT OUTER JOIN correcoes_correcao on correcoes_analise.id_corretor_A = correcoes_correcao.id_corretor
LEFT OUTER JOIN correcoes_contador on correcoes_analise.id_corretor_A = correcoes_contador.id_corretor
GROUP by correcoes_analise.id_corretor_A, usuarios_pessoa.cpf, usuarios_pessoa.nome, usuarios_pessoa.email, vw_corretor_analise.nota, vw_corretor_analise.QTD_CORRECOES, correcoes_contador.data_inicio_correcao


GO
/****** Object:  View [dbo].[vw_correcoes_presas]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_correcoes_presas]
as
select polo.descricao as polo, time.descricao as time, b.last_name, a.id from (
select id, id_corretor from correcoes_correcao where data_termino is null
) a
join auth_user b on a.id_corretor = b.id
join correcoes_corretor d on b.id = d.id
left outer join usuarios_hierarquia_usuarios c on c.user_id = b.id
left outer join usuarios_hierarquia time on c.hierarquia_id = time.id
left outer join usuarios_hierarquia polo on time.id_hierarquia_usuario_pai = polo.id
where d.status_id = 4

GO
/****** Object:  View [dbo].[vw_correcoes_usuario]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_correcoes_usuario] AS
      SELECT
        usuario.id as usuario_id,
        last_name as nome,
        count(correcao.id) AS nr_corrigidas,
        MAX(correcao.data_termino) AS ultima_correcao,
        uh.indice
    FROM auth_user usuario
    LEFT JOIN correcoes_correcao correcao ON correcao.id_corretor = usuario.id
    JOIN usuarios_hierarquia_usuarios uhu on uhu.user_id = usuario.id
    join usuarios_hierarquia uh on uh.id = uhu.hierarquia_id
    where correcao.data_termino is not null
    GROUP BY usuario.id, last_name, uh.indice

GO
/****** Object:  View [dbo].[vw_corretor_analise]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_corretor_analise] as
select id_corretor_A as id_corretor, sum(nota) as nota,
 QTD_CORRECOES = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
                   WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A),
 QTD_DISCREPANCIA = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
                   WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
                         (diferenca_situacao    = 2 OR
                          situacao_nota_final   = 2 OR
                          situacao_competencia1 = 2 OR
                          situacao_competencia2 = 2 OR
                          situacao_competencia3 = 2 OR
                          situacao_competencia4 = 2 OR
                          situacao_competencia5 = 2
                          )) ,
 QTD_DIVERGENCIA = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
                   WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
                         (diferenca_situacao    = 1 OR
                          situacao_nota_final   = 1 OR
                          situacao_competencia1 = 1 OR
                          situacao_competencia2 = 1 OR
                          situacao_competencia3 = 1 OR
                          situacao_competencia4 = 1 OR
                          situacao_competencia5 = 1
                          )) ,
 QTD_DISC_SITUACAO = (SELECT COUNT(*)
                    FROM correcoes_analise ANAX
                   WHERE ANAX.id_corretor_A = TBLBASE.ID_CORRETOR_A AND
                         (diferenca_situacao    = 2))
  from (select id_corretor_A,
               nota = case when diferenca_situacao     = 0 and situacao_nota_final   = 0 and
                                (situacao_competencia1 = 0 and situacao_competencia2 = 0 and
                                 situacao_competencia3 = 0 and situacao_competencia4 = 0 and
                                 situacao_competencia5 = 0 ) then 1.4
                           when diferenca_situacao > 0 then 0
                           when (situacao_nota_final   = 2 or
                                (situacao_competencia1 = 2 or situacao_competencia2 = 2 or
                                 situacao_competencia3 = 2 or situacao_competencia4 = 2 or
                                 situacao_competencia5 = 2 )) then 0 else 1.1 end
         from correcoes_analise) as tblbase
group by id_corretor_A

GO
/****** Object:  View [dbo].[vw_cotas_quarta_correcao]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_cotas_quarta_correcao] as
select us.id as usuario_id, cota1,
       case when cota2 is null then cota1 else cota2 end as cota2,
       case when cota3 is null then (case when cota2 is null then cota1 else cota2 end) else cota3 end as cota3,
       case when cota4 is null then (case when (case when cota3 is null then (case when cota2 is null then cota1 else cota2 end) else cota3 end) is null then cota2 else (case when cota3 is null then (case when cota2 is null then cota1 else cota2 end) else cota3 end) end) else cota4 end as cota4 
 from auth_user us cross apply (
select (
select max_correcoes_dia
  from log_correcoes_corretor lg
 where lg.id = us.id 
   and history_id = (select max(lg2.history_id) from log_correcoes_corretor lg2 join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO' and lg2.history_date between json_value(par.valor_padrao, '$.cotas[0].inicio') and json_value(par.valor_padrao, '$.cotas[0].termino') where lg2.id = lg.id)
) as cota1, (
select max_correcoes_dia
  from log_correcoes_corretor lg
 where lg.id = us.id 
   and history_id = (select max(lg2.history_id) from log_correcoes_corretor lg2 join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO' and lg2.history_date between json_value(par.valor_padrao, '$.cotas[1].inicio') and json_value(par.valor_padrao, '$.cotas[1].termino') where lg2.id = lg.id)
) as cota2, (
select max_correcoes_dia
  from log_correcoes_corretor lg
 where lg.id = us.id 
   and history_id = (select max(lg2.history_id) from log_correcoes_corretor lg2 join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO' and lg2.history_date between json_value(par.valor_padrao, '$.cotas[2].inicio') and json_value(par.valor_padrao, '$.cotas[2].termino') where lg2.id = lg.id)
) as cota3, (
select max_correcoes_dia
  from log_correcoes_corretor lg
 where lg.id = us.id 
   and history_id = (select max(lg2.history_id) from log_correcoes_corretor lg2 join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO' and lg2.history_date between json_value(par.valor_padrao, '$.cotas[3].inicio') and json_value(par.valor_padrao, '$.cotas[3].termino') where lg2.id = lg.id)
) as cota4) as cotas

GO
/****** Object:  View [dbo].[vw_descartada_n70]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create     view [dbo].[vw_descartada_n70] as  
select  aud.co_barra_redacao,   
        cor.id_tipo_correcao,  
  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and   
                          isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and  
                          isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and  
                          isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and  
                          isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and  
                          isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and  
                          aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end  
  from correcoes_correcao aud with (nolock) join correcoes_correcao cor with (nolock) on (aud.co_barra_redacao = cor.co_barra_redacao and   
                                                                                          aud.id_tipo_correcao = 7 ) 

GO
/****** Object:  View [dbo].[vw_distribiucao_faixa_ouro]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_distribiucao_faixa_ouro] as 
    select id_corretor, total_correcoes = correcao, 
           correcoes_ouro_dia = correcaoouro,
           total_correcao_dia = total_dia_correcao,
           total_correcao_anterior = correcao_dia_anterior,
           id_projeto = tab.id_projeto, 
           cota_correcao_dia = dia.correcoes,
           limite_dia = tab.correcao_dia_anterior + dia.correcoes, faixa = tab.correcao_dia_anterior + dia.correcoes - total_dia_correcao
    
    from (
select distinct  id_corretor, correcao = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 ), 
                      correcaoouro = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 and id_tipo_correcao = 5 and cast(data_termino as date)=  cast(GETDATE() as date)),
                total_dia_correcao = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3 and cast(data_termino as date)=  cast(GETDATE() as date)),
                 correcao_dia_anterior = (select count(*) from correcoes_correcao cor with (nolock) where cor.Id_corretor = our.id_corretor  
                      and  cor.id_status = 3  and cast(data_termino as date)  <  cast( GETDATE() as date)),
                id_projeto = our.id_projeto
 from correcoes_filaouro our) as tab join VW_CORRECAO_DIA dia on (tab.id_corretor = dia.id and tab.id_projeto = dia.id_projeto)

GO
/****** Object:  View [dbo].[vw_filas_da_redacao]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                             [VW_FILAS_DA_REDACAO]                                              *
*                                                                                                                *
*  VIEW QUE RETORNA CASO EXISTA ALGUMA FILA COM REGISTRO DA REDACAO EM QUESTAO                                   *
*                                                                                                                *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/

CREATE     VIEW [dbo].[vw_filas_da_redacao] AS 							 
select red.id AS REDACAO_ID, fila = 1  , FILA_NOME = 'FILA 1'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila1         fil1 on (red.id = fil1.redacao_id AND RED.ID_PROJETO = fil1.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 2  , FILA_NOME = 'FILA 2'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila2         fil2 on (red.id = fil2.redacao_id AND RED.ID_PROJETO = fil2.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 3  , FILA_NOME = 'FILA 3'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila3         fil3 on (red.id = fil3.redacao_id AND RED.ID_PROJETO = fil3.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 4  , FILA_NOME = 'FILA 4'   , RED.ID_PROJETO from correcoes_redacao red join correcoes_fila4         fil4 on (red.id = fil4.redacao_id AND RED.ID_PROJETO = fil4.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 7  , FILA_NOME = 'AUDITORIA', RED.ID_PROJETO from correcoes_redacao red join correcoes_filaauditoria fila on (red.id = fila.redacao_id AND RED.ID_PROJETO = fila.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 10 , FILA_NOME = 'PESSOAL'  , RED.ID_PROJETO from correcoes_redacao red join correcoes_filapessoal   filp on (red.id = filp.redacao_id AND RED.ID_PROJETO = filp.ID_PROJETO) UNION 
select red.id AS REDACAO_ID, fila = 5  , FILA_NOME = 'OURO/MODA', RED.ID_PROJETO from correcoes_redacao red join correcoes_filaouro      filo on (red.id = filo.redacao_id AND RED.ID_PROJETO = filo.ID_PROJETO)

GO
/****** Object:  View [dbo].[vw_hierarquia_completa]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       view [dbo].[vw_hierarquia_completa] as
select [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_hierarquia as [time] with (nolock)
       inner join usuarios_hierarquia as polo with (nolock) on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv with (nolock) on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral with (nolock) on geral.id = fgv.id_hierarquia_usuario_pai

GO
/****** Object:  View [dbo].[vw_ocorrencias_ocorrencia]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_ocorrencias_ocorrencia]
AS
SELECT
     dbo.ocorrencias_ocorrencia.id,
     dbo.ocorrencias_ocorrencia.data_solicitacao,
     dbo.ocorrencias_ocorrencia.correcao_id,
     dbo.ocorrencias_tipo.descricao AS tipo_descricao,
     dbo.ocorrencias_categoria.descricao AS categoria_descricao,
     dbo.ocorrencias_situacao.descricao AS situacao_descricao,
     dbo.ocorrencias_status.descricao AS status_descricao,
     dbo.ocorrencias_status.icone AS status_icone,
     dbo.ocorrencias_status.classe AS status_classe,
     dbo.auth_user.last_name
FROM dbo.ocorrencias_ocorrencia
LEFT OUTER JOIN dbo.ocorrencias_situacao
     ON dbo.ocorrencias_ocorrencia.situacao_id = dbo.ocorrencias_situacao.id
INNER JOIN dbo.ocorrencias_status
     ON dbo.ocorrencias_ocorrencia.status_id = dbo.ocorrencias_status.id
LEFT OUTER JOIN dbo.ocorrencias_tipo
     ON dbo.ocorrencias_ocorrencia.tipo_id = dbo.ocorrencias_tipo.id
INNER JOIN dbo.ocorrencias_categoria
     ON dbo.ocorrencias_ocorrencia.categoria_id = dbo.ocorrencias_categoria.id
     AND dbo.ocorrencias_tipo.categoria_id = dbo.ocorrencias_categoria.id
LEFT OUTER JOIN dbo.auth_user
     ON dbo.ocorrencias_ocorrencia.usuario_autor_id = dbo.auth_user.id
     AND dbo.ocorrencias_ocorrencia.usuario_responsavel_id = dbo.auth_user.id
  

GO
/****** Object:  View [dbo].[vw_panorama_geral_ocorrencias]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_panorama_geral_ocorrencias] as
select
    supervisor.last_name "supervisor",
    polo_descricao,
    time_descricao,
    polo_id,
    time_id,
    usuarios.time_indice as indice,
    sum(case when 1 = 1 then 1 else 0 end) total,
    sum(case when categoria.id = 2 then 1 else 0 end) ocorrencias_imagem,
    sum(case when categoria.id = 2 and chamado.status_id in (8, 2) then 1 else 0 end) ocorrencias_imagem_respondidas,
    sum(case when categoria.id = 2 and chamado.status_id not in (8, 2) then 1 else 0 end) ocorrencias_imagem_pendentes,
    sum(case when categoria.id = 1 then 1 else 0 end) ocorrencias_pedagogica,
    sum(case when categoria.id = 1 and chamado.status_id not in (8, 2) then 1 else 0 end) ocorrencias_pedagogica_pendentes,
    sum(case when categoria.id = 1 and chamado.status_id in (8, 2) then 1 else 0 end) ocorrencias_pedagogica_respondidas,
    sum(case when chamado.status_id not in (8, 2) and user_groups.group_id = 25 then 1 else 0 end) ocorrencias_pendentes_supervisor,
    sum(case when chamado.status_id not in (8, 2) and user_groups.group_id = 30 then 1 else 0 end) ocorrencias_pendentes_coord_polo,
    sum(case when chamado.status_id not in (8, 2) and user_groups.group_id = 29 then 1 else 0 end) ocorrencias_pendentes_coord_fgv,
    sum(case when chamado.status_id not in (8, 2) and chamado.responsavel_atual is null then 1 else 0 end) ocorrencias_pendentes_time_tecnico,
    CAST(chamado.criado_em as date) [data]
    from chamados_chamado chamado
        join chamados_tipo tipo
            on tipo.id = chamado.tipo_id
                join chamados_categoria categoria
                    on categoria.id = tipo.categoria_id
                        join auth_user [user]
                            on [user].id = chamado.responsavel_atual
                                join auth_user_groups user_groups
                                    on  user_groups.user_id = [user].id
                                        join vw_usuarios usuarios
                                            on usuarios.usuario_id = chamado.autor_id
                                                join usuarios_hierarquia hierarquia
                                                    on hierarquia.id = usuarios.time_id
                                                        join auth_user [supervisor]
                                                            on supervisor.id = hierarquia.id_usuario_responsavel
    group by CAST(chamado.criado_em as date), polo_descricao, time_descricao, polo_id, time_id, usuarios.time_indice, supervisor.last_name

GO
/****** Object:  View [dbo].[vw_prova_analise_cordgeral]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_prova_analise_cordgeral]
AS
SELECT DISTINCT 
                         r.id AS mascara, r.link_imagem_recortada, CASE WHEN r.link_imagem_recortada LIKE 'result/1810401_G%' THEN 'CESGRANRIO' WHEN r.link_imagem_recortada LIKE 'result/1810401_F%' THEN 'FGV' END AS empresa, 
                         r.co_inscricao, r.co_barra_redacao AS codigo_barra_redacao
FROM            dbo.ocorrencias_ocorrencia AS oc INNER JOIN
                         dbo.correcoes_correcao AS cc ON cc.id = oc.correcao_id INNER JOIN
                         dbo.correcoes_redacao AS r ON r.co_barra_redacao = cc.co_barra_redacao
WHERE        (oc.status_id = 11)

GO
/****** Object:  View [dbo].[vw_rebuild_indices]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_rebuild_indices] as
select 'alter index ' + dbindexes.[name] + ' on ' + dbtables.[name] + ' reorganize' as reorg,
       'alter index ' + dbindexes.[name] + ' on ' + dbtables.[name] + ' rebuild with (fillfactor=80, online=on)' as rebuild
--select count(1)
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE 1 = 1 
and indexstats.database_id = DB_ID()
and indexstats.avg_fragmentation_in_percent > 10
--and dbindexes.fill_factor = 10
GO
/****** Object:  View [dbo].[vw_redacao_auditoria_nota_1000]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_redacao_auditoria_nota_1000] as
SELECT distinct RED.ID AS REDACAO_ID, RED.ID_PROJETO
FROM correcoes_redacao RED JOIN CORRECOES_CORRECAO COR1 ON (RED.ID = COR1.REDACAO_ID AND RED.ID_PROJETO = COR1.ID_PROJETO AND COR1.ID_TIPO_CORRECAO = 1)
                           JOIN CORRECOES_CORRECAO COR2 ON (RED.ID = COR2.REDACAO_ID AND RED.ID_PROJETO = COR2.ID_PROJETO AND COR2.ID_TIPO_CORRECAO = 2)
                      left JOIN CORRECOES_CORRECAO COR3 ON (RED.ID = COR3.REDACAO_ID AND RED.ID_PROJETO = COR3.ID_PROJETO AND COR3.ID_TIPO_CORRECAO = 3)
                      left JOIN CORRECOES_CORRECAO COR4 ON (RED.ID = COR4.REDACAO_ID AND RED.ID_PROJETO = COR4.ID_PROJETO AND COR4.ID_TIPO_CORRECAO = 4)
WHERE (COR1.nota_final = 1000 and COR2.nota_final = 1000) OR 
      (COR1.nota_final = 1000 AND COR3.nota_final = 1000) OR 
	  (COR2.NOTA_FINAL = 1000 AND COR3.nota_final = 1000) OR 
	  (COR4.nota_final = 1000)
      
GO
/****** Object:  View [dbo].[vw_redacao_equidistante]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                           [VW_REDACAO_EQUIDISTANTE]                                            *
*                                                                                                                *
*  VIEW QUE RELACIONA TODAS AS REDACOES QUE SAO EQUIDISTANTES                                                    *
*                                                                                                                *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/

CREATE   view [dbo].[vw_redacao_equidistante] as 
select cor3.redacao_id, 
       cor3.id_projeto, 
       cor3.nota_final as nota_final3, 
       cor2.nota_final as nota_final2, 
	   cor1.nota_final as nota_final1 
  from correcoes_correcao cor3 join correcoes_correcao cor2 on (cor3.redacao_id = cor2.redacao_id and 
                                                                cor3.id_projeto = cor2.id_projeto and 
																cor3.id_tipo_correcao = 3 and
																cor2.id_tipo_correcao = 2)
                               join correcoes_correcao cor1 on (cor3.redacao_id = cor1.redacao_id and 
							                                    cor3.id_projeto = cor1.id_projeto and
																cor1.id_tipo_correcao = 1)
where abs(cor1.nota_final - cor3.nota_final) = abs(cor2.nota_final - cor3.nota_final) and 
      cor3.id_correcao_situacao = 1 and 
	  cor2.id_correcao_situacao = 1 and 
	  cor1.id_correcao_situacao = 1 AND 
	  
	  ABS(cor3.competencia1 - COR1.competencia1) <= 2 AND 
	  ABS(cor3.competencia2 - COR1.competencia2) <= 2 AND 
	  ABS(cor3.competencia3 - COR1.competencia3) <= 2 AND 
	  ABS(cor3.competencia4 - COR1.competencia4) <= 2 AND 
	  ABS(cor3.competencia5 - COR1.competencia5) <= 2 AND 
	  
	  ABS(cor3.competencia1 - COR2.competencia1) <= 2 AND 
	  ABS(cor3.competencia2 - COR2.competencia2) <= 2 AND 
	  ABS(cor3.competencia3 - COR2.competencia3) <= 2 AND 
	  ABS(cor3.competencia4 - COR2.competencia4) <= 2 AND 
	  ABS(cor3.competencia5 - COR2.competencia5) <= 2  


GO
/****** Object:  View [dbo].[vw_redacoes_pendentes]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create     view [dbo].[vw_redacoes_pendentes] as
select co_barra_redacao from (
select co_barra_redacao from correcoes_fila1 union
select co_barra_redacao from correcoes_fila2 union
select co_barra_redacao from correcoes_fila3 union
select co_barra_redacao from correcoes_fila4 union
select co_barra_redacao from correcoes_filaauditoria union
select co_barra_redacao from correcoes_correcao where data_termino is null and id_tipo_correcao in (1,2,3,4,7)
) tab

GO
/****** Object:  View [dbo].[vw_relatorio_acompanhamento_auditoria]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_relatorio_acompanhamento_auditoria] as
select usuario_id, nome as auditor, hierarquia_id, '.1.3.' as indice, data,
       isnull(nota_maxima, 0) as nota_maxima,
       isnull(pd, 0) as pd, isnull(ddh, 0) as ddh, isnull(situacao_esdruxula, 0) as situacao_esdruxula, 
       isnull(nota_maxima, 0) + isnull(pd, 0) + isnull(ddh, 0) + isnull(situacao_esdruxula, 0) as total
  from (
    select usuario_id, nome, hierarquia_id, indice, data, [1] as nota_maxima, [2] as pd, [3] as ddh, [4] as situacao_esdruxula from (
        select a.usuario_id, a.nome, d.id as hierarquia_id, d.indice, convert(date, b.data_termino) as data, b.tipo_auditoria_id, count(*) as correcoes
        from usuarios_pessoa a, correcoes_correcao b, usuarios_hierarquia_usuarios c, usuarios_hierarquia d
        where b.id_corretor = a.usuario_id
    and c.user_id = a.usuario_id
    and c.hierarquia_id = d.id
        and b.id_status = 3
        and b.id_tipo_correcao = 7
        group by a.usuario_id, a.nome, d.id, d.indice, convert(date, b.data_termino), b.tipo_auditoria_id
    ) z pivot (sum(correcoes) for tipo_auditoria_id in ([1], [2], [3], [4]) ) z
) w

GO
/****** Object:  View [dbo].[vw_relatorio_acompanhamento_quarta_correcao]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_relatorio_acompanhamento_quarta_correcao] as
select DISTINCT
    HIE.usuario_id,
    HIE.nome,
    HIE.POLO_ID,
    HIE.indice,
    HIE.POLO_DESCRICAO,
    HIE.time_id,
    HIE.time_descricao,
    DIS_cota_1 = (select cota1 from vw_cotas_quarta_correcao where usuario_id = HIE.usuario_id),
    COR_COTA_1 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[0].inicio') AND json_value(par.valor_padrao, '$.cotas[0].termino')),
    DIS_cota_2 = (select cota2 from vw_cotas_quarta_correcao where usuario_id = HIE.usuario_id),
    COR_COTA_2 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[1].inicio') AND json_value(par.valor_padrao, '$.cotas[1].termino')),

    DIS_cota_3 = (select cota3 from vw_cotas_quarta_correcao where usuario_id = HIE.usuario_id),
    COR_COTA_3 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) BETWEEN json_value(par.valor_padrao, '$.cotas[2].inicio') AND json_value(par.valor_padrao, '$.cotas[2].termino')),

    DIS_cota_4 = (select cota4 from vw_cotas_quarta_correcao where usuario_id = HIE.usuario_id),
    COR_COTA_4 = (SELECT COUNT(*)
                    FROM CORRECOES_CORRECAO CORX join core_parametros par on par.nome = 'COTAS_QUARTA_CORRECAO'
       WHERE CORX.ID_STATUS = 3 AND
             CORX.id_tipo_correcao = 4 AND
       CORX.id_corretor = COR.id_corretor AND
       CAST(CORX.data_termino AS DATE) >= json_value(par.valor_padrao, '$.cotas[3].inicio'))
  from  vw_usuario_hierarquia hie  left join correcoes_correcao cor on (cor.id_corretor = hie.usuario_id and
                                                                        cor.id_tipo_correcao = 4 and
                                                                        cor.id_status = 3)
where HIE.PERFIL = 'SUPERVISOR'

GO
/****** Object:  View [dbo].[vw_relatorio_aproveitamento_notas_geral]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_relatorio_aproveitamento_notas_geral] as
select 1 as id, hierarquia_id, descricao, indice, data,
       sum(redacoes_corrigidas) as redacoes_corrigidas, sum(notas_aproveitadas) as notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou
  from (
select polo_id as hierarquia_id, polo_descricao as descricao, indice, data, sum(redacoes_corrigidas) as redacoes_corrigidas, notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou from (
  select e.polo_id, e.polo_descricao, e.polo_indice as indice, convert(date, d.data_termino) as data, count(*) as redacoes_corrigidas,
        sum(convert(int, isnull(a.aproveitamento, 1))) as notas_aproveitadas, sum((case when a.conclusao_analise in (0,1,2) then 1 else 0 end)) as nao_discrepou, sum((case when a.conclusao_analise in (3,4,5) then 1 else 0 end)) as discrepou
    from correcoes_analise a, usuarios_hierarquia_usuarios b, usuarios_hierarquia c, correcoes_correcao d, vw_usuario_hierarquia_completa e
  where a.id_corretor_A = b.user_id
    and b.hierarquia_id = c.id
    and a.id_tipo_correcao_B = 3
    and d.id = a.id_correcao_A
    and e.usuario_id = b.user_id
  group by e.polo_id, e.polo_descricao, e.polo_indice, convert(date, d.data_termino)
) z
group by polo_id, polo_descricao, indice, data, notas_aproveitadas
union all
select polo_id as hierarquia_id, polo_descricao as descricao, indice, data, sum(redacoes_corrigidas) as redacoes_corrigidas, notas_aproveitadas, sum(nao_discrepou) as nao_discrepou, sum(discrepou) as discrepou from (
  select e.polo_id, e.polo_descricao, e.polo_indice as indice, convert(date, d.data_termino) as data, count(*) as redacoes_corrigidas,
        sum(convert(int, isnull(a.aproveitamento, 1))) as notas_aproveitadas, sum((case when a.conclusao_analise in (0,1,2) then 1 else 0 end)) as nao_discrepou, sum((case when a.conclusao_analise in (3,4,5) then 1 else 0 end)) as discrepou
    from correcoes_analise a, usuarios_hierarquia_usuarios b, usuarios_hierarquia c, correcoes_correcao d, vw_usuario_hierarquia_completa e
  where a.id_corretor_B = b.user_id
    and b.hierarquia_id = c.id
    and a.id_tipo_correcao_B = 3
    and d.id = a.id_correcao_B
    and e.usuario_id = b.user_id
  group by e.polo_id, e.polo_descricao, e.polo_indice, convert(date, d.data_termino)
) z
group by polo_id, polo_descricao, indice, data, notas_aproveitadas
) w
group by hierarquia_id, descricao, indice, data

GO
/****** Object:  View [dbo].[vw_relatorio_aproveitamento_notas_por_polo]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_relatorio_aproveitamento_notas_por_polo] as
select polo_id, polo_descricao, hierarquia_id, descricao, id_hierarquia_usuario_pai, id_tipo_hierarquia_usuario, indice, data,
       sum(redacoes_corrigidas) as redacoes_corrigidas,
       sum(notas_aproveitadas) as notas_aproveitadas,
       sum(notas_nao_aproveitadas) as notas_nao_aproveitadas,
       sum(nao_discrepou) as nao_discrepou,
       sum(discrepou) as discrepou
 from (

select a.polo_id, a.polo_descricao, time_id as hierarquia_id, time_descricao as descricao, time_indice as indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino) as data,
       count(*) as redacoes_corrigidas,
       sum(case when isnull(d.aproveitamento, 0) = 1 then 1 else 0 end) as notas_aproveitadas,
       sum(case when d.aproveitamento = 0 and d.aproveitamento is not null then 1 else 0 end) as notas_nao_aproveitadas,
       sum(convert(int, isnull(e.discrepou, 0))) as discrepou,
       count(*) - sum(convert(int, isnull(e.discrepou, 0))) as nao_discrepou
  from vw_usuario_hierarquia_completa a
       inner join correcoes_correcao b on a.usuario_id = b.id_corretor and b.id_tipo_correcao = 1
       inner join correcoes_analise c on c.id_correcao_a = b.id
       inner join usuarios_hierarquia f on f.id = a.time_id
       left outer join correcoes_analise d on d.id_correcao_a = b.id and d.id_tipo_correcao_b = 3   /*verificar aproveitamento e discrepância de comparação com terceiras*/
       left outer join correcoes_conclusao_analise e on e.id = c.conclusao_analise
 where b.data_termino is not null
group by a.polo_id, a.polo_descricao, a.polo_indice, time_id, time_descricao, time_indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino)
union
select a.polo_id, a.polo_descricao, time_id as hierarquia_id, time_descricao as descricao, time_indice as indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino) as data,
       count(*) as redacoes_corrigidas,
       sum(case when isnull(d.aproveitamento, 0) = 1 then 1 else 0 end) as notas_aproveitadas,
       sum(case when d.aproveitamento = 0 and d.aproveitamento is not null then 1 else 0 end) as notas_nao_aproveitadas,
       sum(convert(int, isnull(e.discrepou, 0))) as discrepou,
       count(*) - sum(convert(int, isnull(e.discrepou, 0))) as nao_discrepou
  from vw_usuario_hierarquia_completa a
       inner join correcoes_correcao b on a.usuario_id = b.id_corretor and b.id_tipo_correcao = 2
       inner join correcoes_analise c on c.id_correcao_b = b.id
       inner join usuarios_hierarquia f on f.id = a.time_id
       left outer join correcoes_analise d on d.id_correcao_a = b.id and d.id_tipo_correcao_b = 3   /*verificar aproveitamento e discrepância de comparação com terceiras*/
       left outer join correcoes_conclusao_analise e on e.id = c.conclusao_analise
 where b.data_termino is not null
group by a.polo_id, a.polo_descricao, a.polo_indice, time_id, time_descricao, time_indice, f.id_hierarquia_usuario_pai, f.id_tipo_hierarquia_usuario, convert(date, data_termino)
) z
group by polo_id, polo_descricao, hierarquia_id, descricao, id_hierarquia_usuario_pai, id_tipo_hierarquia_usuario, indice, data

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_competencia_time]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      view [dbo].[vw_relatorio_distribuicao_notas_competencia_time] as
select polo.id as polo_id, polo.descricao as polo_descricao, polo.indice as polo_indice, time.id as time_id, time.descricao as time_descricao, time.indice as indice, p.usuario_id, p.nome,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
       sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
       sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
       sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
       sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
       sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
       sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
       sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
       sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
       sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
       sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
       sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
       sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
       sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
       sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
       sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
       sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
       sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
       sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
       sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
       sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data,
       count_big(a.id) as nr_corrigidas,
       count_big(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from dbo.correcoes_correcao a
       right join dbo.usuarios_pessoa p on p.usuario_id = a.id_corretor and a.id_status = 3
       inner join dbo.usuarios_hierarquia_usuarios b on b.user_id = p.usuario_id
       inner join dbo.usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
       inner join dbo.usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
       inner join dbo.usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join dbo.usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
group by polo.id, polo.descricao, polo.indice, time.id, time.descricao, time.indice, p.usuario_id, p.nome, convert(date, a.data_termino)

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_geral]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create     view [dbo].[vw_relatorio_distribuicao_notas_geral] as
select ROW_NUMBER() over (order by hierarquia_id) as id, hierarquia_id, descricao, indice, data, nr_total_avaliadores, nr_corrigidas, nr_com_nota_normal,
       (nr_competencia1_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_0,
       (nr_competencia1_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_1,
       (nr_competencia1_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_2,
       (nr_competencia1_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_3,
       (nr_competencia1_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_4,
       (nr_competencia1_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_5,
       (nr_competencia2_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_0,
       (nr_competencia2_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_1,
       (nr_competencia2_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_2,
       (nr_competencia2_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_3,
       (nr_competencia2_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_4,
       (nr_competencia2_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_5,
       (nr_competencia3_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_0,
       (nr_competencia3_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_1,
       (nr_competencia3_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_2,
       (nr_competencia3_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_3,
       (nr_competencia3_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_4,
       (nr_competencia3_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_5,
       (nr_competencia4_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_0,
       (nr_competencia4_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_1,
       (nr_competencia4_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_2,
       (nr_competencia4_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_3,
       (nr_competencia4_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_4,
       (nr_competencia4_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_5,
       (nr_competencia5_ddh * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_ddh,
       (nr_competencia5_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_0,
       (nr_competencia5_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_1,
       (nr_competencia5_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_2,
       (nr_competencia5_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_3,
       (nr_competencia5_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_4,
       (nr_competencia5_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_5
        from (
select c.polo_id as hierarquia_id, c.polo_descricao as descricao, c.polo_indice as indice,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
       sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
       sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
       sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
       sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
       sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
       sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
       sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
       sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
       sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
       sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
       sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
       sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
       sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
       sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
       sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
       sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
       sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
       sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
       sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
       sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data, count(distinct a.id_corretor) as nr_total_avaliadores, count(*) as nr_corrigidas, count(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from correcoes_correcao a with (nolock)
       inner join vw_usuario_hierarquia_completa c with (nolock) on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, convert(date, a.data_termino)
) z

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_polo]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_relatorio_distribuicao_notas_polo] as
SELECT  ROW_NUMBER() over (order by hierarquia_id) as id,
    q.polo_id,
    q.polo_descricao,
    q.polo_indice,
    q.time_id as hierarquia_id,
    q.time_descricao as descricao,
    q.time_indice as indice,
    u.data,
    u.nr_total_avaliadores,
    u.nr_corrigidas,
    u.nr_com_nota_normal,
    ISNULL(u.competencia1_0, 0) as competencia1_0,
    ISNULL(u.competencia1_1, 0) as competencia1_1,
    ISNULL(u.competencia1_2, 0) as competencia1_2,
    ISNULL(u.competencia1_3, 0) as competencia1_3,
    ISNULL(u.competencia1_4, 0) as competencia1_4,
    ISNULL(u.competencia1_5, 0) as competencia1_5,
    ISNULL(u.competencia2_0, 0) as competencia2_0,
    ISNULL(u.competencia2_1, 0) as competencia2_1,
    ISNULL(u.competencia2_2, 0) as competencia2_2,
    ISNULL(u.competencia2_3, 0) as competencia2_3,
    ISNULL(u.competencia2_4, 0) as competencia2_4,
    ISNULL(u.competencia2_5, 0) as competencia2_5,
    ISNULL(u.competencia3_0, 0) as competencia3_0,
    ISNULL(u.competencia3_1, 0) as competencia3_1,
    ISNULL(u.competencia3_2, 0) as competencia3_2,
    ISNULL(u.competencia3_3, 0) as competencia3_3,
    ISNULL(u.competencia3_4, 0) as competencia3_4,
    ISNULL(u.competencia3_5, 0) as competencia3_5,
    ISNULL(u.competencia4_0, 0) as competencia4_0,
    ISNULL(u.competencia4_1, 0) as competencia4_1,
    ISNULL(u.competencia4_2, 0) as competencia4_2,
    ISNULL(u.competencia4_3, 0) as competencia4_3,
    ISNULL(u.competencia4_4, 0) as competencia4_4,
    ISNULL(u.competencia4_5, 0) as competencia4_5,
    ISNULL(u.competencia5_ddh, 0) as competencia5_ddh,
    ISNULL(u.competencia5_0, 0) as competencia5_0,
    ISNULL(u.competencia5_1, 0) as competencia5_1,
    ISNULL(u.competencia5_2, 0) as competencia5_2,
    ISNULL(u.competencia5_3, 0) as competencia5_3,
    ISNULL(u.competencia5_4, 0) as competencia5_4,
    ISNULL(u.competencia5_5, 0) as competencia5_5

FROM vw_hierarquia_completa q LEFT OUTER JOIN (
select polo_id, polo_descricao, polo_indice, hierarquia_id, descricao, indice, data, nr_total_avaliadores, nr_corrigidas, nr_com_nota_normal,
       (nr_competencia1_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_0,
       (nr_competencia1_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_1,
       (nr_competencia1_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_2,
       (nr_competencia1_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_3,
       (nr_competencia1_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_4,
       (nr_competencia1_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_5,
       (nr_competencia2_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_0,
       (nr_competencia2_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_1,
       (nr_competencia2_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_2,
       (nr_competencia2_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_3,
       (nr_competencia2_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_4,
       (nr_competencia2_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_5,
       (nr_competencia3_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_0,
       (nr_competencia3_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_1,
       (nr_competencia3_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_2,
       (nr_competencia3_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_3,
       (nr_competencia3_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_4,
       (nr_competencia3_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_5,
       (nr_competencia4_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_0,
       (nr_competencia4_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_1,
       (nr_competencia4_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_2,
       (nr_competencia4_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_3,
       (nr_competencia4_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_4,
       (nr_competencia4_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_5,
       (nr_competencia5_ddh * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_ddh,
       (nr_competencia5_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_0,
       (nr_competencia5_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_1,
       (nr_competencia5_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_2,
       (nr_competencia5_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_3,
       (nr_competencia5_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_4,
       (nr_competencia5_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_5
        from (
select c.polo_id, c.polo_descricao, c.polo_indice, c.time_id as hierarquia_id, c.time_descricao as descricao, c.time_indice as indice,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
       sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
       sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
       sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
       sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
       sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
       sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
       sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
       sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
       sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
       sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
       sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
       sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
       sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
       sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
       sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
       sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
       sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
       sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
       sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
       sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data, count(distinct a.id_corretor) as nr_total_avaliadores, count(*) as nr_corrigidas, count(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from correcoes_correcao a with (nolock)
       inner join vw_usuario_hierarquia_completa c with (nolock) on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, c.time_id, c.time_descricao, c.time_indice, convert(date, a.data_termino)
) z) u on q.time_id = u.hierarquia_id

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_situacao_geral]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_relatorio_distribuicao_notas_situacao_geral] as
select  ROW_NUMBER() over (order by hierarquia_id) as id, *,
       (nr_nm + nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) as nr_corrigidas,
       (nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) as nr_situacoes from (
select polo_id as hierarquia_id, polo_descricao as descricao, polo_indice as indice, data,
       isnull([1], 0) as nr_nm, isnull([2], 0) as nr_fea, isnull([3], 0) as nr_copia, isnull([6], 0) as nr_ft, isnull([7], 0) as nr_natt, isnull([9], 0) as nr_pd from (
select c.polo_id, c.polo_descricao, c.polo_indice, a.id_correcao_situacao, convert(date, a.data_termino) as data,
       count(*) as nr_corrigidas
  from correcoes_correcao a
       left outer join correcoes_situacao b on a.id_correcao_situacao = b.id
       inner join vw_usuario_hierarquia_completa c on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, a.id_correcao_situacao, convert(date, a.data_termino)
) z pivot (sum(nr_corrigidas) for id_correcao_situacao in ([1], [2], [3], [6], [7], [9])) z
) y

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_situacao_polo]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_distribuicao_notas_situacao_polo]
AS
SELECT ROW_NUMBER()
    OVER (
    ORDER BY
        hierarquia_id) AS id,
        q.polo_id,
        q.polo_descricao,
        q.time_id as hierarquia_id,
        q.time_descricao as descricao,
        q.time_indice as indice,
        u.data,
        ISNULL(u.nr_nm, 0) AS nr_nm,
        ISNULL(u.nr_fea, 0) AS nr_fea,
        ISNULL(u.nr_copia, 0) AS nr_copia,
        ISNULL(u.nr_ft, 0) AS nr_ft,
        ISNULL(u.nr_natt, 0) AS nr_natt,
        ISNULL(u.nr_pd, 0) AS nr_pd,
        ISNULL(u.nr_corrigidas,0) as nr_corrigidas,
        ISNULL(u.nr_situacoes, 0) as nr_situacoes
        FROM vw_hierarquia_completa q LEFT OUTER JOIN(
SELECT
    *, (nr_nm + nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_corrigidas, (nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_situacoes
FROM (
    SELECT
        polo_id,
        polo_descricao,
        time_id AS hierarquia_id,
        time_descricao AS descricao,
        time_indice AS indice,
        data,
        ISNULL([1], 0) AS nr_nm,
        ISNULL([2], 0) AS nr_fea,
        ISNULL([3], 0) AS nr_copia,
        ISNULL([6], 0) AS nr_ft,
        ISNULL([7], 0) AS nr_natt,
        ISNULL([9], 0) AS nr_pd
    FROM (
        SELECT
            c.polo_id,
            c.polo_descricao,
            c.time_id,
            c.time_descricao,
            c.time_indice,
            a.id_correcao_situacao,
            convert(date, a.data_termino) AS data,
            count(*) AS nr_corrigidas
        FROM
            correcoes_correcao a
        LEFT OUTER JOIN correcoes_situacao b ON a.id_correcao_situacao = b.id
    INNER JOIN vw_usuario_hierarquia_completa c ON c.usuario_id = a.id_corretor
    WHERE
        a.id_status = 3
    GROUP BY
        c.polo_id,
        c.polo_descricao,
        c.time_id,
        c.time_descricao,
        c.time_indice,
        a.id_correcao_situacao,
        convert(date, a.data_termino)) z pivot (sum(nr_corrigidas)
        FOR id_correcao_situacao IN ([1],
            [2],
            [3],
            [6],
            [7],
            [9])) z) y) u ON q.time_id = u.hierarquia_id

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_situacao_time]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_distribuicao_notas_situacao_time] AS
SELECT
        q.polo_id,
        q.polo_descricao,
        q.time_id,
        q.time_descricao,
        q.usuario_id,
        q.nome,
        q.time_indice AS indice,
        data,
        ISNULL(u.nr_nm, 0) as nr_nm,
        isnull(u.nr_fea, 0) as nr_fea,
        ISNULL(u.nr_copia, 0) as nr_copia,
        ISNULL(u.nr_ft, 0) as nr_ft,
        ISNULL(u.nr_natt, 0) as nr_natt,
        ISNULL(u.nr_pd, 0) as nr_pd,
        ISNULL(u.nr_corrigidas, 0) as nr_corrigidas,
        isnull(u.nr_situacoes, 0) as nr_situacoes
FROM dbo.vw_usuario_hierarquia_completa q left outer join (
SELECT
    polo_id, polo_descricao, time_id, time_descricao, usuario_id, nome, indice, data, nr_nm, nr_fea, nr_copia, nr_ft, nr_natt, nr_pd, (nr_nm + nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_corrigidas, (nr_fea + nr_copia + nr_ft + nr_natt + nr_pd) AS nr_situacoes
FROM (
    SELECT
        polo_id,
        polo_descricao,
        time_id,
        time_descricao,
        usuario_id,
        nome,
        time_indice AS indice,
        data,
        ISNULL([1], 0) AS nr_nm,
        ISNULL([2], 0) AS nr_fea,
        ISNULL([3], 0) AS nr_copia,
        ISNULL([6], 0) AS nr_ft,
        ISNULL([7], 0) AS nr_natt,
        ISNULL([9], 0) AS nr_pd
    FROM (
        SELECT
            c.polo_id,
            c.polo_descricao,
            c.time_id,
            c.time_descricao,
            c.time_indice,
            c.usuario_id,
            c.nome,
            a.id_correcao_situacao,
            convert(date, a.data_termino) AS data,
            count(*) AS nr_corrigidas
        FROM
            dbo.correcoes_correcao a
        LEFT OUTER JOIN dbo.correcoes_situacao b ON a.id_correcao_situacao = b.id
    INNER JOIN dbo.vw_usuario_hierarquia_completa c ON c.usuario_id = a.id_corretor
    WHERE
        a.id_status = 3
    GROUP BY
        c.polo_id,
        c.polo_descricao,
        c.time_id,
        c.time_descricao,
        c.time_indice,
        c.usuario_id,
        c.nome,
        a.id_correcao_situacao,
        convert(date, a.data_termino)) z pivot (sum(nr_corrigidas)
        FOR id_correcao_situacao IN ([1],
            [2],
            [3],
            [6],
            [7],
            [9])) z) y) u on u.usuario_id = q.usuario_id

GO
/****** Object:  View [dbo].[vw_relatorio_distribuicao_notas_time]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     view [dbo].[vw_relatorio_distribuicao_notas_time] as
select 1 as id, polo_id, polo_descricao, polo_indice, time_id, time_descricao, time_indice, usuario_id, nome, data, nr_corrigidas, nr_com_nota_normal,
       (nr_competencia1_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_0,
       (nr_competencia1_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_1,
          (nr_competencia1_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_2,
          (nr_competencia1_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_3,
          (nr_competencia1_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_4,
          (nr_competencia1_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia1_5,
          (nr_competencia2_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_0,
       (nr_competencia2_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_1,
          (nr_competencia2_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_2,
          (nr_competencia2_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_3,
          (nr_competencia2_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_4,
          (nr_competencia2_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia2_5,
       (nr_competencia3_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_0,
       (nr_competencia3_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_1,
          (nr_competencia3_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_2,
          (nr_competencia3_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_3,
          (nr_competencia3_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_4,
          (nr_competencia3_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia3_5,
       (nr_competencia4_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_0,
       (nr_competencia4_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_1,
          (nr_competencia4_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_2,
          (nr_competencia4_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_3,
          (nr_competencia4_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_4,
          (nr_competencia4_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia4_5,
       (nr_competencia5_ddh * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_ddh,
       (nr_competencia5_0 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_0,
       (nr_competencia5_1 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_1,
          (nr_competencia5_2 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_2,
          (nr_competencia5_3 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_3,
          (nr_competencia5_4 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_4,
          (nr_competencia5_5 * 100.0 / (case when nr_com_nota_normal = 0 then 1 else nr_com_nota_normal end)) as competencia5_5
        from (
select c.polo_id, c.polo_descricao, c.polo_indice, c.time_id, c.time_descricao, c.time_indice, c.usuario_id, c.nome,
       sum(case when competencia1 = 0 then 1 else 0 end) as nr_competencia1_0,
       sum(case when competencia1 = 1 then 1 else 0 end) as nr_competencia1_1,
       sum(case when competencia1 = 2 then 1 else 0 end) as nr_competencia1_2,
       sum(case when competencia1 = 3 then 1 else 0 end) as nr_competencia1_3,
       sum(case when competencia1 = 4 then 1 else 0 end) as nr_competencia1_4,
       sum(case when competencia1 = 5 then 1 else 0 end) as nr_competencia1_5,
       sum(case when competencia2 = 0 then 1 else 0 end) as nr_competencia2_0,
       sum(case when competencia2 = 1 then 1 else 0 end) as nr_competencia2_1,
       sum(case when competencia2 = 2 then 1 else 0 end) as nr_competencia2_2,
       sum(case when competencia2 = 3 then 1 else 0 end) as nr_competencia2_3,
       sum(case when competencia2 = 4 then 1 else 0 end) as nr_competencia2_4,
       sum(case when competencia2 = 5 then 1 else 0 end) as nr_competencia2_5,
       sum(case when competencia3 = 0 then 1 else 0 end) as nr_competencia3_0,
       sum(case when competencia3 = 1 then 1 else 0 end) as nr_competencia3_1,
       sum(case when competencia3 = 2 then 1 else 0 end) as nr_competencia3_2,
       sum(case when competencia3 = 3 then 1 else 0 end) as nr_competencia3_3,
       sum(case when competencia3 = 4 then 1 else 0 end) as nr_competencia3_4,
       sum(case when competencia3 = 5 then 1 else 0 end) as nr_competencia3_5,
       sum(case when competencia4 = 0 then 1 else 0 end) as nr_competencia4_0,
       sum(case when competencia4 = 1 then 1 else 0 end) as nr_competencia4_1,
       sum(case when competencia4 = 2 then 1 else 0 end) as nr_competencia4_2,
       sum(case when competencia4 = 3 then 1 else 0 end) as nr_competencia4_3,
       sum(case when competencia4 = 4 then 1 else 0 end) as nr_competencia4_4,
       sum(case when competencia4 = 5 then 1 else 0 end) as nr_competencia4_5,
       sum(case when competencia5 = -1 then 1 else 0 end) as nr_competencia5_ddh,
       sum(case when competencia5 = 0 then 1 else 0 end) as nr_competencia5_0,
       sum(case when competencia5 = 1 then 1 else 0 end) as nr_competencia5_1,
       sum(case when competencia5 = 2 then 1 else 0 end) as nr_competencia5_2,
       sum(case when competencia5 = 3 then 1 else 0 end) as nr_competencia5_3,
       sum(case when competencia5 = 4 then 1 else 0 end) as nr_competencia5_4,
       sum(case when competencia5 = 5 then 1 else 0 end) as nr_competencia5_5,
       convert(date, a.data_termino) as data, count(*) as nr_corrigidas, count(case when a.id_correcao_situacao = 1 then 1 else null end) as nr_com_nota_normal
  from correcoes_correcao a with (nolock)
          inner join vw_usuario_hierarquia_completa c with (nolock) on c.usuario_id = a.id_corretor
 where a.id_status = 3
group by c.polo_id, c.polo_descricao, c.polo_indice, c.time_id, c.time_descricao, c.time_indice, c.usuario_id, c.nome, convert(date, a.data_termino)
) z

GO
/****** Object:  View [dbo].[vw_relatorio_geral]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_geral]
AS
     SELECT 1 AS id,
            hierarquia_id,
            descricao,
            id_hierarquia_usuario_pai,
            id_tipo_hierarquia_usuario,
            indice,
            data,
            notas_aproveitadas,
            total_corrigidas,
            tempo_medio,
            dsp,
            media_dia
     FROM
     (
         SELECT a.polo_id AS hierarquia_id,
                a.polo_descricao AS descricao,
                g.id_hierarquia_usuario_pai,
                g.id_tipo_hierarquia_usuario,
                a.polo_indice AS indice,
                Convert(Date, b.data_termino) AS data,
                Sum((CASE
                         WHEN f.aproveitamento = 1
                         THEN 1
                         ELSE 0
                     END)) AS notas_aproveitadas,
                Count(DISTINCT b.id) AS total_corrigidas,
                Avg(b.tempo_em_correcao) AS tempo_medio,
                Avg(d.dsp) AS dsp,
                Round(Count(*) / DateDiff(day, e.data_inicio, dbo.getlocaldate()), 2) AS media_dia
         FROM vw_usuario_hierarquia_completa a WITH(NOLOCK)
              INNER JOIN correcoes_correcao b WITH(NOLOCK)
                       ON b.id_corretor = a.usuario_id
                          AND b.id_status = 3
              INNER JOIN usuarios_hierarquia c WITH(NOLOCK)
                       ON c.id = a.time_id
              INNER JOIN usuarios_hierarquia g WITH(NOLOCK)
                       ON g.id = a.polo_id
              INNER JOIN projeto_projeto e WITH(NOLOCK)
                       ON e.id = b.id_projeto
              LEFT OUTER JOIN correcoes_analise f WITH(NOLOCK)
                       ON f.id_correcao_A = b.id
                          AND f.id_tipo_correcao_b = 3
              LEFT OUTER JOIN correcoes_corretor_indicadores d WITH(NOLOCK)
                       ON d.usuario_id = b.id_corretor
                          AND d.data_calculo =
         (
             SELECT Max(data_calculo)
             FROM correcoes_corretor_indicadores z WITH(NOLOCK)
             WHERE z.usuario_id = b.id_corretor
         )
         GROUP BY a.polo_id,
                  a.polo_descricao,
                  g.id_hierarquia_usuario_pai,
                  g.id_tipo_hierarquia_usuario,
                  a.polo_indice,
                  Convert(Date, b.data_termino),
                  e.data_inicio
     ) f;

GO
/****** Object:  View [dbo].[vw_relatorio_geral_por_polo]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_geral_por_polo] AS
SELECT  ROW_NUMBER() over (order by TIME_id) as id,
        POLO_ID,
        POLO_DESCRICAO,
        HIERARQUIA,
        TIME_ID,
        indice,
        DSP = AVG(MEDIA_DSP) ,
        TIME_DESCRICAO,
        TOTAL_CORRIGIDAS,
        TOTAL_CORRIGIDAS_POR_DIA = CAST(ROUND(TOTAL_CORRIGIDAS / (SELECT (CASE WHEN dbo.getlocaldate() <= DATA_TERMINO THEN DATEDIFF(DAY,DATEADD(DAY,-1,DATA_INICIO), dbo.getlocaldate())
                                                                                                             ELSE DATEDIFF(DAY,DATEADD(DAY,-1,DATA_INICIO), DATA_TERMINO) END) * 1.0
                                                                  FROM PROJETO_PROJETO with (nolock) WHERE ID = 4), 2) AS NUMERIC(10,2)),
        TOTAL_CORRETORES,
        TEMPO_MEDIO = CAST(ROUND(CASE WHEN TOTAL_CORRIGIDAS = 0 THEN 0 ELSE  SOMA_TEMPO / (TOTAL_CORRIGIDAS * 1.0) END , 2) AS NUMERIC(10,2)),
        APROVEITAMENTO_NOTA = ISNULL( CAST(ROUND((case when TOTAL_CORRIGIDAS = 0 then 0.00 else aproveitamento_nota / (total_corrigidas * 1.0) end) * 100, 2) AS NUMERIC(10,2)),0)
  FROM (
SELECT DISTINCT
       POLO_ID = HIE2.POLO_ID ,
       POLO_DESCRICAO =  HIE2.POLO_DESCRICAO,
       HIE.indice,
       HIERARQUIA =  HIE2.HIERARQUIA,
       HIE.TIME_ID,
       HIE.TIME_DESCRICAO,
       TOTAL_CORRIGIDAS = ISNULL(COR.QTD,0),
       SOMA_TEMPO = ISNULL(TEMPO,0),
       MEDIA_DSP  = CCI.MEDIA_DSP,
       APROVEITAMENTO_NOTA = QTD_APROVEITAMENTO,
       TOTAL_CORRETORES = ISNULL(CORRETOR.QTD,0)


  FROM (SELECT DISTINCT TIME_ID, TIME_DESCRICAO , INDICE
          FROM VW_USUARIO_HIERARQUIA
          WHERE id_tipo_hierarquia_usuario = 4) AS  HIE   left join (select HIEX.TIME_id, QTD = ISNULL(count(CORX.ID),0), TEMPO = SUM(ISNULL(CORX.TEMPO_EM_CORRECAO,0))
                                                             from correcoes_correcao corX join vw_usuario_hierarquia hieX on (corX.id_corretor = hieX.usuario_id)
                                                            where id_status = 3 GROUP BY HIEX.TIME_id ) AS COR ON (HIE.TIME_id = COR.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, MEDIA_DSP = AVG(ISNULL(CCIX.DSP,0))
                                                             FROM correcoes_corretor_indicadores CCIX join vw_usuario_hierarquia hieX on (CCIX.USUARIO_ID = hieX.usuario_id)
                                                            GROUP BY HIEX.TIME_id) AS CCI ON (HIE.TIME_id = CCI.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, QTD = ISNULL(count(CORR.ID),0)
                                                             FROM correcoes_corretor CORR join vw_usuario_hierarquia hieX on (CORR.id = hieX.usuario_id)
                                                            GROUP BY HIEX.TIME_id) AS CORRETOR ON (HIE.TIME_id = CORRETOR.TIME_id)
                                                LEFT JOIN (SELECT HIEX.TIME_id, QTD_APROVEITAMENTO = ISNULL(COUNT(ANAX.ID),0)
                                                             FROM correcoes_analise ANAX JOIN VW_USUARIO_HIERARQUIA HIEX ON (ANAX.id_correTOR_A = HIEX.USUARIO_ID AND
                                                                                                                             ANAX.ID_TIPO_CORRECAO_B = 3          AND
                                                                                                                             ANAX.aproveitamento = 1)
                                                            GROUP BY HIEX.TIME_id) AS ANA ON (ANA.TIME_id = HIE.TIME_id)
                                               LEFT JOIN (SELECT DISTINCT HIEX.TIME_ID, POLO_ID, POLO_DESCRICAO, HIERARQUIA
                                                            FROM VW_USUARIO_HIERARQUIA HIEX) AS HIE2 ON (HIE2.TIME_ID = HIE.TIME_ID)) AS TAB
GROUP BY POLO_ID,
      POLO_DESCRICAO,
      HIERARQUIA,
      TIME_ID,
      indice,
      TIME_DESCRICAO,
      TOTAL_CORRIGIDAS,
      SOMA_TEMPO,
      APROVEITAMENTO_NOTA,
      TOTAL_CORRETORES

GO
/****** Object:  View [dbo].[vw_relatorio_geral_por_time]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_relatorio_geral_por_time] AS 
WITH CTE_APROVEITAMENTO AS (
            SELECT usuario_id, SUM(nr_corrigidas) nr_corrigidas_1_2, SUM(nr_aproveitadas) as nr_aproveitadas,  
                SUM(nr_discrepantes) as nr_discrepantes, data  
              FROM vw_aproveitamento_notas_time WITH(NOLOCK)
                                 GROUP BY usuario_id, data
  ),

        CTE_TEMPO_MEDIO AS (
            SELECT 
                COUNT(1) nr_corrigidas,
                cast(data_termino as date) AS DATA_TERMINO,
                id_corretor,
                CASE WHEN AVG(tempo_em_correcao) > 1200 then 1200 else AVG(tempo_em_correcao) end as tempo_medio  
              FROM correcoes_correcao  WITH(NOLOCK) where data_termino is not null
             GROUP BY id_corretor, cast(data_termino as date)
    )

        SELECT   
        HIE.polo_id,  
        HIE.polo_descricao,  
        HIE.time_id,  
        HIE.time_descricao,  
        nome as avaliador,  
        HIE.usuario_id,  
        HIE.TIME_indice AS INDICE,  
        nr_corrigidas,
        nr_corrigidas_1_2,  
        nr_aproveitadas,  
        nr_discrepantes,  
        tempo_medio,  
        cast(COR.dsp as varchar(20)) as dsp,  
        data   
        FROM vw_usuario_hierarquia_completa HIE  WITH(NOLOCK) JOIN      correcoes_corretor   COR WITH(NOLOCK) ON (COR.id           = HIE.usuario_id) 
                                                                LEFT JOIN CTE_TEMPO_MEDIO    TEM WITH(NOLOCK) ON (TEM.id_corretor = HIE.usuario_id)
                                                                LEFT JOIN CTE_APROVEITAMENTO APR WITH(NOLOCK) ON (APR.usuario_id  = HIE.usuario_id AND 
                                                                                                                  APR.data        = TEM.DATA_TERMINO)

GO
/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_avaliador]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_padrao_ouro_avaliador]
 AS
SELECT
  a.id_correcao_a AS id_correcao,
  a.id_corretor_a AS id_corretor,
  b.id
  AS redacao,
  a.competencia1_a AS avaliador_c1,
  a.competencia2_a AS avaliador_c2,
  a.competencia3_a AS avaliador_c3,
  a.competencia4_a AS avaliador_c4,
  a.competencia5_a AS avaliador_c5,
  CASE
    WHEN a.competencia5_a = -1 THEN 1
    ELSE 0
  END AS avaliador_is_ddh,
  a.nota_final_a
  AS nota,
  c.id_competencia1 AS referencia_c1,
  c.id_competencia2 AS referencia_c2,
  c.id_competencia3 AS referencia_c3,
  c.id_competencia4 AS referencia_c4,
  c.id_competencia5 AS referencia_c5,
  CASE
    WHEN c.id_competencia5 = -1 THEN 1
    ELSE 0
  END AS referencia_is_ddh,
  c.nota_final
  AS nota_referencia,
  ABS(c.id_competencia1 - a.competencia1_a) AS diferenca_c1,
  ABS(c.id_competencia2 - a.competencia2_a) AS diferenca_c2,
  ABS(c.id_competencia3 - a.competencia3_a) AS diferenca_c3,
  ABS(c.id_competencia4 - a.competencia4_a) AS diferenca_c4,
  ABS(CASE c.id_competencia5
    WHEN -1 THEN 0
    ELSE c.id_competencia5
  END -
       CASE a.competencia5_a
         WHEN -1 THEN 0
         ELSE a.competencia5_a
       END) AS diferenca_c5,
  ABS(c.nota_final - a.nota_final_a) AS nota_diferenca,
  CAST(a.data_termino_a AS date) AS data,
  d.sigla AS avaliador_situacao,
  e.sigla AS referencia_situacao,
  f.discrepou,
  g.time_id,
  g.polo_id,
  g.fgv_id,
  g.geral_id,
  g.time_descricao,
  g.polo_descricao,
  g.fgv_descricao,
  g.geral_descricao,
  g.time_indice,
  g.polo_indice,
  g.fgv_indice,
  g.geral_indice
FROM correcoes_analise a WITH(NOLOCK) JOIN correcoes_redacao              b WITH(NOLOCK) ON (a.redacao_id     = b.id)
                                      JOIN correcoes_gabarito             c WITH(NOLOCK) ON (c.redacao_id     = b.id)
                                      JOIN correcoes_situacao             d WITH(NOLOCK) ON (d.id                   = a.id_correcao_situacao_a)
                                      JOIN correcoes_situacao             e WITH(NOLOCK) ON (c.id_correcao_situacao = e.id)
                                      JOIN correcoes_conclusao_analise    f WITH(NOLOCK) ON (f.id                   = a.conclusao_analise)
                                      JOIN vw_usuario_hierarquia_completa g WITH(NOLOCK) ON (g.usuario_id           = a.id_corretor_a)
WHERE  a.id_tipo_correcao_A = 5

GO
/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_geral]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_padrao_ouro_geral] as
select 1 as id, * from (
  SELECT c.id as hierarquia_id, c.descricao, c.indice,
        convert(date, a.data) as data, count(a.id) as padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as discrepancia_padrao_ouro
    from usuarios_hierarquia c 
        left outer join vw_relatorio_padrao_ouro_avaliador a on c.id = a.polo_id
   where c.id_tipo_hierarquia_usuario = 3
  group by c.id, c.descricao, c.indice, convert(date, a.data)
) z

GO
/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_polo]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_padrao_ouro_polo] as
select 1 as id, b.id as polo_id, b.descricao as polo_descricao, c.id as hierarquia_id, c.descricao, c.indice,
        convert(date, a.data) as data, count(a.id) as padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as discrepancia_padrao_ouro
    from usuarios_hierarquia c
         inner join usuarios_hierarquia b on b.id = c.id_hierarquia_usuario_pai
         left outer join vw_relatorio_padrao_ouro_avaliador a on c.id = a.time_id
   where c.id_tipo_hierarquia_usuario = 4
  group by b.id, b.descricao, c.id, c.descricao, c.indice, convert(date, a.data)

GO
/****** Object:  View [dbo].[vw_relatorio_padrao_ouro_time]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_padrao_ouro_time] as
SELECT d.polo_id, d.polo_descricao, d.time_id, d.time_descricao, b.user_id as usuario_id, b.hierarquia_id, c.id_usuario_responsavel, c.indice, c.id_tipo_hierarquia_usuario, d.nome as avaliador,
        convert(date, a.data) as data, count(a.id_corretor) as nr_padrao_ouro, isnull(sum(convert(int, a.discrepou)), 0) as nr_discrepancia_padrao_ouro
    from usuarios_hierarquia c
        inner join usuarios_hierarquia_usuarios b on c.id = b.hierarquia_id
        inner join vw_usuario_hierarquia_completa d on d.usuario_id = b.user_id
        left outer join vw_relatorio_padrao_ouro_avaliador a on a.id_corretor = b.user_id
   where c.id_tipo_hierarquia_usuario = 4
  group by d.polo_id, d.polo_descricao, d.time_id, d.time_descricao, b.user_id, b.hierarquia_id, c.id_usuario_responsavel, c.indice,
           c.id_tipo_hierarquia_usuario, d.nome, convert(date, a.data)

GO
/****** Object:  View [dbo].[vw_relatorio_panorama_geral_ocorrencias]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_panorama_geral_ocorrencias] AS
SELECT
    *, (total_ocorrencias - ocorrencias_respondidas) AS ocorrencias_pendentes
FROM (
    SELECT
        c.id AS time_id,
        c.id as hierarquia_id,
        c.descricao AS time_descricao,
        e.id AS polo_id,
        e.descricao AS polo_descricao,
        c.id_usuario_responsavel,
        c.id_hierarquia_usuario_pai,
        c.id_tipo_hierarquia_usuario,
        c.indice,
        convert(date, a.data_termino) AS data,
        count(*) AS total_ocorrencias,
        count(data_resposta) AS ocorrencias_respondidas
    FROM
        correcoes_correcao a,
        usuarios_hierarquia_usuarios b,
        usuarios_hierarquia c,
        ocorrencias_ocorrencia d,
        usuarios_hierarquia e
    WHERE
        a.id_corretor = b.user_id
        AND b.hierarquia_id = c.id
        AND d.correcao_id = a.id
        AND c.id_hierarquia_usuario_pai = e.id
    GROUP BY
        c.id,
        c.descricao,
        c.id_hierarquia_usuario_pai,
        c.id_tipo_hierarquia_usuario,
        c.indice,
        convert(date, a.data_termino),
        c.id_usuario_responsavel,
        e.id,
        e.descricao) z


GO
/****** Object:  View [dbo].[vw_relatorio_reescameamento]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_relatorio_reescameamento] as
select 
    url_antiga url_original,
    url_nova url_reescaneada,
    ocorrencia_id id_ocorrencia,
    (
        CASE
            WHEN url_antiga like '%_G_%' then 'CESGRANRIO'
            WHEN url_antiga like '%_F_%' then 'FGV'
        END
    ) empresa,
    (
        CASE 
            WHEN enviado = 1 then 'SIM'
            WHEN enviado <> 1 then 'NAO'
        END
    ) enviado,
    (
        CASE
            WHEN url_nova is null then 'NAO'
            WHEN url_nova is not null then 'SIM'
        END
    ) respondido
from ocorrencias_imagemfalha img
 join ocorrencias_ocorrencia oc
    on oc.id = img.ocorrencia_id
     JOIN ocorrencias_loteimagem li on 
        li.id = img.lote_id;

GO
/****** Object:  View [dbo].[vw_relatorio_reescaneamento]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_relatorio_reescaneamento] as
select 
    url_antiga url_original,
    url_nova url_reescaneada,
    ocorrencia_id id_ocorrencia,
    r.id mascara_redacao,
    (
        CASE
            WHEN LEFT(url_antiga, LEN(url_antiga) - 4) like '%G%' then 'CESGRANRIO'
            WHEN LEFT(url_antiga, LEN(url_antiga) - 4) like '%F%' then 'FGV'
        END
    ) empresa,
    (
        CASE 
            WHEN enviado = 1 then 'SIM'
            WHEN enviado <> 1 then 'NAO'
        END
    ) enviado,
    (
        CASE
            WHEN url_nova is null then 'NAO'
            WHEN url_nova is not null then 'SIM'
        END
    ) respondido
from ocorrencias_imagemfalha img
 join ocorrencias_ocorrencia oc
    on oc.id = img.ocorrencia_id
     JOIN ocorrencias_loteimagem li on 
        li.id = img.lote_id
        join correcoes_correcao c
            on c.id = oc.correcao_id
                join correcoes_redacao r
                 on c.co_barra_redacao = r.co_barra_redacao;

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_avaliador]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                           [VW_RELATORIO_TERCEIRA_CORRECAO_AVALIADOR]                                            *
*                                                                                                                                 *
*  VIEW QUE RETORNA TODAS AS CORRECOES QUE TIVERAM TERCEIRA E ESTA NAO FOI APROVEITADA                                            *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
**********************************************************************************************************************************/

CREATE   VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador] as 
SELECT 
    cor.id AS id_correcao,
    cor.id_corretor,
    hic.nome,
    CAST(red.id AS [nvarchar]) AS redacao,
    cor.competencia1 AS terceira_c1,
    cor.competencia2 AS terceira_c2,
    cor.competencia3 AS terceira_c3,
    cor.competencia4 AS terceira_c4,
    cor.competencia5 AS terceira_c5,
    CAST(cor.nota_final AS [int]) AS terceira_soma,
    sit.sigla AS terceira_situacao,
    cor4.competencia1 AS quarta_c1,
    cor4.competencia2 AS quarta_c2,
    cor4.competencia3 AS quarta_c3,
    cor4.competencia4 AS quarta_c4,
    cor4.competencia5 AS quarta_c5,
    CAST(cor4.nota_final AS [int]) AS quarta_soma,
    sit4.sigla AS quarta_situacao,
    cor.data_termino AS data,
    aproveitamento =
                    CASE
                        WHEN ana.conclusao_analise > 2 THEN 0
                        WHEN ana.conclusao_analise >= 0 THEN 1
                        ELSE NULL
                    END,
    hic.time_id,
    hic.polo_id,
    hic.fgv_id,
    hic.geral_id,
    hic.time_descricao,
    hic.polo_descricao,
    hic.fgv_descricao,
    hic.geral_descricao,
    hic.time_indice,
    hic.polo_indice,
    hic.fgv_indice,
    hic.geral_indice,
    red.co_barra_redacao,
    hie.id_hierarquia_usuario_pai,
    hie.id_tipo_hierarquia_usuario
FROM correcoes_correcao cor with(nolock) JOIN correcoes_redacao red with(nolock) ON (cor.redacao_id = red.id)
                          JOIN vw_usuario_hierarquia_completa   hic with(nolock) ON (hic.usuario_id = cor.id_corretor)
                          JOIN correcoes_situacao               sit with(nolock) ON (sit.id = cor.id_correcao_situacao)
                          JOIN usuarios_hierarquia              hie with(nolock) ON (hie.id = hic.time_id)
                     LEFT JOIN correcoes_analise                ana with(nolock) ON (ana.redacao_id = cor.redacao_id AND ana.id_projeto = cor.id_projeto  AND ana.id_tipo_correcao_A = 3 AND ana.id_tipo_correcao_B = 4)
                     LEFT JOIN correcoes_correcao               cor4 with(nolock) ON (cor4.redacao_id = red.id AND cor4.id_tipo_correcao = 4)
                     LEFT JOIN correcoes_situacao               sit4 with(nolock) ON (sit4.id = cor4.id_correcao_situacao)
WHERE cor.id_tipo_correcao = 3
AND cor.id_status = 3  
AND  EXISTS (SELECT TOP 1 1 FROM correcoes_analise  WHERE id_correcao_B = cor.id)
AND (EXISTS (SELECT TOP 1 1 FROM correcoes_correcao WHERE redacao_id    = cor.redacao_id AND id_tipo_correcao = 4) OR 
     EXISTS (SELECT TOP 1 1 FROM correcoes_fila4    WHERE redacao_id    = cor.redacao_id)                          OR 
     EXISTS (SELECT TOP 1 1 FROM correcoes_correcao WHERE redacao_id    = cor.redacao_id AND id_tipo_correcao = 7) OR 
     EXISTS (SELECT TOP 1 1 FROM correcoes_filaauditoria    WHERE redacao_id    = cor.redacao_id)                          
     )


GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_avaliador_AUX]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador_AUX] as
select ROW_NUMBER() over (order by id_correcao) as id, * from (
select a.id as id_correcao, a.id_corretor, c.nome, b.id as redacao,
       a.competencia1 as terceira_c1,
       a.competencia2 as terceira_c2,
       a.competencia3 as terceira_c3,
       a.competencia4 as terceira_c4,
       a.competencia5 as terceira_c5,
       a.nota_final as terceira_soma,
       e.sigla as terceira_situacao,
       d.competencia1 as quarta_c1,
       d.competencia2 as quarta_c2,
       d.competencia3 as quarta_c3,
       d.competencia4 as quarta_c4,
       d.competencia5 as quarta_c5,
       d.nota_final as quarta_soma,
       f.sigla as quarta_situacao,
       a.data_termino as data,
       -- fila4 = fil4.id ,
      -- correcao4 = corQua.id, ANAX.conclusao_analise,analiseaproveitamento = ANAX.aproveitamento,auditoria = filaud.id,
       conta = ((case when coraud.id is null then 0 else 1 end ) +
                                    (case when corqua.id is null then 0 else 1 end ) +
                                    (case when filaud.id is null then 0 else 1 end ) +
                                    (case when fil4.id   is null then 0 else 1 end )),

       APROVEITAMENTO = (case when ((case when coraud.id is not null then 1 else 0 end ) +
                                    (case when corqua.id is not null then 1 else 0 end ) +
                                    (case when filaud.id is not null then 1 else 0 end ) +
                                    (case when fil4.id   is not null then 1 else 0 end )) > 0 then 0
                              when (case when isnull(ANAX.conclusao_analise,0) < 3 then 1
                                        when ANAX.aproveitamento = 1 then 1 else 0 end) = 1  then 1
                              else 0 end),
        foi_para_quarta = (case when fil4.id is not null or corQua.id is not null or filaud.id is not null or  isnull(ANAX.conclusao_analise,0) > 2 then 1 else 0 end ),
        c.time_id, c.polo_id, c.fgv_id, c.geral_id, c.time_descricao, c.polo_descricao, c.fgv_descricao, c.geral_descricao,
        c.time_indice, c.polo_indice, c.fgv_indice, c.geral_indice,
        a.co_barra_redacao, g.id_hierarquia_usuario_pai, g.id_tipo_hierarquia_usuario
  from correcoes_correcao a
       inner join correcoes_redacao              b on a.co_barra_redacao = b.co_barra_redacao
       inner join vw_usuario_hierarquia_completa c on c.usuario_id = a.id_corretor
       inner join correcoes_situacao             e on e.id = a.id_correcao_situacao
       inner join usuarios_hierarquia            g on g.id = c.time_id
       left  join correcoes_analise            ana on (ana.co_barra_redacao = a.co_barra_redacao and
                                                       ana.id_projeto       = a.id_projeto and
                                                       ana.id_tipo_correcao_A = 3 and
                                                       ana.id_tipo_correcao_B = 4)
       left outer join correcoes_correcao d on d.co_barra_redacao = b.co_barra_redacao and d.id_tipo_correcao = 4
       left outer join correcoes_situacao f on f.id = d.id_correcao_situacao

       left outer join correcoes_analise ANAX on  (ANAX.id_correcao_a = b.id and ANAX.id_tipo_correcao_b = 3)   --verificar aproveitamento e discrepância de comparação com terceiras
       left outer join correcoes_correcao corQua on (corQua.co_barra_redacao = b.co_barra_redacao and corQua.id_tipo_correcao = 4)  -- correcoes de quarta
       left outer join correcoes_correcao corAud on (corAud.co_barra_redacao = b.co_barra_redacao and corAud.id_tipo_correcao = 7)  -- correcoes de auditoria
       left outer join correcoes_fila3 fil3 on (fil3.co_barra_redacao = b.co_barra_redacao)  -- fila 3
       left outer join correcoes_fila4 fil4 on (fil4.co_barra_redacao = b.co_barra_redacao) -- fila 4
       left outer join correcoes_filaauditoria filaud on (filaud.co_barra_redacao = b.co_barra_redacao) -- fila auditoria
 where a.id_tipo_correcao = 3
   and a.id_status = 3
   --and  exists (select top 1 1 from correcoes_analise x where x.id_correcao_B = a.id)
   --and (exists (select top 1 1 from correcoes_correcao where co_barra_redacao = a.co_barra_redacao and id_tipo_correcao = 4) or
   --     exists (select top 1 1 from correcoes_fila4 where co_barra_redacao = a.co_barra_redacao)

        --)
) z

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_avaliador_para_time]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_terceira_correcao_avaliador_para_time] as
select 1 as id, a.id as id_correcao, a.id_corretor, c.nome, b.id as redacao,
       a.competencia1 as terceira_c1,
       a.competencia2 as terceira_c2,
       a.competencia3 as terceira_c3,
       a.competencia4 as terceira_c4,
       a.competencia5 as terceira_c5,
       a.nota_final as terceira_soma,
       e.sigla as terceira_situacao,
       d.competencia1 as quarta_c1,
       d.competencia2 as quarta_c2,
       d.competencia3 as quarta_c3,
       d.competencia4 as quarta_c4,
       d.competencia5 as quarta_c5,
       d.nota_final as quarta_soma,
       f.sigla as quarta_situacao,
       a.data_termino as data,

        aproveitamento = case when ana.conclusao_analise > 2 then 0
                                   when ana.conclusao_analise >=0 then 1 else null end,
        c.time_id, c.polo_id, c.fgv_id, c.geral_id, c.time_descricao, c.polo_descricao, c.fgv_descricao, c.geral_descricao,
        c.time_indice, c.polo_indice, c.fgv_indice, c.geral_indice,
        a.co_barra_redacao, g.id_hierarquia_usuario_pai, g.id_tipo_hierarquia_usuario
  from correcoes_correcao a
       inner join correcoes_redacao b on a.co_barra_redacao = b.co_barra_redacao
       inner join vw_usuario_hierarquia_completa c on c.usuario_id = a.id_corretor
       inner join correcoes_situacao e on e.id = a.id_correcao_situacao
       inner join usuarios_hierarquia g on g.id = c.time_id
       left  join correcoes_analise  ana on (ana.co_barra_redacao = a.co_barra_redacao and
                                             ana.id_projeto       = a.id_projeto and
                                             ana.id_tipo_correcao_A = 3 and
                                             ana.id_tipo_correcao_B = 4)
       left outer join correcoes_correcao d on d.co_barra_redacao = b.co_barra_redacao and d.id_tipo_correcao = 4
       left outer join correcoes_situacao f on f.id = d.id_correcao_situacao
 where a.id_tipo_correcao = 3
   and a.id_status = 3
   and exists (select top 1 1 from correcoes_analise x where x.id_correcao_B = a.id)

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_geral]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE       VIEW [dbo].[vw_relatorio_terceira_correcao_geral] as
select u.id as polo_id,
       u.descricao as polo_descricao,
       u.indice,
       y.data,
       y.id_hierarquia_usuario_pai,
       y.id_tipo_hierarquia_usuario,
       isnull(y.terceiras_corrigidas, 0) as terceiras_corrigidas,
       isnull(y.terceiras_aproveitadas, 0) as terceiras_aproveitadas,
       isnull(y.foram_quarta, 0) as foram_quarta,
       isnull(y.aproveitadas_quarta, 0) as aproveitadas_quarta,
       isnull(y.nao_aproveitadas_quarta, 0) as nao_aproveitadas_quarta
  from usuarios_hierarquia u left outer join (
                                              select a.polo_id as hierarquia_id,
                                                     a.polo_descricao as descricao,
                                                     a.polo_indice as indice,
                                                     convert(date, data) as data,
                                                     a.id_hierarquia_usuario_pai,
                                                     a.id_tipo_hierarquia_usuario,
                                                     count(a.id_correcao) as terceiras_corrigidas,
                                                     sum(convert(int, a.aproveitamento)) as terceiras_aproveitadas,
                                                     sum(a.foi_para_quarta) as foram_quarta,
                                                     sum((case when isnull(c.discrepou, 1) = 1 then 0 else 1 end)) as aproveitadas_quarta,
                                                     sum((case when quarta_soma is null then 0 else isnull(convert(int, c.discrepou), 1) end)) as nao_aproveitadas_quarta
                                                from vw_relatorio_terceira_correcao_avaliador_AUX a
                                                     left outer join correcoes_analise b on a.id_correcao = b.id_correcao_A and b.id_tipo_correcao_B = 4
                                                     left outer join correcoes_conclusao_analise c on c.id = b.conclusao_analise
                                              group by a.polo_id, a.polo_descricao, a.polo_indice, convert(date, data), a.id_hierarquia_usuario_pai, a.id_tipo_hierarquia_usuario
                                              ) y on u.id = y.hierarquia_id where u.id_tipo_hierarquia_usuario = 3

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_polo]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorio_terceira_correcao_polo] as
SELECT
     q.time_id,
     q.time_descricao,
     q.time_indice AS indice,
     k.id_hierarquia_usuario_pai,
     k.id_tipo_hierarquia_usuario,
     u.data,
     q.polo_id,
     q.polo_descricao,
     ISNULL(u.terceiras_corrigidas, 0) as terceiras_corrigidas,
     ISNULL(u.terceiras_aproveitadas, 0) as terceiras_aproveitadas,
     ISNULL(u.foram_quarta, 0) as foram_quarta,
     ISNULL(u.aproveitadas_quarta, 0) as aproveitadas_quarta,
     ISNULL(u.nao_aproveitadas_quarta, 0) as nao_aproveitadas_quarta
FROM vw_hierarquia_completa q
     inner join usuarios_hierarquia k on k.id = q.time_id
     LEFT OUTER JOIN (

SELECT
    *
FROM (
    SELECT
        a.time_id AS hierarquia_id,
        a.time_descricao AS descricao,
        a.time_indice AS indice,
        a.id_hierarquia_usuario_pai,
        a.id_tipo_hierarquia_usuario,
        data,
        polo_id,
        polo_descricao AS polo,
        count(a.id_correcao) AS terceiras_corrigidas,
        sum(convert(int, ISNULL(a.aproveitamento, 0))) AS terceiras_aproveitadas,
        count(a.quarta_soma) AS foram_quarta,
        sum(( CASE WHEN ISNULL(c.discrepou, 1) = 1 THEN
                    0
                ELSE
                    1
END)) AS aproveitadas_quarta,
sum(( CASE WHEN quarta_soma IS NULL THEN
            0
        ELSE
            ISNULL(convert(int, c.discrepou), 1)
END)) AS nao_aproveitadas_quarta
FROM
    vw_relatorio_terceira_correcao_avaliador a
    LEFT OUTER JOIN correcoes_analise b ON a.id_correcao = b.id_correcao_A
    AND b.id_tipo_correcao_B = 4
    LEFT OUTER JOIN correcoes_conclusao_analise c ON c.id = b.conclusao_analise
GROUP BY
    a.time_id,
    a.time_descricao,
    a.time_indice,
    a.id_hierarquia_usuario_pai,
    a.id_tipo_hierarquia_usuario,
    data,
    polo_id,
    polo_descricao) z) u on q.time_id = u.hierarquia_id

GO
/****** Object:  View [dbo].[vw_relatorio_terceira_correcao_time]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                             [VW_RELATORIO_TERCEIRA_CORRECAO_TIME]                                               *
*                                                                                                                                 *
*  VIEW QUE SINTETIZA AS INFORMACOES REFERENTES A CORRECAO DAS TERCEIRAS                                                          *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:03/10/2019 *
***********************************************************************************************************************************/
CREATE   VIEW [dbo].[vw_relatorio_terceira_correcao_time]
AS
SELECT
    hc.time_id,
    hc.time_descricao,
    hc.time_indice AS indice,
    hc.usuario_id AS avaliador_id,
    k.id_hierarquia_usuario_pai,
    k.id_tipo_hierarquia_usuario,
    hc.nome AS avaliador_descricao,
    z.data,
    hc.polo_id,
    hc.polo_descricao,
    ISNULL(z.terceiras_corrigidas, 0) AS terceiras_corrigidas,
    ISNULL(z.terceiras_aproveitadas, 0) AS terceiras_aproveitadas,
    ISNULL(z.foram_quarta, 0) AS foram_quarta,
    ISNULL(z.aproveitadas_quarta, 0) AS aproveitadas_quarta,
    ISNULL(z.nao_aproveitadas_quarta, 0) AS nao_aproveitadas_quarta,
    ISNULL(z.pode_corrigir_3, 0) AS pode_corrigir_3
FROM vw_usuario_hierarquia_completa hc
INNER JOIN usuarios_hierarquia k
    ON k.id = hc.time_id
LEFT OUTER JOIN (SELECT
        a.time_id AS hierarquia_id,
        a.time_descricao AS descricao,
        a.time_indice AS indice,
        a.id_corretor,
        a.nome,
        CONVERT(date, data) AS data,
        polo_id,
        polo_descricao AS polo,
        COUNT(a.id_correcao) AS terceiras_corrigidas,     --isnull(sum(convert(int, a.aproveitamento)), 0) as terceiras_aproveitadas, 
        COUNT(a.id_correcao) - (ISNULL(COUNT(f.id), 0) + ISNULL(COUNT(g.id), 0) + ISNULL(COUNT(k.id), 0) + ISNULL(COUNT(j.id), 0)) AS terceiras_aproveitadas,
        (ISNULL(COUNT(f.id), 0) + ISNULL(COUNT(g.id), 0) + ISNULL(COUNT(k.id), 0) + ISNULL(COUNT(j.id), 0)) AS foram_quarta,
        SUM((CASE
            WHEN ISNULL(c.discrepou, 1) = 1 THEN 0
            ELSE 1
        END)) AS aproveitadas_quarta,
        SUM((CASE
            WHEN quarta_soma IS NULL THEN 0
            ELSE ISNULL(CONVERT(int, c.discrepou), 1)
        END)) AS nao_aproveitadas_quarta,
        h.pode_corrigir_3
    FROM vw_relatorio_terceira_correcao_avaliador_para_time a WITH(NOLOCK)
                                         INNER JOIN correcoes_corretor          h WITH(NOLOCK) ON h.id = a.id_corretor
                                    LEFT OUTER JOIN correcoes_analise           b WITH(NOLOCK) ON a.id_correcao = b.id_correcao_A AND 
                                                                                                  b.id_tipo_correcao_B = 4
                                    LEFT OUTER JOIN correcoes_conclusao_analise c WITH(NOLOCK) ON c.id = b.conclusao_analise
                                    LEFT OUTER JOIN correcoes_fila4             f WITH(NOLOCK) ON f.co_barra_redacao = a.co_barra_redacao
                                    LEFT OUTER JOIN correcoes_filaauditoria     k WITH(NOLOCK) ON k.co_barra_redacao = a.co_barra_redacao
                                    LEFT OUTER JOIN correcoes_correcao          j WITH(NOLOCK) ON j.co_barra_redacao = a.co_barra_redacao       AND 
                                                                                                  j.id_tipo_correcao = 7
                                    LEFT OUTER JOIN correcoes_correcao          g WITH(NOLOCK) ON g.co_barra_redacao = a.co_barra_redacao       AND 
                                                                                g.id_tipo_correcao = 4  
    
    GROUP BY    a.time_id,
                a.time_descricao,
                a.time_indice,
                a.id_corretor,
                a.id_hierarquia_usuario_pai,
                a.id_tipo_hierarquia_usuario,
                a.nome,
                CONVERT(date, data),
                polo_id,
                polo_descricao,
                h.pode_corrigir_3) z
    ON hc.usuario_id = z.id_corretor

GO
/****** Object:  View [dbo].[vw_relatorios_acompanhamento_geral]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_relatorios_acompanhamento_geral] as
select
    projeto,
    projeto_id,
    nr_1_correcao_concluida,
    nr_2_correcao_concluida,
    nr_3_correcao_concluida,
    nr_4_correcao_concluida,
    nr_ouro_concluida,
    nr_moda_concluida,
    nr_auditoria_concluida,
    nr_redacoes_em_andamento,
    nr_redacoes_concluidas,
    etapa_ensino_id,
    etapa_ensino
from (
    select
        SUM(CASE WHEN cor.id_tipo_correcao = 1 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_1_correcao_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 2 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_2_correcao_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 3 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_3_correcao_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 4 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_4_correcao_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 5 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_ouro_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 6 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_moda_concluida,
        SUM(CASE WHEN cor.id_tipo_correcao = 7 and cor.id_status = 3 THEN 1 ELSE 0 END) as nr_auditoria_concluida,
        cor.id_projeto as projeto_id,
        proj.descricao as projeto,
        etap.id as etapa_ensino_id,
        etap.abreviacao as etapa_ensino
    from correcoes_correcao cor
    join projeto_projeto proj on cor.id_projeto = proj.id
    left join projeto_etapaensino etap on proj.etapa_ensino_id = etap.id
    group by cor.id_projeto, proj.descricao, etap.id, etap.abreviacao) a
join (
    select 
        id_projeto,
        COUNT(DISTINCT(CASE WHEN red.id_correcao_situacao IN (2, 3) THEN red.co_barra_redacao END)) as nr_redacoes_em_andamento,
        COUNT(DISTINCT(CASE WHEN red.id_correcao_situacao = 4 THEN red.co_barra_redacao END)) as nr_redacoes_concluidas
    from correcoes_redacao red
    group by id_projeto) b
on a.projeto_id = b.id_projeto

GO
/****** Object:  View [dbo].[VW_TEMPO_TOTAL_OCORRENCIA_POR_CORRECAO_ID]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                      VIEW CALCULA DIFERENCA DE TEMPO DE ABERTURA E FECHAMENTO OCORRENCIA                       *
*                                                                                                                *
*  VIEW QUE CALCULA A DIFERENCA DE DATA DE ABERTURA E FECHAMENTO DE UMA OCORRENCIA DE UMA CORRECAO LEVANDO EM CO *
* TA APENAS A OCRRENCIA PAI NA TABELA OCORRENCIAS_OCORRENCIA                                                     *
*                                                                                                                *
* BANCO_SISTEMA : ENCCEJA                                                                                        *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:26/09/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:26/09/2018 *
******************************************************************************************************************/

create   view [dbo].[VW_TEMPO_TOTAL_OCORRENCIA_POR_CORRECAO_ID] as
SELECT correcao_id, id_projeto, SUM(DATEDIFF(minute, data_solicitacao, data_resposta)) AS DIFERENCA  
  FROM dbo.ocorrencias_ocorrencia  
 WHERE (data_resposta IS NOT NULL) AND (data_solicitacao IS NOT NULL)  and 
       isnull(ocorrencia_pai_id, 0) <> id
GROUP BY correcao_id, id_projeto 


GO
/****** Object:  View [dbo].[vw_todas_as_filas]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_todas_as_filas]
AS

select co_barra_redacao from correcoes_fila1 union all 
select co_barra_redacao from correcoes_fila2 union all
select co_barra_redacao from correcoes_fila3 union all 
select co_barra_redacao from correcoes_fila4 union all 
select co_barra_redacao from correcoes_filapessoal union all 
select co_barra_redacao from correcoes_filaauditoria 

GO
/****** Object:  View [dbo].[vw_total_ocorrencias_pendentes]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_total_ocorrencias_pendentes]
as
select b.id, polo.descricao as polo, time.descricao as time, b.last_name as nome, total from (
select usuario_responsavel_id, count(*) as total from ocorrencias_ocorrencia a
where status_id = 1
group by usuario_responsavel_id
) a
join auth_user b on a.usuario_responsavel_id = b.id
left outer join usuarios_hierarquia_usuarios c on c.user_id = b.id
left outer join usuarios_hierarquia time on c.hierarquia_id = time.id
left outer join usuarios_hierarquia polo on time.id_hierarquia_usuario_pai = polo.id

GO
/****** Object:  View [dbo].[vw_uitl_server_params]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_uitl_server_params] as
SELECT 
    [name],
    [value],
    [description]
FROM 
    sys.configurations
WHERE 
    [name] IN ( 'max degree of parallelism', 'cost threshold for parallelism', 'min server memory (MB)',
                'max server memory (MB)', 'clr enabled', 'xp_cmdshell', 'Ole Automation Procedures',
                'user connections', 'fill factor (%)', 'cross db ownership chaining', 'remote access',
                'default trace enabled', 'external scripts enabled', 'Database Mail XPs', 'Ad Hoc Distributed Queries',
                'SMO and DMO XPs', 'clr strict security', 'remote admin connections'
              )

GO
/****** Object:  View [dbo].[vw_usuario_hierarquia]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     VIEW [dbo].[vw_usuario_hierarquia]
AS
    SELECT pes.usuario_id,
            pes.nome,
            hie.id,
            hierarquia = hie.descricao,
            hie.id_usuario_responsavel,
            RESPONSAVEL = RES.nome,
            ID_HIERARQUIA = HIE.id,
            COR.MAX_CORRECOES_DIA,
            COR.ID_GRUPO,
            COR.PODE_CORRIGIR_1,
            COR.PODE_CORRIGIR_2,
            COR.PODE_CORRIGIR_3,
            COR.STATUS_Id,
            hie.indice,
            ppu.projeto_id,
            hie.id_tipo_hierarquia_usuario,
            hie.id_hierarquia_usuario_pai,
            [time].id AS time_id,
            polo.id AS polo_id,
            fgv.id AS fgv_id,
            geral.id AS geral_id,
            [time].descricao AS time_descricao,
            polo.descricao AS polo_descricao,
            fgv.descricao AS fgv_descricao,
            geral.descricao AS geral_descricao,
            [time].indice AS time_indice,
            polo.indice AS polo_indice,
            fgv.indice AS fgv_indice,
            geral.indice AS geral_indice,
            perfil = grp.name
     FROM usuarios_pessoa pes
         INNER JOIN usuarios_hierarquia_usuarios hieUsu WITH(NOLOCK)
                   ON(pes.usuario_id = hieUsu.user_id)
         INNER JOIN usuarios_hierarquia hie WITH(NOLOCK)
                   ON(hie.id = hieUsu.hierarquia_id)
         INNER JOIN usuarios_pessoa RES WITH(NOLOCK)
                   ON(RES.USUARIO_ID = HIE.id_usuario_responsavel)
         INNER JOIN projeto_projeto_usuarios ppu WITH(NOLOCK)
                   ON(res.usuario_id = ppu.user_id)
         INNER JOIN usuarios_hierarquia [time] WITH(NOLOCK)
                   ON [time].id = hieUsu.hierarquia_id
          LEFT JOIN CORRECOES_CORRETOR COR WITH(NOLOCK)
                   ON(COR.ID = PES.USUARIO_ID)
          LEFT JOIN usuarios_hierarquia polo WITH(NOLOCK)
                   ON polo.id = [time].id_hierarquia_usuario_pai
          LEFT JOIN usuarios_hierarquia fgv WITH(NOLOCK)
                   ON fgv.id = polo.id_hierarquia_usuario_pai
          LEFT JOIN usuarios_hierarquia geral WITH(NOLOCK)
                   ON geral.id = fgv.id_hierarquia_usuario_pai
          LEFT JOIN auth_user_groups gup WITH(NOLOCK)
                   ON(gup.user_id = pes.usuario_id)
          LEFT JOIN auth_group grp WITH(NOLOCK)
                   ON(grp.id = gup.group_id);

GO
/****** Object:  View [dbo].[vw_usuario_hierarquia_completa]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      view [dbo].[vw_usuario_hierarquia_completa] as
select a.usuario_id, a.nome, [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as [time] with (nolock) on [time].id = b.hierarquia_id
       inner join usuarios_hierarquia as polo with (nolock) on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv with (nolock) on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral with (nolock) on geral.id = fgv.id_hierarquia_usuario_pai

GO
/****** Object:  View [dbo].[vw_usuario_hierarquia_completa_para_vw_avaliadores]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_usuario_hierarquia_completa_para_vw_avaliadores] as 
select a.usuario_id, a.nome, [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
       inner join usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
union
select a.usuario_id, a.nome, null as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       null as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as polo on polo.id = b.hierarquia_id
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
 where polo.id_tipo_hierarquia_usuario = 3
union
 select a.usuario_id, a.nome, null as time_id, null as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       null as time_descricao, null as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as fgv on fgv.id = b.hierarquia_id
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
 where fgv.id_tipo_hierarquia_usuario = 2
union
 select a.usuario_id, a.nome, null as time_id, null as polo_id, null as fgv_id, geral.id as geral_id,
       null as time_descricao, null as polo_descricao, null as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, geral.indice as geral_indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as geral on geral.id = b.hierarquia_id
 where geral.id_tipo_hierarquia_usuario = 1

GO
/****** Object:  View [dbo].[vw_usuario_perfil]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   VIEW [dbo].[vw_usuario_perfil]
AS
SELECT        a.usuario_id, a.nome, time.id AS time_id, polo.id AS polo_id, fgv.id AS fgv_id, geral.id AS geral_id, time.descricao AS time_descricao, polo.descricao AS polo_descricao, fgv.descricao AS fgv_descricao, 
                         geral.descricao AS geral_descricao, time.indice AS time_indice, polo.indice AS polo_indice, fgv.indice AS fgv_indice, geral.indice AS geral_indice, dbo.auth_group.name
FROM            dbo.auth_group INNER JOIN
                         dbo.auth_user_groups ON dbo.auth_group.id = dbo.auth_user_groups.group_id RIGHT OUTER JOIN
                         dbo.usuarios_pessoa AS a INNER JOIN
                         dbo.usuarios_hierarquia_usuarios AS b ON b.user_id = a.usuario_id INNER JOIN
                         dbo.usuarios_hierarquia AS time ON time.id = b.hierarquia_id INNER JOIN
                         dbo.usuarios_hierarquia AS polo ON polo.id = time.id_hierarquia_usuario_pai INNER JOIN
                         dbo.usuarios_hierarquia AS fgv ON fgv.id = polo.id_hierarquia_usuario_pai INNER JOIN
                         dbo.usuarios_hierarquia AS geral ON geral.id = fgv.id_hierarquia_usuario_pai ON dbo.auth_user_groups.user_id = a.id

GO
/****** Object:  View [dbo].[vw_usuarios]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_usuarios] as
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, h1.id as time_id, h2.id as polo_id, h3.id as fgv_id, h4.id as geral_id,
       h1.descricao as time_descricao, h2.descricao as polo_descricao, h3.descricao as fgv_descricao, h4.descricao as geral_descricao,
       h1.indice as time_indice, h2.indice as polo_indice, h3.indice as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id and g.id in (26, 34)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as h1 with (nolock) on h1.id = b.hierarquia_id
       inner join usuarios_hierarquia as h2 with (nolock) on h2.id = h1.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as h3 with (nolock) on h3.id = h2.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id = h3.id_hierarquia_usuario_pai
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, h1.id as time_id, h2.id as polo_id, h3.id as fgv_id, h4.id as geral_id,
       h1.descricao as time_descricao, h2.descricao as polo_descricao, h3.descricao as fgv_descricao, h4.descricao as geral_descricao,
       h1.indice as time_indice, h2.indice as polo_indice, h3.indice as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id and g.id in (25)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as h1 with (nolock) on h1.id_usuario_responsavel = b.user_id
       inner join usuarios_hierarquia as h2 with (nolock) on h2.id = b.hierarquia_id
       inner join usuarios_hierarquia as h3 with (nolock) on h3.id = h2.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id = h3.id_hierarquia_usuario_pai
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, null as time_id, h2.id as polo_id, h3.id as fgv_id, h4.id as geral_id,
       null as time_descricao, h2.descricao as polo_descricao, h3.descricao as fgv_descricao, h4.descricao as geral_descricao,
       null as time_indice, h2.indice as polo_indice, h3.indice as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id and g.id in (30,31)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as h2 with (nolock) on h2.id_usuario_responsavel = b.user_id
       inner join usuarios_hierarquia as h3 with (nolock) on h3.id = b.hierarquia_id
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id = h3.id_hierarquia_usuario_pai
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, null as time_id, null as polo_id, h3.id as fgv_id, h4.id as geral_id,
       null as time_descricao, null as polo_descricao, h3.descricao as fgv_descricao, h4.descricao as geral_descricao,
       null as time_indice, null as polo_indice, h3.indice as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id and g.id in (29)
       inner join usuarios_hierarquia_usuarios b with (nolock) on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as h3 with (nolock) on h3.id_usuario_responsavel = b.user_id
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id = b.hierarquia_id
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, null as time_id, null as polo_id, null as fgv_id, h4.id as geral_id,
       null as time_descricao, null as polo_descricao, null as fgv_descricao, h4.descricao as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, h4.indice as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id
       inner join usuarios_hierarquia as h4 with (nolock) on h4.id_usuario_responsavel = ug.user_id
 where not exists (select top 1 1 from usuarios_hierarquia_usuarios b where b.user_id = a.usuario_id)​
union all
select g.id as group_id, g.name as group_name, a.usuario_id, a.nome, null as time_id, null as polo_id, null as fgv_id, null as geral_id,
       null as time_descricao, null as polo_descricao, null as fgv_descricao, null as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, null as geral_indice
  from usuarios_pessoa a with (nolock)
       inner join auth_user_groups ug on ug.user_id = a.usuario_id
       inner join auth_group g on g.id = ug.group_id
 where not exists (select top 1 1 from usuarios_hierarquia_usuarios b where b.user_id = a.usuario_id)
   and not exists (select top 1 1 from usuarios_hierarquia h where h.id_usuario_responsavel = ug.user_id)

GO
/****** Object:  View [dbo].[vw_usuarios_hierarquia_para_vw_avaliadores]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vw_usuarios_hierarquia_para_vw_avaliadores] as 
select a.usuario_id, a.nome, [time].id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       [time].descricao as time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       [time].indice as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, time.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
       inner join usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
union
select a.usuario_id, a.nome, responsavel.id as time_id, polo.id as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       responsavel.descricao time_descricao, polo.descricao as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, polo.indice as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, polo.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as polo on polo.id = b.hierarquia_id
       inner join usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
       inner join usuarios_hierarquia as responsavel on responsavel.id_usuario_responsavel = a.usuario_id
 where polo.id_tipo_hierarquia_usuario = 3
union
 select a.usuario_id, a.nome, null as time_id, null as polo_id, fgv.id as fgv_id, geral.id as geral_id,
       null as time_descricao, null as polo_descricao, fgv.descricao as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, fgv.indice as fgv_indice, geral.indice as geral_indice, fgv.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as fgv on fgv.id = b.hierarquia_id
       inner join usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai
 where fgv.id_tipo_hierarquia_usuario = 2
union
 select a.usuario_id, a.nome, null as time_id, responsavel.id as polo_id, null as fgv_id, geral.id as geral_id,
       null as time_descricao, responsavel.descricao as polo_descricao, null as fgv_descricao, geral.descricao as geral_descricao,
       null as time_indice, null as polo_indice, null as fgv_indice, geral.indice as geral_indice, geral.indice as indice
  from usuarios_pessoa a
       inner join usuarios_hierarquia_usuarios b on b.user_id = a.usuario_id
       inner join usuarios_hierarquia as geral on geral.id = b.hierarquia_id
       inner join usuarios_hierarquia as responsavel on responsavel.id_usuario_responsavel = a.usuario_id
 where geral.id_tipo_hierarquia_usuario = 1

GO
/****** Object:  View [dbo].[vw_util_current_queries]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_util_current_queries] as
SELECT
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 86400 AS VARCHAR), 2) + ' ' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 3600) % 24 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST((DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) / 60) % 60 AS VARCHAR), 2) + ':' + 
    RIGHT('00' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) % 60 AS VARCHAR), 2) + '.' + 
    RIGHT('000' + CAST(DATEDIFF(SECOND, COALESCE(B.start_time, A.login_time), GETDATE()) AS VARCHAR), 3) 
    AS Duration,
    A.session_id AS session_id,
    B.command,
    CAST('<?query --' + CHAR(10) + (
        SELECT TOP 1 SUBSTRING(X.[text], B.statement_start_offset / 2 + 1, ((CASE
                                                                          WHEN B.statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), X.[text])) * 2)
                                                                          ELSE B.statement_end_offset
                                                                      END
                                                                     ) - B.statement_start_offset
                                                                    ) / 2 + 1
                     )
    ) + CHAR(10) + '--?>' AS XML) AS sql_text,
    CAST('<?query --' + CHAR(10) + X.[text] + CHAR(10) + '--?>' AS XML) AS sql_command,
    A.login_name,
    '(' + CAST(COALESCE(E.wait_duration_ms, B.wait_time) AS VARCHAR(20)) + 'ms)' + COALESCE(E.wait_type, B.wait_type) + COALESCE((CASE 
        WHEN COALESCE(E.wait_type, B.wait_type) LIKE 'PAGEIOLATCH%' THEN ':' + DB_NAME(LEFT(E.resource_description, CHARINDEX(':', E.resource_description) - 1)) + ':' + SUBSTRING(E.resource_description, CHARINDEX(':', E.resource_description) + 1, 999)
        WHEN COALESCE(E.wait_type, B.wait_type) = 'OLEDB' THEN '[' + REPLACE(REPLACE(E.resource_description, ' (SPID=', ':'), ')', '') + ']'
        ELSE ''
    END), '') AS wait_info,
    COALESCE(B.cpu_time, 0) AS CPU,
    COALESCE(F.tempdb_allocations, 0) AS tempdb_allocations,
    COALESCE((CASE WHEN F.tempdb_allocations > F.tempdb_current THEN F.tempdb_allocations - F.tempdb_current ELSE 0 END), 0) AS tempdb_current,
    COALESCE(B.logical_reads, 0) AS reads,
    COALESCE(B.writes, 0) AS writes,
    COALESCE(B.reads, 0) AS physical_reads,
    COALESCE(B.granted_query_memory, 0) AS used_memory,
    NULLIF(B.blocking_session_id, 0) AS blocking_session_id,
    COALESCE(G.blocked_session_count, 0) AS blocked_session_count,
    'KILL ' + CAST(A.session_id AS VARCHAR(10)) AS kill_command,
    (CASE 
        WHEN B.[deadlock_priority] <= -5 THEN 'Low'
        WHEN B.[deadlock_priority] > -5 AND B.[deadlock_priority] < 5 AND B.[deadlock_priority] < 5 THEN 'Normal'
        WHEN B.[deadlock_priority] >= 5 THEN 'High'
    END) + ' (' + CAST(B.[deadlock_priority] AS VARCHAR(3)) + ')' AS [deadlock_priority],
    B.row_count,
    B.open_transaction_count,
    (CASE B.transaction_isolation_level
        WHEN 0 THEN 'Unspecified' 
        WHEN 1 THEN 'ReadUncommitted' 
        WHEN 2 THEN 'ReadCommitted' 
        WHEN 3 THEN 'Repeatable' 
        WHEN 4 THEN 'Serializable' 
        WHEN 5 THEN 'Snapshot'
    END) AS transaction_isolation_level,
    A.[status],
    NULLIF(B.percent_complete, 0) AS percent_complete,
    A.[host_name],
    COALESCE(DB_NAME(CAST(B.database_id AS VARCHAR)), 'master') AS [database_name],
    A.[program_name],
    H.[name] AS resource_governor_group,
    COALESCE(B.start_time, A.last_request_end_time) AS start_time,
    A.login_time,
    COALESCE(B.request_id, 0) AS request_id,
    W.query_plan
FROM
    sys.dm_exec_sessions AS A WITH (NOLOCK)
    LEFT JOIN sys.dm_exec_requests AS B WITH (NOLOCK) ON A.session_id = B.session_id
    JOIN sys.dm_exec_connections AS C WITH (NOLOCK) ON A.session_id = C.session_id AND A.endpoint_id = C.endpoint_id
    LEFT JOIN (
        SELECT
            session_id, 
            wait_type,
            wait_duration_ms,
            resource_description,
            ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY (CASE WHEN wait_type LIKE 'PAGEIO%' THEN 0 ELSE 1 END), wait_duration_ms) AS Ranking
        FROM 
            sys.dm_os_waiting_tasks
    ) E ON A.session_id = E.session_id AND E.Ranking = 1
    LEFT JOIN (
        SELECT
            session_id,
            request_id,
            SUM(internal_objects_alloc_page_count + user_objects_alloc_page_count) AS tempdb_allocations,
            SUM(internal_objects_dealloc_page_count + user_objects_dealloc_page_count) AS tempdb_current
        FROM
            sys.dm_db_task_space_usage
        GROUP BY
            session_id,
            request_id
    ) F ON B.session_id = F.session_id AND B.request_id = F.request_id
    LEFT JOIN (
        SELECT 
            blocking_session_id,
            COUNT(*) AS blocked_session_count
        FROM 
            sys.dm_exec_requests
        WHERE 
            blocking_session_id != 0
        GROUP BY
            blocking_session_id
    ) G ON A.session_id = G.blocking_session_id
    OUTER APPLY sys.dm_exec_sql_text(COALESCE(B.[sql_handle], C.most_recent_sql_handle)) AS X
    OUTER APPLY sys.dm_exec_query_plan(B.[plan_handle]) AS W
    LEFT JOIN sys.dm_resource_governor_workload_groups H ON A.group_id = H.group_id
WHERE
    A.session_id > 50
    AND A.session_id <> @@SPID
    AND (A.[status] != 'sleeping' OR (A.[status] = 'sleeping' AND B.open_transaction_count > 0))

GO
/****** Object:  View [dbo].[vw_util_indexes_to_compact]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_util_indexes_to_compact] as
SELECT DISTINCT 
    C.[name] AS [Schema],
    A.[name] AS Tabela,
    NULL AS Indice,
    'ALTER TABLE [' + C.[name] + '].[' + A.[name] + '] REBUILD PARTITION = ALL WITH (DATA_COMPRESSION = PAGE)' AS Comando
FROM 
    sys.tables                   A
    INNER JOIN sys.partitions    B   ON A.[object_id] = B.[object_id]
    INNER JOIN sys.schemas       C   ON A.[schema_id] = C.[schema_id]
WHERE 
    B.data_compression_desc = 'NONE'
    AND B.index_id = 0 -- HEAP
    AND A.[type] = 'U'
    
UNION
 
SELECT DISTINCT 
    C.[name] AS [Schema],
    B.[name] AS Tabela,
    A.[name] AS Indice,
    'ALTER INDEX [' + A.[name] + '] ON [' + C.[name] + '].[' + B.[name] + '] REBUILD PARTITION = ALL WITH ( STATISTICS_NORECOMPUTE = OFF, ONLINE = OFF, SORT_IN_TEMPDB = OFF, DATA_COMPRESSION = PAGE)'
FROM 
    sys.indexes                  A
    INNER JOIN sys.tables        B   ON A.[object_id] = B.[object_id]
    INNER JOIN sys.schemas       C   ON B.[schema_id] = C.[schema_id]
    INNER JOIN sys.partitions    D   ON A.[object_id] = D.[object_id] AND A.index_id = D.index_id
WHERE
    D.data_compression_desc =  'NONE'
    AND D.index_id <> 0
    AND A.[type] IN (1, 2) -- CLUSTERED e NONCLUSTERED (Rowstore)
    AND B.[type] = 'U'

GO
/****** Object:  View [dbo].[vw_util_list_locks]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   view [dbo].[vw_util_list_locks] as
SELECT
    A.request_session_id AS session_id,
    COALESCE(G.start_time, F.last_request_start_time) AS start_time,
    COALESCE(G.open_transaction_count, F.open_transaction_count) AS open_transaction_count,
    A.resource_database_id,
    DB_NAME(A.resource_database_id) AS dbname,
    (CASE WHEN A.resource_type = 'OBJECT' THEN D.[name] ELSE E.[name] END) AS ObjectName,
    (CASE WHEN A.resource_type = 'OBJECT' THEN D.is_ms_shipped ELSE E.is_ms_shipped END) AS is_ms_shipped,
    --B.index_id,
    --C.[name] AS index_name,
    --A.resource_type,
    --A.resource_description,
    --A.resource_associated_entity_id,
    A.request_mode,
    A.request_status,
    F.login_name,
    F.[program_name],
    F.[host_name],
    G.blocking_session_id
FROM
    sys.dm_tran_locks A WITH(NOLOCK)
    LEFT JOIN sys.partitions B WITH(NOLOCK) ON B.hobt_id = A.resource_associated_entity_id
    LEFT JOIN sys.indexes C WITH(NOLOCK) ON C.[object_id] = B.[object_id] AND C.index_id = B.index_id
    LEFT JOIN sys.objects D WITH(NOLOCK) ON A.resource_associated_entity_id = D.[object_id]
    LEFT JOIN sys.objects E WITH(NOLOCK) ON B.[object_id] = E.[object_id]
    LEFT JOIN sys.dm_exec_sessions F WITH(NOLOCK) ON A.request_session_id = F.session_id
    LEFT JOIN sys.dm_exec_requests G WITH(NOLOCK) ON A.request_session_id = G.session_id
WHERE
    A.resource_associated_entity_id > 0
    AND A.resource_database_id = DB_ID()
    AND A.resource_type = 'OBJECT'
    AND (CASE WHEN A.resource_type = 'OBJECT' THEN D.is_ms_shipped ELSE E.is_ms_shipped END) = 0

GO
/****** Object:  View [dbo].[VwOcorrencia]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   VIEW [dbo].[VwOcorrencia]
AS
SELECT
     ocorrencia.id,
     ocorrencia.usuario_autor_id AS usuario_autor,
     ocorrencia.usuario_responsavel_id AS usuario_responsavel,
     ocorrencia.categoria_id,
     ocorrencia.situacao_id,
     ocorrencia.tipo_id,
     ocorrencia.status_id,
     ocorrencia.data_solicitacao,
     ocorrencia.data_resposta,
     ocorrencia.pergunta,
     ocorrencia.resposta,
     ocorrencia.correcao_id,
     ocorrencia.dados_correcao,
     ocorrencia.competencia1,
     ocorrencia.competencia2,
     ocorrencia.competencia3,
     ocorrencia.competencia4,
     ocorrencia.competencia5,
     pessoa1.nome AS nome_responsavel,
     pessoa2.nome AS nome_autor,
     categoria.descricao AS categoria_descricao,
     situacao.descricao AS situacao_descricao,
     status.descricao AS status_descricao,
     status.icone AS status_icone,
     status.classe AS status_classe,
     tipo.descricao AS tipo_descricao
FROM usuarios_pessoa pessoa1,
     usuarios_pessoa pessoa2,
     ocorrencias_ocorrencia ocorrencia,
     ocorrencias_categoria categoria,
     ocorrencias_situacao situacao,
     ocorrencias_status status,
     ocorrencias_tipo tipo
WHERE pessoa1.usuario_id = ocorrencia.usuario_responsavel_id
AND pessoa2.usuario_id = ocorrencia.usuario_autor_id
AND status.id = ocorrencia.status_id
AND situacao.id = ocorrencia.situacao_id
AND tipo.id = ocorrencia.tipo_id
AND categoria.id = ocorrencia.categoria_id;

GO
/****** Object:  StoredProcedure [dbo].[rebuild_indices]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[rebuild_indices] as
begin
    exec sp_foreach_table_azure @command1="ALTER INDEX ALL ON ? REORGANIZE ; "
    exec sp_foreach_table_azure @command1="ALTER INDEX ALL ON ? REBUILD ; "
    exec sp_foreach_table_azure @command1="UPDATE STATISTICS ? ; "
end

GO
/****** Object:  StoredProcedure [dbo].[sp_avalia_aproveitamento]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_avalia_aproveitamento]
    @REDACAO_ID INT,
	@ID_PROJETO INT
	AS

DECLARE @CONCLUSAO1 INT
DECLARE @CONCLUSAO2 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @APROVEITAMENTO1 INT
DECLARE @APROVEITAMENTO2 INT
DECLARE @DIFERENCA_NOTAFINAL1 FLOAT
DECLARE @DIFERENCA_NOTAFINAL2 FLOAT
DECLARE @ID_ANALISE1 INT
DECLARE @ID_ANALISE2 INT
DECLARE @SITUACAO1 INT
DECLARE @SITUACAO2 INT
DECLARE @SITUACAO3 INT
DECLARE @DIFERENCA_SITUACAO1 INT
DECLARE @DIFERENCA_SITUACAO2 INT

select @CONCLUSAO1 = ANA1.conclusao_analise,
       @CONCLUSAO2 = ANA2.conclusao_analise,
	   @ID_CORRECAO1 = ANA1.id_correcao_A,
	   @ID_CORRECAO2 = ANA2.id_correcao_A,
	   @DIFERENCA_NOTAFINAL1   = ANA1.diferenca_nota_final,
	   @DIFERENCA_NOTAFINAL2   = ANA2.diferenca_nota_final,
	   @ID_ANALISE1  = ANA1.ID,
	   @ID_ANALISE2  = ANA2.ID,
	   @SITUACAO1    = ANA1.id_correcao_situacao_A,
	   @SITUACAO2    = ANA2.ID_CORRECAO_SITUACAO_A,
	   @SITUACAO3    = ANA2.id_correcao_situacao_B,
	   @DIFERENCA_SITUACAO1 = ANA1.diferenca_situacao,
	   @DIFERENCA_SITUACAO2 = ANA2.diferenca_situacao

from correcoes_analise ana1 join correcoes_analise ana2 on (ana1.redacao_id = ana2.redacao_id and
                                                            ana1.id_projeto       = ana2.id_projeto AND
															ANA1.id_tipo_correcao_B = ANA2.id_tipo_correcao_B)
  where ana1.id_tipo_correcao_A = 1 and
        ana2.id_tipo_correcao_A = 2 and
		ana2.id_tipo_correcao_B = 3 AND
		ana2.redacao_id = @REDACAO_ID AND
		ANA1.id_projeto = @ID_PROJETO



	SET @APROVEITAMENTO1 = -1
	SET @APROVEITAMENTO2 = -1

    -- SE A TERCERIA CORRECAO FOR SITUACAO ENTAO UMA DAS DUAS
	-- ANTERIORES DEVERAM SER SITUACAO IGUAL PARA APROVEITAMENTO SENAO DESCARTE AS DUAS ANTERIORES
	IF(@CONCLUSAO1 = 0 AND @CONCLUSAO2 = 0)  --*** CRAVOU
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 1
        END
	ELSE IF (@CONCLUSAO1 = 0)  --*** APENAS O PRIMEIRO CRAVOU
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 0
		END
	ELSE IF (@CONCLUSAO2 = 0) --*** APENAS O SEGUNDO CRAVOU
		BEGIN
			SET @APROVEITAMENTO1 = 0
			SET @APROVEITAMENTO2 = 1
		END
	ELSE IF (@CONCLUSAO1 >=3 AND @CONCLUSAO2 >= 3) --*** SE OS DOIS DISCREPARAM
		BEGIN
			SET @APROVEITAMENTO1 = 0
			SET @APROVEITAMENTO2 = 0
		END
	ELSE IF (@CONCLUSAO1 >= 3)  --*** SE APENAS O PRIMEIRO DISCREPOU
		BEGIN
			SET @APROVEITAMENTO1 = 0
			SET @APROVEITAMENTO2 = 1
		END
	ELSE IF (@CONCLUSAO2 >= 3)  --*** SE APENAS O SEGUNDO DISCREPOU
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 0
		END
	ELSE IF (@DIFERENCA_NOTAFINAL1 > @DIFERENCA_NOTAFINAL2) --*** SE NAO HOUVE DISCREPANCIA E A DIFERENCA1 E MAIOR QUE A DIFERENCA2
		BEGIN
			SET @APROVEITAMENTO1 = 0
			SET @APROVEITAMENTO2 = 1
		END
	ELSE IF (@DIFERENCA_NOTAFINAL1 < @DIFERENCA_NOTAFINAL2) --*** SE NAO HOUVE DISCREPANCIA E A DIFERENCA2 E MAIOR QUE A DIFERENCA1
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 0
		END
	ELSE IF (@DIFERENCA_NOTAFINAL1 = @DIFERENCA_NOTAFINAL2) --*** SE NAO HOUVE DISCREPANCIA E A DIFERENCA1 E IGUAL QUE A DIFERENCA2
		BEGIN
			SET @APROVEITAMENTO1 = 1
			SET @APROVEITAMENTO2 = 1
		END

	IF(@APROVEITAMENTO1 <> -1 AND @APROVEITAMENTO2 <> -1)
		BEGIN
			UPDATE CORRECOES_ANALISE SET aproveitamento = @APROVEITAMENTO1
			WHERE ID= @ID_ANALISE1 AND
					id_status_B = 3

			UPDATE CORRECOES_ANALISE SET aproveitamento = @APROVEITAMENTO2
			WHERE ID= @ID_ANALISE2 AND
					id_status_B = 3
		END

GO
/****** Object:  StoredProcedure [dbo].[sp_bloqueio]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************************************************
*                                              PROCEDURE BLOQUEIOS                                               *
*                                                                                                                *
*  PROCEDURE QUE ENCONTRA UM BLOQUEIO MATA SUA OCORRENCIA LIBERANDO O BANCO E GRAVA EM UMA TABELA DE LOG CHAMADA *
*  LOG_BLOQUEIO                                                                                                  *
*                                                                                                                *
* BANCO_SISTEMA : ENCCEJA                                                                                        *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:04/09/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:04/09/2018 *
******************************************************************************************************************/

CREATE   PROCEDURE [dbo].[sp_bloqueio] as 

CREATE TABLE #TEMP(
        SPID INT, Status VARCHAR(MAX), LOGIN VARCHAR(MAX), HostName VARCHAR(MAX), BlkBy VARCHAR(MAX),
        DBName VARCHAR(MAX), Command VARCHAR(MAX), CPUTime INT, DiskIO INT, LastBatch VARCHAR(MAX),
        ProgramName VARCHAR(MAX), SPID_1 INT, REQUESTID INT
)

INSERT INTO #TEMP EXEC sp_who2

DECLARE @BLOQUEIO VARCHAR(100)
DECLARE @HOSTNAME VARCHAR(500)
DECLARE @COMANDO VARCHAR(500)
DECLARE @ERRO    VARCHAR(MAX)
DECLARE @BANCO   VARCHAR(1000)
DECLARE @USUARIO VARCHAR(1000)
declare @data    datetime

DECLARE @BLOQUEIO_f VARCHAR(100)
DECLARE @HOSTNAME_f VARCHAR(500)
DECLARE @COMANDO_f VARCHAR(500)
DECLARE @ERRO_f    VARCHAR(MAX)
DECLARE @BANCO_f   VARCHAR(1000)
DECLARE @USUARIO_f VARCHAR(1000)

SELECT @BLOQUEIO = TP.spid, @HOSTNAME = TP.HostName, @BANCO = TP.DBName, @USUARIO = TP.LOGIN FROM #TEMP TP WHERE TP.SPID IN (
select TMP.BlkBy from #TEMP TMP JOIN sys.sysprocesses AUX ON (TMP.SPID = AUX.SPID)
WHERE TMP.BlkBy <> '  .' and aux.waittime >= 10000)
      AND TP.BlkBy = '  .'
	  
	  SELECT @ERRO = EVENT_INFO FROM sys.dm_exec_input_buffer(@bloqueio, 0);

IF(@@ROWCOUNT > 0)
	BEGIN
		set @data = getdate()
		INSERT LOG_BLOQUEIO 
		SELECT @BLOQUEIO, @HOSTNAME, @ERRO,  @data, @BANCO, @USUARIO

	declare cur_loc cursor for 
	select TmP.spid, TmP.HostName, TmP.DBName, tmp.LOGIN 
	from #TEMP TMP 
                 WHERE TMP.BlkBy <> '  .'
				  
	open cur_loc 
		fetch next from cur_loc into @BLOQUEIO_f, @HOSTNAME_f,  @BANCO_f, @USUARIO_f
		while @@FETCH_STATUS = 0
			BEGIN
			   SELECT @ERRO_f = EVENT_INFO FROM sys.dm_exec_input_buffer(@bloqueio_f, 0);

				insert into log_bloqueio_filha values (@bloqueio, @BLOQUEIO_f, @HOSTNAME_f,isnull( @ERRO_f,'*****'),  @data, @BANCO_f, @USUARIO_f)


			fetch next from cur_loc into @BLOQUEIO_f, @HOSTNAME_f, @BANCO_f, @USUARIO_f
			END
		close cur_loc 
	deallocate cur_loc 


		 set @comando = 'kill '+convert(char,@BLOQUEIO)
				   execute (@comando)
	end

DROP TABLE #TEMP
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[sp_busca_mais_um]
	@AVALIADOR_ID bigint,
	@ID_PROJETO INT,
	@CORRECAO_ID bigint OUTPUT
AS

SET @CORRECAO_ID = 0

     DECLARE @ID bigint

     DECLARE @ID_GRUPO_CORRETOR bigint
     DECLARE @FILA              bigint
     DECLARE @FILA_SUPERVISOR   int     /*** FILA ONDE O SUPERVISOR IRA BUSCAR CORRECOES A SEREM FEITAS - DENFINIDO POR PROJETO ***/
     DECLARE @FILA_PRIORIDADE   int     /*** A PARTIR DE QUAL FILA SERA INICIADO A BUSCA DE UMA CORRECAO PARA O AVALIADOR SOLICITANTE - DENFINIDO POR PROJETO ***/
     DECLARE @ID_PERFIL         bigint  /*** BUSCAR O PERFIL DE PERMISSAO {SUPERVISOR DE HOMOLOGAÇÃO, SUPERVISOR, AVALIADOR}  ***/
     DECLARE @LIMITE            int     /*** CASO O AVALIADOR SEJA SUPERVISOR O LIMITE E A FILA_SUPERVISOR SENAO SERA A ULTIMA DA LISTA A SER TESTADA  */
	 DECLARE @PODE_CORRIGIR_1   int
	 DECLARE @PODE_CORRIGIR_2   int
	 DECLARE @PODE_CORRIGIR_3   int
	 DECLARE @PODE_CORRIGIR_4   int
	 DECLARE @COMANDO           VARCHAR(2000)
	 DECLARE @QTD_CORRECOES     INT

     SET NOCOUNT ON;

     SET @CORRECAO_ID   = 0
	 SET @QTD_CORRECOES = 0

	 /********** BUSCAR O PERFIL DO CORRETOR  *****/
     SELECT
            @ID_PERFIL = GROUP_ID,
            @ID_GRUPO_CORRETOR = grupo_corretor,
			@PODE_CORRIGIR_1 = PODE_CORRIGIR_1,
			@PODE_CORRIGIR_2 = PODE_CORRIGIR_2,
			@PODE_CORRIGIR_3 = PODE_CORRIGIR_3,
			@PODE_CORRIGIR_4 = PODE_CORRIGIR_4

      FROM
		    vw_cor_usuario_grupo with (nolock)
     WHERE
	        ID_USUARIO = @AVALIADOR_ID


	 /**********                     BUSCAR CONFIGURACOES DO PROJETO                             *****/
     /*******************************************************************************************************
   	   SE O AVALIADOR TIVER O PERFIL DE SUPERVISOR ESTE PODERA CORRIGIR SOMENTE AS REDACOES DA FILA DEFINIDA
   	  *******************************************************************************************************/

     SELECT
            @FILA_SUPERVISOR = FILA_SUPERVISOR,
            @FILA_PRIORIDADE = FILA_PRIORITARIA,
			@FILA   = CASE WHEN @ID_PERFIL in (25,31) THEN FILA_SUPERVISOR ELSE FILA_PRIORITARIA END,
			@LIMITE = CASE WHEN @ID_PERFIL in (25,31) THEN FILA_SUPERVISOR ELSE 1                END

     FROM
		    PROJETO_PROJETO with (nolock)
     WHERE
	        ID = @ID_PROJETO


     /********** BUSCAR SE JA EXISTE ALGUMA CORRECAO NA FILA ATUAL COM ATUAL = 1 PARA O AVALIADOR  *****/
     SELECT TOP 1
            @CORRECAO_ID = id_correcao
     FROM
	        correcoes_filapessoal with (nolock)
     WHERE
	        id_corretor = @AVALIADOR_ID AND
			id_projeto  = @ID_PROJETO
     ORDER BY ATUAL DESC, id
     IF @@ROWCOUNT = 1
     BEGIN
          UPDATE correcoes_filapessoal
          SET ATUAL = 1
          WHERE
		         id_corretor = @AVALIADOR_ID
                 AND ATUAL = 0
                 AND id_correcao = @CORRECAO_ID
				 AND id_projeto  = @ID_PROJETO

		  IF (@CORRECAO_ID > 0)
				begin

					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end

          UPDATE correcoes_correcao
          SET data_inicio = dbo.getlocaldate()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
				 AND id_projeto  = @ID_PROJETO
     END
	
	 -- ****** busca na fila ouro
	 if (@CORRECAO_ID = 0)
		begin
		    EXEC sp_busca_mais_um_na_filaOuro  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
					-- **** setar data de inicio na tabela de correcoes_redacao  *****
					update red set red.data_inicio = cor.data_inicio, red.id_status = 2
					from correcoes_redacao red join correcoes_correcao cor on (cor.redacao_id = red.id)
					 where cor.id  = @CORRECAO_ID  and 
						   red.data_inicio is null
				end
		end
	 -- ****** busca na fila moda
	 if (@CORRECAO_ID = 0)
		begin
		    EXEC sp_busca_mais_um_na_filaModa  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
					-- **** setar data de inicio na tabela de correcoes_redacao  *****
					update red set red.data_inicio = cor.data_inicio, red.id_status = 2 
					from correcoes_redacao red join correcoes_correcao cor on (cor.redacao_id = red.id)
					 where cor.id  = @CORRECAO_ID  and 
						   red.data_inicio is null
				end
		end
		
	IF(@CORRECAO_ID = 0)
		BEGIN
			--BEGIN TRANSACTION
				--BEGIN TRY
					WHILE (@FILA >= @LIMITE AND @CORRECAO_ID = 0 )
						BEGIN
							IF(@FILA = 1 AND @PODE_CORRIGIR_1 = 1)
								BEGIN
									EXEC sp_busca_mais_um_na_fila1 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
									-- **** setar data de inicio na tabela de correcoes_redacao  *****
									update red set red.data_inicio = cor.data_inicio, red.id_status = 2 
									from correcoes_redacao red join correcoes_correcao cor on (cor.redacao_id = red.id)
									 where cor.id  = @CORRECAO_ID  and 
										   red.data_inicio is null
								END
							ELSE IF (@FILA = 2 AND @PODE_CORRIGIR_2 = 1)
								BEGIN
									EXEC sp_busca_mais_um_na_fila2 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END
							ELSE IF (@FILA = 3 AND @PODE_CORRIGIR_3 = 1)
								BEGIN
									EXEC sp_busca_mais_um_na_fila3 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END
							ELSE IF (@FILA = 4 AND @PODE_CORRIGIR_4 = 1)
								BEGIN							    
									EXEC sp_busca_mais_um_na_fila4 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
								END

							set @FILA = @FILA - 1
						END

					IF (@CORRECAO_ID > 0)
						begin
							insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
						end
					--COMMIT TRANSACTION
				--END TRY
				--BEGIN CATCH
				--	SET @CORRECAO_ID = -1

				--END CATCH
		END
    SET NOCOUNT OFF;
RETURN

 
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_auditoria]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_auditoria]
	@AVALIADOR_ID bigint,
	@ID_PROJETO INT,
	@TIPO_BUSCA INT,
	@CORRECAO_ID bigint OUTPUT
AS

SET @CORRECAO_ID = 0

     DECLARE @ID bigint
	 DECLARE @ROW INT

     DECLARE @ID_GRUPO_CORRETOR bigint
     DECLARE @FILA              bigint
     DECLARE @FILA_SUPERVISOR   int     /*** FILA ONDE O SUPERVISOR IRA BUSCAR CORRECOES A SEREM FEITAS - DENFINIDO POR PROJETO ***/
     DECLARE @FILA_PRIORIDADE   int     /*** A PARTIR DE QUAL FILA SERA INICIADO A BUSCA DE UMA CORRECAO PARA O AVALIADOR SOLICITANTE - DENFINIDO POR PROJETO ***/
     DECLARE @ID_PERFIL         bigint  /*** BUSCAR O PERFIL DE PERMISSAO {SUPERVISOR DE HOMOLOGAÇÃO, SUPERVISOR, AVALIADOR}  ***/
     DECLARE @LIMITE            int     /*** CASO O AVALIADOR SEJA SUPERVISOR O LIMITE E A FILA_SUPERVISOR SENAO SERA A ULTIMA DA LISTA A SER TESTADA  */
	 DECLARE @PODE_CORRIGIR_1   int
	 DECLARE @PODE_CORRIGIR_2   int
	 DECLARE @PODE_CORRIGIR_3   int
	 DECLARE @COMANDO           VARCHAR(2000)
	 DECLARE @QTD_CORRECOES     INT

     SET NOCOUNT ON;

     SET @CORRECAO_ID   = 0
	 SET @QTD_CORRECOES = 0

	 /********** BUSCAR O PERFIL DO CORRETOR  *****/
     SELECT
            @ID_PERFIL = GROUP_ID,
            @ID_GRUPO_CORRETOR = grupo_corretor,
			@PODE_CORRIGIR_1 = PODE_CORRIGIR_1,
			@PODE_CORRIGIR_2 = PODE_CORRIGIR_2,
			@PODE_CORRIGIR_3 = PODE_CORRIGIR_3
      FROM
		    vw_cor_usuario_grupo with (nolock)
     WHERE
	        ID_USUARIO = @AVALIADOR_ID


	 /**********                     BUSCAR CONFIGURACOES DO PROJETO                             *****/
     /*******************************************************************************************************
   	   SE O AVALIADOR TIVER O PERFIL DE SUPERVISOR ESTE PODERA CORRIGIR SOMENTE AS REDACOES DA FILA DEFINIDA
   	  *******************************************************************************************************/

     SELECT
            @FILA_SUPERVISOR = FILA_SUPERVISOR,
            @FILA_PRIORIDADE = FILA_PRIORITARIA,
			@FILA   = CASE WHEN @ID_PERFIL = 25 THEN FILA_SUPERVISOR ELSE FILA_PRIORITARIA END,
			@LIMITE = CASE WHEN @ID_PERFIL = 25 THEN FILA_SUPERVISOR ELSE 1                END

     FROM
		    PROJETO_PROJETO with (nolock)
     WHERE
	        ID = @ID_PROJETO


     /********** BUSCAR SE JA EXISTE ALGUMA CORRECAO NA FILA ATUAL COM ATUAL = 1 PARA O AVALIADOR  *****/
     SELECT TOP 1
            @CORRECAO_ID = PES.id_correcao
     FROM
	        correcoes_filapessoal pes with (nolock) JOIN CORRECOES_CORRECAO COR with (nolock) ON (PES.ID_CORRECAO = COR.ID AND
		                                                                                          PES.id_projeto  = COR.ID_PROJETO)
     WHERE
	        PES.id_corretor = @AVALIADOR_ID AND
			PES.id_projeto  = @ID_PROJETO   AND
			PES.id_tipo_correcao = 7        AND
			COR.TIPO_AUDITORIA_ID = @TIPO_BUSCA
     ORDER BY PES.ATUAL DESC, PES.id
	 SET @ROW =  @@ROWCOUNT

     IF (@ROW = 1)
     BEGIN
          UPDATE correcoes_filapessoal
          SET ATUAL = 1
          WHERE
		         id_corretor = @AVALIADOR_ID
                 AND ATUAL = 0
                 AND id_correcao = @CORRECAO_ID
				 AND id_projeto  = @ID_PROJETO

		  IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (getdate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end

          UPDATE correcoes_correcao
          SET data_inicio = GETDATE()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
				 AND id_projeto  = @ID_PROJETO
     END

	IF(@CORRECAO_ID = 0)
		BEGIN

			EXEC SP_BUSCA_MAIS_UM_NA_FILAAUDITORIA @AVALIADOR_ID,@ID_PROJETO,@ID_GRUPO_CORRETOR,@TIPO_BUSCA, @CORRECAO_ID output

			IF (@CORRECAO_ID > 0)
				begin
					insert correcoes_historicocorrecao values (getdate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
				end
		END
	 SET NOCOUNT OFF;
RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1]    Script Date: 10/09/2019 20:29:00 ******/
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_fila1]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
	 DECLARE @ROWS INT
	 DECLARE @REDACAO_ID INT

	 SET NOCOUNT ON;


     SET @CORRECAO_ID = 0


		BEGIN TRANSACTION

			BEGIN TRY

               SELECT TOP 1
                      @ID = id,
                      @CO_BARRA_REDACAO = co_barra_redacao,
                      @REDACAO_ID = redacao_id
               FROM
			          correcoes_fila1 WITH (UPDLOCK, READPAST)
               WHERE
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%') AND
                      CASE
                           WHEN @ID_GRUPO_CORRETOR = 2 THEN 2
                           WHEN @ID_GRUPO_CORRETOR = 1 THEN 3
                           WHEN @ID_GRUPO_CORRETOR IS NULL THEN 3
                      END > ISNULL(id_grupo_corretor, 0)
               ORDER BY id;
			SET @ROWS = @@ROWCOUNT

               IF (@ROWS = 0)
					BEGIN
						IF NOT EXISTS (SELECT 1
										FROM correcoes_fila1 WITH (UPDLOCK, READPAST)
									   WHERE id = @ID AND
									         id_projeto = @ID_PROJETO)
							BEGIN
								 SET @CORRECAO_ID = 0

							END
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						  FROM  correcoes_redacao crd with (nolock)
						 WHERE  crd.id = @REDACAO_ID

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/

						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									1,
									co_barra_redacao,
									@AVALIADOR_ID,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_fila1 cor with (nolock)
								WHERE id = @ID

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/**** INSERIR NA LISTA 2				 *****/
						if(exists(select 1 from projeto_projeto where id = @ID_PROJETO and fila_prioritaria >=2))
							begin
								INSERT INTO correcoes_fila2 (corrigido_por, id_grupo_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
										SELECT
											DBO.FN_COR_CORRETOR_REDACAO(co_barra_redacao),
											@ID_GRUPO_CORRETOR,
											@CORRECAO_ID,
											co_barra_redacao,
											@ID_PROJETO,
                                            @REDACAO_ID
										FROM correcoes_fila1 fl1 with (nolock)
									   WHERE id = @ID AND
									         not exists (select top 1 1 from correcoes_correcao corx
											              where corx.redacao_id = fl1.redacao_id and
																corx.id_tipo_correcao = 2)

							end

						/****** FIM DANDO CARGA NA TABELA CORRECAO_FILAPESSOAL E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO_POR_ID(@REDACAO_ID), @ID_GRUPO_CORRETOR, 1, 1, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA 1   *****/
						DELETE FROM correcoes_fila1
						WHERE id = @id
					END
				COMMIT
			END TRY
			BEGIN CATCH

				ROLLBACK
			END CATCH

        SET NOCOUNT OFF;

	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila1_teste]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_fila1_teste]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
	 DECLARE @ROWS INT
	 DECLARE @REDACAO_ID INT

print 'passou 9.1: ' + convert(varchar(100), dbo.getlocaldate())
	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0

		BEGIN TRANSACTION

			BEGIN TRY

               SELECT TOP 1
                      @ID = id,
                      @CO_BARRA_REDACAO = co_barra_redacao,
                      @REDACAO_ID = redacao_id
               FROM
			          correcoes_fila1 WITH (UPDLOCK, READPAST)
               WHERE
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%') AND
                      CASE
                           WHEN @ID_GRUPO_CORRETOR = 2 THEN 2
                           WHEN @ID_GRUPO_CORRETOR = 1 THEN 3
                           WHEN @ID_GRUPO_CORRETOR IS NULL THEN 3
                      END > ISNULL(id_grupo_corretor, 0)
               ORDER BY id;
print 'passou 9.2: ' + convert(varchar(100), dbo.getlocaldate())
			SET @ROWS = @@ROWCOUNT

               IF (@ROWS = 0)
					BEGIN
print 'passou 9.3: ' + convert(varchar(100), dbo.getlocaldate())
						IF NOT EXISTS (SELECT 1
										FROM correcoes_fila1 WITH (UPDLOCK, READPAST)
									   WHERE id = @ID AND
									         id_projeto = @ID_PROJETO)
							BEGIN
								 SET @CORRECAO_ID = 0

							END
print 'passou 9.4: ' + convert(varchar(100), dbo.getlocaldate())
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
print 'passou 9.5: ' + convert(varchar(100), dbo.getlocaldate())
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						  FROM  correcoes_redacao crd with (nolock)
						 WHERE  crd.id = @REDACAO_ID
print 'passou 9.6: ' + convert(varchar(100), dbo.getlocaldate())

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/

						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									1,
									co_barra_redacao,
									@AVALIADOR_ID,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_fila1 cor with (nolock)
								WHERE id = @ID
print 'passou 9.7: ' + convert(varchar(100), dbo.getlocaldate())

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/**** INSERIR NA LISTA 2				 *****/
						if(exists(select 1 from projeto_projeto where id = @ID_PROJETO and fila_prioritaria >=2))
							begin
print 'passou 9.8: ' + convert(varchar(100), dbo.getlocaldate())
								INSERT INTO correcoes_fila2 (corrigido_por, id_grupo_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
										SELECT
											DBO.FN_COR_CORRETOR_REDACAO(co_barra_redacao),
											@ID_GRUPO_CORRETOR,
											@CORRECAO_ID,
											co_barra_redacao,
											@ID_PROJETO,
                                            @REDACAO_ID
										FROM correcoes_fila1 fl1 with (nolock)
									   WHERE id = @ID AND
									         not exists (select top 1 1 from correcoes_correcao corx
											              where corx.redacao_id = fl1.redacao_id and
																corx.id_tipo_correcao = 2)

print 'passou 9.9: ' + convert(varchar(100), dbo.getlocaldate())
							end

						/****** FIM DANDO CARGA NA TABELA CORRECAO_FILAPESSOAL E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO_POR_ID(@REDACAO_ID), @ID_GRUPO_CORRETOR, 1, 1, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)
print 'passou 9.10: ' + convert(varchar(100), dbo.getlocaldate())

						/******* DELETAR O REGISTRO NA FILA 1   *****/
						DELETE FROM correcoes_fila1
						WHERE id = @id
print 'passou 9.11: ' + convert(varchar(100), dbo.getlocaldate())
					END
				COMMIT
			END TRY
			BEGIN CATCH

				ROLLBACK
			END CATCH

        SET NOCOUNT OFF;

	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila2]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_fila2]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@CORRECAO_ID int OUTPUT

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
     DECLARE @REDACAO_ID int

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0

			BEGIN TRY
		BEGIN TRANSACTION

               SELECT TOP 1
                      @ID = id,
                      @CO_BARRA_REDACAO = co_barra_redacao,
                      @REDACAO_ID = redacao_id
               FROM
			          correcoes_fila2 WITH (UPDLOCK, READPAST)
               WHERE
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%') AND
                      CASE
                           WHEN @ID_GRUPO_CORRETOR = 2 THEN 2
                           WHEN @ID_GRUPO_CORRETOR = 1 THEN 3
                           WHEN @ID_GRUPO_CORRETOR IS NULL THEN 3
                      END > ISNULL(id_grupo_corretor, 0)
               ORDER BY id

               IF (@@ROWCOUNT = 0)
					BEGIN
						IF NOT EXISTS (SELECT 1
										FROM correcoes_fila2 WITH (UPDLOCK, READPAST)
									   WHERE id = @ID AND
									         id_projeto = @ID_PROJETO)
							BEGIN
								 SET @CORRECAO_ID = 0

							END
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						FROM correcoes_redacao crd with (nolock)
						WHERE crd.id = @REDACAO_ID

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									2,
									co_barra_redacao,
									@AVALIADOR_ID,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_fila2 cor with (nolock)
								WHERE id = @ID

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()


						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 2, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA 2   *****/
						DELETE FROM correcoes_fila2
						WHERE id = @id
					END
				COMMIT
			END TRY
			BEGIN CATCH
				print error_message()
				ROLLBACK
			END CATCH

        SET NOCOUNT OFF;

	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila3]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_fila3]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR int,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_DESENTORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
     DECLARE @REDACAO_ID int
	 DECLARE @USA_CONSISTENCIA_AUDITORIA INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
	 SELECT @USA_CONSISTENCIA_AUDITORIA = ativo FROM core_feature where codigo = 'checar_consistencia_auditoria'

          BEGIN TRY
          BEGIN TRANSACTION


               SELECT TOP 1
                    @ID = id,
                    @CO_BARRA_REDACAO = co_barra_redacao,
                    @REDACAO_ID = redacao_id
               FROM correcoes_fila3 WITH (UPDLOCK, READPAST)
               WHERE
			         consistido = 1 and
					 (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and 
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%')
               ORDER BY id;

               IF @@ROWCOUNT = 0
				   BEGIN
						IF NOT EXISTS (SELECT  1
							 FROM correcoes_fila3 WITH (UPDLOCK, READPAST)
							 WHERE id = @ID)
						BEGIN
							SET @CORRECAO_ID = 0
						END

				   END
               ELSE
				   BEGIN

						/****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********/
						/***** BUSCANDO AS INFORMACOES DA REDACAO ******/
						SELECT
							 @LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
							 @LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL,
							 @ID_PROJETO = id_projeto
						FROM correcoes_redacao crd
						WHERE crd.id = @REDACAO_ID

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
							 SELECT
								  dbo.getlocaldate(),
								  @LINK_IMAGEM_RECORTADA,
								  @LINK_IMAGEM_ORIGINAL,
								  1,
								  3,
								  co_barra_redacao,
								  @AVALIADOR_ID,
								  @ID_PROJETO,
                                  @REDACAO_ID
							 FROM correcoes_fila3 cor
							 WHERE id = @ID

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/**** INSERIR NA LISTA 4				 *****/
						--if(exists(select top 1 1 from projeto_projeto where id = @ID_PROJETO and fila_prioritaria >=4))
						--	begin
						--		INSERT INTO correcoes_fila4 (corrigido_por, id_grupo_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
						--				SELECT
						--					DBO.FN_COR_CORRETOR_REDACAO(co_barra_redacao),
						--					@ID_GRUPO_CORRETOR,
						--					@CORRECAO_ID,
						--					co_barra_redacao,
						--					@ID_PROJETO,
      --                                      @REDACAO_ID
						--				FROM correcoes_fila3 fl3 with (nolock)
						--			WHERE id = @ID AND
						--			         not exists (select top 1 1 from correcoes_correcao corx
						--					              where corx.redacao_id = fl3.redacao_id and
						--										corx.id_tipo_correcao = 4)
						--	end



						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/

						/****** INSERIR NA LISTA PESSOAL  *****/
						/****** SELECT * FROM correcoes_filapessoal ******/

						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
							 VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 3, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/***** DELETAR O REGISTRO NA FILA 3   *****/
						DELETE FROM correcoes_fila3
						WHERE consistido = 1 and
					          (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
			                  id_projeto = @ID_PROJETO and 
					          id = @id
				   END
		COMMIT
     END TRY
     BEGIN CATCH
          ROLLBACK
     END CATCH

	 SET NOCOUNT OFF;
  RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_fila4]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_fila4]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR int,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
     DECLARE @REDACAO_ID int
     DECLARE @USA_CONSISTENCIA_AUDITORIA int

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
	 
	 SELECT @USA_CONSISTENCIA_AUDITORIA = ativo FROM core_feature where codigo = 'checar_consistencia_auditoria'

          BEGIN TRY
			BEGIN TRANSACTION

               SELECT TOP 1
                    @ID = id,
                    @CO_BARRA_REDACAO = co_barra_redacao,
                    @REDACAO_ID = redacao_id
               FROM correcoes_fila4 WITH (UPDLOCK, READPAST)
               WHERE
			         consistido = 1 and
					 (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
			         id_projeto = @ID_PROJETO  and
					 (corrigido_por IS NULL or CORRIGIDO_POR NOT LIKE '%,' + CONVERT(varchar(20), @AVALIADOR_ID) + ',%')
               ORDER BY id;

               IF @@ROWCOUNT = 0
				   BEGIN
						IF NOT EXISTS (SELECT  1
							 FROM correcoes_fila4 WITH (UPDLOCK, READPAST)
							 WHERE id = @ID)
						BEGIN
							SET @CORRECAO_ID = 0
						END

				   END
               ELSE
				   BEGIN

						/****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********/
						/***** BUSCANDO AS INFORMACOES DA REDACAO ******/
						SELECT
							 @LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
							 @LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL,
							 @ID_PROJETO = id_projeto
						FROM correcoes_redacao crd with (nolock)
						WHERE crd.id = @REDACAO_ID


						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
							 SELECT
								  dbo.getlocaldate(),
								  @LINK_IMAGEM_RECORTADA,
								  @LINK_IMAGEM_ORIGINAL,
								  1,
								  4,
								  co_barra_redacao,
								  @AVALIADOR_ID,
								  @ID_PROJETO,
                                  @REDACAO_ID
							 FROM correcoes_fila4 cor with (nolock)
							 WHERE id = @ID


						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()


						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/

						/****** INSERIR NA LISTA PESSOAL  *****/
						/****** SELECT * FROM correcoes_filapessoal ******/

						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
							 VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 4, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/***** DELETAR O REGISTRO NA FILA 4   *****/
						DELETE FROM correcoes_fila4
						WHERE consistido = 1 and
					          (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
			                  id_projeto = @ID_PROJETO and 
					          id = @id

				   END
		COMMIT
     END TRY
     BEGIN CATCH
          ROLLBACK
     END CATCH

	 SET NOCOUNT OFF;
 RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaauditoria]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE     procedure [dbo].[sp_busca_mais_um_na_filaauditoria]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@TIPO_BUSCA INT,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
	 declare @ROW INT
	 declare @REDACAO_ID INT
     DECLARE @USA_CONSISTENCIA_AUDITORIA int

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
	 
	 SELECT @USA_CONSISTENCIA_AUDITORIA = ativo FROM core_feature where codigo = 'checar_consistencia_auditoria'

		BEGIN TRANSACTION

			BEGIN TRY

               SELECT TOP 1
                      @ID = id, @CORRECAO_ID = isnull(id_correcao,0),
                      @CO_BARRA_REDACAO = co_barra_redacao,
                      @REDACAO_ID = redacao_id
               FROM
			          correcoes_filaauditoria WITH (UPDLOCK, READPAST)
               WHERE
			         consistido = 1 and
					 (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
			         id_projeto = @ID_PROJETO  and
					 (id_corretor IS NULL or ID_CORRETOR = @AVALIADOR_ID) and
					 tipo_id = @TIPO_BUSCA

               ORDER BY pendente, id;
			   SET @ROW = @@ROWCOUNT

               IF ( @ROW = 0)
					BEGIN
						IF NOT EXISTS (SELECT 1
										FROM correcoes_filaauditoria WITH (UPDLOCK, READPAST)
									   WHERE id = @ID AND
									         id_projeto = @ID_PROJETO)
							BEGIN
								 SET @CORRECAO_ID = 0

							END
					END
				ELSE
					BEGIN
						IF(@CORRECAO_ID = 0)
							BEGIN
								-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
								-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
								SELECT
										@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
										@LINK_IMAGEM_ORIGINAL  = LINK_IMAGEM_ORIGINAL
								FROM correcoes_redacao crd with (nolock)
								WHERE crd.id = @REDACAO_ID AND
										CRD.id_projeto = @ID_PROJETO

								/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
								INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
								id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, tipo_auditoria_id, redacao_id)
										SELECT
											GETDATE(),
											@LINK_IMAGEM_RECORTADA,
											@LINK_IMAGEM_ORIGINAL,
											1,
											7,
											co_barra_redacao,
											@AVALIADOR_ID,
											ID_PROJETO,
											@TIPO_BUSCA,
											@REDACAO_ID
										FROM CORRECOES_FILAAUDITORIA cor with (nolock)
										WHERE consistido = 1 and
					                          consistido_auditoria = 1 and 
											  redacao_id = @REDACAO_ID AND
										      id_projeto = @ID_PROJETO

								/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
								SET @CORRECAO_ID = SCOPE_IDENTITY()

							END

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 7, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA AUDITORIA   *****/
						DELETE FROM CORRECOES_FILAAUDITORIA
						WHERE consistido = 1 and
					          (consistido_auditoria = 1 OR @USA_CONSISTENCIA_AUDITORIA = 0)  and
			                  id_projeto = @ID_PROJETO and 
					          id = @id
					END
				COMMIT
			END TRY
			BEGIN CATCH
				print error_message()
				ROLLBACK
			END CATCH

	 SET NOCOUNT OFF;

	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaModa]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_filaModa]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
	 DECLARE @QTD_CORRECOES INT
	 DECLARE @QTD_CORRECOES_MODA INT
	 DECLARE @QTD_CORRECOES_MODA_DIA INT
	 DECLARE @REDACAO_ID INT

	 DECLARE @ID_FILAOURO INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
     SET @QTD_CORRECOES = 0
     SET @REDACAO_ID = NULL

		BEGIN TRANSACTION

			BEGIN TRY
				 select @QTD_CORRECOES = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID and
				  	    cor.id_projeto  = @ID_PROJETO   and
				  	    cor.id_status = 3    and
				  	    red.id_redacaoouro is null

				 select @QTD_CORRECOES_MODA = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID
				  	and cor.id_projeto  = @ID_PROJETO
				  	and cor.id_status = 3
				  	and cor.id_tipo_correcao = 6 --Moda
					and CAST(COR.DATA_TERMINO AS DATE) = CAST(dbo.getlocaldate() AS DATE)


                  /* CALCULO A QUANTIDADE DE MODA QUE O USUARIO PODE TER NO DIA COM BASE NA SUA COTA DE CORRECOES*/
                  SELECT @QTD_CORRECOES_MODA_DIA = DIA.CORRECOES/PRO.ouro_frequencia FROM VW_CORRECAO_DIA DIA WITH (NOLOCK) JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON (DIA.id_projeto = PRO.ID)
				  WHERE DIA.ID =  @AVALIADOR_ID AND
				        DIA.id_projeto = @ID_PROJETO

			   /* SE A QUANTIDADE DE OUROS CORRIGIDAS FOR MENOR QUE A COTA DO DIA TESTA SE ELA FOI SORTEADA */
                IF(@QTD_CORRECOES_MODA < @QTD_CORRECOES_MODA_DIA)
					BEGIN
						  select TOP 1 @CO_BARRA_REDACAO =  our.co_barra_redacao, @ID_FILAOURO = our.ID, @REDACAO_ID = our.redacao_id
							from correcoes_filaouro OUR join correcoes_redacao red on (our.redacao_id = red.id)
														join correcoes_redacaoouro rdo on (rdo.id = red.id_redacaoouro)
						   WHERE OUR.id_corretor = @AVALIADOR_ID AND
				  				 OUR.id_projeto  = @ID_PROJETO   AND
								  rdo.id_redacaotipo = 3 and
								 isnull(OUR.posicao,100000)    <= (@QTD_CORRECOES + 1)
								 ORDER BY POSICAO

                   END



               IF (@REDACAO_ID IS NULL)
					BEGIN
						SET @CORRECAO_ID = 0
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						FROM correcoes_redacao crd with (nolock)
						WHERE crd.id = @REDACAO_ID

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									6,
									co_barra_redacao,
									id_corretor,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_filaOuro cor with (nolock)
								WHERE id = @ID_FILAOURO


						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 6, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA OURO   *****/
						DELETE FROM correcoes_filaOuro
						WHERE ID = @ID_FILAOURO


						/*SE FOR A PRIMEIRA OURO DO DIA REDISTRIBUO AS DEMAIS REDACOES OURO */
						IF(@QTD_CORRECOES_MODA = 0)
							BEGIN
								EXEC sp_distribuir_ordem_DIARIO @AVALIADOR_ID, @ID_PROJETO, 3
							END

					END
				COMMIT
			END TRY
			BEGIN CATCH
				print ERROR_MESSAGE ( )
				ROLLBACK
			END CATCH

		SET NOCOUNT OFF;

	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaModa_teste]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_na_filaModa_teste]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@CORRECAO_ID int output

	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
	 DECLARE @QTD_CORRECOES INT
	 DECLARE @QTD_CORRECOES_MODA INT
	 DECLARE @QTD_CORRECOES_MODA_DIA INT
	 DECLARE @REDACAO_ID INT

	 DECLARE @ID_FILAOURO INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
     SET @QTD_CORRECOES = 0
     SET @REDACAO_ID = NULL

		BEGIN TRANSACTION

			BEGIN TRY
print 'passou 4.1.1.1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
				 select @QTD_CORRECOES = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID and
				  	    cor.id_projeto  = @ID_PROJETO   and
				  	    cor.id_status = 3    and
				  	    red.id_redacaoouro is null
print 'passou 4.1.1.2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

				 select @QTD_CORRECOES_MODA = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID
				  	and cor.id_projeto  = @ID_PROJETO
				  	and cor.id_status = 3
				  	and cor.id_tipo_correcao = 6 --Moda
					and CAST(COR.DATA_TERMINO AS DATE) = CAST(dbo.getlocaldate() AS DATE)

print 'passou 4.1.1.3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

                  /* CALCULO A QUANTIDADE DE MODA QUE O USUARIO PODE TER NO DIA COM BASE NA SUA COTA DE CORRECOES*/
                  SELECT @QTD_CORRECOES_MODA_DIA = DIA.CORRECOES/PRO.ouro_frequencia FROM VW_CORRECAO_DIA DIA WITH (NOLOCK) JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON (DIA.id_projeto = PRO.ID)
				  WHERE DIA.ID =  @AVALIADOR_ID AND
				        DIA.id_projeto = @ID_PROJETO

print 'passou 4.1.1.4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

			   /* SE A QUANTIDADE DE OUROS CORRIGIDAS FOR MENOR QUE A COTA DO DIA TESTA SE ELA FOI SORTEADA */
                IF(@QTD_CORRECOES_MODA < @QTD_CORRECOES_MODA_DIA)
					BEGIN
print 'passou 4.1.1.5: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
						  select TOP 1 @CO_BARRA_REDACAO =  our.co_barra_redacao, @ID_FILAOURO = our.ID, @REDACAO_ID = redacao_id
							from correcoes_filaouro OUR join correcoes_redacao red on (our.co_barra_redacao = red.co_barra_redacao)
														join correcoes_redacaoouro rdo on (rdo.id = red.id_redacaoouro)
						   WHERE OUR.id_corretor = @AVALIADOR_ID AND
				  				 OUR.id_projeto  = @ID_PROJETO   AND
								  rdo.id_redacaotipo = 3 and
								 isnull(OUR.posicao,100000)    <= (@QTD_CORRECOES + 1)
								 ORDER BY POSICAO
print 'passou 4.1.1.6: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

                   END



               IF (@REDACAO_ID IS NULL)
					BEGIN
						SET @CORRECAO_ID = 0
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
print 'passou 4.1.1.7: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						FROM correcoes_redacao crd with (nolock)
						WHERE crd.id = @REDACAO_ID
print 'passou 4.1.1.8: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									6,
									co_barra_redacao,
									id_corretor,
									ID_PROJETO,
                                    @REDACAO_ID
								FROM correcoes_filaOuro cor with (nolock)
								WHERE id = @ID_FILAOURO
print 'passou 4.1.1.9: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT


						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 6, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)

						/******* DELETAR O REGISTRO NA FILA OURO   *****/
						DELETE FROM correcoes_filaOuro
						WHERE ID = @ID_FILAOURO


						/*SE FOR A PRIMEIRA OURO DO DIA REDISTRIBUO AS DEMAIS REDACOES OURO */
						IF(@QTD_CORRECOES_MODA = 0)
							BEGIN
								EXEC sp_distribuir_ordem_DIARIO @AVALIADOR_ID, @ID_PROJETO, 3
							END

					END
				COMMIT
			END TRY
			BEGIN CATCH
				print ERROR_MESSAGE ( )
				ROLLBACK
			END CATCH

		SET NOCOUNT OFF;

	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_na_filaOuro]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* FORMA NOVA DE BUSCAR MAIS UM NA FILA OURO */
CREATE    procedure [dbo].[sp_busca_mais_um_na_filaOuro]
	@AVALIADOR_ID int,
	@ID_PROJETO int,
	@ID_GRUPO_CORRETOR bigint,
	@CORRECAO_ID int output
	as

     DECLARE @ID bigint
     DECLARE @CO_BARRA_REDACAO varchar(50)
     DECLARE @LINK_IMAGEM_RECORTADA varchar(500)
     DECLARE @LINK_IMAGEM_ORIGINAL varchar(500)
     DECLARE @ID_PERFIL bigint
	 DECLARE @QTD_CORRECOES INT
	 DECLARE @QTD_CORRECOES_OURO INT
	 DECLARE @QTD_CORRECOES_OURO_DIA INT
	 DECLARE @REDACAO_ID INT
     DECLARE @DATETIME DATETIME2

     SET @DATETIME = dbo.getlocaldate()


	 DECLARE @ID_FILAOURO INT

	 SET NOCOUNT ON;

     SET @CORRECAO_ID = 0
     SET @QTD_CORRECOES = 0
     SET @CO_BARRA_REDACAO = NULL
     SET @REDACAO_ID = NULL


		BEGIN TRANSACTION

			BEGIN TRY
				/* CONTO QUANTAS CORRECOES O AVALIADOR JA FEZ */
				 select @QTD_CORRECOES = count(cor.id)
				   from correcoes_correcao cor WITH (NOLOCK) join correcoes_redacao red WITH (NOLOCK) on cor.redacao_id = red.id
				  where cor.id_corretor = @AVALIADOR_ID and
				  	    cor.id_projeto  = @ID_PROJETO   and
				  	    cor.id_status = 3    and
				  	    red.id_redacaoouro is null
				/* CONTO QUANTAS CORRECOES OURO O AVALIADOR JA FEZ NO DIA */
                select @QTD_CORRECOES_OURO = count(cor.id)
				   from correcoes_correcao cor
                        join correcoes_redacao red on cor.redacao_id = red.id
				  	                              and cor.id_projeto  = @ID_PROJETO
				  	                              and cor.id_status = 3
				  	                              and cor.id_tipo_correcao = 5 --OURO
						                          and CAST(COR.DATA_TERMINO AS DATE) = convert(date, @DATETIME)


				  /* CALCULO A QUANTIDADE DE OURO QUE O USUARIO PODE TER NO DIA COM BASE NA SUA COTA DE CORRECOES*/
                  SELECT @QTD_CORRECOES_OURO_DIA = DIA.CORRECOES/PRO.ouro_frequencia
                    FROM VW_CORRECAO_DIA DIA WITH (NOLOCK)
                         JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON DIA.id_projeto = PRO.ID
				   WHERE DIA.ID =  @AVALIADOR_ID
				     AND DIA.id_projeto = @ID_PROJETO


                /* SE A QUANTIDADE DE OUROS CORRIGIDAS FOR MENOR QUE A COTA DO DIA TESTA SE ELA FOI SORTEADA */
                IF(@QTD_CORRECOES_OURO < @QTD_CORRECOES_OURO_DIA)
					BEGIN
						  select TOP 1 @CO_BARRA_REDACAO =  our.co_barra_redacao, @ID_FILAOURO = our.ID, @REDACAO_ID = red.id
							from correcoes_filaouro OUR
                                 join correcoes_redacao red on (our.redacao_id = red.id)
								 join correcoes_redacaoouro rdo on (rdo.id = red.id_redacaoouro)
						   WHERE OUR.id_corretor = @AVALIADOR_ID AND
				  				 OUR.id_projeto  = @ID_PROJETO   AND
								  rdo.id_redacaotipo = 2 and
								 isnull(OUR.posicao,100000)    <= (@QTD_CORRECOES + 1)
								 ORDER BY POSICAO

                   END

               IF (@REDACAO_ID IS NULL)
					BEGIN
						SET @CORRECAO_ID = 0
					END
				ELSE
					BEGIN

						-- ****** DANDO CARGA NA TABELA CORRECOES_CORRECAO E RECUPERANDO O ID DA CORRECAO *********
						-- ***** BUSCANDO AS INFORMACOES DA REDACAO ******
						SELECT
								@LINK_IMAGEM_RECORTADA = LINK_IMAGEM_RECORTADA,
								@LINK_IMAGEM_ORIGINAL = LINK_IMAGEM_ORIGINAL
						FROM correcoes_redacao crd with (nolock)
						WHERE crd.id = @REDACAO_ID

						/***** INSERINDO NA TABELA CORRECOES_CORRECAO   *****/
						INSERT INTO correcoes_correcao (data_inicio, link_imagem_recortada, link_imagem_original,
						id_status, id_tipo_correcao, co_barra_redacao, id_corretor, id_projeto, redacao_id)
								SELECT
									dbo.getlocaldate(),
									@LINK_IMAGEM_RECORTADA,
									@LINK_IMAGEM_ORIGINAL,
									1,
									5,
									co_barra_redacao,
									id_corretor,
									ID_PROJETO,@REDACAO_ID
								FROM correcoes_filaOuro cor with (nolock)
								WHERE cor.id = @ID_FILAOURO

						/****** RECUPERANDO O ID DA TABELA CORRECOES_CORRECAO   *****/
						select @CORRECAO_ID = SCOPE_IDENTITY()

						/****** FIM DANDO CARGA NA TABELA CORRECAO_REDACAO E RECUPERANDO O ID DA CORRECAO *********/
						/****** INSERIR NA LISTA PESSOAL   *****/
						INSERT INTO correcoes_filapessoal (corrigido_por, id_grupo_corretor, atual, id_tipo_correcao, id_corretor, id_correcao, co_barra_redacao, id_projeto, redacao_id)
								VALUES (DBO.FN_COR_CORRETOR_REDACAO(@CO_BARRA_REDACAO), @ID_GRUPO_CORRETOR, 1, 5, @AVALIADOR_ID, @CORRECAO_ID, @CO_BARRA_REDACAO, @ID_PROJETO, @REDACAO_ID)
						/******* DELETAR O REGISTRO NA FILA OURO   *****/
						DELETE FROM correcoes_filaOuro
						WHERE ID = @ID_FILAOURO

						/*SE FOR A PRIMEIRA OURO DO DIA REDISTRIBUO AS DEMAIS REDACOES OURO */
						IF(@QTD_CORRECOES_OURO = 0)
							BEGIN
								EXEC sp_distribuir_ordem_DIARIO @AVALIADOR_ID, @ID_PROJETO, 2
							END

					END
				COMMIT
			END TRY
			BEGIN CATCH
				print ERROR_MESSAGE ( )
				ROLLBACK
			END CATCH

		SET NOCOUNT OFF;

	RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_busca_mais_um_teste]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_busca_mais_um_teste]
    @AVALIADOR_ID bigint,
    @ID_PROJETO INT,
    @CORRECAO_ID bigint OUTPUT
AS

SET @CORRECAO_ID = 0

     DECLARE @ID bigint

     DECLARE @ID_GRUPO_CORRETOR bigint
     DECLARE @FILA              bigint
     DECLARE @FILA_SUPERVISOR   int     /*** FILA ONDE O SUPERVISOR IRA BUSCAR CORRECOES A SEREM FEITAS - DENFINIDO POR PROJETO ***/
     DECLARE @FILA_PRIORIDADE   int     /*** A PARTIR DE QUAL FILA SERA INICIADO A BUSCA DE UMA CORRECAO PARA O AVALIADOR SOLICITANTE - DENFINIDO POR PROJETO ***/
     DECLARE @ID_PERFIL         bigint  /*** BUSCAR O PERFIL DE PERMISSAO {SUPERVISOR DE HOMOLOGAÇÃO, SUPERVISOR, AVALIADOR}  ***/
     DECLARE @LIMITE            int     /*** CASO O AVALIADOR SEJA SUPERVISOR O LIMITE E A FILA_SUPERVISOR SENAO SERA A ULTIMA DA LISTA A SER TESTADA  */
     DECLARE @PODE_CORRIGIR_1   int
     DECLARE @PODE_CORRIGIR_2   int
     DECLARE @PODE_CORRIGIR_3   int
     DECLARE @COMANDO           VARCHAR(2000)
     DECLARE @QTD_CORRECOES     INT

print 'passou 1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
     SET NOCOUNT ON;

     SET @CORRECAO_ID   = 0
     SET @QTD_CORRECOES = 0


     /********** BUSCAR O PERFIL DO CORRETOR  *****/
     SELECT
            @ID_PERFIL = GROUP_ID,
            @ID_GRUPO_CORRETOR = grupo_corretor,
            @PODE_CORRIGIR_1 = PODE_CORRIGIR_1,
            @PODE_CORRIGIR_2 = PODE_CORRIGIR_2,
            @PODE_CORRIGIR_3 = PODE_CORRIGIR_3
      FROM
            vw_cor_usuario_grupo with (nolock)
     WHERE
            ID_USUARIO = @AVALIADOR_ID
print 'passou 2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT


     /**********                     BUSCAR CONFIGURACOES DO PROJETO                             *****/
     /*******************************************************************************************************
       SE O AVALIADOR TIVER O PERFIL DE SUPERVISOR ESTE PODERA CORRIGIR SOMENTE AS REDACOES DA FILA DEFINIDA
      *******************************************************************************************************/

     SELECT
            @FILA_SUPERVISOR = FILA_SUPERVISOR,
            @FILA_PRIORIDADE = FILA_PRIORITARIA,
            @FILA   = CASE WHEN @ID_PERFIL = 25 THEN FILA_SUPERVISOR ELSE FILA_PRIORITARIA END,
            @LIMITE = CASE WHEN @ID_PERFIL = 25 THEN FILA_SUPERVISOR ELSE 1                END

     FROM
            PROJETO_PROJETO with (nolock)
     WHERE
            ID = @ID_PROJETO

print 'passou 3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

     /********** BUSCAR SE JA EXISTE ALGUMA CORRECAO NA FILA ATUAL COM ATUAL = 1 PARA O AVALIADOR  *****/
     SELECT TOP 1
            @CORRECAO_ID = id_correcao
     FROM
            correcoes_filapessoal with (nolock)
     WHERE
            id_corretor = @AVALIADOR_ID AND
            id_projeto  = @ID_PROJETO
     ORDER BY ATUAL DESC, id
print 'passou 4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

     IF @@ROWCOUNT = 1
     BEGIN
          UPDATE correcoes_filapessoal
          SET ATUAL = 1
          WHERE
                 id_corretor = @AVALIADOR_ID
                 AND ATUAL = 0
                 AND id_correcao = @CORRECAO_ID
                 AND id_projeto  = @ID_PROJETO
print 'passou 5: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT


          IF (@CORRECAO_ID > 0)
                begin

                    insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
                end
print 'passou 6: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT

          UPDATE correcoes_correcao
          SET data_inicio = dbo.getlocaldate()
          WHERE  id = @CORRECAO_ID
                 AND data_inicio IS NULL
                 AND id_projeto  = @ID_PROJETO
print 'passou 7: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
     END

print 'passou 4.1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
     -- ****** busca na fila ouro
     if (@CORRECAO_ID = 0)
        begin
print 'passou 4.1.1: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
            EXEC sp_busca_mais_um_na_filaOuro_teste  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
print 'passou 4.1.2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
            IF (@CORRECAO_ID > 0)
                begin
                    insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
                end
        end
     -- ****** busca na fila moda
     if (@CORRECAO_ID = 0)
        begin
print 'passou 4.1.3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
            EXEC sp_busca_mais_um_na_filaModa  @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
print 'passou 4.1.4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
            IF (@CORRECAO_ID > 0)
                begin
                    insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
                end
        end
print 'passou 4.2: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
    IF(@CORRECAO_ID = 0)
        BEGIN
            --BEGIN TRANSACTION
                --BEGIN TRY
print 'passou 4.3: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
                    WHILE (@FILA >= @LIMITE AND @CORRECAO_ID = 0 )
                        BEGIN
print 'passou 4.4: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
                            IF(@FILA = 1 AND @PODE_CORRIGIR_1 = 1)
                                BEGIN
print 'passou 8: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
                                    EXEC sp_busca_mais_um_na_fila1_teste @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
print 'passou 9: ' + convert(varchar(100), dbo.getlocaldate())
RAISERROR(N'', 0, 1) WITH NOWAIT
                                END
                            ELSE IF (@FILA = 2 AND @PODE_CORRIGIR_2 = 1)
                                BEGIN
                                    EXEC sp_busca_mais_um_na_fila2 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
                                END
                            ELSE IF (@FILA = 3 AND @PODE_CORRIGIR_3 = 1)
                                BEGIN
                                    EXEC sp_busca_mais_um_na_fila3 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
                                END
                            ELSE IF (@FILA = 4)
                                BEGIN
                                    EXEC sp_busca_mais_um_na_fila4 @AVALIADOR_ID, @ID_PROJETO, @ID_GRUPO_CORRETOR, @CORRECAO_ID OUTPUT
                                END

                            set @FILA = @FILA - 1
                        END

                    IF (@CORRECAO_ID > 0)
                        begin
                            insert correcoes_historicocorrecao values (dbo.getlocaldate(), null, @CORRECAO_ID, 1, @AVALIADOR_ID)
                        end
                    --COMMIT TRANSACTION
                --END TRY
                --BEGIN CATCH
                --  SET @CORRECAO_ID = -1

                --END CATCH
        END
    SET NOCOUNT OFF;
RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_carrega_ouro]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_carrega_ouro] 
    @ID_REDACAO INT,
    @ID_CORRETOR INT,
    @ID_PROJETO  INT 
as 

begin try
begin tran

    -- ***** colocar na tabela redacoes ouro as redacoes selecionadas

    insert into correcoes_redacaoouro (link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
                                       co_barra_redacao,co_inscricao,co_formulario,id_prova, id_projeto, id_redacaotipo)
    select link_imagem_recortada, link_imagem_original,nota_final, null, 
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,2 
     from correcoes_redacao red 
    where not exists (select 1 from correcoes_redacaoouro our 
                       where our.co_barra_redacao = red.co_barra_redacao and 
                             our.id_projeto = red.id_projeto and 
                             our.id_redacaotipo = 2) and
          id_redacaoouro is null and 
          RED.id_projeto = @ID_PROJETO AND
          red.id in (@id_redacao)
    order by co_barra_redacao

    DROP TABLE  #tmp_correcoes_redacao
     -- **** inserir na tabela redacao as redacoes ouro para o candidato 
     select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
            co_barra_redacao = '001' + right('000000' +convert(varchar(6),our.id),6) +
                                       right('000000' +convert(varchar(6),@ID_CORRETOR),6),
            co_inscricaon    = '001' + right('000000' +convert(varchar(6),our.id),6) +
                                       right('000000' +convert(varchar(6),@ID_CORRETOR),6),
            co_formulario,id_prova, id_projeto,id 
      into #tmp_correcoes_redacao
       from correcoes_redacaoouro OUR 
         where data_criacao > '2018-12-03 23:00'
      order by co_barra_redacao

    insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao,
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
    select link_imagem_recortada, link_imagem_original, nota_final, 1, 
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
      from #tmp_correcoes_redacao tmp
     where not exists (select 1 from correcoes_redacao redx 
                        where redx.co_barra_redacao = tmp.co_barra_redacao AND
                              REDX.id_projeto = TMP.id_projeto)

    -- **** inserir na tabela filaOURO
    insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto)
    SELECT red.co_barra_redacao,
           @ID_CORRETOR, null, red.id_projeto
      FROM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
     where not exists (select * from correcoes_filaouro flox 
                        where flox.co_barra_redacao = red.co_barra_redacao and 
                              flox.id_corretor      = @ID_CORRETOR AND 
                              FLOX.id_projeto       = @ID_PROJETO)
 
    --- INSERE NA CORRECOES GABARITO
    insert correcoes_gabarito (nota_final, id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
           nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
           co_barra_redacao)
    select  our.nota_final, our.id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
           nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
           red.co_barra_redacao
     frOM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
     where not exists (select 1 from correcoes_gabarito gabx
                        where gabx.co_barra_redacao = red.co_barra_redacao) and
           our.id_projeto = 4
           and data_criacao > '2018-12-03 23:00'

     exec sp_distribuir_ordem @ID_CORRETOR, @ID_PROJETO, 2

     commit
end try
begin catch
    print error_message()
    rollback
end catch


SELECT * FROM correcoes_REDACAOouro WHERE id_redacaotipo = 3

GO
/****** Object:  StoredProcedure [dbo].[sp_carrega_ouro2]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     procedure [dbo].[sp_carrega_ouro2] 
    @ID_CORRETOR INT,
    @ID_PROJETO  INT 
as 

begin try
--begin tran


     -- **** inserir na tabela redacao as redacoes ouro para o candidato 
     select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
            co_barra_redacao = '001' + right('000000' +convert(varchar(6),our.id),6) +
                                       right('000000' +convert(varchar(6),@ID_CORRETOR),6),
            co_inscricao    = '001' + right('000000' +convert(varchar(6),our.id),6) +
                                       right('000000' +convert(varchar(6),@ID_CORRETOR),6),
            co_formulario,id_prova, id_projeto,id 
       into #tmp_correcoes_redacao
       from correcoes_redacaoouro OUR 
      order by co_barra_redacao

    insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao,
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
    select link_imagem_recortada, link_imagem_original, nota_final, 1, 
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
      from #tmp_correcoes_redacao tmp
     where not exists (select 1 from correcoes_redacao redx 
                        where redx.co_barra_redacao = tmp.co_barra_redacao AND
                              REDX.id_projeto = TMP.id_projeto)

    -- **** inserir na tabela filaOURO
    insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto)
    SELECT co_barra_redacao,
           @ID_CORRETOR, null, id_projeto
      FROM #tmp_correcoes_redacao

 
    --- INSERE NA CORRECOES GABARITO
    insert correcoes_gabarito (nota_final, id_correcao_situacao, id_competencia1, id_competencia2, id_competencia3, id_competencia4, id_competencia5,
           nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
           co_barra_redacao)
    select our.nota_final, our.id_correcao_situacao, our.id_competencia1, our.id_competencia2, our.id_competencia3, our.id_competencia4, our.id_competencia5,
           our.nota_competencia1, our.nota_competencia2, our.nota_competencia3, our.nota_competencia4, our.nota_competencia5,
           red.co_barra_redacao
     frOM CORRECOES_REDACAOouro our join correcoes_redacao red on (red.id_redacaoouro = our.id)
     where not exists (select 1 from correcoes_gabarito gabx
                        where gabx.co_barra_redacao = red.co_barra_redacao) and
           our.id_projeto = @ID_PROJETO
           

     exec sp_distribuir_ordem @ID_CORRETOR, @ID_PROJETO, 2

     --commit
end try
begin catch
    print error_message()
    rollback
end catch

GO
/****** Object:  StoredProcedure [dbo].[sp_carregar_correcoes_corretor_indicadores]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_carregar_correcoes_corretor_indicadores] as
DECLARE @DATA DATE
DECLARE @DATA_ANTERIOR DATE
DECLARE @ID_PROJETO INT

SET @DATA = CAST(dbo.getlocaldate() AS DATE)

declare abc cursor for 
    select id from projeto_projeto
     where cast(dbo.getlocaldate() as date) between cast(data_inicio as date) and cast(data_termino as date)

    open abc 
        fetch next from abc into @ID_PROJETO
        while @@FETCH_STATUS = 0
            BEGIN
                --IF (NOT EXISTS(SELECT * FROM CORRECOES_CORRETOR_INDICADORES WHERE DATA_CALCULO = @DATA))
                --  BEGIN
                --      SET @DATA_ANTERIOR = DATEADD(DAY,-1,@DATA)
                --      EXEC SP_CORRECOES_CORRETOR_INDICADORES @DATA_ANTERIOR, @ID_PROJETO
                --  END
                SET @DATA_ANTERIOR = DATEADD(DAY,-1,@DATA)
                EXEC SP_CORRECOES_CORRETOR_INDICADORES @DATA_ANTERIOR, @ID_PROJETO

            fetch next from abc into @ID_PROJETO
            END
    close abc 
deallocate abc

GO
/****** Object:  StoredProcedure [dbo].[SP_COMPARAR_TABELAS]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                                     [SP_COMPARAR_TABELAS]                                                       *
*                                                                                                                                 *
*  PROCEDURE QUE RECEBE O NOME DE DUAS TABELAS E SE ELAS POSSUIREM A MESMA ESTRUTURA SERA COMPARADO CAMPO A CAMPO SE OS DADOS EST *
* AO IGUAIS)                                                                                                                      *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:10/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:10/10/2019 *
**********************************************************************************************************************************/

CREATE   PROCEDURE [dbo].[SP_COMPARAR_TABELAS]  
   @TAB1 VARCHAR(100), @TAB2 VARCHAR(100) AS

DECLARE @SQL NVARCHAR(1000)


SET @SQL = 
N'SELECT *, TABELA = ' + CHAR(39) + @TAB1 + CHAR(39) + ' FROM (
SELECT *  FROM ' + @TAB1 + ' 
EXCEPT 
SELECT *  FROM ' + @TAB2 + '
) AS TAB
UNION 
SELECT *, TABELA = ' + CHAR(39) + @TAB2 + CHAR(39) + ' FROM (
SELECT *  FROM ' + @TAB2 + '
EXCEPT 
SELECT *  FROM ' + @TAB1 + '
 ) AS TAB1  ORDER BY 1'

 PRINT @SQL 

 EXEC SP_EXECUTESQL @SQL

GO
/****** Object:  StoredProcedure [dbo].[SP_COMPARAR_TABELAS_CAMPO_A_CAMPO]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************
*                                                     [SP_COMPARAR_TABELAS]                                                       *
*                                                                                                                                 *
*  PROCEDURE QUE RECEBE O NOME DE DUAS TABELAS E SE ELAS POSSUIREM A MESMA ESTRUTURA SERA COMPARADO CAMPO A CAMPO SE OS DADOS EST *
* AO IGUAIS)                                                                                                                      *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:10/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:10/10/2019 *
**********************************************************************************************************************************/
-- EXEC SP_COMPARAR_TABELAS_CAMPO_A_CAMPO usuarios_hierarquia, #TMP
---SELECT * INTO #TMP FROM usuarios_hierarquia

CREATE   PROCEDURE [dbo].[SP_COMPARAR_TABELAS_CAMPO_A_CAMPO]  
   @TAB1 VARCHAR(100), @TAB2 VARCHAR(100) AS

DECLARE @SQL NVARCHAR(4000),@CAMPOS_SQL NVARCHAR(4000), @CAMPO VARCHAR(500), @SQL1 VARCHAR(500), @SQL2 VARCHAR(500)

SET @SQL1 = N'SELECT DISTINCT TAB1.*, TABELA = ' + CHAR(39)  + @TAB1 + CHAR(39) + ' FROM ' + @TAB1 + ' AS TAB1 WITH(NOLOCK) LEFT  JOIN ' + @TAB2 + ' AS TAB2 ON ( ' 
SET @SQL2 = N'SELECT DISTINCT TAB2.*, TABELA = ' + CHAR(39)  + @TAB2 + CHAR(39) + ' FROM ' + @TAB1 + ' AS TAB1 WITH(NOLOCK) RIGHT JOIN ' + @TAB2 + ' AS TAB2 ON ( ' 
SET @CAMPOS_SQL = N''
declare abc cursor for 
    SELECT CAMPO = ' isnull(convert(varchar(1000),tab1.'+ COLUMN_NAME + '), ' + CHAR(39) + '-9*X|' + CHAR(39) + ') =' +
                   ' isnull(convert(varchar(1000),tab2.'+ COLUMN_NAME + '), ' + CHAR(39) + '-9*X|' + CHAR(39) + ') and'
      FROM INFORMATION_SCHEMA.COLUMNS
     where TABLE_NAME = @TAB1

    open abc 
        fetch next from abc into @CAMPO
        while @@FETCH_STATUS = 0
            BEGIN
                SET @CAMPOS_SQL = @CAMPOS_SQL + @CAMPO
            fetch next from abc into @CAMPO
            END
    close abc 
deallocate abc 
SET @CAMPOS_SQL = @CAMPOS_SQL + ')'
SET @CAMPOS_SQL = REPLACE(@CAMPOS_SQL, 'AND)',')')


SET @SQL = N'' + @SQL1 + @CAMPOS_SQL + '   ' + @SQL2 + @CAMPOS_SQL  


 EXEC SP_EXECUTESQL @SQL


GO
/****** Object:  StoredProcedure [dbo].[sp_consistir_filas]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   procedure [dbo].[sp_consistir_filas] 
    @redacao_id int, @ID_PROJETO INT,@fila int as


-- *** CONSISTENCIA DA FILA 3
--		VALIDAR SE NAO EXISTE INSERCAO EM OUTRA FILA
--		VALIDAR SE AS COMPETENCIAS VEZES O PESO E IGUAL A NOTA GRAVADA
--		VALIDAR SE A NOTA FINAL E IGUAL AO SOMATORIO DAS NOTAS DE CADA COMPETENCIA
--		VALIDAR SE EXISTEM CORRECOES DE PRIMEIRA E SEGUNDA 
if (@fila = 3) -- VALIDACAO DA TERCEIRA FILA
	begin
		 update fil3 set fil3.consistido = abs(1 -
			(select COUNT(DISTINCT 1)
						 from correcoes_fila3 FIL3    join projeto_projeto     pro  on (pro.id = FIL3.id_projeto) 
													  join VW_FILAS_DA_REDACAO fils  on (FIL3.redacao_id  = fils.REDACAO_ID and FIL3.id_projeto = fils.id_projeto)
												 LEFT join correcoes_correcao  cor1 on (cor1.redacao_id = FIL3.redacao_id and cor1.id_tipo_correcao = 1 AND FIL3.id_PROJETO = COR1.ID_PROJETO ) 
												 LEFT join correcoes_correcao  cor2 on (cor2.redacao_id = FIL3.redacao_id and cor2.id_tipo_correcao = 2 AND FIL3.id_projeto = COR2.ID_PROJETO )
												 LEFT join correcoes_correcao  cor3 on (cor3.redacao_id = FIL3.redacao_id and cor3.id_tipo_correcao = 3 AND FIL3.id_projeto = COR3.ID_PROJETO )  
						where  
						       (	
						           -- **** testar se as notas da correcao1 estao corretas e se o somatorio das mesmas bate com a nota final 
						           (cor1.id_correcao_situacao = 1 and 
										(isnull(cor1.competencia1,-5) * pro.peso_competencia <> cor1.nota_competencia1 or  
										 isnull(cor1.competencia2,-5) * pro.peso_competencia <> cor1.nota_competencia2 or  
										 isnull(cor1.competencia3,-5) * pro.peso_competencia <> cor1.nota_competencia3 or  
										 isnull(cor1.competencia4,-5) * pro.peso_competencia <> cor1.nota_competencia4 or  
										 case cor1.competencia5 when -1 then 0 else isnull(cor1.competencia5,-5) end * pro.peso_competencia <> cor1.nota_competencia5 or 
										 cor1.nota_final <> cor1.nota_competencia1 + cor1.nota_competencia2 + cor1.nota_competencia3 + cor1.nota_competencia4 + cor1.nota_competencia5)
									) or 

									-- **** testar se as notas da correcao2 estao corretas e se o somatorio das mesmas bate com a nota final 
						           (cor2.id_correcao_situacao = 1 and 
										(isnull(cor2.competencia1,-5) * pro.peso_competencia <> cor2.nota_competencia1 or  
										 isnull(cor2.competencia2,-5) * pro.peso_competencia <> cor2.nota_competencia2 or  
										 isnull(cor2.competencia3,-5) * pro.peso_competencia <> cor2.nota_competencia3 or  
										 isnull(cor2.competencia4,-5) * pro.peso_competencia <> cor2.nota_competencia4 or  
										 case cor2.competencia5 when -1 then 0 else isnull(cor2.competencia5,-5) end * pro.peso_competencia <> cor2.nota_competencia5 or 
										 cor2.nota_final <> cor2.nota_competencia1 + cor2.nota_competencia2 + cor2.nota_competencia3 + cor2.nota_competencia4 + cor2.nota_competencia5)
									) or 

									-- **** testar as notas finais da primeira e segunda correcao discrepam quando a situacao for 1
						           (cor1.id_correcao_situacao = 1 and
									cor2.id_correcao_situacao = 1 and
									abs(cor1.nota_final - cor2.nota_final) < pro.limite_nota_final ) or 

									-- **** testar se quando for dado situacao diferente de 1 se as situacoes discrepam
									(	(cor1.id_correcao_situacao <> 1 and cor2.id_correcao_situacao = cor1.id_correcao_situacao) or 
									    (cor1.id_correcao_situacao <> 2 and cor2.id_correcao_situacao = cor1.id_correcao_situacao)
									) or 

									-- **** testar caso a situacao for direrente de 1 as notas das competencias tem que ser zero (0)
									(cor1.id_correcao_situacao <> 1 and (cor1.nota_competencia1 <> 0 or cor1.nota_competencia2 <> 0 or cor1.nota_competencia3 <> 0 or cor1.nota_competencia4 <> 0 or cor1.nota_competencia5 <> 0)) or 
									(cor2.id_correcao_situacao <> 1 and (cor2.nota_competencia1 <> 0 or cor2.nota_competencia2 <> 0 or cor2.nota_competencia3 <> 0 or cor2.nota_competencia4 <> 0 or cor2.nota_competencia5 <> 0)) or 
									
									(COR1.ID IS NULL)     OR -- *** para existir fila3 deve exitir correcao (1,2)
									(COR2.ID IS NULL)     OR -- *** para existir fila3 deve exitir correcao (1,2)
									(COR3.ID IS NOT NULL) OR -- *** para existir fila3 nao deve exitir correcao 3
									(fils.FILA <> 3)		 -- *** para existir fila3 nao deve exitir fila	diferente de 3
								)  
				)
					  
					  ) -- final do pareteses do ABS

		from correcoes_fila3 fil3 
		 where fil3.redacao_id = @redacao_id  AND 
		       fil3.id_projeto = @ID_PROJETO

	end -- (FIM IF @FILA = 3)

--  ###################################################################################################################

-- *** CONSISTENCIA DA FILA 4 
--		VALIDAR SE NAO EXISTE INSERCAO EM OUTRA FILA
--		VALIDAR SE AS COMPETENCIAS VEZES O PESO E IGUAL A NOTA GRAVADA (1,2,3)
--		VALIDAR SE A NOTA FINAL E IGUAL AO SOMATORIO DAS NOTAS DE CADA COMPETENCIA
--		VALIDAR SE EXISTEM CORRECOES DE PRIMEIRA E SEGUNDA 
if (@FILA = 4)
	BEGIN
		update fil4 set fil4.consistido = abs(1 -
			(select COUNT(DISTINCT 1) 
			  FROM correcoes_fila4 FIL4 join projeto_projeto         pro  on (pro.id = FIL4.id_projeto) 
										join VW_FILAS_DA_REDACAO     fils on (FIL4.redacao_id  = fils.REDACAO_ID and FIL4.id_projeto = fils.id_projeto)
								   LEFT join correcoes_correcao      cor1 on (cor1.redacao_id = FIL4.redacao_id and cor1.id_tipo_correcao = 1 AND FIL4.id_PROJETO = COR1.ID_PROJETO ) 
								   LEFT join correcoes_correcao      cor2 on (cor2.redacao_id = FIL4.redacao_id and cor2.id_tipo_correcao = 2 AND FIL4.id_projeto = COR2.ID_PROJETO ) 
								   LEFT join correcoes_correcao      cor3 on (cor3.redacao_id = FIL4.redacao_id and cor3.id_tipo_correcao = 3 AND FIL4.id_projeto = COR3.ID_PROJETO ) 
								   LEFT join correcoes_correcao      cor4 on (cor4.redacao_id = FIL4.redacao_id and cor4.id_tipo_correcao = 4 AND FIL4.id_projeto = COR4.ID_PROJETO ) 
								   LEFT JOIN vw_redacao_equidistante EQU  ON (EQU.redacao_id  = fil4.redacao_id AND EQU.id_projeto = FIL4.id_projeto )
			 WHERE  
				   (	(fils.FILA <> 4) or -- *** nao pode existir fila diferente de 4 

						(COR1.ID IS  NULL)    OR  -- *** para existir fila4 e necessario que existam correcoes (1,2,3) 
						(COR2.ID IS  NULL)    OR  -- *** para existir fila4 e necessario que existam correcoes (1,2,3) 
						(COR3.ID IS  NULL)    OR  -- *** para existir fila4 e necessario que existam correcoes (1,2,3) 
						(COR4.ID IS NOT NULL) OR  -- *** testar se existe correcoes  em correcoes_correcao para tipo 4 

						-- **** testar se as notas da correcao1 estao corretas e se o somatorio das mesmas bate com a nota final 
						(cor1.id_correcao_situacao = 1 and 
							(isnull(cor1.competencia1,-5) * pro.peso_competencia <> cor1.nota_competencia1 or  
							 isnull(cor1.competencia2,-5) * pro.peso_competencia <> cor1.nota_competencia2 or  
							 isnull(cor1.competencia3,-5) * pro.peso_competencia <> cor1.nota_competencia3 or  
							 isnull(cor1.competencia4,-5) * pro.peso_competencia <> cor1.nota_competencia4 or  
							 case cor1.competencia5 when -1 then 0 else isnull(cor1.competencia5,-5) end * pro.peso_competencia <> cor1.nota_competencia5 or 
							 cor1.nota_final <> cor1.nota_competencia1 + cor1.nota_competencia2 + cor1.nota_competencia3 + cor1.nota_competencia4 + cor1.nota_competencia5)
						) or 

						-- **** testar se as notas da correcao2 estao corretas e se o somatorio das mesmas bate com a nota final 
						(cor2.id_correcao_situacao = 1 and 
							(isnull(cor2.competencia1,-5) * pro.peso_competencia <> cor2.nota_competencia1 or  
							 isnull(cor2.competencia2,-5) * pro.peso_competencia <> cor2.nota_competencia2 or  
							 isnull(cor2.competencia3,-5) * pro.peso_competencia <> cor2.nota_competencia3 or  
							 isnull(cor2.competencia4,-5) * pro.peso_competencia <> cor2.nota_competencia4 or  
							 case cor2.competencia5 when -1 then 0 else isnull(cor2.competencia5,-5) end * pro.peso_competencia <> cor2.nota_competencia5 or 
							 cor2.nota_final <> cor2.nota_competencia1 + cor2.nota_competencia2 + cor2.nota_competencia3 + cor2.nota_competencia4 + cor2.nota_competencia5)
						) or

					    -- **** testar se as notas da correcao3 estao corretas e se o somatorio das mesmas bate com a nota final 
						(cor3.id_correcao_situacao = 1 and 
							(isnull(cor3.competencia1,-5) * pro.peso_competencia <> cor3.nota_competencia1 or  
							 isnull(cor3.competencia2,-5) * pro.peso_competencia <> cor3.nota_competencia2 or  
							 isnull(cor3.competencia3,-5) * pro.peso_competencia <> cor3.nota_competencia3 or  
							 isnull(cor3.competencia4,-5) * pro.peso_competencia <> cor3.nota_competencia4 or  
							 case cor3.competencia5 when -1 then 0 else isnull(cor3.competencia5,-5) end * pro.peso_competencia <> cor3.nota_competencia5 or 
							 cor3.nota_final <> cor3.nota_competencia1 + cor3.nota_competencia2 + cor3.nota_competencia3 + cor3.nota_competencia4 + cor3.nota_competencia5)
						) OR 

						-- **** testar caso a situacao for direrente de 1 as notas das competencias tem que ser zero (0)
						(cor1.id_correcao_situacao <> 1 and (cor1.nota_competencia1 <> 0 or cor1.nota_competencia2 <> 0 or cor1.nota_competencia3 <> 0 or cor1.nota_competencia4 <> 0 or cor1.nota_competencia5 <> 0)) or 
						(cor2.id_correcao_situacao <> 1 and (cor2.nota_competencia1 <> 0 or cor2.nota_competencia2 <> 0 or cor2.nota_competencia3 <> 0 or cor2.nota_competencia4 <> 0 or cor2.nota_competencia5 <> 0)) or 
						(cor3.id_correcao_situacao <> 1 and (cor3.nota_competencia1 <> 0 or cor3.nota_competencia2 <> 0 or cor3.nota_competencia3 <> 0 or cor3.nota_competencia4 <> 0 or cor3.nota_competencia5 <> 0)) or
				        
						-- *** testar condicoes para estar na fila4 -* discrepancia da terceira coma primeira e segunda ou equidistante  
						-- *** equidistante
						(	(cor1.id_correcao_situacao = 1 and 
						     cor2.id_correcao_situacao = 1 and 
						     cor3.id_correcao_situacao = 1 and 
							 (abs(cor1.nota_final - cor3.nota_final) > pro.limite_nota_final OR  
							  abs(cor2.nota_final - cor3.nota_final) > pro.limite_nota_final) and 

							 EQU.redacao_id IS NOT NULL )
						) OR 

						-- *** SE NAO FOR EQUIDISTANTE DEVERA HAVER DISCREPANCIA ENTRE TERCEIRA COM COM PRIMEIRA E SEGUNDA
						(	(cor1.id_correcao_situacao <> 1 OR 
						     cor2.id_correcao_situacao <> 1 OR 
						     cor3.id_correcao_situacao <> 1) and 
							 EQU.redacao_id IS NULL and
							 (	(COR1.id_correcao_situacao = 1 AND 
							     COR3.id_correcao_situacao = 1 AND
							     abs(cor1.nota_final - cor3.nota_final) < pro.limite_nota_final)  OR
								(COR2.id_correcao_situacao = 1 AND 
							     COR3.id_correcao_situacao = 1 AND
							     abs(cor2.nota_final - cor3.nota_final) < pro.limite_nota_final)  OR 
								(cor1.id_correcao_situacao = cor3.id_correcao_situacao) OR
								(cor2.id_correcao_situacao = cor3.id_correcao_situacao)
							)
						)  

				   )
			)
				) -- final do pareteses do ABS
		from correcoes_fila4 fil4 
		 where fil4.redacao_id = @redacao_id  AND 
		       fil4.id_projeto = @ID_PROJETO
	END -- FIM FILA4

--  ###################################################################################################################			
			
-- *** AUDITORIA
	-- NOTA 1000
	-- PD TENDO UM PD -9
	-- DDH COMPETENCIA 5 = -1 - TENDO 1
if (@FILA = 7)
	BEGIN
		update filaud set filaud.consistido = abs(1 -
			(select COUNT(DISTINCT 1) 
			  FROM correcoes_filaauditoria AUD join projeto_projeto         pro    on (pro.id          = AUD.id_projeto) 
										       join VW_FILAS_DA_REDACAO     fils   on (AUD.redacao_id  = fils.REDACAO_ID and AUD.id_projeto = fils.id_projeto)
								          LEFT join correcoes_correcao      cor1   on (cor1.redacao_id = AUD.redacao_id and cor1.id_tipo_correcao = 1 AND AUD.id_PROJETO = COR1.ID_PROJETO ) 
								          LEFT join correcoes_correcao      cor2   on (cor2.redacao_id = AUD.redacao_id and cor2.id_tipo_correcao = 2 AND AUD.id_projeto = COR2.ID_PROJETO ) 
								          LEFT join correcoes_correcao      cor3   on (cor3.redacao_id = AUD.redacao_id and cor3.id_tipo_correcao = 3 AND AUD.id_projeto = COR3.ID_PROJETO ) 
								          LEFT join correcoes_correcao      cor4   on (cor4.redacao_id = AUD.redacao_id and cor4.id_tipo_correcao = 4 AND AUD.id_projeto = COR4.ID_PROJETO ) 
								          LEFT join correcoes_correcao      corAUD on (AUD.redacao_id  = corAUD.redacao_id and corAUD.id_tipo_correcao = 7 AND AUD.id_projeto = corAUD.ID_PROJETO ) 
								  
			 WHERE  AUD.redacao_id = @redacao_id and 
			        AUD.id_projeto = @ID_PROJETO and 
						-- **** nao pode existir em outras filas
					(	(fils.fila <> 7) or   
						-- **** parte desconectada
					    (	(aud.tipo_id = 2) and
							(	(cor1.id_correcao_situacao <> 9 and cor2.id_correcao_situacao <> 9) and                        -- *** pd na primeira ou segunda correcao
								(cor3.id is null and cor4.id is null)) or								                       -- *** pd na primeira ou segunda correcao
							(	(cor3.id_correcao_situacao <> 9 and  														   -- pd na terceira correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is null)) or  -- pd na terceira correcao
							(	(cor4.id_correcao_situacao <> 9 and  														   -- pd na quarta correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is not null)) -- pd na quarta correcao   
					    )  or 
						-- **** DDH 
						(	(aud.tipo_id = 3) and
							(	(cor1.competencia5 <> -1 and cor2.competencia5 <> -1) and                                      -- *** DDH na primeira ou segunda correcao
								(cor3.id is null and cor4.id is null)) or								                       -- *** DDH na primeira ou segunda correcao
							(	(cor3.competencia5 <> -1 and  														           -- DDH na terceira correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is null)) or  -- DDH na terceira correcao
							(	(cor4.competencia5 <> -1 and  															       -- DDH na quarta correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is not null)) -- DDH na quarta correcao   
					    ) or 
						-- **** NOTA MIL 
						(	(aud.tipo_id = 1) and
							(	(cor1.nota_final <> 1000 OR cor2.nota_final <> 1000) and                                       -- *** MIL na primeira ou segunda correcao
								(cor3.id is null and cor4.id is null)) or								                       -- *** MIL na primeira ou segunda correcao
							(	(((cor1.nota_final <> 1000 AND cor2.nota_final <> 1000) OR                                     -- *** MIL na primeira ou segunda com a terceira
							      (cor3.nota_final <> 1000)) and  				    			                               -- *** MIL na primeira ou segunda com a terceira
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is null)) or  -- MIL na terceira correcao
							(	(cor4.nota_final <> 1000 and  															       -- MIL na quarta correcao
								 cor1.id is not null and cor2.id is not null and cor3.id is not null and cor4.id is not null)) -- MIL na quarta correcao   
					    )					
					)
				)
			) -- final do pareteses do ABS
		from correcoes_filaauditoria filaud 
		 where filaud.redacao_id = @redacao_id  AND 
		       filaud.id_projeto = @ID_PROJETO
	END -- FIM FILAUD
	
GO
/****** Object:  StoredProcedure [dbo].[sp_consome_analise_discrepancia]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[sp_consome_analise_discrepancia] 
as
declare @CODBARRA varchar(100)
declare @ID_ANALISE int
declare @REDACAO_ID int
declare @fila int

declare cur_con_ana_dis cursor for 
    select redacao_id, co_barra_redacao,id, id_tipo_correcao_B + 1
      from correcoes_analise 
     where conclusao_analise > 2 and 
      fila = 0
    open cur_con_ana_dis 
        fetch next from cur_con_ana_dis into @REDACAO_ID, @CODBARRA, @ID_ANALISE, @FILA
        while @@FETCH_STATUS = 0
            BEGIN
                EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA,@REDACAO_ID, @ID_ANALISE, 3


            fetch next from cur_con_ana_dis into  @REDACAO_ID, @CODBARRA, @ID_ANALISE, @FILA
            END
    close cur_con_ana_dis 
deallocate cur_con_ana_dis
GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[sp_consome_pendencia_analise] as
DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)
DECLARE @RETORNO_AUX      VARCHAR(500)
DECLARE @CO_BARRA_REDACAO VARCHAR(50)

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
    SELECT id, id_correcao, id_tipo_correcao, id_projeto FROM CORRECOES_PENDENTEANALISE PEN 
     WHERE NOT EXISTS (SELECT 1
                        FROM CORRECOES_PENDENTEANALISE PENX 
                       WHERE PENX.ERRO IS NOT NULL AND
                             PENX.redacao_id = PEN.redacao_id) AND
			                 PEN.criado_em <= DATEADD(second, -10, dbo.getlocaldate())
      ORDER BY ID

    open CRS_ANALISE
        fetch next from CRS_ANALISE into @id, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
        while @@FETCH_STATUS = 0
            BEGIN

                /****************************************************************************************/
                /* CONFORME O TIPO DE CORRECAO E DIRECIONADO PARA UMA COMPARACAO                        */
                /* GRAVACAO 1-(COMPARACAO 1,2) 2-(COMPARACAO 1,3) 3-(COMPARACAO 2-3) 4-(COMPARACAO 3-4) */
                /* GRAVACAO 5-(COMPARACAO 5,gabarito)                                                   */
                /* CASO TIPO GRAVACAO SEJA 1 OU 2 SERA EXECUTADO APENAS A GRVACAO 1                     */
                /* CASO TIPO GRAVACAO SEJA 3 SERA EXECUTADO A GRVACAO 2 E A 3                           */
                /* CASO TIPO GRAVACAO SEJA 4 SERA EXECUTADO A GRVACAO 3 E A 4                           */
                /* CASO TIPO GRAVACAO SEJA 5 SERA EXECUTADO A GRVACAO 5 E A GABARITO                    */
                /* PARA DEMAIS TIPOS AINDA TEMOS QUE TRATAR FUTURAMENTE                                 */
                /****************************************************************************************/
                IF(@ID_TIPO_CORRECAO IN (1,2))
                    BEGIN
                        EXEC  sp_inserir_analise @ID_CORRECAO,1, @ID_PROJETO, @retorno output
                        /*****************************************************************/
                        /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
                        /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
                        /*****************************************************************/
                        IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
                            BEGIN
                                DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                            END
                        ELSE
                            BEGIN
                                UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                            END
                    END
                ELSE IF(@ID_TIPO_CORRECAO =3 )
                    BEGIN
                        BEGIN TRY
                            BEGIN TRANSACTION

                            EXEC  sp_inserir_analise @ID_CORRECAO,2, @ID_PROJETO, @retorno output
                            IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                                END

                            EXEC  sp_inserir_analise @ID_CORRECAO,3, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT
                        END TRY
                        BEGIN CATCH
                            ROLLBACK
                        END CATCH
                    END
                ELSE IF(@ID_TIPO_CORRECAO =4 )
                    BEGIN
                        BEGIN TRY
                            BEGIN TRANSACTION

                            EXEC  sp_inserir_analise @ID_CORRECAO,4, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT
                        END TRY
                        BEGIN CATCH
                            ROLLBACK
                        END CATCH
                    END
                -- OURO
                ELSE IF(@ID_TIPO_CORRECAO = 5)
                    BEGIN
                        BEGIN TRY
                            BEGIN TRANSACTION

                            EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT
                        END TRY
                        BEGIN CATCH
                            ROLLBACK
                        END CATCH
                    END
                -- MODA
                ELSE IF(@ID_TIPO_CORRECAO = 6)
                    BEGIN
                        BEGIN TRY
                            BEGIN TRANSACTION

                            EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN
                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT
                        END TRY
                        BEGIN CATCH
                            ROLLBACK
                        END CATCH
                    END
                --- AUDITORIA
                ELSE IF(@ID_TIPO_CORRECAO = 7)
                    BEGIN
--                      BEGIN TRY
--                          BEGIN TRAN TIPO7

                            EXEC  sp_inserir_analise_auditoria @ID_CORRECAO, @ID_PROJETO, @RETORNO_AUX output
                            IF(@RETORNO_AUX in('OK','JÁ EXISTE','NAO EXISTE'))
                                BEGIN
                                    DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                                END
                            ELSE
                                BEGIN

                                    UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO_AUX + ' **** ' + @RETORNO_AUX
                                     WHERE ID = @ID
                                END
                            COMMIT TRAN TIPO7
--                      END TRY
--                      BEGIN CATCH
--                          ROLLBACK TRAN TIPO7
--                      END CATCH
                    END

            fetch next from CRS_ANALISE into @ID, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
            END
    close CRS_ANALISE
deallocate CRS_ANALISE
GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise_gabarito]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE      PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito] as

DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
    SELECT id, erro, id_correcao,id_tipo_correcao, id_projeto
      FROM CORRECOES_PENDENTEANALISE PEN
     WHERE NOT EXISTS (SELECT 1
                        FROM CORRECOES_PENDENTEANALISE PENX
                       WHERE PENX.ERRO IS NOT NULL AND
                             PENX.redacao_id = PEN.redacao_id)
      ORDER BY ID

    open CRS_ANALISE
        fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
        while @@FETCH_STATUS = 0
            BEGIN
                IF(@ID_TIPO_CORRECAO IN (1,2))
                    BEGIN
                        EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @retorno output
                        /*****************************************************************/
                        /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
                        /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
                        /*****************************************************************/
                        IF(@RETORNO in('OK','JÁ EXISTE'))
                            BEGIN
                                DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                            END
                        ELSE
                            BEGIN
                                UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                            END
                    END


            fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
            END
    close CRS_ANALISE
deallocate CRS_ANALISE

GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise_gabarito_preteste]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito_preteste] as

DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)
DECLARE @CO_BARRA_REDACAO VARCHAR(50)
DECLARE @REDACAO_ID       INT

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
    SELECT id, erro, id_correcao, co_barra_redacao,id_tipo_correcao, id_projeto, redacao_id
      FROM CORRECOES_PENDENTEANALISE PEN
     WHERE NOT EXISTS (SELECT 1
                        FROM CORRECOES_PENDENTEANALISE PENX
                       WHERE PENX.ERRO IS NOT NULL AND
                             PENX.REDACAO_ID = PEN.REDACAO_ID)
      ORDER BY ID

    open CRS_ANALISE
        fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO,  @ID_TIPO_CORRECAO, @ID_PROJETO, @REDACAO_ID
        while @@FETCH_STATUS = 0
            BEGIN
                IF(@ID_TIPO_CORRECAO IN (1,2))
                    BEGIN
                        EXEC  sp_inserir_analise_gabarito_preteste @ID_CORRECAO, @ID_PROJETO, @retorno output
                        /*****************************************************************/
                        /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
                        /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
                        /*****************************************************************/
                        IF(@RETORNO in('OK','JÁ EXISTE'))
                            BEGIN
                                DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                            END
                        ELSE
                            BEGIN
                                UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                            END
                    END


            fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @CO_BARRA_REDACAO, @ID_TIPO_CORRECAO, @ID_PROJETO, @REDACAO_ID
            END
    close CRS_ANALISE
deallocate CRS_ANALISE

GO
/****** Object:  StoredProcedure [dbo].[sp_consome_pendencia_analise_gabarito_preteste_enem]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create       PROCEDURE [dbo].[sp_consome_pendencia_analise_gabarito_preteste_enem] as

DECLARE @ID               INT
DECLARE @ID_CORRECAO      INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_PROJETO       INT
DECLARE @ERRO             VARCHAR(500)
DECLARE @RETORNO          VARCHAR(500)

/****** INICIO DO CURSOR ******/
declare CRS_ANALISE cursor for
    SELECT id, erro, id_correcao, id_tipo_correcao, id_projeto
      FROM CORRECOES_PENDENTEANALISE PEN
     WHERE NOT EXISTS (SELECT 1
                        FROM CORRECOES_PENDENTEANALISE PENX
                       WHERE PENX.ERRO IS NOT NULL AND
                             PENX.REDACAO_ID = PEN.REDACAO_ID)
      ORDER BY ID

    open CRS_ANALISE
        fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
        while @@FETCH_STATUS = 0
            BEGIN
                IF(@ID_TIPO_CORRECAO IN (5, 6))
                    BEGIN
                        EXEC  sp_inserir_analise_gabarito_preteste_enem @ID_CORRECAO, @ID_PROJETO, @retorno output
                        /*****************************************************************/
                        /* SE O RETORNO FOR POSITIVO E DELETADO DA FILA DE PENDENTES     */
                        /* CASO CONTRARIO E GRAVADO A MENSAGEM DE ERRO QUE FOI RETORNADA */
                        /*****************************************************************/
                        IF(@RETORNO in('OK','JÁ EXISTE'))
                            BEGIN
                                DELETE FROM CORRECOES_PENDENTEANALISE WHERE ID = @ID
                            END
                        ELSE
                            BEGIN
                                UPDATE CORRECOES_PENDENTEANALISE SET ERRO = @RETORNO WHERE ID = @ID
                            END
                    END


            fetch next from CRS_ANALISE into @ID, @ERRO, @ID_CORRECAO, @ID_TIPO_CORRECAO, @ID_PROJETO
            END
    close CRS_ANALISE
deallocate CRS_ANALISE
GO
/****** Object:  StoredProcedure [dbo].[SP_COPIAR_NOTAS_FINAL_REDACAO]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                        [SP_COPIAR_NOTAS_FINAL_REDACAO]                                         *
*                                                                                                                *
*  PROCEDURE QUE FAZ A COPIA DAS NOTAS DE COMPETENCIA PARA A A TABELA DE REDACAO QUANDO ESTA E FINALIZADA JUNTAM *
* ENTE COM ISSO E FEITO ALGUMAS VALIDACOES CASO EXISTA ALGUM PROBELMA SERA SETADO O ID_STATUS DA REDACAO PARA 3  *
* (Em Revisão) E A DATA DE TERMINO RECEBERA NULL                                                                 *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/

						/************** TESTAR O TIPO DE GRAVACAO: *****************
						*               1-(COMPARACAO 1,2) 						   *
						*               2-(COMPARACAO 1,3) 						   *
						*               3-(COMPARACAO 2-3) 						   *
						*               4-(COMPARACAO 3-4)						   *
						*               5-(COMPARACAO 5 E OURO) 				   *
						*               6-(COMPARACAO 6-MODA) 					   *
						*               7-(COMPAFRACAO 7-ABSOLUTA)				   *
						************************************************************/

--  exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRACAO, @REDACAO_ID, @ANALISE_ID, @PROJETO_ID
CREATE   PROCEDURE [dbo].[SP_COPIAR_NOTAS_FINAL_REDACAO] 
    @TIPO_GRACAO INT,
    @REDACAO_ID  INT,
    @ANALISE_ID  INT, 
    @PROJETO_ID  INT 

	AS 

-- **** CASO A REDACAO SEJA FINALIZADA NA COMPARACAO ENTRE PRIMEIRA E SEGUNDA ****
IF(@TIPO_GRACAO = 1)	
	BEGIN		 
		BEGIN TRAN 
			BEGIN TRY
				update red set red.nota_competencia1 = (nota_competencia1_A + nota_competencia1_B)/2.0,
					   red.nota_competencia2 = (nota_competencia2_A + nota_competencia2_B)/2.0,
					   red.nota_competencia3 = (nota_competencia3_A + nota_competencia3_B)/2.0,
					   red.nota_competencia4 = (nota_competencia4_A + nota_competencia4_B)/2.0,
					   red.nota_competencia5 = (nota_competencia5_A + nota_competencia5_B)/2.0
				  from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id AND 
				                                                             RED.id_projeto = ANA.id_projeto)
				 where ana.id_tipo_correcao_B = 2 and conclusao_analise <= 2  and 
					   RED.id_status = 4          AND 
					   red.nota_final IS NOT NULL AND 
		 			   ana.id = @ANALISE_ID       AND 
					   red.id = @REDACAO_ID       AND 
					   red.id_projeto = @PROJETO_ID

				IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) +
										                     ISNULL(RED.nota_competencia4,-1) + ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
					BEGIN 
						ROLLBACK
						update correcoes_redacao set id_status = 3, data_termino = null where ID = @REDACAO_ID 
					END
				ELSE 
					BEGIN
						COMMIT 
					END
			END TRY
			BEGIN CATCH
				ROLLBACK
			END CATCH
	END

-- **** CASO A REDACAO SEJA FINALIZADA NA COMPARACAO ENTRE PRIMEIRA COM TERCEIRA E SEGUNDA COM TERCEIRA
-- **** SERA PASSADO O TIPO_GRAVACAO 3 PARA SELECAO DA CARGA
IF(@TIPO_GRACAO = 3)
	BEGIN
		IF EXISTS (SELECT 1 FROM correcoes_tipo WHERE flag_soberano = 1 AND id = 3) 
			BEGIN -- TESTE SOBERANA
				BEGIN TRAN
					BEGIN TRY						
						update red set red.nota_competencia1 = nota_competencia1_B,
									   red.nota_competencia2 = nota_competencia2_B,
									   red.nota_competencia3 = nota_competencia3_B,
									   red.nota_competencia4 = nota_competencia4_B,
									   red.nota_competencia5 = nota_competencia5_B
						   from correcoes_redacao red  join correcoes_analise ana on (red.id = ana.redacao_id AND
																				      red.id_projeto = ana.id_projeto)
						  where ana.id_tipo_correcao_B = 3 and 
							    red.id = @REDACAO_ID       AND 
							    red.id_projeto = @PROJETO_ID 

						IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + 
										                     ISNULL(RED.nota_competencia4,-1) + ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
							BEGIN 
								ROLLBACK
						        update correcoes_redacao set id_status = 3, data_termino = null where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
				        ROLLBACK
					END CATCH
			END -- FIM TESTE SOBERANA
		ELSE
			BEGIN -- ELSE TESTE SOBERANA
				BEGIN TRAN
					BEGIN TRY						
						update red set red.nota_competencia1 = CASE WHEN ABS(nota_final_cor3 - nota_final_cor1) < ABS(nota_final_cor3 - nota_final_cor2) then ABS(nota_comp11 + nota_comp31)/2 else ABS(nota_comp21 + nota_comp31)/2 end ,
									   red.nota_competencia2 = CASE WHEN ABS(nota_final_cor3 - nota_final_cor1) < ABS(nota_final_cor3 - nota_final_cor2) then ABS(nota_comp12 + nota_comp32)/2 else ABS(nota_comp22 + nota_comp32)/2 end ,
									   red.nota_competencia3 = CASE WHEN ABS(nota_final_cor3 - nota_final_cor1) < ABS(nota_final_cor3 - nota_final_cor2) then ABS(nota_comp13 + nota_comp33)/2 else ABS(nota_comp23 + nota_comp33)/2 end ,
									   red.nota_competencia4 = CASE WHEN ABS(nota_final_cor3 - nota_final_cor1) < ABS(nota_final_cor3 - nota_final_cor2) then ABS(nota_comp14 + nota_comp34)/2 else ABS(nota_comp24 + nota_comp34)/2 end ,
									   red.nota_competencia5 = CASE WHEN ABS(nota_final_cor3 - nota_final_cor1) < ABS(nota_final_cor3 - nota_final_cor2) then ABS(nota_comp15 + nota_comp35)/2 else ABS(nota_comp25 + nota_comp35)/2 end 
						   from correcoes_redacao red  join vw_analise_terceira_finalizadas ANA ON (ANA.ID = RED.ID AND 
						                                                                            ANA.ID_PROJETO = RED.ID_PROJETO)
						  where (ana.conclusao_analise13  <= 2 OR ANA.CONCLUSAO_ANALISE23 <= 2) AND
							     red.id = @REDACAO_ID         AND 
							     red.id_projeto = @PROJETO_ID 

						IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                            RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + 
										                     ISNULL(RED.nota_competencia4,-1) + ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
							BEGIN 
								ROLLBACK
								update correcoes_redacao set id_status = 3, data_termino = null  where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
				        ROLLBACK
					END CATCH
			END -- FIM ELSE TESTE SOBERANA
	END 

-- **** CASO A REDACAO SEJA FINALIZADA NA QUARTA
-- **** SERA PASSADO O TIPO_GRAVACAO 4 PARA SELECAO DA CARGA
IF(@TIPO_GRACAO = 4)
	BEGIN
		BEGIN TRAN 
			BEGIN TRY
				update red set red.nota_competencia1 = nota_competencia1_B,
					           red.nota_competencia2 = nota_competencia2_B,
					           red.nota_competencia3 = nota_competencia3_B,
					           red.nota_competencia4 = nota_competencia4_B,
					           red.nota_competencia5 = nota_competencia5_B
				  FROM correcoes_redacao RED JOIN correcoes_analise ANA ON (RED.id = ANA.redacao_id AND 
				                                                            RED.id_projeto = ANA.id_projeto)
				where RED.id         = @REDACAO_ID AND
				      RED.id_projeto = @PROJETO_ID AND
					  ANA.id_tipo_correcao_B = 4   and 
					  ANA.id  = @ANALISE_ID

			IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + 
										                      ISNULL(RED.nota_competencia4,-1) + ISNULL(RED.nota_competencia5,-1)))  or 
										  (fil.fila <> 0) )
										 )
							BEGIN 
								ROLLBACK
								update correcoes_redacao set id_status = 3, data_termino = null  where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
				        ROLLBACK
					END CATCH
	END 

-- **** CASO A REDACAO SEJA FINALIZADA NA AUDITORIA
-- **** SERA PASSADO O TIPO_GRAVACAO 4 PARA SELECAO DA CARGA
IF(@TIPO_GRACAO = 7)
	BEGIN
		BEGIN TRAN 
			BEGIN TRY
				update red set red.nota_competencia1 = ANA.nota_competencia1_A,
					           red.nota_competencia2 = ANA.nota_competencia2_A,
					           red.nota_competencia3 = ANA.nota_competencia3_A,
					           red.nota_competencia4 = ANA.nota_competencia4_A,
					           red.nota_competencia5 = ANA.nota_competencia5_A

				  FROM correcoes_redacao RED JOIN correcoes_analise ANA ON (RED.id = ANA.redacao_id AND 
				                                                            RED.id_projeto = ANA.id_projeto)
				where RED.id                 = @REDACAO_ID AND
				      RED.id_projeto         = @PROJETO_ID AND
					  ANA.id_tipo_correcao_A = 7           AND 
					  ANA.id                 = @ANALISE_ID    

			IF EXISTS (SELECT 1 FROM correcoes_redacao RED join VW_FILAS_DA_REDACAO fil on (RED.id = fil.REDACAO_ID and 
			                                                                                RED.id_projeto = fil.ID_PROJETO)
									WHERE RED.id = @REDACAO_ID AND RED.id_projeto = @PROJETO_ID and 
									     ((
									      RED.nota_final <> (ISNULL(RED.nota_competencia1,-1) + ISNULL(RED.nota_competencia2,-1) + ISNULL(RED.nota_competencia3,-1) + 
										                     ISNULL(RED.nota_competencia4,-1) + ISNULL(RED.nota_competencia5,-1))) or 
										  (fil.fila <> 0) )
										  )
							BEGIN 
								ROLLBACK
								update correcoes_redacao set id_status = 3, data_termino = null  where ID = @REDACAO_ID 
							END
						ELSE 
							BEGIN
								COMMIT 
							END
					END TRY 
					BEGIN CATCH
				        ROLLBACK
					END CATCH
	END 
GO
/****** Object:  StoredProcedure [dbo].[SP_COR_VALIDAR_CORRECAO]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                           [SP_COR_VALIDAR_CORRECAO]                                            *
*                                                                                                                *
*  PROCEDURE QUE FAZ VALIDACOES NAS CORRECOES FINALIZADAS. DEVERA SER CHAMADA APOS O FECHAMENTO DE UM CICLO DE   *
*  VIDA DE UMA REDACAO.                                                                                          *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/
CREATE   PROCEDURE [dbo].[SP_COR_VALIDAR_CORRECAO] 
                 @REDACAO_ID INT, @ID_CORRECAO INT, @TIPO_GRAVACAO INT,	@ID_PROJETO INT 
AS 


									/***********************************
											TIPOS DE GRAVACAO 

										1-(COMPARACAO 1,2) 
										2-(COMPARACAO 1,3) 
										3-(COMPARACAO 2-3) 
										4-(COMPARACAO 3-4)
										5-(COMPARACAO 5 E OURO) 
										6-(COMPARACAO 6-MODA) 
										7-(COMPAFRACAO 7-ABSOLUTA)
									************************************/

/*
	SELECT RED.ID, COR1.id, COR2.id, RED.id_projeto, ANA.CONCLUSAO_ANALISE, RED.*
	  FROM CORRECOES_REDACAO RED JOIN CORRECOES_CORRECAO COR1 ON (RED.ID = COR1.REDACAO_ID AND COR1.id_tipo_correcao = 1)
	                                    JOIN CORRECOES_CORRECAO COR2 ON (RED.ID = COR2.REDACAO_ID AND COR2.id_tipo_correcao = 2)
	                                    JOIN CORRECOES_CORRECAO COR3 ON (RED.ID = COR3.REDACAO_ID AND COR3.id_tipo_correcao = 3)
										JOIN correcoes_analise ANA ON (ANA.id_correcao_B = COR3.id )
	WHERE ANA.CONCLUSAO_ANALISE <=2

	     AND RED.ID = 270176
		 
	SELECT * FROM CORRECOES_CORRECAO WHERE REDACAO_ID = 270418
	SELECT * FROM CORRECOES_REDACAO WHERE ID = 270418
	SELECT * FROM VW_FILAS_DA_REDACAO WHERE REDACAO_ID = 270418
*/

-- select redacao_id, id, id_projeto, * from correcoes_ANALISE where id_tipo_correcao_B = 3 AND REDACAO_ID = 270418


DECLARE  @STATUS INT

	SET @REDACAO_ID = 271160
	SET @ID_CORRECAO = 1102  
	SET @ID_PROJETO = 4
	SET @TIPO_GRAVACAO = 4
	SET @STATUS = 0 -- (1 - OK / 0 - PROBLEMA) 


-- VALIDAR SE AS COMPETENCIAS ESTAO CORRETAS
-- ******* VALIDACAO DAS CORRECOES  *******
SELECT  @STATUS = COUNT(DISTINCT 1)
      -- COR.nota_final , (COR.nota_competencia1 + COR.nota_competencia2 + COR.nota_competencia3 + COR.nota_competencia4 + CASE WHEN PRO.etapa_ensino_id = 2 THEN COR.nota_competencia5 ELSE 0 END ),* 
FROM correcoes_correcao COR WITH(NOLOCK) JOIN projeto_projeto PRO WITH(NOLOCK) ON (COR.id_projeto = PRO.ID)
WHERE COR.id         = @ID_CORRECAO  AND  
      COR.id_projeto = @ID_PROJETO   AND 
	  COR.id_status  = 3             AND

	  ((COR.id_correcao_situacao > 1 AND      -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia1 IS NULL     AND      -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia2 IS NULL     AND 	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia3 IS NULL     AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia4 IS NULL     AND 	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia5 IS NULL)     OR	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	   (COR.id_correcao_situacao = 1 AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
	    COR.competencia1 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
      	COR.competencia2 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
		COR.competencia3 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
		COR.competencia4 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
		((COR.competencia5 IS NOT NULL AND 	    -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
		  PRO.etapa_ensino_id = 2        )  OR	-- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
		 (ISNULL(COR.competencia5,-1) = -1 AND  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
		  PRO.etapa_ensino_id = 1)))  )    AND  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM

	  ((COR.id_correcao_situacao > 1 AND COR.nota_final = 0) OR  -- SITUACAO DIFERENTE DE NORMAL A NOTA FINAL TEM QUE SER ZERO
	   (COR.id_correcao_situacao = 1 AND 
	    COR.nota_final = (COR.nota_competencia1 + COR.nota_competencia2 + COR.nota_competencia3 + COR.nota_competencia4 + 
		                  CASE WHEN PRO.etapa_ensino_id = 2 THEN COR.nota_competencia5 ELSE 0 END ))) AND -- SITUACAO NORMAL A SOMA DAS COMPETENCIAS TEM QUE SER IGUAL A NOTA TOTAL 
	
	(ISNULL(competencia1,0) * PRO.peso_competencia = nota_competencia1 AND -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	 ISNULL(competencia2,0) * PRO.peso_competencia = nota_competencia2 AND -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	 ISNULL(competencia3,0) * PRO.peso_competencia = nota_competencia3 AND -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	 ISNULL(competencia4,0) * PRO.peso_competencia = nota_competencia4 AND -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	 CASE WHEN COMPETENCIA5 = -1 THEN 0 ELSE ISNULL(competencia5,0) END *  -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
	            PRO.peso_competencia = ISNULL(nota_competencia5,0))        -- VALIDAR SE O CALCULO DA NOTA POR COMPETENCIA ESTA CORRETO 
PRINT 'VALIDACAO 1'
PRINT @STATUS 
--########################################################################################################
/*** TESTAR SE A REDACAO POSSUI STATUS DE CONCLUIDA E SE ENCONTRA ABERTA EM ALGUMA FILA DE CORRECAO OU COM CORRECAO AINDA EM ABERTO ***/
IF( @STATUS = 1)
    BEGIN
		SELECT  @STATUS = COUNT(distinct 1) 
		  FROM correcoes_redacao RED WITH(NOLOCK) LEFT JOIN correcoes_correcao      COR WITH(NOLOCK) ON (RED.id = COR.redacao_id AND 
		                                                                                                 RED.id_projeto = COR.id_projeto)
		                                          LEFT JOIN VW_FILAS_DA_REDACAO     FIL WITH(NOLOCK) ON (RED.id = FIL.REDACAO_ID AND 
												                                                         RED.id_projeto = FIL.ID_PROJETO)

		 WHERE RED.id          = @REDACAO_ID AND 
		       RED.id_projeto  = @ID_PROJETO AND              
			   ((RED.id_status = 4           AND       -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
	             RED.data_termino IS NOT NULL AND      -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
			      (COR.id  IS NOT NULL   OR  		   -- CASO EXISTA FINALIZACAO NA REDACAO (STATUS = 4 E DATA) E AINDA ASSIM EXISTA REGISTRO EM FILAS OU CORRECAO ABERTA <> 3
				   FIL.fila IS not NULL) )  
				)
	END
PRINT 'VALIDACAO 2'
print @status
---##################################################################################################
IF(@TIPO_GRAVACAO = 1 AND @STATUS = 1) -- QUANDO FOR COMPARACAO DE 1 COM 2 
	BEGIN
		SELECT @STATUS = COUNT(DISTINCT 1)
		  FROM correcoes_analise ANA WITH(NOLOCK) JOIN correcoes_conclusao_analise CCA  WITH(NOLOCK) ON (ANA.conclusao_analise = CCA.id)
		                                          JOIN correcoes_redacao           RED  WITH(NOLOCK) ON (ANA.redacao_id        = RED.ID AND 
												                                                         ANA.id_projeto        = RED.id_projeto)
											 LEFT JOIN correcoes_fila3             FIL3 WITH(NOLOCK) ON (FIL3.redacao_id       = ANA.redacao_id and 
											                                                             FIL3.id_projeto       = ANA.id_projeto)
											 LEFT JOIN CORRECOES_FILA4             FIL4 WITH(NOLOCK) ON (FIL4.redacao_id       = ANA.redacao_id and 
											                                                             FIL4.id_projeto       = ANA.id_projeto)
											 LEFT JOIN CORRECOES_CORRECAO          COR  WITH(NOLOCK) ON (COR.redacao_id       = ANA.redacao_id AND 
											                                                             COR.id_projeto       = ANA.id_projeto AND 
																										 COR.id_tipo_correcao IN (3,4,7))
		  WHERE ANA.redacao_id     = @REDACAO_ID   AND
		        ANA.id_projeto     = @ID_PROJETO   AND 
				ANA.id_tipo_correcao_B = 2         AND 
				(ANA.id_correcao_A = @ID_CORRECAO   OR 
		         ANA.id_correcao_B = @ID_CORRECAO) AND
				((CCA.discrepou = 0                AND     -- ** SE NAO DISCREPAR {
				  RED.id_status = 4                AND     -- O STATUS DA REDACAO TEM QUE SER 4             AJUSTE - AINDA NAO ESTA SENDO GRAVADO O STATUS E A DATA DE CONCLUSAO 
				  RED.data_termino IS NOT NULL     AND     -- A DATA DE CONCLUSAO DEVERA ESTAR PREENCHIDA   AJUSTE - AINDA NAO ESTA SENDO GRAVADO O STATUS E A DATA DE CONCLUSAO
				  FIL3.ID IS NULL                  AND     -- NAO PODE TER REGISTRO NA FILA 3
				  FIL4.ID IS NULL                  AND     -- NAO PODE TER REGSITRO NA FILA 4
				  COR.id IS NULL                           -- NAO PODE TER REGISTRO DE CORRECAO DE QUARTA }
				  ) 
		        )
    END
PRINT 'VALIDACAO 3'
print @status
---##################################################################################################


--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
---#################################################################################################
/*
--   select id_projeto,redacao_id,id_correcao_b, id_tipo_correcao_A,  id_tipo_correcao_b, * from correcoes_analise where redacao_id =20506 and id_correcao_A = 16367
--   select top 1000 redacao_id, id, id_projeto, * from correcoes_CORRECAO cor
--   where id_tipo_correcao = 2 and id_correcao_situacao <> 1 and exists (select 1 from correcoes_analise ana where ana.id_correcao_A  = cor.id and ana.id_tipo_correcao_B = 3  )

/****  QUANDO FOR COMPARACAO DE  1 COM 3 e a TERCEIRA FOR ABSOLUTA ***/
IF(@TIPO_GRAVACAO =2 AND @STATUS = 1) -- QUANDO FOR COMPARACAO DE 1 COM 3  
	BEGIN
	 
		SELECT  @STATUS = COUNT (distinct 1)
		  FROM CORRECOES_ANALISE ANA WITH(NOLOCK) JOIN projeto_projeto PRO WITH(NOLOCK) ON (ana.id_projeto = PRO.ID)
		                                          JOIN correcoes_conclusao_analise CCA  WITH(NOLOCK) ON (ANA.conclusao_analise = CCA.id)
		                                          JOIN correcoes_redacao           RED  WITH(NOLOCK) ON (ANA.redacao_id        = RED.ID AND 
												                                                         ANA.id_projeto        = RED.id_projeto)
											      JOIN correcoes_CORRECAO          COR1 WITH(NOLOCK) ON (COR1.redacao_id       = ANA.redacao_id AND 
												                                                         COR1.id               = ANA.id_correcao_A and 
												                                                         COR1.id_projeto       = ANA.id_projeto)
												 JOIN VW_FILAS_DA_REDACAO            FIL WITH(NOLOCK) ON (FIL.REDACAO_ID = ANA.redacao_id AND 
												                                                        FIL.id_projeto = ANA.id_projeto)
	     WHERE ANA.redacao_id    = @REDACAO_ID  AND 
		       ANA.id_projeto    = @ID_PROJETO  AND 
			   ANA.id_correcao_b = @ID_CORRECAO AND  
			   FIL.FILA          = 0            AND 
		       ANA.id_tipo_correcao_A = 1       AND 
		       ANA.id_tipo_correcao_B = 3       AND 
			   (EXISTS (select 1 from correcoes_tipo where id = 3 and flag_soberano = 1 ) AND 
					(
						(COR1.id_correcao_situacao = 1 AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia1 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
      					 COR1.competencia2 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia3 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia4 IS NOT NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
		                (	(COR1.competencia5 IS NOT NULL AND -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 			 PRO.etapa_ensino_id = 2        
							)  OR	-- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 			(ISNULL(COR1.competencia5,-1) = -1 AND  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
				 	         PRO.etapa_ensino_id = 1)              -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM
							)
						)or         -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS - DEPENDE DO TIPO DO PROCESSO EF OU EM 
						(COR1.id_correcao_situacao <> 1 AND -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia1 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
      					 COR1.competencia2 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia3 IS NULL AND	  -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia4 IS NULL AND    -- VALINDANDO PREENCHIMENTO DAS COMPETENCIAS
						 COR1.competencia5 IS NULL 
						)
					)         
			    )	
	END 
	PRINT 'VALIDACAO 4'
print @status */

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
---##################################################################################################
 
/****  QUANDO FOR COMPARACAO DE  2 COM 3 e a TERCEIRA FOR ABSOLUTA ***/
IF(@TIPO_GRAVACAO =3 AND @STATUS = 1) -- QUANDO FOR COMPARACAO DE 2 COM 3  
	BEGIN
		select @STATUS = COUNT (distinct 1)
		  FROM vw_analise_terceira_finalizadas ANA left join VW_FILAS_DA_REDACAO     fil on (ANA.ID = fil.REDACAO_ID and ANA.id_projeto = fil.ID_PROJETO)
		                                           left join vw_redacao_equidistante equ on (ANA.ID = equ.redacao_id and ANA.id_projeto = equ.id_projeto)
		 WHERE ANA.id            = @REDACAO_ID   AND 
		       ANA.id_projeto    = @ID_PROJETO   AND 
			   isnull(fil.fila,0) = 0       and
			   isnull(equ.redacao_id,0) = 0 AND

			   ( (ANA.SITUACAO1 = 1 AND 
			      ANA.comp11 IS not NULL AND 
			      ANA.comp12 IS not NULL AND 
			      ANA.comp13 IS not NULL AND 
			      ANA.comp14 IS not NULL AND 
			      ANA.comp15 IS not NULL) OR  
			     (ANA.SITUACAO1 <> 1 AND 
			      ANA.comp11 IS NULL AND 
			      ANA.comp12 IS NULL AND 
			      ANA.comp13 IS NULL AND 
			      ANA.comp14 IS NULL AND 
			      ANA.comp15 IS NULL)
			   )AND
			   ( (ANA.SITUACAO2 = 1 AND 
			      ANA.comp21 IS not NULL AND 
			      ANA.comp22 IS not NULL AND 
			      ANA.comp23 IS not NULL AND 
			      ANA.comp24 IS not NULL AND 
			      ANA.comp25 IS not NULL) OR  
			     (ANA.SITUACAO2 <> 1 AND 
			      ANA.comp21 IS NULL AND 
			      ANA.comp22 IS NULL AND 
			      ANA.comp23 IS NULL AND 
			      ANA.comp24 IS NULL AND 
			      ANA.comp25 IS NULL)
			   )AND
			   ( (ANA.SITUACAO3 = 1 AND 
			      ANA.comp31 IS not NULL AND 
			      ANA.comp32 IS not NULL AND 
			      ANA.comp33 IS not NULL AND 
			      ANA.comp34 IS not NULL AND 
			      ANA.comp35 IS not NULL) OR  
			     (ANA.SITUACAO3 <> 1 AND 
			      ANA.comp31 IS NULL AND 
			      ANA.comp32 IS NULL AND 
			      ANA.comp33 IS NULL AND 
			      ANA.comp34 IS  NULL AND 
			      ANA.comp35 IS NULL)
			   ) 
	END
PRINT 'VALIDACAO 5'
PRINT @STATUS 

 
/****  QUANDO FOR ANALISE 4 ABSOLUTA ***/
IF(@TIPO_GRAVACAO = 4 AND @STATUS = 1) -- QUANDO FOR TIPO 4
	BEGIN
		SELECT @STATUS = COUNT (distinct 1)
		  FROM correcoes_redacao RED JOIN correcoes_correcao  COR4 ON (RED.ID = COR4.REDACAO_ID AND RED.ID_PROJETO = COR4.ID_PROJETO AND COR4.id_tipo_correcao = 4)
		                        LEFT JOIN correcoes_correcao  AUD  ON (RED.id = AUD.redacao_id AND RED.id_projeto = AUD.id_projeto AND AUD.id_tipo_correcao = 7)
								LEFT JOIN VW_FILAS_DA_REDACAO FIL  ON (RED.ID = FIL.REDACAO_ID AND RED.id_projeto = FIL.ID_PROJETO)
		WHERE RED.id = @REDACAO_ID         AND 
		      RED.id_projeto = @ID_PROJETO AND 
			  AUD.id IS NULL         AND 
			  ISNULL(FIL.FILA,0) = 0 AND 
			  (	(RED.nota_final = COR4.nota_final AND 
			     RED.nota_competencia1 = COR4.nota_competencia1 AND
			     RED.nota_competencia2 = COR4.nota_competencia2 AND
			     RED.nota_competencia3 = COR4.nota_competencia3 AND
			     RED.nota_competencia4 = COR4.nota_competencia4 AND
			     RED.nota_competencia5 = COR4.nota_competencia5  )
			  )
	END

/****  QUANDO FOR ANALISE AUDITORIA ***/
IF(@TIPO_GRAVACAO = 4 AND @STATUS = 1) -- QUANDO FOR TIPO 7
	BEGIN
		SELECT @STATUS = COUNT (distinct 1)
		  FROM correcoes_redacao RED JOIN correcoes_correcao  COR7 ON (RED.ID = COR7.REDACAO_ID AND RED.ID_PROJETO = COR7.ID_PROJETO AND COR7.id_tipo_correcao = 7)
								LEFT JOIN VW_FILAS_DA_REDACAO FIL  ON (RED.ID = FIL.REDACAO_ID AND RED.id_projeto = FIL.ID_PROJETO)
		WHERE RED.id = @REDACAO_ID         AND 
		      RED.id_projeto = @ID_PROJETO AND 
			  ISNULL(FIL.FILA,0) = 0 AND 
			  (	(RED.nota_final = COR7.nota_final AND 
			     RED.nota_competencia1 = COR7.nota_competencia1 AND
			     RED.nota_competencia2 = COR7.nota_competencia2 AND
			     RED.nota_competencia3 = COR7.nota_competencia3 AND
			     RED.nota_competencia4 = COR7.nota_competencia4 AND
			     RED.nota_competencia5 = COR7.nota_competencia5  )
			  )
END 

IF(@STATUS = 0)
	BEGIN
	PRINT @STATUS
		UPDATE correcoes_redacao SET id_status = 3, data_termino = NULL WHERE ID = @REDACAO_ID AND id_projeto = @ID_PROJETO
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_correcoes_corretor_indicadores]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    PROCEDURE [dbo].[sp_correcoes_corretor_indicadores] 
    @DATA_CARGA date,
    @ID_PROJETO INT AS

    DECLARE @DATA_INICIO DATE
    SET @DATA_INICIO = (select cast(data_inicio as date) from projeto_projeto WITH (NOLOCK) where id = @id_projeto)

     INSERT correcoes_corretor_indicadores 
            (USUARIO_ID, NOME, ID_HIERARQUIA, ID_USUARIO_RESPONSAVEL, PROJETO_ID, INDICE, TEMPO_CORRECAO,
             OUROS_CORRIGIDAS, MODAS_CORRIGIDAS, DISCREPANCIAS_OURO, APROVEITAMENTOS_COM_DISC, APROVEITAMENTOS_SEM_DISC,
             TOTAL_CORRECOES, DESEMPENHO_OURO, DESEMPENHO_MODA, DSP, TEMPO_MEDIO_CORRECAO, TAXA_DISCREPANCIA_OURO, TAXA_APROVEITAMENTO,
             TAXA_APROVEITAMENTO_COLETIVO, FLG_DADO_ATUAL, DATA_CALCULO)


select distinct usuario_id, nome =ISNULL(nome,''), id_hierarquia, id_usuario_responsavel, projeto_id, indice,
       TEMPO_CORRECAO               = sum(TEMPO_CORRECAO),
       OUROS_CORRIGIDAS             = sum(OUROS_CORRIGIDAS), 
       MODAS_CORRIGIDAS             = sum(MODAS_CORRIGIDAS), 
       DISCREPANCIAS_OURO           = sum(DISCREPANCIAS_OURO),
       APROVEITAMENTOS_COM_DISC     = sum(APROVEITAMENTOS_COM_DISC),
       APROVEITAMENTOS_SEM_DISC     = sum(APROVEITAMENTOS_SEM_DISC),
       TOTAL_CORRECOES              = sum(TOTAL_CORRECOES),   
       DESEMPENHO_OURO              = max(DESEMPENHO_OURO),  
       DESEMPENHO_MODA              = max(DESEMPENHO_MODA), 
       DSP                          = 0.0,
       TEMPO_MEDIO_CORRECAO         = 0.0,
       TAXA_DISCREPANCIA_OURO       = 0.0,
       TAXA_APROVEITAMENTO          = 0.0,
       TAXA_APROVEITAMENTO_COLETIVO = 0.0,
       FLG_DADO_ATUAL               = 0,
       DATA_CALCULO =  @DATA_CARGA 
  from (
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                                  from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_a and 
                                                                                                                           corx.id_projeto = anax.id_projeto)
                                  where corx.id_corretor = vw.usuario_id                  and 
                                        corx.id_status   = 3                              and 
                                        @DATA_CARGA      = cast(corx.data_termino as date)),0), 
       OUROS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 5 then 1 else 0 end),
       MODAS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 6 then 1 else 0 end),
       DISCREPANCIAS_OURO       = sum(case when (ana.id_tipo_correcao_a    = 5 and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_COM_DISC = sum(case when (ana.id_tipo_correcao_B IN(3,4)and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
       DESEMPENHO_OURO          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 5 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)), 
       DESEMPENHO_MODA          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 6 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)) 

  from  vw_usuario_hierarquia vw WITH (NOLOCK) left join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_A and 
                                                                vw.projeto_id = ana.id_projeto         and 
                                                                cast(ana.data_termino_A as date) = @DATA_CARGA) 
        where VW.PROJETO_ID = @ID_PROJETO  --AND VW.USUARIO_ID = 5312
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice,ana.id_corretor_A


union all 
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                          from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_b and 
                                                                                                                   corx.id_projeto = anax.id_projeto)
                      where corx.id_corretor                = vw.usuario_id and 
                            corx.id_status                  = 3             and 
                            cast(corx.data_termino as date) = @DATA_CARGA) ,0), 
       OUROS_CORRIGIDAS         = 0,
       MODAS_CORRIGIDAS         = 0,
       DISCREPANCIAS_OURO       = 0,
       APROVEITAMENTOS_COM_DISC = 0,
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_b = 2 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
       DESEMPENHO_OURO          = 0.0, 
       DESEMPENHO_MODA          = 0.0
  from vw_usuario_hierarquia vw WITH (NOLOCK) join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_b      and 
                                                                                           vw.projeto_id = ana.id_projeto         and 
                                                                                           cast(ana.data_termino_b as date) = @DATA_CARGA) 
       where VW.PROJETO_ID = @ID_PROJETO 
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice) as tab
group by usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice
--**********************************************************************************************************************

UPDATE CCI SET 
       CCI.DSP =  CASE WHEN ouros_corrigidas = 0 AND modas_corrigidas = 0 THEN ISNULL((SELECT ci.DSP FROM correcoes_corretor_indicadores CI
                                                                                 WHERE CI.usuario_id = CCI.usuario_id
                                                                                   AND CI.projeto_id = CCI.projeto_id
                                                                                   AND DATA_CALCULO =
                                                                    /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                    FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                    WHERE CCIXX.usuario_id = CI.USUARIO_ID AND 
                                                                                                        CCIXX.projeto_id = CI.PROJETO_ID AND 
                                                                                                        CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                        CCIXX.DSP IS NOT NULL  AND 
                                                                                                        CCIXX.DATA_CALCULO < @DATA_CARGA)), 0)
                     ELSE ISNULL(CAST(ROUND((CASE WHEN @DATA_CARGA < DATEADD(DAY, 3, @DATA_INICIO) THEN CCI.DESEMPENHO_OURO
                                         WHEN (CCI.OUROS_CORRIGIDAS = 0 OR CCI.MODAS_CORRIGIDAS = 0 ) THEN (CASE WHEN CCI.OUROS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_OURO
                                                                                                                 WHEN CCI.MODAS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_MODA 
                                                                                                                 ELSE NULL
                                                                                                            END) *  0.7 + 
                                                                                                        (SELECT ISNULL(CCIX.DSP,0) * 0.3 
                                                                                                           FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
                                                                                                          WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                CCIX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                 CCIX.FLG_DADO_ATUAL = 1 AND
                                                                                                                CCIX.DATA_CALCULO =
                                                                                                                /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                                                               FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                                                             WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                                                   CCIXX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                                                    CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                                                                    CCIXX.DSP IS NOT NULL  AND 
                                                                                                                                                    CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/)
                                                                         ELSE 
                                                                             (isnull(CCI.DESEMPENHO_OURO,0) * 0.7 + isnull(CCI.DESEMPENHO_MODA,0) * 0.3) * 0.7 + 
                                                                             isnull((SELECT ISNULL(CCIX.DSP,0) * 0.3 
                                                                                FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
                                                                               WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
                                                                                     CCIX.projeto_id = CCI.PROJETO_ID AND 
                                                                                     CCIX.FLG_DADO_ATUAL = 1 AND
                                                                                    CCIX.DATA_CALCULO =
                                                                                    /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                                   FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                                  WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                        CCIXX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                        CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                                        CCIXX.DSP IS NOT NULL  AND 
                                                                                                                        CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/),0)                                                       
                                    END),2) AS FLOAT), 0)
                    END,                                                                          
  CCI.TEMPO_MEDIO_CORRECAO = CAST(ROUND(CASE WHEN total_correcoes >0  THEN CCI.TEMPO_CORRECAO / (total_correcoes * 1.0) 
                                                                      ELSE 0.00 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO  = CAST(ROUND(CASE WHEN total_correcoes > 0 THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / (total_correcoes * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO_COLETIVO   = CAST(ROUND(CASE WHEN (SELECT SUM(ccix.APROVEITAMENTOS_COM_DISC + ccix.APROVEITAMENTOS_SEM_DISC)
                                                               FROM correcoes_corretor_indicadores ccix
                                                              WHERE ccix.indice = cci.indice AND 
                                                                    ccix.DATA_CALCULO = cci.DATA_CALCULO) > 0 
                                                                      THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / ((SELECT SUM(isnull(ccix.APROVEITAMENTOS_COM_DISC,0) + isnull(ccix.APROVEITAMENTOS_SEM_DISC,0))
                                                                                                                                       FROM correcoes_corretor_indicadores ccix WITH (NOLOCK)
                                                                                                                                      WHERE ccix.indice = cci.indice AND 
                                                                                                                                            ccix.DATA_CALCULO = cci.DATA_CALCULO)      * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_DISCREPANCIA_OURO = CAST(ROUND(CASE WHEN OUROS_CORRIGIDAS > 0 THEN DISCREPANCIAS_OURO / (OUROS_CORRIGIDAS * 1.0) * 100
                                                                         ELSE 0.0 END, 2) AS numeric(10, 2))
FROM correcoes_corretor_indicadores cci
WHERE DATA_CALCULO = @DATA_CARGA AND 
      FLG_DADO_ATUAL = 0 AND 
      CCI.projeto_id = @ID_PROJETO

-- ************************************

--**********************************************************************************************************************

DELETE FROM correcoes_corretor_indicadores
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 1 AND 
       projeto_id = @ID_PROJETO

UPDATE correcoes_corretor_indicadores SET FLG_DADO_ATUAL = 1
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 0 AND 
       projeto_id = @ID_PROJETO


--Atualiza no corretor o valor mais recente de alguns indicadores
UPDATE cor
   SET cor.dsp = case when cci.desempenho_moda is null and cci.desempenho_ouro is null and cci.dsp = 0 then null else cci.dsp end,
       cor.tempo_medio_correcao = cci.tempo_medio_correcao
  FROM correcoes_corretor AS cor
       INNER JOIN correcoes_corretor_indicadores cci ON cci.usuario_id = cor.id
 WHERE cci.id = (SELECT max(cci2.id) FROM correcoes_corretor_indicadores cci2 WHERE cci2.usuario_id = cci.usuario_id)

GO
/****** Object:  StoredProcedure [dbo].[sp_correcoes_corretor_indicadores_new]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_correcoes_corretor_indicadores_new] 
    @DATA_CARGA date,
    @ID_PROJETO INT AS

    DECLARE @DATA_INICIO DATE
    SET @DATA_INICIO = (select cast(data_inicio as date) from projeto_projeto WITH (NOLOCK) where id = @id_projeto)

     INSERT correcoes_corretor_indicadores 
            (USUARIO_ID, NOME, ID_HIERARQUIA, ID_USUARIO_RESPONSAVEL, PROJETO_ID, INDICE, TEMPO_CORRECAO,
             OUROS_CORRIGIDAS, MODAS_CORRIGIDAS, DISCREPANCIAS_OURO, APROVEITAMENTOS_COM_DISC, APROVEITAMENTOS_SEM_DISC,
             TOTAL_CORRECOES, DESEMPENHO_OURO, DESEMPENHO_MODA, DSP, TEMPO_MEDIO_CORRECAO, TAXA_DISCREPANCIA_OURO, TAXA_APROVEITAMENTO,
             TAXA_APROVEITAMENTO_COLETIVO, FLG_DADO_ATUAL, DATA_CALCULO)

    --declare @DATA_CARGA date
    --declare @ID_PROJETO INT 
    --set @DATA_CARGA = '2018-11-09'
    --set @ID_PROJETO = 4

select distinct usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice,
       TEMPO_CORRECAO               = sum(TEMPO_CORRECAO),
       OUROS_CORRIGIDAS             = sum(OUROS_CORRIGIDAS), 
       MODAS_CORRIGIDAS             = sum(MODAS_CORRIGIDAS), 
       DISCREPANCIAS_OURO           = sum(DISCREPANCIAS_OURO),
       APROVEITAMENTOS_COM_DISC     = sum(APROVEITAMENTOS_COM_DISC),
       APROVEITAMENTOS_SEM_DISC     = sum(APROVEITAMENTOS_SEM_DISC),
       TOTAL_CORRECOES              = sum(TOTAL_CORRECOES),   
       DESEMPENHO_OURO              = max(DESEMPENHO_OURO),  
       DESEMPENHO_MODA              = max(DESEMPENHO_MODA), 
       DSP                          = 0.0,
       TEMPO_MEDIO_CORRECAO         = 0.0,
       TAXA_DISCREPANCIA_OURO       = 0.0,
       TAXA_APROVEITAMENTO          = 0.0,
       TAXA_APROVEITAMENTO_COLETIVO = 0.0,
       FLG_DADO_ATUAL               = 0,
       DATA_CALCULO =  @DATA_CARGA 
  from (
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                                  from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_a and 
                                                                                                                           corx.id_projeto = anax.id_projeto)
                                  where corx.id_corretor = vw.usuario_id                  and 
                                        corx.id_status   = 3                              and 
                                        @DATA_CARGA      = cast(corx.data_termino as date)),0), 
       OUROS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 5 then 1 else 0 end),
       MODAS_CORRIGIDAS         = sum(case when ANA.id_tipo_correcao_a = 6 then 1 else 0 end),
       DISCREPANCIAS_OURO       = sum(case when (ana.id_tipo_correcao_a    = 5 and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_COM_DISC = sum(case when (ana.id_tipo_correcao_B IN(3,4)and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
       DESEMPENHO_OURO          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 5 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)), 
       DESEMPENHO_MODA          = (select avg(anax.nota_desempenho) from correcoes_analise anax WITH (NOLOCK)
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 6 and 
                                          @DATA_CARGA = cast(anax.data_termino_A as date)) 

  from  vw_usuario_hierarquia vw WITH (NOLOCK) left join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_A and 
                                                                vw.projeto_id = ana.id_projeto         and 
                                                                cast(ana.data_termino_A as date) = @DATA_CARGA) 
        where VW.PROJETO_ID = 4  --AND VW.USUARIO_ID = 5312
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice,ana.id_corretor_A


union all 
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                          from correcoes_correcao corx WITH (NOLOCK) join correcoes_analise anax WITH (NOLOCK) on (corx.id = anax.id_correcao_b and 
                                                                                                                   corx.id_projeto = anax.id_projeto)
                      where corx.id_corretor                = vw.usuario_id and 
                            corx.id_status                  = 3             and 
                            cast(corx.data_termino as date) = @DATA_CARGA) ,0), 
       OUROS_CORRIGIDAS         = 0,
       MODAS_CORRIGIDAS         = 0,
       DISCREPANCIAS_OURO       = 0,
       APROVEITAMENTOS_COM_DISC = 0,
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_b = 2 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
       DESEMPENHO_OURO          = 0.0, 
       DESEMPENHO_MODA          = 0.0
  from vw_usuario_hierarquia vw WITH (NOLOCK) join correcoes_analise ana WITH (NOLOCK) on (vw.usuario_id = ana.id_corretor_b      and 
                                                                                           vw.projeto_id = ana.id_projeto         and 
                                                                                           cast(ana.data_termino_b as date) = @DATA_CARGA) 
       where VW.PROJETO_ID = @ID_PROJETO --AND VW.USUARIO_ID = 5312
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice) as tab
--where usuario_id = 1278
group by usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice
--**********************************************************************************************************************
UPDATE CCI SET 
       CCI.DSP = CAST(ROUND((CASE WHEN @DATA_CARGA < DATEADD(DAY, 3, @DATA_INICIO) THEN CCI.DESEMPENHO_OURO
                                         WHEN (CCI.OUROS_CORRIGIDAS = 0 OR CCI.MODAS_CORRIGIDAS = 0 ) THEN (CASE WHEN CCI.OUROS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_OURO
                                                                                                                 WHEN CCI.MODAS_CORRIGIDAS <> 0  THEN CCI.DESEMPENHO_MODA 
                                                                                                                 ELSE NULL
                                                                                                            END) *  0.7 + 
                                                                                                        (SELECT ISNULL(CCIX.DSP,0) * 0.3 
                                                                                                           FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
                                                                                                          WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                CCIX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                 CCIX.FLG_DADO_ATUAL = 1 AND
                                                                                                                CCIX.DATA_CALCULO =
                                                                                                                /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                                                               FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                                                             WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                                                   CCIXX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                                                    CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                                                                    CCIXX.DSP IS NOT NULL  AND 
                                                                                                                                                    CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/)
                                                                         ELSE 
                                                                             (isnull(CCI.DESEMPENHO_OURO,0) * 0.7 + isnull(CCI.DESEMPENHO_MODA,0) * 0.3) * 0.7 + 
                                                                             isnull((SELECT ISNULL(CCIX.DSP,0) * 0.3 
                                                                                FROM correcoes_corretor_indicadores CCIX WITH (NOLOCK) 
                                                                               WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
                                                                                     CCIX.projeto_id = CCI.PROJETO_ID AND 
                                                                                     CCIX.FLG_DADO_ATUAL = 1 AND
                                                                                    CCIX.DATA_CALCULO =
                                                                                    /*DATA DO ANTERIOR VALIDO*/ (SELECT MAX(DATA_CALCULO) 
                                                                                                                   FROM correcoes_corretor_indicadores CCIXX WITH (NOLOCK) 
                                                                                                                  WHERE CCIXX.usuario_id = CCI.USUARIO_ID AND 
                                                                                                                        CCIXX.projeto_id = CCI.PROJETO_ID AND 
                                                                                                                        CCIXX.FLG_DADO_ATUAL = 1          AND 
                                                                                                                        CCIXX.DSP IS NOT NULL  AND 
                                                                                                                        CCIXX.DATA_CALCULO < @DATA_CARGA)    /**/),0)                                                       
                                    END),2) AS FLOAT),                                                                          
  CCI.TEMPO_MEDIO_CORRECAO = CAST(ROUND(CASE WHEN total_correcoes >0  THEN CCI.TEMPO_CORRECAO / (total_correcoes * 1.0) 
                                                                      ELSE 0.00 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO  = CAST(ROUND(CASE WHEN total_correcoes > 0 THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / (total_correcoes * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO_COLETIVO   = CAST(ROUND(CASE WHEN (SELECT SUM(ccix.APROVEITAMENTOS_COM_DISC + ccix.APROVEITAMENTOS_SEM_DISC)
                                                               FROM correcoes_corretor_indicadores ccix
                                                              WHERE ccix.indice = cci.indice AND 
                                                                    ccix.DATA_CALCULO = cci.DATA_CALCULO) > 0 
                                                                      THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / ((SELECT SUM(isnull(ccix.APROVEITAMENTOS_COM_DISC,0) + isnull(ccix.APROVEITAMENTOS_SEM_DISC,0))
                                                                                                                                       FROM correcoes_corretor_indicadores ccix WITH (NOLOCK)
                                                                                                                                      WHERE ccix.indice = cci.indice AND 
                                                                                                                                            ccix.DATA_CALCULO = cci.DATA_CALCULO)      * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_DISCREPANCIA_OURO = CAST(ROUND(CASE WHEN OUROS_CORRIGIDAS > 0 THEN DISCREPANCIAS_OURO / (OUROS_CORRIGIDAS * 1.0) * 100
                                                                         ELSE 0.0 END, 2) AS numeric(10, 2))
FROM correcoes_corretor_indicadores cci
WHERE DATA_CALCULO = @DATA_CARGA AND 
      FLG_DADO_ATUAL = 0 AND 
      CCI.projeto_id = @ID_PROJETO

-- ************************************

--**********************************************************************************************************************

DELETE FROM correcoes_corretor_indicadores
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 1 AND 
       projeto_id = @ID_PROJETO

UPDATE correcoes_corretor_indicadores SET FLG_DADO_ATUAL = 1
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 0 AND 
       projeto_id = @ID_PROJETO

GO
/****** Object:  StoredProcedure [dbo].[sp_correcoes_corretor_indicadores_old]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_correcoes_corretor_indicadores_old] 
    @DATA_CARGA date,
    @ID_PROJETO INT AS

    DECLARE @DATA_INICIO DATE
    SET @DATA_INICIO = (select cast(data_inicio as date) from projeto_projeto where id = @id_projeto)

     INSERT correcoes_corretor_indicadores 
            (USUARIO_ID, NOME, ID_HIERARQUIA, ID_USUARIO_RESPONSAVEL, PROJETO_ID, INDICE, TEMPO_CORRECAO,
             OUROS_CORRIGIDAS, DISCREPANCIAS_OURO, APROVEITAMENTOS_COM_DISC, APROVEITAMENTOS_SEM_DISC,
             TOTAL_CORRECOES, DESEMPENHO_OURO, DESEMPENHO_MODA, DSP, TEMPO_MEDIO_CORRECAO, TAXA_DISCREPANCIA_OURO, TAXA_APROVEITAMENTO,
             TAXA_APROVEITAMENTO_COLETIVO, FLG_DADO_ATUAL, DATA_CALCULO)

    --declare @DATA_CARGA date
    --declare @ID_PROJETO INT 
    --set @DATA_CARGA = '2018-11-09'
    --set @ID_PROJETO = 4

select distinct usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice,
       TEMPO_CORRECAO               = sum(TEMPO_CORRECAO),
       OUROS_CORRIGIDAS             = sum(OUROS_CORRIGIDAS), 
       DISCREPANCIAS_OURO           = sum(DISCREPANCIAS_OURO),
       APROVEITAMENTOS_COM_DISC     = sum(APROVEITAMENTOS_COM_DISC),
       APROVEITAMENTOS_SEM_DISC     = sum(APROVEITAMENTOS_SEM_DISC),
       TOTAL_CORRECOES              = sum(TOTAL_CORRECOES),   
       DESEMPENHO_OURO              = max(DESEMPENHO_OURO),  
       DESEMPENHO_MODA              = max(DESEMPENHO_MODA), 
       DSP                          = 0.0,
       TEMPO_MEDIO_CORRECAO         = 0.0,
       TAXA_DISCREPANCIA_OURO       = 0.0,
       TAXA_APROVEITAMENTO          = 0.0,
       TAXA_APROVEITAMENTO_COLETIVO = 0.0,
       FLG_DADO_ATUAL               = 0,
       DATA_CALCULO =  @DATA_CARGA 
  from (
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                                  from correcoes_correcao corx  join correcoes_analise anax on (corx.id = anax.id_correcao_a and 
                                                                                                corx.id_projeto = anax.id_projeto)
                                  where corx.id_corretor = vw.usuario_id                  and 
                                        corx.id_status   = 3                              and 
                                        @DATA_CARGA      = cast(corx.data_termino as date)),0), 
       OUROS_CORRIGIDAS         = sum(case when id_tipo_correcao_a = 5 then 1 else 0 end),
       DISCREPANCIAS_OURO       = sum(case when (ana.id_tipo_correcao_a    = 5 and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_COM_DISC = sum(case when (ana.id_tipo_correcao_B IN(3,4)and ana.conclusao_analise  > 2) then 1 else 0 end),
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A    = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
       DESEMPENHO_OURO          = (select avg(anax.nota_desempenho) from correcoes_analise anax
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 5 and 
                                          @data_carga = cast(anax.data_termino_A as date)), 
       DESEMPENHO_MODA          = (select avg(anax.nota_desempenho) from correcoes_analise anax
                                    where anax.id_corretor_A = ana.id_corretor_A and anax.id_tipo_correcao_a = 6 and 
                                          @data_carga = cast(anax.data_termino_A as date)) 
      

  from  vw_usuario_hierarquia vw left join correcoes_analise ana on (vw.usuario_id = ana.id_corretor_A and 
                                                                vw.projeto_id = ana.id_projeto         and 
                                                                cast(ana.data_termino_A as date) = @DATA_CARGA) 
      where  VW.PROJETO_ID = @ID_PROJETO 
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice,ana.id_corretor_A


union all 
select distinct vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice, 
       TEMPO_CORRECAO = isnull((select sum(isnull(tempo_em_correcao,0)) 
                          from correcoes_correcao corx  join correcoes_analise anax on (corx.id = anax.id_correcao_b and 
                                                                                        corx.id_projeto = anax.id_projeto)
                      where corx.id_corretor                = vw.usuario_id and 
                            corx.id_status                  = 3             and 
                            cast(corx.data_termino as date) = @DATA_CARGA) ,0), 
       OUROS_CORRIGIDAS         = 0,
       DISCREPANCIAS_OURO       = 0,
       APROVEITAMENTOS_COM_DISC = 0,
       APROVEITAMENTOS_SEM_DISC = sum(case when (ana.id_tipo_correcao_b = 2 AND ana.conclusao_analise  < 3) then 1 else 0 end),
       TOTAL_CORRECOES          = sum(case when (ana.id_tipo_correcao_A = 1 AND ana.id_tipo_correcao_B = 2) then 1 else 0 end), 
       DESEMPENHO_OURO          = 0.0, 
       DESEMPENHO_MODA          = 0.0
  from vw_usuario_hierarquia vw join correcoes_analise ana on (vw.usuario_id = ana.id_corretor_b      and 
                                                                    vw.projeto_id = ana.id_projeto         and 
                                                                    cast(ana.data_termino_b as date) = @DATA_CARGA) 
       where VW.PROJETO_ID = @ID_PROJETO   
group by vw.usuario_id, vw.nome, vw.id_hierarquia, vw.id_usuario_responsavel, vw.projeto_id, vw.indice) as tab
--where usuario_id = 1278
group by usuario_id, nome, id_hierarquia, id_usuario_responsavel, projeto_id, indice
--**********************************************************************************************************************
UPDATE CCI SET 
       CCI.DSP = isnull(CAST(ROUND((CASE WHEN @DATA_CARGA < DATEADD(DAY, 3, @DATA_INICIO) THEN CCI.DESEMPENHO_OURO 
                                                                         ELSE 
                                                                             (isnull(CCI.DESEMPENHO_OURO,0) * 0.7 + isnull(CCI.DESEMPENHO_MODA,0) * 0.3) * 0.7 + 
                                                                             isnull((SELECT ISNULL(CCIX.DSP,0) * 0.3 
                                                                                FROM correcoes_corretor_indicadores CCIX 
                                                                               WHERE CCIX.usuario_id = CCI.USUARIO_ID AND 
                                                                                     CCIX.projeto_id = CCI.PROJETO_ID AND 
                                                                                     CCIX.FLG_DADO_ATUAL = 1 AND
                                                                                    CCIX.DATA_CALCULO = DATEADD(DAY, -1, @DATA_CARGA)),0) END),2) AS FLOAT),0.0),                                                                           
  CCI.TEMPO_MEDIO_CORRECAO = CAST(ROUND(CASE WHEN total_correcoes >0  THEN CCI.TEMPO_CORRECAO / (total_correcoes * 1.0) 
                                                                      ELSE 0.00 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO  = CAST(ROUND(CASE WHEN total_correcoes > 0 THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / (total_correcoes * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_APROVEITAMENTO_COLETIVO   = CAST(ROUND(CASE WHEN (SELECT SUM(ccix.APROVEITAMENTOS_COM_DISC + ccix.APROVEITAMENTOS_SEM_DISC)
                                                               FROM correcoes_corretor_indicadores ccix
                                                              WHERE ccix.indice = cci.indice AND 
                                                                    ccix.DATA_CALCULO = cci.DATA_CALCULO) > 0 
                                                                      THEN (APROVEITAMENTOS_COM_DISC + APROVEITAMENTOS_SEM_DISC) / ((SELECT SUM(isnull(ccix.APROVEITAMENTOS_COM_DISC,0) + isnull(ccix.APROVEITAMENTOS_SEM_DISC,0))
                                                                                                                                       FROM correcoes_corretor_indicadores ccix
                                                                                                                                      WHERE ccix.indice = cci.indice AND 
                                                                                                                                            ccix.DATA_CALCULO = cci.DATA_CALCULO)      * 1.0) * 100
                                                                      ELSE 0.0 END, 2) AS numeric(10, 2)),
  CCI.TAXA_DISCREPANCIA_OURO = CAST(ROUND(CASE WHEN OUROS_CORRIGIDAS > 0 THEN DISCREPANCIAS_OURO / (OUROS_CORRIGIDAS * 1.0) * 100
                                                                         ELSE 0.0 END, 2) AS numeric(10, 2))
FROM correcoes_corretor_indicadores cci
WHERE DATA_CALCULO = @DATA_CARGA AND 
      FLG_DADO_ATUAL = 0 AND 
      CCI.projeto_id = @ID_PROJETO

-- ************************************

--**********************************************************************************************************************

DELETE FROM correcoes_corretor_indicadores
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 1 AND 
       projeto_id = @ID_PROJETO

UPDATE correcoes_corretor_indicadores SET FLG_DADO_ATUAL = 1
 WHERE DATA_CALCULO = @DATA_CARGA AND 
       FLG_DADO_ATUAL = 0 AND 
       projeto_id = @ID_PROJETO

GO
/****** Object:  StoredProcedure [dbo].[SP_CORRIGE_FILAPESSOAL]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/******************
OS COORDENADORES POLO E SUPERVISORES APESENTAVAM REGISTROS NA FILAPESSOAL QUE NAO POSSUIAM REFERENCIA NA CORRECOES_CORRECAO

SOLUCAO: APGAR OS REGISTROS DA FILAPESSOAL (FOI FEITO BACKUP -> CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115)
SELECT IDENTIFICA OS CASOS
*******************/
-- SELECT * FROM CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115
CREATE   procedure [dbo].[SP_CORRIGE_FILAPESSOAL] AS
BEGIN TRY
    BEGIN TRAN FILA
        insert into CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115
        SELECT * FROM correcoes_filapessoal PES 
        WHERE NOT EXISTS (SELECT TOP 1 1 FROM CORRECOES_CORRECAO COR WHERE COR.co_barra_redacao = PES.co_barra_redacao AND 
                                                                           COR.id_corretor      = PES.id_corretor)
                                                                           ORDER BY id_corretor
        
        delete FROM CORRECOES_FILAPESSOAL WHERE ID IN (
        SELECT PES.ID 
        FROM CORRECOES_FILAPESSOAL PES JOIN CORRECOES_FILAPESSOAL_SUPERVISOR_COORDENADOR_POLO_20181204__1115 BKP ON (PES.id = BKP.ID))

    COMMIT TRAN FILA
END TRY
BEGIN CATCH
    ROLLBACK TRAN FILA 
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[sp_distribuir_ordem]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_distribuir_ordem] 
    @id_avaliador int, 
    @id_projeto   int,
    @id_redacaotipo int
as

DECLARE @QUANTIDADE           INT
DECLARE @CONT                 INT
declare @aux                  int
declare @resultado            int 
declare @id                   int
declare @nova_faixa           int
declare @nova_quantidade      int
declare @faixa_ouro           int
declare @qtd_ouro             int
declare @aux_ouro             int
declare @qtd_correcao         int
DECLARE @QUANTIDADE_CORRIGIDA INT 
DECLARE @POSICAO_INICIAL      INT 

/*
select @qtd_correcao = count(cor.id)
  from correcoes_correcao cor join correcoes_redacao red on (cor.co_barra_redacao = red.co_barra_redacao and
                                                             cor.id_projeto       = red.id_projeto)
where cor.id_corretor = 469 and
      cor.id_projeto  = 4 and 
      cor.id_correcao_situacao = 3 and
      red.id_redacaoouro is null 
*/
select @faixa_ouro = ouro_frequencia, @qtd_ouro= ouro_quantidade 
 from projeto_projeto where id = @id_projeto
set @aux = @faixa_ouro/ @qtd_ouro

SET @CONT   = 0
SET @QUANTIDADE = (SELECT COUNT(*) FROM CORRECOES_REDACAOOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
                                                                                JOIN CORRECOES_FILAOURO FIL WITH (NOLOCK)  ON (FIL.co_barra_redacao = RED.co_barra_redacao)
                    WHERE ID_REDACAOTIPO =  @ID_REDACAOTIPO AND 
                          FIL.posicao IS NULL AND 
                          FIL.id_corretor = @id_avaliador)

set @QUANTIDADE_CORRIGIDA = (SELECT COUNT(ID) FROM CORRECOES_CORRECAO COR  WITH (NOLOCK)
                             WHERE COR.id_corretor = @ID_AVALIADOR AND 
                                   COR.id_projeto  = @ID_PROJETO   AND
                                   COR.id_status   = 3             AND
                                   COR.id_tipo_correcao < 5)


    SELECT @POSICAO_INICIAL = MAX(POSICAO) FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED  WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
                                                       JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro)
    WHERE OUR.id_corretor = @id_avaliador AND REO.id_redacaotipo = @id_redacaotipo

    IF (@POSICAO_INICIAL IS NOT NULL)
            BEGIN
                SET @QUANTIDADE_CORRIGIDA = @POSICAO_INICIAL
            END

    /*

    UPDATE  OURO SET OURO.POSICAO = NULL 
    FROM CORRECOES_FILAOURO OURO
    WHERE id_corretor = @id_avaliador and
          id_projeto  = @id_projeto   and             
          posicao > @QUANTIDADE_CORRIGIDA AND 
          EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
                                                                           JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro) 
                    WHERE OURO.CO_BARRA_REDACAO = OUR.CO_BARRA_REDACAO AND 
                          REO.id_redacaotipo = @id_redacaotipo)

*/


WHILE (@CONT < @QUANTIDADE)
    BEGIN
    
        
        set @resultado =  ((@QUANTIDADE_CORRIGIDA + @aux*@cont ) + (  @aux )*rand())
        if (@resultado = 0)
            begin
                set @resultado = 5
            end


        select top 1 @id = id from correcoes_filaouro OURO
        where id_corretor = @id_avaliador and
              id_projeto  = @id_projeto   and             
              posicao is null AND 
               EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.co_barra_redacao = RED.co_barra_redacao)
                                                                           JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro) 
                    WHERE OURO.CO_BARRA_REDACAO = OUR.CO_BARRA_REDACAO AND 
                          REO.id_redacaotipo = @id_redacaotipo)
        ORDER BY OURO.ID

        update correcoes_filaouro set posicao =  @resultado 
        where id = @id

        SET @CONT = @CONT + 1
    END

GO
/****** Object:  StoredProcedure [dbo].[sp_distribuir_ordem_DIARIO]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create       procedure [dbo].[sp_distribuir_ordem_DIARIO]
    @id_avaliador int,
    @id_projeto   int,
    @id_redacaotipo int
as

DECLARE @QUANTIDADE           INT
DECLARE @CONT                 INT
declare @aux                  int
declare @resultado            int
declare @id                   int
declare @nova_faixa           int
declare @nova_quantidade      int
declare @faixa_ouro           int
declare @qtd_ouro             int
declare @aux_ouro             int
declare @qtd_correcao         int
DECLARE @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR INT
DECLARE @POSICAO_INICIAL      INT
declare @alcance              int


--update projeto_projeto set ouro_quantidade = 2, ouro_frequencia = 30 where id = 4

select @faixa_ouro = ouro_frequencia, @qtd_ouro= ouro_quantidade
 from projeto_projeto where id = 4-- @id_projeto
set @aux = @faixa_ouro/ @qtd_ouro
print @aux 
SET @CONT   = 1

/* LIMPAR A POSICAO DE TODAS AS CORRECOES OURO OU MODA PARA NOVA REDISTRIBUICAO */
UPDATE  FIL SET FIL.POSICAO = NULL
    FROM CORRECOES_FILAOURO FIL WITH (NOLOCK) JOIN CORRECOES_REDACAO     RED WITH (NOLOCK) ON (FIL.REDACAO_ID = RED.ID)
                                              JOIN CORRECOES_REDACAOOURO OUR WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
    WHERE FIL.id_corretor = @id_avaliador and
          FIL.id_projeto  = @id_projeto   AND
          OUR.id_redacaotipo = @id_redacaotipo



SET @QUANTIDADE = (SELECT COUNT(*) FROM CORRECOES_REDACAOOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED  WITH (NOLOCK) ON (OUR.ID = RED.id_redacaoouro)
                                                                                JOIN CORRECOES_FILAOURO FIL WITH (NOLOCK)  ON (FIL.redacao_id = RED.id)
                    WHERE ID_REDACAOTIPO =  @ID_REDACAOTIPO AND
                          FIL.posicao IS NULL AND
                          FIL.id_corretor = @id_avaliador AND
                          FIL.id_projeto  = @id_projeto)

set @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR = (SELECT COUNT(ID) FROM CORRECOES_CORRECAO COR  WITH (NOLOCK)
                                             WHERE COR.id_corretor = @ID_AVALIADOR AND
                                                   COR.id_projeto  = @ID_PROJETO   AND
                                                   COR.id_status   = 3             AND
                                                   COR.id_tipo_correcao < 5       AND
                                          CAST(COR.DATA_TERMINO AS DATE)  <CAST(GETDATE() AS DATE))


WHILE (@CONT <= @QUANTIDADE)
    BEGIN


       -- set @resultado =  ((@QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + @aux*@cont ) + ((@aux )*rand()))
		set @resultado =  @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + (@aux * @cont) - (cast (RAND() * (@aux - 1) as int) + 1)  
		set @alcance   = (@QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + @aux*@cont )
        if (@resultado = 0)
            begin
                set @resultado = @QUANTIDADE_CORRIGIDA_DIA_ANTERIOR + 5
            end


        select top 1 @id = id from correcoes_filaouro OURO
        where id_corretor = @id_avaliador and
              id_projeto  = @id_projeto   and
              posicao is null AND
               EXISTS (SELECT TOP 1 1 FROM CORRECOES_FILAOURO OUR WITH (NOLOCK) JOIN CORRECOES_REDACAO RED    WITH (NOLOCK)ON (OUR.redacao_id = RED.id)
                                                                           JOIN CORRECOES_REDACAOOURO REO WITH (NOLOCK) ON (REO.ID = RED.id_redacaoouro)
                    WHERE OURO.redacao_id = OUR.redacao_id AND
                          REO.id_redacaotipo = @id_redacaotipo)
        ORDER BY OURO.ID

        update correcoes_filaouro set posicao =  @resultado, alcance = @alcance
        where id = @id

        SET @CONT = @CONT + 1
    END




GO
/****** Object:  StoredProcedure [dbo].[sp_executa_consistencia_fila]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                        [SP_EXECUTA_CONSISTENCIA_FILA]                                          *
*                                                                                                                *
*  PROCEDURE QUE BUSCA NAS FILAS 3, 4 E AUDITORIA AS REDACOES QUE AINDA NAO FORAM VALIDADAS E FAZ UMA VALIDACAO  *
* SE ESTAS DEVRIAM ESTA REALMENTE NESTA FILA                                                                     *
*                                                                                                                *
*                                         DEVERÁ SER CRIADO UM JOB                                               *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/
CREATE     procedure [dbo].[sp_executa_consistencia_fila] as 
DECLARE @REDACAO_ID INT, @ID_PROJETO INT, @FILA INT

declare abc cursor for 
		SELECT redacao_id,id_projeto,FILA = 3 FROM correcoes_fila3         WHERE consistido IS NULL  UNION
		SELECT redacao_id,id_projeto,FILA = 4 FROM correcoes_fila4         WHERE consistido IS NULL  UNION
		SELECT  redacao_id,id_projeto,FILA =7 FROM correcoes_filaAUDITORIA WHERE consistido IS NULL
	open abc 
		fetch next from abc into @REDACAO_ID, @ID_PROJETO, @FILA
		while @@FETCH_STATUS = 0
			BEGIN
				EXEC sp_consiStir_filas @REDACAO_ID, @ID_PROJETO, @FILA


			fetch next from abc into @REDACAO_ID, @ID_PROJETO, @FILA
			END
	close abc 
deallocate abc 
GO
/****** Object:  StoredProcedure [dbo].[sp_foreach_table_azure]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_foreach_table_azure]
    @command1 nvarchar(2000), @replacechar nchar(1) = N'?', @command2 nvarchar(2000) = null,
  @command3 nvarchar(2000) = null, @whereand nvarchar(2000) = null,
    @precommand nvarchar(2000) = null, @postcommand nvarchar(2000) = null
AS
    declare @mscat nvarchar(12)
    select @mscat = ltrim(str(convert(int, 0x0002)))
    if (@precommand is not null)
        exec(@precommand)
   exec(N'declare hCForEachTable cursor global for select ''['' + REPLACE(schema_name(syso.schema_id), N'']'', N'']]'') + '']'' + ''.'' + ''['' + REPLACE(object_name(o.id), N'']'', N'']]'') + '']'' from dbo.sysobjects o join sys.all_objects syso on o.id = syso.object_id '
         + N' where OBJECTPROPERTY(o.id, N''IsUserTable'') = 1 ' + N' and o.category & ' + @mscat + N' = 0 '
         + @whereand)
    declare @retval int
    select @retval = @@error
    if (@retval = 0)
        exec @retval = dbo.sp_foreach_worker @command1, @replacechar, @command2, @command3, 0
    if (@retval = 0 and @postcommand is not null)
        exec(@postcommand)
    return @retval

GO
/****** Object:  StoredProcedure [dbo].[sp_gera_lote_n59]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec vwf_correcoes_por_redacao getdate()

CREATE   PROCEDURE [dbo].[sp_gera_lote_n59] @data_tabelas date
as
begin

	declare @data_char varchar(8) = format(dbo.getlocaldate(), 'ddMMyyyy')

	exec('
	SELECT TOP 1 
		   REDACAO_ID               = RED.ID,
		   CO_PROJETO               = RED.id_projeto,
		   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
		   NOME_AVALIADOR_AV1       = PES1.NOME,
		   CPF_AVALIADOR_AV1        = PES1.cpf,  
		   COMP1_AV1                = COR1.COMPETENCIA1,
		   COMP2_AV1                = COR1.COMPETENCIA2,
		   COMP3_AV1                = COR1.COMPETENCIA3,
		   COMP4_AV1                = COR1.COMPETENCIA4,
		   COMP5_AV1                = COR1.COMPETENCIA5,
		   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
		   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV1       = (select sitx.sigla from correcoes_situacao sitx where sitx.id = COR1.id_correcao_situacao),
		   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV1          = COR1.data_inicio,
		   DATA_TERMINO_AV1         = COR1.data_termino,
		   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
		   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
		   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
		   NOME_AVALIADOR_AV2       = PES2.NOME,
		   CPF_AVALIADOR_AV2        = PES2.cpf,  
		   COMP1_AV2                = COR2.COMPETENCIA1,
		   COMP2_AV2                = COR2.COMPETENCIA2,
		   COMP3_AV2                = COR2.COMPETENCIA3,
		   COMP4_AV2                = COR2.COMPETENCIA4,
		   COMP5_AV2                = COR2.COMPETENCIA5,
		   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
		   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV2       = (select sitx.sigla from correcoes_situacao sitx where sitx.id = COR2.id_correcao_situacao),
		   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV2          = COR2.data_inicio,
		   DATA_TERMINO_AV2         = COR2.data_termino,
		   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
		   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,
	   
	   	
		   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
		   NOME_AVALIADOR_AV3       = PES3.NOME,
		   CPF_AVALIADOR_AV3        = PES3.cpf,  
		   COMP1_AV3                = COR3.COMPETENCIA1,
		   COMP2_AV3                = COR3.COMPETENCIA2,
		   COMP3_AV3                = COR3.COMPETENCIA3,
		   COMP4_AV3                = COR3.COMPETENCIA4,
		   COMP5_AV3                = COR3.COMPETENCIA5,
		   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
		   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
		   SIGLA_SITUACAO_AV3       = (select sitx.sigla from correcoes_situacao sitx where sitx.id = COR3.id_correcao_situacao),
		   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AV3          = COR3.data_inicio,
		   DATA_TERMINO_AV3         = COR3.data_termino,
		   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
		   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
		   ID_AVALIADOR_AVA4        = COR4.ID_CORRETOR,
		   NOME_AVALIADOR_AVA4      = PES4.NOME,
		   CPF_AVALIADOR_AVA4       = PES4.cpf,  
		   COMP1_AVA4               = COR4.COMPETENCIA1,
		   COMP2_AVA4               = COR4.COMPETENCIA2,
		   COMP3_AVA4               = COR4.COMPETENCIA3,
		   COMP4_AVA4               = COR4.COMPETENCIA4,
		   COMP5_AVA4               = COR4.COMPETENCIA5,
		   NOTA_COMP1_AVA4          = COR4.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVA4          = COR4.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVA4          = COR4.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVA4          = COR4.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVA4          = COR4.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVA4          = COR4.NOTA_FINAL,
		   ID_SITUACAO_AVA4         = COR4.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVA4      = (select sitx.sigla from correcoes_situacao sitx where sitx.id = COR4.id_correcao_situacao),
		   FERE_DH_AVA4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
		   DATA_INICIO_AVA4         = COR4.data_inicio,
		   DATA_TERMINO_AVA4        = COR4.data_termino,
		   DURACAO_AVA4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
		   LINK_IMAGEM_AV4          = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
		   ID_AVALIADOR_AVAA        = CORA.ID_CORRETOR,
		   NOME_AVALIADOR_AVAA      = PESA.NOME,
		   CPF_AVALIADOR_AVAA       = PESA.cpf,  
		   COMP1_AVAA               = CORA.COMPETENCIA1,
		   COMP2_AVAA               = CORA.COMPETENCIA2,
		   COMP3_AVAA               = CORA.COMPETENCIA3,
		   COMP4_AVAA               = CORA.COMPETENCIA4,
		   COMP5_AVAA               = CORA.COMPETENCIA5,
		   NOTA_COMP1_AVAA          = CORA.NOTA_COMPETENCIA1,
		   NOTA_COMP2_AVAA          = CORA.NOTA_COMPETENCIA2,
		   NOTA_COMP3_AVAA          = CORA.NOTA_COMPETENCIA3,
		   NOTA_COMP4_AVAA          = CORA.NOTA_COMPETENCIA4,
		   NOTA_COMP5_AVAA          = CORA.NOTA_COMPETENCIA5,
		   NOTA_FINAL_AVAA          = CORA.NOTA_FINAL,
		   ID_SITUACAO_AVAA         = CORA.id_correcao_situacao, 
		   SIGLA_SITUACAO_AVAA      = (select sitx.sigla from correcoes_situacao sitx where sitx.id = CORA.id_correcao_situacao),
		   DATA_INICIO_AVAA         = CORA.data_inicio,
		   DATA_TERMINO_AVAA        = CORA.data_termino,
		   DURACAO_AVAA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
		   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

		   RED.CO_BARRA_REDACAO, 
		   RED.CO_INSCRICAO,
		   RED.ID_CORRECAO_SITUACAO,
		   RED.NOTA_FINAL,
		   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
											 when CORA.id is not null and CORA.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
											 when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
											 else NULL end,
	   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
		   sno2.CO_PROJETO,               
		   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
		   sn91.ID_ITEM_ATENDIMENTO,
		   NOTA_COMP1 = case
						   when CORA.id is not null then CORA.nota_competencia1
						   when CORA.id is null and COR4.id is not null then COR4.nota_competencia1
						   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia1
						   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia1 + COR2.nota_competencia1) / 2
						end,
		   NOTA_COMP2 = case
						   when CORA.id is not null then CORA.nota_competencia2
						   when CORA.id is null and COR4.id is not null then COR4.nota_competencia2
						   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia2
						   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia2 + COR2.nota_competencia2) / 2
						end,
		   NOTA_COMP3 = case
						   when CORA.id is not null then CORA.nota_competencia3
						   when CORA.id is null and COR4.id is not null then COR4.nota_competencia3
						   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia3
						   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia3 + COR2.nota_competencia3) / 2
						end,
		   NOTA_COMP4 = case
						   when CORA.id is not null then CORA.nota_competencia4
						   when CORA.id is null and COR4.id is not null then COR4.nota_competencia4
						   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia4
						   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia4 + COR2.nota_competencia4) / 2
						end,
		   NOTA_COMP5 = case
						   when CORA.id is not null then CORA.nota_competencia5
						   when CORA.id is null and COR4.id is not null then COR4.nota_competencia5
						   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia5
						   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia5 + COR2.nota_competencia5) / 2
						end,
		   co_justificativa = null,
		   FERE_DH_AVAA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
	--select count(1)
	  FROM CORRECOES_REDACAO RED  LEFT JOIN INEP_N02        SNO2 ON (SNO2.CO_INSCRICAO     = RED.co_inscricao)  
		   INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
		   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (5, 8))
		   LEFT JOIN CORRECOES_CORRECAO COR1 ON (RED.co_barra_redacao  = COR1.co_barra_redacao AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
		   LEFT JOIN USUARIOS_PESSOA    PES1 ON (COR1.id_corretor      = PES1.usuario_id)
		   LEFT JOIN CORRECOES_CORRECAO COR2 ON (RED.co_barra_redacao  = COR2.co_barra_redacao AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
		   LEFT JOIN USUARIOS_PESSOA    PES2 ON (COR2.id_corretor      = PES2.usuario_id)
		   LEFT JOIN CORRECOES_CORRECAO COR3 ON (RED.co_barra_redacao  = COR3.co_barra_redacao AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
		   LEFT JOIN USUARIOS_PESSOA    PES3 ON (COR3.id_corretor      = PES3.usuario_id)
		   LEFT JOIN CORRECOES_CORRECAO COR4 ON (RED.co_barra_redacao  = COR4.co_barra_redacao AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
		   LEFT JOIN USUARIOS_PESSOA    PES4 ON (COR4.id_corretor      = PES4.usuario_id)
		   LEFT JOIN CORRECOES_CORRECAO CORA ON (RED.co_barra_redacao  = CORA.co_barra_redacao AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
		   LEFT JOIN USUARIOS_PESSOA    PESA ON (CORA.id_corretor      = PESA.usuario_id)
		   LEFT JOIN CORRECOES_ANALISE  ANA3 ON (ANA3.co_barra_redacao = RED.co_barra_redacao AND ANA3.id_tipo_correcao_B = 3 AND ANA3.aproveitamento = 1) 
	WHERE red.cancelado = 0 and red.nota_final is not null
	')
end
GO
/****** Object:  StoredProcedure [dbo].[SP_GERAR_REDACAO_OURO_MODA]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                  PROCEDURE PARA CRIAR REDACOES OURO OU MODA                                    *
*                                                                                                                *
*  PROCEDURE QUE RECEBE O TIPO DE REDACAO A SER GERADA (2-OURO OU 3-MODA) E COM BASE NAS REDACOES CADASTRADAS NA * 
* TABELA redacoes_redacaoreferencia SERA CRIADO UMA COPIA NA TABELA CORRECOES_REDACAOOURO, UMA COPIA NA          *
* CORRECOES_REDACAO COM O CODIGO DE BARRA ALTERADO (SENDO INICIADO COM 001 PARA OURO E 002 PARA MODA DEPOIS      *
* CRIADO UM REGISTRO PARA CADA UMA NA CORRECOES_FILAOURO E EM SEGUIDA CRIADO UMA ORDENACAO DE BUSCA COM BASE NAS *
* INFORMACOESDA PROJETO_PROJETO                                                                                  *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:27/11/2018 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:27/11/2018 *
******************************************************************************************************************/


CREATE   PROCEDURE [dbo].[SP_GERAR_REDACAO_OURO_MODA] @TIPO_REDACAO INT AS 

DECLARE @ID_CORRETOR  INT 
DECLARE @ID_PROJETO   INT 

--***** INSERIR NA TABELA CORRRECOES_REDACAOOURO (as modas selecionadas na tabela redacoes_redacaoreferencia)
insert into correcoes_redacaoouro (link_imagem_recortada, link_imagem_original, co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaotipo, data_criacao, id_origem)
select red.link_imagem_recortada, red.link_imagem_original, red.co_barra_redacao, red.co_inscricao, red.co_formulario, red.id_prova, red.id_projeto, id_redacaotipo = ref.id_redacao_tipo, 
       data_criacao = getdate(), id_origem = 1 
  from correcoes_redacao red join redacoes_redacaoreferencia  ref on  (ref.id_redacao       = red.id)  
                        left join correcoes_redacaoouro       our on  (red.co_barra_redacao = our.co_barra_redacao)
                        left join correcoes_redacaoouro       ourx on (red.id_redacaoouro   = ourx.id)
 where ref.id_redacao_tipo = @tipo_redacao and 
       our.co_barra_redacao is null and 
       ourx.co_barra_redacao is null 

-- **** inserir na tabela redacao as redacoes ouro para o candidato 
     select link_imagem_recortada, link_imagem_original,nota_final, id_correcao_situacao, 
            co_barra_redacao = CASE WHEN @tipo_redacao = 2 THEN '001'
                                    WHEN @tipo_redacao = 3 THEN '002'ELSE '***' END + right('000000' +convert(varchar(6),our.id),6) +
                                                                                      right('000000' +convert(varchar(6),cor.id),6),
            co_inscricao     = CASE WHEN @tipo_redacao = 2 THEN '001'
                                    WHEN @tipo_redacao = 3 THEN '002'ELSE '***' END + right('000000' +convert(varchar(6),our.id),6) +
                                                                                      right('000000' +convert(varchar(6),cor.id),6),
            co_formulario,id_prova, id_projeto,our.id, id_corretor = cor.id
        into #tmp_correcoes_redacao
       from correcoes_redacaoouro OUR join correcoes_corretor cor on (1=1)
                                      join projeto_projeto_usuarios usu on (cor.id = usu.user_id)
        where usu.projeto_id = 4 and 
              our.id_redacaotipo = @tipo_redacao and 
              usu.user_id in (select usuario_id from vw_usuario_hierarquia where perfil in ('AUXILIARES DE CORREÇÃO DE REDAÇÃO', 'avaliador'))
      order by co_barra_redacao

      select * from #tmp_correcoes_redacao
      -- *** inserir na tabela redacao com o codigo de barra alterado para o padrao moda ou ouro dependendo do tipo_redacao escolhido e levando o id da redacao referencia 
    insert correcoes_redacao (link_imagem_recortada, link_imagem_original, nota_final, id_redacao_situacao,
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto, id_redacaoouro)
    select link_imagem_recortada, link_imagem_original, nota_final, 1, 
           co_barra_redacao, co_inscricao, co_formulario, id_prova, id_projeto,id 
      from #tmp_correcoes_redacao tmp
     where not exists (select 1 from correcoes_redacao redx 
                        where redx.co_barra_redacao = tmp.co_barra_redacao AND
                              REDX.id_projeto = TMP.id_projeto)

    -- **** inserir na tabela filaOURO
    -- **** select * from correcoes_filaouro where posicao is null 
    insert correcoes_filaouro (co_barra_redacao, id_corretor, posicao, id_projeto, criado_em)
    SELECT tem.co_barra_redacao, tem.id_corretor, null, tem.id_projeto, GETDATE()
      FROM #tmp_correcoes_redacao tem
     where not exists (select top 1 1 from correcoes_filaouro flox 
                        where flox.co_barra_redacao = tem.co_barra_redacao and 
                              flox.id_corretor      = tem.id_corretor AND 
                              FLOX.id_projeto       = 4)
 
 -- ***** monto a ordenacao de busca das redacoes para o busca mais um 
 declare CUR_DIS_ORD_OUR_MOD cursor for 
    SELECT id_corretor, id_projeto FROM #tmp_correcoes_redacao
    open CUR_DIS_ORD_OUR_MOD 
        fetch next from CUR_DIS_ORD_OUR_MOD into @id_corretor, @id_projeto
        while @@FETCH_STATUS = 0
            BEGIN
                 exec sp_distribuir_ordem  @id_corretor, @id_projeto, @tipo_redacao

            fetch next from CUR_DIS_ORD_OUR_MOD into @id_corretor, @id_projeto
            END
    close CUR_DIS_ORD_OUR_MOD 
deallocate CUR_DIS_ORD_OUR_MOD

GO
/****** Object:  StoredProcedure [dbo].[sp_insere_discrepancia_na_fila]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_insere_discrepancia_na_fila] @CO_BARRA_REDACAO varchar(100), @REDACAO_ID int, @ID_ANALISE int, @FILA int
AS
	IF (@FILA = 3)
	BEGIN
		INSERT INTO CORRECOES_FILA3 (CORRIGIDO_POR, id_projeto, co_barra_redacao, redacao_id)
			SELECT DISTINCT
				DBO.fn_cor_corretor_redacao(CO_BARRA_REDACAO),
				id_projeto,
				co_barra_redacao,
				redacao_id
			FROM correcoes_correcao FIL3 WITH (NOLOCK)
			WHERE redacao_id = @REDACAO_ID
			AND NOT EXISTS (SELECT
					1
				FROM correcoes_fila3 FILX
				WHERE FILX.id_projeto = FIL3.id_projeto
				AND FILX.redacao_id = FIL3.redacao_id)
			AND NOT EXISTS (SELECT TOP 1
					1
				FROM CORRECOES_CORRECAO CORX
				WHERE CORX.redacao_id = FIL3.redacao_id
				AND CORX.id_tipo_correcao = 3
				AND CORX.id_projeto = FIL3.id_projeto)
		UPDATE correcoes_analise
		SET FILA = 3
		WHERE ID = @ID_ANALISE
	END
	ELSE
	IF (@FILA = 4)
	BEGIN
		INSERT INTO CORRECOES_FILA4 (CORRIGIDO_POR, id_projeto, co_barra_redacao, redacao_id)
			SELECT DISTINCT
				DBO.fn_cor_corretor_redacao(CO_BARRA_REDACAO),
				id_projeto,
				co_barra_redacao,
				redacao_id
			FROM correcoes_correcao FIL4 WITH (NOLOCK)
			WHERE redacao_id = @REDACAO_ID
			AND NOT EXISTS (SELECT
					1
				FROM correcoes_fila4 FILX
				WHERE FILX.id_projeto = FIL4.id_projeto
				AND FILX.redacao_id = FIL4.redacao_id)
			AND NOT EXISTS (SELECT TOP 1
					1
				FROM CORRECOES_CORRECAO CORX
				WHERE CORX.redacao_id = FIL4.redacao_id
				AND CORX.id_tipo_correcao = 4
				AND CORX.id_projeto = FIL4.id_projeto)
		UPDATE correcoes_analise
		SET FILA = 4
		WHERE ID = @ID_ANALISE
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                                             [SP_INSERIR_ANALISE]                                               *
*                                                                                                                *
*  PROCEDURE QUE EFETUA TODA A ANALISE DAS CORRECOES E COM BASE NESTAS ANALISES DESCIDE O FLUXO DA REDACAO NO PR *
* OCESSO DE CORRECAO.                                                                                            *
*                                                                                                                *
* BANCO_SISTEMA : ENEM                                                                                           *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:23/11/2019 *
******************************************************************************************************************/
CREATE   procedure [dbo].[sp_inserir_analise]
    @ID_CORRECAO   INT,
    @TIPO_GRAVACAO INT,
    @ID_PROJETO    INT,
    @ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @CONCLUSAO INT
DECLARE @REDACAO_ID INT

DECLARE @VAI_PARA_AUDITORIA INT
DECLARE @CODIGO_PD INT

DECLARE @LIMITE_NOTA_FINAL       FLOAT
DECLARE @LIMITE_NOTA_COMPETENCIA FLOAT

DECLARE @NOTA_FINAL FLOAT
DECLARE @RETORNOU_REGISTRO INT

DECLARE @SOBERANA INT

DECLARE @EQUIDISTANTE INT
SET @EQUIDISTANTE = 0

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0
SET @VAI_PARA_AUDITORIA = 0


SELECT @CODIGO_PD  = ID FROM CORRECOES_SITUACAO WHERE SIGLA = 'PD'

-- ***** VERIFICA QUA O PRIMEIRO TIPO DE CORREÇÃO É SOBERANO *****
SELECT TOP 1 @SOBERANA = ID FROM CORRECOES_TIPO WHERE flag_soberano = 1 ORDER BY ID

SELECT @CODBARRA = COR.CO_BARRA_REDACAO,
       @LIMITE_NOTA_FINAL = PRO.limite_nota_final,
       @LIMITE_NOTA_COMPETENCIA = PRO.limite_nota_competencia,
       @REDACAO_ID = COR.REDACAO_ID
  FROM CORRECOES_CORRECAO COR WITH (NOLOCK) JOIN PROJETO_PROJETO PRO WITH (NOLOCK) ON (COR.id_projeto = PRO.id)
 WHERE COR.ID = @ID_CORRECAO AND
       COR.id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY

            /************** TESTAR O TIPO DE GRAVACAO 1-(COMPARACAO 1,2) 2-(COMPARACAO 1,3) 3-(COMPARACAO 2-3) 4-(COMPARACAO 3-4)
                                                      5-(COMPARACAO 5 E OURO) 6-(COMPARACAO 6-MODA) 7-(COMPAFRACAO 7-ABSOLUTA)*******/
            IF (@TIPO_GRAVACAO = 1)
                BEGIN
                    IF (EXISTS (SELECT TOP 1 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
                                 WHERE redacao_id   = @REDACAO_ID AND
                                       id_tipo_correcao_A = 1 AND
                                       id_tipo_correcao_B = 2 AND
                                       id_projeto = @ID_PROJETO))
                        BEGIN
                            SET @ERRO = 'JÁ EXISTE'
                        END
                    ELSE
                        BEGIN
                            SELECT @NOTA         = NOTATOTAL,           @COMP1        = COMPETENCIA1,
                                   @COMP2        = COMPETENCIA2,        @COMP3        = COMPETENCIA3,
                                   @COMP4        = COMPETENCIA4,        @COMP5        = COMPETENCIA5,
                                   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
                                   @ID_CORRECAO2 = CORRECAO2,           @ID_CORRETOR1 = ID_CORRETOR1,
                                   @ID_CORRETOR2 = ID_CORRETOR2
                             FROM vw_cor_avalia_discrepancia_divergencia_correcao_1_2 WITH (NOLOCK)
                            WHERE id = @REDACAO_ID AND
                                  id_projeto = @ID_PROJETO
                            IF(@@ROWCOUNT = 0)
                                BEGIN
                                    set @ERRO = 'NAO EXISTE'
                                END
                        END
                END
            ELSE IF (@TIPO_GRAVACAO = 2)
                BEGIN
                    IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
                                 WHERE redacao_id   = @REDACAO_ID AND
                                       id_tipo_correcao_A = 1 AND
                                       id_tipo_correcao_B = 3 AND
                                       id_projeto = @ID_PROJETO))
                        BEGIN
                            SET @ERRO = 'JÁ EXISTE'
                        END
                    ELSE
                        BEGIN
                            SELECT @NOTA         = NOTATOTAL,           @COMP1        = COMPETENCIA1,
                                   @COMP2        = COMPETENCIA2,        @COMP3        = COMPETENCIA3,
                                   @COMP4        = COMPETENCIA4,        @COMP5        = COMPETENCIA5,
                                   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
                                   @ID_CORRECAO2 = CORRECAO2,           @ID_CORRETOR1 = ID_CORRETOR1,
                                   @ID_CORRETOR2 = ID_CORRETOR2
                             FROM vw_cor_avalia_discrepancia_divergencia_correcao_1_3 
                            WHERE id = @REDACAO_ID AND
                                  id_projeto = @ID_PROJETO
                            IF(@@ROWCOUNT = 0)
                                BEGIN
                                    set @ERRO = 'NAO EXISTE'
                                END
                        END
                END
            ELSE IF (@TIPO_GRAVACAO = 3)
                BEGIN
                    IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
                                 WHERE redacao_id = @REDACAO_ID AND
                                       id_tipo_correcao_A = 2 AND
                                       id_tipo_correcao_B = 3 AND
                                       id_projeto = @ID_PROJETO))
                        BEGIN
                            SET @ERRO = 'JÁ EXISTE'
                        END
                    ELSE
                        BEGIN
                            SELECT @NOTA         = NOTATOTAL,           @COMP1        = COMPETENCIA1,
                                   @COMP2        = COMPETENCIA2,        @COMP3        = COMPETENCIA3,
                                   @COMP4        = COMPETENCIA4,        @COMP5        = COMPETENCIA5,
                                   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
                                   @ID_CORRECAO2 = CORRECAO2,           @ID_CORRETOR1 = ID_CORRETOR1,
                                   @ID_CORRETOR2 = ID_CORRETOR2
                              FROM vw_cor_avalia_discrepancia_divergencia_correcao_2_3 
                            WHERE id = @REDACAO_ID AND
                                       id_projeto = @ID_PROJETO
                            IF(@@ROWCOUNT = 0)
                                BEGIN
                                    set @ERRO = 'NAO EXISTE'
                                END

                            SET @RETORNOU_REGISTRO = @@ROWCOUNT
                        END
                END
            ELSE IF (@TIPO_GRAVACAO = 4)
                BEGIN
                    IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE WITH (NOLOCK)
                                 WHERE redacao_id = @REDACAO_ID AND
                                       id_tipo_correcao_A = 3 AND
                                       id_tipo_correcao_B = 4 AND
                                       id_projeto = @ID_PROJETO))
                        BEGIN
                            SET @ERRO = 'JÁ EXISTE'
                        END
                    ELSE
                        BEGIN
                            SELECT @NOTA         = NOTATOTAL,           @COMP1        = COMPETENCIA1,
                                   @COMP2        = COMPETENCIA2,        @COMP3        = COMPETENCIA3,
                                   @COMP4        = COMPETENCIA4,        @COMP5        = COMPETENCIA5,
                                   @SITUACAO     = DIVERGENCIASITUACAO, @ID_CORRECAO1 = CORRECAO1,
                                   @ID_CORRECAO2 = CORRECAO2,           @ID_CORRETOR1 = ID_CORRETOR1,
                                   @ID_CORRETOR2 = ID_CORRETOR2
                              FROM vw_cor_avalia_discrepancia_divergencia_correcao_3_4 
                            WHERE id = @REDACAO_ID AND
                                       id_projeto = @ID_PROJETO
                            IF(@@ROWCOUNT = 0)
                                BEGIN
                                    set @ERRO = 'NAO EXISTE'
                                END

                            SET @RETORNOU_REGISTRO = @@ROWCOUNT
                        END
                END

            IF (@ERRO = '')
                BEGIN
                    /******* SE FOR COMPARACAO ENTRE 1 E 2 E HOUVER DISCREPANCIA GRAVAR UM REGISTRO NA FILA3 *********/
                    /*************************************************************************************************
                                                   ENCCEJA
                                                       NOTA MAIOR OU IGUAL 400
                                                       SITUACOES DIFERENTES
                                                   ENEM
                                                       NOTAFINAL MAIOR  100
                                                       NOTACOMPETENCIA MAIOR  80
                                                       SITUACAO DIFERENTE
                    *************************************************************************************************/

                    IF((@SITUACAO = 'SIM') )
                        BEGIN
                            SET @CONCLUSAO = 5
                        END
                    ELSE IF ((@NOTA >= @LIMITE_NOTA_FINAL))
                        BEGIN
                            print @nota
                            print @LIMITE_NOTA_FINAL
                            SET @CONCLUSAO = 4
                        END
                    ELSE IF ((@COMP1 >= @LIMITE_NOTA_COMPETENCIA OR
                              @COMP2 >= @LIMITE_NOTA_COMPETENCIA OR
                              @COMP3 >= @LIMITE_NOTA_COMPETENCIA OR
                              @COMP4 >= @LIMITE_NOTA_COMPETENCIA OR
                              @COMP5 >= @LIMITE_NOTA_COMPETENCIA ) )
                        BEGIN
                            SET @CONCLUSAO = 3
                        END
                    ELSE IF ((@NOTA > 0) )
                        BEGIN
                            SET @CONCLUSAO = 2
                        END
                    ELSE IF ((@COMP1 > 0 OR
                              @COMP2 > 0 OR
                              @COMP3 > 0 OR
                              @COMP4 > 0 OR
                              @COMP5 > 0 )  )
                        BEGIN
                            SET @CONCLUSAO = 1
                        END
                    ELSE
                        BEGIN
                            SET @CONCLUSAO = 0
                        END

                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/

                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
                    INSERT INTO CORRECOES_ANALISE (id_correcao_A, co_barra_redacao, data_inicio_A, data_termino_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
                                                   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
                                                   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
                                                   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
                                                   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
                                                   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO, id_projeto,
                                                   diferenca_nota_final,
                                                   conclusao_analise,fila,redacao_id,
                                                   ID_CORRECAO_B,
                                                   DATA_INICIO_B,         
                                                   DATA_TERMINO_B,        
                                                   NOTA_FINAL_B,          
                                                   COMPETENCIA1_B,        
                                                   COMPETENCIA2_B,        
                                                   COMPETENCIA3_B,        
                                                   COMPETENCIA4_B,        
                                                   COMPETENCIA5_B,        
                                                   NOTA_COMPETENCIA1_B,   
                                                   NOTA_COMPETENCIA2_B,   
                                                   NOTA_COMPETENCIA3_B,   
                                                   NOTA_COMPETENCIA4_B,   
                                                   NOTA_COMPETENCIA5_B,   
                                                   ID_AUXILIAR1_B,        
                                                   ID_AUXILIAR2_B ,       
                                                   ID_CORRECAO_SITUACAO_B,
                                                   ID_CORRETOR_B,         
                                                   ID_STATUS_B,           
                                                   ID_TIPO_CORRECAO_B)
                    SELECT COR1.ID, COR1.co_barra_redacao, COR1.data_inicio, COR1.data_termino,
                           COR1.link_imagem_recortada, COR1.link_imagem_original,
                           COR1.nota_final, COR1.competencia1, COR1.competencia2, COR1.competencia3, COR1.competencia4, COR1.competencia5,
                           COR1.nota_competencia1, DIFERENCA_COMPETENCIA1 = @COMP1,
                           SITUACAO_COMPETENCIA1 = CASE WHEN @COMP1 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP1 = 0 THEN 0 ELSE 1 END,
                           COR1.nota_competencia2, DIFERENCA_COMPETENCIA2 = @COMP2,
                           SITUACAO_COMPETENCIA2 = CASE WHEN @COMP2 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP2 = 0 THEN 0 ELSE 1 END,
                           COR1.nota_competencia3, DIFERENCA_COMPETENCIA3 = @COMP3,
                           SITUACAO_COMPETENCIA3 = CASE WHEN @COMP3 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP3 = 0 THEN 0 ELSE 1 END,
                           COR1.nota_competencia4, DIFERENCA_COMPETENCIA4 = @COMP4,
                           SITUACAO_COMPETENCIA4 = CASE WHEN @COMP4 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP4 = 0 THEN 0 ELSE 1 END,
                           COR1.nota_competencia5, DIFERENCA_COMPETENCIA5 = @COMP5,
                           SITUACAO_COMPETENCIA5 = CASE WHEN @COMP5 >= @LIMITE_NOTA_COMPETENCIA THEN 2 WHEN @COMP5 = 0 THEN 0 ELSE 1 END,
                           COR1.id_auxiliar1, COR1.id_auxiliar2, COR1.id_correcao_situacao,
                           COR1.id_corretor, COR1.id_status, COR1.id_tipo_correcao,
                           SITUACAO_NOTA_FINAL   = CASE WHEN @NOTA    >= @LIMITE_NOTA_FINAL   THEN 2 WHEN @NOTA = 0 THEN 0 ELSE 1 END,
                           DIFERENCA_SITUACAO    = CASE WHEN @SITUACAO = 'SIM' THEN 2 ELSE 0 END, COR1.id_projeto,
                           @NOTA, @CONCLUSAO, 0, @REDACAO_ID,
                           COR2.ID,
                           COR2.data_inicio,
                           COR2.data_termino,
                           COR2.NOTA_FINAL,
                           COR2.competencia1,
                           COR2.competencia2,
                           COR2.competencia3,
                           COR2.competencia4,
                           COR2.competencia5,
                           COR2.NOTA_COMPETENCIA1,
                           COR2.NOTA_COMPETENCIA2,
                           COR2.NOTA_COMPETENCIA3,
                           COR2.NOTA_COMPETENCIA4,
                           COR2.NOTA_COMPETENCIA5,
                           COR2.id_auxiliar1,
                           COR2.id_auxiliar2,
                           COR2.id_correcao_situacao,
                           COR2.id_corretor,
                           COR2.id_status,
                           COR2.id_tipo_correcao
                      FROM CORRECOES_CORRECAO COR1 JOIN CORRECOES_CORRECAO COR2 ON COR2.redacao_id = COR1.REDACAO_ID
                     WHERE COR1.ID = @ID_CORRECAO1
                       AND COR2.ID = @ID_CORRECAO2
                       AND COR1.id_projeto = @ID_PROJETO

                    /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    SET @ID_ANALISE = SCOPE_IDENTITY()

                END

            /****************************************************************************************************************/
           -- print 'passou 1'
            if exists(select top 1 1 from core_feature where codigo = 'auditoria' and ativo = 1) begin
          --  print 'passou 2'
                select distinct ID_PROJETO, redacao_id, CO_BARRA_REDACAO, id_correcao = null, corrigido_por = NULL, pendente = 0,
                        tipo_id = case when ((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) then 1
                                                  when (id_correcao_situacao_A = @CODIGO_PD or id_correcao_situacao_B = @CODIGO_PD) then 2
                                                  when (competencia5_A = -1 or competencia5_B = -1)  then 3
                                                  else null end, id_corretor = null
                into #temp_auditoria
                 from correcoes_analise ana
                where (((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) or
                       (competencia5_A = -1 or competencia5_B = -1) or
                       (id_correcao_situacao_A = @CODIGO_PD or id_correcao_situacao_B = @CODIGO_PD)) and
                       not exists (select 1 from correcoes_filaauditoria audx
                                    where audx.redacao_id = ana.redacao_id and
                                          audx.id_projeto       = ana.id_projeto       and
                                          audx.tipo_id = (case when ((nota_final_A = 1000 and nota_final_B  = 1000) or (nota_final_B  = 1000 and id_tipo_correcao_B = 4)) then 1
                                                               when (id_correcao_situacao_A = @CODIGO_PD or
                                                                     id_correcao_situacao_B = @CODIGO_PD)
                                                                     then 2
                                                               when (competencia5_A = -1 or competencia5_B = -1)
                                                                    then 3
                                                               else null end)) and

                    id = @ID_ANALISE

                    insert correcoes_filaauditoria (id_projeto, redacao_id, CO_BARRA_REDACAO, id_correcao, corrigido_por, pendente, tipo_id, id_corretor)
                    select * from #temp_auditoria tem
                    where not exists(select top 1 1 from correcoes_filaauditoria AUD WITH (NOLOCK) WHERE AUD.redacao_id = TEM.redacao_id)
                    set @VAI_PARA_AUDITORIA = 0

                    select @VAI_PARA_AUDITORIA = 1 from correcoes_filaauditoria aud WHERE AUD.redacao_id = @REDACAO_ID


                    if(exists(select top 1 1 from correcoes_correcao corx join correcoes_analise anax on (corx.redacao_id = anax.redacao_id)
                                 where anax.redacao_id = @REDACAO_ID and
                                       corx.id_tipo_correcao = 7))
                        begin
                            set @VAI_PARA_AUDITORIA = 1
                        end
            end
            /******************************************************************************************************************/
            /* EQUIDISTANCIA */

                /*select que busca todos equidistantes que nao possuem nenhuma discrepancia de competencia */
                IF ((SELECT COUNT(COR1.ID)
                                    FROM CORRECOES_CORRECAO COR1 JOIN CORRECOES_CORRECAO COR2 ON (COR1.redacao_id = COR2.redacao_id AND
                                                                                                                              COR1.id_tipo_correcao = 1 AND COR2.id_tipo_correcao = 2)
                                                                JOIN CORRECOES_CORRECAO COR3 ON (COR3.redacao_id = COR2.redacao_id AND
                                                                                                               COR3.id_tipo_correcao = 3)
                                     WHERE ((COR3.nota_final = (COR1.nota_final + COR2.nota_final)/2.0) OR
                                            (COR1.nota_final = COR2.nota_final AND
                                             COR1.id_correcao_situacao =1     AND
                                             COR2.id_correcao_situacao =1     AND
                                             COR3.id_correcao_situacao =1 ))  AND
                                             COR1.redacao_id = @REDACAO_ID and
                                            ((abs(cor3.competencia1 - cor2.competencia1)<=2) and
                                             (abs(cor3.competencia2 - cor2.competencia2)<=2) and
                                             (abs(cor3.competencia3 - cor2.competencia3)<=2) and
                                             (abs(cor3.competencia4 - cor2.competencia4)<=2) and
                                             (abs(cor3.competencia5 - cor2.competencia5)<=2)) and
                                            ((abs(cor3.competencia1 - cor1.competencia1)<=2) and
                                             (abs(cor3.competencia2 - cor1.competencia2)<=2) and
                                             (abs(cor3.competencia3 - cor1.competencia3)<=2) and
                                             (abs(cor3.competencia4 - cor1.competencia4)<=2) and
                                             (abs(cor3.competencia5 - cor1.competencia5)<=2))
                                             )> 0) and EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)
                        BEGIN

                            SET @EQUIDISTANTE = 1
                            SET @CONCLUSAO = 4
                            EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4
                        UPDATE correcoes_analise SET CONCLUSAO_ANALISE = 4 WHERE ID = @ID_ANALISE
                        END

           /*****************************************************************************************************************/
           /*****************************************************************************************************************/
                IF(@VAI_PARA_AUDITORIA = 0)
                    BEGIN
                        IF(EXISTS(SELECT 1 FROM CORE_FEATURE
                                   WHERE CODIGO = 'INSERE_NA_FILA_3_AUTOMATICO' AND ativo = 1) AND
                                         @CONCLUSAO > 2  and @TIPO_GRAVACAO = 1)
                            BEGIN
                                EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 3
                            END
                        ELSE IF(EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)AND
                                 @CONCLUSAO > 2 and
                                 @TIPO_GRAVACAO = 3)
                            BEGIN
                               /* se houver discrepancia na analise da terceira nas duas comparacoes 1 e 2 */
                                IF ((select count(id) from correcoes_analise
                                      where redacao_id = @REDACAO_ID  and
                                            id_tipo_correcao_B = 3        and
                                            conclusao_analise > 2) = 2 )
                                    BEGIN
                                        EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4

                                    END
                            END
                          ELSE IF(EXISTS(SELECT 1 FROM CORE_FEATURE WHERE CODIGO = 'INSERE_NA_FILA_4_AUTOMATICO' AND ativo = 1)AND
                                @EQUIDISTANTE = 1 and
                                 @TIPO_GRAVACAO = 3)
                            BEGIN
                                EXEC SP_INSERE_DISCREPANCIA_NA_FILA @CODBARRA, @REDACAO_ID, @ID_ANALISE, 4

                            END
                        -- ****** CALCULO DA NOTA FINAL DA REDACAO
                        -- ***** se for comparacao de primeira com segunda e nao houver discrepancia
                        IF(@TIPO_GRAVACAO = 1 and @CONCLUSAO <= 2)
                            BEGIN
                                  UPDATE RED SET RED.nota_final = (ABS(ISNULL(ANA.nota_final_A,0) + ISNULL(ANA.nota_final_B,0))/2.0) ,
                                                 red.id_correcao_situacao = ana.id_correcao_situacao_B, 
												 red.id_status = 4 ,
												 red.data_termino = case when ana.data_termino_a > ana.data_termino_b then ana.data_termino_a else ana.data_termino_b end 
                                   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                   WHERE ANA.ID = @ID_ANALISE

								   -- ***** copia notas e valida a finalizacao
								   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                            END
                        -- ***** se for comparacao com terceira
                        ELSE IF(@TIPO_GRAVACAO IN (2,3) AND @EQUIDISTANTE = 0)  -- SE FOR EQUIDISTANTE NAO GRAVA NOTA
                            BEGIN
                                IF(@SOBERANA <> 3 )
                                    BEGIN

                                        if((select count(id) from correcoes_analise
                                          where redacao_id = @REDACAO_ID and
                                                id_tipo_correcao_B = 3        and
                                                conclusao_analise < 3) > 0)
                                        begin
                                            DECLARE @NOTA_AUX  FLOAT
                                            DECLARE @NOTA1 FLOAT
                                            DECLARE @NOTA2 FLOAT
                                            DECLARE @NOTA3 FLOAT
                                            DECLARE @SITUACAO1 INT
                                            DECLARE @SITUACAO2 INT
                                            DECLARE @SITUACAO_AUX INT

                                            select @NOTA1     = CASE WHEN conclusao_analise <3 THEN nota_final_A ELSE -1 END,
                                                   @NOTA3     = nota_final_B,
                                                   @SITUACAO1 = CASE WHEN id_correcao_situacao_B = id_correcao_situacao_A THEN id_correcao_situacao_B ELSE -1 END
                                              from correcoes_analise
                                             where redacao_id = @REDACAO_ID and id_tipo_correcao_B = 3 and id_tipo_correcao_A = 1

                                            select @NOTA2     = CASE WHEN conclusao_analise <3 THEN nota_final_A ELSE -1 END,
                                                   @SITUACAO2 = CASE WHEN id_correcao_situacao_B = id_correcao_situacao_A THEN id_correcao_situacao_B ELSE -1 END
                                              from correcoes_analise
                                             where redacao_id = @REDACAO_ID and id_tipo_correcao_B = 3 and id_tipo_correcao_A = 2

                                            SET @NOTA_AUX = (CASE WHEN (@NOTA2 < 0 AND @NOTA1 <0) THEN -1
                                                                  WHEN (@NOTA2 < 0) THEN @NOTA1
                                                                  WHEN (@NOTA1 < 0) THEN @NOTA2
                                                                  WHEN ABS(@NOTA3 - @NOTA2) >= ABS(@NOTA3-@NOTA1) THEN @NOTA1 ELSE @NOTA2 END)

                                            SET @SITUACAO_AUX = (CASE WHEN @SITUACAO1 > 0 THEN @SITUACAO1
                                                                      WHEN @SITUACAO2 > 0 THEN @SITUACAO2
                                                                 END)

                                            IF(@NOTA_AUX > 0)
                                                BEGIN
                                                    UPDATE RED SET RED.nota_final =  (ABS(ISNULL(@NOTA_AUX,0) + ISNULL(@NOTA3,0))/2.0), 
													               RED.id_correcao_situacao = @SITUACAO_AUX, 
												                   red.id_status = 4 , red.data_termino = ana.data_termino_b
                                                       FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                                       WHERE ANA.ID = @ID_ANALISE
													   
													   print @TIPO_GRAVACAO 
													   print @REDACAO_ID
													   print @ID_ANALISE

													   -- ***** copia notas e valida a finalizacao
													   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                                                END
                                            ELSE
                                                BEGIN
                                                    UPDATE RED SET RED.nota_final =  0.0 , RED.id_correcao_situacao = @SITUACAO_AUX, 
												                   red.id_status = 4 , red.data_termino = ana.data_termino_b
                                                       FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                                       WHERE ANA.ID = @ID_ANALISE
													   
													   -- ***** copia notas e valida a finalizacao
													   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                                                END

                                        end
                                    END -------
                                ELSE
                                    BEGIN
                                        UPDATE RED SET RED.nota_final = ANA.nota_final_B, red.id_correcao_situacao = ana.id_correcao_situacao_B, 
												       red.id_status = 4 , red.data_termino = ana.data_termino_b
                                           FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                           WHERE ANA.ID = @ID_ANALISE
										   
										   -- ***** copia notas e valida a finalizacao
										   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                                    END
                            END
                        -- ***** se comparacao for com a quarta
                        ELSE IF(@TIPO_GRAVACAO IN (4) AND @SOBERANA = 4)
                            BEGIN

                                UPDATE RED SET RED.nota_final = ANA.nota_final_B, red.id_correcao_situacao = ana.id_correcao_situacao_B, 
											   red.id_status = 4 , red.data_termino = ana.data_termino_b
                                   FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.redacao_id = RED.id)
                                   WHERE ANA.ID = @ID_ANALISE
								   
								   -- ***** copia notas e valida a finalizacao
								   exec SP_COPIAR_NOTAS_FINAL_REDACAO @TIPO_GRAVACAO, @REDACAO_ID, @ID_ANALISE, @ID_PROJETO
                            END


                        IF (@TIPO_GRAVACAO = 3 and @erro = '' AND @EQUIDISTANTE = 0)
                            BEGIN
                                exec SP_AVALIA_APROVEITAMENTO @REDACAO_ID, @id_projeto
                            END
                    end
            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE()
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN
GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_auditoria]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_inserir_analise_auditoria]
    @ID_CORRECAO INT,
    @ID_PROJETO INT,
    @ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_TIPO_CORRECAO INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @LIMITE_NOTA_FINAL FLOAT
DECLARE @LIMITE_NOTA_COMPETENCIA FLOAT

DECLARE @RETORNOU_REGISTRO INT


SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

 SELECT @NOTA         = NOTA_FINAL,           @COMP1          = COMPETENCIA1,
        @COMP2        = COMPETENCIA2,         @COMP3          = COMPETENCIA3,
        @COMP4        = COMPETENCIA4,         @COMP5          = COMPETENCIA5,
        @SITUACAO     = ID_CORRECAO_SITUACAO, @ID_PROJETO     = ID_PROJETO,
        @ID_CORRECAO1 = ID,                   @ID_CORRETOR1   = ID_CORRETOR,
        @ID_TIPO_CORRECAO = ID_TIPO_CORRECAO
   FROM CORRECOES_CORRECAO COR
  WHERE CO_BARRA_REDACAO = @CODBARRA AND
        id_projeto = @ID_PROJETO     AND
        ID_TIPO_CORRECAO = 7
IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRY
            BEGIN TRANSACTION

            IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE
                            WHERE CO_BARRA_REDACAO = @CODBARRA AND
                                id_corretor_A      = @ID_CORRETOR1  AND
                                id_projeto         = @ID_PROJETO    AND
                                id_tipo_correcao_A = @ID_TIPO_CORRECAO))
                BEGIN
                    SET @ERRO = 'JÁ EXISTE'
                END



            IF (@ERRO = '')
                BEGIN
                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/
                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/

                    INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, nota_competencia2_A, nota_competencia3_A,  nota_competencia4_A, nota_competencia5_A,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A, id_corretor_A, id_status_A, id_tipo_correcao_A,
                                                   id_projeto, conclusao_analise,fila, redacao_id)
                    SELECT co_barra_redacao, data_inicio,data_termino, id,
                           link_imagem_recortada, link_imagem_original,
                           nota_final, competencia1, competencia2, competencia3, competencia4, competencia5,
                           nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
                           id_auxiliar1, id_auxiliar2, id_correcao_situacao, id_corretor, id_status, id_tipo_correcao, id_projeto, 0,0, redacao_id
                      FROM CORRECOES_CORRECAO
                     WHERE id_corretor = @ID_CORRETOR1  and
                           co_barra_redacao = @CODBARRA and
                           id_projeto = @ID_PROJETO     and
                           id_tipo_correcao = @ID_TIPO_CORRECAO
            /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    select @ID_ANALISE = ANA.ID
                    FROM CORRECOES_ANALISE ANA
                     WHERE ANA.CO_BARRA_REDACAO = @CODBARRA AND
                           ana.id_tipo_correcao_A = 7


            /****************************************************************************************************************/

             UPDATE RED SET RED.nota_final =  ANA.nota_final_A, red.id_correcao_situacao = ana.id_correcao_situacao_A,
			                                  red.id_status = 4, red.data_termino = ana.data_termino_a 
             FROM CORRECOES_ANALISE ANA JOIN CORRECOES_REDACAO RED ON (ANA.co_barra_redacao = RED.co_barra_redacao AND
                                                                       ANA.id_projeto       = RED.id_projeto)
              WHERE ANA.ID = @ID_ANALISE

                END

            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'AUDITORIA - O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_gabarito]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   procedure [dbo].[sp_inserir_analise_gabarito]
    @ID_CORRECAO INT,
    @ID_PROJETO INT,
    @ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @REDACAO_ID INT

DECLARE @LIMITE_NOTA_COMPETENCIA DECIMAL(10,2)
DECLARE @LIMITE_NOTA_FINAL DECIMAL(10,2)

DECLARE @RETORNOU_REGISTRO INT

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0


--Carrega os valores limites para o cálculo da discrepância e divergência
select @LIMITE_NOTA_COMPETENCIA = LIMITE_NOTA_COMPETENCIA, @LIMITE_NOTA_FINAL = LIMITE_NOTA_FINAL
  from projeto_projeto
  where id = @ID_PROJETO

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor, @REDACAO_ID = redacao_id
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY

            IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE 
                            WHERE redacao_id = @REDACAO_ID AND
                                id_corretor_A = @ID_CORRETOR1  AND
                                id_projeto = @ID_PROJETO)) BEGIN
                SET @ERRO = 'JÁ EXISTE'
            END


            IF (@ERRO = '')
                BEGIN
                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/
                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
                    INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
                                                   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
                                                   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
                                                   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
                                                   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
                                                   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO,
                                                   diferenca_nota_final,id_projeto,
                                                   conclusao_analise,fila,
                                                   nota_final_b,
                                                   competencia1_b,        
                                                   competencia2_b,
                                                   competencia3_b,
                                                   competencia4_b,
                                                   competencia5_b,
                                                   nota_competencia1_b,
                                                   nota_competencia2_b,
                                                   nota_competencia3_b,
                                                   nota_competencia4_b,
                                                   nota_competencia5_b,
                                                   id_correcao_situacao_b,
                                                   redacao_id
                                                    )
                    SELECT top 1 cor.co_barra_redacao, cor.data_inicio_correcao, cor.data_termino_correcao, cor.id_correcao,
                           cor.link_imagem_recortada, cor.link_imagem_original,
                           nota_final_correcao,
                           id_competencia1_correcao,
                           id_competencia2_correcao,
                           id_competencia3_correcao,
                           id_competencia4_correcao,
                           id_competencia5_correcao,
                           nota_competencia1_correcao, competencia1_diferenca, case when competencia1_diferenca >= 81 then 2 when competencia1_diferenca = 0 then 0 else 1 end as situacao_competencia1,
                           nota_competencia2_correcao, competencia2_diferenca, case when competencia2_diferenca >= 81 then 2 when competencia2_diferenca = 0 then 0 else 1 end as situacao_competencia2,
                           nota_competencia3_correcao, competencia3_diferenca, case when competencia3_diferenca >= 81 then 2 when competencia3_diferenca = 0 then 0 else 1 end as situacao_competencia3,
                           nota_competencia4_correcao, competencia4_diferenca, case when competencia4_diferenca >= 81 then 2 when competencia4_diferenca = 0 then 0 else 1 end as situacao_competencia4,
                           nota_competencia5_correcao, competencia5_diferenca, case when competencia5_diferenca >= 81 then 2 when competencia5_diferenca = 0 then 0 else 1 end as situacao_competencia5,
                           id_auxiliar1, id_auxiliar2, id_correcao_situacao_correcao,
                           id_corretor, id_status, id_tipo_correcao,
                           case when nota_final_diferenca >= 101 then 2 when nota_final_diferenca = 0 then 0 else 1 end as situacao_nota_final,
                           case when divergencia_situacao = 'SIM' then 2 else 0 end,
                           nota_final_diferenca,id_projeto,
                           0 as conclusao_analise,
                           0 as fila,
                           cor.nota_final_gabarito,
                           cor.id_competencia1_gabarito,
                           cor.id_competencia2_gabarito,
                           cor.id_competencia3_gabarito,
                           cor.id_competencia4_gabarito,
                           cor.id_competencia5_gabarito,
                           cor.nota_competencia1_gabarito,
                           cor.nota_competencia2_gabarito,
                           cor.nota_competencia3_gabarito,
                           cor.nota_competencia4_gabarito,
                           cor.nota_competencia5_gabarito,
                           cor.id_correcao_situacao_gabarito,
                           @REDACAO_ID
                      FROM [vw_cor_batimento_gabarito] COR
                     WHERE cor.id_corretor = @ID_CORRETOR1 and
                           cor.co_barra_redacao = @CODBARRA and
                           cor.id_projeto = @ID_PROJETO

                    /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    set @ID_ANALISE = @@IDENTITY

                    --ATUALIZA A CONCLUSAO DA ANALISE
                    update ana set ana.conclusao_analise = 
                           case when diferenca_situacao > 0 then 5
                         when situacao_nota_final = 2  then 4
                         when (situacao_competencia1 = 2 or
                               situacao_competencia2 = 2 or
                               situacao_competencia3 = 2 or
                               situacao_competencia4 = 2 or
                               situacao_competencia5 = 2 )then 3
                         when  situacao_nota_final = 1 then 2
                         when (situacao_competencia1 = 1 or
                               situacao_competencia2 = 1 or
                               situacao_competencia3 = 1 or
                               situacao_competencia4 = 1 or
                               situacao_competencia5 = 1 )then 1 else 0 end
                          from correcoes_analise ana
                         where id = @ID_ANALISE

               update ana set ana.nota_corretor = case  conclusao_analise when 5 then 0
                                  when 4 then 0
                                  when 3 then 0
                                  when 2 then 1
                                  when 1 then 1
                                  when 0 then 1 end,
                             ana.nota_desempenho = dbo.fn_calcula_nota_desempenho_ouro_moda(@ID_ANALISE) 
                from correcoes_analise ana 
            where id = @ID_ANALISE


            update correcoes_corretor set 
                   nota_corretor =  round(cast ((select sum(nota_corretor) * 10/ (select max_correcoes_dia 
                                                                                    from projeto_projeto proxx 
                                                                                   where proxx.id = @ID_PROJETO)
             
                                                             from correcoes_analise anax
                                                            where id_corretor_A = @ID_CORRETOR1) as decimal(3,1)),2) 
             where id = @ID_CORRETOR1

            -- *** GRAVAR STATUS E DATA DE TERMINO DA CORRECAO
			update red set red.id_status = 4, RED.data_termino = ana.data_termino_a
			   from correcoes_redacao red join correcoes_analise ana ON (red.id = ana.redacao_id)
			   where ana.id = @ID_ANALISE
                END

            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN
GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_gabarito_preteste]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    procedure [dbo].[sp_inserir_analise_gabarito_preteste]
    @ID_CORRECAO INT,
    @ID_PROJETO INT,
    @ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @REDACAO_ID INT

DECLARE @LIMITE_NOTA_COMPETENCIA DECIMAL(10,2)
DECLARE @LIMITE_NOTA_FINAL DECIMAL(10,2)

DECLARE @RETORNOU_REGISTRO INT

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0


--Carrega os valores limites para o cálculo da discrepância e divergência
select @LIMITE_NOTA_COMPETENCIA = LIMITE_NOTA_COMPETENCIA, @LIMITE_NOTA_FINAL = LIMITE_NOTA_FINAL
  from projeto_projeto
  where id = @ID_PROJETO

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor, @REDACAO_ID = redacao_id
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY

            IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE 
                            WHERE CO_BARRA_REDACAO = @CODBARRA AND
                                id_corretor_A = @ID_CORRETOR1  AND
                                id_projeto = @ID_PROJETO)) BEGIN
                SET @ERRO = 'JÁ EXISTE'
            END


            IF (@ERRO = '')
                BEGIN
                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/
                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
                    INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
                                                   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
                                                   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
                                                   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
                                                   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
                                                   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO,
                                                   diferenca_nota_final,id_projeto,
                                                   conclusao_analise,fila,
                                                   nota_final_b,
                                                   competencia1_b,        
                                                   competencia2_b,
                                                   competencia3_b,
                                                   competencia4_b,
                                                   competencia5_b,
                                                   nota_competencia1_b,
                                                   nota_competencia2_b,
                                                   nota_competencia3_b,
                                                   nota_competencia4_b,
                                                   nota_competencia5_b,
                                                   id_correcao_situacao_b, redacao_id
                                                    )
                    SELECT top 1 cor.co_barra_redacao, cor.data_inicio_correcao, cor.data_termino_correcao, cor.id_correcao,
                           cor.link_imagem_recortada, cor.link_imagem_original,
                           nota_final_correcao,
                           id_competencia1_correcao,
                           id_competencia2_correcao,
                           id_competencia3_correcao,
                           id_competencia4_correcao,
                           id_competencia5_correcao,
                           nota_competencia1_correcao, competencia1_diferenca, case when competencia1_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia1_diferenca = 0 then 0 else 1 end as situacao_competencia1,
                           nota_competencia2_correcao, competencia2_diferenca, case when competencia2_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia2_diferenca = 0 then 0 else 1 end as situacao_competencia2,
                           nota_competencia3_correcao, competencia3_diferenca, case when competencia3_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia3_diferenca = 0 then 0 else 1 end as situacao_competencia3,
                           nota_competencia4_correcao, competencia4_diferenca, case when competencia4_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia4_diferenca = 0 then 0 else 1 end as situacao_competencia4,
                           nota_competencia5_correcao, competencia5_diferenca, case when competencia5_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia5_diferenca = 0 then 0 else 1 end as situacao_competencia5,
                           id_auxiliar1, id_auxiliar2, id_correcao_situacao_correcao,
                           id_corretor, id_status, id_tipo_correcao,
                           case when nota_final_diferenca >= @LIMITE_NOTA_FINAL then 2 when nota_final_diferenca = 0 then 0 else 1 end as situacao_nota_final,
                           case when divergencia_situacao = 'SIM' then 2 else 0 end,
                           nota_final_diferenca,id_projeto,
                           0 as conclusao_analise,
                           0 as fila,
                           cor.nota_final_gabarito,
                           cor.id_competencia1_gabarito,
                           cor.id_competencia2_gabarito,
                           cor.id_competencia3_gabarito,
                           cor.id_competencia4_gabarito,
                           cor.id_competencia5_gabarito,
                           cor.nota_competencia1_gabarito,
                           cor.nota_competencia2_gabarito,
                           cor.nota_competencia3_gabarito,
                           cor.nota_competencia4_gabarito,
                           cor.nota_competencia5_gabarito,
                           cor.id_correcao_situacao_gabarito,
                           @REDACAO_ID
                      FROM [vw_cor_batimento_gabarito] COR
                     WHERE cor.id_corretor = @ID_CORRETOR1 and
                           cor.redacao_id = @REDACAO_ID and
                           cor.id_projeto = @ID_PROJETO

                    /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    set @ID_ANALISE = @@IDENTITY

                    --ATUALIZA A CONCLUSAO DA ANALISE
                    update ana set ana.conclusao_analise = 
                           case when diferenca_situacao > 0 then 5
                         when situacao_nota_final = 2  then 4
                         when (situacao_competencia1 = 2 or
                               situacao_competencia2 = 2 or
                               situacao_competencia3 = 2 or
                               situacao_competencia4 = 2 or
                               situacao_competencia5 = 2 )then 3
                         when  situacao_nota_final = 1 then 2
                         when (situacao_competencia1 = 1 or
                               situacao_competencia2 = 1 or
                               situacao_competencia3 = 1 or
                               situacao_competencia4 = 1 or
                               situacao_competencia5 = 1 )then 1 else 0 end
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update ana
                           set ana.nota_corretor = (case conclusao_analise
                                                        when 5 then 0
                                                        when 4 then 0
                                                        when 3 then 0
                                                        when 2 then 1
                                                        when 1 then 1
                                                        when 0 then 1 end) * convert(decimal(10,2), ((select convert(decimal(10,2), isnull(valor, valor_padrao)) from core_parametros where nome = 'NOTA_MAXIMA_PRETESTE') / (select convert(decimal(10,2), isnull(valor, valor_padrao)) from core_parametros where nome = 'REDACOES_OURO_PRETESTE')))
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update correcoes_corretor set 
                            nota_corretor =  round(cast ((select sum(nota_corretor)                        
                                                            from correcoes_analise anax
                                                           where id_corretor_A = @ID_CORRETOR1) as decimal(3,1)),2) 
                        where id = @ID_CORRETOR1

                END

            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN

GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_analise_gabarito_preteste_enem]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    procedure [dbo].[sp_inserir_analise_gabarito_preteste_enem]
    @ID_CORRECAO INT,
    @ID_PROJETO INT,
    @ERRO VARCHAR(500) OUTPUT
AS

DECLARE @NOTA INT
DECLARE @COMP1 INT
DECLARE @COMP2 INT
DECLARE @COMP3 INT
DECLARE @COMP4 INT
DECLARE @COMP5 INT
DECLARE @ID_CORRECAO1 INT
DECLARE @ID_CORRECAO2 INT
DECLARE @ID_CORRETOR1 INT
DECLARE @ID_CORRETOR2 INT
DECLARE @ID_ANALISE INT
DECLARE @SITUACAO VARCHAR(10)
DECLARE @CODBARRA VARCHAR(50)
DECLARE @REDACAO_ID INT

DECLARE @LIMITE_NOTA_COMPETENCIA DECIMAL(10,2)
DECLARE @LIMITE_NOTA_FINAL DECIMAL(10,2)

DECLARE @RETORNOU_REGISTRO INT

SET @ERRO = ''
SET @RETORNOU_REGISTRO = 0


--Carrega os valores limites para o cálculo da discrepância e divergência
select @LIMITE_NOTA_COMPETENCIA = LIMITE_NOTA_COMPETENCIA, @LIMITE_NOTA_FINAL = LIMITE_NOTA_FINAL
  from projeto_projeto
  where id = @ID_PROJETO

SELECT @CODBARRA = CO_BARRA_REDACAO, @ID_CORRETOR1 = id_corretor, @REDACAO_ID = redacao_id
  FROM CORRECOES_CORRECAO
 WHERE ID = @ID_CORRECAO AND
       id_projeto = @ID_PROJETO

IF(@@ROWCOUNT = 0)
    BEGIN
        SET @ERRO = 'NAO EXISTE REFERENCIA PARA ESTE ID DE CORRECAO - ' + CONVERT(VARCHAR(20),@ID_CORRECAO)
    END

IF (@ERRO = '')
    BEGIN
        BEGIN TRANSACTION
        BEGIN TRY

            IF (EXISTS (SELECT 1 FROM CORRECOES_ANALISE 
                            WHERE CO_BARRA_REDACAO = @CODBARRA AND
                                id_corretor_A = @ID_CORRETOR1  AND
                                id_projeto = @ID_PROJETO)) BEGIN
                SET @ERRO = 'JÁ EXISTE'
            END


            IF (@ERRO = '')
                BEGIN
                    --PRINT 'GRAVAR NA CORRECCOES_ANALISE'
                    /*****************************************************************************************************/
                    /***** FAZER O INSERT DO PRIMEIRO CORRETOR NA TABELA ANALISE ******/
                    INSERT INTO CORRECOES_ANALISE (co_barra_redacao, data_inicio_A, data_termino_A, id_correcao_A,
                                                   link_imagem_recortada, link_imagem_original,
                                                   nota_final_A, competencia1_A, competencia2_A, competencia3_A, competencia4_A, competencia5_A,
                                                   nota_competencia1_A, diferenca_competencia1, situacao_competencia1,
                                                   nota_competencia2_A, diferenca_competencia2, situacao_competencia2,
                                                   nota_competencia3_A, diferenca_competencia3, situacao_competencia3,
                                                   nota_competencia4_A, diferenca_competencia4, situacao_competencia4,
                                                   nota_competencia5_A, diferenca_competencia5, situacao_competencia5,
                                                   id_auxiliar1_A, id_auxiliar2_A, id_correcao_situacao_A,
                                                   id_corretor_A, id_status_A, id_tipo_correcao_A, situacao_nota_final,DIFERENCA_SITUACAO,
                                                   diferenca_nota_final,id_projeto,
                                                   conclusao_analise,fila,
                                                   nota_final_b,
                                                   competencia1_b,        
                                                   competencia2_b,
                                                   competencia3_b,
                                                   competencia4_b,
                                                   competencia5_b,
                                                   nota_competencia1_b,
                                                   nota_competencia2_b,
                                                   nota_competencia3_b,
                                                   nota_competencia4_b,
                                                   nota_competencia5_b,
                                                   id_correcao_situacao_b, redacao_id
                                                    )
                    SELECT top 1 cor.co_barra_redacao, cor.data_inicio_correcao, cor.data_termino_correcao, cor.id_correcao,
                           cor.link_imagem_recortada, cor.link_imagem_original,
                           nota_final_correcao,
                           id_competencia1_correcao,
                           id_competencia2_correcao,
                           id_competencia3_correcao,
                           id_competencia4_correcao,
                           id_competencia5_correcao,
                           nota_competencia1_correcao, competencia1_diferenca, case when competencia1_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia1_diferenca = 0 then 0 else 1 end as situacao_competencia1,
                           nota_competencia2_correcao, competencia2_diferenca, case when competencia2_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia2_diferenca = 0 then 0 else 1 end as situacao_competencia2,
                           nota_competencia3_correcao, competencia3_diferenca, case when competencia3_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia3_diferenca = 0 then 0 else 1 end as situacao_competencia3,
                           nota_competencia4_correcao, competencia4_diferenca, case when competencia4_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia4_diferenca = 0 then 0 else 1 end as situacao_competencia4,
                           nota_competencia5_correcao, competencia5_diferenca, case when competencia5_diferenca >= @LIMITE_NOTA_COMPETENCIA then 2 when competencia5_diferenca = 0 then 0 else 1 end as situacao_competencia5,
                           id_auxiliar1, id_auxiliar2, id_correcao_situacao_correcao,
                           id_corretor, id_status, id_tipo_correcao,
                           case when nota_final_diferenca >= @LIMITE_NOTA_FINAL then 2 when nota_final_diferenca = 0 then 0 else 1 end as situacao_nota_final,
                           case when divergencia_situacao = 'SIM' then 2 else 0 end,
                           nota_final_diferenca,id_projeto,
                           0 as conclusao_analise,
                           0 as fila,
                           cor.nota_final_gabarito,
                           cor.id_competencia1_gabarito,
                           cor.id_competencia2_gabarito,
                           cor.id_competencia3_gabarito,
                           cor.id_competencia4_gabarito,
                           cor.id_competencia5_gabarito,
                           cor.nota_competencia1_gabarito,
                           cor.nota_competencia2_gabarito,
                           cor.nota_competencia3_gabarito,
                           cor.nota_competencia4_gabarito,
                           cor.nota_competencia5_gabarito,
                           cor.id_correcao_situacao_gabarito,
                           @REDACAO_ID
                      FROM [vw_cor_batimento_gabarito] COR
                     WHERE cor.id_corretor = @ID_CORRETOR1 and
                           cor.redacao_id = @REDACAO_ID and
                           cor.id_projeto = @ID_PROJETO

                    /***** RECUPERAR O ID DA TABELA ANALISE PARA O PODERMOS INSERIR A SEGUNDA CORRECAO ******/
                    set @ID_ANALISE = @@IDENTITY

                    --ATUALIZA A CONCLUSAO DA ANALISE
                    update ana set ana.conclusao_analise = 
                           case when diferenca_situacao > 0 then 5
                         when situacao_nota_final = 2  then 4
                         when (situacao_competencia1 = 2 or
                               situacao_competencia2 = 2 or
                               situacao_competencia3 = 2 or
                               situacao_competencia4 = 2 or
                               situacao_competencia5 = 2 )then 3
                         when  situacao_nota_final = 1 then 2
                         when (situacao_competencia1 = 1 or
                               situacao_competencia2 = 1 or
                               situacao_competencia3 = 1 or
                               situacao_competencia4 = 1 or
                               situacao_competencia5 = 1 )then 1 else 0 end
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update ana
                           set ana.nota_corretor = dbo.fn_calcula_nota_desempenho_ouro_moda_preteste_enem(@ID_ANALISE),
                               ana.nota_desempenho = dbo.fn_calcula_nota_desempenho_ouro_moda_preteste_enem(@ID_ANALISE)
                          from correcoes_analise ana
                         where id = @ID_ANALISE

                        update correcoes_corretor set 
                            nota_corretor =  (select avg(nota_corretor)                        
                                                            from correcoes_analise anax
                                                           where id_corretor_A = @ID_CORRETOR1)
                        where id = @ID_CORRETOR1

                END

            COMMIT
        END TRY
        BEGIN CATCH
            ROLLBACK
            SET @ERRO = 'O PROCESSAMENTO NAO FOI EFETUADO - ID_CORRECAO = ' + CONVERT(VARCHAR(30), @ID_CORRECAO) + ' - ' + ERROR_MESSAGE ( )
        END CATCH
    END

    IF(@ERRO = '')
        BEGIN
            SET @ERRO = 'OK'
        END

    RETURN


GO
/****** Object:  StoredProcedure [dbo].[sp_inserir_log_erro_N]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*****************************************************************************************************************
*                        PROCEDURE PARA INSERIR NA TABELA DE LOG DE ERROS DOS ARQUIVOS N                         *
*                                                                                                                *
* PROCEDIMENTO QUE RECEBE O CODIGO DA CORRECAO QUE DEU ERRO, TIPO, O ARQUIVO N QUE DEU ERRO E A DESCRICAO DO     *
* ERRO                                                                                                           *
*                                                                                                                *
* BANCO_SISTEMA: CORRECAO_ENCCEJA                                                                                *
* AUTOR: WEMERSON BITTORI MADURO                                                                 DATA:07/08/2018 *
* MODIFICADO: WEMERSON BITTORI MADURO                                                            DATA:10/08/2018 *
******************************************************************************************************************/
-- SELECT * FROM inep_log_erro_N

CREATE   procedure [dbo].[sp_inserir_log_erro_N] 
    @idCorrecao int,        /****  IDENTIFICADOR DA CORRECAO                         ***/
    @tipo_log varchar(100), /****  TIPO DO LOG { INSERT, UPDATE, DELETE,...          ***/
    @arquivo varchar(100),  /****  NOME DO ARQUIVO QUE GEROU O LOG { N02, N59, ...}  ***/
    @descricao varchar(1000),/****  DETALHAMENTO DO LOG                               ***/
    @tipo_erro varchar(1000) /****  TIPO DO ERRO QUE GEROU O LOG                      ***/
as 

insert into inep_log_erro_N (criado_em, id_correcao, tipo_log,   arquivo, des_log,     tipo_erro) 
     values                 (getdate(), @idCorrecao, @tipo_log, @arquivo, @descricao, @tipo_erro)

GO
/****** Object:  StoredProcedure [dbo].[sp_libera_correcao]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_libera_correcao] 
    @id_fila_pessoal int
AS

set nocount on

declare @id_correcao int
declare @id_tipo_correcao int
declare @co_barra_redacao varchar(50)
declare @corrigido_por varchar(255)
declare @id_projeto int
declare @id_grupo_corretor int

select @id_correcao = id_correcao from correcoes_filapessoal where id = @id_fila_pessoal

--Consulta dados da Correção
select @id_tipo_correcao = a.id_tipo_correcao, @co_barra_redacao = a.co_barra_redacao, @id_projeto = a.id_projeto, @id_grupo_corretor = b.id_grupo,
       @corrigido_por = ',' + (STUFF((
          SELECT ',' + convert(varchar(50), x.id_corretor)
          FROM correcoes_correcao x
          WHERE x.co_barra_redacao = a.co_barra_redacao and id <> @id_correcao
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
          ) + ','
  from correcoes_correcao a, correcoes_corretor b
 where a.id = @id_correcao and a.id_corretor = b.id

begin tran

delete from correcoes_filapessoal where id = @id_fila_pessoal
delete from ocorrencias_ocorrencia where correcao_id = @id_correcao
delete from correcoes_historicocorrecao where correcao_id = @id_correcao
delete from correcoes_correcao where id = @id_correcao

if @id_tipo_correcao = 1 begin
    insert into correcoes_fila1 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
    values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end
if @id_tipo_correcao = 2 begin
    insert into correcoes_fila2 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
    values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end
if @id_tipo_correcao = 3 begin
    insert into correcoes_fila3 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
    values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end

set nocount off

print 'Correção retornada para fila' + convert(varchar(100), @id_tipo_correcao)

commit

GO
/****** Object:  StoredProcedure [dbo].[SP_RECALCULA_ANALISE]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC SP_RECALCULA_ANALISE 98265,1
CREATE  PROCEDURE [dbo].[SP_RECALCULA_ANALISE] @analise_id INT, @ID_PROJETO INT AS 
 
declare  @redacao_id int, @id_tipo_correcao int , @ID_CORRECAO INT, @RETORNO VARCHAR(500), @PODE_REFAZER INT
	
	-- set @analise_id = 98265
    -- set @ID_PROJETO = 1
	SET @RETORNO = 'NAO FOI POSSIVEL RECALCULAR A ANALISE'
	SET @PODE_REFAZER = 0

	select  @redacao_id = redacao_id , @id_tipo_correcao = id_tipo_correcao_B, 
	        @ID_PROJETO = id_projeto,  @ID_CORRECAO = id_correcao_B	
	from correcoes_analise
	 where id = @analise_id and id_projeto = @ID_PROJETO

	         SELECT @PODE_REFAZER = 1
			   FROM VW_MAIOR_CORRECAO MAI JOIN VW_FILA_MAIS_ALTA ALT ON (MAI.REDACAO_ID = ALT.REDACAO_ID AND 
			                                                             MAI.ID_PROJETO = ALT.ID_PROJETO)  
			 WHERE MAI.REDACAO_ID = @redacao_id AND 
			       MAI.ID_PROJETO = @ID_PROJETO AND 
				   MAI.MAIOR_CORRECAO = @id_tipo_correcao AND
				   ALT.FILA = 0




                IF(@ID_TIPO_CORRECAO IN (1,2) and @PODE_REFAZER = 1) -- **** COMPARACAO PRIMEIRA COM A SEGUNDA
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO AND id_tipo_correcao_B = 2

								EXEC  sp_inserir_analise @ID_CORRECAO,1, @ID_PROJETO, @retorno output	
								SET @RETORNO = 'ANALISE RECALCULADA'						
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
												
					END
				ELSE IF(@ID_TIPO_CORRECAO =3  and @PODE_REFAZER = 1) -- **** COMPARARACAO PRIMEIRA COM TERCEIRA E SEGUNDA COM TERCEIRA 
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO AND id_tipo_correcao_B = 3
								                                   

								EXEC  sp_inserir_analise @ID_CORRECAO,2, @ID_PROJETO, @retorno output							
								EXEC  sp_inserir_analise @ID_CORRECAO,3, @ID_PROJETO, @retorno output	
								SET @RETORNO = 'ANALISE RECALCULADA'						
							
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
				ELSE IF(@ID_TIPO_CORRECAO =4  and @PODE_REFAZER = 1)
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO  AND id_tipo_correcao_B = 4

								EXEC  sp_inserir_analise @ID_CORRECAO,4, @ID_PROJETO, @retorno output		
								SET @RETORNO = 'ANALISE RECALCULADA'												
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
				-- OURO
				ELSE IF(@ID_TIPO_CORRECAO = 5 and @PODE_REFAZER = 1) -- **** CORRECOES DO TIPO OURO 
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO  AND id_tipo_correcao_B = 5

								EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @retorno output		
								SET @RETORNO = 'ANALISE RECALCULADA'												
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
                -- MODA
				ELSE IF(@ID_TIPO_CORRECAO = 6 and @PODE_REFAZER = 1) -- **** CORRECOES DO TIPO MODA 
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO  AND id_tipo_correcao_B = 6

								EXEC  sp_inserir_analise_gabarito @ID_CORRECAO, @ID_PROJETO, @retorno output			
								SET @RETORNO = 'ANALISE RECALCULADA'											
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END
                --- AUDITORIA
				ELSE IF(@ID_TIPO_CORRECAO = 7 and @PODE_REFAZER = 1) -- **** CORRECOES DO TIPO AUDITORIA 
					BEGIN
						BEGIN TRY
							BEGIN TRANSACTION
								DELETE FROM correcoes_analise WHERE redacao_id = @redacao_id AND  id_projeto = @ID_PROJETO  AND id_tipo_correcao_B = 7

								EXEC  sp_inserir_analise_auditoria @ID_CORRECAO, @ID_PROJETO, @retorno output	
								SET @RETORNO = 'ANALISE RECALCULADA'						
							COMMIT
						END TRY
						BEGIN CATCH
							ROLLBACK
						END CATCH
					END

		PRINT @RETORNO + ' -> REDACAO ID = ' + CONVERT(VARCHAR(20),@REDACAO_ID) 
GO
/****** Object:  StoredProcedure [dbo].[sp_WhoIsActive]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*********************************************************************************************
Who Is Active? v11.32 (2018-07-03)
(C) 2007-2018, Adam Machanic

Feedback: mailto:adam@dataeducation.com
Updates: http://whoisactive.com
Blog: http://dataeducation.com

License: 
    Who is Active? is free to download and use for personal, educational, and internal 
    corporate purposes, provided that this header is preserved. Redistribution or sale 
    of Who is Active?, in whole or in part, is prohibited without the author's express 
    written consent.
*********************************************************************************************/
CREATE   PROC [dbo].[sp_WhoIsActive]
(
--~
    --Filters--Both inclusive and exclusive
    --Set either filter to '' to disable
    --Valid filter types are: session, program, database, login, and host
    --Session is a session ID, and either 0 or '' can be used to indicate "all" sessions
    --All other filter types support % or _ as wildcards
    @filter sysname = '',
    @filter_type VARCHAR(10) = 'session',
    @not_filter sysname = '',
    @not_filter_type VARCHAR(10) = 'session',

    --Retrieve data about the calling session?
    @show_own_spid BIT = 0,

    --Retrieve data about system sessions?
    @show_system_spids BIT = 0,

    --Controls how sleeping SPIDs are handled, based on the idea of levels of interest
    --0 does not pull any sleeping SPIDs
    --1 pulls only those sleeping SPIDs that also have an open transaction
    --2 pulls all sleeping SPIDs
    @show_sleeping_spids TINYINT = 1,

    --If 1, gets the full stored procedure or running batch, when available
    --If 0, gets only the actual statement that is currently running in the batch or procedure
    @get_full_inner_text BIT = 0,

    --Get associated query plans for running tasks, if available
    --If @get_plans = 1, gets the plan based on the request's statement offset
    --If @get_plans = 2, gets the entire plan based on the request's plan_handle
    @get_plans TINYINT = 0,

    --Get the associated outer ad hoc query or stored procedure call, if available
    @get_outer_command BIT = 0,

    --Enables pulling transaction log write info and transaction duration
    @get_transaction_info BIT = 0,

    --Get information on active tasks, based on three interest levels
    --Level 0 does not pull any task-related information
    --Level 1 is a lightweight mode that pulls the top non-CXPACKET wait, giving preference to blockers
    --Level 2 pulls all available task-based metrics, including: 
    --number of active tasks, current wait stats, physical I/O, context switches, and blocker information
    @get_task_info TINYINT = 1,

    --Gets associated locks for each request, aggregated in an XML format
    @get_locks BIT = 0,

    --Get average time for past runs of an active query
    --(based on the combination of plan handle, sql handle, and offset)
    @get_avg_time BIT = 0,

    --Get additional non-performance-related information about the session or request
    --text_size, language, date_format, date_first, quoted_identifier, arithabort, ansi_null_dflt_on, 
    --ansi_defaults, ansi_warnings, ansi_padding, ansi_nulls, concat_null_yields_null, 
    --transaction_isolation_level, lock_timeout, deadlock_priority, row_count, command_type
    --
    --If a SQL Agent job is running, an subnode called agent_info will be populated with some or all of
    --the following: job_id, job_name, step_id, step_name, msdb_query_error (in the event of an error)
    --
    --If @get_task_info is set to 2 and a lock wait is detected, a subnode called block_info will be
    --populated with some or all of the following: lock_type, database_name, object_id, file_id, hobt_id, 
    --applock_hash, metadata_resource, metadata_class_id, object_name, schema_name
    @get_additional_info BIT = 0,

    --Walk the blocking chain and count the number of 
    --total SPIDs blocked all the way down by a given session
    --Also enables task_info Level 1, if @get_task_info is set to 0
    @find_block_leaders BIT = 0,

    --Pull deltas on various metrics
    --Interval in seconds to wait before doing the second data pull
    @delta_interval TINYINT = 0,

    --List of desired output columns, in desired order
    --Note that the final output will be the intersection of all enabled features and all 
    --columns in the list. Therefore, only columns associated with enabled features will 
    --actually appear in the output. Likewise, removing columns from this list may effectively
    --disable features, even if they are turned on
    --
    --Each element in this list must be one of the valid output column names. Names must be
    --delimited by square brackets. White space, formatting, and additional characters are
    --allowed, as long as the list contains exact matches of delimited valid column names.
    @output_column_list VARCHAR(8000) = '[dd%][session_id][sql_text][sql_command][login_name][wait_info][tasks][tran_log%][cpu%][temp%][block%][reads%][writes%][context%][physical%][query_plan][locks][%]',

    --Column(s) by which to sort output, optionally with sort directions. 
        --Valid column choices:
        --session_id, physical_io, reads, physical_reads, writes, tempdb_allocations, 
        --tempdb_current, CPU, context_switches, used_memory, physical_io_delta, reads_delta, 
        --physical_reads_delta, writes_delta, tempdb_allocations_delta, tempdb_current_delta, 
        --CPU_delta, context_switches_delta, used_memory_delta, tasks, tran_start_time, 
        --open_tran_count, blocking_session_id, blocked_session_count, percent_complete, 
        --host_name, login_name, database_name, start_time, login_time, program_name
        --
        --Note that column names in the list must be bracket-delimited. Commas and/or white
        --space are not required. 
    @sort_order VARCHAR(500) = '[start_time] ASC',

    --Formats some of the output columns in a more "human readable" form
    --0 disables outfput format
    --1 formats the output for variable-width fonts
    --2 formats the output for fixed-width fonts
    @format_output TINYINT = 1,

    --If set to a non-blank value, the script will attempt to insert into the specified 
    --destination table. Please note that the script will not verify that the table exists, 
    --or that it has the correct schema, before doing the insert.
    --Table can be specified in one, two, or three-part format
    @destination_table VARCHAR(4000) = '',

    --If set to 1, no data collection will happen and no result set will be returned; instead,
    --a CREATE TABLE statement will be returned via the @schema parameter, which will match 
    --the schema of the result set that would be returned by using the same collection of the
    --rest of the parameters. The CREATE TABLE statement will have a placeholder token of 
    --<table_name> in place of an actual table name.
    @return_schema BIT = 0,
    @schema VARCHAR(MAX) = NULL OUTPUT,

    --Help! What do I do?
    @help BIT = 0
--~
)
/*
OUTPUT COLUMNS
--------------
Formatted/Non:  [session_id] [smallint] NOT NULL
    Session ID (a.k.a. SPID)

Formatted:      [dd hh:mm:ss.mss] [varchar](15) NULL
Non-Formatted:  <not returned>
    For an active request, time the query has been running
    For a sleeping session, time since the last batch completed

Formatted:      [dd hh:mm:ss.mss (avg)] [varchar](15) NULL
Non-Formatted:  [avg_elapsed_time] [int] NULL
    (Requires @get_avg_time option)
    How much time has the active portion of the query taken in the past, on average?

Formatted:      [physical_io] [varchar](30) NULL
Non-Formatted:  [physical_io] [bigint] NULL
    Shows the number of physical I/Os, for active requests

Formatted:      [reads] [varchar](30) NULL
Non-Formatted:  [reads] [bigint] NULL
    For an active request, number of reads done for the current query
    For a sleeping session, total number of reads done over the lifetime of the session

Formatted:      [physical_reads] [varchar](30) NULL
Non-Formatted:  [physical_reads] [bigint] NULL
    For an active request, number of physical reads done for the current query
    For a sleeping session, total number of physical reads done over the lifetime of the session

Formatted:      [writes] [varchar](30) NULL
Non-Formatted:  [writes] [bigint] NULL
    For an active request, number of writes done for the current query
    For a sleeping session, total number of writes done over the lifetime of the session

Formatted:      [tempdb_allocations] [varchar](30) NULL
Non-Formatted:  [tempdb_allocations] [bigint] NULL
    For an active request, number of TempDB writes done for the current query
    For a sleeping session, total number of TempDB writes done over the lifetime of the session

Formatted:      [tempdb_current] [varchar](30) NULL
Non-Formatted:  [tempdb_current] [bigint] NULL
    For an active request, number of TempDB pages currently allocated for the query
    For a sleeping session, number of TempDB pages currently allocated for the session

Formatted:      [CPU] [varchar](30) NULL
Non-Formatted:  [CPU] [int] NULL
    For an active request, total CPU time consumed by the current query
    For a sleeping session, total CPU time consumed over the lifetime of the session

Formatted:      [context_switches] [varchar](30) NULL
Non-Formatted:  [context_switches] [bigint] NULL
    Shows the number of context switches, for active requests

Formatted:      [used_memory] [varchar](30) NOT NULL
Non-Formatted:  [used_memory] [bigint] NOT NULL
    For an active request, total memory consumption for the current query
    For a sleeping session, total current memory consumption

Formatted:      [physical_io_delta] [varchar](30) NULL
Non-Formatted:  [physical_io_delta] [bigint] NULL
    (Requires @delta_interval option)
    Difference between the number of physical I/Os reported on the first and second collections. 
    If the request started after the first collection, the value will be NULL

Formatted:      [reads_delta] [varchar](30) NULL
Non-Formatted:  [reads_delta] [bigint] NULL
    (Requires @delta_interval option)
    Difference between the number of reads reported on the first and second collections. 
    If the request started after the first collection, the value will be NULL

Formatted:      [physical_reads_delta] [varchar](30) NULL
Non-Formatted:  [physical_reads_delta] [bigint] NULL
    (Requires @delta_interval option)
    Difference between the number of physical reads reported on the first and second collections. 
    If the request started after the first collection, the value will be NULL

Formatted:      [writes_delta] [varchar](30) NULL
Non-Formatted:  [writes_delta] [bigint] NULL
    (Requires @delta_interval option)
    Difference between the number of writes reported on the first and second collections. 
    If the request started after the first collection, the value will be NULL

Formatted:      [tempdb_allocations_delta] [varchar](30) NULL
Non-Formatted:  [tempdb_allocations_delta] [bigint] NULL
    (Requires @delta_interval option)
    Difference between the number of TempDB writes reported on the first and second collections. 
    If the request started after the first collection, the value will be NULL

Formatted:      [tempdb_current_delta] [varchar](30) NULL
Non-Formatted:  [tempdb_current_delta] [bigint] NULL
    (Requires @delta_interval option)
    Difference between the number of allocated TempDB pages reported on the first and second 
    collections. If the request started after the first collection, the value will be NULL

Formatted:      [CPU_delta] [varchar](30) NULL
Non-Formatted:  [CPU_delta] [int] NULL
    (Requires @delta_interval option)
    Difference between the CPU time reported on the first and second collections. 
    If the request started after the first collection, the value will be NULL

Formatted:      [context_switches_delta] [varchar](30) NULL
Non-Formatted:  [context_switches_delta] [bigint] NULL
    (Requires @delta_interval option)
    Difference between the context switches count reported on the first and second collections
    If the request started after the first collection, the value will be NULL

Formatted:      [used_memory_delta] [varchar](30) NULL
Non-Formatted:  [used_memory_delta] [bigint] NULL
    Difference between the memory usage reported on the first and second collections
    If the request started after the first collection, the value will be NULL

Formatted:      [tasks] [varchar](30) NULL
Non-Formatted:  [tasks] [smallint] NULL
    Number of worker tasks currently allocated, for active requests

Formatted/Non:  [status] [varchar](30) NOT NULL
    Activity status for the session (running, sleeping, etc)

Formatted/Non:  [wait_info] [nvarchar](4000) NULL
    Aggregates wait information, in the following format:
        (Ax: Bms/Cms/Dms)E
    A is the number of waiting tasks currently waiting on resource type E. B/C/D are wait
    times, in milliseconds. If only one thread is waiting, its wait time will be shown as B.
    If two tasks are waiting, each of their wait times will be shown (B/C). If three or more 
    tasks are waiting, the minimum, average, and maximum wait times will be shown (B/C/D).
    If wait type E is a page latch wait and the page is of a "special" type (e.g. PFS, GAM, SGAM), 
    the page type will be identified.
    If wait type E is CXPACKET, the nodeId from the query plan will be identified

Formatted/Non:  [locks] [xml] NULL
    (Requires @get_locks option)
    Aggregates lock information, in XML format.
    The lock XML includes the lock mode, locked object, and aggregates the number of requests. 
    Attempts are made to identify locked objects by name

Formatted/Non:  [tran_start_time] [datetime] NULL
    (Requires @get_transaction_info option)
    Date and time that the first transaction opened by a session caused a transaction log 
    write to occur.

Formatted/Non:  [tran_log_writes] [nvarchar](4000) NULL
    (Requires @get_transaction_info option)
    Aggregates transaction log write information, in the following format:
    A:wB (C kB)
    A is a database that has been touched by an active transaction
    B is the number of log writes that have been made in the database as a result of the transaction
    C is the number of log kilobytes consumed by the log records

Formatted:      [open_tran_count] [varchar](30) NULL
Non-Formatted:  [open_tran_count] [smallint] NULL
    Shows the number of open transactions the session has open

Formatted:      [sql_command] [xml] NULL
Non-Formatted:  [sql_command] [nvarchar](max) NULL
    (Requires @get_outer_command option)
    Shows the "outer" SQL command, i.e. the text of the batch or RPC sent to the server, 
    if available

Formatted:      [sql_text] [xml] NULL
Non-Formatted:  [sql_text] [nvarchar](max) NULL
    Shows the SQL text for active requests or the last statement executed
    for sleeping sessions, if available in either case.
    If @get_full_inner_text option is set, shows the full text of the batch.
    Otherwise, shows only the active statement within the batch.
    If the query text is locked, a special timeout message will be sent, in the following format:
        <timeout_exceeded />
    If an error occurs, an error message will be sent, in the following format:
        <error message="message" />

Formatted/Non:  [query_plan] [xml] NULL
    (Requires @get_plans option)
    Shows the query plan for the request, if available.
    If the plan is locked, a special timeout message will be sent, in the following format:
        <timeout_exceeded />
    If an error occurs, an error message will be sent, in the following format:
        <error message="message" />

Formatted/Non:  [blocking_session_id] [smallint] NULL
    When applicable, shows the blocking SPID

Formatted:      [blocked_session_count] [varchar](30) NULL
Non-Formatted:  [blocked_session_count] [smallint] NULL
    (Requires @find_block_leaders option)
    The total number of SPIDs blocked by this session,
    all the way down the blocking chain.

Formatted:      [percent_complete] [varchar](30) NULL
Non-Formatted:  [percent_complete] [real] NULL
    When applicable, shows the percent complete (e.g. for backups, restores, and some rollbacks)

Formatted/Non:  [host_name] [sysname] NOT NULL
    Shows the host name for the connection

Formatted/Non:  [login_name] [sysname] NOT NULL
    Shows the login name for the connection

Formatted/Non:  [database_name] [sysname] NULL
    Shows the connected database

Formatted/Non:  [program_name] [sysname] NULL
    Shows the reported program/application name

Formatted/Non:  [additional_info] [xml] NULL
    (Requires @get_additional_info option)
    Returns additional non-performance-related session/request information
    If the script finds a SQL Agent job running, the name of the job and job step will be reported
    If @get_task_info = 2 and the script finds a lock wait, the locked object will be reported

Formatted/Non:  [start_time] [datetime] NOT NULL
    For active requests, shows the time the request started
    For sleeping sessions, shows the time the last batch completed

Formatted/Non:  [login_time] [datetime] NOT NULL
    Shows the time that the session connected

Formatted/Non:  [request_id] [int] NULL
    For active requests, shows the request_id
    Should be 0 unless MARS is being used

Formatted/Non:  [collection_time] [datetime] NOT NULL
    Time that this script's final SELECT ran
*/
AS
BEGIN;
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET QUOTED_IDENTIFIER ON;
    SET ANSI_PADDING ON;
    SET CONCAT_NULL_YIELDS_NULL ON;
    SET ANSI_WARNINGS ON;
    SET NUMERIC_ROUNDABORT OFF;
    SET ARITHABORT ON;

    IF
        @filter IS NULL
        OR @filter_type IS NULL
        OR @not_filter IS NULL
        OR @not_filter_type IS NULL
        OR @show_own_spid IS NULL
        OR @show_system_spids IS NULL
        OR @show_sleeping_spids IS NULL
        OR @get_full_inner_text IS NULL
        OR @get_plans IS NULL
        OR @get_outer_command IS NULL
        OR @get_transaction_info IS NULL
        OR @get_task_info IS NULL
        OR @get_locks IS NULL
        OR @get_avg_time IS NULL
        OR @get_additional_info IS NULL
        OR @find_block_leaders IS NULL
        OR @delta_interval IS NULL
        OR @format_output IS NULL
        OR @output_column_list IS NULL
        OR @sort_order IS NULL
        OR @return_schema IS NULL
        OR @destination_table IS NULL
        OR @help IS NULL
    BEGIN;
        RAISERROR('Input parameters cannot be NULL', 16, 1);
        RETURN;
    END;
    
    IF @filter_type NOT IN ('session', 'program', 'database', 'login', 'host')
    BEGIN;
        RAISERROR('Valid filter types are: session, program, database, login, host', 16, 1);
        RETURN;
    END;
    
    IF @filter_type = 'session' AND @filter LIKE '%[^0123456789]%'
    BEGIN;
        RAISERROR('Session filters must be valid integers', 16, 1);
        RETURN;
    END;
    
    IF @not_filter_type NOT IN ('session', 'program', 'database', 'login', 'host')
    BEGIN;
        RAISERROR('Valid filter types are: session, program, database, login, host', 16, 1);
        RETURN;
    END;
    
    IF @not_filter_type = 'session' AND @not_filter LIKE '%[^0123456789]%'
    BEGIN;
        RAISERROR('Session filters must be valid integers', 16, 1);
        RETURN;
    END;
    
    IF @show_sleeping_spids NOT IN (0, 1, 2)
    BEGIN;
        RAISERROR('Valid values for @show_sleeping_spids are: 0, 1, or 2', 16, 1);
        RETURN;
    END;
    
    IF @get_plans NOT IN (0, 1, 2)
    BEGIN;
        RAISERROR('Valid values for @get_plans are: 0, 1, or 2', 16, 1);
        RETURN;
    END;

    IF @get_task_info NOT IN (0, 1, 2)
    BEGIN;
        RAISERROR('Valid values for @get_task_info are: 0, 1, or 2', 16, 1);
        RETURN;
    END;

    IF @format_output NOT IN (0, 1, 2)
    BEGIN;
        RAISERROR('Valid values for @format_output are: 0, 1, or 2', 16, 1);
        RETURN;
    END;
    
    IF @help = 1
    BEGIN;
        DECLARE 
            @header VARCHAR(MAX),
            @params VARCHAR(MAX),
            @outputs VARCHAR(MAX);

        SELECT 
            @header =
                REPLACE
                (
                    REPLACE
                    (
                        CONVERT
                        (
                            VARCHAR(MAX),
                            SUBSTRING
                            (
                                t.text, 
                                CHARINDEX('/' + REPLICATE('*', 93), t.text) + 94,
                                CHARINDEX(REPLICATE('*', 93) + '/', t.text) - (CHARINDEX('/' + REPLICATE('*', 93), t.text) + 94)
                            )
                        ),
                        CHAR(13)+CHAR(10),
                        CHAR(13)
                    ),
                    '   ',
                    ''
                ),
            @params =
                CHAR(13) +
                    REPLACE
                    (
                        REPLACE
                        (
                            CONVERT
                            (
                                VARCHAR(MAX),
                                SUBSTRING
                                (
                                    t.text, 
                                    CHARINDEX('--~', t.text) + 5, 
                                    CHARINDEX('--~', t.text, CHARINDEX('--~', t.text) + 5) - (CHARINDEX('--~', t.text) + 5)
                                )
                            ),
                            CHAR(13)+CHAR(10),
                            CHAR(13)
                        ),
                        '   ',
                        ''
                    ),
                @outputs = 
                    CHAR(13) +
                        REPLACE
                        (
                            REPLACE
                            (
                                REPLACE
                                (
                                    CONVERT
                                    (
                                        VARCHAR(MAX),
                                        SUBSTRING
                                        (
                                            t.text, 
                                            CHARINDEX('OUTPUT COLUMNS'+CHAR(13)+CHAR(10)+'--------------', t.text) + 32,
                                            CHARINDEX('*/', t.text, CHARINDEX('OUTPUT COLUMNS'+CHAR(13)+CHAR(10)+'--------------', t.text) + 32) - (CHARINDEX('OUTPUT COLUMNS'+CHAR(13)+CHAR(10)+'--------------', t.text) + 32)
                                        )
                                    ),
                                    CHAR(9),
                                    CHAR(255)
                                ),
                                CHAR(13)+CHAR(10),
                                CHAR(13)
                            ),
                            '   ',
                            ''
                        ) +
                        CHAR(13)
        FROM sys.dm_exec_requests AS r
        CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
        WHERE
            r.session_id = @@SPID;

        WITH
        a0 AS
        (SELECT 1 AS n UNION ALL SELECT 1),
        a1 AS
        (SELECT 1 AS n FROM a0 AS a, a0 AS b),
        a2 AS
        (SELECT 1 AS n FROM a1 AS a, a1 AS b),
        a3 AS
        (SELECT 1 AS n FROM a2 AS a, a2 AS b),
        a4 AS
        (SELECT 1 AS n FROM a3 AS a, a3 AS b),
        numbers AS
        (
            SELECT TOP(LEN(@header) - 1)
                ROW_NUMBER() OVER
                (
                    ORDER BY (SELECT NULL)
                ) AS number
            FROM a4
            ORDER BY
                number
        )
        SELECT
            RTRIM(LTRIM(
                SUBSTRING
                (
                    @header,
                    number + 1,
                    CHARINDEX(CHAR(13), @header, number + 1) - number - 1
                )
            )) AS [------header---------------------------------------------------------------------------------------------------------------]
        FROM numbers
        WHERE
            SUBSTRING(@header, number, 1) = CHAR(13);

        WITH
        a0 AS
        (SELECT 1 AS n UNION ALL SELECT 1),
        a1 AS
        (SELECT 1 AS n FROM a0 AS a, a0 AS b),
        a2 AS
        (SELECT 1 AS n FROM a1 AS a, a1 AS b),
        a3 AS
        (SELECT 1 AS n FROM a2 AS a, a2 AS b),
        a4 AS
        (SELECT 1 AS n FROM a3 AS a, a3 AS b),
        numbers AS
        (
            SELECT TOP(LEN(@params) - 1)
                ROW_NUMBER() OVER
                (
                    ORDER BY (SELECT NULL)
                ) AS number
            FROM a4
            ORDER BY
                number
        ),
        tokens AS
        (
            SELECT 
                RTRIM(LTRIM(
                    SUBSTRING
                    (
                        @params,
                        number + 1,
                        CHARINDEX(CHAR(13), @params, number + 1) - number - 1
                    )
                )) AS token,
                number,
                CASE
                    WHEN SUBSTRING(@params, number + 1, 1) = CHAR(13) THEN number
                    ELSE COALESCE(NULLIF(CHARINDEX(',' + CHAR(13) + CHAR(13), @params, number), 0), LEN(@params)) 
                END AS param_group,
                ROW_NUMBER() OVER
                (
                    PARTITION BY
                        CHARINDEX(',' + CHAR(13) + CHAR(13), @params, number),
                        SUBSTRING(@params, number+1, 1)
                    ORDER BY 
                        number
                ) AS group_order
            FROM numbers
            WHERE
                SUBSTRING(@params, number, 1) = CHAR(13)
        ),
        parsed_tokens AS
        (
            SELECT
                MIN
                (
                    CASE
                        WHEN token LIKE '@%' THEN token
                        ELSE NULL
                    END
                ) AS parameter,
                MIN
                (
                    CASE
                        WHEN token LIKE '--%' THEN RIGHT(token, LEN(token) - 2)
                        ELSE NULL
                    END
                ) AS description,
                param_group,
                group_order
            FROM tokens
            WHERE
                NOT 
                (
                    token = '' 
                    AND group_order > 1
                )
            GROUP BY
                param_group,
                group_order
        )
        SELECT
            CASE
                WHEN description IS NULL AND parameter IS NULL THEN '-------------------------------------------------------------------------'
                WHEN param_group = MAX(param_group) OVER() THEN parameter
                ELSE COALESCE(LEFT(parameter, LEN(parameter) - 1), '')
            END AS [------parameter----------------------------------------------------------],
            CASE
                WHEN description IS NULL AND parameter IS NULL THEN '----------------------------------------------------------------------------------------------------------------------'
                ELSE COALESCE(description, '')
            END AS [------description-----------------------------------------------------------------------------------------------------]
        FROM parsed_tokens
        ORDER BY
            param_group, 
            group_order;
        
        WITH
        a0 AS
        (SELECT 1 AS n UNION ALL SELECT 1),
        a1 AS
        (SELECT 1 AS n FROM a0 AS a, a0 AS b),
        a2 AS
        (SELECT 1 AS n FROM a1 AS a, a1 AS b),
        a3 AS
        (SELECT 1 AS n FROM a2 AS a, a2 AS b),
        a4 AS
        (SELECT 1 AS n FROM a3 AS a, a3 AS b),
        numbers AS
        (
            SELECT TOP(LEN(@outputs) - 1)
                ROW_NUMBER() OVER
                (
                    ORDER BY (SELECT NULL)
                ) AS number
            FROM a4
            ORDER BY
                number
        ),
        tokens AS
        (
            SELECT 
                RTRIM(LTRIM(
                    SUBSTRING
                    (
                        @outputs,
                        number + 1,
                        CASE
                            WHEN 
                                COALESCE(NULLIF(CHARINDEX(CHAR(13) + 'Formatted', @outputs, number + 1), 0), LEN(@outputs)) < 
                                COALESCE(NULLIF(CHARINDEX(CHAR(13) + CHAR(255) COLLATE Latin1_General_Bin2, @outputs, number + 1), 0), LEN(@outputs))
                                THEN COALESCE(NULLIF(CHARINDEX(CHAR(13) + 'Formatted', @outputs, number + 1), 0), LEN(@outputs)) - number - 1
                            ELSE
                                COALESCE(NULLIF(CHARINDEX(CHAR(13) + CHAR(255) COLLATE Latin1_General_Bin2, @outputs, number + 1), 0), LEN(@outputs)) - number - 1
                        END
                    )
                )) AS token,
                number,
                COALESCE(NULLIF(CHARINDEX(CHAR(13) + 'Formatted', @outputs, number + 1), 0), LEN(@outputs)) AS output_group,
                ROW_NUMBER() OVER
                (
                    PARTITION BY 
                        COALESCE(NULLIF(CHARINDEX(CHAR(13) + 'Formatted', @outputs, number + 1), 0), LEN(@outputs))
                    ORDER BY
                        number
                ) AS output_group_order
            FROM numbers
            WHERE
                SUBSTRING(@outputs, number, 10) = CHAR(13) + 'Formatted'
                OR SUBSTRING(@outputs, number, 2) = CHAR(13) + CHAR(255) COLLATE Latin1_General_Bin2
        ),
        output_tokens AS
        (
            SELECT 
                *,
                CASE output_group_order
                    WHEN 2 THEN MAX(CASE output_group_order WHEN 1 THEN token ELSE NULL END) OVER (PARTITION BY output_group)
                    ELSE ''
                END COLLATE Latin1_General_Bin2 AS column_info
            FROM tokens
        )
        SELECT
            CASE output_group_order
                WHEN 1 THEN '-----------------------------------'
                WHEN 2 THEN 
                    CASE
                        WHEN CHARINDEX('Formatted/Non:', column_info) = 1 THEN
                            SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)+1, CHARINDEX(']', column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)+2) - CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info))
                        ELSE
                            SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)+2, CHARINDEX(']', column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)+2) - CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info)-1)
                    END
                ELSE ''
            END AS formatted_column_name,
            CASE output_group_order
                WHEN 1 THEN '-----------------------------------'
                WHEN 2 THEN 
                    CASE
                        WHEN CHARINDEX('Formatted/Non:', column_info) = 1 THEN
                            SUBSTRING(column_info, CHARINDEX(']', column_info)+2, LEN(column_info))
                        ELSE
                            SUBSTRING(column_info, CHARINDEX(']', column_info)+2, CHARINDEX('Non-Formatted:', column_info, CHARINDEX(']', column_info)+2) - CHARINDEX(']', column_info)-3)
                    END
                ELSE ''
            END AS formatted_column_type,
            CASE output_group_order
                WHEN 1 THEN '---------------------------------------'
                WHEN 2 THEN 
                    CASE
                        WHEN CHARINDEX('Formatted/Non:', column_info) = 1 THEN ''
                        ELSE
                            CASE
                                WHEN SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1, 1) = '<' THEN
                                    SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1, CHARINDEX('>', column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1) - CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info)))
                                ELSE
                                    SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1, CHARINDEX(']', column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1) - CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info)))
                            END
                    END
                ELSE ''
            END AS unformatted_column_name,
            CASE output_group_order
                WHEN 1 THEN '---------------------------------------'
                WHEN 2 THEN 
                    CASE
                        WHEN CHARINDEX('Formatted/Non:', column_info) = 1 THEN ''
                        ELSE
                            CASE
                                WHEN SUBSTRING(column_info, CHARINDEX(CHAR(255) COLLATE Latin1_General_Bin2, column_info, CHARINDEX('Non-Formatted:', column_info))+1, 1) = '<' THEN ''
                                ELSE
                                    SUBSTRING(column_info, CHARINDEX(']', column_info, CHARINDEX('Non-Formatted:', column_info))+2, CHARINDEX('Non-Formatted:', column_info, CHARINDEX(']', column_info)+2) - CHARINDEX(']', column_info)-3)
                            END
                    END
                ELSE ''
            END AS unformatted_column_type,
            CASE output_group_order
                WHEN 1 THEN '----------------------------------------------------------------------------------------------------------------------'
                ELSE REPLACE(token, CHAR(255) COLLATE Latin1_General_Bin2, '')
            END AS [------description-----------------------------------------------------------------------------------------------------]
        FROM output_tokens
        WHERE
            NOT 
            (
                output_group_order = 1 
                AND output_group = LEN(@outputs)
            )
        ORDER BY
            output_group,
            CASE output_group_order
                WHEN 1 THEN 99
                ELSE output_group_order
            END;

        RETURN;
    END;

    WITH
    a0 AS
    (SELECT 1 AS n UNION ALL SELECT 1),
    a1 AS
    (SELECT 1 AS n FROM a0 AS a, a0 AS b),
    a2 AS
    (SELECT 1 AS n FROM a1 AS a, a1 AS b),
    a3 AS
    (SELECT 1 AS n FROM a2 AS a, a2 AS b),
    a4 AS
    (SELECT 1 AS n FROM a3 AS a, a3 AS b),
    numbers AS
    (
        SELECT TOP(LEN(@output_column_list))
            ROW_NUMBER() OVER
            (
                ORDER BY (SELECT NULL)
            ) AS number
        FROM a4
        ORDER BY
            number
    ),
    tokens AS
    (
        SELECT 
            '|[' +
                SUBSTRING
                (
                    @output_column_list,
                    number + 1,
                    CHARINDEX(']', @output_column_list, number) - number - 1
                ) + '|]' AS token,
            number
        FROM numbers
        WHERE
            SUBSTRING(@output_column_list, number, 1) = '['
    ),
    ordered_columns AS
    (
        SELECT
            x.column_name,
            ROW_NUMBER() OVER
            (
                PARTITION BY
                    x.column_name
                ORDER BY
                    tokens.number,
                    x.default_order
            ) AS r,
            ROW_NUMBER() OVER
            (
                ORDER BY
                    tokens.number,
                    x.default_order
            ) AS s
        FROM tokens
        JOIN
        (
            SELECT '[session_id]' AS column_name, 1 AS default_order
            UNION ALL
            SELECT '[dd hh:mm:ss.mss]', 2
            WHERE
                @format_output IN (1, 2)
            UNION ALL
            SELECT '[dd hh:mm:ss.mss (avg)]', 3
            WHERE
                @format_output IN (1, 2)
                AND @get_avg_time = 1
            UNION ALL
            SELECT '[avg_elapsed_time]', 4
            WHERE
                @format_output = 0
                AND @get_avg_time = 1
            UNION ALL
            SELECT '[physical_io]', 5
            WHERE
                @get_task_info = 2
            UNION ALL
            SELECT '[reads]', 6
            UNION ALL
            SELECT '[physical_reads]', 7
            UNION ALL
            SELECT '[writes]', 8
            UNION ALL
            SELECT '[tempdb_allocations]', 9
            UNION ALL
            SELECT '[tempdb_current]', 10
            UNION ALL
            SELECT '[CPU]', 11
            UNION ALL
            SELECT '[context_switches]', 12
            WHERE
                @get_task_info = 2
            UNION ALL
            SELECT '[used_memory]', 13
            UNION ALL
            SELECT '[physical_io_delta]', 14
            WHERE
                @delta_interval > 0 
                AND @get_task_info = 2
            UNION ALL
            SELECT '[reads_delta]', 15
            WHERE
                @delta_interval > 0
            UNION ALL
            SELECT '[physical_reads_delta]', 16
            WHERE
                @delta_interval > 0
            UNION ALL
            SELECT '[writes_delta]', 17
            WHERE
                @delta_interval > 0
            UNION ALL
            SELECT '[tempdb_allocations_delta]', 18
            WHERE
                @delta_interval > 0
            UNION ALL
            SELECT '[tempdb_current_delta]', 19
            WHERE
                @delta_interval > 0
            UNION ALL
            SELECT '[CPU_delta]', 20
            WHERE
                @delta_interval > 0
            UNION ALL
            SELECT '[context_switches_delta]', 21
            WHERE
                @delta_interval > 0
                AND @get_task_info = 2
            UNION ALL
            SELECT '[used_memory_delta]', 22
            WHERE
                @delta_interval > 0
            UNION ALL
            SELECT '[tasks]', 23
            WHERE
                @get_task_info = 2
            UNION ALL
            SELECT '[status]', 24
            UNION ALL
            SELECT '[wait_info]', 25
            WHERE
                @get_task_info > 0
                OR @find_block_leaders = 1
            UNION ALL
            SELECT '[locks]', 26
            WHERE
                @get_locks = 1
            UNION ALL
            SELECT '[tran_start_time]', 27
            WHERE
                @get_transaction_info = 1
            UNION ALL
            SELECT '[tran_log_writes]', 28
            WHERE
                @get_transaction_info = 1
            UNION ALL
            SELECT '[open_tran_count]', 29
            UNION ALL
            SELECT '[sql_command]', 30
            WHERE
                @get_outer_command = 1
            UNION ALL
            SELECT '[sql_text]', 31
            UNION ALL
            SELECT '[query_plan]', 32
            WHERE
                @get_plans >= 1
            UNION ALL
            SELECT '[blocking_session_id]', 33
            WHERE
                @get_task_info > 0
                OR @find_block_leaders = 1
            UNION ALL
            SELECT '[blocked_session_count]', 34
            WHERE
                @find_block_leaders = 1
            UNION ALL
            SELECT '[percent_complete]', 35
            UNION ALL
            SELECT '[host_name]', 36
            UNION ALL
            SELECT '[login_name]', 37
            UNION ALL
            SELECT '[database_name]', 38
            UNION ALL
            SELECT '[program_name]', 39
            UNION ALL
            SELECT '[additional_info]', 40
            WHERE
                @get_additional_info = 1
            UNION ALL
            SELECT '[start_time]', 41
            UNION ALL
            SELECT '[login_time]', 42
            UNION ALL
            SELECT '[request_id]', 43
            UNION ALL
            SELECT '[collection_time]', 44
        ) AS x ON 
            x.column_name LIKE token ESCAPE '|'
    )
    SELECT
        @output_column_list =
            STUFF
            (
                (
                    SELECT
                        ',' + column_name as [text()]
                    FROM ordered_columns
                    WHERE
                        r = 1
                    ORDER BY
                        s
                    FOR XML
                        PATH('')
                ),
                1,
                1,
                ''
            );
    
    IF COALESCE(RTRIM(@output_column_list), '') = ''
    BEGIN;
        RAISERROR('No valid column matches found in @output_column_list or no columns remain due to selected options.', 16, 1);
        RETURN;
    END;
    
    IF @destination_table <> ''
    BEGIN;
        SET @destination_table = 
            --database
            COALESCE(QUOTENAME(PARSENAME(@destination_table, 3)) + '.', '') +
            --schema
            COALESCE(QUOTENAME(PARSENAME(@destination_table, 2)) + '.', '') +
            --table
            COALESCE(QUOTENAME(PARSENAME(@destination_table, 1)), '');
            
        IF COALESCE(RTRIM(@destination_table), '') = ''
        BEGIN;
            RAISERROR('Destination table not properly formatted.', 16, 1);
            RETURN;
        END;
    END;

    WITH
    a0 AS
    (SELECT 1 AS n UNION ALL SELECT 1),
    a1 AS
    (SELECT 1 AS n FROM a0 AS a, a0 AS b),
    a2 AS
    (SELECT 1 AS n FROM a1 AS a, a1 AS b),
    a3 AS
    (SELECT 1 AS n FROM a2 AS a, a2 AS b),
    a4 AS
    (SELECT 1 AS n FROM a3 AS a, a3 AS b),
    numbers AS
    (
        SELECT TOP(LEN(@sort_order))
            ROW_NUMBER() OVER
            (
                ORDER BY (SELECT NULL)
            ) AS number
        FROM a4
        ORDER BY
            number
    ),
    tokens AS
    (
        SELECT 
            '|[' +
                SUBSTRING
                (
                    @sort_order,
                    number + 1,
                    CHARINDEX(']', @sort_order, number) - number - 1
                ) + '|]' AS token,
            SUBSTRING
            (
                @sort_order,
                CHARINDEX(']', @sort_order, number) + 1,
                COALESCE(NULLIF(CHARINDEX('[', @sort_order, CHARINDEX(']', @sort_order, number)), 0), LEN(@sort_order)) - CHARINDEX(']', @sort_order, number)
            ) AS next_chunk,
            number
        FROM numbers
        WHERE
            SUBSTRING(@sort_order, number, 1) = '['
    ),
    ordered_columns AS
    (
        SELECT
            x.column_name +
                CASE
                    WHEN tokens.next_chunk LIKE '%asc%' THEN ' ASC'
                    WHEN tokens.next_chunk LIKE '%desc%' THEN ' DESC'
                    ELSE ''
                END AS column_name,
            ROW_NUMBER() OVER
            (
                PARTITION BY
                    x.column_name
                ORDER BY
                    tokens.number
            ) AS r,
            tokens.number
        FROM tokens
        JOIN
        (
            SELECT '[session_id]' AS column_name
            UNION ALL
            SELECT '[physical_io]'
            UNION ALL
            SELECT '[reads]'
            UNION ALL
            SELECT '[physical_reads]'
            UNION ALL
            SELECT '[writes]'
            UNION ALL
            SELECT '[tempdb_allocations]'
            UNION ALL
            SELECT '[tempdb_current]'
            UNION ALL
            SELECT '[CPU]'
            UNION ALL
            SELECT '[context_switches]'
            UNION ALL
            SELECT '[used_memory]'
            UNION ALL
            SELECT '[physical_io_delta]'
            UNION ALL
            SELECT '[reads_delta]'
            UNION ALL
            SELECT '[physical_reads_delta]'
            UNION ALL
            SELECT '[writes_delta]'
            UNION ALL
            SELECT '[tempdb_allocations_delta]'
            UNION ALL
            SELECT '[tempdb_current_delta]'
            UNION ALL
            SELECT '[CPU_delta]'
            UNION ALL
            SELECT '[context_switches_delta]'
            UNION ALL
            SELECT '[used_memory_delta]'
            UNION ALL
            SELECT '[tasks]'
            UNION ALL
            SELECT '[tran_start_time]'
            UNION ALL
            SELECT '[open_tran_count]'
            UNION ALL
            SELECT '[blocking_session_id]'
            UNION ALL
            SELECT '[blocked_session_count]'
            UNION ALL
            SELECT '[percent_complete]'
            UNION ALL
            SELECT '[host_name]'
            UNION ALL
            SELECT '[login_name]'
            UNION ALL
            SELECT '[database_name]'
            UNION ALL
            SELECT '[start_time]'
            UNION ALL
            SELECT '[login_time]'
            UNION ALL
            SELECT '[program_name]'
        ) AS x ON 
            x.column_name LIKE token ESCAPE '|'
    )
    SELECT
        @sort_order = COALESCE(z.sort_order, '')
    FROM
    (
        SELECT
            STUFF
            (
                (
                    SELECT
                        ',' + column_name as [text()]
                    FROM ordered_columns
                    WHERE
                        r = 1
                    ORDER BY
                        number
                    FOR XML
                        PATH('')
                ),
                1,
                1,
                ''
            ) AS sort_order
    ) AS z;

    CREATE TABLE #sessions
    (
        recursion SMALLINT NOT NULL,
        session_id SMALLINT NOT NULL,
        request_id INT NOT NULL,
        session_number INT NOT NULL,
        elapsed_time INT NOT NULL,
        avg_elapsed_time INT NULL,
        physical_io BIGINT NULL,
        reads BIGINT NULL,
        physical_reads BIGINT NULL,
        writes BIGINT NULL,
        tempdb_allocations BIGINT NULL,
        tempdb_current BIGINT NULL,
        CPU INT NULL,
        thread_CPU_snapshot BIGINT NULL,
        context_switches BIGINT NULL,
        used_memory BIGINT NOT NULL, 
        tasks SMALLINT NULL,
        status VARCHAR(30) NOT NULL,
        wait_info NVARCHAR(4000) NULL,
        locks XML NULL,
        transaction_id BIGINT NULL,
        tran_start_time DATETIME NULL,
        tran_log_writes NVARCHAR(4000) NULL,
        open_tran_count SMALLINT NULL,
        sql_command XML NULL,
        sql_handle VARBINARY(64) NULL,
        statement_start_offset INT NULL,
        statement_end_offset INT NULL,
        sql_text XML NULL,
        plan_handle VARBINARY(64) NULL,
        query_plan XML NULL,
        blocking_session_id SMALLINT NULL,
        blocked_session_count SMALLINT NULL,
        percent_complete REAL NULL,
        host_name sysname NULL,
        login_name sysname NOT NULL,
        database_name sysname NULL,
        program_name sysname NULL,
        additional_info XML NULL,
        start_time DATETIME NOT NULL,
        login_time DATETIME NULL,
        last_request_start_time DATETIME NULL,
        PRIMARY KEY CLUSTERED (session_id, request_id, recursion) WITH (IGNORE_DUP_KEY = ON),
        UNIQUE NONCLUSTERED (transaction_id, session_id, request_id, recursion) WITH (IGNORE_DUP_KEY = ON)
    );

    IF @return_schema = 0
    BEGIN;
        --Disable unnecessary autostats on the table
        CREATE STATISTICS s_session_id ON #sessions (session_id)
        WITH SAMPLE 0 ROWS, NORECOMPUTE;
        CREATE STATISTICS s_request_id ON #sessions (request_id)
        WITH SAMPLE 0 ROWS, NORECOMPUTE;
        CREATE STATISTICS s_transaction_id ON #sessions (transaction_id)
        WITH SAMPLE 0 ROWS, NORECOMPUTE;
        CREATE STATISTICS s_session_number ON #sessions (session_number)
        WITH SAMPLE 0 ROWS, NORECOMPUTE;
        CREATE STATISTICS s_status ON #sessions (status)
        WITH SAMPLE 0 ROWS, NORECOMPUTE;
        CREATE STATISTICS s_start_time ON #sessions (start_time)
        WITH SAMPLE 0 ROWS, NORECOMPUTE;
        CREATE STATISTICS s_last_request_start_time ON #sessions (last_request_start_time)
        WITH SAMPLE 0 ROWS, NORECOMPUTE;
        CREATE STATISTICS s_recursion ON #sessions (recursion)
        WITH SAMPLE 0 ROWS, NORECOMPUTE;

        DECLARE @recursion SMALLINT;
        SET @recursion = 
            CASE @delta_interval
                WHEN 0 THEN 1
                ELSE -1
            END;

        DECLARE @first_collection_ms_ticks BIGINT;
        DECLARE @last_collection_start DATETIME;
        DECLARE @sys_info BIT;
        SET @sys_info = ISNULL(CONVERT(BIT, SIGN(OBJECT_ID('sys.dm_os_sys_info'))), 0);

        --Used for the delta pull
        REDO:;
        
        IF 
            @get_locks = 1 
            AND @recursion = 1
            AND @output_column_list LIKE '%|[locks|]%' ESCAPE '|'
        BEGIN;
            SELECT
                y.resource_type,
                y.database_name,
                y.object_id,
                y.file_id,
                y.page_type,
                y.hobt_id,
                y.allocation_unit_id,
                y.index_id,
                y.schema_id,
                y.principal_id,
                y.request_mode,
                y.request_status,
                y.session_id,
                y.resource_description,
                y.request_count,
                s.request_id,
                s.start_time,
                CONVERT(sysname, NULL) AS object_name,
                CONVERT(sysname, NULL) AS index_name,
                CONVERT(sysname, NULL) AS schema_name,
                CONVERT(sysname, NULL) AS principal_name,
                CONVERT(NVARCHAR(2048), NULL) AS query_error
            INTO #locks
            FROM
            (
                SELECT
                    sp.spid AS session_id,
                    CASE sp.status
                        WHEN 'sleeping' THEN CONVERT(INT, 0)
                        ELSE sp.request_id
                    END AS request_id,
                    CASE sp.status
                        WHEN 'sleeping' THEN sp.last_batch
                        ELSE COALESCE(req.start_time, sp.last_batch)
                    END AS start_time,
                    sp.dbid
                FROM sys.sysprocesses AS sp
                OUTER APPLY
                (
                    SELECT TOP(1)
                        CASE
                            WHEN 
                            (
                                sp.hostprocess > ''
                                OR r.total_elapsed_time < 0
                            ) THEN
                                r.start_time
                            ELSE
                                DATEADD
                                (
                                    ms, 
                                    1000 * (DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())) / 500) - DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())), 
                                    DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())
                                )
                        END AS start_time
                    FROM sys.dm_exec_requests AS r
                    WHERE
                        r.session_id = sp.spid
                        AND r.request_id = sp.request_id
                ) AS req
                WHERE
                    --Process inclusive filter
                    1 =
                        CASE
                            WHEN @filter <> '' THEN
                                CASE @filter_type
                                    WHEN 'session' THEN
                                        CASE
                                            WHEN
                                                CONVERT(SMALLINT, @filter) = 0
                                                OR sp.spid = CONVERT(SMALLINT, @filter)
                                                    THEN 1
                                            ELSE 0
                                        END
                                    WHEN 'program' THEN
                                        CASE
                                            WHEN sp.program_name LIKE @filter THEN 1
                                            ELSE 0
                                        END
                                    WHEN 'login' THEN
                                        CASE
                                            WHEN sp.loginame LIKE @filter THEN 1
                                            ELSE 0
                                        END
                                    WHEN 'host' THEN
                                        CASE
                                            WHEN sp.hostname LIKE @filter THEN 1
                                            ELSE 0
                                        END
                                    WHEN 'database' THEN
                                        CASE
                                            WHEN DB_NAME(sp.dbid) LIKE @filter THEN 1
                                            ELSE 0
                                        END
                                    ELSE 0
                                END
                            ELSE 1
                        END
                    --Process exclusive filter
                    AND 0 =
                        CASE
                            WHEN @not_filter <> '' THEN
                                CASE @not_filter_type
                                    WHEN 'session' THEN
                                        CASE
                                            WHEN sp.spid = CONVERT(SMALLINT, @not_filter) THEN 1
                                            ELSE 0
                                        END
                                    WHEN 'program' THEN
                                        CASE
                                            WHEN sp.program_name LIKE @not_filter THEN 1
                                            ELSE 0
                                        END
                                    WHEN 'login' THEN
                                        CASE
                                            WHEN sp.loginame LIKE @not_filter THEN 1
                                            ELSE 0
                                        END
                                    WHEN 'host' THEN
                                        CASE
                                            WHEN sp.hostname LIKE @not_filter THEN 1
                                            ELSE 0
                                        END
                                    WHEN 'database' THEN
                                        CASE
                                            WHEN DB_NAME(sp.dbid) LIKE @not_filter THEN 1
                                            ELSE 0
                                        END
                                    ELSE 0
                                END
                            ELSE 0
                        END
                    AND 
                    (
                        @show_own_spid = 1
                        OR sp.spid <> @@SPID
                    )
                    AND 
                    (
                        @show_system_spids = 1
                        OR sp.hostprocess > ''
                    )
                    AND sp.ecid = 0
            ) AS s
            INNER HASH JOIN
            (
                SELECT
                    x.resource_type,
                    x.database_name,
                    x.object_id,
                    x.file_id,
                    CASE
                        WHEN x.page_no = 1 OR x.page_no % 8088 = 0 THEN 'PFS'
                        WHEN x.page_no = 2 OR x.page_no % 511232 = 0 THEN 'GAM'
                        WHEN x.page_no = 3 OR (x.page_no - 1) % 511232 = 0 THEN 'SGAM'
                        WHEN x.page_no = 6 OR (x.page_no - 6) % 511232 = 0 THEN 'DCM'
                        WHEN x.page_no = 7 OR (x.page_no - 7) % 511232 = 0 THEN 'BCM'
                        WHEN x.page_no IS NOT NULL THEN '*'
                        ELSE NULL
                    END AS page_type,
                    x.hobt_id,
                    x.allocation_unit_id,
                    x.index_id,
                    x.schema_id,
                    x.principal_id,
                    x.request_mode,
                    x.request_status,
                    x.session_id,
                    x.request_id,
                    CASE
                        WHEN COALESCE(x.object_id, x.file_id, x.hobt_id, x.allocation_unit_id, x.index_id, x.schema_id, x.principal_id) IS NULL THEN NULLIF(resource_description, '')
                        ELSE NULL
                    END AS resource_description,
                    COUNT(*) AS request_count
                FROM
                (
                    SELECT
                        tl.resource_type +
                            CASE
                                WHEN tl.resource_subtype = '' THEN ''
                                ELSE '.' + tl.resource_subtype
                            END AS resource_type,
                        COALESCE(DB_NAME(tl.resource_database_id), N'(null)') AS database_name,
                        CONVERT
                        (
                            INT,
                            CASE
                                WHEN tl.resource_type = 'OBJECT' THEN tl.resource_associated_entity_id
                                WHEN tl.resource_description LIKE '%object_id = %' THEN
                                    (
                                        SUBSTRING
                                        (
                                            tl.resource_description, 
                                            (CHARINDEX('object_id = ', tl.resource_description) + 12), 
                                            COALESCE
                                            (
                                                NULLIF
                                                (
                                                    CHARINDEX(',', tl.resource_description, CHARINDEX('object_id = ', tl.resource_description) + 12),
                                                    0
                                                ), 
                                                DATALENGTH(tl.resource_description)+1
                                            ) - (CHARINDEX('object_id = ', tl.resource_description) + 12)
                                        )
                                    )
                                ELSE NULL
                            END
                        ) AS object_id,
                        CONVERT
                        (
                            INT,
                            CASE 
                                WHEN tl.resource_type = 'FILE' THEN CONVERT(INT, tl.resource_description)
                                WHEN tl.resource_type IN ('PAGE', 'EXTENT', 'RID') THEN LEFT(tl.resource_description, CHARINDEX(':', tl.resource_description)-1)
                                ELSE NULL
                            END
                        ) AS file_id,
                        CONVERT
                        (
                            INT,
                            CASE
                                WHEN tl.resource_type IN ('PAGE', 'EXTENT', 'RID') THEN 
                                    SUBSTRING
                                    (
                                        tl.resource_description, 
                                        CHARINDEX(':', tl.resource_description) + 1, 
                                        COALESCE
                                        (
                                            NULLIF
                                            (
                                                CHARINDEX(':', tl.resource_description, CHARINDEX(':', tl.resource_description) + 1), 
                                                0
                                            ), 
                                            DATALENGTH(tl.resource_description)+1
                                        ) - (CHARINDEX(':', tl.resource_description) + 1)
                                    )
                                ELSE NULL
                            END
                        ) AS page_no,
                        CASE
                            WHEN tl.resource_type IN ('PAGE', 'KEY', 'RID', 'HOBT') THEN tl.resource_associated_entity_id
                            ELSE NULL
                        END AS hobt_id,
                        CASE
                            WHEN tl.resource_type = 'ALLOCATION_UNIT' THEN tl.resource_associated_entity_id
                            ELSE NULL
                        END AS allocation_unit_id,
                        CONVERT
                        (
                            INT,
                            CASE
                                WHEN
                                    /*TODO: Deal with server principals*/ 
                                    tl.resource_subtype <> 'SERVER_PRINCIPAL' 
                                    AND tl.resource_description LIKE '%index_id or stats_id = %' THEN
                                    (
                                        SUBSTRING
                                        (
                                            tl.resource_description, 
                                            (CHARINDEX('index_id or stats_id = ', tl.resource_description) + 23), 
                                            COALESCE
                                            (
                                                NULLIF
                                                (
                                                    CHARINDEX(',', tl.resource_description, CHARINDEX('index_id or stats_id = ', tl.resource_description) + 23), 
                                                    0
                                                ), 
                                                DATALENGTH(tl.resource_description)+1
                                            ) - (CHARINDEX('index_id or stats_id = ', tl.resource_description) + 23)
                                        )
                                    )
                                ELSE NULL
                            END 
                        ) AS index_id,
                        CONVERT
                        (
                            INT,
                            CASE
                                WHEN tl.resource_description LIKE '%schema_id = %' THEN
                                    (
                                        SUBSTRING
                                        (
                                            tl.resource_description, 
                                            (CHARINDEX('schema_id = ', tl.resource_description) + 12), 
                                            COALESCE
                                            (
                                                NULLIF
                                                (
                                                    CHARINDEX(',', tl.resource_description, CHARINDEX('schema_id = ', tl.resource_description) + 12), 
                                                    0
                                                ), 
                                                DATALENGTH(tl.resource_description)+1
                                            ) - (CHARINDEX('schema_id = ', tl.resource_description) + 12)
                                        )
                                    )
                                ELSE NULL
                            END 
                        ) AS schema_id,
                        CONVERT
                        (
                            INT,
                            CASE
                                WHEN tl.resource_description LIKE '%principal_id = %' THEN
                                    (
                                        SUBSTRING
                                        (
                                            tl.resource_description, 
                                            (CHARINDEX('principal_id = ', tl.resource_description) + 15), 
                                            COALESCE
                                            (
                                                NULLIF
                                                (
                                                    CHARINDEX(',', tl.resource_description, CHARINDEX('principal_id = ', tl.resource_description) + 15), 
                                                    0
                                                ), 
                                                DATALENGTH(tl.resource_description)+1
                                            ) - (CHARINDEX('principal_id = ', tl.resource_description) + 15)
                                        )
                                    )
                                ELSE NULL
                            END
                        ) AS principal_id,
                        tl.request_mode,
                        tl.request_status,
                        tl.request_session_id AS session_id,
                        tl.request_request_id AS request_id,

                        /*TODO: Applocks, other resource_descriptions*/
                        RTRIM(tl.resource_description) AS resource_description,
                        tl.resource_associated_entity_id
                        /*********************************************/
                    FROM 
                    (
                        SELECT 
                            request_session_id,
                            CONVERT(VARCHAR(120), resource_type) COLLATE Latin1_General_Bin2 AS resource_type,
                            CONVERT(VARCHAR(120), resource_subtype) COLLATE Latin1_General_Bin2 AS resource_subtype,
                            resource_database_id,
                            CONVERT(VARCHAR(512), resource_description) COLLATE Latin1_General_Bin2 AS resource_description,
                            resource_associated_entity_id,
                            CONVERT(VARCHAR(120), request_mode) COLLATE Latin1_General_Bin2 AS request_mode,
                            CONVERT(VARCHAR(120), request_status) COLLATE Latin1_General_Bin2 AS request_status,
                            request_request_id
                        FROM sys.dm_tran_locks
                    ) AS tl
                ) AS x
                GROUP BY
                    x.resource_type,
                    x.database_name,
                    x.object_id,
                    x.file_id,
                    CASE
                        WHEN x.page_no = 1 OR x.page_no % 8088 = 0 THEN 'PFS'
                        WHEN x.page_no = 2 OR x.page_no % 511232 = 0 THEN 'GAM'
                        WHEN x.page_no = 3 OR (x.page_no - 1) % 511232 = 0 THEN 'SGAM'
                        WHEN x.page_no = 6 OR (x.page_no - 6) % 511232 = 0 THEN 'DCM'
                        WHEN x.page_no = 7 OR (x.page_no - 7) % 511232 = 0 THEN 'BCM'
                        WHEN x.page_no IS NOT NULL THEN '*'
                        ELSE NULL
                    END,
                    x.hobt_id,
                    x.allocation_unit_id,
                    x.index_id,
                    x.schema_id,
                    x.principal_id,
                    x.request_mode,
                    x.request_status,
                    x.session_id,
                    x.request_id,
                    CASE
                        WHEN COALESCE(x.object_id, x.file_id, x.hobt_id, x.allocation_unit_id, x.index_id, x.schema_id, x.principal_id) IS NULL THEN NULLIF(resource_description, '')
                        ELSE NULL
                    END
            ) AS y ON
                y.session_id = s.session_id
                AND y.request_id = s.request_id
            OPTION (HASH GROUP);

            --Disable unnecessary autostats on the table
            CREATE STATISTICS s_database_name ON #locks (database_name)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_object_id ON #locks (object_id)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_hobt_id ON #locks (hobt_id)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_allocation_unit_id ON #locks (allocation_unit_id)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_index_id ON #locks (index_id)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_schema_id ON #locks (schema_id)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_principal_id ON #locks (principal_id)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_request_id ON #locks (request_id)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_start_time ON #locks (start_time)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_resource_type ON #locks (resource_type)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_object_name ON #locks (object_name)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_schema_name ON #locks (schema_name)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_page_type ON #locks (page_type)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_request_mode ON #locks (request_mode)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_request_status ON #locks (request_status)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_resource_description ON #locks (resource_description)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_index_name ON #locks (index_name)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_principal_name ON #locks (principal_name)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
        END;
        
        DECLARE 
            @sql VARCHAR(MAX), 
            @sql_n NVARCHAR(MAX);

        SET @sql = 
            CONVERT(VARCHAR(MAX), '') +
            'DECLARE @blocker BIT;
            SET @blocker = 0;
            DECLARE @i INT;
            SET @i = 2147483647;

            DECLARE @sessions TABLE
            (
                session_id SMALLINT NOT NULL,
                request_id INT NOT NULL,
                login_time DATETIME,
                last_request_end_time DATETIME,
                status VARCHAR(30),
                statement_start_offset INT,
                statement_end_offset INT,
                sql_handle BINARY(20),
                host_name NVARCHAR(128),
                login_name NVARCHAR(128),
                program_name NVARCHAR(128),
                database_id SMALLINT,
                memory_usage INT,
                open_tran_count SMALLINT, 
                ' +
                CASE
                    WHEN 
                    (
                        @get_task_info <> 0 
                        OR @find_block_leaders = 1 
                    ) THEN
                        'wait_type NVARCHAR(32),
                        wait_resource NVARCHAR(256),
                        wait_time BIGINT, 
                        '
                    ELSE 
                        ''
                END +
                'blocked SMALLINT,
                is_user_process BIT,
                cmd VARCHAR(32),
                PRIMARY KEY CLUSTERED (session_id, request_id) WITH (IGNORE_DUP_KEY = ON)
            );

            DECLARE @blockers TABLE
            (
                session_id INT NOT NULL PRIMARY KEY WITH (IGNORE_DUP_KEY = ON)
            );

            BLOCKERS:;

            INSERT @sessions
            (
                session_id,
                request_id,
                login_time,
                last_request_end_time,
                status,
                statement_start_offset,
                statement_end_offset,
                sql_handle,
                host_name,
                login_name,
                program_name,
                database_id,
                memory_usage,
                open_tran_count, 
                ' +
                CASE
                    WHEN 
                    (
                        @get_task_info <> 0
                        OR @find_block_leaders = 1 
                    ) THEN
                        'wait_type,
                        wait_resource,
                        wait_time, 
                        '
                    ELSE
                        ''
                END +
                'blocked,
                is_user_process,
                cmd 
            )
            SELECT TOP(@i)
                spy.session_id,
                spy.request_id,
                spy.login_time,
                spy.last_request_end_time,
                spy.status,
                spy.statement_start_offset,
                spy.statement_end_offset,
                spy.sql_handle,
                spy.host_name,
                spy.login_name,
                spy.program_name,
                spy.database_id,
                spy.memory_usage,
                spy.open_tran_count,
                ' +
                CASE
                    WHEN 
                    (
                        @get_task_info <> 0  
                        OR @find_block_leaders = 1 
                    ) THEN
                        'spy.wait_type,
                        CASE
                            WHEN
                                spy.wait_type LIKE N''PAGE%LATCH_%''
                                OR spy.wait_type = N''CXPACKET''
                                OR spy.wait_type LIKE N''LATCH[_]%''
                                OR spy.wait_type = N''OLEDB'' THEN
                                    spy.wait_resource
                            ELSE
                                NULL
                        END AS wait_resource,
                        spy.wait_time, 
                        '
                    ELSE
                        ''
                END +
                'spy.blocked,
                spy.is_user_process,
                spy.cmd
            FROM
            (
                SELECT TOP(@i)
                    spx.*, 
                    ' +
                    CASE
                        WHEN 
                        (
                            @get_task_info <> 0 
                            OR @find_block_leaders = 1 
                        ) THEN
                            'ROW_NUMBER() OVER
                            (
                                PARTITION BY
                                    spx.session_id,
                                    spx.request_id
                                ORDER BY
                                    CASE
                                        WHEN spx.wait_type LIKE N''LCK[_]%'' THEN 
                                            1
                                        ELSE
                                            99
                                    END,
                                    spx.wait_time DESC,
                                    spx.blocked DESC
                            ) AS r 
                            '
                        ELSE 
                            '1 AS r 
                            '
                    END +
                'FROM
                (
                    SELECT TOP(@i)
                        sp0.session_id,
                        sp0.request_id,
                        sp0.login_time,
                        sp0.last_request_end_time,
                        LOWER(sp0.status) AS status,
                        CASE
                            WHEN sp0.cmd = ''CREATE INDEX'' THEN
                                0
                            ELSE
                                sp0.stmt_start
                        END AS statement_start_offset,
                        CASE
                            WHEN sp0.cmd = N''CREATE INDEX'' THEN
                                -1
                            ELSE
                                COALESCE(NULLIF(sp0.stmt_end, 0), -1)
                        END AS statement_end_offset,
                        sp0.sql_handle,
                        sp0.host_name,
                        sp0.login_name,
                        sp0.program_name,
                        sp0.database_id,
                        sp0.memory_usage,
                        sp0.open_tran_count, 
                        ' +
                        CASE
                            WHEN 
                            (
                                @get_task_info <> 0 
                                OR @find_block_leaders = 1 
                            ) THEN
                                'CASE
                                    WHEN sp0.wait_time > 0 AND sp0.wait_type <> N''CXPACKET'' THEN
                                        sp0.wait_type
                                    ELSE
                                        NULL
                                END AS wait_type,
                                CASE
                                    WHEN sp0.wait_time > 0 AND sp0.wait_type <> N''CXPACKET'' THEN 
                                        sp0.wait_resource
                                    ELSE
                                        NULL
                                END AS wait_resource,
                                CASE
                                    WHEN sp0.wait_type <> N''CXPACKET'' THEN
                                        sp0.wait_time
                                    ELSE
                                        0
                                END AS wait_time, 
                                '
                            ELSE
                                ''
                        END +
                        'sp0.blocked,
                        sp0.is_user_process,
                        sp0.cmd
                    FROM
                    (
                        SELECT TOP(@i)
                            sp1.session_id,
                            sp1.request_id,
                            sp1.login_time,
                            sp1.last_request_end_time,
                            sp1.status,
                            sp1.cmd,
                            sp1.stmt_start,
                            sp1.stmt_end,
                            MAX(NULLIF(sp1.sql_handle, 0x00)) OVER (PARTITION BY sp1.session_id, sp1.request_id) AS sql_handle,
                            sp1.host_name,
                            MAX(sp1.login_name) OVER (PARTITION BY sp1.session_id, sp1.request_id) AS login_name,
                            sp1.program_name,
                            sp1.database_id,
                            MAX(sp1.memory_usage)  OVER (PARTITION BY sp1.session_id, sp1.request_id) AS memory_usage,
                            MAX(sp1.open_tran_count)  OVER (PARTITION BY sp1.session_id, sp1.request_id) AS open_tran_count,
                            sp1.wait_type,
                            sp1.wait_resource,
                            sp1.wait_time,
                            sp1.blocked,
                            sp1.hostprocess,
                            sp1.is_user_process
                        FROM
                        (
                            SELECT TOP(@i)
                                sp2.spid AS session_id,
                                CASE sp2.status
                                    WHEN ''sleeping'' THEN
                                        CONVERT(INT, 0)
                                    ELSE
                                        sp2.request_id
                                END AS request_id,
                                MAX(sp2.login_time) AS login_time,
                                MAX(sp2.last_batch) AS last_request_end_time,
                                MAX(CONVERT(VARCHAR(30), RTRIM(sp2.status)) COLLATE Latin1_General_Bin2) AS status,
                                MAX(CONVERT(VARCHAR(32), RTRIM(sp2.cmd)) COLLATE Latin1_General_Bin2) AS cmd,
                                MAX(sp2.stmt_start) AS stmt_start,
                                MAX(sp2.stmt_end) AS stmt_end,
                                MAX(sp2.sql_handle) AS sql_handle,
                                MAX(CONVERT(sysname, RTRIM(sp2.hostname)) COLLATE SQL_Latin1_General_CP1_CI_AS) AS host_name,
                                MAX(CONVERT(sysname, RTRIM(sp2.loginame)) COLLATE SQL_Latin1_General_CP1_CI_AS) AS login_name,
                                MAX
                                (
                                    CASE
                                        WHEN blk.queue_id IS NOT NULL THEN
                                            N''Service Broker
                                                database_id: '' + CONVERT(NVARCHAR, blk.database_id) +
                                                N'' queue_id: '' + CONVERT(NVARCHAR, blk.queue_id)
                                        ELSE
                                            CONVERT
                                            (
                                                sysname,
                                                RTRIM(sp2.program_name)
                                            )
                                    END COLLATE SQL_Latin1_General_CP1_CI_AS
                                ) AS program_name,
                                MAX(sp2.dbid) AS database_id,
                                MAX(sp2.memusage) AS memory_usage,
                                MAX(sp2.open_tran) AS open_tran_count,
                                RTRIM(sp2.lastwaittype) AS wait_type,
                                RTRIM(sp2.waitresource) AS wait_resource,
                                MAX(sp2.waittime) AS wait_time,
                                COALESCE(NULLIF(sp2.blocked, sp2.spid), 0) AS blocked,
                                MAX
                                (
                                    CASE
                                        WHEN blk.session_id = sp2.spid THEN
                                            ''blocker''
                                        ELSE
                                            RTRIM(sp2.hostprocess)
                                    END
                                ) AS hostprocess,
                                CONVERT
                                (
                                    BIT,
                                    MAX
                                    (
                                        CASE
                                            WHEN sp2.hostprocess > '''' THEN
                                                1
                                            ELSE
                                                0
                                        END
                                    )
                                ) AS is_user_process
                            FROM
                            (
                                SELECT TOP(@i)
                                    session_id,
                                    CONVERT(INT, NULL) AS queue_id,
                                    CONVERT(INT, NULL) AS database_id
                                FROM @blockers

                                UNION ALL

                                SELECT TOP(@i)
                                    CONVERT(SMALLINT, 0),
                                    CONVERT(INT, NULL) AS queue_id,
                                    CONVERT(INT, NULL) AS database_id
                                WHERE
                                    @blocker = 0

                                UNION ALL

                                SELECT TOP(@i)
                                    CONVERT(SMALLINT, spid),
                                    queue_id,
                                    database_id
                                FROM sys.dm_broker_activated_tasks
                                WHERE
                                    @blocker = 0
                            ) AS blk
                            INNER JOIN sys.sysprocesses AS sp2 ON
                                sp2.spid = blk.session_id
                                OR
                                (
                                    blk.session_id = 0
                                    AND @blocker = 0
                                )
                            ' +
                            CASE 
                                WHEN 
                                (
                                    @get_task_info = 0 
                                    AND @find_block_leaders = 0
                                ) THEN
                                    'WHERE
                                        sp2.ecid = 0 
                                    ' 
                                ELSE
                                    ''
                            END +
                            'GROUP BY
                                sp2.spid,
                                CASE sp2.status
                                    WHEN ''sleeping'' THEN
                                        CONVERT(INT, 0)
                                    ELSE
                                        sp2.request_id
                                END,
                                RTRIM(sp2.lastwaittype),
                                RTRIM(sp2.waitresource),
                                COALESCE(NULLIF(sp2.blocked, sp2.spid), 0)
                        ) AS sp1
                    ) AS sp0
                    WHERE
                        @blocker = 1
                        OR
                        (1=1 
                        ' +
                            --inclusive filter
                            CASE
                                WHEN @filter <> '' THEN
                                    CASE @filter_type
                                        WHEN 'session' THEN
                                            CASE
                                                WHEN CONVERT(SMALLINT, @filter) <> 0 THEN
                                                    'AND sp0.session_id = CONVERT(SMALLINT, @filter) 
                                                    '
                                                ELSE
                                                    ''
                                            END
                                        WHEN 'program' THEN
                                            'AND sp0.program_name LIKE @filter 
                                            '
                                        WHEN 'login' THEN
                                            'AND sp0.login_name LIKE @filter 
                                            '
                                        WHEN 'host' THEN
                                            'AND sp0.host_name LIKE @filter 
                                            '
                                        WHEN 'database' THEN
                                            'AND DB_NAME(sp0.database_id) LIKE @filter 
                                            '
                                        ELSE
                                            ''
                                    END
                                ELSE
                                    ''
                            END +
                            --exclusive filter
                            CASE
                                WHEN @not_filter <> '' THEN
                                    CASE @not_filter_type
                                        WHEN 'session' THEN
                                            CASE
                                                WHEN CONVERT(SMALLINT, @not_filter) <> 0 THEN
                                                    'AND sp0.session_id <> CONVERT(SMALLINT, @not_filter) 
                                                    '
                                                ELSE
                                                    ''
                                            END
                                        WHEN 'program' THEN
                                            'AND sp0.program_name NOT LIKE @not_filter 
                                            '
                                        WHEN 'login' THEN
                                            'AND sp0.login_name NOT LIKE @not_filter 
                                            '
                                        WHEN 'host' THEN
                                            'AND sp0.host_name NOT LIKE @not_filter 
                                            '
                                        WHEN 'database' THEN
                                            'AND DB_NAME(sp0.database_id) NOT LIKE @not_filter 
                                            '
                                        ELSE
                                            ''
                                    END
                                ELSE
                                    ''
                            END +
                            CASE @show_own_spid
                                WHEN 1 THEN
                                    ''
                                ELSE
                                    'AND sp0.session_id <> @@spid 
                                    '
                            END +
                            CASE 
                                WHEN @show_system_spids = 0 THEN
                                    'AND sp0.hostprocess > '''' 
                                    ' 
                                ELSE
                                    ''
                            END +
                            CASE @show_sleeping_spids
                                WHEN 0 THEN
                                    'AND sp0.status <> ''sleeping'' 
                                    '
                                WHEN 1 THEN
                                    'AND
                                    (
                                        sp0.status <> ''sleeping''
                                        OR sp0.open_tran_count > 0
                                    )
                                    '
                                ELSE
                                    ''
                            END +
                        ')
                ) AS spx
            ) AS spy
            WHERE
                spy.r = 1; 
            ' + 
            CASE @recursion
                WHEN 1 THEN 
                    'IF @@ROWCOUNT > 0
                    BEGIN;
                        INSERT @blockers
                        (
                            session_id
                        )
                        SELECT TOP(@i)
                            blocked
                        FROM @sessions
                        WHERE
                            NULLIF(blocked, 0) IS NOT NULL

                        EXCEPT

                        SELECT TOP(@i)
                            session_id
                        FROM @sessions; 
                        ' +

                        CASE
                            WHEN
                            (
                                @get_task_info > 0
                                OR @find_block_leaders = 1
                            ) THEN
                                'IF @@ROWCOUNT > 0
                                BEGIN;
                                    SET @blocker = 1;
                                    GOTO BLOCKERS;
                                END; 
                                '
                            ELSE 
                                ''
                        END +
                    'END; 
                    '
                ELSE 
                    ''
            END +
            'SELECT TOP(@i)
                @recursion AS recursion,
                x.session_id,
                x.request_id,
                DENSE_RANK() OVER
                (
                    ORDER BY
                        x.session_id
                ) AS session_number,
                ' +
                CASE
                    WHEN @output_column_list LIKE '%|[dd hh:mm:ss.mss|]%' ESCAPE '|' THEN 
                        'x.elapsed_time '
                    ELSE 
                        '0 '
                END + 
                    'AS elapsed_time, 
                    ' +
                CASE
                    WHEN
                        (
                            @output_column_list LIKE '%|[dd hh:mm:ss.mss (avg)|]%' ESCAPE '|' OR 
                            @output_column_list LIKE '%|[avg_elapsed_time|]%' ESCAPE '|'
                        )
                        AND @recursion = 1
                            THEN 
                                'x.avg_elapsed_time / 1000 '
                    ELSE 
                        'NULL '
                END + 
                    'AS avg_elapsed_time, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[physical_io|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[physical_io_delta|]%' ESCAPE '|'
                            THEN 
                                'x.physical_io '
                    ELSE 
                        'NULL '
                END + 
                    'AS physical_io, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[reads|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[reads_delta|]%' ESCAPE '|'
                            THEN 
                                'x.reads '
                    ELSE 
                        '0 '
                END + 
                    'AS reads, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[physical_reads|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[physical_reads_delta|]%' ESCAPE '|'
                            THEN 
                                'x.physical_reads '
                    ELSE 
                        '0 '
                END + 
                    'AS physical_reads, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[writes|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[writes_delta|]%' ESCAPE '|'
                            THEN 
                                'x.writes '
                    ELSE 
                        '0 '
                END + 
                    'AS writes, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[tempdb_allocations|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[tempdb_allocations_delta|]%' ESCAPE '|'
                            THEN 
                                'x.tempdb_allocations '
                    ELSE 
                        '0 '
                END + 
                    'AS tempdb_allocations, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[tempdb_current|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[tempdb_current_delta|]%' ESCAPE '|'
                            THEN 
                                'x.tempdb_current '
                    ELSE 
                        '0 '
                END + 
                    'AS tempdb_current, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[CPU|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[CPU_delta|]%' ESCAPE '|'
                            THEN
                                'x.CPU '
                    ELSE
                        '0 '
                END + 
                    'AS CPU, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[CPU_delta|]%' ESCAPE '|'
                        AND @get_task_info = 2
                        AND @sys_info = 1
                            THEN 
                                'x.thread_CPU_snapshot '
                    ELSE 
                        '0 '
                END + 
                    'AS thread_CPU_snapshot, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[context_switches|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[context_switches_delta|]%' ESCAPE '|'
                            THEN 
                                'x.context_switches '
                    ELSE 
                        'NULL '
                END + 
                    'AS context_switches, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[used_memory|]%' ESCAPE '|'
                        OR @output_column_list LIKE '%|[used_memory_delta|]%' ESCAPE '|'
                            THEN 
                                'x.used_memory '
                    ELSE 
                        '0 '
                END + 
                    'AS used_memory, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[tasks|]%' ESCAPE '|'
                        AND @recursion = 1
                            THEN 
                                'x.tasks '
                    ELSE 
                        'NULL '
                END + 
                    'AS tasks, 
                    ' +
                CASE
                    WHEN 
                        (
                            @output_column_list LIKE '%|[status|]%' ESCAPE '|' 
                            OR @output_column_list LIKE '%|[sql_command|]%' ESCAPE '|'
                        )
                        AND @recursion = 1
                            THEN 
                                'x.status '
                    ELSE 
                        ''''' '
                END + 
                    'AS status, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[wait_info|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                CASE @get_task_info
                                    WHEN 2 THEN
                                        'COALESCE(x.task_wait_info, x.sys_wait_info) '
                                    ELSE
                                        'x.sys_wait_info '
                                END
                    ELSE 
                        'NULL '
                END + 
                    'AS wait_info, 
                    ' +
                CASE
                    WHEN 
                        (
                            @output_column_list LIKE '%|[tran_start_time|]%' ESCAPE '|' 
                            OR @output_column_list LIKE '%|[tran_log_writes|]%' ESCAPE '|' 
                        )
                        AND @recursion = 1
                            THEN 
                                'x.transaction_id '
                    ELSE 
                        'NULL '
                END + 
                    'AS transaction_id, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[open_tran_count|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                'x.open_tran_count '
                    ELSE 
                        'NULL '
                END + 
                    'AS open_tran_count, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[sql_text|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                'x.sql_handle '
                    ELSE 
                        'NULL '
                END + 
                    'AS sql_handle, 
                    ' +
                CASE
                    WHEN 
                        (
                            @output_column_list LIKE '%|[sql_text|]%' ESCAPE '|' 
                            OR @output_column_list LIKE '%|[query_plan|]%' ESCAPE '|' 
                        )
                        AND @recursion = 1
                            THEN 
                                'x.statement_start_offset '
                    ELSE 
                        'NULL '
                END + 
                    'AS statement_start_offset, 
                    ' +
                CASE
                    WHEN 
                        (
                            @output_column_list LIKE '%|[sql_text|]%' ESCAPE '|' 
                            OR @output_column_list LIKE '%|[query_plan|]%' ESCAPE '|' 
                        )
                        AND @recursion = 1
                            THEN 
                                'x.statement_end_offset '
                    ELSE 
                        'NULL '
                END + 
                    'AS statement_end_offset, 
                    ' +
                'NULL AS sql_text, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[query_plan|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                'x.plan_handle '
                    ELSE 
                        'NULL '
                END + 
                    'AS plan_handle, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[blocking_session_id|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                'NULLIF(x.blocking_session_id, 0) '
                    ELSE 
                        'NULL '
                END + 
                    'AS blocking_session_id, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[percent_complete|]%' ESCAPE '|'
                        AND @recursion = 1
                            THEN 
                                'x.percent_complete '
                    ELSE 
                        'NULL '
                END + 
                    'AS percent_complete, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[host_name|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                'x.host_name '
                    ELSE 
                        ''''' '
                END + 
                    'AS host_name, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[login_name|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                'x.login_name '
                    ELSE 
                        ''''' '
                END + 
                    'AS login_name, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[database_name|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                'DB_NAME(x.database_id) '
                    ELSE 
                        'NULL '
                END + 
                    'AS database_name, 
                    ' +
                CASE
                    WHEN 
                        @output_column_list LIKE '%|[program_name|]%' ESCAPE '|' 
                        AND @recursion = 1
                            THEN 
                                'x.program_name '
                    ELSE 
                        ''''' '
                END + 
                    'AS program_name, 
                    ' +
                CASE
                    WHEN
                        @output_column_list LIKE '%|[additional_info|]%' ESCAPE '|'
                        AND @recursion = 1
                            THEN
                                '(
                                    SELECT TOP(@i)
                                        x.text_size,
                                        x.language,
                                        x.date_format,
                                        x.date_first,
                                        CASE x.quoted_identifier
                                            WHEN 0 THEN ''OFF''
                                            WHEN 1 THEN ''ON''
                                        END AS quoted_identifier,
                                        CASE x.arithabort
                                            WHEN 0 THEN ''OFF''
                                            WHEN 1 THEN ''ON''
                                        END AS arithabort,
                                        CASE x.ansi_null_dflt_on
                                            WHEN 0 THEN ''OFF''
                                            WHEN 1 THEN ''ON''
                                        END AS ansi_null_dflt_on,
                                        CASE x.ansi_defaults
                                            WHEN 0 THEN ''OFF''
                                            WHEN 1 THEN ''ON''
                                        END AS ansi_defaults,
                                        CASE x.ansi_warnings
                                            WHEN 0 THEN ''OFF''
                                            WHEN 1 THEN ''ON''
                                        END AS ansi_warnings,
                                        CASE x.ansi_padding
                                            WHEN 0 THEN ''OFF''
                                            WHEN 1 THEN ''ON''
                                        END AS ansi_padding,
                                        CASE ansi_nulls
                                            WHEN 0 THEN ''OFF''
                                            WHEN 1 THEN ''ON''
                                        END AS ansi_nulls,
                                        CASE x.concat_null_yields_null
                                            WHEN 0 THEN ''OFF''
                                            WHEN 1 THEN ''ON''
                                        END AS concat_null_yields_null,
                                        CASE x.transaction_isolation_level
                                            WHEN 0 THEN ''Unspecified''
                                            WHEN 1 THEN ''ReadUncomitted''
                                            WHEN 2 THEN ''ReadCommitted''
                                            WHEN 3 THEN ''Repeatable''
                                            WHEN 4 THEN ''Serializable''
                                            WHEN 5 THEN ''Snapshot''
                                        END AS transaction_isolation_level,
                                        x.lock_timeout,
                                        x.deadlock_priority,
                                        x.row_count,
                                        x.command_type, 
                                        ' +
                                        CASE
                                            WHEN OBJECT_ID('master.dbo.fn_varbintohexstr') IS NOT NULL THEN
                                                'master.dbo.fn_varbintohexstr(x.sql_handle) AS sql_handle,
                                                master.dbo.fn_varbintohexstr(x.plan_handle) AS plan_handle,'
                                            ELSE
                                                'CONVERT(VARCHAR(256), x.sql_handle, 1) AS sql_handle,
                                                CONVERT(VARCHAR(256), x.plan_handle, 1) AS plan_handle,'
                                        END +
                                        '
                                        x.statement_start_offset,
                                        x.statement_end_offset,
                                        ' +
                                        CASE
                                            WHEN @output_column_list LIKE '%|[program_name|]%' ESCAPE '|' THEN
                                                '(
                                                    SELECT TOP(1)
                                                        CONVERT(uniqueidentifier, CONVERT(XML, '''').value(''xs:hexBinary( substring(sql:column("agent_info.job_id_string"), 0) )'', ''binary(16)'')) AS job_id,
                                                        agent_info.step_id,
                                                        (
                                                            SELECT TOP(1)
                                                                NULL
                                                            FOR XML
                                                                PATH(''job_name''),
                                                                TYPE
                                                        ),
                                                        (
                                                            SELECT TOP(1)
                                                                NULL
                                                            FOR XML
                                                                PATH(''step_name''),
                                                                TYPE
                                                        )
                                                    FROM
                                                    (
                                                        SELECT TOP(1)
                                                            SUBSTRING(x.program_name, CHARINDEX(''0x'', x.program_name) + 2, 32) AS job_id_string,
                                                            SUBSTRING(x.program_name, CHARINDEX('': Step '', x.program_name) + 7, CHARINDEX('')'', x.program_name, CHARINDEX('': Step '', x.program_name)) - (CHARINDEX('': Step '', x.program_name) + 7)) AS step_id
                                                        WHERE
                                                            x.program_name LIKE N''SQLAgent - TSQL JobStep (Job 0x%''
                                                    ) AS agent_info
                                                    FOR XML
                                                        PATH(''agent_job_info''),
                                                        TYPE
                                                ),
                                                '
                                            ELSE ''
                                        END +
                                        CASE
                                            WHEN @get_task_info = 2 THEN
                                                'CONVERT(XML, x.block_info) AS block_info, 
                                                '
                                            ELSE
                                                ''
                                        END + '
                                        x.host_process_id,
                                        x.group_id
                                    FOR XML
                                        PATH(''additional_info''),
                                        TYPE
                                ) '
                    ELSE
                        'NULL '
                END + 
                    'AS additional_info, 
                x.start_time, 
                    ' +
                CASE
                    WHEN
                        @output_column_list LIKE '%|[login_time|]%' ESCAPE '|'
                        AND @recursion = 1
                            THEN
                                'x.login_time '
                    ELSE 
                        'NULL '
                END + 
                    'AS login_time, 
                x.last_request_start_time
            FROM
            (
                SELECT TOP(@i)
                    y.*,
                    CASE
                        WHEN DATEDIFF(hour, y.start_time, GETDATE()) > 576 THEN
                            DATEDIFF(second, GETDATE(), y.start_time)
                        ELSE DATEDIFF(ms, y.start_time, GETDATE())
                    END AS elapsed_time,
                    COALESCE(tempdb_info.tempdb_allocations, 0) AS tempdb_allocations,
                    COALESCE
                    (
                        CASE
                            WHEN tempdb_info.tempdb_current < 0 THEN 0
                            ELSE tempdb_info.tempdb_current
                        END,
                        0
                    ) AS tempdb_current, 
                    ' +
                    CASE
                        WHEN 
                            (
                                @get_task_info <> 0
                                OR @find_block_leaders = 1
                            ) THEN
                                'N''('' + CONVERT(NVARCHAR, y.wait_duration_ms) + N''ms)'' +
                                    y.wait_type +
                                        CASE
                                            WHEN y.wait_type LIKE N''PAGE%LATCH_%'' THEN
                                                N'':'' +
                                                COALESCE(DB_NAME(CONVERT(INT, LEFT(y.resource_description, CHARINDEX(N'':'', y.resource_description) - 1))), N''(null)'') +
                                                N'':'' +
                                                SUBSTRING(y.resource_description, CHARINDEX(N'':'', y.resource_description) + 1, LEN(y.resource_description) - CHARINDEX(N'':'', REVERSE(y.resource_description)) - CHARINDEX(N'':'', y.resource_description)) +
                                                N''('' +
                                                    CASE
                                                        WHEN
                                                            CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 1 OR
                                                            CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) % 8088 = 0
                                                                THEN 
                                                                    N''PFS''
                                                        WHEN
                                                            CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 2 OR
                                                            CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) % 511232 = 0
                                                                THEN 
                                                                    N''GAM''
                                                        WHEN
                                                            CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 3 OR
                                                            (CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) - 1) % 511232 = 0
                                                                THEN
                                                                    N''SGAM''
                                                        WHEN
                                                            CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 6 OR
                                                            (CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) - 6) % 511232 = 0 
                                                                THEN 
                                                                    N''DCM''
                                                        WHEN
                                                            CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) = 7 OR
                                                            (CONVERT(INT, RIGHT(y.resource_description, CHARINDEX(N'':'', REVERSE(y.resource_description)) - 1)) - 7) % 511232 = 0 
                                                                THEN 
                                                                    N''BCM''
                                                        ELSE 
                                                            N''*''
                                                    END +
                                                N'')''
                                            WHEN y.wait_type = N''CXPACKET'' THEN
                                                N'':'' + SUBSTRING(y.resource_description, CHARINDEX(N''nodeId'', y.resource_description) + 7, 4)
                                            WHEN y.wait_type LIKE N''LATCH[_]%'' THEN
                                                N'' ['' + LEFT(y.resource_description, COALESCE(NULLIF(CHARINDEX(N'' '', y.resource_description), 0), LEN(y.resource_description) + 1) - 1) + N'']''
                                            WHEN
                                                y.wait_type = N''OLEDB''
                                                AND y.resource_description LIKE N''%(SPID=%)'' THEN
                                                    N''['' + LEFT(y.resource_description, CHARINDEX(N''(SPID='', y.resource_description) - 2) +
                                                        N'':'' + SUBSTRING(y.resource_description, CHARINDEX(N''(SPID='', y.resource_description) + 6, CHARINDEX(N'')'', y.resource_description, (CHARINDEX(N''(SPID='', y.resource_description) + 6)) - (CHARINDEX(N''(SPID='', y.resource_description) + 6)) + '']''
                                            ELSE
                                                N''''
                                        END COLLATE Latin1_General_Bin2 AS sys_wait_info, 
                                        '
                            ELSE
                                ''
                        END +
                        CASE
                            WHEN @get_task_info = 2 THEN
                                'tasks.physical_io,
                                tasks.context_switches,
                                tasks.tasks,
                                tasks.block_info,
                                tasks.wait_info AS task_wait_info,
                                tasks.thread_CPU_snapshot,
                                '
                            ELSE
                                '' 
                    END +
                    CASE 
                        WHEN NOT (@get_avg_time = 1 AND @recursion = 1) THEN
                            'CONVERT(INT, NULL) '
                        ELSE 
                            'qs.total_elapsed_time / qs.execution_count '
                    END + 
                        'AS avg_elapsed_time 
                FROM
                (
                    SELECT TOP(@i)
                        sp.session_id,
                        sp.request_id,
                        COALESCE(r.logical_reads, s.logical_reads) AS reads,
                        COALESCE(r.reads, s.reads) AS physical_reads,
                        COALESCE(r.writes, s.writes) AS writes,
                        COALESCE(r.CPU_time, s.CPU_time) AS CPU,
                        sp.memory_usage + COALESCE(r.granted_query_memory, 0) AS used_memory,
                        LOWER(sp.status) AS status,
                        COALESCE(r.sql_handle, sp.sql_handle) AS sql_handle,
                        COALESCE(r.statement_start_offset, sp.statement_start_offset) AS statement_start_offset,
                        COALESCE(r.statement_end_offset, sp.statement_end_offset) AS statement_end_offset,
                        ' +
                        CASE
                            WHEN 
                            (
                                @get_task_info <> 0
                                OR @find_block_leaders = 1 
                            ) THEN
                                'sp.wait_type COLLATE Latin1_General_Bin2 AS wait_type,
                                sp.wait_resource COLLATE Latin1_General_Bin2 AS resource_description,
                                sp.wait_time AS wait_duration_ms, 
                                '
                            ELSE
                                ''
                        END +
                        'NULLIF(sp.blocked, 0) AS blocking_session_id,
                        r.plan_handle,
                        NULLIF(r.percent_complete, 0) AS percent_complete,
                        sp.host_name,
                        sp.login_name,
                        sp.program_name,
                        s.host_process_id,
                        COALESCE(r.text_size, s.text_size) AS text_size,
                        COALESCE(r.language, s.language) AS language,
                        COALESCE(r.date_format, s.date_format) AS date_format,
                        COALESCE(r.date_first, s.date_first) AS date_first,
                        COALESCE(r.quoted_identifier, s.quoted_identifier) AS quoted_identifier,
                        COALESCE(r.arithabort, s.arithabort) AS arithabort,
                        COALESCE(r.ansi_null_dflt_on, s.ansi_null_dflt_on) AS ansi_null_dflt_on,
                        COALESCE(r.ansi_defaults, s.ansi_defaults) AS ansi_defaults,
                        COALESCE(r.ansi_warnings, s.ansi_warnings) AS ansi_warnings,
                        COALESCE(r.ansi_padding, s.ansi_padding) AS ansi_padding,
                        COALESCE(r.ansi_nulls, s.ansi_nulls) AS ansi_nulls,
                        COALESCE(r.concat_null_yields_null, s.concat_null_yields_null) AS concat_null_yields_null,
                        COALESCE(r.transaction_isolation_level, s.transaction_isolation_level) AS transaction_isolation_level,
                        COALESCE(r.lock_timeout, s.lock_timeout) AS lock_timeout,
                        COALESCE(r.deadlock_priority, s.deadlock_priority) AS deadlock_priority,
                        COALESCE(r.row_count, s.row_count) AS row_count,
                        COALESCE(r.command, sp.cmd) AS command_type,
                        COALESCE
                        (
                            CASE
                                WHEN
                                (
                                    s.is_user_process = 0
                                    AND r.total_elapsed_time >= 0
                                ) THEN
                                    DATEADD
                                    (
                                        ms,
                                        1000 * (DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())) / 500) - DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())),
                                        DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())
                                    )
                            END,
                            NULLIF(COALESCE(r.start_time, sp.last_request_end_time), CONVERT(DATETIME, ''19000101'', 112)),
                            sp.login_time
                        ) AS start_time,
                        sp.login_time,
                        CASE
                            WHEN s.is_user_process = 1 THEN
                                s.last_request_start_time
                            ELSE
                                COALESCE
                                (
                                    DATEADD
                                    (
                                        ms,
                                        1000 * (DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())) / 500) - DATEPART(ms, DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())),
                                        DATEADD(second, -(r.total_elapsed_time / 1000), GETDATE())
                                    ),
                                    s.last_request_start_time
                                )
                        END AS last_request_start_time,
                        r.transaction_id,
                        sp.database_id,
                        sp.open_tran_count,
                        ' +
                            CASE
                                WHEN EXISTS
                                (
                                    SELECT
                                        *
                                    FROM sys.all_columns AS ac
                                    WHERE
                                        ac.object_id = OBJECT_ID('sys.dm_exec_sessions')
                                        AND ac.name = 'group_id'
                                )
                                    THEN 's.group_id'
                                ELSE 'CONVERT(INT, NULL) AS group_id'
                            END + '
                    FROM @sessions AS sp
                    LEFT OUTER LOOP JOIN sys.dm_exec_sessions AS s ON
                        s.session_id = sp.session_id
                        AND s.login_time = sp.login_time
                    LEFT OUTER LOOP JOIN sys.dm_exec_requests AS r ON
                        sp.status <> ''sleeping''
                        AND r.session_id = sp.session_id
                        AND r.request_id = sp.request_id
                        AND
                        (
                            (
                                s.is_user_process = 0
                                AND sp.is_user_process = 0
                            )
                            OR
                            (
                                r.start_time = s.last_request_start_time
                                AND s.last_request_end_time <= sp.last_request_end_time
                            )
                        )
                ) AS y
                ' + 
                CASE 
                    WHEN @get_task_info = 2 THEN
                        CONVERT(VARCHAR(MAX), '') +
                        'LEFT OUTER HASH JOIN
                        (
                            SELECT TOP(@i)
                                task_nodes.task_node.value(''(session_id/text())[1]'', ''SMALLINT'') AS session_id,
                                task_nodes.task_node.value(''(request_id/text())[1]'', ''INT'') AS request_id,
                                task_nodes.task_node.value(''(physical_io/text())[1]'', ''BIGINT'') AS physical_io,
                                task_nodes.task_node.value(''(context_switches/text())[1]'', ''BIGINT'') AS context_switches,
                                task_nodes.task_node.value(''(tasks/text())[1]'', ''INT'') AS tasks,
                                task_nodes.task_node.value(''(block_info/text())[1]'', ''NVARCHAR(4000)'') AS block_info,
                                task_nodes.task_node.value(''(waits/text())[1]'', ''NVARCHAR(4000)'') AS wait_info,
                                task_nodes.task_node.value(''(thread_CPU_snapshot/text())[1]'', ''BIGINT'') AS thread_CPU_snapshot
                            FROM
                            (
                                SELECT TOP(@i)
                                    CONVERT
                                    (
                                        XML,
                                        REPLACE
                                        (
                                            CONVERT(NVARCHAR(MAX), tasks_raw.task_xml_raw) COLLATE Latin1_General_Bin2,
                                            N''</waits></tasks><tasks><waits>'',
                                            N'', ''
                                        )
                                    ) AS task_xml
                                FROM
                                (
                                    SELECT TOP(@i)
                                        CASE waits.r
                                            WHEN 1 THEN
                                                waits.session_id
                                            ELSE
                                                NULL
                                        END AS [session_id],
                                        CASE waits.r
                                            WHEN 1 THEN
                                                waits.request_id
                                            ELSE
                                                NULL
                                        END AS [request_id],                                            
                                        CASE waits.r
                                            WHEN 1 THEN
                                                waits.physical_io
                                            ELSE
                                                NULL
                                        END AS [physical_io],
                                        CASE waits.r
                                            WHEN 1 THEN
                                                waits.context_switches
                                            ELSE
                                                NULL
                                        END AS [context_switches],
                                        CASE waits.r
                                            WHEN 1 THEN
                                                waits.thread_CPU_snapshot
                                            ELSE
                                                NULL
                                        END AS [thread_CPU_snapshot],
                                        CASE waits.r
                                            WHEN 1 THEN
                                                waits.tasks
                                            ELSE
                                                NULL
                                        END AS [tasks],
                                        CASE waits.r
                                            WHEN 1 THEN
                                                waits.block_info
                                            ELSE
                                                NULL
                                        END AS [block_info],
                                        REPLACE
                                        (
                                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                                CONVERT
                                                (
                                                    NVARCHAR(MAX),
                                                    N''('' +
                                                        CONVERT(NVARCHAR, num_waits) + N''x: '' +
                                                        CASE num_waits
                                                            WHEN 1 THEN
                                                                CONVERT(NVARCHAR, min_wait_time) + N''ms''
                                                            WHEN 2 THEN
                                                                CASE
                                                                    WHEN min_wait_time <> max_wait_time THEN
                                                                        CONVERT(NVARCHAR, min_wait_time) + N''/'' + CONVERT(NVARCHAR, max_wait_time) + N''ms''
                                                                    ELSE
                                                                        CONVERT(NVARCHAR, max_wait_time) + N''ms''
                                                                END
                                                            ELSE
                                                                CASE
                                                                    WHEN min_wait_time <> max_wait_time THEN
                                                                        CONVERT(NVARCHAR, min_wait_time) + N''/'' + CONVERT(NVARCHAR, avg_wait_time) + N''/'' + CONVERT(NVARCHAR, max_wait_time) + N''ms''
                                                                    ELSE 
                                                                        CONVERT(NVARCHAR, max_wait_time) + N''ms''
                                                                END
                                                        END +
                                                    N'')'' + wait_type COLLATE Latin1_General_Bin2
                                                ),
                                                NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''),
                                                NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''),
                                                NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''),
                                            NCHAR(0),
                                            N''''
                                        ) AS [waits]
                                    FROM
                                    (
                                        SELECT TOP(@i)
                                            w1.*,
                                            ROW_NUMBER() OVER
                                            (
                                                PARTITION BY
                                                    w1.session_id,
                                                    w1.request_id
                                                ORDER BY
                                                    w1.block_info DESC,
                                                    w1.num_waits DESC,
                                                    w1.wait_type
                                            ) AS r
                                        FROM
                                        (
                                            SELECT TOP(@i)
                                                task_info.session_id,
                                                task_info.request_id,
                                                task_info.physical_io,
                                                task_info.context_switches,
                                                task_info.thread_CPU_snapshot,
                                                task_info.num_tasks AS tasks,
                                                CASE
                                                    WHEN task_info.runnable_time IS NOT NULL THEN
                                                        ''RUNNABLE''
                                                    ELSE
                                                        wt2.wait_type
                                                END AS wait_type,
                                                NULLIF(COUNT(COALESCE(task_info.runnable_time, wt2.waiting_task_address)), 0) AS num_waits,
                                                MIN(COALESCE(task_info.runnable_time, wt2.wait_duration_ms)) AS min_wait_time,
                                                AVG(COALESCE(task_info.runnable_time, wt2.wait_duration_ms)) AS avg_wait_time,
                                                MAX(COALESCE(task_info.runnable_time, wt2.wait_duration_ms)) AS max_wait_time,
                                                MAX(wt2.block_info) AS block_info
                                            FROM
                                            (
                                                SELECT TOP(@i)
                                                    t.session_id,
                                                    t.request_id,
                                                    SUM(CONVERT(BIGINT, t.pending_io_count)) OVER (PARTITION BY t.session_id, t.request_id) AS physical_io,
                                                    SUM(CONVERT(BIGINT, t.context_switches_count)) OVER (PARTITION BY t.session_id, t.request_id) AS context_switches, 
                                                    ' +
                                                    CASE
                                                        WHEN 
                                                            @output_column_list LIKE '%|[CPU_delta|]%' ESCAPE '|'
                                                            AND @sys_info = 1
                                                            THEN
                                                                'SUM(tr.usermode_time + tr.kernel_time) OVER (PARTITION BY t.session_id, t.request_id) '
                                                        ELSE
                                                            'CONVERT(BIGINT, NULL) '
                                                    END + 
                                                        ' AS thread_CPU_snapshot, 
                                                    COUNT(*) OVER (PARTITION BY t.session_id, t.request_id) AS num_tasks,
                                                    t.task_address,
                                                    t.task_state,
                                                    CASE
                                                        WHEN
                                                            t.task_state = ''RUNNABLE''
                                                            AND w.runnable_time > 0 THEN
                                                                w.runnable_time
                                                        ELSE
                                                            NULL
                                                    END AS runnable_time
                                                FROM sys.dm_os_tasks AS t
                                                CROSS APPLY
                                                (
                                                    SELECT TOP(1)
                                                        sp2.session_id
                                                    FROM @sessions AS sp2
                                                    WHERE
                                                        sp2.session_id = t.session_id
                                                        AND sp2.request_id = t.request_id
                                                        AND sp2.status <> ''sleeping''
                                                ) AS sp20
                                                LEFT OUTER HASH JOIN
                                                ( 
                                                ' +
                                                    CASE
                                                        WHEN @sys_info = 1 THEN
                                                            'SELECT TOP(@i)
                                                                (
                                                                    SELECT TOP(@i)
                                                                        ms_ticks
                                                                    FROM sys.dm_os_sys_info
                                                                ) -
                                                                    w0.wait_resumed_ms_ticks AS runnable_time,
                                                                w0.worker_address,
                                                                w0.thread_address,
                                                                w0.task_bound_ms_ticks
                                                            FROM sys.dm_os_workers AS w0
                                                            WHERE
                                                                w0.state = ''RUNNABLE''
                                                                OR @first_collection_ms_ticks >= w0.task_bound_ms_ticks'
                                                        ELSE
                                                            'SELECT
                                                                CONVERT(BIGINT, NULL) AS runnable_time,
                                                                CONVERT(VARBINARY(8), NULL) AS worker_address,
                                                                CONVERT(VARBINARY(8), NULL) AS thread_address,
                                                                CONVERT(BIGINT, NULL) AS task_bound_ms_ticks
                                                            WHERE
                                                                1 = 0'
                                                        END +
                                                '
                                                ) AS w ON
                                                    w.worker_address = t.worker_address 
                                                ' +
                                                CASE
                                                    WHEN
                                                        @output_column_list LIKE '%|[CPU_delta|]%' ESCAPE '|'
                                                        AND @sys_info = 1
                                                        THEN
                                                            'LEFT OUTER HASH JOIN sys.dm_os_threads AS tr ON
                                                                tr.thread_address = w.thread_address
                                                                AND @first_collection_ms_ticks >= w.task_bound_ms_ticks
                                                            '
                                                    ELSE
                                                        ''
                                                END +
                                            ') AS task_info
                                            LEFT OUTER HASH JOIN
                                            (
                                                SELECT TOP(@i)
                                                    wt1.wait_type,
                                                    wt1.waiting_task_address,
                                                    MAX(wt1.wait_duration_ms) AS wait_duration_ms,
                                                    MAX(wt1.block_info) AS block_info
                                                FROM
                                                (
                                                    SELECT DISTINCT TOP(@i)
                                                        wt.wait_type +
                                                            CASE
                                                                WHEN wt.wait_type LIKE N''PAGE%LATCH_%'' THEN
                                                                    '':'' +
                                                                    COALESCE(DB_NAME(CONVERT(INT, LEFT(wt.resource_description, CHARINDEX(N'':'', wt.resource_description) - 1))), N''(null)'') +
                                                                    N'':'' +
                                                                    SUBSTRING(wt.resource_description, CHARINDEX(N'':'', wt.resource_description) + 1, LEN(wt.resource_description) - CHARINDEX(N'':'', REVERSE(wt.resource_description)) - CHARINDEX(N'':'', wt.resource_description)) +
                                                                    N''('' +
                                                                        CASE
                                                                            WHEN
                                                                                CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 1 OR
                                                                                CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) % 8088 = 0
                                                                                    THEN 
                                                                                        N''PFS''
                                                                            WHEN
                                                                                CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 2 OR
                                                                                CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) % 511232 = 0 
                                                                                    THEN 
                                                                                        N''GAM''
                                                                            WHEN
                                                                                CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 3 OR
                                                                                (CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) - 1) % 511232 = 0 
                                                                                    THEN 
                                                                                        N''SGAM''
                                                                            WHEN
                                                                                CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 6 OR
                                                                                (CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) - 6) % 511232 = 0 
                                                                                    THEN 
                                                                                        N''DCM''
                                                                            WHEN
                                                                                CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) = 7 OR
                                                                                (CONVERT(INT, RIGHT(wt.resource_description, CHARINDEX(N'':'', REVERSE(wt.resource_description)) - 1)) - 7) % 511232 = 0
                                                                                    THEN 
                                                                                        N''BCM''
                                                                            ELSE
                                                                                N''*''
                                                                        END +
                                                                    N'')''
                                                                WHEN wt.wait_type = N''CXPACKET'' THEN
                                                                    N'':'' + SUBSTRING(wt.resource_description, CHARINDEX(N''nodeId'', wt.resource_description) + 7, 4)
                                                                WHEN wt.wait_type LIKE N''LATCH[_]%'' THEN
                                                                    N'' ['' + LEFT(wt.resource_description, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description), 0), LEN(wt.resource_description) + 1) - 1) + N'']''
                                                                ELSE 
                                                                    N''''
                                                            END COLLATE Latin1_General_Bin2 AS wait_type,
                                                        CASE
                                                            WHEN
                                                            (
                                                                wt.blocking_session_id IS NOT NULL
                                                                AND wt.wait_type LIKE N''LCK[_]%''
                                                            ) THEN
                                                                (
                                                                    SELECT TOP(@i)
                                                                        x.lock_type,
                                                                        REPLACE
                                                                        (
                                                                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                                                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                                                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                                                                DB_NAME
                                                                                (
                                                                                    CONVERT
                                                                                    (
                                                                                        INT,
                                                                                        SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''dbid='', wt.resource_description), 0) + 5, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''dbid='', wt.resource_description) + 5), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''dbid='', wt.resource_description) - 5)
                                                                                    )
                                                                                ),
                                                                                NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''),
                                                                                NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''),
                                                                                NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''),
                                                                            NCHAR(0),
                                                                            N''''
                                                                        ) AS database_name,
                                                                        CASE x.lock_type
                                                                            WHEN N''objectlock'' THEN
                                                                                SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''objid='', wt.resource_description), 0) + 6, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''objid='', wt.resource_description) + 6), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''objid='', wt.resource_description) - 6)
                                                                            ELSE
                                                                                NULL
                                                                        END AS object_id,
                                                                        CASE x.lock_type
                                                                            WHEN N''filelock'' THEN
                                                                                SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''fileid='', wt.resource_description), 0) + 7, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''fileid='', wt.resource_description) + 7), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''fileid='', wt.resource_description) - 7)
                                                                            ELSE
                                                                                NULL
                                                                        END AS file_id,
                                                                        CASE
                                                                            WHEN x.lock_type in (N''pagelock'', N''extentlock'', N''ridlock'') THEN
                                                                                SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''associatedObjectId='', wt.resource_description), 0) + 19, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''associatedObjectId='', wt.resource_description) + 19), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''associatedObjectId='', wt.resource_description) - 19)
                                                                            WHEN x.lock_type in (N''keylock'', N''hobtlock'', N''allocunitlock'') THEN
                                                                                SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''hobtid='', wt.resource_description), 0) + 7, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''hobtid='', wt.resource_description) + 7), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''hobtid='', wt.resource_description) - 7)
                                                                            ELSE
                                                                                NULL
                                                                        END AS hobt_id,
                                                                        CASE x.lock_type
                                                                            WHEN N''applicationlock'' THEN
                                                                                SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''hash='', wt.resource_description), 0) + 5, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''hash='', wt.resource_description) + 5), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''hash='', wt.resource_description) - 5)
                                                                            ELSE
                                                                                NULL
                                                                        END AS applock_hash,
                                                                        CASE x.lock_type
                                                                            WHEN N''metadatalock'' THEN
                                                                                SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''subresource='', wt.resource_description), 0) + 12, COALESCE(NULLIF(CHARINDEX(N'' '', wt.resource_description, CHARINDEX(N''subresource='', wt.resource_description) + 12), 0), LEN(wt.resource_description) + 1) - CHARINDEX(N''subresource='', wt.resource_description) - 12)
                                                                            ELSE
                                                                                NULL
                                                                        END AS metadata_resource,
                                                                        CASE x.lock_type
                                                                            WHEN N''metadatalock'' THEN
                                                                                SUBSTRING(wt.resource_description, NULLIF(CHARINDEX(N''classid='', wt.resource_description), 0) + 8, COALESCE(NULLIF(CHARINDEX(N'' dbid='', wt.resource_description) - CHARINDEX(N''classid='', wt.resource_description), 0), LEN(wt.resource_description) + 1) - 8)
                                                                            ELSE
                                                                                NULL
                                                                        END AS metadata_class_id
                                                                    FROM
                                                                    (
                                                                        SELECT TOP(1)
                                                                            LEFT(wt.resource_description, CHARINDEX(N'' '', wt.resource_description) - 1) COLLATE Latin1_General_Bin2 AS lock_type
                                                                    ) AS x
                                                                    FOR XML
                                                                        PATH('''')
                                                                )
                                                            ELSE NULL
                                                        END AS block_info,
                                                        wt.wait_duration_ms,
                                                        wt.waiting_task_address
                                                    FROM
                                                    (
                                                        SELECT TOP(@i)
                                                            wt0.wait_type COLLATE Latin1_General_Bin2 AS wait_type,
                                                            wt0.resource_description COLLATE Latin1_General_Bin2 AS resource_description,
                                                            wt0.wait_duration_ms,
                                                            wt0.waiting_task_address,
                                                            CASE
                                                                WHEN wt0.blocking_session_id = p.blocked THEN
                                                                    wt0.blocking_session_id
                                                                ELSE
                                                                    NULL
                                                            END AS blocking_session_id
                                                        FROM sys.dm_os_waiting_tasks AS wt0
                                                        CROSS APPLY
                                                        (
                                                            SELECT TOP(1)
                                                                s0.blocked
                                                            FROM @sessions AS s0
                                                            WHERE
                                                                s0.session_id = wt0.session_id
                                                                AND COALESCE(s0.wait_type, N'''') <> N''OLEDB''
                                                                AND wt0.wait_type <> N''OLEDB''
                                                        ) AS p
                                                    ) AS wt
                                                ) AS wt1
                                                GROUP BY
                                                    wt1.wait_type,
                                                    wt1.waiting_task_address
                                            ) AS wt2 ON
                                                wt2.waiting_task_address = task_info.task_address
                                                AND wt2.wait_duration_ms > 0
                                                AND task_info.runnable_time IS NULL
                                            GROUP BY
                                                task_info.session_id,
                                                task_info.request_id,
                                                task_info.physical_io,
                                                task_info.context_switches,
                                                task_info.thread_CPU_snapshot,
                                                task_info.num_tasks,
                                                CASE
                                                    WHEN task_info.runnable_time IS NOT NULL THEN
                                                        ''RUNNABLE''
                                                    ELSE
                                                        wt2.wait_type
                                                END
                                        ) AS w1
                                    ) AS waits
                                    ORDER BY
                                        waits.session_id,
                                        waits.request_id,
                                        waits.r
                                    FOR XML
                                        PATH(N''tasks''),
                                        TYPE
                                ) AS tasks_raw (task_xml_raw)
                            ) AS tasks_final
                            CROSS APPLY tasks_final.task_xml.nodes(N''/tasks'') AS task_nodes (task_node)
                            WHERE
                                task_nodes.task_node.exist(N''session_id'') = 1
                        ) AS tasks ON
                            tasks.session_id = y.session_id
                            AND tasks.request_id = y.request_id 
                        '
                    ELSE
                        ''
                END +
                'LEFT OUTER HASH JOIN
                (
                    SELECT TOP(@i)
                        t_info.session_id,
                        COALESCE(t_info.request_id, -1) AS request_id,
                        SUM(t_info.tempdb_allocations) AS tempdb_allocations,
                        SUM(t_info.tempdb_current) AS tempdb_current
                    FROM
                    (
                        SELECT TOP(@i)
                            tsu.session_id,
                            tsu.request_id,
                            tsu.user_objects_alloc_page_count +
                                tsu.internal_objects_alloc_page_count AS tempdb_allocations,
                            tsu.user_objects_alloc_page_count +
                                tsu.internal_objects_alloc_page_count -
                                tsu.user_objects_dealloc_page_count -
                                tsu.internal_objects_dealloc_page_count AS tempdb_current
                        FROM sys.dm_db_task_space_usage AS tsu
                        CROSS APPLY
                        (
                            SELECT TOP(1)
                                s0.session_id
                            FROM @sessions AS s0
                            WHERE
                                s0.session_id = tsu.session_id
                        ) AS p

                        UNION ALL

                        SELECT TOP(@i)
                            ssu.session_id,
                            NULL AS request_id,
                            ssu.user_objects_alloc_page_count +
                                ssu.internal_objects_alloc_page_count AS tempdb_allocations,
                            ssu.user_objects_alloc_page_count +
                                ssu.internal_objects_alloc_page_count -
                                ssu.user_objects_dealloc_page_count -
                                ssu.internal_objects_dealloc_page_count AS tempdb_current
                        FROM sys.dm_db_session_space_usage AS ssu
                        CROSS APPLY
                        (
                            SELECT TOP(1)
                                s0.session_id
                            FROM @sessions AS s0
                            WHERE
                                s0.session_id = ssu.session_id
                        ) AS p
                    ) AS t_info
                    GROUP BY
                        t_info.session_id,
                        COALESCE(t_info.request_id, -1)
                ) AS tempdb_info ON
                    tempdb_info.session_id = y.session_id
                    AND tempdb_info.request_id =
                        CASE
                            WHEN y.status = N''sleeping'' THEN
                                -1
                            ELSE
                                y.request_id
                        END
                ' +
                CASE 
                    WHEN 
                        NOT 
                        (
                            @get_avg_time = 1 
                            AND @recursion = 1
                        ) THEN 
                            ''
                    ELSE
                        'LEFT OUTER HASH JOIN
                        (
                            SELECT TOP(@i)
                                *
                            FROM sys.dm_exec_query_stats
                        ) AS qs ON
                            qs.sql_handle = y.sql_handle
                            AND qs.plan_handle = y.plan_handle
                            AND qs.statement_start_offset = y.statement_start_offset
                            AND qs.statement_end_offset = y.statement_end_offset
                        '
                END + 
            ') AS x
            OPTION (KEEPFIXED PLAN, OPTIMIZE FOR (@i = 1)); ';

        SET @sql_n = CONVERT(NVARCHAR(MAX), @sql);

        SET @last_collection_start = GETDATE();

        IF 
            @recursion = -1
            AND @sys_info = 1
        BEGIN;
            SELECT
                @first_collection_ms_ticks = ms_ticks
            FROM sys.dm_os_sys_info;
        END;

        INSERT #sessions
        (
            recursion,
            session_id,
            request_id,
            session_number,
            elapsed_time,
            avg_elapsed_time,
            physical_io,
            reads,
            physical_reads,
            writes,
            tempdb_allocations,
            tempdb_current,
            CPU,
            thread_CPU_snapshot,
            context_switches,
            used_memory,
            tasks,
            status,
            wait_info,
            transaction_id,
            open_tran_count,
            sql_handle,
            statement_start_offset,
            statement_end_offset,       
            sql_text,
            plan_handle,
            blocking_session_id,
            percent_complete,
            host_name,
            login_name,
            database_name,
            program_name,
            additional_info,
            start_time,
            login_time,
            last_request_start_time
        )
        EXEC sp_executesql 
            @sql_n,
            N'@recursion SMALLINT, @filter sysname, @not_filter sysname, @first_collection_ms_ticks BIGINT',
            @recursion, @filter, @not_filter, @first_collection_ms_ticks;

        --Collect transaction information?
        IF
            @recursion = 1
            AND
            (
                @output_column_list LIKE '%|[tran_start_time|]%' ESCAPE '|'
                OR @output_column_list LIKE '%|[tran_log_writes|]%' ESCAPE '|' 
            )
        BEGIN;  
            DECLARE @i INT;
            SET @i = 2147483647;

            UPDATE s
            SET
                tran_start_time =
                    CONVERT
                    (
                        DATETIME,
                        LEFT
                        (
                            x.trans_info,
                            NULLIF(CHARINDEX(NCHAR(254) COLLATE Latin1_General_Bin2, x.trans_info) - 1, -1)
                        ),
                        121
                    ),
                tran_log_writes =
                    RIGHT
                    (
                        x.trans_info,
                        LEN(x.trans_info) - CHARINDEX(NCHAR(254) COLLATE Latin1_General_Bin2, x.trans_info)
                    )
            FROM
            (
                SELECT TOP(@i)
                    trans_nodes.trans_node.value('(session_id/text())[1]', 'SMALLINT') AS session_id,
                    COALESCE(trans_nodes.trans_node.value('(request_id/text())[1]', 'INT'), 0) AS request_id,
                    trans_nodes.trans_node.value('(trans_info/text())[1]', 'NVARCHAR(4000)') AS trans_info              
                FROM
                (
                    SELECT TOP(@i)
                        CONVERT
                        (
                            XML,
                            REPLACE
                            (
                                CONVERT(NVARCHAR(MAX), trans_raw.trans_xml_raw) COLLATE Latin1_General_Bin2, 
                                N'</trans_info></trans><trans><trans_info>', N''
                            )
                        )
                    FROM
                    (
                        SELECT TOP(@i)
                            CASE u_trans.r
                                WHEN 1 THEN u_trans.session_id
                                ELSE NULL
                            END AS [session_id],
                            CASE u_trans.r
                                WHEN 1 THEN u_trans.request_id
                                ELSE NULL
                            END AS [request_id],
                            CONVERT
                            (
                                NVARCHAR(MAX),
                                CASE
                                    WHEN u_trans.database_id IS NOT NULL THEN
                                        CASE u_trans.r
                                            WHEN 1 THEN COALESCE(CONVERT(NVARCHAR, u_trans.transaction_start_time, 121) + NCHAR(254), N'')
                                            ELSE N''
                                        END + 
                                            REPLACE
                                            (
                                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                                    CONVERT(VARCHAR(128), COALESCE(DB_NAME(u_trans.database_id), N'(null)')),
                                                    NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
                                                    NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
                                                    NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
                                                NCHAR(0),
                                                N'?'
                                            ) +
                                            N': ' +
                                        CONVERT(NVARCHAR, u_trans.log_record_count) + N' (' + CONVERT(NVARCHAR, u_trans.log_kb_used) + N' kB)' +
                                        N','
                                    ELSE
                                        N'N/A,'
                                END COLLATE Latin1_General_Bin2
                            ) AS [trans_info]
                        FROM
                        (
                            SELECT TOP(@i)
                                trans.*,
                                ROW_NUMBER() OVER
                                (
                                    PARTITION BY
                                        trans.session_id,
                                        trans.request_id
                                    ORDER BY
                                        trans.transaction_start_time DESC
                                ) AS r
                            FROM
                            (
                                SELECT TOP(@i)
                                    session_tran_map.session_id,
                                    session_tran_map.request_id,
                                    s_tran.database_id,
                                    COALESCE(SUM(s_tran.database_transaction_log_record_count), 0) AS log_record_count,
                                    COALESCE(SUM(s_tran.database_transaction_log_bytes_used), 0) / 1024 AS log_kb_used,
                                    MIN(s_tran.database_transaction_begin_time) AS transaction_start_time
                                FROM
                                (
                                    SELECT TOP(@i)
                                        *
                                    FROM sys.dm_tran_active_transactions
                                    WHERE
                                        transaction_begin_time <= @last_collection_start
                                ) AS a_tran
                                INNER HASH JOIN
                                (
                                    SELECT TOP(@i)
                                        *
                                    FROM sys.dm_tran_database_transactions
                                    WHERE
                                        database_id < 32767
                                ) AS s_tran ON
                                    s_tran.transaction_id = a_tran.transaction_id
                                LEFT OUTER HASH JOIN
                                (
                                    SELECT TOP(@i)
                                        *
                                    FROM sys.dm_tran_session_transactions
                                ) AS tst ON
                                    s_tran.transaction_id = tst.transaction_id
                                CROSS APPLY
                                (
                                    SELECT TOP(1)
                                        s3.session_id,
                                        s3.request_id
                                    FROM
                                    (
                                        SELECT TOP(1)
                                            s1.session_id,
                                            s1.request_id
                                        FROM #sessions AS s1
                                        WHERE
                                            s1.transaction_id = s_tran.transaction_id
                                            AND s1.recursion = 1
                                            
                                        UNION ALL
                                    
                                        SELECT TOP(1)
                                            s2.session_id,
                                            s2.request_id
                                        FROM #sessions AS s2
                                        WHERE
                                            s2.session_id = tst.session_id
                                            AND s2.recursion = 1
                                    ) AS s3
                                    ORDER BY
                                        s3.request_id
                                ) AS session_tran_map
                                GROUP BY
                                    session_tran_map.session_id,
                                    session_tran_map.request_id,
                                    s_tran.database_id
                            ) AS trans
                        ) AS u_trans
                        FOR XML
                            PATH('trans'),
                            TYPE
                    ) AS trans_raw (trans_xml_raw)
                ) AS trans_final (trans_xml)
                CROSS APPLY trans_final.trans_xml.nodes('/trans') AS trans_nodes (trans_node)
            ) AS x
            INNER HASH JOIN #sessions AS s ON
                s.session_id = x.session_id
                AND s.request_id = x.request_id
            OPTION (OPTIMIZE FOR (@i = 1));
        END;

        --Variables for text and plan collection
        DECLARE 
            @session_id SMALLINT,
            @request_id INT,
            @sql_handle VARBINARY(64),
            @plan_handle VARBINARY(64),
            @statement_start_offset INT,
            @statement_end_offset INT,
            @start_time DATETIME,
            @database_name sysname;

        IF 
            @recursion = 1
            AND @output_column_list LIKE '%|[sql_text|]%' ESCAPE '|'
        BEGIN;
            DECLARE sql_cursor
            CURSOR LOCAL FAST_FORWARD
            FOR 
                SELECT 
                    session_id,
                    request_id,
                    sql_handle,
                    statement_start_offset,
                    statement_end_offset
                FROM #sessions
                WHERE
                    recursion = 1
                    AND sql_handle IS NOT NULL
            OPTION (KEEPFIXED PLAN);

            OPEN sql_cursor;

            FETCH NEXT FROM sql_cursor
            INTO 
                @session_id,
                @request_id,
                @sql_handle,
                @statement_start_offset,
                @statement_end_offset;

            --Wait up to 5 ms for the SQL text, then give up
            SET LOCK_TIMEOUT 5;

            WHILE @@FETCH_STATUS = 0
            BEGIN;
                BEGIN TRY;
                    UPDATE s
                    SET
                        s.sql_text =
                        (
                            SELECT
                                REPLACE
                                (
                                    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                        N'--' + NCHAR(13) + NCHAR(10) +
                                        CASE 
                                            WHEN @get_full_inner_text = 1 THEN est.text
                                            WHEN LEN(est.text) < (@statement_end_offset / 2) + 1 THEN est.text
                                            WHEN SUBSTRING(est.text, (@statement_start_offset/2), 2) LIKE N'[a-zA-Z0-9][a-zA-Z0-9]' THEN est.text
                                            ELSE
                                                CASE
                                                    WHEN @statement_start_offset > 0 THEN
                                                        SUBSTRING
                                                        (
                                                            est.text,
                                                            ((@statement_start_offset/2) + 1),
                                                            (
                                                                CASE
                                                                    WHEN @statement_end_offset = -1 THEN 2147483647
                                                                    ELSE ((@statement_end_offset - @statement_start_offset)/2) + 1
                                                                END
                                                            )
                                                        )
                                                    ELSE RTRIM(LTRIM(est.text))
                                                END
                                        END +
                                        NCHAR(13) + NCHAR(10) + N'--' COLLATE Latin1_General_Bin2,
                                        NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
                                        NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
                                        NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
                                    NCHAR(0),
                                    N''
                                ) AS [processing-instruction(query)]
                            FOR XML
                                PATH(''),
                                TYPE
                        ),
                        s.statement_start_offset = 
                            CASE 
                                WHEN LEN(est.text) < (@statement_end_offset / 2) + 1 THEN 0
                                WHEN SUBSTRING(CONVERT(VARCHAR(MAX), est.text), (@statement_start_offset/2), 2) LIKE '[a-zA-Z0-9][a-zA-Z0-9]' THEN 0
                                ELSE @statement_start_offset
                            END,
                        s.statement_end_offset = 
                            CASE 
                                WHEN LEN(est.text) < (@statement_end_offset / 2) + 1 THEN -1
                                WHEN SUBSTRING(CONVERT(VARCHAR(MAX), est.text), (@statement_start_offset/2), 2) LIKE '[a-zA-Z0-9][a-zA-Z0-9]' THEN -1
                                ELSE @statement_end_offset
                            END
                    FROM 
                        #sessions AS s,
                        (
                            SELECT TOP(1)
                                text
                            FROM
                            (
                                SELECT 
                                    text, 
                                    0 AS row_num
                                FROM sys.dm_exec_sql_text(@sql_handle)
                                
                                UNION ALL
                                
                                SELECT 
                                    NULL,
                                    1 AS row_num
                            ) AS est0
                            ORDER BY
                                row_num
                        ) AS est
                    WHERE 
                        s.session_id = @session_id
                        AND s.request_id = @request_id
                        AND s.recursion = 1
                    OPTION (KEEPFIXED PLAN);
                END TRY
                BEGIN CATCH;
                    UPDATE s
                    SET
                        s.sql_text = 
                            CASE ERROR_NUMBER() 
                                WHEN 1222 THEN '<timeout_exceeded />'
                                ELSE '<error message="' + ERROR_MESSAGE() + '" />'
                            END
                    FROM #sessions AS s
                    WHERE 
                        s.session_id = @session_id
                        AND s.request_id = @request_id
                        AND s.recursion = 1
                    OPTION (KEEPFIXED PLAN);
                END CATCH;

                FETCH NEXT FROM sql_cursor
                INTO
                    @session_id,
                    @request_id,
                    @sql_handle,
                    @statement_start_offset,
                    @statement_end_offset;
            END;

            --Return this to the default
            SET LOCK_TIMEOUT -1;

            CLOSE sql_cursor;
            DEALLOCATE sql_cursor;
        END;

        IF 
            @get_outer_command = 1 
            AND @recursion = 1
            AND @output_column_list LIKE '%|[sql_command|]%' ESCAPE '|'
        BEGIN;
            DECLARE @buffer_results TABLE
            (
                EventType VARCHAR(30),
                Parameters INT,
                EventInfo NVARCHAR(4000),
                start_time DATETIME,
                session_number INT IDENTITY(1,1) NOT NULL PRIMARY KEY
            );

            DECLARE buffer_cursor
            CURSOR LOCAL FAST_FORWARD
            FOR 
                SELECT 
                    session_id,
                    MAX(start_time) AS start_time
                FROM #sessions
                WHERE
                    recursion = 1
                GROUP BY
                    session_id
                ORDER BY
                    session_id
                OPTION (KEEPFIXED PLAN);

            OPEN buffer_cursor;

            FETCH NEXT FROM buffer_cursor
            INTO 
                @session_id,
                @start_time;

            WHILE @@FETCH_STATUS = 0
            BEGIN;
                BEGIN TRY;
                    --In SQL Server 2008, DBCC INPUTBUFFER will throw 
                    --an exception if the session no longer exists
                    INSERT @buffer_results
                    (
                        EventType,
                        Parameters,
                        EventInfo
                    )
                    EXEC sp_executesql
                        N'DBCC INPUTBUFFER(@session_id) WITH NO_INFOMSGS;',
                        N'@session_id SMALLINT',
                        @session_id;

                    UPDATE br
                    SET
                        br.start_time = @start_time
                    FROM @buffer_results AS br
                    WHERE
                        br.session_number = 
                        (
                            SELECT MAX(br2.session_number)
                            FROM @buffer_results br2
                        );
                END TRY
                BEGIN CATCH
                END CATCH;

                FETCH NEXT FROM buffer_cursor
                INTO 
                    @session_id,
                    @start_time;
            END;

            UPDATE s
            SET
                sql_command = 
                (
                    SELECT 
                        REPLACE
                        (
                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                CONVERT
                                (
                                    NVARCHAR(MAX),
                                    N'--' + NCHAR(13) + NCHAR(10) + br.EventInfo + NCHAR(13) + NCHAR(10) + N'--' COLLATE Latin1_General_Bin2
                                ),
                                NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
                                NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
                                NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
                            NCHAR(0),
                            N''
                        ) AS [processing-instruction(query)]
                    FROM @buffer_results AS br
                    WHERE 
                        br.session_number = s.session_number
                        AND br.start_time = s.start_time
                        AND 
                        (
                            (
                                s.start_time = s.last_request_start_time
                                AND EXISTS
                                (
                                    SELECT *
                                    FROM sys.dm_exec_requests r2
                                    WHERE
                                        r2.session_id = s.session_id
                                        AND r2.request_id = s.request_id
                                        AND r2.start_time = s.start_time
                                )
                            )
                            OR 
                            (
                                s.request_id = 0
                                AND EXISTS
                                (
                                    SELECT *
                                    FROM sys.dm_exec_sessions s2
                                    WHERE
                                        s2.session_id = s.session_id
                                        AND s2.last_request_start_time = s.last_request_start_time
                                )
                            )
                        )
                    FOR XML
                        PATH(''),
                        TYPE
                )
            FROM #sessions AS s
            WHERE
                recursion = 1
            OPTION (KEEPFIXED PLAN);

            CLOSE buffer_cursor;
            DEALLOCATE buffer_cursor;
        END;

        IF 
            @get_plans >= 1 
            AND @recursion = 1
            AND @output_column_list LIKE '%|[query_plan|]%' ESCAPE '|'
        BEGIN;
            DECLARE @live_plan BIT;
            SET @live_plan = ISNULL(CONVERT(BIT, SIGN(OBJECT_ID('sys.dm_exec_query_statistics_xml'))), 0)

            DECLARE plan_cursor
            CURSOR LOCAL FAST_FORWARD
            FOR 
                SELECT
                    session_id,
                    request_id,
                    plan_handle,
                    statement_start_offset,
                    statement_end_offset
                FROM #sessions
                WHERE
                    recursion = 1
                    AND plan_handle IS NOT NULL
            OPTION (KEEPFIXED PLAN);

            OPEN plan_cursor;

            FETCH NEXT FROM plan_cursor
            INTO 
                @session_id,
                @request_id,
                @plan_handle,
                @statement_start_offset,
                @statement_end_offset;

            --Wait up to 5 ms for a query plan, then give up
            SET LOCK_TIMEOUT 5;

            WHILE @@FETCH_STATUS = 0
            BEGIN;
                DECLARE @query_plan XML;
                SET @query_plan = NULL;

                IF @live_plan = 1
                BEGIN;
                    BEGIN TRY;
                        SELECT
                            @query_plan = x.query_plan
                        FROM sys.dm_exec_query_statistics_xml(@session_id) AS x;

                        IF 
                            @query_plan IS NOT NULL
                            AND EXISTS
                            (
                                SELECT
                                    *
                                FROM sys.dm_exec_requests AS r
                                WHERE
                                    r.session_id = @session_id
                                    AND r.request_id = @request_id
                                    AND r.plan_handle = @plan_handle
                                    AND r.statement_start_offset = @statement_start_offset
                                    AND r.statement_end_offset = @statement_end_offset
                            )
                        BEGIN;
                            UPDATE s
                            SET
                                s.query_plan = @query_plan
                            FROM #sessions AS s
                            WHERE 
                                s.session_id = @session_id
                                AND s.request_id = @request_id
                                AND s.recursion = 1
                            OPTION (KEEPFIXED PLAN);
                        END;
                    END TRY
                    BEGIN CATCH;
                        SET @query_plan = NULL;
                    END CATCH;
                END;

                IF @query_plan IS NULL
                BEGIN;
                    BEGIN TRY;
                        UPDATE s
                        SET
                            s.query_plan =
                            (
                                SELECT
                                    CONVERT(xml, query_plan)
                                FROM sys.dm_exec_text_query_plan
                                (
                                    @plan_handle, 
                                    CASE @get_plans
                                        WHEN 1 THEN
                                            @statement_start_offset
                                        ELSE
                                            0
                                    END, 
                                    CASE @get_plans
                                        WHEN 1 THEN
                                            @statement_end_offset
                                        ELSE
                                            -1
                                    END
                                )
                            )
                        FROM #sessions AS s
                        WHERE 
                            s.session_id = @session_id
                            AND s.request_id = @request_id
                            AND s.recursion = 1
                        OPTION (KEEPFIXED PLAN);
                    END TRY
                    BEGIN CATCH;
                        IF ERROR_NUMBER() = 6335
                        BEGIN;
                            UPDATE s
                            SET
                                s.query_plan =
                                (
                                    SELECT
                                        N'--' + NCHAR(13) + NCHAR(10) + 
                                        N'-- Could not render showplan due to XML data type limitations. ' + NCHAR(13) + NCHAR(10) + 
                                        N'-- To see the graphical plan save the XML below as a .SQLPLAN file and re-open in SSMS.' + NCHAR(13) + NCHAR(10) +
                                        N'--' + NCHAR(13) + NCHAR(10) +
                                            REPLACE(qp.query_plan, N'<RelOp', NCHAR(13)+NCHAR(10)+N'<RelOp') + 
                                            NCHAR(13) + NCHAR(10) + N'--' COLLATE Latin1_General_Bin2 AS [processing-instruction(query_plan)]
                                    FROM sys.dm_exec_text_query_plan
                                    (
                                        @plan_handle, 
                                        CASE @get_plans
                                            WHEN 1 THEN
                                                @statement_start_offset
                                            ELSE
                                                0
                                        END, 
                                        CASE @get_plans
                                            WHEN 1 THEN
                                                @statement_end_offset
                                            ELSE
                                                -1
                                        END
                                    ) AS qp
                                    FOR XML
                                        PATH(''),
                                        TYPE
                                )
                            FROM #sessions AS s
                            WHERE 
                                s.session_id = @session_id
                                AND s.request_id = @request_id
                                AND s.recursion = 1
                            OPTION (KEEPFIXED PLAN);
                        END;
                        ELSE
                        BEGIN;
                            UPDATE s
                            SET
                                s.query_plan = 
                                    CASE ERROR_NUMBER() 
                                        WHEN 1222 THEN '<timeout_exceeded />'
                                        ELSE '<error message="' + ERROR_MESSAGE() + '" />'
                                    END
                            FROM #sessions AS s
                            WHERE 
                                s.session_id = @session_id
                                AND s.request_id = @request_id
                                AND s.recursion = 1
                            OPTION (KEEPFIXED PLAN);
                        END;
                    END CATCH;
                END;

                FETCH NEXT FROM plan_cursor
                INTO
                    @session_id,
                    @request_id,
                    @plan_handle,
                    @statement_start_offset,
                    @statement_end_offset;
            END;

            --Return this to the default
            SET LOCK_TIMEOUT -1;

            CLOSE plan_cursor;
            DEALLOCATE plan_cursor;
        END;

        IF 
            @get_locks = 1 
            AND @recursion = 1
            AND @output_column_list LIKE '%|[locks|]%' ESCAPE '|'
        BEGIN;
            DECLARE locks_cursor
            CURSOR LOCAL FAST_FORWARD
            FOR 
                SELECT DISTINCT
                    database_name
                FROM #locks
                WHERE
                    EXISTS
                    (
                        SELECT *
                        FROM #sessions AS s
                        WHERE
                            s.session_id = #locks.session_id
                            AND recursion = 1
                    )
                    AND database_name <> '(null)'
                OPTION (KEEPFIXED PLAN);

            OPEN locks_cursor;

            FETCH NEXT FROM locks_cursor
            INTO 
                @database_name;

            WHILE @@FETCH_STATUS = 0
            BEGIN;
                BEGIN TRY;
                    SET @sql_n = CONVERT(NVARCHAR(MAX), '') +
                        'UPDATE l ' +
                        'SET ' +
                            'object_name = ' +
                                'REPLACE ' +
                                '( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                        'o.name COLLATE Latin1_General_Bin2, ' +
                                        'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
                                        'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
                                        'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
                                    'NCHAR(0), ' +
                                    N''''' ' +
                                '), ' +
                            'index_name = ' +
                                'REPLACE ' +
                                '( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                        'i.name COLLATE Latin1_General_Bin2, ' +
                                        'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
                                        'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
                                        'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
                                    'NCHAR(0), ' +
                                    N''''' ' +
                                '), ' +
                            'schema_name = ' +
                                'REPLACE ' +
                                '( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                        's.name COLLATE Latin1_General_Bin2, ' +
                                        'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
                                        'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
                                        'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
                                    'NCHAR(0), ' +
                                    N''''' ' +
                                '), ' +
                            'principal_name = ' + 
                                'REPLACE ' +
                                '( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                        'dp.name COLLATE Latin1_General_Bin2, ' +
                                        'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
                                        'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
                                        'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
                                    'NCHAR(0), ' +
                                    N''''' ' +
                                ') ' +
                        'FROM #locks AS l ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.allocation_units AS au ON ' +
                            'au.allocation_unit_id = l.allocation_unit_id ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.partitions AS p ON ' +
                            'p.hobt_id = ' +
                                'COALESCE ' +
                                '( ' +
                                    'l.hobt_id, ' +
                                    'CASE ' +
                                        'WHEN au.type IN (1, 3) THEN au.container_id ' +
                                        'ELSE NULL ' +
                                    'END ' +
                                ') ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.partitions AS p1 ON ' +
                            'l.hobt_id IS NULL ' +
                            'AND au.type = 2 ' +
                            'AND p1.partition_id = au.container_id ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.objects AS o ON ' +
                            'o.object_id = COALESCE(l.object_id, p.object_id, p1.object_id) ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.indexes AS i ON ' +
                            'i.object_id = COALESCE(l.object_id, p.object_id, p1.object_id) ' +
                            'AND i.index_id = COALESCE(l.index_id, p.index_id, p1.index_id) ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.schemas AS s ON ' +
                            's.schema_id = COALESCE(l.schema_id, o.schema_id) ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.database_principals AS dp ON ' +
                            'dp.principal_id = l.principal_id ' +
                        'WHERE ' +
                            'l.database_name = @database_name ' +
                        'OPTION (KEEPFIXED PLAN); ';
                    
                    EXEC sp_executesql
                        @sql_n,
                        N'@database_name sysname',
                        @database_name;
                END TRY
                BEGIN CATCH;
                    UPDATE #locks
                    SET
                        query_error = 
                            REPLACE
                            (
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                    CONVERT
                                    (
                                        NVARCHAR(MAX), 
                                        ERROR_MESSAGE() COLLATE Latin1_General_Bin2
                                    ),
                                    NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
                                    NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
                                    NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
                                NCHAR(0),
                                N''
                            )
                    WHERE 
                        database_name = @database_name
                    OPTION (KEEPFIXED PLAN);
                END CATCH;

                FETCH NEXT FROM locks_cursor
                INTO
                    @database_name;
            END;

            CLOSE locks_cursor;
            DEALLOCATE locks_cursor;

            CREATE CLUSTERED INDEX IX_SRD ON #locks (session_id, request_id, database_name);

            UPDATE s
            SET 
                s.locks =
                (
                    SELECT 
                        REPLACE
                        (
                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                CONVERT
                                (
                                    NVARCHAR(MAX), 
                                    l1.database_name COLLATE Latin1_General_Bin2
                                ),
                                NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
                                NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
                                NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
                            NCHAR(0),
                            N''
                        ) AS [Database/@name],
                        MIN(l1.query_error) AS [Database/@query_error],
                        (
                            SELECT 
                                l2.request_mode AS [Lock/@request_mode],
                                l2.request_status AS [Lock/@request_status],
                                COUNT(*) AS [Lock/@request_count]
                            FROM #locks AS l2
                            WHERE 
                                l1.session_id = l2.session_id
                                AND l1.request_id = l2.request_id
                                AND l2.database_name = l1.database_name
                                AND l2.resource_type = 'DATABASE'
                            GROUP BY
                                l2.request_mode,
                                l2.request_status
                            FOR XML
                                PATH(''),
                                TYPE
                        ) AS [Database/Locks],
                        (
                            SELECT
                                COALESCE(l3.object_name, '(null)') AS [Object/@name],
                                l3.schema_name AS [Object/@schema_name],
                                (
                                    SELECT
                                        l4.resource_type AS [Lock/@resource_type],
                                        l4.page_type AS [Lock/@page_type],
                                        l4.index_name AS [Lock/@index_name],
                                        CASE 
                                            WHEN l4.object_name IS NULL THEN l4.schema_name
                                            ELSE NULL
                                        END AS [Lock/@schema_name],
                                        l4.principal_name AS [Lock/@principal_name],
                                        l4.resource_description AS [Lock/@resource_description],
                                        l4.request_mode AS [Lock/@request_mode],
                                        l4.request_status AS [Lock/@request_status],
                                        SUM(l4.request_count) AS [Lock/@request_count]
                                    FROM #locks AS l4
                                    WHERE 
                                        l4.session_id = l3.session_id
                                        AND l4.request_id = l3.request_id
                                        AND l3.database_name = l4.database_name
                                        AND COALESCE(l3.object_name, '(null)') = COALESCE(l4.object_name, '(null)')
                                        AND COALESCE(l3.schema_name, '') = COALESCE(l4.schema_name, '')
                                        AND l4.resource_type <> 'DATABASE'
                                    GROUP BY
                                        l4.resource_type,
                                        l4.page_type,
                                        l4.index_name,
                                        CASE 
                                            WHEN l4.object_name IS NULL THEN l4.schema_name
                                            ELSE NULL
                                        END,
                                        l4.principal_name,
                                        l4.resource_description,
                                        l4.request_mode,
                                        l4.request_status
                                    FOR XML
                                        PATH(''),
                                        TYPE
                                ) AS [Object/Locks]
                            FROM #locks AS l3
                            WHERE 
                                l3.session_id = l1.session_id
                                AND l3.request_id = l1.request_id
                                AND l3.database_name = l1.database_name
                                AND l3.resource_type <> 'DATABASE'
                            GROUP BY 
                                l3.session_id,
                                l3.request_id,
                                l3.database_name,
                                COALESCE(l3.object_name, '(null)'),
                                l3.schema_name
                            FOR XML
                                PATH(''),
                                TYPE
                        ) AS [Database/Objects]
                    FROM #locks AS l1
                    WHERE
                        l1.session_id = s.session_id
                        AND l1.request_id = s.request_id
                        AND l1.start_time IN (s.start_time, s.last_request_start_time)
                        AND s.recursion = 1
                    GROUP BY 
                        l1.session_id,
                        l1.request_id,
                        l1.database_name
                    FOR XML
                        PATH(''),
                        TYPE
                )
            FROM #sessions s
            OPTION (KEEPFIXED PLAN);
        END;

        IF 
            @find_block_leaders = 1
            AND @recursion = 1
            AND @output_column_list LIKE '%|[blocked_session_count|]%' ESCAPE '|'
        BEGIN;
            WITH
            blockers AS
            (
                SELECT
                    session_id,
                    session_id AS top_level_session_id,
                    CONVERT(VARCHAR(8000), '.' + CONVERT(VARCHAR(8000), session_id) + '.') AS the_path
                FROM #sessions
                WHERE
                    recursion = 1

                UNION ALL

                SELECT
                    s.session_id,
                    b.top_level_session_id,
                    CONVERT(VARCHAR(8000), b.the_path + CONVERT(VARCHAR(8000), s.session_id) + '.') AS the_path
                FROM blockers AS b
                JOIN #sessions AS s ON
                    s.blocking_session_id = b.session_id
                    AND s.recursion = 1
                    AND b.the_path NOT LIKE '%.' + CONVERT(VARCHAR(8000), s.session_id) + '.%' COLLATE Latin1_General_Bin2
            )
            UPDATE s
            SET
                s.blocked_session_count = x.blocked_session_count
            FROM #sessions AS s
            JOIN
            (
                SELECT
                    b.top_level_session_id AS session_id,
                    COUNT(*) - 1 AS blocked_session_count
                FROM blockers AS b
                GROUP BY
                    b.top_level_session_id
            ) x ON
                s.session_id = x.session_id
            WHERE
                s.recursion = 1;
        END;

        IF
            @get_task_info = 2
            AND @output_column_list LIKE '%|[additional_info|]%' ESCAPE '|'
            AND @recursion = 1
        BEGIN;
            CREATE TABLE #blocked_requests
            (
                session_id SMALLINT NOT NULL,
                request_id INT NOT NULL,
                database_name sysname NOT NULL,
                object_id INT,
                hobt_id BIGINT,
                schema_id INT,
                schema_name sysname NULL,
                object_name sysname NULL,
                query_error NVARCHAR(2048),
                PRIMARY KEY (database_name, session_id, request_id)
            );

            CREATE STATISTICS s_database_name ON #blocked_requests (database_name)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_schema_name ON #blocked_requests (schema_name)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_object_name ON #blocked_requests (object_name)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
            CREATE STATISTICS s_query_error ON #blocked_requests (query_error)
            WITH SAMPLE 0 ROWS, NORECOMPUTE;
        
            INSERT #blocked_requests
            (
                session_id,
                request_id,
                database_name,
                object_id,
                hobt_id,
                schema_id
            )
            SELECT
                session_id,
                request_id,
                database_name,
                object_id,
                hobt_id,
                CONVERT(INT, SUBSTRING(schema_node, CHARINDEX(' = ', schema_node) + 3, LEN(schema_node))) AS schema_id
            FROM
            (
                SELECT
                    session_id,
                    request_id,
                    agent_nodes.agent_node.value('(database_name/text())[1]', 'sysname') AS database_name,
                    agent_nodes.agent_node.value('(object_id/text())[1]', 'int') AS object_id,
                    agent_nodes.agent_node.value('(hobt_id/text())[1]', 'bigint') AS hobt_id,
                    agent_nodes.agent_node.value('(metadata_resource/text()[.="SCHEMA"]/../../metadata_class_id/text())[1]', 'varchar(100)') AS schema_node
                FROM #sessions AS s
                CROSS APPLY s.additional_info.nodes('//block_info') AS agent_nodes (agent_node)
                WHERE
                    s.recursion = 1
            ) AS t
            WHERE
                t.database_name IS NOT NULL
                AND
                (
                    t.object_id IS NOT NULL
                    OR t.hobt_id IS NOT NULL
                    OR t.schema_node IS NOT NULL
                );
            
            DECLARE blocks_cursor
            CURSOR LOCAL FAST_FORWARD
            FOR
                SELECT DISTINCT
                    database_name
                FROM #blocked_requests;
                
            OPEN blocks_cursor;
            
            FETCH NEXT FROM blocks_cursor
            INTO 
                @database_name;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN;
                BEGIN TRY;
                    SET @sql_n = 
                        CONVERT(NVARCHAR(MAX), '') +
                        'UPDATE b ' +
                        'SET ' +
                            'b.schema_name = ' +
                                'REPLACE ' +
                                '( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                        's.name COLLATE Latin1_General_Bin2, ' +
                                        'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
                                        'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
                                        'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
                                    'NCHAR(0), ' +
                                    N''''' ' +
                                '), ' +
                            'b.object_name = ' +
                                'REPLACE ' +
                                '( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                    'REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE( ' +
                                        'o.name COLLATE Latin1_General_Bin2, ' +
                                        'NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''), ' +
                                        'NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''), ' +
                                        'NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''), ' +
                                    'NCHAR(0), ' +
                                    N''''' ' +
                                ') ' +
                        'FROM #blocked_requests AS b ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.partitions AS p ON ' +
                            'p.hobt_id = b.hobt_id ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.objects AS o ON ' +
                            'o.object_id = COALESCE(p.object_id, b.object_id) ' +
                        'LEFT OUTER JOIN ' + QUOTENAME(@database_name) + '.sys.schemas AS s ON ' +
                            's.schema_id = COALESCE(o.schema_id, b.schema_id) ' +
                        'WHERE ' +
                            'b.database_name = @database_name; ';
                    
                    EXEC sp_executesql
                        @sql_n,
                        N'@database_name sysname',
                        @database_name;
                END TRY
                BEGIN CATCH;
                    UPDATE #blocked_requests
                    SET
                        query_error = 
                            REPLACE
                            (
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                    CONVERT
                                    (
                                        NVARCHAR(MAX), 
                                        ERROR_MESSAGE() COLLATE Latin1_General_Bin2
                                    ),
                                    NCHAR(31),N'?'),NCHAR(30),N'?'),NCHAR(29),N'?'),NCHAR(28),N'?'),NCHAR(27),N'?'),NCHAR(26),N'?'),NCHAR(25),N'?'),NCHAR(24),N'?'),NCHAR(23),N'?'),NCHAR(22),N'?'),
                                    NCHAR(21),N'?'),NCHAR(20),N'?'),NCHAR(19),N'?'),NCHAR(18),N'?'),NCHAR(17),N'?'),NCHAR(16),N'?'),NCHAR(15),N'?'),NCHAR(14),N'?'),NCHAR(12),N'?'),
                                    NCHAR(11),N'?'),NCHAR(8),N'?'),NCHAR(7),N'?'),NCHAR(6),N'?'),NCHAR(5),N'?'),NCHAR(4),N'?'),NCHAR(3),N'?'),NCHAR(2),N'?'),NCHAR(1),N'?'),
                                NCHAR(0),
                                N''
                            )
                    WHERE
                        database_name = @database_name;
                END CATCH;

                FETCH NEXT FROM blocks_cursor
                INTO
                    @database_name;
            END;
            
            CLOSE blocks_cursor;
            DEALLOCATE blocks_cursor;
            
            UPDATE s
            SET
                additional_info.modify
                ('
                    insert <schema_name>{sql:column("b.schema_name")}</schema_name>
                    as last
                    into (/additional_info/block_info)[1]
                ')
            FROM #sessions AS s
            INNER JOIN #blocked_requests AS b ON
                b.session_id = s.session_id
                AND b.request_id = s.request_id
                AND s.recursion = 1
            WHERE
                b.schema_name IS NOT NULL;

            UPDATE s
            SET
                additional_info.modify
                ('
                    insert <object_name>{sql:column("b.object_name")}</object_name>
                    as last
                    into (/additional_info/block_info)[1]
                ')
            FROM #sessions AS s
            INNER JOIN #blocked_requests AS b ON
                b.session_id = s.session_id
                AND b.request_id = s.request_id
                AND s.recursion = 1
            WHERE
                b.object_name IS NOT NULL;

            UPDATE s
            SET
                additional_info.modify
                ('
                    insert <query_error>{sql:column("b.query_error")}</query_error>
                    as last
                    into (/additional_info/block_info)[1]
                ')
            FROM #sessions AS s
            INNER JOIN #blocked_requests AS b ON
                b.session_id = s.session_id
                AND b.request_id = s.request_id
                AND s.recursion = 1
            WHERE
                b.query_error IS NOT NULL;
        END;

        IF
            @output_column_list LIKE '%|[program_name|]%' ESCAPE '|'
            AND @output_column_list LIKE '%|[additional_info|]%' ESCAPE '|'
            AND @recursion = 1
            AND DB_ID('msdb') IS NOT NULL
        BEGIN;
            SET @sql_n =
                N'BEGIN TRY;
                    DECLARE @job_name sysname;
                    SET @job_name = NULL;
                    DECLARE @step_name sysname;
                    SET @step_name = NULL;

                    SELECT
                        @job_name = 
                            REPLACE
                            (
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                    j.name,
                                    NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''),
                                    NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''),
                                    NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''),
                                NCHAR(0),
                                N''?''
                            ),
                        @step_name = 
                            REPLACE
                            (
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                                    s.step_name,
                                    NCHAR(31),N''?''),NCHAR(30),N''?''),NCHAR(29),N''?''),NCHAR(28),N''?''),NCHAR(27),N''?''),NCHAR(26),N''?''),NCHAR(25),N''?''),NCHAR(24),N''?''),NCHAR(23),N''?''),NCHAR(22),N''?''),
                                    NCHAR(21),N''?''),NCHAR(20),N''?''),NCHAR(19),N''?''),NCHAR(18),N''?''),NCHAR(17),N''?''),NCHAR(16),N''?''),NCHAR(15),N''?''),NCHAR(14),N''?''),NCHAR(12),N''?''),
                                    NCHAR(11),N''?''),NCHAR(8),N''?''),NCHAR(7),N''?''),NCHAR(6),N''?''),NCHAR(5),N''?''),NCHAR(4),N''?''),NCHAR(3),N''?''),NCHAR(2),N''?''),NCHAR(1),N''?''),
                                NCHAR(0),
                                N''?''
                            )
                    FROM msdb.dbo.sysjobs AS j
                    INNER JOIN msdb.dbo.sysjobsteps AS s ON
                        j.job_id = s.job_id
                    WHERE
                        j.job_id = @job_id
                        AND s.step_id = @step_id;

                    IF @job_name IS NOT NULL
                    BEGIN;
                        UPDATE s
                        SET
                            additional_info.modify
                            (''
                                insert text{sql:variable("@job_name")}
                                into (/additional_info/agent_job_info/job_name)[1]
                            '')
                        FROM #sessions AS s
                        WHERE 
                            s.session_id = @session_id
                            AND s.recursion = 1
                        OPTION (KEEPFIXED PLAN);
                        
                        UPDATE s
                        SET
                            additional_info.modify
                            (''
                                insert text{sql:variable("@step_name")}
                                into (/additional_info/agent_job_info/step_name)[1]
                            '')
                        FROM #sessions AS s
                        WHERE 
                            s.session_id = @session_id
                            AND s.recursion = 1
                        OPTION (KEEPFIXED PLAN);
                    END;
                END TRY
                BEGIN CATCH;
                    DECLARE @msdb_error_message NVARCHAR(256);
                    SET @msdb_error_message = ERROR_MESSAGE();
                
                    UPDATE s
                    SET
                        additional_info.modify
                        (''
                            insert <msdb_query_error>{sql:variable("@msdb_error_message")}</msdb_query_error>
                            as last
                            into (/additional_info/agent_job_info)[1]
                        '')
                    FROM #sessions AS s
                    WHERE 
                        s.session_id = @session_id
                        AND s.recursion = 1
                    OPTION (KEEPFIXED PLAN);
                END CATCH;'

            DECLARE @job_id UNIQUEIDENTIFIER;
            DECLARE @step_id INT;

            DECLARE agent_cursor
            CURSOR LOCAL FAST_FORWARD
            FOR 
                SELECT
                    s.session_id,
                    agent_nodes.agent_node.value('(job_id/text())[1]', 'uniqueidentifier') AS job_id,
                    agent_nodes.agent_node.value('(step_id/text())[1]', 'int') AS step_id
                FROM #sessions AS s
                CROSS APPLY s.additional_info.nodes('//agent_job_info') AS agent_nodes (agent_node)
                WHERE
                    s.recursion = 1
            OPTION (KEEPFIXED PLAN);
            
            OPEN agent_cursor;

            FETCH NEXT FROM agent_cursor
            INTO 
                @session_id,
                @job_id,
                @step_id;

            WHILE @@FETCH_STATUS = 0
            BEGIN;
                EXEC sp_executesql
                    @sql_n,
                    N'@job_id UNIQUEIDENTIFIER, @step_id INT, @session_id SMALLINT',
                    @job_id, @step_id, @session_id

                FETCH NEXT FROM agent_cursor
                INTO 
                    @session_id,
                    @job_id,
                    @step_id;
            END;

            CLOSE agent_cursor;
            DEALLOCATE agent_cursor;
        END; 
        
        IF 
            @delta_interval > 0 
            AND @recursion <> 1
        BEGIN;
            SET @recursion = 1;

            DECLARE @delay_time CHAR(12);
            SET @delay_time = CONVERT(VARCHAR, DATEADD(second, @delta_interval, 0), 114);
            WAITFOR DELAY @delay_time;

            GOTO REDO;
        END;
    END;

    SET @sql = 
        --Outer column list
        CONVERT
        (
            VARCHAR(MAX),
            CASE
                WHEN 
                    @destination_table <> '' 
                    AND @return_schema = 0 
                        THEN 'INSERT ' + @destination_table + ' '
                ELSE ''
            END +
            'SELECT ' +
                @output_column_list + ' ' +
            CASE @return_schema
                WHEN 1 THEN 'INTO #session_schema '
                ELSE ''
            END
        --End outer column list
        ) + 
        --Inner column list
        CONVERT
        (
            VARCHAR(MAX),
            'FROM ' +
            '( ' +
                'SELECT ' +
                    'session_id, ' +
                    --[dd hh:mm:ss.mss]
                    CASE
                        WHEN @format_output IN (1, 2) THEN
                            'CASE ' +
                                'WHEN elapsed_time < 0 THEN ' +
                                    'RIGHT ' +
                                    '( ' +
                                        'REPLICATE(''0'', max_elapsed_length) + CONVERT(VARCHAR, (-1 * elapsed_time) / 86400), ' +
                                        'max_elapsed_length ' +
                                    ') + ' +
                                        'RIGHT ' +
                                        '( ' +
                                            'CONVERT(VARCHAR, DATEADD(second, (-1 * elapsed_time), 0), 120), ' +
                                            '9 ' +
                                        ') + ' +
                                        '''.000'' ' +
                                'ELSE ' +
                                    'RIGHT ' +
                                    '( ' +
                                        'REPLICATE(''0'', max_elapsed_length) + CONVERT(VARCHAR, elapsed_time / 86400000), ' +
                                        'max_elapsed_length ' +
                                    ') + ' +
                                        'RIGHT ' +
                                        '( ' +
                                            'CONVERT(VARCHAR, DATEADD(second, elapsed_time / 1000, 0), 120), ' +
                                            '9 ' +
                                        ') + ' +
                                        '''.'' + ' + 
                                        'RIGHT(''000'' + CONVERT(VARCHAR, elapsed_time % 1000), 3) ' +
                            'END AS [dd hh:mm:ss.mss], '
                        ELSE
                            ''
                    END +
                    --[dd hh:mm:ss.mss (avg)] / avg_elapsed_time
                    CASE 
                        WHEN  @format_output IN (1, 2) THEN 
                            'RIGHT ' +
                            '( ' +
                                '''00'' + CONVERT(VARCHAR, avg_elapsed_time / 86400000), ' +
                                '2 ' +
                            ') + ' +
                                'RIGHT ' +
                                '( ' +
                                    'CONVERT(VARCHAR, DATEADD(second, avg_elapsed_time / 1000, 0), 120), ' +
                                    '9 ' +
                                ') + ' +
                                '''.'' + ' +
                                'RIGHT(''000'' + CONVERT(VARCHAR, avg_elapsed_time % 1000), 3) AS [dd hh:mm:ss.mss (avg)], '
                        ELSE
                            'avg_elapsed_time, '
                    END +
                    --physical_io
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, physical_io))) OVER() - LEN(CONVERT(VARCHAR, physical_io))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_io), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_io), 1), 19)) AS '
                        ELSE ''
                    END + 'physical_io, ' +
                    --reads
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, reads))) OVER() - LEN(CONVERT(VARCHAR, reads))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, reads), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, reads), 1), 19)) AS '
                        ELSE ''
                    END + 'reads, ' +
                    --physical_reads
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, physical_reads))) OVER() - LEN(CONVERT(VARCHAR, physical_reads))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_reads), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_reads), 1), 19)) AS '
                        ELSE ''
                    END + 'physical_reads, ' +
                    --writes
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, writes))) OVER() - LEN(CONVERT(VARCHAR, writes))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, writes), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, writes), 1), 19)) AS '
                        ELSE ''
                    END + 'writes, ' +
                    --tempdb_allocations
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tempdb_allocations))) OVER() - LEN(CONVERT(VARCHAR, tempdb_allocations))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_allocations), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_allocations), 1), 19)) AS '
                        ELSE ''
                    END + 'tempdb_allocations, ' +
                    --tempdb_current
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tempdb_current))) OVER() - LEN(CONVERT(VARCHAR, tempdb_current))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_current), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_current), 1), 19)) AS '
                        ELSE ''
                    END + 'tempdb_current, ' +
                    --CPU
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, CPU))) OVER() - LEN(CONVERT(VARCHAR, CPU))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, CPU), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, CPU), 1), 19)) AS '
                        ELSE ''
                    END + 'CPU, ' +
                    --context_switches
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, context_switches))) OVER() - LEN(CONVERT(VARCHAR, context_switches))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, context_switches), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, context_switches), 1), 19)) AS '
                        ELSE ''
                    END + 'context_switches, ' +
                    --used_memory
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, used_memory))) OVER() - LEN(CONVERT(VARCHAR, used_memory))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, used_memory), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, used_memory), 1), 19)) AS '
                        ELSE ''
                    END + 'used_memory, ' +
                    CASE
                        WHEN @output_column_list LIKE '%|_delta|]%' ESCAPE '|' THEN
                            --physical_io_delta         
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                    'AND physical_io_delta >= 0 ' +
                                        'THEN ' +
                                        CASE @format_output
                                            WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, physical_io_delta))) OVER() - LEN(CONVERT(VARCHAR, physical_io_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_io_delta), 1), 19)) ' 
                                            WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_io_delta), 1), 19)) '
                                            ELSE 'physical_io_delta '
                                        END +
                                'ELSE NULL ' +
                            'END AS physical_io_delta, ' +
                            --reads_delta
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                    'AND reads_delta >= 0 ' +
                                        'THEN ' +
                                        CASE @format_output
                                            WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, reads_delta))) OVER() - LEN(CONVERT(VARCHAR, reads_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, reads_delta), 1), 19)) '
                                            WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, reads_delta), 1), 19)) '
                                            ELSE 'reads_delta '
                                        END +
                                'ELSE NULL ' +
                            'END AS reads_delta, ' +
                            --physical_reads_delta
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                    'AND physical_reads_delta >= 0 ' +
                                        'THEN ' +
                                        CASE @format_output
                                            WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, physical_reads_delta))) OVER() - LEN(CONVERT(VARCHAR, physical_reads_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_reads_delta), 1), 19)) '
                                            WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, physical_reads_delta), 1), 19)) '
                                            ELSE 'physical_reads_delta '
                                        END + 
                                'ELSE NULL ' +
                            'END AS physical_reads_delta, ' +
                            --writes_delta
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                    'AND writes_delta >= 0 ' +
                                        'THEN ' +
                                        CASE @format_output
                                            WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, writes_delta))) OVER() - LEN(CONVERT(VARCHAR, writes_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, writes_delta), 1), 19)) '
                                            WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, writes_delta), 1), 19)) '
                                            ELSE 'writes_delta '
                                        END + 
                                'ELSE NULL ' +
                            'END AS writes_delta, ' +
                            --tempdb_allocations_delta
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                    'AND tempdb_allocations_delta >= 0 ' +
                                        'THEN ' +
                                        CASE @format_output
                                            WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tempdb_allocations_delta))) OVER() - LEN(CONVERT(VARCHAR, tempdb_allocations_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_allocations_delta), 1), 19)) '
                                            WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_allocations_delta), 1), 19)) '
                                            ELSE 'tempdb_allocations_delta '
                                        END + 
                                'ELSE NULL ' +
                            'END AS tempdb_allocations_delta, ' +
                            --tempdb_current_delta
                            --this is the only one that can (legitimately) go negative 
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                        'THEN ' +
                                        CASE @format_output
                                            WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tempdb_current_delta))) OVER() - LEN(CONVERT(VARCHAR, tempdb_current_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_current_delta), 1), 19)) '
                                            WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tempdb_current_delta), 1), 19)) '
                                            ELSE 'tempdb_current_delta '
                                        END + 
                                'ELSE NULL ' +
                            'END AS tempdb_current_delta, ' +
                            --CPU_delta
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                        'THEN ' +
                                            'CASE ' +
                                                'WHEN ' +
                                                    'thread_CPU_delta > CPU_delta ' +
                                                    'AND thread_CPU_delta > 0 ' +
                                                        'THEN ' +
                                                            CASE @format_output
                                                                WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, thread_CPU_delta + CPU_delta))) OVER() - LEN(CONVERT(VARCHAR, thread_CPU_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, thread_CPU_delta), 1), 19)) '
                                                                WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, thread_CPU_delta), 1), 19)) '
                                                                ELSE 'thread_CPU_delta '
                                                            END + 
                                                'WHEN CPU_delta >= 0 THEN ' +
                                                    CASE @format_output
                                                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, thread_CPU_delta + CPU_delta))) OVER() - LEN(CONVERT(VARCHAR, CPU_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, CPU_delta), 1), 19)) '
                                                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, CPU_delta), 1), 19)) '
                                                        ELSE 'CPU_delta '
                                                    END + 
                                                'ELSE NULL ' +
                                            'END ' +
                                'ELSE ' +
                                    'NULL ' +
                            'END AS CPU_delta, ' +
                            --context_switches_delta
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                    'AND context_switches_delta >= 0 ' +
                                        'THEN ' +
                                        CASE @format_output
                                            WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, context_switches_delta))) OVER() - LEN(CONVERT(VARCHAR, context_switches_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, context_switches_delta), 1), 19)) '
                                            WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, context_switches_delta), 1), 19)) '
                                            ELSE 'context_switches_delta '
                                        END + 
                                'ELSE NULL ' +
                            'END AS context_switches_delta, ' +
                            --used_memory_delta
                            'CASE ' +
                                'WHEN ' +
                                    'first_request_start_time = last_request_start_time ' + 
                                    'AND num_events = 2 ' +
                                    'AND used_memory_delta >= 0 ' +
                                        'THEN ' +
                                        CASE @format_output
                                            WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, used_memory_delta))) OVER() - LEN(CONVERT(VARCHAR, used_memory_delta))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, used_memory_delta), 1), 19)) '
                                            WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, used_memory_delta), 1), 19)) '
                                            ELSE 'used_memory_delta '
                                        END + 
                                'ELSE NULL ' +
                            'END AS used_memory_delta, '
                        ELSE ''
                    END +
                    --tasks
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, tasks))) OVER() - LEN(CONVERT(VARCHAR, tasks))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tasks), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, tasks), 1), 19)) '
                        ELSE ''
                    END + 'tasks, ' +
                    'status, ' +
                    'wait_info, ' +
                    'locks, ' +
                    'tran_start_time, ' +
                    'LEFT(tran_log_writes, LEN(tran_log_writes) - 1) AS tran_log_writes, ' +
                    --open_tran_count
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, open_tran_count))) OVER() - LEN(CONVERT(VARCHAR, open_tran_count))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, open_tran_count), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, open_tran_count), 1), 19)) AS '
                        ELSE ''
                    END + 'open_tran_count, ' +
                    --sql_command
                    CASE @format_output 
                        WHEN 0 THEN 'REPLACE(REPLACE(CONVERT(NVARCHAR(MAX), sql_command), ''<?query --''+CHAR(13)+CHAR(10), ''''), CHAR(13)+CHAR(10)+''--?>'', '''') AS '
                        ELSE ''
                    END + 'sql_command, ' +
                    --sql_text
                    CASE @format_output 
                        WHEN 0 THEN 'REPLACE(REPLACE(CONVERT(NVARCHAR(MAX), sql_text), ''<?query --''+CHAR(13)+CHAR(10), ''''), CHAR(13)+CHAR(10)+''--?>'', '''') AS '
                        ELSE ''
                    END + 'sql_text, ' +
                    'query_plan, ' +
                    'blocking_session_id, ' +
                    --blocked_session_count
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, blocked_session_count))) OVER() - LEN(CONVERT(VARCHAR, blocked_session_count))) + LEFT(CONVERT(CHAR(22), CONVERT(MONEY, blocked_session_count), 1), 19)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, LEFT(CONVERT(CHAR(22), CONVERT(MONEY, blocked_session_count), 1), 19)) AS '
                        ELSE ''
                    END + 'blocked_session_count, ' +
                    --percent_complete
                    CASE @format_output
                        WHEN 1 THEN 'CONVERT(VARCHAR, SPACE(MAX(LEN(CONVERT(VARCHAR, CONVERT(MONEY, percent_complete), 2))) OVER() - LEN(CONVERT(VARCHAR, CONVERT(MONEY, percent_complete), 2))) + CONVERT(CHAR(22), CONVERT(MONEY, percent_complete), 2)) AS '
                        WHEN 2 THEN 'CONVERT(VARCHAR, CONVERT(CHAR(22), CONVERT(MONEY, blocked_session_count), 1)) AS '
                        ELSE ''
                    END + 'percent_complete, ' +
                    'host_name, ' +
                    'login_name, ' +
                    'database_name, ' +
                    'program_name, ' +
                    'additional_info, ' +
                    'start_time, ' +
                    'login_time, ' +
                    'CASE ' +
                        'WHEN status = N''sleeping'' THEN NULL ' +
                        'ELSE request_id ' +
                    'END AS request_id, ' +
                    'GETDATE() AS collection_time '
        --End inner column list
        ) +
        --Derived table and INSERT specification
        CONVERT
        (
            VARCHAR(MAX),
                'FROM ' +
                '( ' +
                    'SELECT TOP(2147483647) ' +
                        '*, ' +
                        'CASE ' +
                            'MAX ' +
                            '( ' +
                                'LEN ' +
                                '( ' +
                                    'CONVERT ' +
                                    '( ' +
                                        'VARCHAR, ' +
                                        'CASE ' +
                                            'WHEN elapsed_time < 0 THEN ' +
                                                '(-1 * elapsed_time) / 86400 ' +
                                            'ELSE ' +
                                                'elapsed_time / 86400000 ' +
                                        'END ' +
                                    ') ' +
                                ') ' +
                            ') OVER () ' +
                                'WHEN 1 THEN 2 ' +
                                'ELSE ' +
                                    'MAX ' +
                                    '( ' +
                                        'LEN ' +
                                        '( ' +
                                            'CONVERT ' +
                                            '( ' +
                                                'VARCHAR, ' +
                                                'CASE ' +
                                                    'WHEN elapsed_time < 0 THEN ' +
                                                        '(-1 * elapsed_time) / 86400 ' +
                                                    'ELSE ' +
                                                        'elapsed_time / 86400000 ' +
                                                'END ' +
                                            ') ' +
                                        ') ' +
                                    ') OVER () ' +
                        'END AS max_elapsed_length, ' +
                        CASE
                            WHEN @output_column_list LIKE '%|_delta|]%' ESCAPE '|' THEN
                                'MAX(physical_io * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(physical_io * recursion) OVER (PARTITION BY session_id, request_id) AS physical_io_delta, ' +
                                'MAX(reads * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(reads * recursion) OVER (PARTITION BY session_id, request_id) AS reads_delta, ' +
                                'MAX(physical_reads * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(physical_reads * recursion) OVER (PARTITION BY session_id, request_id) AS physical_reads_delta, ' +
                                'MAX(writes * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(writes * recursion) OVER (PARTITION BY session_id, request_id) AS writes_delta, ' +
                                'MAX(tempdb_allocations * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(tempdb_allocations * recursion) OVER (PARTITION BY session_id, request_id) AS tempdb_allocations_delta, ' +
                                'MAX(tempdb_current * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(tempdb_current * recursion) OVER (PARTITION BY session_id, request_id) AS tempdb_current_delta, ' +
                                'MAX(CPU * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(CPU * recursion) OVER (PARTITION BY session_id, request_id) AS CPU_delta, ' +
                                'MAX(thread_CPU_snapshot * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(thread_CPU_snapshot * recursion) OVER (PARTITION BY session_id, request_id) AS thread_CPU_delta, ' +
                                'MAX(context_switches * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(context_switches * recursion) OVER (PARTITION BY session_id, request_id) AS context_switches_delta, ' +
                                'MAX(used_memory * recursion) OVER (PARTITION BY session_id, request_id) + ' +
                                    'MIN(used_memory * recursion) OVER (PARTITION BY session_id, request_id) AS used_memory_delta, ' +
                                'MIN(last_request_start_time) OVER (PARTITION BY session_id, request_id) AS first_request_start_time, '
                            ELSE ''
                        END +
                        'COUNT(*) OVER (PARTITION BY session_id, request_id) AS num_events ' +
                    'FROM #sessions AS s1 ' +
                    CASE 
                        WHEN @sort_order = '' THEN ''
                        ELSE
                            'ORDER BY ' +
                                @sort_order
                    END +
                ') AS s ' +
                'WHERE ' +
                    's.recursion = 1 ' +
            ') x ' +
            'OPTION (KEEPFIXED PLAN); ' +
            '' +
            CASE @return_schema
                WHEN 1 THEN
                    'SET @schema = ' +
                        '''CREATE TABLE <table_name> ( '' + ' +
                            'STUFF ' +
                            '( ' +
                                '( ' +
                                    'SELECT ' +
                                        ''','' + ' +
                                        'QUOTENAME(COLUMN_NAME) + '' '' + ' +
                                        'DATA_TYPE + ' + 
                                        'CASE ' +
                                            'WHEN DATA_TYPE LIKE ''%char'' THEN ''('' + COALESCE(NULLIF(CONVERT(VARCHAR, CHARACTER_MAXIMUM_LENGTH), ''-1''), ''max'') + '') '' ' +
                                            'ELSE '' '' ' +
                                        'END + ' +
                                        'CASE IS_NULLABLE ' +
                                            'WHEN ''NO'' THEN ''NOT '' ' +
                                            'ELSE '''' ' +
                                        'END + ''NULL'' AS [text()] ' +
                                    'FROM tempdb.INFORMATION_SCHEMA.COLUMNS ' +
                                    'WHERE ' +
                                        'TABLE_NAME = (SELECT name FROM tempdb.sys.objects WHERE object_id = OBJECT_ID(''tempdb..#session_schema'')) ' +
                                        'ORDER BY ' +
                                            'ORDINAL_POSITION ' +
                                    'FOR XML ' +
                                        'PATH('''') ' +
                                '), + ' +
                                '1, ' +
                                '1, ' +
                                ''''' ' +
                            ') + ' +
                        ''')''; ' 
                ELSE ''
            END
        --End derived table and INSERT specification
        );

    SET @sql_n = CONVERT(NVARCHAR(MAX), @sql);

    EXEC sp_executesql
        @sql_n,
        N'@schema VARCHAR(MAX) OUTPUT',
        @schema OUTPUT;
END;

GO
/****** Object:  StoredProcedure [dbo].[vwf_correcoes_por_redacao]    Script Date: 23/11/2019 09:23:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE   PROCEDURE [dbo].[vwf_correcoes_por_redacao] @data_tabelas date
AS
BEGIN
EXEC('
SELECT TOP 1 
       REDACAO_ID               = RED.ID,
       CO_PROJETO               = RED.id_projeto,
	   ID_AVALIADOR_AV1         = COR1.ID_CORRETOR,
	   NOME_AVALIADOR_AV1       = PES1.NOME,
	   CPF_AVALIADOR_AV1        = PES1.cpf,  
	   COMP1_AV1                = COR1.COMPETENCIA1,
	   COMP2_AV1                = COR1.COMPETENCIA2,
	   COMP3_AV1                = COR1.COMPETENCIA3,
	   COMP4_AV1                = COR1.COMPETENCIA4,
	   COMP5_AV1                = COR1.COMPETENCIA5,
	   NOTA_COMP1_AV1           = COR1.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AV1           = COR1.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AV1           = COR1.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AV1           = COR1.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AV1           = COR1.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AV1           = COR1.NOTA_FINAL,
	   ID_SITUACAO_AV1          = COR1.id_correcao_situacao, 
	   SIGLA_SITUACAO_AV1       = (select sitx.sigla from correcoes_situacao sitx where sitx.id = COR1.id_correcao_situacao),
	   FERE_DH_AV1              = case when COR1.COMPETENCIA5 = -1 and COR1.COMPETENCIA5 is not null then 1 when COR1.COMPETENCIA5 = 0 then 0 else NULL end,
	   DATA_INICIO_AV1          = COR1.data_inicio,
	   DATA_TERMINO_AV1         = COR1.data_termino,
	   DURACAO_AV1              = (CASE WHEN (cor1.tempo_em_correcao) > 1200 THEN 1200 ELSE cor1.tempo_em_correcao END),
	   LINK_IMAGEM_AV1          = COR1.LINK_IMAGEM_RECORTADA,
				   
	   ID_AVALIADOR_AV2         = COR2.ID_CORRETOR,
	   NOME_AVALIADOR_AV2       = PES2.NOME,
	   CPF_AVALIADOR_AV2        = PES2.cpf,  
	   COMP1_AV2                = COR2.COMPETENCIA1,
	   COMP2_AV2                = COR2.COMPETENCIA2,
	   COMP3_AV2                = COR2.COMPETENCIA3,
	   COMP4_AV2                = COR2.COMPETENCIA4,
	   COMP5_AV2                = COR2.COMPETENCIA5,
	   NOTA_COMP1_AV2           = COR2.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AV2           = COR2.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AV2           = COR2.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AV2           = COR2.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AV2           = COR2.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AV2           = COR2.NOTA_FINAL,
	   ID_SITUACAO_AV2          = COR2.id_correcao_situacao, 
	   SIGLA_SITUACAO_AV2       = (select sitx.sigla from correcoes_situacao sitx where sitx.id = COR2.id_correcao_situacao),
	   FERE_DH_AV2              = case when COR2.COMPETENCIA5 = -1 and COR2.COMPETENCIA5 is not null then 1 when COR2.COMPETENCIA5 = 0 then 0 else NULL end,
	   DATA_INICIO_AV2          = COR2.data_inicio,
	   DATA_TERMINO_AV2         = COR2.data_termino,
	   DURACAO_AV2              = (CASE WHEN (cor2.tempo_em_correcao) > 1200 THEN 1200 ELSE cor2.tempo_em_correcao END),
	   LINK_IMAGEM_AV2          = COR2.LINK_IMAGEM_RECORTADA,
	   
	   	
	   ID_AVALIADOR_AV3         = COR3.ID_CORRETOR,
	   NOME_AVALIADOR_AV3       = PES3.NOME,
	   CPF_AVALIADOR_AV3        = PES3.cpf,  
	   COMP1_AV3                = COR3.COMPETENCIA1,
	   COMP2_AV3                = COR3.COMPETENCIA2,
	   COMP3_AV3                = COR3.COMPETENCIA3,
	   COMP4_AV3                = COR3.COMPETENCIA4,
	   COMP5_AV3                = COR3.COMPETENCIA5,
	   NOTA_COMP1_AV3           = COR3.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AV3           = COR3.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AV3           = COR3.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AV3           = COR3.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AV3           = COR3.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AV3           = COR3.NOTA_FINAL,
	   ID_SITUACAO_AV3          = COR3.id_correcao_situacao, 
	   SIGLA_SITUACAO_AV3       = (select sitx.sigla from correcoes_situacao sitx where sitx.id = COR3.id_correcao_situacao),
	   FERE_DH_AV3              = case when COR3.COMPETENCIA5 = -1 and COR3.COMPETENCIA5 is not null then 1 when COR3.COMPETENCIA5 = 0 then 0 else NULL end,
	   DATA_INICIO_AV3          = COR3.data_inicio,
	   DATA_TERMINO_AV3         = COR3.data_termino,
	   DURACAO_AV3              = (CASE WHEN (cor3.tempo_em_correcao) > 1200 THEN 1200 ELSE cor3.tempo_em_correcao END),	   
	   LINK_IMAGEM_AV3          = COR3.LINK_IMAGEM_RECORTADA,
	    	
	   ID_AVALIADOR_AVA4        = COR4.ID_CORRETOR,
	   NOME_AVALIADOR_AVA4      = PES4.NOME,
	   CPF_AVALIADOR_AVA4       = PES4.cpf,  
	   COMP1_AVA4               = COR4.COMPETENCIA1,
	   COMP2_AVA4               = COR4.COMPETENCIA2,
	   COMP3_AVA4               = COR4.COMPETENCIA3,
	   COMP4_AVA4               = COR4.COMPETENCIA4,
	   COMP5_AVA4               = COR4.COMPETENCIA5,
	   NOTA_COMP1_AVA4          = COR4.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AVA4          = COR4.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AVA4          = COR4.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AVA4          = COR4.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AVA4          = COR4.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AVA4          = COR4.NOTA_FINAL,
	   ID_SITUACAO_AVA4         = COR4.id_correcao_situacao, 
	   SIGLA_SITUACAO_AVA4      = (select sitx.sigla from correcoes_situacao sitx where sitx.id = COR4.id_correcao_situacao),
	   FERE_DH_AVA4             = case when COR4.COMPETENCIA5 = -1 and COR4.COMPETENCIA5 is not null then 1 when COR4.COMPETENCIA5 = 0 then 0 else NULL end,
	   DATA_INICIO_AVA4         = COR4.data_inicio,
	   DATA_TERMINO_AVA4        = COR4.data_termino,
	   DURACAO_AVA4             = (CASE WHEN (cor4.tempo_em_correcao) > 1200 THEN 1200 ELSE cor4.tempo_em_correcao END),
	   LINK_IMAGEM_AV4          = COR4.LINK_IMAGEM_RECORTADA,
	  	    	
	   ID_AVALIADOR_AVAA        = CORA.ID_CORRETOR,
	   NOME_AVALIADOR_AVAA      = PESA.NOME,
	   CPF_AVALIADOR_AVAA       = PESA.cpf,  
	   COMP1_AVAA               = CORA.COMPETENCIA1,
	   COMP2_AVAA               = CORA.COMPETENCIA2,
	   COMP3_AVAA               = CORA.COMPETENCIA3,
	   COMP4_AVAA               = CORA.COMPETENCIA4,
	   COMP5_AVAA               = CORA.COMPETENCIA5,
	   NOTA_COMP1_AVAA          = CORA.NOTA_COMPETENCIA1,
	   NOTA_COMP2_AVAA          = CORA.NOTA_COMPETENCIA2,
	   NOTA_COMP3_AVAA          = CORA.NOTA_COMPETENCIA3,
	   NOTA_COMP4_AVAA          = CORA.NOTA_COMPETENCIA4,
	   NOTA_COMP5_AVAA          = CORA.NOTA_COMPETENCIA5,
	   NOTA_FINAL_AVAA          = CORA.NOTA_FINAL,
	   ID_SITUACAO_AVAA         = CORA.id_correcao_situacao, 
	   SIGLA_SITUACAO_AVAA      = (select sitx.sigla from correcoes_situacao sitx where sitx.id = CORA.id_correcao_situacao),
	   DATA_INICIO_AVAA         = CORA.data_inicio,
	   DATA_TERMINO_AVAA        = CORA.data_termino,
	   DURACAO_AVAA             = (CASE WHEN (corA.tempo_em_correcao) > 1200 THEN 1200 ELSE corA.tempo_em_correcao END),
	   LINK_IMAGEM_AVA          = CORA.LINK_IMAGEM_RECORTADA,

	   RED.CO_BARRA_REDACAO, 
	   RED.CO_INSCRICAO,
	   RED.ID_CORRECAO_SITUACAO,
	   RED.NOTA_FINAL,
	   FERE_DH_FINAL              = case when CORA.id is not null and CORA.competencia5 = -1 then 1
	                                     when CORA.id is not null and CORA.competencia5 = 0 then 0
	                                     when CORA.id is null and COR4.id is not null and COR4.competencia5 = -1 then 1
	                                     when CORA.id is null and COR4.id is not null and COR4.competencia5 = 0 then 0
	                                     when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = -1 and COR2.competencia5 = -1 then 1
	                                     when CORA.id is null and COR4.id is null and COR3.id is null and COR1.competencia5 = 0 and COR2.competencia5 = 0 then 0
	                                     else NULL end,
   DATA_TERMINO = dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(dbo.InlineMaxDatetime(COR1.data_termino, COR2.data_termino), COR3.data_termino), COR4.data_termino), CORA.data_termino),
	   sno2.CO_PROJETO,               
	   sn90.SG_UF_MUNICIPIO_PROVA as SG_UF_PROVA,            
	   sn91.ID_ITEM_ATENDIMENTO,
	   NOTA_COMP1 = case
	                   when CORA.id is not null then CORA.nota_competencia1
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia1
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia1
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia1 + COR2.nota_competencia1) / 2
					end,
	   NOTA_COMP2 = case
	                   when CORA.id is not null then CORA.nota_competencia2
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia2
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia2
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia2 + COR2.nota_competencia2) / 2
					end,
	   NOTA_COMP3 = case
	                   when CORA.id is not null then CORA.nota_competencia3
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia3
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia3
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia3 + COR2.nota_competencia3) / 2
					end,
	   NOTA_COMP4 = case
	                   when CORA.id is not null then CORA.nota_competencia4
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia4
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia4
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia4 + COR2.nota_competencia4) / 2
					end,
	   NOTA_COMP5 = case
	                   when CORA.id is not null then CORA.nota_competencia5
					   when CORA.id is null and COR4.id is not null then COR4.nota_competencia5
					   when CORA.id is null and COR4.id is null and COR3.id is not null and ANA3.id is not null then COR3.nota_competencia5
					   when CORA.id is null and COR4.id is null and COR3.id is null and COR1.id is not null and COR2.id is not null then (COR1.nota_competencia5 + COR2.nota_competencia5) / 2
					end,
	   co_justificativa = null,
	   FERE_DH_AVAA              = case when CORA.COMPETENCIA5 = -1 and CORA.COMPETENCIA5 is not null then 1 when CORA.COMPETENCIA5 = 0 then 0 else NULL end
--select count(1)
  FROM CORRECOES_REDACAO RED  LEFT JOIN INEP_N02        SNO2 ON (SNO2.CO_INSCRICAO     = RED.co_inscricao)  
       INNER JOIN inep_n90 sn90 on sn90.co_inscricao = red.co_inscricao 
	   LEFT JOIN INEP_N91 SN91 ON (SN91.CO_INSCRICAO = RED.co_inscricao and sn91.ID_ITEM_ATENDIMENTO IN (5, 8))
	   LEFT JOIN CORRECOES_CORRECAO COR1 ON (RED.co_barra_redacao  = COR1.co_barra_redacao AND RED.id_projeto = COR1.id_projeto AND COR1.id_tipo_correcao = 1)
	   LEFT JOIN USUARIOS_PESSOA    PES1 ON (COR1.id_corretor      = PES1.usuario_id)
	   LEFT JOIN CORRECOES_CORRECAO COR2 ON (RED.co_barra_redacao  = COR2.co_barra_redacao AND RED.id_projeto = COR2.id_projeto AND COR2.id_tipo_correcao = 2)
	   LEFT JOIN USUARIOS_PESSOA    PES2 ON (COR2.id_corretor      = PES2.usuario_id)
	   LEFT JOIN CORRECOES_CORRECAO COR3 ON (RED.co_barra_redacao  = COR3.co_barra_redacao AND RED.id_projeto = COR3.id_projeto AND COR3.id_tipo_correcao = 3)
	   LEFT JOIN USUARIOS_PESSOA    PES3 ON (COR3.id_corretor      = PES3.usuario_id)
	   LEFT JOIN CORRECOES_CORRECAO COR4 ON (RED.co_barra_redacao  = COR4.co_barra_redacao AND RED.id_projeto = COR4.id_projeto AND COR4.id_tipo_correcao = 4)
	   LEFT JOIN USUARIOS_PESSOA    PES4 ON (COR4.id_corretor      = PES4.usuario_id)
	   LEFT JOIN CORRECOES_CORRECAO CORA ON (RED.co_barra_redacao  = CORA.co_barra_redacao AND RED.id_projeto = CORA.id_projeto AND CORA.id_tipo_correcao = 7)
	   LEFT JOIN USUARIOS_PESSOA    PESA ON (CORA.id_corretor      = PESA.usuario_id)
	   LEFT JOIN CORRECOES_ANALISE  ANA3 ON (ANA3.co_barra_redacao = RED.co_barra_redacao AND ANA3.id_tipo_correcao_B = 3 AND ANA3.aproveitamento = 1) 
WHERE red.cancelado = 0 and red.nota_final is not null
')
END
GO
