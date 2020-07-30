If Exists(Select * from Tempdb..SysObjects Where Name Like '#tmp_remover%')
drop table #tmp_remover

declare @instituicao_id int,  @instituticao_nome varchar(max)

set @instituticao_nome = '%SÃO TOMÁS DE AQUINO%'
select  @instituicao_id = min(id) from core_instituicao where nome like @instituticao_nome

select  id as codigo_remover 
--into #tmp_remover 
from core_instituicao where nome like @instituticao_nome and id <> @instituicao_id

select distinct instituicao_ensino_medio_id as antigo , @instituicao_id novo
 --  update tab set tab.instituicao_ensino_medio_id = @instituicao_id 
  from historicos_historico tab join #tmp_remover rev on (tab.instituicao_ensino_medio_id = rev.codigo_remover)

select distinct instituicao_id as antigo , @instituicao_id novo 
 --  update tab set tab.instituicao_id = @instituicao_id 
  from academico_pessoa_titulacao tab join #tmp_remover rev on (tab.instituicao_id = rev.codigo_remover) 
  
select distinct instituicao_id as antigo , @instituicao_id novo 
 --  update tab set tab.instituicao_id = @instituicao_id 
  from academico_alunodisciplinainformada tab join #tmp_remover rev on (tab.instituicao_id = rev.codigo_remover) 
  
select distinct instituicao_id as antigo , @instituicao_id novo 
 --  update tab set tab.instituicao_id = @instituicao_id 
  from curriculos_disciplinainformada tab join #tmp_remover rev on (tab.instituicao_id = rev.codigo_remover) 
  
-- **** deletar  ****
select * from core_instituicao ins join #tmp_remover tmp on (ins.id = tmp.codigo_remover)



select * from core_instituicao
where id in (
22271,
22299,
22764,
22417)