/****** Object:  StoredProcedure [dbo].[sp_libera_correcao]    Script Date: 24/11/2019 21:41:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[sp_libera_correcao] 
    @id_fila_pessoal int
AS

set nocount on

declare @id_correcao int
declare @id_tipo_correcao int
declare @co_barra_redacao varchar(50)
declare @corrigido_por varchar(255)
declare @id_projeto int
declare @id_grupo_corretor int
DECLARE @ID_INSERT INT 
DECLARE @REDACAO_ID INT

select @id_correcao = id_correcao from correcoes_filapessoal where id = @id_fila_pessoal

--Consulta dados da Correção
select @id_tipo_correcao = a.id_tipo_correcao, @co_barra_redacao = a.co_barra_redacao, @REDACAO_ID = A.redacao_id, @id_projeto = a.id_projeto, @id_grupo_corretor = b.id_grupo,

       @corrigido_por = ',' + (STUFF((
          SELECT ',' + convert(varchar(50), x.id_corretor)
          FROM correcoes_correcao x
          WHERE x.redacao_id = a.redacao_id and id <> @id_correcao
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
          ) + ','
  from correcoes_correcao a, correcoes_corretor b
 where a.id = @id_correcao and a.id_corretor = b.id

begin tran

-- CRIACAO LOG
	EXEC SP_INSERE_LOG_FILAPESSOAL @id_fila_pessoal, @ID_PROJETO, NULL, '-'
-- CRIACAO LOG 
delete from correcoes_filapessoal where id = @id_fila_pessoal

--CRIACAO LOG
INSERT INTO LOG_ocorrencias_ocorrencia
		(history_date, history_change_reason, history_type, history_user_id, observacao,
         id, data_solicitacao, data_resposta, data_fechamento, pergunta, resposta, nivel, dados_correcao, 
competencia1, competencia2, competencia3, competencia4, competencia5, correcao_situacao, img, 
atualizado_por, categoria_id, correcao_id, id_projeto, lote_solicitado_id, ocorrencia_pai_id, 
situacao_id, status_id, tipo_id, usuario_autor_id, usuario_responsavel_id, ocorrencia_relacionada_id

)
	SELECT dbo.getlocaldate(), null, '-', NULL, null,
	       id, data_solicitacao, data_resposta, data_fechamento, pergunta, resposta, nivel, dados_correcao, 
competencia1, competencia2, competencia3, competencia4, competencia5, correcao_situacao, img, 
atualizado_por, categoria_id, correcao_id, id_projeto, lote_solicitado_id, ocorrencia_pai_id, 
situacao_id, status_id, tipo_id, usuario_autor_id, usuario_responsavel_id, ocorrencia_relacionada_id
		FROM ocorrencias_ocorrencia
		WHERE ID IN (SELECT ID FROM ocorrencias_ocorrencia WHERE correcao_id = @id_correcao)
-- CRIACAO LOG - FIM 
delete from ocorrencias_ocorrencia where correcao_id = @id_correcao


-- CRIACAO LOG
INSERT INTO LOG_correcoes_historicocorrecao 
		(history_date, history_change_reason, history_type, history_user_id, observacao,
		id, dt_historico, data, correcao_id, evento_id, usuario_id)
SELECT dbo.getlocaldate(), null, '-', NULL, null,
		id, dt_historico, data, correcao_id, evento_id, usuario_id
	FROM correcoes_historicocorrecao
	WHERE id IN (SELECT ID FROM correcoes_historicocorrecao HIS 
	             WHERE correcao_id = @id_correcao)
-- CRIACAO LOG - FIM 
delete from correcoes_historicocorrecao where correcao_id = @id_correcao
   
-- LOG CORRECAO UPDATE 
	EXEC SP_INSERE_LOG_CORRECAO @id_correcao, @ID_PROJETO, NULL, '-'
-- LOG CORRECAO UPDATE FIM 
delete from correcoes_correcao where id = @id_correcao

if @id_tipo_correcao = 1 begin
    insert into correcoes_fila1 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao, REDACAO_ID)
    values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao, @REDACAO_ID);
	SET @ID_INSERT = SCOPE_IDENTITY()
	-- CRIACAO LOG 
		EXEC SP_INSERE_LOG_FILA1 @ID_INSERT, @ID_PROJETO, NULL,'+'
	-- CRIACAO LOG - FIM
end
if @id_tipo_correcao = 2 begin
    insert into correcoes_fila2 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao, REDACAO_ID)
    values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao, @REDACAO_ID);
	SET @ID_INSERT = SCOPE_IDENTITY()
	-- CRIACAO LOG 
		EXEC SP_INSERE_LOG_FILA2 @ID_INSERT, @ID_PROJETO, NULL,'+'
	-- CRIACAO LOG - FIM
end
if @id_tipo_correcao = 3 begin
    insert into correcoes_fila3 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao, REDACAO_ID)
    values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao, @REDACAO_ID);
	SET @ID_INSERT = SCOPE_IDENTITY()
	-- CRIACAO LOG 
		EXEC SP_INSERE_LOG_FILA3 @ID_INSERT, @ID_PROJETO, NULL,'+'
	-- CRIACAO LOG - FIM

end

set nocount off

print 'Correção retornada para fila' + convert(varchar(100), @id_tipo_correcao)

commit
GO
