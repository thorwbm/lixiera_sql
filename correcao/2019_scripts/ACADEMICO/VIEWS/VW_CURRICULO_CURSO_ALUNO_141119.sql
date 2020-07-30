create view vw_curriculo_curso_aluno as 
select distinct 
       cur.id as curso_id, cur.nome as curso_nome, 
       crc.id as curriculo_id, crc.nome as curriculo_nome, 
	   alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra, pes.cpf as aluno_cpf, 
	   csa.id as statuscurriculoaluno_id, csa.nome as statuscurriculoaluno_nome, csa.curso_atual

from curriculos_aluno cra join academico_aluno        alu on (alu.id = cra.aluno_id)
                          join curriculos_curriculo   crc on (crc.id = cra.curriculo_id)
						  join academico_curso        cur on (cur.id = crc.curso_id)
						  join curriculos_statusaluno csa on (csa.id = cra.status_id)    
                          join auth_user              usu with(nolock) on (usu.id = alu.user_id)     
                          join pessoas_pessoa         pes with(nolock) on (pes.id = alu.pessoa_id) 