with cte_aluno_prouni_fies as (
		select distinct cra.id as curriculo_aluno_id, cra.aluno_id, cra.curriculo_id, fmi.id as ingresso_id , fmi.nome as ingresso_nome
		  from curriculos_aluno cra join curriculos_formaingresso fmi on (fmi.id = cra.metodo_admissao_id )
		 where fmi.nome in ('PROUNI','enem','FIES','ENEM-PROUNI') and 
			   cra.status_id = 13 
)

	, cte_informacoes as (
		select  distinct  ALU.ID as aluno_id, cra.id as curriculo_aluno_id, etp.ETAPA, ETP.ID, eta.periodo, eta.id as etapaano_id  
		  from curriculos_aluno cra join curriculos_curriculo crc on (crc.id = cra.curriculo_id)
									join curriculos_grade      gra on (cra.grade_id = gra.id)
									join academico_etapa       etp on (etp.id = gra.etapa_id and 
																	   crc.curso_oferta_id = etp.curso_oferta_id)
									join academico_etapaano    eta on (etp.id = eta.etapa_id)
									join academico_aluno       alu on (alu.id = cra.aluno_id)
									join academico_turmadisciplinaaluno tda on (tda.aluno_id = cra.aluno_id )
									join academico_turmadisciplina      tds on (tds.id = tda.turma_disciplina_id)
									join academico_turma                tur on (tur.id = tds.turma_id and 
																				eta.id = tur.etapa_ano_id)
		  
)

	, cte_aluno_turma_disciplina as (
		select cte.* , tur.grade_id, tur.etapa_ano_id
		  from cte_aluno_prouni_fies cte join academico_turmadisciplinaaluno tda on (cte.aluno_id = tda.aluno_id)
		                                 join academico_aluno                alu on (alu.id = tda.aluno_id)
		                                 join academico_turmadisciplina      tds on (tds.id = tda.turma_disciplina_id)
										 join academico_turma                tur on (tur.id = tds.turma_id and 
										                                             tur.turma_pai_id is null)
                                         join curriculos_grade               gra on (gra.id = tur.grade_id )
)

	, cte_disciplinas_grade as (
		   select distinct *, (select count(1) from cte_aluno_turma_disciplina aux 
					   where cte.curriculo_aluno_id = aux.curriculo_aluno_id and
							 cte.grade_id = aux.grade_id and 
							 cte.etapa_ano_id = aux.etapa_ano_id) as qtd
		   from cte_aluno_turma_disciplina cte
)

	, cte_qtd_situacao as (
			select curriculo_aluno_id, con.status_id,etapa_ano_id, sta.nome as status, count(1) as qtd
			  from curriculos_disciplinaconcluida con join curriculos_statusdisciplina sta on (con.status_id = sta.id)
			  where status_id in (2,9,10)
			     group by curriculo_aluno_id, con.status_id,etapa_ano_id, sta.nome
)
			
	, cte_agrupando as (
			select dgr.curriculo_aluno_id, dgr.etapa_ano_id, dgr.aluno_id, ingresso_nome, dgr.grade_id, dgr.qtd,
			case when status = 'aprovado' then sit.qtd else 0 end as aprovado,
			case when status <> 'aprovado' then sit.qtd else 0 end as reprovado
			  from cte_qtd_situacao sit join cte_disciplinas_grade dgr on (sit.curriculo_aluno_id = dgr.curriculo_aluno_id and 
			                                                               sit.etapa_ano_id       = dgr.etapa_ano_id       )
)
	, cte_finalizado as (
			select  curriculo_aluno_id, etapa_ano_id, aluno_id, ingresso_nome, grade_id, qtd, sum(aprovado) as aprovado , sum(reprovado) as reprovado
			from cte_agrupando 		
	       group by curriculo_aluno_id, etapa_ano_id, aluno_id, ingresso_nome, grade_id, qtd
) 
			select cte.*, aproveitamento = (100-reprovado * 100.0 / qtd), case when (reprovado * 100.0 / qtd) >= 75 then 'reprovado' else 'aprovado' end as status,
			       alu.nome, alu.ra, crc.nome as curriculo, eta.ano, etp.etapa, etp.nome
			from cte_finalizado cte join academico_aluno      alu on (alu.id = cte.aluno_id)
			                        join curriculos_aluno     cra on (cra.id = cte.curriculo_aluno_id)
									join curriculos_curriculo crc on (crc.id = cra.curriculo_id)
									join academico_etapaano   eta on (eta.id = cte.etapa_ano_id)
									join academico_etapa      etp on (etp.id = eta.etapa_id)
									join cte_informacoes      inf on (inf.curriculo_aluno_id = cte.curriculo_aluno_id and
									                                  inf.etapaano_id = eta.id)

		      where alu.nome = 'ROSELI SOARES DOS REIS'

/*


			select con.curriculo_aluno_id, con.status_id, con.etapa_ano_id
			  from curriculos_disciplinaconcluida con join cte_qtd_situacao  cte on (con.curriculo_aluno_id = cte.curriculo_aluno_id and 
													                                 con.etapa_ano_id       = cte.etapa_ano_id)
			 
			     group by con.curriculo_aluno_id,con.etapa_ano_id, con.status_id


            select * from curriculos_statusdisciplina  
			where
			      etapa_ano_id = 35

			select curriculo_aluno_id, con.status_id, sta.nome, count(1) as qtd
			  from curriculos_disciplinaconcluida con join curriculos_statusdisciplina sta on (con.status_id = sta.id)
			where curriculo_aluno_id = 35396  and 
			      etapa_ano_id = 35
			     group by curriculo_aluno_id, con.status_id, sta.nome

				 select * from curriculos_statusdisciplina*/