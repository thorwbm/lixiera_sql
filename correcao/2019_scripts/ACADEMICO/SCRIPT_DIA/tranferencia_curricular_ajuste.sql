-- commit 
-- rollback 

declare @aluno_id int , @antigo int, @novo int , @curriculoantigo int 

set @aluno_id = 42409
select distinct @antigo = min(CURRICULOALUNO_ID) from vw_aluno_curriculo_curso_turma_etapa_discplina where aluno_id = @aluno_id
select distinct @curriculoantigo = CURRICULO_ID from vw_aluno_curriculo_curso_turma_etapa_discplina where aluno_id = @aluno_id and  CURRICULOALUNO_ID = @antigo

select distinct @novo = max(CURRICULOALUNO_ID) from vw_aluno_curriculo_curso_turma_etapa_discplina where aluno_id = @aluno_id
begin tran;

with cte_curriculo_antigo as (
select   * from curriculos_disciplinaconcluida 
where curriculo_aluno_id in (@antigo)
) 
,
 cte_turmadisciplina_curriculo_antigo as (
select distinct tds.* from academico_turmadisciplina tds join academico_turma  tur on (tur.id = tds.turma_id)
                                            join curriculos_grade gra on (gra.id = tur.grade_id)
											join curriculos_curriculo crc on (crc.id = gra.curriculo_id)
											join academico_turmadisciplinaaluno tda on (tda.turma_disciplina_id = tds.id)
		where gra.curriculo_id = @curriculoantigo and tda.aluno_id = @aluno_id

) 

insert into curriculos_disciplinaconcluida (criado_em, atualizado_em, carga_horaria, nota, faltas, frequencia, titulacao_id, criado_por, disciplina_id, status_id, 
                                            curriculo_aluno_id, professor_id, etapa_ano_id, atualizado_por, atributos, exigencia_id, ativo_ate, disciplina_informada_id)
select  criado_em = getdate(), atualizado_em = getdate(), carga_horaria, nota, faltas, frequencia, titulacao_id, criado_por, disciplina_id, status_id, 
      curriculo_aluno_id = @novo, professor_id, etapa_ano_id, atualizado_por, 
	  atributos = '{"justificativa":"ajuste manual da transferencia de curriculo a pedido da CMMG"}', exigencia_id, ativo_ate, disciplina_informada_id

from cte_curriculo_antigo cur 
where disciplina_id not in (select distinct disciplina_id from cte_turmadisciplina_curriculo_antigo)
