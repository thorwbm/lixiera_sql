-- 
--'MEDICINA 2020/12-1 (1-2020)'
				 --'MEDICINA 2019/12-2 (2-2019)'
				-- 'MEDICINA 2019/12-1 (1-2019)'
				-- 'MEDICINA 2018/6-2 (2-2018)',
				-- 'MEDICINA 2017/6-3 (2-2017)',
				-- 'ENFERMAGEM 2017/10-1',
				-- 'ENFERMAGEM 2016/10-1',
				-- 'PSICOLOGIA 2018/10-1',
				-- 'PSICOLOGIA 2017/10-1',
				--'PSICOLOGIA 2016/10-1'

DROP TABLE #temp_enturmacao
							   
declare @curriculo_id int = (select ID from curriculos_curriculo where nome = 'ENFERMAGEM 2017/10-1')

    --------------------------------------------------
	SELECT ent.CURRICULO_ALUNO_ID, ENT.ALUNO_ID, ent.ALUNO_NOME, ENT.DESTINO, ENT.disciplina_id, DIS.NOME AS DISCIPLINA_NOME, 
	       CAN.TURMA_ID, CAN.TURMA_NOME, 
	       DST.NOME AS TURMA_DESTINO, cur.nome as curso_nome, tds.id as turmadisciplina_id
		   INTO #temp_enturmacao
      FROM vw_pro_aluno_disciplina_enturmar ENT JOIN ACADEMICO_DISCIPLINA           DIS ON (ENT.disciplina_id = DIS.ID)
	                                            join academico_curso                cur on (cur.id = ent.curso_id)
	                                            JOIN VW_PRO_ALUNO_TURMA_CANDIDATA   can on (can.curriculo_aluno_id = ent.curriculo_aluno_id AND
												                                            CAN.ANO = 2020 AND CAN.SEMESTRE = 1)
										   LEFT JOIN ACADEMICO_TURMA                DST ON (DST.turma_origem_rematricula_id = CAN.TURMA_ID)
										   left join academico_turmadisciplina      tds on (tds.turma_id = dst.id and 
												                                            tds.disciplina_id = dis.id)
										   LEFT JOIN VW_PRO_ALUNO_MAIS_DE_UM_ATIVO  MUA ON (MUA.ALUNO_ID = ENT.ALUNO_ID)
										   left join academico_turmadisciplinaaluno XXX ON (XXX.ALUNO_ID = ENT.ALUNO_ID AND 
										                                                    XXX.curriculo_aluno_id = ENT.curriculo_aluno_id AND
																							XXX.turma_disciplina_id = TDS.ID )										   
											 left join TMP_BLACK_LIST_ENTURMACAO_2020 blk on (blk.aluno_id = ent.aluno_id)
		 where blk.aluno_id is null and

	      ENT.curriculo_id = @curriculo_id AND 
	      MUA.ALUNO_ID IS NULL and 
		  tds.id is not null  and 
		  CUR.NOME NOT IN ('CURSO DE EXTENSÃO EM ORATÓRIA','CURSO DE TUTORIA') AND 
		  XXX.ID IS NULL 
	ORDER BY CUR.NOME, ENT.DESTINO, ENT.ALUNO_NOME, DIS.NOME
	-- order by   tds.id, ENT.ALUNO_NOME,  DIS.NOME
	--------------------------------------------------

INSERT INTO academico_turmadisciplinaaluno (
       ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, 
	   exigencia_matricula_disciplina_id,TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, 
	   FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)

SELECT distinct ALUNO_ID = tem.ALUNO_ID, TURMA_DISCIPLINA_ID = tem.turmadisciplina_id, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, 
       ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, 
	   STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = NULL, TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = tem.curriculo_aluno_id
  FROM #temp_enturmacao tem LEFT JOIN academico_turmadisciplinaaluno XXX ON (XXX.aluno_id = tem.ALUNO_ID AND 
                                                                             XXX.turma_disciplina_id = tem.turmadisciplina_id AND
																			 XXX.curriculo_aluno_id  = tem.curriculo_aluno_id)
 WHERE XXX.id IS NULL AND 
       (select isnull(tdsx.maximo_vagas,0) - count(tdsx.id) 
			  from academico_turmadisciplina      tdsx 
								   left join academico_turmadisciplinaaluno tdax on (tdsx.id = tdax.turma_disciplina_id)
			  where tdsx.id = tem.turmadisciplina_id  			        
			 group by tdsx.id, isnull(tdsx.maximo_vagas,0)) > 0



--#########################################################################################################################
-- EXECUTAR PROCEDURE PAR DAR CARGA EM SUBTURMAS E TURMAS ESPECIAS

--    
--select * from curriculos_curriculo where nome = 'MEDICINA 2020/12-1 (1-2020)'

EXEC SP_PRO_CARGA_SUBTURMA_CURRICULO @curriculo_id


 --delete from academico_turmadisciplinaaluno where id in (
 --   select turma_disciplina_aluno_id from vw_curriculo_curso_turma_disciplina_aluno_grade
 --      where status_mat_dis_id = 14 and
 --	        disciplina_nome = 'fisiologia humana ii' and turma_nome like '%p%')

-- EXECUTAR PROCEDURE PARA DAR CARGA DAS TURMAS DE FISIOLOGIA HUMANA 
   EXEC SP_PRO_CARGA_FISIOLOGIA_HUMANA_SUB
-- EXECUTAR PROCEDURE PARA DAR CARGA DAS TURMAS DE FISIOLOGIA HUMANA 
   EXEC SP_PRO_CARGA_FISIOLOGIA_HUMANA_SUB_SUB

-- EXECUTAR PARA AS TURMAS ESPECIAIS 
   EXEC SP_PRO_RODAR_SUBTURMA_E_TURMAS_ESPECIAIS @curriculo_id


select * from TMP_BLACK_LIST_ENTURMACAO_2020
/*
--#################################################################################
   SELECT * FROM VW_PRO_CARGA_FISIOLOGIA_HUMANA

   --      TESTAR 


 select * from vw_curriculo_curso_turma_disciplina_aluno_grade
      where status_mat_dis_id = 14 and
	        CURRICULO_NOME = 'ENFERMAGEM 2017/10-1'  
	        AND aluno_nome = 'LARISSA LEMOS GONÇALVES DO AMARAL'
		    --  and turma_nome like '%08'
	      -- and  disciplina_nome LIKE 'ESTÁGIO SUPERVISIONADO%' 
		order by aluno_nome, disciplina_nome, turma_nome, SUBSTRING(turma_nome,1,1) 


--        DELETAR

   select * delete from academico_turmadisciplinaaluno where id in (
   select turma_disciplina_aluno_id from vw_curriculo_curso_turma_disciplina_aluno_grade
      where status_mat_dis_id = 14  and 
	        curriculo_nome = 'ENFERMAGEM 2017/10-1' 
			--and aluno_nome = 'VIVIAN APARECIDA CAMPOS DA SILVA '
	        --AND disciplina_nome like 'ADMINISTRAÇÃO DOS SERVIÇOS DE ENFERMAGEM II'
			)



  SELECT * FROM VW_ACD_DISCIPLINA_CONCLUIDA WHERE curriculo_aluno_id = 36199 ORDER BY disciplina_nome



               exec SP_PRO_INSERT_DISCIPLINA_ESPECIAL_GENERICO 36746, 'Treinamento de Habilidade', null  




select * from tmp_blac



select * from VW_PRO_DISCIPLINA_NAO_CURSADA where curriculo_aluno_id = 35842

  select * from vw_curriculo_curso_turma_disciplina_aluno_grade
      where status_mat_dis_id = 14 and 
	        curriculo_nome = 'PSICOLOGIA 2016/10-1'-- and aluno_nome = 'KATIA CRISTIANE TIBURCIO'
	        AND disciplina_nome like 'ESTÁGIO%'
		order by aluno_nome, turma_nome, disciplina_nome
		
select * from VW_PRO_DISCIPLINA_NAO_CURSADA where curriculo_aluno_id = 35842 and grade_id = 6688
 and grade_nome = '3º período'


   select * --  delete 
   
   from academico_turmadisciplinaaluno where id in (

   select turma_disciplina_aluno_id from vw_curriculo_curso_turma_disciplina_aluno_grade
      where status_mat_dis_id = 14  
	  --     and  curriculo_nome = 'MEDICINA 2019/12-2 (2-2019)'
			
			)


			--exec SP_PRO_CARGA_SUBTURMAS_ALUNO 37596
			select * from academico_disciplina where nome = 'Estágio Supervisionado I'

			SELECT * FROM VW_ACD_TURMA_PAI_FILHA WHERE TURMA_PAI_NOME = 'M073S02D202T'

select * from vw_acd_curso_turma_disciplina_grade 
where grade_id = 6688 and disciplina_id = 4888



select * from curriculos_disciplinaconcluida where curriculo_aluno_id = 35842 and disciplina_id = 4888
select * from vw_curriculo_curso_turma_disciplina_aluno_grade where disciplina_id = 4888 and 
  aluno_id = 48062

  select * from vw_gradedisciplinaequivalente where disciplina_id = 4888 and nome_curriculo = 'ENFERMAGEM 2017/10-1'


  select * from ent
  */