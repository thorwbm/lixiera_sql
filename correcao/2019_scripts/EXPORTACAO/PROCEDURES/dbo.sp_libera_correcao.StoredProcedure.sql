/****** Object:  StoredProcedure [dbo].[sp_libera_correcao]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_libera_correcao] 
	@id_fila_pessoal int
AS

set nocount on

declare @id_correcao int
declare @id_tipo_correcao int
declare @co_barra_redacao varchar(50)
declare @corrigido_por varchar(255)
declare @id_projeto int
declare @id_grupo_corretor int

select @id_correcao = id_correcao from correcoes_filapessoal where id = @id_fila_pessoal

--Consulta dados da Correção
select @id_tipo_correcao = a.id_tipo_correcao, @co_barra_redacao = a.co_barra_redacao, @id_projeto = a.id_projeto, @id_grupo_corretor = b.id_grupo,
       @corrigido_por = ',' + (STUFF((
          SELECT ',' + convert(varchar(50), x.id_corretor)
          FROM correcoes_correcao x
          WHERE x.co_barra_redacao = a.co_barra_redacao and id <> @id_correcao
          FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')
		  ) + ','
  from correcoes_correcao a, correcoes_corretor b
 where a.id = @id_correcao and a.id_corretor = b.id

begin tran

delete from correcoes_filapessoal where id = @id_fila_pessoal
delete from ocorrencias_ocorrencia where correcao_id = @id_correcao
delete from correcoes_historicocorrecao where correcao_id = @id_correcao
delete from correcoes_correcao where id = @id_correcao

if @id_tipo_correcao = 1 begin
	insert into correcoes_fila1 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
	values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end
if @id_tipo_correcao = 2 begin
	insert into correcoes_fila2 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
	values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end
if @id_tipo_correcao = 3 begin
	insert into correcoes_fila3 (corrigido_por, id_grupo_corretor, id_projeto, co_barra_redacao)
	values (@corrigido_por, @id_grupo_corretor, @id_projeto, @co_barra_redacao);
end

set nocount off

print 'Correção retornada para fila' + convert(varchar(100), @id_tipo_correcao)

commit
GO
