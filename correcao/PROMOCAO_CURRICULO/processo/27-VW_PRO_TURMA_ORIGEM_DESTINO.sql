create view VW_PRO_TURMA_ORIGEM_DESTINO as 
select ori.id as turma_origem_id, ori.nome as turma_origem_nome, 
       ORI.grade_id as turma_origem_grade_id, 
	   YEAR(ORi.inicio_vigencia) as turma_origem_ano, 
	   case when MONTH(ori.inicio_vigencia) <7 then 1 else 2 end as turma_origem_periodo,
       dst.id as turma_destino_id, dst.nome as turma_destino_nome, 
	   dst.grade_id as turma_destino_grade_id,
	   YEAR(dst.inicio_vigencia) as turma_destino_ano, 
	   case when MONTH(dst.inicio_vigencia) < 7 then 1 else 2 end as turma_destino_periodo
  from academico_turma dst join academico_turma ori on (ori.id = dst.turma_origem_rematricula_id)