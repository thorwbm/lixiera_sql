/****** Object:  UserDefinedFunction [dbo].[fu_tmp_nacionalidade]    Script Date: 28/11/2019 11:41:42 ******/
DROP FUNCTION [dbo].[fu_tmp_nacionalidade]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_tmp_importancia_titulacao]    Script Date: 28/11/2019 11:41:42 ******/
DROP FUNCTION [dbo].[fu_tmp_importancia_titulacao]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_time_text_to_number]    Script Date: 28/11/2019 11:41:42 ******/
DROP FUNCTION [dbo].[fu_time_text_to_number]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_time_text]    Script Date: 28/11/2019 11:41:42 ******/
DROP FUNCTION [dbo].[fu_time_text]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_time_number_to_text]    Script Date: 28/11/2019 11:41:42 ******/
DROP FUNCTION [dbo].[fu_time_number_to_text]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_retorna_dias_aulas_dadas]    Script Date: 28/11/2019 11:41:42 ******/
DROP FUNCTION [dbo].[fn_retorna_dias_aulas_dadas]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_retorna_colunas_tabela]    Script Date: 28/11/2019 11:41:42 ******/
DROP FUNCTION [dbo].[fn_retorna_colunas_tabela]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_retorna_colunas_tabela]    Script Date: 28/11/2019 11:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--  select dbo.fn_retorna_colunas_tabela('academico_aula')

create   function [dbo].[fn_retorna_colunas_tabela] (@tabela varchar(100)) 
returns varchar(1000)
as 
begin 
    declare @cols nvarchar(max);
	with cte_temp as (
	SELECT distinct TABLE_NAME, COLUMN_NAME		 
		  FROM INFORMATION_SCHEMA.COLUMNS
         WHERE TABLE_NAME = @tabela 
	)
	select  @cols = stuff((
		select distinct ',' 
		+ quotename(COLUMN_NAME) 
			from cte_temp for xml path('')
                  ), 1,1, '' )

	 return  replace(replace(@cols,'[',''),']','')
end 
GO
/****** Object:  UserDefinedFunction [dbo].[fn_retorna_dias_aulas_dadas]    Script Date: 28/11/2019 11:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_retorna_dias_aulas_dadas] (@turma_disciplina_id int, @professor_id int, @ano int, @semetre int) 
returns varchar(1000)
as 
begin 
    declare @cols nvarchar(max);
	with cte_temp as (
	SELECT distinct cast(aula_data_ini as date) as aula_data, professor_id, turma_disciplina_id
		 
		  FROM vw_aulas_aluno_professor_frequencia
         WHERE turma_disciplina_id = @turma_disciplina_id and 
		       professor_id = @professor_id
	)
	select  @cols = stuff((
		select distinct ',' 
		+ quotename(aula_data) 
			from cte_temp  for xml path('')
                  ), 1,1, '')

	 return  @cols
end 

		

   



GO
/****** Object:  UserDefinedFunction [dbo].[fu_time_number_to_text]    Script Date: 28/11/2019 11:41:42 ******/
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
/****** Object:  UserDefinedFunction [dbo].[fu_time_text]    Script Date: 28/11/2019 11:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[fu_time_text] (@time varchar(50)) 
returns varchar(50) as
begin
  declare @hour_part varchar(50)
  declare @dec_part  varchar(10)

  if not @time is null begin
    set @hour_part = convert(int, left(@time, charindex(':', @time) - 1))
    set @dec_part = substring(@time, charindex(':', @time) + 1, len(@time))

    return @hour_part + ':' + @dec_part
  end

  return null
end
GO
/****** Object:  UserDefinedFunction [dbo].[fu_time_text_to_number]    Script Date: 28/11/2019 11:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[fu_time_text_to_number] (@time varchar(50)) 
returns numeric(10, 2) as
begin
  declare @hour_part int
  declare @dec_part int

  if not @time is null begin
    set @hour_part = convert(int, left(@time, charindex(':', @time) - 1))
    set @dec_part = convert(int, substring(@time, charindex(':', @time) + 1, len(@time)))

    return @hour_part + (@dec_part / 60.00)
  end

  return null
end
GO
/****** Object:  UserDefinedFunction [dbo].[fu_tmp_importancia_titulacao]    Script Date: 28/11/2019 11:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[fu_tmp_importancia_titulacao] (@titulacao varchar(50)) 
returns int as
begin

if @titulacao = 'PÓS-DOUTORADO' begin return 10 end
if @titulacao = 'PÓS-DOUTORA' begin return 10 end
if @titulacao = 'DOUTOR' begin return 20 end
if @titulacao = 'DOUTORA' begin return 20 end
if @titulacao = 'MESTRE' begin return 30 end
if @titulacao = 'MESTRADO' begin return 30 end
if @titulacao = 'MBA' begin return 40 end
if @titulacao = 'ESPECIALIZAÇÃO' begin return 50 end

  return null
end
GO
/****** Object:  UserDefinedFunction [dbo].[fu_tmp_nacionalidade]    Script Date: 28/11/2019 11:41:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create   function [dbo].[fu_tmp_nacionalidade] (@pais varchar(50)) 
returns varchar(100) as
begin

if @pais = 'BRASIL' begin return 'BRASILEIRA' end
if @pais = 'ALEMANHA' begin return 'ALEMÃO' end
if @pais = 'BELGICA' begin return 'BELGA' end
if @pais = 'BOLÍVIA' begin return 'BOLIVIANO' end
if @pais = 'INGLATERRA' begin return 'BRITANICO' end
if @pais = 'CANADA' begin return 'CANADENSE' end
if @pais = 'CHILE' begin return 'CHILENO' end
if @pais = 'CHINA' begin return 'CHINÊS' end
if @pais = 'COREIA' begin return 'COREANO' end
if @pais = 'CUBA' begin return 'CUBANA' end
if @pais = 'ESPANHA' begin return 'ESPANHOL' end
if @pais = 'FRANÇA' begin return 'FRANCÊS' end
if @pais = 'IRAQUE' begin return 'IRAQUIANA' end
if @pais = 'ITÁLIA' begin return 'ITALIANO' end
if @pais = 'JAPÃO' begin return 'JAPONESA' end
if @pais = 'Estados Unidos Da América (Eua)' begin return 'NORTE-AMERICANO' end
if @pais = 'ESTADOS UNIDOS DA AMÉRICA' begin return 'NORTE-AMERICANO' end
if @pais = 'PARAGUAI' begin return 'PARAGUAIO' end
if @pais = 'PORTUGAL' begin return 'PORTUGUÊS' end
if @pais = 'SUIÇA' begin return 'SUIÇO' end
if @pais = 'URUGUAI' begin return 'URUGUAIO' end
if @pais = 'CHINA' begin return 'CHINESA' end
if @pais = 'GUATEMALA' begin return 'GUATEMALTECO' end
if @pais = 'PERU' begin return 'PERUANA' end
if @pais = 'SALVADOR' begin return 'SALVADOR' end
if @pais = 'PORTUGAL' begin return 'PORTUGUESA' end
if @pais = 'HONDURAS' begin return 'HONDURENHA' end
if @pais = 'ANGOLA' begin return 'ANGOLANO' end
if @pais = 'COLOMBIA' begin return 'COLOMBIANA' end
if @pais = 'REPÚBLICA DOMINICANA' begin return 'DOMINICANA' end
if @pais = 'MOÇAMBIQUE' begin return 'MOÇAMBICANA' end
if @pais = 'FILIPINAS' begin return 'FILIPINAS' end
if @pais = 'FILIPINAS' begin return 'FILIPINO' end
if @pais = 'VENEZUELA' begin return 'VENEZUELANA' end
if @pais = 'EQUADOR' begin return 'EQUATORIANA' end
if @pais = 'BRASIL' begin return 'Brasil' end
if @pais = 'ALEMANHA' begin return 'Alemanha' end
if @pais = 'COLOMBIA' begin return 'Colômbia' end
if @pais = 'AFEGANISTÃO' begin return 'Afeganistão' end
  return null
end
GO
