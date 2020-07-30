
select con.id as contrato_id, alu.id as aluno_id, alu.nome as aluno_nome, alu.ra as aluno_ra, crc.id as curriculo_id, crc.nome as curriculo_nome,
                 crcx.id as curriculo_id_cra, crcx.nome as curriculo_nome_cra, stc.nome as status_curriculo_cra
from contratos_contrato con join academico_aluno      alu on (alu.id = con.aluno_id)
                            join curriculos_curriculo crc on (crc.id = con.curriculo_id)
							join curriculos_aluno cra on (cra.aluno_id = con.aluno_id)
							join curriculos_curriculo crcx on (cra.curriculo_id = crcx.id)
							join curriculos_statusaluno stc on (stc.id = cra.status_id)
where con.id in (
select con.id
from contratos_contrato con left join curriculos_aluno cra on (con.aluno_id = cra.aluno_id and 
                                                       con.curriculo_id = cra.curriculo_id and 
													   cra.status_id = 13)
where cra.id is null ) and 
   stc.nome <> 'Transf. Curricular'
order by alu.nome