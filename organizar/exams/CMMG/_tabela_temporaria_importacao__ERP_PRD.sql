 USE ERP_PRD; 
-- with   cte_imp_turmas as (
--   select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� Per�odo', prova = ' Avalia��o de Anatomia Humana I', turma = 'M073S01A201T', disciplina = 'Anatomia Humana I', external_id = 377 union
--   select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� Per�odo', prova = ' Avalia��o de Anatomia Humana I', turma = 'M073S01B201T', disciplina = 'Anatomia Humana I', external_id = 377 union
--   select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� Per�odo', prova = ' Avalia��o de Anatomia Humana I', turma = 'M073S01C201T', disciplina = 'Anatomia Humana I', external_id = 377 union
--   select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� Per�odo', prova = ' Avalia��o de Anatomia Humana I', turma = 'M073S01D201T', disciplina = 'Anatomia Humana I', external_id = 377        
-- )

 drop table tmpimp_provaexam
--select * into tmpimp_provaexam 
--from cte_imp_turmas
--select * from tmpimp_provaexam

SELECT rtrim(ltrim(curso_nome)) as curso, entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina',
       rtrim(ltrim(periodo_nome)) as periodo, 
	   rtrim(ltrim(ds_avaliacao)) as prova,
	   turma = rtrim(ltrim(reverse(left(reverse(ds_aplicacao),charindex('-',reverse(ds_aplicacao)) -1)))), 
	   rtrim(ltrim(disciplina_nome)) as disciplina, id_avaliacao as external_id
into tmpimp_provaexam
 FROM educat_cmmg..vw_aplicacao_curso_disciplina_periodo 
where id_avaliacao = 367

select * from tmpimp_provaexam


	
  --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� Per�odo', prova = 'Avalia��o de Metodologia Cient�fica', turma = 'M073S01A201T', disciplina = 'Metodologia Cientifica', external_id = 375 union
  --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� Per�odo', prova = 'Avalia��o de Metodologia Cient�fica', turma = 'M073S01B201T', disciplina = 'Metodologia Cientifica', external_id = 375 union
  --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� Per�odo', prova = 'Avalia��o de Metodologia Cient�fica', turma = 'M073S01C201T', disciplina = 'Metodologia Cientifica', external_id = 375 union
  --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� Per�odo', prova = 'Avalia��o de Metodologia Cient�fica', turma = 'M073S01D201T', disciplina = 'Metodologia Cientifica', external_id = 375 
    
       --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02A201T', disciplina = 'Anatomia Humana II' union
       --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02B201T', disciplina = 'Anatomia Humana II' union
       --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02C201T', disciplina = 'Anatomia Humana II' union
       --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02D201T', disciplina = 'Anatomia Humana II' --union
       --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02E201T', disciplina = 'INTEGRA��O CURRICULAR II' union
       --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02F201T', disciplina = 'INTEGRA��O CURRICULAR II' union
       --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02G201T', disciplina = 'INTEGRA��O CURRICULAR II' union
       --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02H201T', disciplina = 'INTEGRA��O CURRICULAR II' 
            
			-- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'Avalia��o de EMBRIOLOGIA HUMANA', turma = 'M073S01A201T', disciplina = 'Embriologia Humana' union
            -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'Avalia��o de EMBRIOLOGIA HUMANA', turma = 'M073S01B201T', disciplina = 'Embriologia Humana' union
            -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'Avalia��o de EMBRIOLOGIA HUMANA', turma = 'M073S01C201T', disciplina = 'Embriologia Humana' union
            -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'Avalia��o de EMBRIOLOGIA HUMANA', turma = 'M073S01D201T', disciplina = 'Embriologia Humana' 
             
             -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'APIC do 1� per�odo de Medicina - 1�/2020', turma = 'M073S01A201T', disciplina = 'INTEGRA��O CURRICULAR I' union
             -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'APIC do 1� per�odo de Medicina - 1�/2020', turma = 'M073S01B201T', disciplina = 'INTEGRA��O CURRICULAR I' union
             -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'APIC do 1� per�odo de Medicina - 1�/2020', turma = 'M073S01C201T', disciplina = 'INTEGRA��O CURRICULAR I' union
             -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'APIC do 1� per�odo de Medicina - 1�/2020', turma = 'M073S01D201T', disciplina = 'INTEGRA��O CURRICULAR I' union
             -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'APIC do 1� per�odo de Medicina - 1�/2020', turma = 'M073S01E201T', disciplina = 'INTEGRA��O CURRICULAR I' union
             -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'APIC do 1� per�odo de Medicina - 1�/2020', turma = 'M073S01F201T', disciplina = 'INTEGRA��O CURRICULAR I' union
             -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'APIC do 1� per�odo de Medicina - 1�/2020', turma = 'M073S01G201T', disciplina = 'INTEGRA��O CURRICULAR I' union
             -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '1� periodo', prova = 'APIC do 1� per�odo de Medicina - 1�/2020', turma = 'M073S01H201T', disciplina = 'INTEGRA��O CURRICULAR I' union
            
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'APIC do 2� per�odo de Medicina - 1�/2020', turma = 'M072S02A201T', disciplina = 'INTEGRA��O CURRICULAR II' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'APIC do 2� per�odo de Medicina - 1�/2020', turma = 'M072S02B201T', disciplina = 'INTEGRA��O CURRICULAR II' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'APIC do 2� per�odo de Medicina - 1�/2020', turma = 'M072S02C201T', disciplina = 'INTEGRA��O CURRICULAR II' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'APIC do 2� per�odo de Medicina - 1�/2020', turma = 'M072S02D201T', disciplina = 'INTEGRA��O CURRICULAR II' union
           --        
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '3� periodo', prova = 'APIC do 3� per�odo de Medicina - 1�/2020', turma = 'M071S03A201T', disciplina = 'INTEGRA��O CURRICULAR III' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '3� periodo', prova = 'APIC do 3� per�odo de Medicina - 1�/2020', turma = 'M071S03B201T', disciplina = 'INTEGRA��O CURRICULAR III' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '3� periodo', prova = 'APIC do 3� per�odo de Medicina - 1�/2020', turma = 'M071S03C201T', disciplina = 'INTEGRA��O CURRICULAR III' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '3� periodo', prova = 'APIC do 3� per�odo de Medicina - 1�/2020', turma = 'M071S03D201T', disciplina = 'INTEGRA��O CURRICULAR III' --union       
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '3� periodo', prova = 'APIC do 3� per�odo de Medicina - 1�/2020', turma = 'M071S03E201T', disciplina = 'INTEGRA��O CURRICULAR III' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '3� periodo', prova = 'APIC do 3� per�odo de Medicina - 1�/2020', turma = 'M071S03F201T', disciplina = 'INTEGRA��O CURRICULAR III' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '3� periodo', prova = 'APIC do 3� per�odo de Medicina - 1�/2020', turma = 'M071S03G201T', disciplina = 'INTEGRA��O CURRICULAR III' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '3� periodo', prova = 'APIC do 3� per�odo de Medicina - 1�/2020', turma = 'M071S03H201T', disciplina = 'INTEGRA��O CURRICULAR III' union
           --        
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '4� periodo', prova = 'APIC do 4� per�odo de Medicina - 1�/2020', turma = 'M070A02A201T', disciplina = 'INTEGRA��O CURRICULAR IV' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '4� periodo', prova = 'APIC do 4� per�odo de Medicina - 1�/2020', turma = 'M070A02B201T', disciplina = 'INTEGRA��O CURRICULAR IV' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '4� periodo', prova = 'APIC do 4� per�odo de Medicina - 1�/2020', turma = 'M070A02C201T', disciplina = 'INTEGRA��O CURRICULAR IV' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '4� periodo', prova = 'APIC do 4� per�odo de Medicina - 1�/2020', turma = 'M070A02D201T', disciplina = 'INTEGRA��O CURRICULAR IV' union
           --        
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '5� periodo', prova = 'APIC do 5� per�odo de Medicina - 1�/2020', turma = 'M069A03A201T', disciplina = 'INTEGRA��O CURRICULAR V' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '5� periodo', prova = 'APIC do 5� per�odo de Medicina - 1�/2020', turma = 'M069A03B201T', disciplina = 'INTEGRA��O CURRICULAR V' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '5� periodo', prova = 'APIC do 5� per�odo de Medicina - 1�/2020', turma = 'M069A03C201T', disciplina = 'INTEGRA��O CURRICULAR V' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '5� periodo', prova = 'APIC do 5� per�odo de Medicina - 1�/2020', turma = 'M069A03D201T', disciplina = 'INTEGRA��O CURRICULAR V' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '5� periodo', prova = 'APIC do 5� per�odo de Medicina - 1�/2020', turma = 'M069A03E201T', disciplina = 'INTEGRA��O CURRICULAR V' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '5� periodo', prova = 'APIC do 5� per�odo de Medicina - 1�/2020', turma = 'M069A03F201T', disciplina = 'INTEGRA��O CURRICULAR V' union
           --        
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '6� periodo', prova = 'APIC do 6� per�odo de Medicina - 1�/2020', turma = 'M068A03A201T', disciplina = 'INTEGRA��O CURRICULAR VI' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '6� periodo', prova = 'APIC do 6� per�odo de Medicina - 1�/2020', turma = 'M068A03B201T', disciplina = 'INTEGRA��O CURRICULAR VI' UNION
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '6� periodo', prova = 'APIC do 6� per�odo de Medicina - 1�/2020', turma = 'M068A03C201T', disciplina = 'INTEGRA��O CURRICULAR VI' union
           -- select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '6� periodo', prova = 'APIC do 6� per�odo de Medicina - 1�/2020', turma = 'M068A03D201T', disciplina = 'INTEGRA��O CURRICULAR VI' 
           
            --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '7� periodo', prova = 'APIC do 7� per�odo de Medicina - 1�/2020', turma = 'M067A04A201T', disciplina = 'INTEGRA��O CURRICULAR V' UNION
            --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '7� periodo', prova = 'APIC do 7� per�odo de Medicina - 1�/2020', turma = 'M067A04B201T', disciplina = 'INTEGRA��O CURRICULAR V' union
            --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '7� periodo', prova = 'APIC do 7� per�odo de Medicina - 1�/2020', turma = 'M067A04C201T', disciplina = 'INTEGRA��O CURRICULAR V' UNION 
            --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '7� periodo', prova = 'APIC do 7� per�odo de Medicina - 1�/2020', turma = 'M067A04AC201T', disciplina = 'INTEGRA��O CURRICULAR V' UNION 
            --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '7� periodo', prova = 'APIC do 7� per�odo de Medicina - 1�/2020', turma = 'M067A04D201T', disciplina = 'INTEGRA��O CURRICULAR V'   UNION
            --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '7� periodo', prova = 'APIC do 7� per�odo de Medicina - 1�/2020', turma = 'M067A04E201T', disciplina = 'INTEGRA��O CURRICULAR V'   union
            --select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '7� periodo', prova = 'APIC do 7� per�odo de Medicina - 1�/2020', turma = 'M067A04F201T', disciplina = 'INTEGRA��O CURRICULAR V' 
			--select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02A201T', disciplina = 'ANATOMIA HUMANA II' union
			--select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02B201T', disciplina = 'ANATOMIA HUMANA II' union
			--select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02C201T', disciplina = 'ANATOMIA HUMANA II' union
			--select curso = 'medicina', entidade = 'CMMG - Faculdade de Ci�ncias M�dicas Medicina', periodo = '2� periodo', prova = 'Avalia��o de ANATOMIA HUMANA II', turma = 'M072S02D201T', disciplina = 'ANATOMIA HUMANA II' 






