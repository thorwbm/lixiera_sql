CREATE VIEW vw_pro_aluno_disciplina_enturmar AS 
WITH	cte_turma_disciplina_aluno_cursando AS (
			SELECT 
			       tda.curriculo_aluno_id, tds.disciplina_id, tds.turma_id, gde.disciplina_equivalente_id 
			  FROM 
			       academico_turmadisciplinaaluno tda JOIN academico_turmadisciplina     tds ON (tds.id = tda.turma_disciplina_id)
				                                      JOIN curriculos_aluno              cra ON (cra.id = tda.curriculo_aluno_id)
				                                 LEFT JOIN vw_gradedisciplinaequivalente gde ON (gde.curriculo_id = cra.curriculo_id AND
												                                                 gde.disciplina_equivalente_id = tds.disciplina_id)
			 WHERE 
			       tda.status_matricula_disciplina_id = 1
)

			SELECT distinct 
				   alu.ALUNO_ID, alu.ALUNO_NOME, alu.CURRICULO_ID,	alu.CURRICULO_NOME,	 alu.DESTINO, alu.curriculo_aluno_id,
				   ncs.disciplina_id, ncs.curso_id, ncs.grade_id, ncs.grade_nome
			 FROM 
				  vw_pro_relacao_alunos alu JOIN vw_pro_disciplina_nao_cursada       ncs ON (alu.curriculo_aluno_id = ncs.curriculo_aluno_id AND
																							 alu.destino = ncs.grade_nome)
									   LEFT JOIN cte_turma_disciplina_aluno_cursando tac ON (tac.curriculo_aluno_id = alu.curriculo_aluno_id AND
																							 tac.disciplina_id = ncs.disciplina_id)	
									   LEFT JOIN cte_turma_disciplina_aluno_cursando equ ON (equ.curriculo_aluno_id = alu.curriculo_aluno_id AND
																							 equ.disciplina_equivalente_id = ncs.disciplina_id)							
			 WHERE
				   tac.curriculo_aluno_id IS NULL AND
				   equ.curriculo_aluno_id IS NULL AND alu.curriculo_aluno_id = 36682



SELECT * FROM VW_PRO_ALUNO_TURMA_CANDIDATA WHERE curriculo_aluno_id = 36682 AND grade_nome = '3ª série'


begin tran 
DECLARE @CURRICULO_ALUNO_ID INT, @ALUNO_ID INT, @ALUNO_NOME VARCHAR(200), @SERIE VARCHAR(200), 
        @DISCIPLINA_ID INT, @DISCIPLINA_NOME VARCHAR(200),
		@TURMA_ORIGEM VARCHAR(200), @controle varchar(200), 
		@TURMA_DESTINO VARCHAR(200),
		@curso_nome varchar(200), @TURMADISCIPLINA_ID INT,
		@cont int

set @controle = ''
set @cont = 1
-- drop table #temp_enturmacao

declare CUR_ENT cursor for 
    --------------------------------------------------
	SELECT ent.CURRICULO_ALUNO_ID, ENT.ALUNO_ID, ent.ALUNO_NOME, ENT.DESTINO, ENT.disciplina_id, DIS.NOME AS DISCIPLINA_NOME, CAN.TURMA_NOME , 
	       DST.NOME AS TURMA_DESTINO, cur.nome as curso_nome, tds.id as turmadisciplina_id

		  -- into #temp_enturmacao
      FROM vw_pro_aluno_disciplina_enturmar ENT JOIN ACADEMICO_DISCIPLINA         DIS ON (ENT.disciplina_id = DIS.ID)
	                                            join academico_curso      cur on (cur.id = ent.curso_id)
	                                            JOIN VW_PRO_ALUNO_TURMA_CANDIDATA can on (can.curriculo_aluno_id = ent.curriculo_aluno_id AND
												                                          CAN.ANO = 2020 AND CAN.SEMESTRE = 1)
										   LEFT JOIN ACADEMICO_TURMA              DST ON (DST.turma_origem_rematricula_id = CAN.TURMA_ID)
										   left join academico_turmadisciplina    tds on (tds.turma_id = dst.id and 
												                                          tds.disciplina_id = dis.id)
										   LEFT JOIN VW_PRO_ALUNO_MAIS_DE_UM_ATIVO MUA ON (MUA.ALUNO_ID = ENT.ALUNO_ID)
										   left join academico_turmadisciplinaaluno XXX ON (XXX.ALUNO_ID = ENT.ALUNO_ID AND 
										                                                    XXX.curriculo_aluno_id = ENT.curriculo_aluno_id AND
																							XXX.turma_disciplina_id = TDS.ID )

	WHERE ENT.curriculo_nome = 'MEDICINA 2020/12-1 (1-2020)' AND 
	      MUA.ALUNO_ID IS NULL and 
		  tds.id is not null AND
		  XXX.ID IS NULL
	ORDER BY CUR.NOME, ENT.DESTINO, ENT.ALUNO_NOME, DIS.NOME
	-- order by   tds.id, ENT.ALUNO_NOME,  DIS.NOME
	--------------------------------------------------
	open CUR_ENT 
		fetch next from CUR_ENT into @CURRICULO_ALUNO_ID, @ALUNO_ID, @ALUNO_NOME, @SERIE,@DISCIPLINA_ID, @DISCIPLINA_NOME, @TURMA_ORIGEM, @TURMA_DESTINO, @curso_nome,
		                             @TURMADISCIPLINA_ID
		while @@FETCH_STATUS = 0
			BEGIN

			if (@controle <> @ALUNO_NOME) 
				begin
				    PRINT ('')
					PRINT ('ENTURMAR O ALUNO *** ' + @ALUNO_NOME + ' *** - NA ' + @SERIE) + ' DO CURSO  [ ' + UPPER(@CURSO_NOME) + ' ]'
					PRINT ('******************************************************************************************************')
				    
					set @controle = @aluno_nome
					set @cont = 1
				end

				PRINT (convert(varchar(10), @cont) + '- PARA A TURMA ORIGEM - ' + @TURMA_ORIGEM + ' --- CADASTRAR A DISCIPLINA  == ' + @DISCIPLINA_NOME) + ' - NA TURMA DE DESTINO - ' + ISNULL(@TURMA_DESTINO,'*******') 
				
INSERT INTO academico_turmadisciplinaaluno (ALUNO_ID, TURMA_DISCIPLINA_ID, CRIADO_EM, CRIADO_POR, ATUALIZADO_EM, ATUALIZADO_POR, exigencia_matricula_disciplina_id,
                                            TIPO_MATRICULA_ID, STATUS_MATRICULA_DISCIPLINA_ID, FECHADO_EM, TENTAR_FECHAMENTO, CURRICULO_ALUNO_ID)
SELECT ALUNO_ID = @ALUNO_ID, TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID, CRIADO_EM = GETDATE(), CRIADO_POR = 11717, ATUALIZADO_EM = GETDATE(), ATUALIZADO_POR = 11717, 
       EXIGENCIA_MATRICULA_DISCIPLINA_ID = 2, TIPO_MATRICULA_ID = 1, STATUS_MATRICULA_DISCIPLINA_ID = 14, FECHADO_EM = '2020-12-31', TENTAR_FECHAMENTO = 0, CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID
	   WHERE NOT EXISTS (SELECT 1 FROM academico_turmadisciplinaaluno 
	                      WHERE ALUNO_ID = @ALUNO_ID AND 
						        TURMA_DISCIPLINA_ID = @TURMADISCIPLINA_ID AND 
								CURRICULO_ALUNO_ID = @CURRICULO_ALUNO_ID)

				set @cont = @cont + 1

			fetch next from CUR_ENT into @CURRICULO_ALUNO_ID, @ALUNO_ID, @ALUNO_NOME, @SERIE,@DISCIPLINA_ID, @DISCIPLINA_NOME, @TURMA_ORIGEM, @TURMA_DESTINO, @curso_nome,
		                             @TURMADISCIPLINA_ID
			END
	close CUR_ENT 
deallocate CUR_ENT 

-- rollback 


SELECT *  from TMP_TESTE_INSERCAO_ENTURMACAO where turma_disciplina_id = 19285









	  SELECT TOP 10 * FROM vw_curriculos_grade_disciplina_ETAPA_ANO 
	  SELECT TOP 10 * FROM curriculos_disciplinaconcluida  CDC WHERE CDC.etapa_ano_id = 2215



	  SELECT DISTINCT CON.* FROM curriculos_disciplinaconcluida CON JOIN curriculos_statusdisciplina              STA ON (STA.id = CON.STATUS_ID)
	                                                                JOIN vw_curriculos_grade_disciplina_ETAPA_ANO CGD ON (CON.disciplina_id = CGD.disciplina_id AND
																	                                                      CON.etapa_ano_id  = CGD.ETAPA_ANO_ID)
	  WHERE curriculo_aluno_id = 34960

	  SELECT * FROM ACADEMICO_ETAPAANO WHERE ID = 2215
	  SELECT * FROM ACADEMICO_ETAPA WHERE ID = 47

	  SELECT * FROM vw_curriculos_grade_disciplina vcgd
	  WHERE CURRICULO_ID = 2308 AND GRADE_NOME = '10º período'


	  select aluno_ra, aluno_nome, curso_nome, curriculo_nome, etapa_nome, disciplina_nome, nota, frequencia, carga_horaria, disciplina_status_sigla
from vw_rel_historico_comparativo

 where curriculo_aluno_status_id = 13 and
    CURRICULO_NOME = 'PSICOLOGIA 2016/10-1' AND 
  -- ALUNO_NOME ='ÁLVARO ALOÍSIO DE SOUZA' AND 
   ETAPA_NOME = '10º período'

order by curso_nome, aluno_nome, etapa_numero, disciplina_nome



SELECT TDA.* FROM ACADEMICO_ALUNO                ALU
										 JOIN academico_turmadisciplinaaluno TDA ON (TDA.ALUNO_ID = ALU.ID)
										 JOIN academico_turmadisciplina      TDS ON (TDS.ID = TDA.turma_disciplina_id)
										 JOIN ACADEMICO_TURMA                TUR ON (TUR.ID = TDS.TURMA_ID AND TUR.TURMA_PAI_ID IS NULL)
WHERE   ALU.NOME = 'ÁLVARO ALOÍSIO DE SOUZA'



--##############################################################################################################
-------------------------VALIDACOES RAPIDAS ----------------------------------------------

-- QUANTIDADE DE ALUNOS POR TURMA
select  turma_destino, count(distinct aluno_id) as qtd_aluno
from #temp_enturmacao
group by turma_destino

-- QUANTIDADES DE DISCIPLINA DE CADA ALUNO EM UMA TURMA
select aluno_id,  turma_destino,aluno_nome, count(distinct disciplina_id) as qtd_disciplina
from #temp_enturmacao
group by aluno_id,  turma_destino,aluno_nome

-- QUANTIDADE DE TURMADISCIPLINA POR ALUNO DE UMA TURMA
select aluno_id,  turma_destino,aluno_nome, count(distinct turmadisciplina_id) as qtd_disciplina
from #temp_enturmacao
group by aluno_id,  turma_destino,aluno_nome

-- CURRICULO CURSO TURMA GRADE ETAPA
select * from vw_acd_curso_curriculo_turma_grade_etapa 
where curriculo_nome = 'MEDICINA 2020/12-1 (1-2020)' and grade_nome = '2º período' and etapa_ano = 2020 and etapa_periodo = 2
and turma_nome = 'M073S02B202T'

-- DISCIPLINAS ASSOCIADAS A TURMA
select * from vw_acd_curso_turma_disciplina_grade where  turma_nome = 'M073S02B202T' and grade_nome = '2º período' and etapa_ano = 2020 and etapa_periodo = 2




SELECT DISTINCT curriculo_nome, turma_nome as turma_origem, TURMA_DESTINO, destino as periodo--, DISCIPLINA_NOME, disciplina_id
FROM #temp_enturmacao
WHERE 
      turma_destino is  null
ORDER BY 1,2


select * from academico_turma where nome = 'M069A03C201T'
select * from academico_turmadisciplina where nome = 'M069A03C201T'




SELECT DISTINCT   turma_nome as turma_origem, TURMA_DESTINO,  destino as periodo_destino, DISCIPLINA_NOME, disciplina_id
FROM #temp_enturmacao
WHERE 
     --  turma_destino is  null and 
	 turmadisciplina_id is null  and 
	-- turma_nome = 'M070A03D202T' --and
	--  disciplina_nome = 'FARMACOLOGIA BÁSICA E DOS SISTEMAS'
ORDER BY 1,2


--M071S04C202T


select * from vw_turma_disciplina_grade where turma_nome = 'M071S04C202T' 7072


select * from academico_turma where nome = 'M071S04C202T'

select * from academico_turma where id = 4619

select * from academico_turmadisciplina where turma_id =5890    and disciplina_id = 7072


select * from vw_pro_aluno_disciplina_enturmar where ALUNO_ID = 53177



select * from vw_curriculo_grade_disciplina 
where curriculo_id = 2350 and grade_id = 6894



select tur.nome, dis.* from academico_turmadisciplina tds join academico_turma tur on (tur.id = tds.turma_id)
                                            join academico_disciplina dis on (dis.id = tds.disciplina_id)
where tur.nome ='M070A03D202T' 