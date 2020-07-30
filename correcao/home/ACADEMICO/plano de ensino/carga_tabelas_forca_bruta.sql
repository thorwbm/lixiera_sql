/********************************************************************************************** 
criar as tabelas temporarias na base de homologacao exportar todas e importar na producao
depios rodar o script de carga
-----------------------------------------------------------------------------------------------
drop table tmpimp_planoensino 
drop table TMPIMP_BIBLIOGRAFIA
drop table TMPIMP_COMPETENCIA 
drop table tmpimp_ple_bibiliografia
drop table tmpimp_ple_competencia
drop table tmpimp_sugestaobibliografia
drop table tmpimp_sugestaocopetencia

select * into tmpimp_planoensino       from erp_hmg..planos_ensino_planoensino where ano = 2020                                        
select * INTO TMPIMP_BIBLIOGRAFIA      from erp_hmg..bibliografias_bibliografia
select * INTO TMPIMP_COMPETENCIA       from erp_hmg..competencias_competencia

select * into tmpimp_ple_bibiliografia from erp_hmg..planos_ensino_planoensino_bibliografia
where planoensino_id in (select id from erp_hmg..planos_ensino_planoensino where ano = 2020)

select * into tmpimp_ple_competencia  from planos_ensino_planoensino_competencia
where planoensino_id in (select id from erp_hmg..planos_ensino_planoensino where ano = 2020)

select * into tmpimp_sugestaobibliografia from planos_ensino_sugestaobibliografia
where planoensino_id in (select id from erp_hmg..planos_ensino_planoensino where ano = 2020)

select * into tmpimp_sugestaocopetencia from planos_ensino_sugestaocompetencia
where planoensino_id in (select id from erp_hmg..planos_ensino_planoensino where ano = 2020)
*******************************************************************************************/

-- SCRIPT DE CARGA

--select * from planos_ensino_planoensino where ano = 2020
------------------------------------------------------------------------------
SET IDENTITY_INSERT planos_ensino_planoensino ON  --Desabilita o IDENTITY

insert into planos_ensino_planoensino (id, criado_em, atualizado_em, carga_horaria, ementa, curso_id, criado_por, disciplina_id, 
                                       atualizado_por, matriz, serie, ano, praticas_extensionistas, conteudo_programatico, 
                                       metodos_de_ensino, aprovado_em, aprovado_por, status_id, etapa_ano_id, curriculo_id, 
                                       replicado_em, permite_replicacao_criterio, grade_disciplina_id, alterar_competencias_gerais, 
                                       alterar_competencias_especificas, agrupar_competencias)
select pla.id, criado_em = getdate(), atualizado_em = getdate(), pla.carga_horaria, pla.ementa, pla.curso_id, pla.criado_por, pla.disciplina_id, 
       pla.atualizado_por, pla.matriz, pla.serie, pla.ano, pla.praticas_extensionistas, pla.conteudo_programatico, 
       pla.metodos_de_ensino, pla.aprovado_em, pla.aprovado_por, pla.status_id, pla.etapa_ano_id, pla.curriculo_id, 
       pla.replicado_em, pla.permite_replicacao_criterio, pla.grade_disciplina_id, pla.alterar_competencias_gerais, 
       pla.alterar_competencias_especificas, pla.agrupar_competencias
  from tmpimp_planoensino pla left join planos_ensino_planoensino xxx on (xxx.id = pla.id)
 where xxx.id is null 

SET IDENTITY_INSERT planos_ensino_planoensino OFF  --Habilita o IDENTITY
--###########################################################################


-- select * from bibliografias_bibliografia
------------------------------------------------------------------------------
SET IDENTITY_INSERT bibliografias_bibliografia ON  --Desabilita o IDENTITY

insert into bibliografias_bibliografia (id, criado_em, atualizado_em, descricao, categoria_id, criado_por, atualizado_por)
select blb.id, criado_em = getdate(), atualizado_em = getdate(), blb.descricao, blb.categoria_id, blb.criado_por, blb.atualizado_por 
  from TMPIMP_BIBLIOGRAFIA blb left join bibliografias_bibliografia xxx on (blb.id = xxx.id)
 where xxx.id is null 

SET IDENTITY_INSERT bibliografias_bibliografia OFF  --Habilita o IDENTITY
--###########################################################################


-- select * from competencias_competencia
------------------------------------------------------------------------------
SET IDENTITY_INSERT competencias_competencia ON  --Desabilita o IDENTITY

insert into competencias_competencia (id, criado_em, atualizado_em, descricao, category_id, criado_por, objective_id, atualizado_por, curso_id)
select com.id, criado_em = getdate(), atualizado_em = getdate(), com.descricao, com.category_id, com.criado_por, com.objective_id, com.atualizado_por, com.curso_id 
  from TMPIMP_COMPETENCIA com left join competencias_competencia xxx on (xxx.id = com.id)
 where xxx.id is null 

SET IDENTITY_INSERT competencias_competencia OFF  --Habilita o IDENTITY
--###########################################################################


-- select * from planos_ensino_planoensino_bibliografia
------------------------------------------------------------------------------
SET IDENTITY_INSERT planos_ensino_planoensino_bibliografia ON  --Desabilita o IDENTITY

insert into planos_ensino_planoensino_bibliografia (id, criado_em, atualizado_em, bibliografia_id, criado_por, planoensino_id, atualizado_por)
select bib.id, criado_em = getdate(), atualizado_em = getdate(), bib.bibliografia_id, bib.criado_por, bib.planoensino_id, bib.atualizado_por
from tmpimp_ple_bibiliografia bib left join planos_ensino_planoensino_bibliografia xxx on (xxx.id = bib.id)
where xxx.id is null 

SET IDENTITY_INSERT planos_ensino_planoensino_bibliografia OFF  --Habilita o IDENTITY
--###########################################################################


-- select * from planos_ensino_planoensino_competencia
------------------------------------------------------------------------------
SET IDENTITY_INSERT planos_ensino_planoensino_competencia ON  --Desabilita o IDENTITY

insert into planos_ensino_planoensino_competencia (id, criado_em, atualizado_em, competencia_id, criado_por, planoensino_id, atualizado_por)
select com.id, criado_em = getdate(), atualizado_em = getdate(), com.competencia_id, com.criado_por, com.planoensino_id, com.atualizado_por
from tmpimp_ple_competencia com left join planos_ensino_planoensino_competencia xxx on (xxx.id = com.id)
where xxx.id is null 

SET IDENTITY_INSERT planos_ensino_planoensino_competencia OFF  --Habilita o IDENTITY
--###########################################################################


-- select * from planos_ensino_sugestaobibliografia
------------------------------------------------------------------------------
SET IDENTITY_INSERT planos_ensino_sugestaobibliografia ON  --Desabilita o IDENTITY

insert into planos_ensino_sugestaobibliografia (id, criado_em, atualizado_em, descricao, aprovado, analisada_em, 
                                            analisada_por, criado_por, substituir, planoensino_id, atualizado_por)
select bib.id, criado_em = getdate(), atualizado_em = getdate(), bib.descricao, bib.aprovado, bib.analisada_em, 
       bib.analisada_por, bib.criado_por, bib.substituir, bib.planoensino_id, bib.atualizado_por 
  from tmpimp_sugestaobibliografia bib left join planos_ensino_sugestaobibliografia xxx on (xxx.id = bib.id)
  where xxx.id is null 

SET IDENTITY_INSERT planos_ensino_sugestaobibliografia OFF  --Habilita o IDENTITY
--###########################################################################


-- select * from planos_ensino_sugestaocompetencia
------------------------------------------------------------------------------
SET IDENTITY_INSERT planos_ensino_sugestaocompetencia ON  --Desabilita o IDENTITY

insert into planos_ensino_sugestaocompetencia (id, criado_em, atualizado_em, descricao, aprovado, analisada_em, analisada_por, 
                                               criado_por, planoensino_id, atualizado_por, categoria_id, objetivo_id)
select com.id, criado_em = getdate(), atualizado_em = getdate(), com.descricao, com.aprovado, com.analisada_em, com.analisada_por, 
       com.criado_por, com.planoensino_id, com.atualizado_por, com.categoria_id, com.objetivo_id
  from tmpimp_sugestaocopetencia com left join planos_ensino_sugestaocompetencia xxx on (xxx.id = com.id)
 where xxx.id is null 

SET IDENTITY_INSERT planos_ensino_sugestaocompetencia OFF  --Habilita o IDENTITY
--###########################################################################






