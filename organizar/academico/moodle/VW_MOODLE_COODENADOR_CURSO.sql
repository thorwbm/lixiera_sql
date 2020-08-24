create view VW_MOODLE_COODENADOR_CURSO AS 
select coo.id as coordenador_id, usu.nome_civil as coordenador_nome, 
       cur.id as curso_id, cur.nome as curso_nome, 
	   data_inicio, data_termino
from academico_coordenadorcurso coo join auth_user usu on (usu.id = coo.user_id)
                                    join academico_curso cur on (cur.id = coo.curso_id)

