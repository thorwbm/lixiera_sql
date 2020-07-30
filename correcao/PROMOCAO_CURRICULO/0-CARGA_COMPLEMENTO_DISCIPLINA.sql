/*

--'MEDICINA 2018/6-1 (1-2018)',
--'MEDICINA 2017/6-4 (1-2017)',
--'ENFERMAGEM 2020/5-1 (1-2020)',
-- 'ENFERMAGEM 2019/5-1 (1-2019)',
--'FISIOTERAPIA 2020/5-1 (1-2020)',
--'FISIOTERAPIA 2019/5-1 (1-2019)',
---'FISIOTERAPIA 2017/5-1D',
--'PSICOLOGIA 2020/5-1 (1-2020)',
'PSICOLOGIA 2019/5-1 (1-2019)'
*/

declare @curriculo_ori_id int = (select ID from curriculos_curriculo where nome = 'PSICOLOGIA 2019/5-1 (1-2019)')

drop table #temp_importacao 

select distinct cap.aluno_id, cap.curriculo_aluno_id, dnc.disciplina_id, tur.id as turma_destino_id, cap.aluno_nome, cap.curriculo_id, 
          tds.id as turma_disciplina_id--, 
		  --cap.curriculo_nome, tur.nome as turma_nome, dis.nome as disciplina_nome
		into #temp_importacao
		  from  VW_PRO_DISCIPLINA_NAO_CURSADA dnc join VW_ACD_CURRICULO_ALUNO_PESSOA  cap on (cap.curriculo_aluno_id = dnc.curriculo_aluno_id and 
																							  dnc.grade_id = cap.grade_id)
												  join VW_PRO_ALUNO_TURMA_CANDIDATA   can on (can.CURRICULO_ALUNO_ID = dnc.curriculo_aluno_id and 
																							  can.ANO = 2020 and can.SEMESTRE = 1)  
												  join academico_turma                tur on (tur.nome = STUFF(can.TURMA_NOME,11,1,'2' ))
											 left JOIN academico_turmadisciplina      tds on (tds.disciplina_id = dnc.disciplina_id and 
												                                              tds.turma_id = tur.id)
											 left join TMP_BLACK_LIST_ENTURMACAO_2020 blk on (blk.aluno_id = cap.aluno_id)
										     --left join academico_disciplina       dis on (dis.id = dnc.disciplina_id) 
		 where blk.aluno_id is null and
		       cap.curriculo_id = @curriculo_ori_id and -- cap.curriculo_nome in ('FISIOTERAPIA 2017/5-1D') 
			   cap.curriculo_aluno_status_id = 13   
         order by  dnc.disciplina_id,cap.curriculo_id, cap.aluno_nome


declare @aluno_id int, @curriculo_aluno_id int, @disciplina_id int, 
        @TURMA_DESTINO_ID int, @aluno_nome varchar(200), @curriculo_id int, 
		@TURMA_DISCIPLINA_ID INT, @VAGA_DISPONIVEL INT

declare CUR_CARGA cursor for 
	------------------------------------------------------------------------------
		select distinct cap.aluno_id, cap.curriculo_aluno_id, dnc.disciplina_id, tur.id as turma_destino_id, cap.aluno_nome, cap.curriculo_id, 
          tds.id as turma_disciplina_id 

		  from  VW_PRO_DISCIPLINA_NAO_CURSADA dnc join VW_ACD_CURRICULO_ALUNO_PESSOA  cap on (cap.curriculo_aluno_id = dnc.curriculo_aluno_id and 
																							  dnc.grade_id = cap.grade_id)
												  join VW_PRO_ALUNO_TURMA_CANDIDATA   can on (can.CURRICULO_ALUNO_ID = dnc.curriculo_aluno_id and 
																							  can.ANO = 2020 and can.SEMESTRE = 1)  
												  join academico_turma                tur on (tur.nome = STUFF(can.TURMA_NOME,11,1,'2' ))
												  JOIN academico_turmadisciplina      tds on (tds.disciplina_id = dnc.disciplina_id and 
												                                              tds.turma_id = tur.id)
											 left join TMP_BLACK_LIST_ENTURMACAO_2020 blk on (blk.aluno_id = cap.aluno_id)
		 where blk.aluno_id is null and
		       cap.curriculo_id = @curriculo_ori_id and -- cap.curriculo_nome in ('FISIOTERAPIA 2017/5-1D') 
		       cap.curriculo_aluno_status_id = 13   
         order by  dnc.disciplina_id,cap.curriculo_id, cap.aluno_nome

	-----------------------------------------------------------------------------
	open CUR_CARGA 
		fetch next from CUR_CARGA into @aluno_id, @curriculo_aluno_id, @disciplina_id, @TURMA_DESTINO_ID, @aluno_nome, @curriculo_id, @turma_disciplina_id
		while @@FETCH_STATUS = 0
			BEGIN
			    SELECT @VAGA_DISPONIVEL = VAG.VAGA_DISPONIVEL, @TURMA_DISCIPLINA_ID = VAG.TURMADISCIPLINA_ID 
				      FROM VW_PRO_TURMA_DISCIPLINA_QUANTIDADE_DISPONIVEL_VAGA VAG
					 WHERE turmadisciplina_id = @turma_disciplina_id
					 
				IF ( @VAGA_DISPONIVEL > 0)
					BEGIN
						INSERT INTO academico_turmadisciplinaaluno (
							   ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
							   exigencia_matricula_disciplina_id,TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, 
							   FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)
						
						SELECT distinct ALUNO_ID = tem.ALUNO_ID, TURMA_DISCIPLINA_ID = tem.TURMA_DISCIPLINA_ID, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, 
							   ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, 
							   STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = tem.curriculo_aluno_id
					      from #temp_importacao tem left join  vw_curriculo_curso_turma_disciplina_aluno_grade XXX on (
						                                                      XXX.curriculo_id  = tem.curriculo_id  AND 
										                                      XXX.disciplina_id = tem.DISCIPLINA_ID AND
												                              XXX.tda_curriculo_aluno_id  = tem.curriculo_aluno_id)	
						WHERE XXX.aluno_id is null and
						      tem.TURMA_DISCIPLINA_ID = @TURMA_DISCIPLINA_ID and
							  tem.curriculo_aluno_id = @curriculo_aluno_id
						

						delete from #temp_importacao 
						where ALUNO_ID = @ALUNO_ID AND 
					          disciplina_id = @DISCIPLINA_ID AND 
						      CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID

					END
				ELSE
					BEGIN
						PRINT CONVERT(VARCHAR(20), @ALUNO_ID) + ' ALUNO - ' + CONVERT(VARCHAR(20), @TURMA_DISCIPLINA_ID) + ' TDS   - NAO FOI POSSIVEL MATRICULAR POR FALTA DE VAGAS'
					END


			fetch next from CUR_CARGA into  @aluno_id, @curriculo_aluno_id, @disciplina_id, @TURMA_DESTINO_ID, @aluno_nome, @curriculo_id,@turma_disciplina_id
			END
	close CUR_CARGA 
deallocate CUR_CARGA 
	   

EXEC SP_PRO_CARGA_SUBTURMA_CURRICULO @curriculo_ori_id 

--	   select * from curriculos_curriculo where nome = 'PSICOLOGIA 2019/5-1 (1-2019)'

-- EXECUTAR PARA AS TURMAS ESPECIAIS 
--   EXEC SP_PRO_RODAR_SUBTURMA_E_TURMAS_ESPECIAIS_COM 2354




/* **************************************************************************
--         TESTAR 

SELECT *  FROM vw_curriculo_curso_turma_disciplina_aluno_grade
WHERE status_mat_dis_id = 14 AND 
      curriculo_nome = 'MEDICINA 2018/6-1 (1-2018)' 	  
      -- AND grade_id = 6778 
	  -- and disciplina_nome like 'TREINAMENTO DE HABILIDADES%'
      and aluno_nome = 'ALESSANDRA DE FREITAS MARTINS VIEIRA' 
order by disciplina_nome


--#############################################################################
--         APAGAR 

SELECT * DELETE 
FROM academico_turmadisciplinaaluno 
WHERE id IN (SELECT TURMA_DISCIPLINA_ALUNO_ID  
               FROM vw_curriculo_curso_turma_disciplina_aluno_grade
              WHERE status_mat_dis_id = 14 and 
                    curriculo_nome = 'FISIOTERAPIA 2017/5-1D'
					--AND aluno_nome = 'TABATA ISLA ANDRADE' 
			)


*/
