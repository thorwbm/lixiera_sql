-- **** datas das correcoes (dias)
with	 cte_datas_correcao as (
		select distinct cast(data_termino as date) as data_correcao
		  from  correcoes_correcao 
)

	-- **** associacao dos corretores com as datas de correcao
	, cte_corretores as (
		select pes.usuario_id as corretor_id, pes.cpf as corretor_cpf, pes.nome as corretor_nome, 
			   gru.name as corretor_perfil, dat.data_correcao
		from usuarios_pessoa pes join auth_user_groups aug on (pes.usuario_id = aug.user_id)
								 join auth_group       gru on (gru.id = aug.group_id) 
								 join cte_datas_correcao dat on (1=1)
)
     
	-- **** correcoes de primeira por corretor
	, cte_correcoes_primeira as (
		select cor.id_corretor as corretor_id, 
		      cast(data_termino as date) as data_correcao,  
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 1
		group by cor.id_corretor, cast(data_termino as date)--, cor.id_projeto
)

	-- **** correcoes de segunda por corretor
	, cte_correcoes_segunda as (
		select cor.id_corretor as corretor_id, 
		      cast(data_termino as date) as data_correcao,
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 2
		group by cor.id_corretor, cast(data_termino as date)--, cor.id_projeto
)

	-- **** correcoes de terceira por corretor
	, cte_correcoes_terceira as (
		select cor.id_corretor as corretor_id,  
		      cast(data_termino as date) as data_correcao,
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 3
		group by cor.id_corretor, cast(data_termino as date)--, cor.id_projeto
)

	-- **** correcoes de quarta por corretor
	, cte_correcoes_quarta as (
		select cor.id_corretor as corretor_id,  
		      cast(data_termino as date) as data_correcao,
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 4
		group by cor.id_corretor, cast(data_termino as date)--, cor.id_projeto
)

	-- **** correcoes de ouro por corretor
	, cte_correcoes_ouro as (
		select cor.id_corretor as corretor_id,  
		      cast(data_termino as date) as data_correcao,
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 5
		group by cor.id_corretor, cast(data_termino as date)--, cor.id_projeto
)

	-- **** correcoes de moda por corretor
	, cte_correcoes_moda as (
		select cor.id_corretor as corretor_id,  
		      cast(data_termino as date) as data_correcao,
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 6
		group by cor.id_corretor, cast(data_termino as date)--, cor.id_projeto
)

	-- **** correcoes de auditoria por corretor
	, cte_correcoes_auditoria as (
		select cor.id_corretor as corretor_id,  
		      cast(data_termino as date) as data_correcao,
			   count(1) as qtd_correcao
		 from correcoes_correcao cor 
		where cor.id_status = 3 and
		      cor.id_tipo_correcao = 7
		group by cor.id_corretor, cast(data_termino as date)--, cor.id_projeto
)


insert into relatorios_extratocorrecaodiario
       (data, usuario_id, nome, cpf, perfil, enviados, enviados_primeira, enviados_segunda, enviados_terceira, enviados_quarta, 
              enviados_ouro, enviados_moda, enviados_auditoria, glosadas)

			  select cor.data_correcao, cor.corretor_id, cor.corretor_nome, cor.corretor_cpf, cor.corretor_perfil,
			         envidadas          = isnull(pri.qtd_correcao,0)+
					 					  isnull(seg.qtd_correcao,0)+
					 					  isnull(ter.qtd_correcao,0)+
					 					  isnull(qua.qtd_correcao,0)+
					 					  isnull(our.qtd_correcao,0)+
					 					  isnull(mda.qtd_correcao,0)+
					 					  isnull(aud.qtd_correcao,0),							  
			         enviados_primeira  = isnull(pri.qtd_correcao,0), 
			         enviados_segunda   = isnull(seg.qtd_correcao,0), 
			         enviados_terceira  = isnull(ter.qtd_correcao,0), 
			         enviados_quarta    = isnull(qua.qtd_correcao,0), 
			         enviados_ouro      = isnull(our.qtd_correcao,0), 
			         enviados_moda      = isnull(mda.qtd_correcao,0), 
			         enviados_auditoria = isnull(aud.qtd_correcao,0),
					 glosadas = 0   
			    from cte_corretores cor left join cte_correcoes_primeira  pri on (cor.corretor_id = pri.corretor_id AND COR.DATA_CORRECAO = pri.DATA_CORRECAO)
				                        left join cte_correcoes_segunda   seg on (cor.corretor_id = seg.corretor_id AND COR.DATA_CORRECAO = seg.DATA_CORRECAO)
				                        left join cte_correcoes_terceira  ter on (cor.corretor_id = ter.corretor_id AND COR.DATA_CORRECAO = ter.DATA_CORRECAO)
				                        left join cte_correcoes_quarta    qua on (cor.corretor_id = qua.corretor_id AND COR.DATA_CORRECAO = qua.DATA_CORRECAO)
				                        left join cte_correcoes_ouro      our on (cor.corretor_id = our.corretor_id AND COR.DATA_CORRECAO = our.DATA_CORRECAO)
				                        left join cte_correcoes_moda      mda on (cor.corretor_id = mda.corretor_id AND COR.DATA_CORRECAO = mda.DATA_CORRECAO)
				                        left join cte_correcoes_auditoria aud on (cor.corretor_id = aud.corretor_id AND COR.DATA_CORRECAO = aud.DATA_CORRECAO)
              -- group by cor.data_correcao, cor.corretor_id, corretor_nome, corretor_cpf, corretor_perfil 
			  where corretor_cpf is not null 


		-- select * from relatorios_extratocorrecaodiario