-- OTIMIZACAO DA FUNCAO 20201005
create or ALTER     FUNCTION [dbo].[fn_cor_corretor_redacao_por_id](@redacao_id int)
RETURNS VARCHAR(1000)
BEGIN
    DECLARE @RETORNO varchar(1000)
    declare @id_corretor int

    set @retorno = ''

 select @retorno =
STUFF((SELECT ',,'+convert(varchar(20), id_corretor)
    from correcoes_correcao
     where redacao_id = @redacao_id
    FOR XML PATH('')),1,1,'') 

return (@retorno)

END
go

-- OTIMIZACAO DA FUNCAO 20201005
create or ALTER   FUNCTION [dbo].[fn_cor_corretor_redacao](@co_barra_redacao VARCHAR(1000))
RETURNS VARCHAR(1000)
BEGIN
    DECLARE @RETORNO varchar(1000)
    declare @id_corretor int

    set @retorno = ''

 select @retorno =
STUFF((SELECT ',,'+convert(varchar(20), id_corretor)
    from correcoes_correcao
     where co_barra_redacao = @co_barra_redacao
    FOR XML PATH('')),1,1,'') 

return (@retorno)

END
