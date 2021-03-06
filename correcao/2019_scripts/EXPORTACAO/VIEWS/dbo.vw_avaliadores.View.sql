/****** Object:  View [dbo].[vw_avaliadores]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_avaliadores] as
select 
       a.geral_descricao as geral,
	   a.fgv_descricao as fgv,
	   a.polo_descricao as polo,
	   a.time_descricao as time, 
	   a.indice,
       b.cpf,
       b.email,
       b.telefone_celular,
       b.municipio,
       b.dddtelefone_celular,
       b.uf,
       b.nome,
       f.id_usuario_responsavel,
       f.descricao as hierarquia,
       b.usuario_id as id,
       b.cep,
       b.bairro,
       b.complemento,
       b.dddtelefone_residencial,
       b.logradouro,
       b.numero,
       b.telefone_residencial,
       a.time_id as hierarquia_id,
	   c.max_correcoes_dia,
       c.status_id,
       e.id as group_id,
       e.name as group_name,
       c.pode_corrigir_1,
       c.pode_corrigir_2,
       c.pode_corrigir_3,
		(( CASE WHEN c.pode_corrigir_1 = 1
						AND (c.pode_corrigir_2 = 1
							OR c.pode_corrigir_3 = 1) THEN
						'1ª, '
						WHEN c.pode_corrigir_1 = 1 THEN
						'1ª'
					ELSE
						''
		END) + ( CASE WHEN c.pode_corrigir_2 = 1
				AND c.pode_corrigir_3 = 1 THEN
				'2ª, '
				WHEN c.pode_corrigir_2 = 1 THEN
				'2ª'
			ELSE
				''
		END) + ( CASE WHEN c.pode_corrigir_3 = 1 THEN
				'3ª'
			ELSE
				''
		END)) AS tipo_correcao,
		count(g.data_termino) as total_correcoes,
        (SELECT
			COUNT(j.id)
		FROM
			dbo.correcoes_suspensao j
		WHERE (j.id_corretor = c.id)) AS total_suspensoes,
		h.max_correcoes_dia as projeto_max_correcoes_dia,
		h.id AS projeto_id

  from vw_usuarios_hierarquia_para_vw_avaliadores a
       inner join usuarios_pessoa b on b.usuario_id = a.usuario_id
	   inner join correcoes_corretor c on c.id = a.usuario_id
	   inner join auth_user_groups d on c.id = d.user_id
	   inner join auth_group e on e.id = d.group_id
	   left outer join usuarios_hierarquia f on f.id = a.time_id
	   left outer join projeto_projeto_usuarios i on i.user_id = c.id
	   left outer join projeto_projeto h on h.id = i.projeto_id
	   left outer join correcoes_correcao g on g.id_corretor = c.id
group by
       a.geral_descricao,
	   a.fgv_descricao,
	   a.polo_descricao,
	   a.time_descricao, 
	   a.indice,
       b.cpf,
       b.email,
       b.telefone_celular,
       b.municipio,
       b.dddtelefone_celular,
       b.uf,
       b.nome,
       f.id_usuario_responsavel,
       f.descricao,
       b.usuario_id,
       b.cep,
       b.bairro,
       b.complemento,
       b.dddtelefone_residencial,
       b.logradouro,
       b.numero,
       b.telefone_residencial,
       a.time_id,
	   c.max_correcoes_dia,
       c.status_id,
       e.id,
       e.name,
       c.pode_corrigir_1,
       c.pode_corrigir_2,
       c.pode_corrigir_3,
	   c.id,
	   h.max_correcoes_dia,
	   h.id
GO
