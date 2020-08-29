

with cte_datas as (
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  '1� s�rie', dia_aplicacao = '1� DIA'       union 
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  '2� s�rie', dia_aplicacao = '1� DIA'		  union 
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  '3� s�rie', dia_aplicacao = '1� DIA'		  union 
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  'extensivo', dia_aplicacao = '1� DIA'	  union 
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  'extensivo mega', dia_aplicacao = '1� DIA' union 
																											  
select janela_aplicacao = '2020-09-23' , avaliacao_diaganostica =  '4� ano', dia_aplicacao = '1� DIA'		  union 
select janela_aplicacao = '2020-09-23' , avaliacao_diaganostica =  '5� ano', dia_aplicacao = '1� DIA'		  union 
select janela_aplicacao = '2020-09-23' , avaliacao_diaganostica =  '6� ano', dia_aplicacao = '1� DIA'		  union 
																											  
select janela_aplicacao = '2020-09-25' , avaliacao_diaganostica =  '7� ano', dia_aplicacao = '1� DIA'		  union 
select janela_aplicacao = '2020-09-25' , avaliacao_diaganostica =  '8� ano', dia_aplicacao = '1� DIA'		  union 
select janela_aplicacao = '2020-09-25' , avaliacao_diaganostica =  '9� ano', dia_aplicacao = '1� DIA'		  union 

select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  '1� s�rie', dia_aplicacao = '2� DIA'       union 
select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  '2� s�rie', dia_aplicacao = '2� DIA'		  union 
select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  '3� s�rie', dia_aplicacao = '2� DIA'		  union 
select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  'extensivo', dia_aplicacao = '2� DIA'	  union 
select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  'extensivo mega', dia_aplicacao = '2� DIA' union 
																											   
select janela_aplicacao = '2020-09-24' , avaliacao_diaganostica =  '4� ano', dia_aplicacao = '2� DIA'		  union 
select janela_aplicacao = '2020-09-24' , avaliacao_diaganostica =  '5� ano', dia_aplicacao = '2� DIA'		  union 
select janela_aplicacao = '2020-09-24' , avaliacao_diaganostica =  '6� ano', dia_aplicacao = '2� DIA'		  union 
																											  
select janela_aplicacao = '2020-09-28' , avaliacao_diaganostica =  '7� ano', dia_aplicacao = '2� DIA'		  union 
select janela_aplicacao = '2020-09-28' , avaliacao_diaganostica =  '8� ano', dia_aplicacao = '2� DIA'		  union 
select janela_aplicacao = '2020-09-28' , avaliacao_diaganostica =  '9� ano', dia_aplicacao = '2� DIA'		   
) 



SELECT DISTINCT 
       json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome, 
	   json_value(usu.extra, '$.hierarchy.unity.value') as escola_id, 
	   json_value(usu.extra, '$.hierarchy.grade.name') as grade_nome, 
	   json_value(usu.extra, '$.hierarchy.grade.value') as grade_id
FROM TMP_IMP_ESCOLA_SEM_AGENDAMENTO age join auth_user usu on (age.escola_nome = json_value(usu.extra, '$.hierarchy.unity.name'))
                                        join cte_datas dat on (dat.avaliacao_diaganostica = json_value(usu.extra, '$.hierarchy.grade.name'))
where json_value(usu.extra, '$.hierarchy.grade.name') in ('extensivo','extensivo mega', '1� s�rie', '2� s�rie', '3� s�rie', '4� ano',
                                                           '5� ano', '6� ano', '7� ano', '8� ano', '9� ano' )



select * from tmp_imp_escola_1dia

/*  27
29/09 - 1�, 2� e 3� - Dia 01
23/09 - 4�, 5� e 6� - Dia 01
25/09 - 7�, 8� e 9� - Dia 01
30/09 - 1�, 2� e 3� - Dia 02
24/09 - 4�, 5� e 6� - Dia 02
28/09 - 7�, 8� e 9� - Dia 02

*/