USE [ADMINISTRACAO]
GO
/****** Object:  StoredProcedure [dbo].[SP_BACKP_AUTOMATIZADO]    Script Date: 28/03/2020 16:03:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/**********************************************************************************************************************************  
*                                          BACKUP AUTOMATIZADO - SP_BACKP_AUTOMATIZADO                                            *  
*                                                                                                                                 *  
*  PROCEDURE QUE CORRE A TABELA [ADMINISTRACAO.controle_backup] E DISPARA O BACKUP NO S3 PARA TODAS QUE POSSUEM O CAMPO           *  
*   [FAZER_BACKUP = 1] E GRAVA A ORDEM EM QUE FOI GERADO DENTRO DO DIA (GRAVADO NO ARQUIVO BAK) PARA SER REFERENCIA NA HORA DE    *  
*   RESTAURAR                                                                                                                     *  
*                                                                                                                                 *  
* BANCO_SISTEMA : EDUCAT                                                                                                          *  
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:14/02/2020 *  
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:14/02/2020 *  
**********************************************************************************************************************************/  
-- EXEC SP_BACKP_AUTOMATIZADO
 -- SELECT * FROM controle_backup
ALTER    procedure [dbo].[SP_BACKP_AUTOMATIZADO] as   
DECLARE @DATABASE VARCHAR(200), @SQL VARCHAR(MAX), @ENDERECO VARCHAR(500), @posicao int

  
declare CUR_ cursor for   
 SELECT pri.NOME_BANCO, 
        endereco_backup =  CHAR(39) +'arn:aws:s3:::educat-feluma-rds-backups/PRD/' + pri.NOME_BANCO + '/'+ pri.NOME_BANCO + '_'+ CONVERT(VARCHAR(10), getdate(), 121 ) + '_' + convert(varchar(10),isnull(max(sec.posicao),1) + 1)+ 
                '.bak'+ CHAR(39),
		posicao = isnull(max(sec.posicao),1) + 1
   FROM controle_backup pri left join controle_backup sec on (pri.id = sec.id and 
                                                              cast(sec.ultima_acao as date) = cast(getdate() as date) )
   WHERE pri.FAZER_BACKUP = 1  
   group by pri.nome_banco
 open CUR_    
  fetch next from CUR_ into @DATABASE , @ENDERECO, @POSICAO
  while @@FETCH_STATUS = 0  
   BEGIN  
    SET @SQL = N'EXEC msdb.dbo.rds_backup_database        @source_db_name = ' + CHAR(39) +  @DATABASE + CHAR(39) +
	            ',        @s3_arn_to_backup_to = '+ @ENDERECO +',        @overwrite_S3_backup_file = 1;'   
    EXEC(@sql)  

   update controle_backup set arquivo_s3 = @ENDERECO, ultima_acao = getdate(), posicao = @posicao   where nome_banco = @DATABASE  
 
   fetch next from CUR_ into @DATABASE , @ENDERECO, @POSICAO  
   END  
 close CUR_   
deallocate CUR_   