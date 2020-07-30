
select distinct nome, cpf = replace(replace(cpf,'.',''),'.',''), phone_number from tmp_rematricula rem  join personal_personaldata dat on (rem.nome = dat.real_name)

