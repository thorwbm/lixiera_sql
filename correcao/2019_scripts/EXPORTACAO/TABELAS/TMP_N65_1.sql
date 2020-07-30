-- 191.235.89.232

select DISTINCT  id, cpf, nome, nome_mae, data_nascimento, sexo, Logradouro, N�mero as numero, Complemento, Bairro, CEP, 
       Munic�pio, co_municipio, UF, [DDD_telefone residencial] as ddd_res, [Telefone residencial] as tel_res, celular, email, 
	   Funcao, tp_titulacao,  
    co_titulacao = case tp_titulacao when 'GRADUA��O'	    then 1
	                              when 'ESPECIALIZA��O' then 2 
	                              when 'MESTRADO'	    then 3
	                              when 'DOUTORADO'	    then 4 end 
into TMP_N65
 from vw_N65

 DROP TABLE TMP_N65