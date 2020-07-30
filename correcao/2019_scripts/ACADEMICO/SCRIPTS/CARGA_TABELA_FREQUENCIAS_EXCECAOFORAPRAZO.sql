-- *** ASSOCIA A TABELA FREQUENCIAS_EXCECAOFREQUENCIAFORAPRAZO COM FREQUENCIAS_PROTOCOLOFREQUENCIAFORAPRAZO 
select distinct exc.*,pro.id 
 -- begin tran update exc set exc.protocolo_frequencia_fora_prazo_id = pza.protocolo_frequencia_fora_prazo_id
  from academico_aula aul        join frequencias_protocolofrequenciaforaprazo_aula pza on (aul.id = pza.aula_id)
                                 join frequencias_protocolofrequenciaforaprazo      pro on (pro.id = pza.protocolo_frequencia_fora_prazo_id)
                                 join protocolos_resolucao                          res on (res.protocolo_id = pro.protocolo_id and res.status_id = 1)
								 join protocolos_protocolo                          ptc on (ptc.id           = res.protocolo_id and categoria_id = 9)
                                 join frequencias_excecaofrequenciaforaprazo        exc on (exc.turma_disciplina_id = pro.turma_disciplina_id and
                                                                                            exc.professor_id        = pro.professor_id and 
																						    exc.grupo_aula_id       = aul.grupo_id)
where --pza.protocolo_frequencia_fora_prazo_id in (71,330) and 
      exc.protocolo_frequencia_fora_prazo_id is null 


-- commit 
-- rollback 