USE [erp_hmg]
GO
/****** Object:  View [dbo].[vw_contrato_parcela_desconto_aluno]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_contrato_parcela_desconto_aluno] as   
select alu.ra as aluno_ra, alu.nome as aluno_nome,   
       con.id as contrato_id,   
    par.id as parcela_id, par.descricao as parcela_nome, par.data_vencimento, par.mes_competencia, par.ano_competencia, par.valor as parcela_desc,   
    dsc.id as desconto_id, dsc.descricao as desconto_desc, dsc.valor as desconto_valor  
from contratos_contrato con join contratos_parcela par on (con.id = par.contrato_id)  
                           left join contratos_desconto dsc on (par.id = dsc.parcela_id)  
       join academico_aluno    alu on (alu.id = con.aluno_id)  
GO
