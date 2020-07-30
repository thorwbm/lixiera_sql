/**********************************************************************************************************************************
*                                                   [VW_FREQUENCIAS_PENDENTES]                                                    *
*                                                                                                                                 *
*  VIEW QUE RETORNA TODAS AS FREQUENCIAS QUE NAO FORAM AINDA ENVIADAS E CASO EXISTA ALGUM PROTOCOLO ASSOCIADO                     *
*                                                                                                                                 *
*                                                                                                                                 *
* BANCO_SISTEMA : ENEM                                                                                                            *
* CRIADO POR    : WEMERSON BITTORI MADURO                                                                         DATA:16/10/2019 *
* ALTERADO POR  : WEMERSON BITTORI MADURO                                                                         DATA:16/10/2019 *
**********************************************************************************************************************************/
-- select * from vw_frequencias_pendentes
create or alter view vw_frequencias_pendentes as 
with cte_protocolo as (
select fpz.professor_id, pro.user_id,  fpz.grupo_aula_id as grupo_id, fpz.turma_disciplina_id, 
       ptc.id as protocolo_id, ptc.mensagem, sta.id as status_id, sta.nome as sta_protocolo, 
	   ptc.criado_em
  from frequencias_protocolofrequenciaforaprazo fpz with(nolock) join academico_professor  pro with(nolock) on (pro.id = fpz.professor_id)
                                                                 join protocolos_protocolo ptc with(nolock) on (fpz.protocolo_id = ptc.id and 
                                                                                                                pro.user_id = ptc.requerido_por and 
																											    ptc.categoria_id = 9)
																 join protocolos_status    sta with(nolock) on (sta.id = ptc.status_id)
)

select distinct  cur.nome as curso, tur.nome as turma, dis.nome as disciplina,   
        data_inicio = isnull(GRA.data_inicio,''), 
        data_termino = isnull(GRA.data_termino,''), 
		pro.nome as professor, 
		sta.nome as situacao, 
		protocolo_id = isnull(convert(varchar(20),ptc.protocolo_id),''),
		protocolo    = ISNULL(ptc.mensagem,''), 
		status_protocolo = isnull(ptc.sta_protocolo,''), gra.id AS grupoaula_id

   from academico_aula                                     aul  with(nolock) 
        join academico_grupoaula                           gra  with(nolock) on (gra.id = aul.grupo_id)
		join academico_statusaula                          staG with(nolock) on (staG.id = GRA.status_id)
        join academico_turmadisciplina                     trd  with(nolock) on (trd.id = gra.turma_disciplina_id)
		join academico_turma                               tur  with(nolock) on (tur.id = trd.turma_id)
		join academico_disciplina                          dis  with(nolock) on (dis.id = trd.disciplina_id)
		join academico_curso                               cur  with(nolock) on (cur.id = tur.curso_id)
		join academico_professor                           pro  with(nolock) on (pro.id = aul.professor_id)
		join academico_statusaula                          sta  with(nolock) on (sta.id = aul.status_id)
		left join cte_protocolo                            ptc  with(nolock) on (ptc.grupo_id = gra.id and 
		                                                                         ptc.user_id  = pro.user_id and 
																                 Ptc.turma_disciplina_id = trd.id)
  where GRA.data_inicio >= '2017-07-01' and 
        gra.data_inicio <= getdate()    and 
		aul.status_id   <> 3

