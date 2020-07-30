with cte_corretores as (
		select pes.usuario_id as corretor_id, pes.cpf as corretor_cpf, pes.nome as corretor_nome, 
			   gru.name as corretor_perfil
		from usuarios_pessoa pes join auth_user_groups aug on (pes.usuario_id = aug.user_id)
								 join auth_group       gru on (gru.id = aug.group_id)
)

	-- **** correcoes de primeira por corretor
	, cte_correcoes_primeira as (
		select cor.id_corretor as corretor_id, 
		      -- cor.id_projeto, 
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 1
		group by cor.id_corretor--, cor.id_projeto
)

	-- **** correcoes de segunda por corretor
	, cte_correcoes_segunda as (
		select cor.id_corretor as corretor_id, 
		       --cor.id_projeto, 
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 2
		group by cor.id_corretor--, cor.id_projeto
)

	-- **** correcoes de terceira por corretor
	, cte_correcoes_terceira as (
		select cor.id_corretor as corretor_id, 
		       --cor.id_projeto, 
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 3
		group by cor.id_corretor--, cor.id_projeto
)

	-- **** correcoes de quarta por corretor
	, cte_correcoes_quarta as (
		select cor.id_corretor as corretor_id, 
		     --  cor.id_projeto, 
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 4
		group by cor.id_corretor--, cor.id_projeto
)

	-- **** correcoes de ouro por corretor
	, cte_correcoes_ouro as (
		select cor.id_corretor as corretor_id, 
		      -- cor.id_projeto, 
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 5
		group by cor.id_corretor--, cor.id_projeto
)

	-- **** correcoes de moda por corretor
	, cte_correcoes_moda as (
		select cor.id_corretor as corretor_id, 
		      -- cor.id_projeto, 
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 6
		group by cor.id_corretor--, cor.id_projeto
)

	-- **** correcoes de auditoria por corretor
	, cte_correcoes_auditoria as (
		select cor.id_corretor as corretor_id, 
		       --cor.id_projeto, 
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 7
		group by cor.id_corretor--, cor.id_projeto
)

	, cte_totalizador as (
			  select cor.corretor_id, cor.corretor_nome, cor.corretor_cpf, cor.corretor_perfil,
			         enviados_primeira  = sum(isnull(pri.qtd_correcao,0)), 
			         enviados_segunda   = sum(isnull(seg.qtd_correcao,0)), 
			         enviados_terceira  = sum(isnull(ter.qtd_correcao,0)), 
			         enviados_quarta    = sum(isnull(qua.qtd_correcao,0)), 
			         enviados_ouro      = sum(isnull(our.qtd_correcao,0)), 
			         enviados_moda      = sum(isnull(mda.qtd_correcao,0)), 
			         enviados_auditoria = sum(isnull(aud.qtd_correcao,0)),
					 glosadas = 0   
			    from cte_corretores cor left join cte_correcoes_primeira  pri on (cor.corretor_id = pri.corretor_id)
				                        left join cte_correcoes_segunda   seg on (cor.corretor_id = seg.corretor_id)
				                        left join cte_correcoes_terceira  ter on (cor.corretor_id = ter.corretor_id)
				                        left join cte_correcoes_quarta    qua on (cor.corretor_id = qua.corretor_id)
				                        left join cte_correcoes_ouro      our on (cor.corretor_id = our.corretor_id)
				                        left join cte_correcoes_moda      mda on (cor.corretor_id = mda.corretor_id)
				                        left join cte_correcoes_auditoria aud on (cor.corretor_id = aud.corretor_id)
               group by cor.corretor_id, corretor_nome, corretor_cpf, corretor_perfil 
)  


			insert into relatorios_extratocorrecao
			       (usuario_id, nome, cpf, perfil,enviados_primeira, enviados_segunda, enviados_terceira, 
                    enviados_quarta, enviados_ouro, enviados_moda, enviados_auditoria, glosadas, enviados)
			select *, enviados = (enviados_primeira + enviados_segunda + enviados_terceira + enviados_quarta + 
			                      enviados_ouro + enviados_moda + enviados_auditoria)
			 from cte_totalizador
			 where corretor_cpf is not null 


			 -- select   *  from relatorios_extratocorrecao