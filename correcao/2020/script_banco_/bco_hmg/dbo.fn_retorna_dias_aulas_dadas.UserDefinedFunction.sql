USE [erp_hmg]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_retorna_dias_aulas_dadas]    Script Date: 12/02/2020 15:40:52 ******/
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
