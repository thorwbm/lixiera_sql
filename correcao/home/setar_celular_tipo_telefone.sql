declare @telefone_tipo_id int = 0

select @telefone_tipo_id = id from pessoas_tipotelefone where nome = 'celular'
if (@telefone_tipo_id = 0) 
	begin
		insert into pessoas_tipotelefone values('Celular')
		select @telefone_tipo_id = id from pessoas_tipotelefone where nome = 'celular'
	end



update pessoas_telefone set numero = replace(rtrim(ltrim(numero)),' ','')


select * from pessoas_telefone
--update pessoas_telefone set tipo_id = @telefone_tipo_id
where numero like '9%'
----------------------------------------
select * from pessoas_telefone
--update pessoas_telefone set tipo_id = @telefone_tipo_id
where numero like '%)9%'
-----------------------------------------
select * from pessoas_telefone
--update pessoas_telefone set tipo_id = @telefone_tipo_id
where numero like '319%'
-----------------------------------------
select * from pessoas_telefone
--update pessoas_telefone set tipo_id = @telefone_tipo_id
where numero like '31 9%'
-----------------------------------------
select * from pessoas_telefone
--update pessoas_telefone set tipo_id = @telefone_tipo_id
where numero like '0319%'
-----------------------------------------
select * from pessoas_telefone
--update pessoas_telefone set tipo_id = @telefone_tipo_id, numero = '9' + numero
where left(numero,1) in ('7','8','9') and len (numero) = 8 
-----------------------------------------
select *  from pessoas_telefone
--update pessoas_telefone set tipo_id = @telefone_tipo_id, NUMERO = STUFF(numero,CHARINDEX(')',numero) + 1,0,'9') 
where numero like '%)7%' OR numero like '%)8%'
-----------------------------------------
select * from pessoas_telefone
--update pessoas_telefone set tipo_id = @telefone_tipo_id, numero = replace(numero, '-','')
where numero like '31-9%'
-----------------------------------------
SELECT *,replace(replace(replace(numero,'(',''),')',''),'-','') from pessoas_telefone 
-- update pessoas_telefone set tipo_id = @telefone_tipo_id
WHERE TIPO_ID <> 3 and len(replace(replace(replace(numero,'(',''),')',''),'-','')) = 11 and 
      left(replace(replace(replace(numero,'(',''),')',''),'-',''),1) <> '0' and 
	  charindex('9',replace(replace(replace(numero,'(',''),')',''),'-','')) = @telefone_tipo_id
-----------------------------------------