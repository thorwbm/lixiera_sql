
select crc.id as curriculo_id, crc.nome as curriculo into TMP_RENOVACAO_MATRICULA_2020
  from curriculos_curriculo crc 
 where crc.nome in (
	'MEDICINA 2020/12-1 (1-2020)',
	'MEDICINA 2019/12-2 (2-2019)',
	'MEDICINA 2019/12-1 (1-2019)',
	'MEDICINA 2018/6-2 (2-2018)',
	'MEDICINA 2017/6-3 (2-2017)',
	'ENFERMAGEM 2017/10-1',
	'ENFERMAGEM 2016/10-1',
	'PSICOLOGIA 2018/10-1',
	'PSICOLOGIA 2017/10-1',
	'PSICOLOGIA 2016/10-1'
)