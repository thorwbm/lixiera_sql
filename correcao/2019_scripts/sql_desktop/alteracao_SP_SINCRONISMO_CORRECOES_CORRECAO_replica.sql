/******************************************/
--  lembrar de de alterar o nome do campo 
--  antes de rodar esta alteracao
/*****************************************/

/****** Object:  StoredProcedure [dbo].[SP_SINCRONISMO_CORRECOES_CORRECAO]    Script Date: 17/10/2018 16:02:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SINCRONISMO_CORRECOES_CORRECAO] AS 

DECLARE @ID_LOG INT 
DECLARE @ID     INT 
DECLARE @CONT   INT
DECLARE @ACAO  VARCHAR(50)

declare CUR_COR_LOG cursor for 
	SELECT  ID_LOG, ACAO, ID  FROM sn_correcoes_CORRECAO_LOG
	WHERE SINCRONISMO = 0

	open CUR_COR_LOG 
		fetch next from CUR_COR_LOG into @ID_LOG, @ACAO, @ID
		while @@FETCH_STATUS = 0
			BEGIN
				SET @CONT = 0 
/*** INSERTES ***/
IF (@ACAO in ( 'INSERT','UPDATE'))	
	BEGIN
		merge correcoes_CORRECAO dst
		using (select * from sn_correcoes_correcao where id = @id) as ori 
		 on (dst.id = ori.id)
		when matched then
			update set 
				data_inicio			 = ORI.data_inicio			 ,
				data_termino		 = ORI.data_termino		 ,
				correcao			 = ORI.correcao			 ,
				link_imagem_recortada= ORI.link_imagem_recortada,
				link_imagem_original = ORI.link_imagem_original ,
				nota_final			 = ORI.nota_final			 ,
				competencia1		 = ORI.competencia1		 ,
				competencia2		 = ORI.competencia2		 ,
				competencia3		 = ORI.competencia3		 ,
				competencia4		 = ORI.competencia4		 ,
				competencia5		 = ORI.competencia5		 ,
				nota_competencia1	 = ORI.nota_competencia1	 ,
				nota_competencia2	 = ORI.nota_competencia2	 ,
				nota_competencia3	 = ORI.nota_competencia3	 ,
				nota_competencia4	 = ORI.nota_competencia4	 ,
				nota_competencia5	 = ORI.nota_competencia5	 ,
				id_auxiliar1		 = ORI.id_auxiliar1		 ,
				id_auxiliar2		 = ORI.id_auxiliar2		 ,
				id_correcao_situacao = ORI.id_correcao_situacao ,
				id_corretor			 = ORI.id_corretor			 ,
				id_status			 = ORI.id_status			 ,
				id_tipo_correcao	 = ORI.id_tipo_correcao	 ,
				id_projeto			 = ORI.id_projeto			 ,
				co_barra_redacao	 = ORI.co_barra_redacao	 ,
				tempo_em_correcao  = ORI.tempo_em_correcao,
				atualizado_por       = ori.atualizado_por,
				data_atualizacao	 = GETDATE()
		WHEN NOT MATCHED THEN
			INSERT (id, data_inicio, data_termino, correcao, link_imagem_recortada, link_imagem_original, nota_final,
			        competencia1, competencia2, competencia3, competencia4, competencia5,
				   nota_competencia1, nota_competencia2, nota_competencia3, nota_competencia4, nota_competencia5,
				    id_auxiliar1, id_auxiliar2, id_correcao_situacao, id_corretor, id_status, 
					id_tipo_correcao, id_projeto, co_barra_redacao, tempo_em_correcao, atualizado_por, data_atualizacao)
			VALUES (id, ori.data_inicio, ori.data_termino, ori.correcao, ori.link_imagem_recortada, 
					ori.link_imagem_original, ori.nota_final, ori.competencia1, ori.competencia2, 
					ori.competencia3, ori.competencia4, ori.competencia5, ori.nota_competencia1, 
					ori.nota_competencia2, ori.nota_competencia3, ori.nota_competencia4, ori.nota_competencia5, 
					ori.id_auxiliar1, ori.id_auxiliar2, ori.id_correcao_situacao, ori.id_corretor, ori.id_status, 
					ori.id_tipo_correcao, ori.id_projeto, ori.co_barra_redacao, ORI.tempo_em_correcao,
					ori.atualizado_por,
					 GETDATE());

			   SET @CONT = @CONT + @@ROWCOUNT
	END
ELSE IF (@ACAO = 'DELETE')	
	BEGIN
/*** DELETE ***/
		DELETE FROM correcoes_CORRECAO
		WHERE ID = @ID
		SET @CONT = @CONT + @@ROWCOUNT
	END

IF (@CONT > 0)
	BEGIN
		
		/** ATUALIZAR A TABELA DE LOG **/
		UPDATE sn_correcoes_CORRECAO_log SET 
			   sincronismo = 1, 
			   sincronismo_em = GETDATE()
		  WHERE id_log = @ID_LOG
	END

			fetch next from CUR_COR_LOG into  @ID_LOG, @ACAO, @ID
			END
	close CUR_COR_LOG 
deallocate CUR_COR_LOG 
