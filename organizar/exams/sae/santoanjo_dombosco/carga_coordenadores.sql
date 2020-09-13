
select distinct Login as coordenador_login, UsuarioPerfil as coordenador_perfil, UsuarioId as coordenador_id,
       UsuarioNome as coordenador_nome, EscolaId as escola_id, EscolaNome as escola_nome
	   into tmp_imp_carga_coordenador_db_sa 
 from (
select * from tmp_imp_coordenador_dombosco union 
select * from tmp_imp_coordenador_santoanjo) as tab