--drop table  tmp_importacao_monitoria_2019  -- 23504 
select  *, criado_em = getdate() 
   into tmp_importacao_monitoria_2019  
from vw_disciplina_cursada_aluno_monitoria
where aluno_nome = 'Ana Carolina Dias Almeida' and 
      disciplina = 'Técnicas Operatórias'
select * from academico_aluno where nome = 	   'MARCOS SALOMAO STAUT AVELAR'
select * from curriculos_aluno where aluno_id = 60279
select * from academico_disciplina where nome = 'TREINAMENTO DE HABILIDADES'

	  select * from curriculos_errofechamentodisciplina 
	  where aluno_id = 60115
	    and disciplina_id = 8081