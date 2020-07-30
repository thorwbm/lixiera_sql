with cte_correcao as (
            select origem = 286 ,destino = 1012 union
            select origem = 305 ,destino = 1015 union
            select origem = 290 ,destino = 1019 union
            select origem = 248 ,destino = 1018 union
            select origem = 163 ,destino = 1013
) 

        --select 
           update dst set
               dst.carga_horaria         = ori.carga_horaria, 
               dst.ementa                = ori.ementa, 
             --  dst.curso_id            =   ori.curso_id,
             --  dst.disciplina_Id       =   ori.disciplina_Id, 
	           dst.matriz                = ori.matriz, 
	           dst.serie                 = ori.serie, 
	           dst.conteudo_programatico = ori.conteudo_programatico, 
	           dst.metodos_de_ensino     = ori.metodos_de_ensino,
	           dst.etapa_ano_id          = ori.etapa_ano_id, 
	           dst.curriculo_id          = ori.curriculo_id, 
	           dst.grade_disciplina_id   = ori.grade_disciplina_id 


          from cte_correcao cor join planos_ensino_planoensino dst on (dst.id = cor.destino)
                                join planos_ensino_planoensino ori on (ori.id = cor.origem)

--#########################################################################################
/*
DECLARE @DATAEXECUCAO DATETIME    
SET @DATAEXECUCAO = CAST( CONVERT(VARCHAR(19),GETDATE(),120) AS DATETIME)    

begin tran ;


with cte_correcao as (
            select origem = 286 ,destino = 1012 union
            select origem = 305 ,destino = 1015 union
            select origem = 290 ,destino = 1019 union
            select origem = 248 ,destino = 1018 union
            select origem = 163 ,destino = 1013
) 

insert into planos_ensino_planoensino_bibliografia (criado_em, atualizado_em, criado_por, atualizado_por, bibliografia_id, planoensino_id)
select distinct
       criado_em = @DATAEXECUCAO,atualizado_em = @DATAEXECUCAO, criado_por = 11717, atualizado_por = 11717, 
	   bibliografia_id, planoensino_id = cor.destino
  from planos_ensino_planoensino pla join planos_ensino_planoensino_bibliografia bib on (pla.id = bib.planoensino_id)
                                     join cte_correcao                           cor on (cor.origem = pla.id)
                                     
where pla.ano = 2019

 -- GERAR LOG    
 EXEC SP_GERAR_LOG_EM_LOTE_INSERT 'PLANOS_ENSINO_PLANOENSINO_BIBLIOGRAFIA', @DATAEXECUCAO  
    
	-- COMMIT
	-- ROLLBACK 

*/

--#########################################################################################
/*
select * 
  from 
       planos_ensino_planoensino ple join academico_disciplina dis on (dis.id = ple.disciplina_id)
 where 
       ano = 2019 and 
       --matriz   = 'CURSO OFERTA OPTATIVAS / GESTÃO DA QUALIDADE EM SAÚDE / 2020' and 
       dis.nome like  'SAÚDE E ACESSIBILIDADE: DESAFIOS CONTEMPORÂNEOS'

select * 
  from 
       planos_ensino_planoensino ple join academico_disciplina dis on (dis.id = ple.disciplina_id)
 where 
       ano = 2020 and 
     --  matriz   = 'CURSO OFERTA OPTATIVAS / INOVAÇÃO, TECNOLOGIA E EMPREENDEDORISMO EM SAÚDE / 2020' and 
       dis.nome = 'SAÚDE E ACESSIBILIDADE: DESAFIOS CONTEMPORÂNEOS' 


       select origem = 286 ,destino = 1012 union
       select origem = 305 ,destino = 1015 union
       select origem = 290 ,destino = 1019 union
       select origem = 248 ,destino = 1018 union
       select origem = 163 ,destino = 1013
*/