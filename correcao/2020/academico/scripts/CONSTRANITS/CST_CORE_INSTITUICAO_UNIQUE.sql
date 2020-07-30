-- criar
ALTER TABLE core_instituicao   
ADD CONSTRAINT UN_core_instituicao_NOME_CIDADE_ID UNIQUE (NOME, CIDADE_ID);   
GO  
-- apagar
ALTER TABLE core_instituicao   
drop CONSTRAINT UN_core_instituicao_NOME_CIDADE_ID