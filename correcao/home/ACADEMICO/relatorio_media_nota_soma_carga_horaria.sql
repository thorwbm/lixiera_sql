--create or alter view vw_acd_media_geral as 
declare @casasdecimais INTEGER 
set @casasdecimais = 1
select alu.id as aluno_id, alu.ra as aluno_ra, alu.nome as aluno_nome, crc.nome as curriculo_nome, csa.nome as aluno_curriculo_status,  
       dsc.curriculo_aluno_id, cast(round(avg(dsc.nota),@casasdecimais) as real)  as media_geral, sum(dsc.carga_horaria) as carga_horaria_cumprida
from curriculos_disciplinaconcluida dsc join curriculos_aluno       cra on (cra.id = dsc.curriculo_aluno_id)
                                        join curriculos_curriculo   crc on (crc.id = cra.curriculo_id)
                                        join academico_aluno        alu on (alu.id = cra.aluno_id)
                                        join curriculos_statusaluno csa on (csa.id = cra.status_id)
where dsc.status_id = 2  and 
      cra.status_id = 13
group by dsc.curriculo_aluno_id, alu.id, alu.ra, alu.nome, crc.nome, csa.nome


select * from vw_acd_media_geral
order by aluno_nome, curriculo_nome


select * 
from curriculos_disciplinaconcluida dsc join curriculos_aluno       cra on (cra.id = dsc.curriculo_aluno_id)
                                        join curriculos_curriculo   crc on (crc.id = cra.curriculo_id)
                                        join academico_aluno        alu on (alu.id = cra.aluno_id)
                                        join curriculos_statusaluno csa on (csa.id = cra.status_id)
where dsc.status_id = 2  and 
      cra.status_id = 13 and 
      alu.nome = 'MARINE ALVES'