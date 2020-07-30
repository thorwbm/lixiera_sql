select distinct prz.protocolo_id, prz.turma_disciplina_id, prz.professor_id , pro.nome as professor_nome, tda.turma_nome, tda.disciplina_nome, tda.turma_disciplina_id
from frequencias_protocolofrequenciaforaprazo prz join frequencias_protocolofrequenciaforaprazo_aula pza on (prz.id = pza.protocolo_frequencia_fora_prazo_id)
                                                  join academico_professor                           pro on (prz.professor_id = pro.id)
												  join vw_curso_turma_disciplina                     tda on (tda.turma_disciplina_id = prz.turma_disciplina_id)
                                             left join vw_aula_professor_turma_disciplina            pta on (pta.turma_disciplina_id = prz.turma_disciplina_id and 
											                                                                 pta.professor_id        = prz.professor_id and 
																											 pta.aula_id             = pza.aula_id)
where pta.turma_disciplina_id is null 


select * from vw_curso_turma_disciplina