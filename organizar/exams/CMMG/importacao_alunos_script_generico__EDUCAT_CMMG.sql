-- USE AVALIACAO_EDUCAT

-- ### DEVERA TER SIDO EXECUTADO O SCRIPT PARA IMPORATACAO DE BASE ###

/* ############ LISTA DE PARAMENTROS PARA IMPORTACAO ################
        select distinct 
               avaliacao_id, curso_id, periodo_id, data_aplicacao, 
               instituicao_id, id_disciplina, qtd_participante
     -- SELECT *
      from 
               VW_CMMG_PARAMENTRO_IMPORTACAO
   ################################################################## */
--   select * from TbAvaliacaoAplicacao where id_avaliacao = 368

-- 'Avaliação APIC - 1º período de Enfermagem - E015A01A201T - Trabalho em equipe' 363
-- Avaliação APIC - 3º período de Enfermagem - E014A02A201T - Metodologia do Trabalho e da Pesquisa Científica 362
-- Avaliação APIC - 7º período de Enfermagem - E013S07A201T - Assistência de Enfermagem à Saúde do idoso       360

   --SELECT * FROM VW_CMMG_AVALIACAO
   --select * from TBCURSO WHERE id_curso = 1
   --SELECT * FROM CMMG_APPLICATION_APPLICATION WHERE STARTED_at is not null 
   --SELECT * FROM TbDisciplina WHERE ds_disciplina LIKE '%Avaliação Parcial Integradora de Conteúdos%'
   --select * from tbperiodo = '1 '

    declare @AVALIACAO_EXT_ID INT = 13
    declare @ID_CURSO         int = 1
    declare @ID_PERIODO       int = 23
    declare @DATA_APLICACAO   datetime = '2020-06-16 14:00:00.000'
    declare @ID_INSTITUICAO   int = 7 
    declare @ID_DISCIPLINA    int = 49
    declare @NR_RESPONDENTES  int = 124 

declare @inicio datetime = getdate()
declare @FINAL datetime 
declare @descricao varchar(max)
declare @error varchar(max)

select @descricao = 'CARGA AVALAICAO - [' + ds_avaliacao + ']' from VW_cmmg_AVALIACAO where exa_id = @AVALIACAO_EXT_ID 
BEGIN TRY
BEGIN TRAN 

--  ######### INSERT USUARIO  ######### 
 INSERT INTO TbPessoaFisica (nome, external_id)
SELECT DISTINCT  nome = USU.name, external_id = USU.ID
  FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO USU ON (APP.user_id = USU.id)
                                  LEFT JOIN TbPessoaFisica XXX ON (XXX.nome = USU.NAME and 
								                                   xxx.external_id = usu.id)
  WHERE XXX.id_pessoa_fisica IS NULL 
  ORDER BY usu.name 
--------------------------------------------------------------------------------------------
INSERT INTO TbUsuario (PASSWORD, EMAIL, IS_ENABLED, id_pessoa_fisica)
SELECT DISTINCT 
       PASSWORD = '123456',
	  -- EMAIL = isnull(usu.email, 'educat_ex' + CONVERT(VARCHAR(20),  ROW_NUMBER() OVER(ORDER BY USU.name ))  + '@educat.com.br'),
       EMAIL =  'educat_ex' + CONVERT(VARCHAR(20), TBF.EXTERNAL_ID  )  + '@educat.com.br',
	   IS_ENABLED = 1, TBF.id_pessoa_fisica
  FROM  TbPessoaFisica TBF  JOIN CMMG_USUARIO USU ON (USU.ID = TBF.EXTERNAL_ID)   
                       LEFT JOIN TbUsuario XXX ON (XXX.id_pessoa_fisica = TBF.id_pessoa_fisica)
   WHERE XXX.ID IS NULL
--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOAPLICACAO  #########

INSERT INTO TbAvaliacaoAplicacao (id_avaliacao, ID_CURSO, ID_PERIODO, ID_DISCIPLINA, ID_STATUS, DT_APLICACAO,
                                  DURACAO, BL_HAS_ANALISE_TRI, ID_INSTITUICAO, NR_RESPONDENTES, 
								  ds_aplicacao)
 
 SELECT DISTINCT  
         AVA.id_avaliacao, ID_CURSO = @ID_CURSO, ID_PERIODO = @ID_PERIODO , 
         ID_DISCIPLINA = @ID_DISCIPLINA, ID_STATUS = 3, DATA_APLICACAO = @DATA_APLICACAO,
		 DURACAO = 0, BL_HAS_ANALISE_TRI = 1, ID_INSTITUICAO = @ID_INSTITUICAO, 
		 NR_RESPONDENTES = @NR_RESPONDENTES, DS_APLICACAO = UPPER(AVA.DS_AVALIACAO)

   FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO         USU ON (APP.user_id = USU.id)
                                         JOIN VW_CMMG_AVALIACAO    AVA ON (AVA.exa_id = APP.exam_id)
									     JOIN TbPessoaFisica       TBF ON (TBF.nome = USU.name and 
										                                   tbf.external_id = usu.id)
									     JOIN TbUsuario            TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
								    left join TbAvaliacaoAplicacao xxx on (xxx.id_avaliacao = AVA.id_avaliacao and
								                                           xxx.id_curso       = @ID_CURSO and
																		   xxx.id_periodo     = @ID_PERIODO and
																		   xxx.id_disciplina  = @ID_DISCIPLINA and
																		   xxx.id_instituicao = @ID_INSTITUICAO )
   WHERE AVA.exa_id = @AVALIACAO_EXT_ID and 
         xxx.id_avaliacao_aplicacao is null 

--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOREALIZACAO  #########
 INSERT INTO TbAvaliacaoRealizacao (dt_criada, dt_concluida, id_avaliacao_aplicacao, id_usuario, bl_presente, bl_aberta)

	SELECT DISTINCT --DT_CRIADA = @DATA_APLICACAO,DT_CONCLUIDA = @DATA_APLICACAO, 
                    TBA.id_avaliacao_aplicacao, ID_USUARIO = TBU.id , BL_PRESENTE = 1, BL_ABERTA = 0
	FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO         USU ON (APP.user_id = USU.id)
									     JOIN TbPessoaFisica        TBF ON (TBF.nome = USU.name and
										                                    tbf.external_id = usu.id)
                                         JOIN VW_CMMG_AVALIACAO     AVA ON (AVA.exa_id = APP.exam_id)
									     JOIN TbAvaliacaoAplicacao  TBA ON (TBA.id_avaliacao = AVA.id_avaliacao AND
                                                                            tba.extra = app.extra)
									     JOIN TbUsuario             TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
                                    LEFT JOIN TbAvaliacaoRealizacao XXX ON (XXX.id_avaliacao_aplicacao = TBA.id_avaliacao_aplicacao AND 
								                                            XXX.id_usuario = TBU.ID)
   WHERE  tba.id_avaliacao_aplicacao = 425
          AVA.exa_id = @AVALIACAO_EXT_ID AND 
		 TBA.dt_aplicacao = @DATA_APLICACAO AND 
         APP.started_at IS NOT NULL  AND 
		 XXX.id_avaliacao_aplicacao IS NULL  


--------------------------------------------------------------------------------------------
--  ######### INSERT TBAVALIACAOREALIZACAORESPOSTA  #########
  INSERT INTO TbAvaliacaoRealizacaoResposta (id_avaliacao_realizacao, id_item_alternativa, id_avaliacao_item)
    SELECT TRA.id_avaliacao_real




    SELECT * FROM CMMG_APPLICATION_APPLICATION caa --left JOIN TbAvaliacaoAplicacao taa ON (caa.extra = taa.extra)
    WHERE caa.exam_id IN (13) AND extra IS  NULL 
    
    ORDER BY user_id

    SELECT * FROM TbAvaliacaoAplicacao WHERE extra IS NOT NULL 

    SELECT *   FROM TbAvaliacaoRealizacao tar
    WHERE tar.id_avaliacao_aplicacao In (424, 425, 426, 449, 450, 451) AND id_usuario = 19003
    ORDER BY id_usuario 

SELECT DISTINCT apa.* 
  FROM TbAvaliacaoRealizacaoResposta arr JOIN tbavaliacaorealizacao avr ON (avr.id_avaliacao_realizacao = arr.id_avaliacao_realizacao)
                                         JOIN tbavaliacaoaplicacao  apa ON (apa.id_avaliacao_aplicacao = avr.id_avaliacao_aplicacao)
                                         JOIN tbavaliacao           ava ON (ava.id_avaliacao = apa.id_avaliacao)
                                         JOIN CMMG_APPLICATION_APPLICATION app ON (app.extra = apa.extra)
  WHERE app.exam_id IN (13)



  SELECT * FROM CMMG_APPLICATION_APPLICATION caa left JOIN tbavaliacaoaplicacao avp ON (caa.extra = avp.extra)
  WHERE caa.exam_id = 13



  SELECT DISTINCT tar.*
  FROM CMMG_APPLICATION_APPLICATION APP JOIN CMMG_USUARIO         USU ON (APP.user_id = USU.id)
                                         JOIN VW_CMMG_AVALIACAO    AVA ON (AVA.exa_id = APP.exam_id)
									     JOIN TbPessoaFisica       TBF ON (TBF.nome = USU.name and 
										                                   tbf.external_id = usu.id)
									     JOIN TbUsuario            TBU ON (TBU.ID_PESSOA_FISICA = TBF.id_pessoa_fisica)
                                         JOIN TbAvaliacaoAplicacao apl ON (apl.id_avaliacao = ava.id_avaliacao)
                                    LEFT JOIN TbAvaliacaoRealizacao tar ON (tar.id_avaliacao_aplicacao = apl.id_avaliacao_aplicacao)
   WHERE app.exam_id = 13 AND 
         app.extra = apl.extra AND
         tar.id_avaliacao_realizacao IS NULL 


SELECT DISTINCT rea.id_avaliacao_realizacao
  FROM TbAvaliacaoRealizacao rea JOIN TbAvaliacaoAplicacao         apl ON (rea.id_avaliacao_aplicacao = apl.id_avaliacao_aplicacao)
                                 JOIN TbUsuario                    usu ON (usu.id = rea.id_usuario)
                                 JOIN TbPessoaFisica               tpf ON (tpf.id_pessoa_fisica = usu.id_pessoa_fisica)
                            LEFT JOIN CMMG_APPLICATION_APPLICATION app ON (app.extra = apl.extra AND
                                                                           app.user_id = tpf.external_id)
 WHERE id_avaliacao = 368 AND app.user_id IS  NULL 


 SELECT * into tmp_FROM TbAvaliacaoRealizacao

 SELECT * delete FROM TbAvaliacaoRealizacaoresposta 
 WHERE id_avaliacao_realizacao In (29010, 29012, 29015, 29016, 29023, 29024, 29025, 29026, 29027, 29028, 29029, 29030, 29031, 29032, 29033, 29034, 29035, 
29036, 29037, 29038, 29039, 29040, 29041, 29042, 29043, 29044, 29045, 29046, 29047, 29048, 29049, 29050, 29051, 29052, 29053, 
29054, 29056, 29057, 29058, 29059, 29060, 29061, 29062, 29063, 29064, 29065, 29067, 29068, 29069, 29070, 29071, 29072, 29073, 
29074, 29075, 29076, 29077, 29078, 29079, 29080, 29081, 29082, 29083, 29085, 29086, 29087, 29088, 29089, 29090, 29091, 29092, 
29093, 29094, 29095, 29096, 29097, 29098, 29099, 29100, 29101, 29102, 29103, 29104, 29105, 29106, 29107, 29108, 29109, 29110, 
29111, 29112, 29114, 29115, 29116, 29117, 29118, 29119, 29120, 29121, 29122, 29123, 29124, 29125, 29126, 29128, 29129, 29130, 
29131, 29132, 29133, 29134, 29135, 29136, 29137, 29138, 29139, 29140, 29141, 29142, 29143, 29144, 29145, 29146, 29147, 29150, 
29151, 29152, 29156, 29157, 29161, 29164, 29166, 29167, 29171, 29172, 29173, 29174, 29175, 29177, 29179, 29180, 29181, 29182, 
29183, 29184, 29185, 29186, 29187, 29188, 29189, 29190, 29191, 29192, 29193, 29194, 29195, 29196, 29197, 29198, 29199, 29201, 
29202, 29203, 29204, 29206, 29207, 29208, 29209, 29210, 29211, 29212, 29213, 29214, 29215, 29216, 29217, 29218, 29219, 29220, 
29221, 29222, 29223, 29224, 29225, 29227, 29228, 29229, 29230, 29231, 29232, 29233, 29234, 29235, 29237, 29238, 29239, 29240, 
29241, 29242, 29243, 29244, 29246, 29247, 29248, 29249, 29250, 29251, 29252, 29253, 29254, 29255, 29256, 29257, 29259, 29261, 
29262, 29264, 29265, 29266, 29267, 29268, 29269, 29270, 29272, 29273, 29275, 29277, 29278, 29279, 29281, 29282, 29283, 29284, 
29285, 29286, 29287, 29288, 29289, 29292, 29293, 29294, 29297, 29299, 29300, 29301, 29302, 29303, 29314, 29315, 29316, 29317, 
29318, 29319, 29320, 29321, 29322, 29323, 29324, 29325, 29326, 29327, 29328, 29329, 29330, 29331, 29332, 29333, 29334, 29335, 
29336, 29337, 29338, 29339, 29340, 29341, 29342, 29343, 29344, 29345, 29346, 29347, 29348, 29349, 29350, 29351, 29352, 29353, 
29354, 29355, 29356, 29357, 29358, 29359, 29360, 29361, 29362, 29363, 29364, 29365, 29366, 29367, 29368, 29369, 29370, 29371, 
29372, 29373, 29374, 29375, 29376, 29377, 29378, 29379, 29380, 29381, 29382, 29383, 29384, 29385, 29386, 29387, 29389, 29390, 
29391, 29392, 29393, 29394, 29395, 29396, 29397, 29398, 29399, 29400, 29401, 29402, 29403, 29404, 29405, 29406, 29407, 29408, 
29409, 29410, 29411, 29412, 29413, 29414, 29415, 29416, 29417, 29418, 29419, 29420, 29421, 29422, 29423, 29424, 29425, 29426, 
29427, 29428, 29429, 29430, 29431, 29432, 29433, 29434, 29435, 29436, 29437, 29438, 29440, 29448, 29449, 29453, 29454, 29455, 
29456, 29458, 29459, 29460, 29461, 29462, 29464, 29467, 29468, 29469, 29470, 29473, 29474, 29475, 29476, 29477, 29478, 29480, 
29481, 29482, 29483, 29484, 29485, 29486, 29487, 29489, 29490, 29491, 29492, 29493, 29495, 29496, 29498, 29499, 29500, 29501, 
29502, 29503, 29504, 29505, 29506, 29507, 29508, 29509, 29510, 29511, 29512, 29513, 29514, 29515, 29516, 29517, 29518, 29519, 
29520, 29521, 29522, 29524, 29525, 29526, 29527, 29528, 29530, 29531, 29532, 29533, 29534, 29535, 29537, 29538, 29539, 29540, 
29541, 29542, 29543, 29544, 29546, 29548, 29549, 29550, 29551, 29552, 29553, 29554, 29555, 29556, 29557, 29558, 29559, 29560, 
29561, 29562, 29563, 29565, 29566, 29567, 29568, 29569, 29570, 29571, 29572, 29574, 29575, 29576, 29577, 29580, 29581, 29587, 
29589, 29590, 29594, 29595, 29596, 29597, 29598, 29599, 29600, 29601, 29602, 29603, 29604, 29605, 29606, 29607, 29608, 29609, 
29610, 29611, 29612, 29613, 29614, 29615, 29616, 29617, 29618, 29619, 29620, 29621, 29622, 29623, 29624, 29625, 29626, 29627, 
29628, 29629, 29630, 29631, 29632, 29633, 29634, 29635, 29636, 29637, 29638, 29639, 29640, 29641, 29642, 29643, 29644, 29645, 
29646, 29647, 29648, 29649, 29650, 29651, 29652, 29653, 29654, 29655, 29656, 29658, 29659, 29660, 29661, 29662, 29663, 29664, 
29665, 29666, 29667, 29668, 29669, 29670, 29671, 29672, 29674, 29675, 29676, 29677, 29678, 29679, 29680, 29681, 29682, 29683, 
29684, 29685, 29686, 29687, 29688, 29689, 29690, 29691, 29692, 29693, 29694, 29695, 29696, 29697, 29698, 29699, 29700, 29701, 
29702, 29703, 29704, 29705, 29706, 29707, 29708, 29709, 29710, 29711, 29712, 29713, 29714, 29715, 29716, 29717, 29719, 29720, 
29722, 29727, 29732, 29733, 29736, 29741, 29742, 29745, 29747)