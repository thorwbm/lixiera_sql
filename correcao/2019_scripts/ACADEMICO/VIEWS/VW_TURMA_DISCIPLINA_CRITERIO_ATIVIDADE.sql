/**********************************************************************************************************************************  
*                                             VW_TURMA_DISCIPLINA_CRITERIO_ATIVIDADE                                              *  
*                                                                                                                                 *  
*  VIEW QUE AGRUPA TURMAS DISCIPLINAS CRITERIOS E ATIVIDADES                                                                      *  
*                                                                                                                                 *  
*                                                                                                                                 *  
* BANCO_SISTEMA : EDUCAT                                                                                                          *  
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:15/10/2019 *  
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:15/10/2019 *  
**********************************************************************************************************************************/  
create or alter view vw_turma_disciplina_criterio_atividade as   
select ati.criterio_turma_disciplina_id, turma_id = tur.id, turma_nome = tur.nome, eta.ano, eta.periodo, etp.etapa, tio.nome as tipo_oferta, 
       disciplina_id = dis.id, disciplina_nome = dis.nome,   
       criterio_id = cri.id, criterio_nome = cri.nome, criterio_valor = cri.valor,  
    atividade_id = ati.id, atividade_nome = ati.nome, atividade_valor = ati.valor  
  from academico_turmadisciplina trd with(nolock) join academico_turma                     tur with(nolock) on (tur.id = trd.turma_id)  
                                                  join academico_etapaano                  eta with(nolock) on (eta.id = tur.etapa_ano_id)
												  join academico_etapa                     etp with(nolock) on (etp.id = eta.etapa_id)
                                                  join academico_disciplina                dis with(nolock) on (dis.id = trd.disciplina_id)
												  join academico_cursooferta               cuo with(nolock) on (cuo.id = etp.curso_oferta_id)
												  join academico_tipooferta                tio with(nolock) on (tio.id = cuo.tipo_oferta_id)   
              join atividades_criterio_turmadisciplina ctd with(nolock) on (trd.id = ctd.turma_disciplina_id)  
              join atividades_criterio                 cri with(nolock) on (cri.id = ctd.criterio_id)  
              join atividades_atividade                ati with(nolock) on (ctd.id = ati.criterio_turma_disciplina_id)




