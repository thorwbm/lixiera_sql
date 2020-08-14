  
CREATE or alter  view [dbo].[VW_MOODLE_CURSO_TURMA_DISCIPLINA] AS   
select distinct cur.id as curso_id, cur.nome as curso_nome,   
       tur.id as turma_id, tur.nome as turma_nome,  
       dis.id as disciplina_id, dis.nome as disciplina_nome,   
    gra.id as grade_id, gra.nome as grade_nome,   
    eta.id as etapa_ano_id, eta.ano as etapa_ano, eta.periodo as etapa_periodo,  
    convert(varchar(10),eta.periodo) + '/' + convert(varchar(10),eta.ano) as etapa_ano_periodo,  
    linha = cur.nome + ' - ' + TUR.nome + ' - ' + dis.nome + ' - ' + gra.nome + ' - ' +  
            convert(varchar(10),eta.periodo) + '/' + convert(varchar(10),eta.ano),  
    cast(tur.inicio_vigencia as date) AS inicio_vigencia,   
    json_value(tds.atributos, '$.moodle.id' ) as moodle_id,   
    json_value(tds.atributos, '$.moodle.course_id' ) as moodle_curse_id  
from academico_turmadisciplina tds  
                 join academico_turma          tur on (tur.id = tds.turma_id)  
                 join academico_disciplina     dis on (dis.id = tds.disciplina_id)  
                 join academico_categoriaturma cat on (cat.id = tur.categoria_id)  
                 join curriculos_grade         gra on (gra.id = tur.grade_id)  
                 join curriculos_curriculo     crc on (crc.id = gra.curriculo_id)  
                 join academico_curso          cur on (cur.id = crc.curso_id)   
                 -- join academico_etapaano    eta on (gra.etapa_id = eta.etapa_id) -- old 				
                 join academico_etapaano       eta on (eta.id = tur.etapa_ano_id) 
where cat.id = 1  and  -- categoria = teorica  
      cast(tur.inicio_vigencia as date) >= '2020-07-27'  