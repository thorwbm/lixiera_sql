/****** Object:  View [dbo].[vw_distribiucao_faixa_ouro]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE view [dbo].[vw_distribiucao_faixa_ouro] as 
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
