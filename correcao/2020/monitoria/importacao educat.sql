
begin tran 

-- ***************** CARGA NA TABELA CURSO **************************
 -- select * from curso 
  --insert into curso 
	  select distinct curso_id, curso,'ATIVO' from [tmp_importacao_monitoria_2019] imp
	  where not exists (select * from curso cur where cur.des_cur COLLATE DATABASE_DEFAULT = imp.curso COLLATE DATABASE_DEFAULT)
	  order by 1

-- ***************** CARGA NA TABELA DISCIPLINA **************************
  --select * from disciplina
 -- insert into disciplina 
	  select distinct DISCIPLINA, disciplina_id, sigla =null   from tmp_importacao_monitoria_2019 imp	
	   where not exists (select * 
	                     from disciplina dis 
						where dis.des_dis COLLATE DATABASE_DEFAULT = imp.disciplina COLLATE DATABASE_DEFAULT)	
	  order by 1

-- ******************* CARGA DE PROFESSORES NA TABELA USUARIO ******************************************
-- select * from usuario
--insert into usuario
select distinct professor, cpf_professor, login = substring(professor,1,CHARINDEX(' ',professor)-1) + '.' + reverse(substring(reverse(professor),1,CHARINDEX(' ',reverse(professor))-1)) ,
                senha = SUBSTRING(sys.fn_sqlvarbasetostr(HASHBYTES('sha1', replace(replace(cpf_professor,'.',''),'-',''))),3,60),
                email = isnull(email,'semEmail@email.com'),professor_telefone = '000000000', data_nascimento = isnull(data_nascimento, '1901-01-01') 
		  from tmp_importacao_monitoria_2019 tem
	where tem.professor is not null and 
	not exists (select * from usuario usu 
	                   where usu.nom_usu COLLATE DATABASE_DEFAULT = tem.professor COLLATE DATABASE_DEFAULT and  
					         replace(replace(usu.cpf_usu,'.',''),'-','') COLLATE DATABASE_DEFAULT = replace(replace(tem.cpf_professor,'.',''),'-','') COLLATE DATABASE_DEFAULT)
	      and cpf_professor is not null
order by 1 



-- ******************* CARGA DE PROFESSORES NA TABELA USUARIO_PERFIL ******************************************
-- insert into usuario_perfil
select distinct usu.cod_usu,3  from tmp_importacao_monitoria_2019 tem join usuario usu on (replace(replace(usu.cpf_usu,'.',''),'-','') COLLATE DATABASE_DEFAULT = replace(replace(tem.cpf_professor,'.',''),'-','') COLLATE DATABASE_DEFAULT)
where not exists (select * from usuario_perfil usp where usp.cod_usu = usu.cod_usu and usp.cod_per = 3)


-- ******************* CARGA NA TABELA USUARIO_CURSO_DISCPLINA ONDE RELACIONA O PROFESSOR AS SUAS DISCIPLINAS  ******************************************
--insert into usuario_curso_disciplina
select distinct cur.cod_cur, dis.cod_dis, usu.cod_usu
  from tmp_importacao_monitoria_2019 tem join usuario usu on (replace(replace(usu.cpf_usu,'.',''),'-','') COLLATE DATABASE_DEFAULT = replace(replace(tem.cpf_professor,'.',''),'-','') COLLATE DATABASE_DEFAULT)
                                 join disciplina dis on (dis.des_dis  = tem.disciplina)
								 join curso      cur on (cur.des_cur  = tem.curso)
 where not exists (select * from usuario_curso_disciplina ucd where ucd.cod_cur = cur.cod_cur and ucd.cod_dis = dis.cod_dis and ucd.cod_usu = usu.cod_usu)


 --**************** CARGA ESPECIFICA DA DISCIPLINA DE PESQUISA DE EXTENÇAO **********************************
 --INSERT INTO usuario_curso_disciplina 
SELECT DISTINCT  COD_CUR,(select COD_DIS from DISCIPLINA WHERE des_dis = 'PESQUISA E EXTENÇÃO'), COD_USU 
FROM usuario_curso_disciplina UCD  
WHERE NOT EXISTS (SELECT * FROM usuario_curso_disciplina UCDX 
                   WHERE UCDX.COD_CUR = UCD.COD_CUR AND 
				         UCDX.COD_USU = UCD.COD_USU AND
						 UCDX.COD_DIS = (select COD_DIS from DISCIPLINA WHERE des_dis = 'PESQUISA E EXTENÇÃO'))



--*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8*8

-- **************************** CARGA NA TABELA USUARIO - ALUNO *************************************
--INSERT INTO USUARIO 
	SELECT  DISTINCT ALUNO_NOME, ALUNO_CPF, ALUNO_RA, 
	                 ciccpf = STUFF(STUFF(STUFF(ALUNO_CPF,10,0,'-'),7,0,'.'),4,0,'.') COLLATE DATABASE_DEFAULT,
                     senha = isnull(SUBSTRING(sys.fn_sqlvarbasetostr(HASHBYTES('sha1', replace(replace(ALUNO_CPF,'.',''),'-',''))),3,60),'7751a23fa55170a57e90374df13a3ab78efe0e99') COLLATE DATABASE_DEFAULT, 
	                 ALUNO_TELEFONE = NULL,ALUNO_DTNASC
	  FROM tmp_importacao_monitoria_2019 TEM
	 WHERE 
	       NOT EXISTS (SELECT * FROM USUARIO USU WHERE replace(replace(USU.cpf_usu,'.',''),'-','') = replace(replace(TEM.ALUNO_CPF,'.',''),'-','')) 
	 ORDER BY 1



-- **************************** CARGA NA TABELA ALUNO_CURSO_DISCIPLINA *************************************
if exists(Select * from Tempdb..SysObjects Where Name Like '#tmp_importacao%') drop table #tmp_importacao
if exists(Select * from Tempdb..SysObjects Where Name Like '#tmp_import_final%') drop table #tmp_import_final

	select tmp.curso, tmp.disciplina, tmp.aluno_nome,  tmp.aluno_cpf, tmp.etapa,  tmp.ano,max(isnull(tmp.nota,0)) nota
	 into #tmp_importacao
     from tmp_importacao_monitoria_2019	tmp			where  tmp.aluno_nome = 'BARBARA BELLONI PEREZ COUTO'		  							  
	and 
		  tmp.situacao  in ( 'Aprovado', 'DISPENSADO', 'RESERVA', 'Reprovado por Falta','Reprovado') 
	group by tmp.curso, tmp.disciplina, tmp.aluno_nome,  tmp.aluno_cpf,  tmp.ano, tmp.etapa

	select usu.cod_usu, crs.cod_cur, dsp.cod_dis, tna.ano, tna.ETAPA, tna.nota	
	  into #tmp_import_final
	  from #tmp_importacao tna join usuario usu with(nolock) on (tna.aluno_nome = usu.nom_usu and 
	                                                             replace(replace(usu.cpf_usu,'.',''),'-','') = replace(replace(tna.aluno_cpf,'.',''),'-',''))
							   join curso   crs with(nolock) on (crs.des_cur = tna.curso)
							   join disciplina dsp with(nolock) on (dsp.des_dis = tna.disciplina)


							   select * from #tmp_importacao where aluno_nome ='BARBARA BELLONI PEREZ COUTO'	
	-- **************************** CARGA NA TABELA ALUNO_CURSO_DISCIPLINA *************************************
-- insert into aluno_curso_disciplina (cod_usu, cod_cur, cod_dis, ano_acd, per_acd, not_acd)
	select cod_usu, cod_cur, cod_dis, ano, etapa, nota	
	  from #tmp_import_final tna 
	where not exists (select 1 from aluno_curso_disciplina acdx with(nolock)
		               where acdx.cod_usu = tna.cod_usu and 
					         acdx.cod_cur = tna.cod_cur and
							 acdx.cod_dis = tna.cod_dis) 
				and tna.ano is not null and cod_dis = 697
					 
-- ***********************************  CARGA ESPECIFICA ******************************************
 -- INSERT INTO aluno_curso_disciplina
select DISTINCT ACD.cod_usu, ACD.cod_cur, DIS.cod_dis, YEAR(GETDATE()) -1, 1, 100
  from CURSO CUR JOIN aluno_curso_disciplina ACD ON (ACD.cod_cur = CUR.cod_cur)
            LEFT JOIN disciplina             DIS ON (DIS.des_dis = 'PESQUISA E EXTENÇÃO')
WHERE NOT EXISTS (SELECT * FROM aluno_curso_disciplina ACDX 
	               WHERE ACDX.COD_USU = ACD.COD_USU AND 
				         ACDX.COD_CUR = ACD.COD_CUR AND
						 ACDX.COD_DIS = 424)

-- **************************** CARGA NA TABELA USUARIO_PERFIL *************************************
-- insert into usuario_perfil
select distinct cod_usu, 2 from aluno_curso_disciplina acd
where not exists (select * from usuario_perfil upr where upr.cod_usu = acd.cod_usu and upr.cod_per = 2)

	-- ***************************************
  -- update aluno_curso_disciplina set not_acd = nota, ano_acd = atu.ANO, per_acd = atu.ETAPA
  -- select * 
  from aluno_curso_disciplina acd join #tmp_import_final atu on (acd.cod_usu = atu.cod_usu and 
                                                               acd.cod_cur = atu.cod_cur and 
															   acd.cod_dis = atu.cod_dis and 
															   acd.per_acd = atu.etapa)
 where acd.not_acd <> atu.NOTA 





 -- commit 
 -- rollback 