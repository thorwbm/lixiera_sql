/*
with cte_disciplina_duplicadas as (
			SELECT NOME, disciplina_id_aux = min(id)
			FROM ACADEMICO_disciplina
             GROUP BY NOME HAVING COUNT(1)> 1
)
	,	cte_disciplinas as (			
				select dis.id, dis.nome, disciplina_id_aux
			  from cte_disciplina_duplicadas dup join academico_disciplina dis on (dup.nome = dis.nome)
) 
			select * into #tmp_disciplina
             from cte_disciplinas

*/

 begin tran 
 declare @disciplina varchar(500), @antigo int, @novo int
declare CUR_ cursor for 
	SELECT * from #tmp_disciplina 
	where id <> disciplina_id_aux
	open CUR_ 
		fetch next from CUR_ into @antigo, @disciplina, @novo
		while @@FETCH_STATUS = 0
			BEGIN
-- ####################################################################################################
--*************  academico_turmadisciplina
   update aux set aux.disciplina_id = @novo
from academico_turmadisciplina aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                     dis.nome = @disciplina)
where disciplina_id = @antigo

--*************  curriculos_gradedisciplina
   update aux set aux.disciplina_id = @novo
from curriculos_gradedisciplina aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo

--*************  materiais_didaticos_publicacao
   update aux set aux.disciplina_id = @novo
from materiais_didaticos_publicacao aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo

--*************  historicos_historicodisciplina
   update aux set aux.disciplina_id = @novo
from historicos_historicodisciplina aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo

--*************  curriculos_solicitacaodiscinformada
   update aux set aux.disciplina_id = @novo
from curriculos_solicitacaodiscinformada aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo

--*************  academico_responsaveldisciplina
   update aux set aux.disciplina_id = @novo
from academico_responsaveldisciplina aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo

--*************  cronogramas_cronograma
   update aux set aux.disciplina_id = @novo
from cronogramas_cronograma aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo AND 
      NOT EXISTS (SELECT 1 FROM cronogramas_cronograma AUXX 
	                WHERE AUX.etapa_ano_id = AUXX.etapa_ano_id AND 
					      AUXX.disciplina_id = @novo)

  DELETE AUX
	from cronogramas_cronograma aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
    where disciplina_id = @antigo

--*************  curriculos_disciplinaconcluida
   update aux set aux.disciplina_id = @novo
from curriculos_disciplinaconcluida aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo

--*************  planos_ensino_planoensino
   update aux set aux.disciplina_id = @novo
from planos_ensino_planoensino aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo

--*************  curriculos_errofechamentodisciplina
   update aux set aux.disciplina_id = @novo
from curriculos_errofechamentodisciplina aux join academico_disciplina dis on (dis.id = aux.disciplina_id and 
                                                                      dis.nome = @disciplina)
where disciplina_id = @antigo

-- ******************  DELETAR DISCIPLINA DUPLICADA 
DELETE 
   FROM ACADEMICO_DISCIPLINA 
   WHERE ID = @ANTIGO
-- ####################################################################################################
			fetch next from CUR_ into @antigo, @disciplina, @novo
			END
	close CUR_ 
deallocate CUR_ 
	
/*  rollback 
SELECT TOP 10 * FROM academico_turmadisciplina
SELECT TOP 10 * FROM materiais_didaticos_publicacao --OK
SELECT TOP 10 * FROM historicos_historicodisciplina --OK
SELECT TOP 10 * FROM curriculos_gradedisciplina     --OK
SELECT TOP 10 * FROM historicos_historico             --OK
SELECT TOP 10 * FROM ofertas_disciplina_ofertadisciplina --?????????????????????
SELECT TOP 10 * FROM curriculos_solicitacaodiscinformada  -- VAZIA
SELECT TOP 10 * FROM academico_responsaveldisciplina --OK
SELECT TOP 10 * FROM cronogramas_cronograma   --OK
SELECT TOP 10 * FROM curriculos_disciplinaconcluida  --OK
SELECT TOP 10 * FROM planos_ensino_planoensino  --OK      TEM GRADEDISCIPLINA_ID MAS NAO E USADA
SELECT TOP 10 * FROM curriculos_errofechamentodisciplina  --OK

*/	