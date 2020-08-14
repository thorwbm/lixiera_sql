  
CREATE or alter view [dbo].[VW_MOODLE_CURSO_TURMA_DISCIPLINA_ALUNO] as   
select    
       cur.id as curso_id, cur.nome as curso_nome,   
       tur.id as turma_id, tur.nome as turma_nome,   
    dis.id as disciplina_id, dis.nome as disciplina_nome,   
    gra.id as grade_id, gra.nome as grade_nome,   
    eta.id as etapa_ano_id, eta.ano as etapa_ano, eta.periodo as etapa_periodo,  
    convert(varchar(10),eta.periodo) + '/' + convert(varchar(10),eta.ano) as etapa_ano_periodo,  
    alu.id as aluno_id, alu.nome as aluno_nome, usu.username as aluno_username,   
    smd.id as status_matricula_disciplina_id, smd.nome as status_matricula_disciplina_nome,   
    csa.id as status_curriculo_aluno_id, csa.nome as status_curriculo_aluno_nome,  
    cast(tur.inicio_vigencia as date) AS INICIO_VIGENCIA,   
    json_value(usu.atributos, '$.moodle.id' ) as aluno_moodle_id  
from curriculos_aluno cra  
           join curriculos_curriculo                crc on (crc.id = cra.curriculo_id)  
           join academico_curso                     cur on (cur.id = crc.curso_id)  
           join academico_aluno                     alu on (alu.id = cra.aluno_id)  
           join academico_turmadisciplinaaluno      tda on (cra.id = tda.curriculo_aluno_id and   
                                                            alu.id = tda.aluno_id)  
           join academico_turmadisciplina           tdS on (tdS.id = tda.turma_disciplina_id)  
           join academico_turma                     tur on (tur.id = tds.turma_id)  
           join curriculos_grade                    gra on (gra.id = tur.grade_id)  
           join academico_disciplina                dis on (dis.id = tds.disciplina_id)  
           join academico_categoriaturma            cat on (cat.id = tur.categoria_id)  
           join auth_user                           usu on (usu.id = alu.user_id)   
        -- join academico_etapaano                  eta on (gra.etapa_id = eta.etapa_id) -- old 				
           join academico_etapaano                  eta on (eta.id = tur.etapa_ano_id)   
           join academico_statusmatriculadisciplina smd on (smd.id = tda.status_matricula_disciplina_id)  
           join curriculos_statusaluno              csa on (csa.id = cra.status_id)  
where cat.id = 1  and  -- categoria = teorica  
      cast(tur.inicio_vigencia as date) >= '2020-07-27'  