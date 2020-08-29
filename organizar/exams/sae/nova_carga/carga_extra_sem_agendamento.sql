

with cte_datas as (
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  '1ª série', dia_aplicacao = '1º DIA'       union 
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  '2ª série', dia_aplicacao = '1º DIA'		  union 
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  '3ª série', dia_aplicacao = '1º DIA'		  union 
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  'extensivo', dia_aplicacao = '1º DIA'	  union 
select janela_aplicacao = '2020-09-29' , avaliacao_diaganostica =  'extensivo mega', dia_aplicacao = '1º DIA' union 
																											  
select janela_aplicacao = '2020-09-23' , avaliacao_diaganostica =  '4º ano', dia_aplicacao = '1º DIA'		  union 
select janela_aplicacao = '2020-09-23' , avaliacao_diaganostica =  '5º ano', dia_aplicacao = '1º DIA'		  union 
select janela_aplicacao = '2020-09-23' , avaliacao_diaganostica =  '6º ano', dia_aplicacao = '1º DIA'		  union 
																											  
select janela_aplicacao = '2020-09-25' , avaliacao_diaganostica =  '7º ano', dia_aplicacao = '1º DIA'		  union 
select janela_aplicacao = '2020-09-25' , avaliacao_diaganostica =  '8º ano', dia_aplicacao = '1º DIA'		  union 
select janela_aplicacao = '2020-09-25' , avaliacao_diaganostica =  '9º ano', dia_aplicacao = '1º DIA'		  union 

select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  '1ª série', dia_aplicacao = '2º DIA'       union 
select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  '2ª série', dia_aplicacao = '2º DIA'		  union 
select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  '3ª série', dia_aplicacao = '2º DIA'		  union 
select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  'extensivo', dia_aplicacao = '2º DIA'	  union 
select janela_aplicacao = '2020-09-30' , avaliacao_diaganostica =  'extensivo mega', dia_aplicacao = '2º DIA' union 
																											   
select janela_aplicacao = '2020-09-24' , avaliacao_diaganostica =  '4º ano', dia_aplicacao = '2º DIA'		  union 
select janela_aplicacao = '2020-09-24' , avaliacao_diaganostica =  '5º ano', dia_aplicacao = '2º DIA'		  union 
select janela_aplicacao = '2020-09-24' , avaliacao_diaganostica =  '6º ano', dia_aplicacao = '2º DIA'		  union 
																											  
select janela_aplicacao = '2020-09-28' , avaliacao_diaganostica =  '7º ano', dia_aplicacao = '2º DIA'		  union 
select janela_aplicacao = '2020-09-28' , avaliacao_diaganostica =  '8º ano', dia_aplicacao = '2º DIA'		  union 
select janela_aplicacao = '2020-09-28' , avaliacao_diaganostica =  '9º ano', dia_aplicacao = '2º DIA'		   
) 



SELECT DISTINCT 
       json_value(usu.extra, '$.hierarchy.unity.name') as escola_nome, 
	   json_value(usu.extra, '$.hierarchy.unity.value') as escola_id, 
	   json_value(usu.extra, '$.hierarchy.grade.name') as grade_nome, 
	   json_value(usu.extra, '$.hierarchy.grade.value') as grade_id
FROM TMP_IMP_ESCOLA_SEM_AGENDAMENTO age join auth_user usu on (age.escola_nome = json_value(usu.extra, '$.hierarchy.unity.name'))
                                        join cte_datas dat on (dat.avaliacao_diaganostica = json_value(usu.extra, '$.hierarchy.grade.name'))
where json_value(usu.extra, '$.hierarchy.grade.name') in ('extensivo','extensivo mega', '1ª série', '2ª série', '3ª série', '4º ano',
                                                           '5º ano', '6º ano', '7º ano', '8º ano', '9º ano' )



select * from tmp_imp_escola_1dia

/*  27
29/09 - 1ª, 2ª e 3ª - Dia 01
23/09 - 4º, 5º e 6º - Dia 01
25/09 - 7º, 8º e 9º - Dia 01
30/09 - 1ª, 2ª e 3ª - Dia 02
24/09 - 4º, 5º e 6º - Dia 02
28/09 - 7º, 8º e 9º - Dia 02

*/