select *

-- setar maximo correcao e nota corretor
update cor set cor.max_correcoes_dia = 30, 
               cor.nota_corretor = null 
 from correcoes_corretor cor 


-- apagar historico correcao
delete  from correcoes_historicocorrecao
 DBCC CHECKIDENT('correcoes_historicocorrecao', RESEED, 0) ;

-- apagar analises
delete from correcoes_pendenteanalise
delete from correcoes_analise
 DBCC CHECKIDENT('correcoes_pendenteanalise', RESEED, 0) ;
 DBCC CHECKIDENT('correcoes_analise', RESEED, 0) ;

-- apgar filapessoal 
delete from correcoes_filapessoal
 DBCC CHECKIDENT('correcoes_filapessoal', RESEED, 0) ;

-- apagar correcoes correao
 delete from correcoes_correcao
 DBCC CHECKIDENT('correcoes_correcao', RESEED, 0) ;

-- LIMPAR USUARIOS
delete gru from auth_user_groups gru join auth_user usu on (usu.id = gru.user_id)
where isnumeric(username) = 1

delete from correcoes_corretor

delete ppu from projeto_projeto_usuarios ppu join auth_user usu on (usu.id = ppu.user_id)
where isnumeric(username) = 1

delete UPS from usuarios_pessoa UPS join auth_user usu on (usu.id = UPS.USUARIO_ID)
where isnumeric(username) = 1
 delete from correcoes_correcao
 DBCC CHECKIDENT('usuarios_pessoa', RESEED, 1) ;


 delete EAT from external_auth_token EAT join auth_user usu on (usu.id = EAT.USUARIO_ID)
where isnumeric(username) = 1

DELETE FROM log_correcoes_correcao
DELETE FROM log_correcoes_filapessoal
delete from log_correcoes_historicocorrecao
delete from log_correcoes_pendenteanalise 


 delete from auth_user 
 where isnumeric(username) = 1



/*

 -- apagar correcoes redacao
delete from correcoes_gabarito
 DBCC CHECKIDENT('correcoes_gabarito', RESEED, 0) ; 
delete from correcoes_redacao
 DBCC CHECKIDENT('correcoes_redacao', RESEED, 0) ;

 */


/**********************************************
POS CARGA DE USUARIOS (AVALIADORES, COORDENADORES....)

select count(1) from auth_user 
select count(1) from auth_user_groups
select count(1) from projeto_projeto_usuarios
select count(1) from correcoes_corretor
select count(1) FROM CORRECOES_CORRECAO
SELECT COUNT(1) FROM correcoes_filapessoal

update correcoes_corretor set max_correcoes_dia = 30

insert into projeto_projeto_usuarios (projeto_id, user_id)
select 1, usu.id from auth_user usu  left join projeto_projeto_usuarios xxx on (usu.id = xxx.user_id and xxx.projeto_id = 1)
where xxx.id is null 

select * 
--update usu set usu.password = 'pbkdf2_sha256$150000$vTMiQuPlOvmo$bm6Jq9+pkTfwmT5mNEacnCy5NhJUVMMZLtb73nTSeOU=', usu.is_active = 1
from auth_user usu where password = ''

  exec sp_gera_carga_correcoes_corretor

***********************************************/
