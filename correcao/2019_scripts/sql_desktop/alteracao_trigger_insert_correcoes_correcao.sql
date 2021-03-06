/******************************************/
--  lembrar de de alterar o nome do campo 
--  antes de rodar esta alteracao
/*****************************************/


/****** Object:  Trigger [dbo].[TR_INSERT_CORRECOES_CORRECAO_LOG]    Script Date: 17/10/2018 15:42:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/** XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  **/ 
  
/*****************************************************************************************************************  
*                                 TRIGGER PARA INSERT DA TABELA CORRECOES_CORRECAO                               *  
*                                                                                                                *  
*  AO INSERIR NA TABELA CORRECOES_CORRECAO E GERADO UM LOG NA TABELA CORRECOES_CORRECAO_LOG                      *  
*                                                                                                                *  
*                                                                                                                *  
* BANCO_SISTEMA : ENCCEJA                                                                                        *  
* CRIADO POR    : WEMERSON BITTORI MADURO                                                        DATA:27/08/2018 *  
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                        DATA:27/08/2018 *  
******************************************************************************************************************/  
  
ALTER TRIGGER [dbo].[TR_INSERT_CORRECOES_CORRECAO_LOG]  
   ON [dbo].[correcoes_correcao]  
  after insert  
AS   
 BEGIN  
  declare @id_aux int    
    
  declare cur_cor_ins_log cursor for     
  SELECT id FROM INSERTED     
      
  open cur_cor_ins_log     
  fetch next from cur_cor_ins_log into @id_aux    
  while @@FETCH_STATUS = 0    
   BEGIN  
    insert CORRECOES_CORRECAO_LOG (  
           id, data_inicio, data_termino, correcao, link_imagem_recortada, link_imagem_original,  
        nota_final, competencia1, competencia2, competencia3, competencia4, competencia5,   
        nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,  
        id_auxiliar1, id_auxiliar2, id_correcao_situacao, id_corretor, id_status, id_tipo_correcao,   
        id_projeto, co_barra_redacao, tempo_em_correcao,  atualizado_por,
        data_log, acao, sincronismo, sincronismo_em)  
    select id, data_inicio, data_termino, correcao, link_imagem_recortada, link_imagem_original,   
           nota_final, competencia1, competencia2, competencia3, competencia4, competencia5,   
        nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,  
        id_auxiliar1, id_auxiliar2, id_correcao_situacao, id_corretor, id_status, id_tipo_correcao,   
        id_projeto, co_barra_redacao, tempo_em_correcao, atualizado_por,
        getdate(),'INSERT',0,NULL   
      FROM inserted   
     where id = @id_aux  
  
  fetch next from cur_cor_ins_log into @ID_AUX    
  END    
  close cur_cor_ins_log     
  deallocate cur_cor_ins_log    
 END  
