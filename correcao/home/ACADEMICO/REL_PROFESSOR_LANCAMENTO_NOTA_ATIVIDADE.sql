create or alter view vw_acd_rel_criterio_atividade as 
WITH   CTE_ATIVIDADE_NAO_ENVIADA AS (
            SELECT AAU.atividade_id, count(aal.id) as NOTAS_LANCADAS,
                   SUM(DISTINCT CASE WHEN AAL.divulgada_em IS NULL THEN 0 ELSE 1 END) AS NOTA_DIVULGADA
              FROM  atividades_atividade_aula AAU LEFT JOIN atividades_atividade_aluno AAL ON (AAL.atividade_id = AAU.atividade_id)
             GROUP BY AAU.ATIVIDADE_ID
)

SELECT DISTINCT 
       VW.CURSO_NOME, vw.CURRICULO_NOME, VW.professor_nome, VW.turma_nome,VW.disciplina_nome,  
       cri.nome as criterio_nome, cri.valor as criterio_valor,ati.nome as atividade_nome,ATI.VALOR AS ATIVIDADE_VALOR, 
       CASE WHEN ATI.ID IS NULL THEN 'SEM ATIVIDADE' ELSE 'TEM ATIVIDADE' END AS ATIVIDADE,
       CASE WHEN ANE.NOTAS_LANCADAS = 0 THEN 'NAO LANCADO' ELSE CASE WHEN ATI.ID IS NULL THEN 'NAO LANCADO' ELSE 'LANCADO' END END AS LANCAMENTO_NOTA,
       CASE WHEN ANE.NOTA_DIVULGADA = 0 THEN 'NAO DIVULGADO' ELSE  CASE WHEN ATI.ID IS NULL THEN 'NAO DIVULGADO' ELSE 'DIVULGADO' END END AS DIVULGACAO_NOTA, 
       year(vw.inicio_vigencia) as ano
  FROM vw_acd_curriculo_curso_turma_disciplina_professor VW JOIN atividades_criterio_turmadisciplina ACT ON (VW.turmadisciplina_id = ACT.turma_disciplina_id AND 
                                                                                                             VW.professor_id = ACT.professor_id)
                                                            JOIN ATIVIDADES_CRITERIO                 CRI ON (CRI.ID = ACT.criterio_id)
                                                       LEFT JOIN ATIVIDADES_ATIVIDADE                ATI ON (ACT.ID = ATI.criterio_turma_disciplina_id)
                                                       LEFT JOIN CTE_ATIVIDADE_NAO_ENVIADA           ANE ON (ATI.ID = ANE.atividade_id)
 
 
 where year(vw.inicio_vigencia) = 2020
 order by curriculo_nome, curso_nome, professor_nome, disciplina_nome, turma_nome, criterio_nome, atividade_nome


/*
create view vw_acd_curriculo_curso_turma_disciplina_professor as 
select distinct 
       crc.id as curriculo_id, crc.nome as curriculo_nome, 
       cur.id as curso_id, cur.nome as curso_nome, 
       tof.id as tipooferta_id, tof.nome as tipooferta_nome, 
       tur.id as turma_id, tur.nome as turma_nome, tur.inicio_vigencia, tur.termino_vigencia,
       dis.id as disciplina_id, dis.nome as disciplina_nome, 
       tds.id as turmadisciplina_id, 
       pro.id as professor_id, pro.nome as professor_nome
  from academico_turmadisciplina tds join academico_turma                    tur on (tur.id = tds.turma_id)
                                     join academico_curso                    cur on (cur.id = tur.curso_id)
                                     join academico_disciplina               dis on (dis.id = tds.disciplina_id)
                                     join curriculos_curriculo               crc on (cur.id = crc.curso_id)
                                     join academico_cursooferta              cof on (cof.id = crc.curso_oferta_id)
                                     join academico_tipooferta               tof on (tof.id = cof.tipo_oferta_id)
                                     join academico_turmadisciplinaprofessor tdp on (tds.id = tdp.turma_disciplina_id)
                                     join academico_professor                pro on (pro.id = tdp.professor_id)
*/
with cte_nao_lancou_nota as (
select td.id as turmadisciplinaid, ctd.id as atividadecriterioturmadisciplinaid, 
       prof.id as professorid, cri.id as criterioid,  atv.id as atividadeid, 
	   aula.data_inicio as data_atividade,  YEAR(turma.inicio_vigencia) AS ANO,
	   count(atva.id) as alunos_com_nota_lanacda
  from atividades_criterio_turmadisciplina ctd
       join atividades_atividade atv on atv.criterio_turma_disciplina_id = ctd.id
       join atividades_criterio cri on cri.id = ctd.criterio_id
       join academico_turmadisciplina td on td.id = ctd.turma_disciplina_id
       join academico_turma turma on turma.id = td.turma_id
       left outer join academico_professor prof on prof.id = ctd.professor_id
       left outer join atividades_atividade_aluno atva on atva.atividade_id = atv.id and atva.divulgada_em is not null
       left outer join atividades_atividade_aula atvau on atvau.atividade_id = atv.id
       left outer join academico_aula aula on aula.id = atvau.aula_id and aula.data_inicio = (select min(aula2.data_inicio)
	                                                                                            from academico_aula aula2
																								     join atividades_atividade_aula atvau2 on atvau2.aula_id = aula2.id
																									                                      and atvau2.atividade_id = atv.id)
 where  turma.inicio_vigencia is not null
   and turma.termino_vigencia is not null
  
group by td.id, ctd.id, prof.id, cri.id,  atv.id, aula.data_inicio ,YEAR(turma.inicio_vigencia)
       having count(atva.id) = 0
)

-- professores que nao cadastraram atividades para um criterio 
    ,   cte_sem_atividade_criterio as (
select cri.id as criterio_id, pro.id as professor_id, tds.id as turmadisciplina_id, year(tur.inicio_vigencia) AS ANO
from atividades_criterio_turmadisciplina actd
join academico_turmadisciplina           tds on tds.id = actd.turma_disciplina_id
join academico_turma                     tur on tur.id = tds.turma_id
join atividades_criterio                 cri on cri.id = actd.criterio_id
join academico_professor                 pro on pro.id = actd.professor_id
where actd.id not in (select criterio_turma_disciplina_id from atividades_atividade)

) 

select DISTINCT vw.*, cri.nome as criterio_nome,
       CASE WHEN sac.turmadisciplina_id IS NOT NULL THEN 'SEM ATIVIDADE' ELSE 'COM ATIVIDADE' END  as sem_atividade , 
       CASE WHEN nln.turmadisciplinaid IS NOT NULL THEN 'NAO LANCOU NOTA' ELSE  CASE WHEN sac.turmadisciplina_id IS NOT NULL THEN 'NAO LANCOU NOTA' ELSE 'LANCOU NOTA' END END AS SEM_NOTA
  from vw_acd_curriculo_curso_turma_disciplina_professor vw join atividades_criterio_turmadisciplina ctd on (ctd.turma_disciplina_id = vw.turmadisciplina_id)
                                                            join atividades_criterio                 cri on (cri.id = ctd.criterio_id)
                                                       left join cte_sem_atividade_criterio          sac on (sac.turmadisciplina_id = vw.turmadisciplina_id and 
                                                                                                             sac.professor_id = vw.professor_id and 
                                                                                                             sac.criterio_id  = ctd.criterio_id AND
                                                                                                             SAC.ANO = year(vw.inicio_vigencia))
                                                       left join cte_nao_lancou_nota                 nln on (nln.turmadisciplinaid = vw.turmadisciplina_id and 
                                                                                                             cri.id = nln.criterioid and 
                                                                                                             vw.professor_id = nln.professorid AND
                                                                                                             NLN.ANO = year(vw.inicio_vigencia))

where year(vw.inicio_vigencia) = 2020




