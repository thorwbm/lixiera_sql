/*ALTER TABLE ACADEMICO_TURMADISCIPLINA DROP COLUMN turma_universus
ALTER TABLE ACADEMICO_TURMADISCIPLINA DROP COLUMN professor_universus_id
ALTER TABLE ACADEMICO_TURMADISCIPLINA DROP COLUMN disciplina_universus_id
ALTER TABLE ACADEMICO_TURMADISCIPLINA DROP COLUMN escola_universus_id
ALTER TABLE ACADEMICO_TURMADISCIPLINA DROP COLUMN ano_universus_id
ALTER TABLE ACADEMICO_TURMADISCIPLINA DROP COLUMN regime_universus_id
ALTER TABLE ACADEMICO_TURMADISCIPLINA DROP COLUMN periodo_universus_id*/
-- COMMIT 
-- ROLLBACK

declare @ID_AUX int 
declare @turmadisciplina_id int 
set @turmadisciplina_id = 11382  --14074


BEGIN TRAN 
 SELECT * FROM ACADEMICO_TURMADISCIPLINAALUNO WHERE turma_disciplina_id = 11382
select * from academico_complementacaocargahoraria where turma_disciplina_id = 11382 
-- ******* GERAR LOG  academico_turmadisciplinaprofessor  DELECAO ******
		declare CUR_TDP_DEL cursor for 
			select id from academico_turmadisciplinaprofessor where turma_disciplina_id = @turmadisciplina_id  

			open CUR_TDP_DEL 
				fetch next from CUR_TDP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						 EXEC SP_GERAR_LOG 'academico_turmadisciplinaprofessor', @ID_AUX, '-', 2136, NULL, NULL, NULL						
					fetch next from CUR_TDP_DEL into @ID_AUX
					END
			close CUR_TDP_DEL 
		deallocate CUR_TDP_DEL
-- ******* GERAR LOG DELECAO FIM ******
delete from academico_turmadisciplinaprofessor where turma_disciplina_id = @turmadisciplina_id

-- ******* GERAR LOG  frequencias_protocolofrequenciaforaprazo_aula  DELECAO ******
		declare CUR_TDP_DEL cursor for 
			select id from frequencias_protocolofrequenciaforaprazo_aula
            where aula_id in (select id from academico_aula where turma_disciplina_id = @turmadisciplina_id)   

			open CUR_TDP_DEL 
				fetch next from CUR_TDP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						 EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', @ID_AUX, '-', 2136, NULL, NULL, NULL						
					fetch next from CUR_TDP_DEL into @ID_AUX
					END
			close CUR_TDP_DEL 
		deallocate CUR_TDP_DEL
-- ******* GERAR LOG DELECAO FIM ******
delete from frequencias_protocolofrequenciaforaprazo_aula
 where aula_id in (select id from academico_aula where turma_disciplina_id = @turmadisciplina_id)   

-- ******* GERAR LOG  academico_frequenciadiaria  DELECAO ******
		declare CUR_TDP_DEL cursor for 
			select id from academico_frequenciadiaria
            where aula_id in (select id from academico_aula where turma_disciplina_id = @turmadisciplina_id)   

			open CUR_TDP_DEL 
				fetch next from CUR_TDP_DEL into @ID_AUX
				while @@FETCH_STATUS = 0
					BEGIN
						 EXEC SP_GERAR_LOG 'academico_frequenciadiaria', @ID_AUX, '-', 2136, NULL, NULL, NULL
					fetch next from CUR_TDP_DEL into @ID_AUX
					END
			close CUR_TDP_DEL 
		deallocate CUR_TDP_DEL
-- ******* GERAR LOG DELECAO FIM ******
--select * from academico_turmadisciplinaaluno where turma_disciplina_id = @turmadisciplina_id
delete from academico_frequenciadiaria
  where aula_id in (select id from academico_aula where turma_disciplina_id = @turmadisciplina_id)

EXEC SP_GERAR_LOG 'academico_aula',220696, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220697, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220698, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220699, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220700, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220701, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220702, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220703, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220704, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220705, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220706, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220707, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220708, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220709, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220710, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220711, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220712, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220713, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220714, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220715, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220716, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220717, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220718, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220719, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220720, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220721, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220722, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220723, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220724, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220725, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220726, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220727, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220728, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220729, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220730, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_aula',220731, '-', 2136, NULL, NULL, NULL

delete from academico_aula where turma_disciplina_id = @turmadisciplina_id

EXEC SP_GERAR_LOG 'aulas_agendamento', 10042, '-', 2136, NULL, NULL, NULL
delete from aulas_agendamento where turma_disciplina_id = @turmadisciplina_id


EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 2341, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 2342, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 2343, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 2344, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 7043, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 7044, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 7045, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 7046, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 7075, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 7076, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 7077, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo_aula', 7078, '-', 2136, NULL, NULL, NULL
delete from frequencias_protocolofrequenciaforaprazo_aula
where aula_id in (select id from academico_aula where turma_disciplina_id = @turmadisciplina_id)


EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo', 694, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo', 2160, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'frequencias_protocolofrequenciaforaprazo', 2175, '-', 2136, NULL, NULL, NULL
delete from frequencias_protocolofrequenciaforaprazo where turma_disciplina_id = @turmadisciplina_id

EXEC SP_GERAR_LOG 'academico_grupoaula', 72582, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_grupoaula', 72583, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_grupoaula', 72584, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_grupoaula', 72585, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_grupoaula', 72586, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_grupoaula', 72587, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_grupoaula', 72588, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_grupoaula', 72589, '-', 2136, NULL, NULL, NULL
EXEC SP_GERAR_LOG 'academico_grupoaula', 72590, '-', 2136, NULL, NULL, NULL
--select * 
delete from academico_grupoaula
where turma_disciplina_id = @turmadisciplina_id

EXEC SP_GERAR_LOG 'ACADEMICO_TURMADISCIPLINA', @turmadisciplina_id, '-', 2136, NULL, NULL, NULL
--  SELECT * 
 DELETE 
FROM ACADEMICO_TURMADISCIPLINA 
WHERE ID = @turmadisciplina_id



 SELECT * FROM ACADEMICO_TURMADISCIPLINAALUNO WHERE turma_disciplina_id = 11382