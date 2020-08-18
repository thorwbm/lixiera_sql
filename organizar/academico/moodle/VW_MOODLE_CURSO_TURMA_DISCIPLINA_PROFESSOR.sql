create or alter   view VW_MOODLE_CURSO_TURMA_DISCIPLINA_PROFESSOR AS     
select distinct     
       cur.id as curso_id, cur.nome as curso_nome,     
       tur.id as turma_id, tur.nome as turma_nome,     
    dis.id as disciplina_id, dis.nome as disciplina_nome,     
    gra.id as grade_id, gra.nome as grade_nome,     
    eta.id as etapa_ano_id, eta.ano as etapa_ano, eta.periodo as etapa_periodo,    
    convert(varchar(10),eta.periodo) + '/' + convert(varchar(10),eta.ano) as etapa_ano_periodo,    
    pro.id as professor_id, usu.nome_civil as professor_nome,usu.username as professor_username,    
    cast(tur.inicio_vigencia as date) AS INICIO_VIGENCIA,     
    json_value(usu.atributos, '$.moodle.id' ) as professor_moodle_id    
    
from academico_turmadisciplina tds    
                 join academico_turma                    tur on (tur.id = tds.turma_id)    
                 join academico_disciplina               dis on (dis.id = tds.disciplina_id)    
                 join academico_categoriaturma           cat on (cat.id = tur.categoria_id)    
                 join curriculos_grade                   gra on (gra.id = tur.grade_id)    
                 join curriculos_curriculo               crc on (crc.id = gra.curriculo_id)    
                 join academico_curso                    cur on (cur.id = crc.curso_id)    
                 join academico_turmadisciplinaprofessor trp on (tds.id = trp.turma_disciplina_id)    
                 join academico_professor                pro on (pro.id = trp.professor_id)     
                 join auth_user                          usu on (usu.id = pro.user_id)    
                -- join academico_etapaano                 eta on (gra.etapa_id = eta.etapa_id) -- old       
            left     join academico_etapaano                 eta on (eta.id = tur.etapa_ano_id)   
  
where cat.id = 1  and   
      tur.inicio_vigencia >= '2020-07-27'  