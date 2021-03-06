/******************************************/
--  lembrar de de alterar o nome do campo 
--  antes de rodar esta alteracao
/*****************************************/


/****** Object:  Trigger [dbo].[TR_UPDATE_DELETE_CORRECOES_CORRECAO_LOG]    Script Date: 17/10/2018 15:44:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[TR_UPDATE_DELETE_CORRECOES_CORRECAO_LOG]
   ON [dbo].[correcoes_correcao]
	INSTEAD OF update, DELETE   
AS   
	BEGIN  
		SET NOCOUNT ON;  
  
		IF(EXISTS(SELECT 1 FROM inserted))  
			BEGIN
				declare @id_aux int  
  
				declare cur_cor_upd_log cursor for   
				SELECT id FROM INSERTED   
				
				open cur_cor_upd_log   
				fetch next from cur_cor_upd_log into @id_aux  
				while @@FETCH_STATUS = 0  
					BEGIN			  
						INSERT INTO CORRECOES_CORRECAO_LOG (
								id, data_inicio, data_termino, correcao, link_imagem_recortada,
								link_imagem_original, nota_final, 
								competencia1, competencia2, competencia3, competencia4, competencia5, nota_competencia1, 
								nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5, id_auxiliar1, 
								id_auxiliar2, id_correcao_situacao, id_corretor, id_status, id_tipo_correcao, co_barra_redacao,
								 id_projeto, tempo_em_correcao, 
								data_log, acao, sincronismo, sincronismo_em

						)
						SELECT  COR.id, COR.data_inicio, COR.data_termino, COR.correcao, COR.link_imagem_recortada,
								COR.link_imagem_original, COR.nota_final, COR.competencia1, COR.competencia2, COR.competencia3, 
								COR.competencia4, COR.competencia5, COR.nota_competencia1, COR.nota_competencia2, COR.nota_competencia3, 
								COR.nota_competencia4, COR.nota_competencia5, COR.id_auxiliar1, COR.id_auxiliar2, COR.id_correcao_situacao, 
								COR.id_corretor, COR.id_status, COR.id_tipo_correcao, COR.co_barra_redacao, COR.id_projeto, COR.tempo_em_correcao,
								GETDATE(),'UPDATE',0,null 
						FROM CORRECOES_CORRECAO COR JOIN inserted INS ON (COR.ID = INS.ID)
						WHERE COR.ID = @ID_AUX

	
						UPDATE COR SET
								COR.data_inicio               = INS.data_inicio    ,           
								COR.data_termino			  = INS.data_termino	,		  
								COR.correcao				  = INS.correcao		,		  
								COR.link_imagem_recortada	  = INS.link_imagem_recortada,	  
								COR.link_imagem_original	  = INS.link_imagem_original	 , 
								COR.nota_final				  = INS.nota_final				  ,
								COR.competencia1			  = INS.competencia1			  ,
								COR.competencia2			  = INS.competencia2			  ,
								COR.competencia3			  = INS.competencia3			  ,
								COR.competencia4			  = INS.competencia4			  ,
								COR.competencia5			  = INS.competencia5			  ,
								COR.nota_competencia1		  = INS.nota_competencia1		  ,
								COR.nota_competencia2		  = INS.nota_competencia2		  ,
								COR.nota_competencia3		  = INS.nota_competencia3		  ,
								COR.nota_competencia4		  = INS.nota_competencia4		  ,
								COR.nota_competencia5		  = INS.nota_competencia5		  ,
								COR.id_auxiliar1			  = INS.id_auxiliar1			  ,
								COR.id_auxiliar2			  = INS.id_auxiliar2			  ,
								COR.id_correcao_situacao	  = INS.id_correcao_situacao	  ,
								COR.id_corretor				  = INS.id_corretor				  ,
								COR.id_status				  = INS.id_status				  ,
								COR.id_tipo_correcao		  = INS.id_tipo_correcao		  ,
								COR.id_projeto				  = INS.id_projeto				  ,
								COR.co_barra_redacao          = INS.co_barra_redacao          ,
								COR.tempo_em_correcao         = INS.tempo_em_correcao
					  
						FROM CORRECOES_CORRECAO COR JOIN inserted INS ON (COR.ID = INS.ID)     
					   WHERE COR.ID = @ID_AUX

		        	fetch next from cur_cor_upd_log into @ID_AUX  
				END  
				close cur_cor_upd_log   
				deallocate cur_cor_upd_log
			END  
		ELSE IF (EXISTS (SELECT 1 FROM DELETED))  
			BEGIN   
				declare @id_aux_DEL int  
  
				declare cur_cor_upd_log_DEL cursor for   
				SELECT id FROM DELETED   
				
				open cur_cor_upd_log_DEL   
				fetch next from cur_cor_upd_log_DEL into @id_aux_DEL  
				while @@FETCH_STATUS = 0  
					BEGIN 
						INSERT INTO CORRECOES_CORRECAO_LOG (
								id, data_inicio, data_termino, correcao, link_imagem_recortada,
								link_imagem_original, nota_final, 
								competencia1, competencia2, competencia3, competencia4, competencia5, nota_competencia1, 
								nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5, id_auxiliar1, 
								id_auxiliar2, id_correcao_situacao, id_corretor, id_status, id_tipo_correcao, co_barra_redacao,
								 id_projeto, minutos_em_cotempo_em_correcaorrecao,
								data_log, acao, sincronismo, sincronismo_em
						)
						SELECT COR.id, COR.data_inicio, COR.data_termino, COR.correcao, COR.link_imagem_recortada,
							   COR.link_imagem_original, COR.nota_final, COR.competencia1, COR.competencia2, COR.competencia3, 
							   COR.competencia4, COR.competencia5, COR.nota_competencia1, COR.nota_competencia2, COR.nota_competencia3, 
							   COR.nota_competencia4, COR.nota_competencia5, COR.id_auxiliar1, COR.id_auxiliar2, COR.id_correcao_situacao, 
							   COR.id_corretor, COR.id_status, COR.id_tipo_correcao, COR.co_barra_redacao, COR.id_projeto, COR.tempo_em_correcao,
							GETDATE(),'DELETE',0,null 
						FROM CORRECOES_CORRECAO COR 
						 WHERE COR.ID = @ID_AUX_DEL     
  
						  DELETE FROM CORRECOES_CORRECAO  
						  WHERE ID = @ID_AUX_DEL    
  
		        	fetch next from cur_cor_upd_log_DEL into @ID_AUX_DEL  
				END  
				close cur_cor_upd_log_DEL   
				deallocate cur_cor_upd_log_DEL   
			END  
	END
