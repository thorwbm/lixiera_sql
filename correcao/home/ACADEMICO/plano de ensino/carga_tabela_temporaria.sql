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