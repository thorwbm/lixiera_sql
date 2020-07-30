-- criar constraint 
ALTER TABLE academico_professor 
ADD CONSTRAINT academico_professor_UK_nome UNIQUE (nome);   
GO
-- dropar constraint
ALTER TABLE academico_professor 
drop CONSTRAINT academico_professor_UK_nome