/****** Object:  UserDefinedFunction [dbo].[fn_calcula_nota_desempenho_ouro_moda]    Script Date: 04/10/2019 10:24:44 ******/
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
