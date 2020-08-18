--  exec sp_rel_relatorio_financeiro  
  
--select * from dnc_relatorio_financeiro where contrato_id = 11  
-- EXEC or alter sp_rel_relatorio_financeiro    
    
CREATE     procedure [dbo].[sp_rel_relatorio_financeiro] as       
declare @coluna_pivot varchar(200), @sql varchar(max), @sql_create varchar(max), @sql_view_create varchar(max)      
      
    exec sp_retorna_campo_pivot 'grupo_nome','VW_EXTRATO_FINANCEIRO', @coluna_pivot output        
      
 set @sql_create = @coluna_pivot      
 set @sql_create = replace(@coluna_pivot, ',',' float,')      
 set @sql_create = N'create table dnc_relatorio_financeiro ( contrato_id int, ano_competencia float, ' +      
                   ' mes_competencia int,valor_bruto int, valor_liquido float, valor_pago float, responsavel_id int, ' +   
       isnull(@sql_create,'desconto') + ' float)'      
         
drop table dnc_relatorio_financeiro      
 exec (@sql_create)      
       
 create index ix__dnc_relatorio_financeiro__contrato_id on dnc_relatorio_financeiro(contrato_id)   
 create index ix__dnc_relatorio_financeiro__ano_mes_competencia on dnc_relatorio_financeiro(ano_competencia, mes_competencia)      
 create index ix__dnc_relatorio_financeiro__contrato_ano_mes_competencia on dnc_relatorio_financeiro(contrato_id,ano_competencia, mes_competencia)      
      
      
   set @sql = N' SELECT *       
                 FROM (SELECT * from VW_EXTRATO_FINANCEIRO ) em_linha       
     pivot       
     (sum(valor_desconto) for  grupo_nome in ( ' + @coluna_pivot + ')) em_colunas ORDER BY CONTRATO_ID'      
      insert into dnc_relatorio_financeiro      
   EXEC (@SQL)       
      
   IF (EXISTS(select  1 from SYS.VIEWS  where NAME = 'VW_REL_EXTRATO_FINANCEIRO'))      
  BEGIN       
   DROP VIEW VW_REL_EXTRATO_FINANCEIRO      
  END ;      
      
   set @sql_view_create = N' create view VW_REL_EXTRATO_FINANCEIRO as       
                          select distinct LAN.ID AS LANCAMENTO_ID, CRC.ID AS CURRICULO_ID, CRC.NOME AS CURRICULO_NOME,      
                                    ALU.ID AS ALUNO_ID, ALU.NOME AS ALUNO_NOME, ALU.RA AS ALUNO_RA, CON.DATA_MATRICULA,       
                                 LAN.DATA_VENCIMENTO, LAN.PAGO_EM, LAN.VALOR_ACRESCIMOS, LAN.VALOR_DESCONTO_PONTUALIDADE,       
                                 JUROS = CASE WHEN LAN.VALOR_ACRESCIMOS > 0 THEN RLF.VALOR_LIQUIDO * (CAST(JSON_VALUE(LAN.EXTRA,' + char(39) + '$.multa.multa' + char(39) + ')AS FLOAT) /100.0 )     
                                                    ELSE 0 END,    
         MULTA = CASE WHEN LAN.VALOR_ACRESCIMOS > 0 THEN LAN.VALOR_ACRESCIMOS - (RLF.VALOR_LIQUIDO * (CAST(JSON_VALUE(LAN.EXTRA, ' + char(39) + '$.multa.multa' + char(39) + ')AS FLOAT) /100.0 ))     
                                                    ELSE 0 END,     
                                 RESPONSAVEL = res.NOME, STATUS_LANCAMENTO = STL.NOME, STATUS_ALUNO = CAS.NOME,      
                                 RLF.*      
                               from dnc_relatorio_financeiro rlf left join contratos_contrato con on (con.id = rlf.contrato_id)      
                                       join curriculos_curriculo  crc on (crc.id = con.curriculo_id)      
                                       join academico_aluno       alu on (alu.id = con.aluno_id)      
                                       join financeiro_lancamento lan on (con.id = lan.contrato_id and      
                                                                 rlf.ano_competencia = lan.ano_competencia and      
                       rlf.mes_competencia = lan.mes_competencia and   
       --rlf.valor_bruto      = lan.valor_bruto and   
       rlf.responsavel_id   = lan.responsavel_id)         
            join financeiro_statuslancamento stl on (stl.id = lan.status_id)      
   join pessoas_pessoa              res on (res.id = lan.responsavel_id)      
          LEFT JOIN curriculos_aluno            CRA ON (ALU.ID = CRA.aluno_id AND       
                                                     CRC.ID = CRA.curriculo_id)      
          LEFT JOIN curriculos_statusaluno      CAS ON (CAS.ID = CRA.status_id)'      
   exec (@sql_view_create)  