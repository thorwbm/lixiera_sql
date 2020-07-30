/****** Object:  StoredProcedure [dbo].[sp_gera_entregas]    Script Date: 26/12/2019 13:14:39 ******/
DROP PROCEDURE IF EXISTS [dbo].[sp_gera_entregas]
GO
/****** Object:  StoredProcedure [dbo].[sp_gera_entregas]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sp_gera_entregas] as
begin
	
	--Copia os dados mais atualizados da correção
    exec sp_copia_dados 

    exec sp_gera_lote_n59

	-- exec sp_gera_lote_n65 -- corretores sem referencia na view do aurelio
	-- exec sp_gera_lote_n67 -- OK
	-- exec sp_gera_lote_n68 -- OK
	-- exec sp_gera_lote_n69 -- OK
	-- exec sp_gera_lote_n70 -- OK
end 
GO
