insert into relatorios_extratocorrecao (usuario_id, cpf, nome, perfil, enviados, enviados_primeira, enviados_segunda, 
                                        enviados_terceira, enviados_quarta, enviados_ouro, enviados_moda, enviados_auditoria, glosadas)
select usuario_id, cpf, nome, perfil, enviados, enviados_primeira, enviados_segunda, 
       enviados_terceira, enviados_quarta, enviados_ouro, enviados_moda, enviados_auditoria, glosadas
from vw_relatorios_extratocorrecao ext
where not exists (select 1 from relatorios_extratocorrecao extx 
                   where ext.cpf = extx.cpf and 
				         ext.usuario_id = extx.usuario_id)


insert into relatorios_extratocorrecaodiario (cpf, nome, perfil, enviados, enviados_primeira, enviados_segunda, enviados_terceira, enviados_quarta, 
                                              enviados_ouro, enviados_moda, enviados_auditoria, glosadas, usuario_id, data)
select cpf, nome, perfil, enviados, enviados_primeira, enviados_segunda, enviados_terceira, enviados_quarta, 
       enviados_ouro, enviados_moda, enviados_auditoria, glosadas, usuario_id, data
from vw_relatorios_extratocorrecaodiario ext
where not exists (select 1 
                  from relatorios_extratocorrecaodiario extx
				   where ext.cpf = extx.cpf and 
				         ext.usuario_id = extx.usuario_id and
						 ext.data       = extx.data)
