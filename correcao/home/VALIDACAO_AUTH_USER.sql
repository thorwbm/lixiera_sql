select usu1.id, usu1.nome_civil, usu2.id, usu2.nome_civil, pes.nome_civil
  from auth_user usu1 join pessoas_pessoa pes  on (pes.id = usu1.person_id)
                      join auth_user      usu2 on (pes.id = usu2.person_id)
where usu1.id <> usu2.id and 
      usu1.nome_civil <> usu2.nome_civil

-- ##############################################################################
-- USUARIOS QUE POSSUEM DOIS RESGISTROS NA AUTH_USER COM DIVERGENCIA DE NOME MAS 
-- APONTAM PARA A MESMA PESSOA 
---------------------------------------------------------------------------------
select id, nome_civil, last_name, email from auth_user 
where id in (select usu1.id  
               from auth_user usu1 join pessoas_pessoa pes  on (pes.id = usu1.person_id)
                                   join auth_user      usu2 on (pes.id = usu2.person_id)
              where usu1.id <> usu2.id and 
                    usu1.nome_civil <> usu2.nome_civil) order by 2