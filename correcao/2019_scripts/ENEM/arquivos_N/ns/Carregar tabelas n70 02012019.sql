

create   view vw_descartada_n70 as    
select  aud.co_barra_redacao,     
        cor.id_tipo_correcao,    
  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and     
                          isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and    
                          isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and    
                          isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and    
                          isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and    
                          isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and    
                          aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end    
  from correcoes_correcao aud with (nolock) join correcoes_correcao cor with (nolock) on (aud.co_barra_redacao = cor.co_barra_redacao and     
                                                                                          aud.id_tipo_correcao = 7 ) 

/*---------------------------------------------------------------------------------------------------*/
create or alter view VW_N70_AVALIACOES_REDACOES_DESCARTADAS as 
select distinct cor.id_tipo_correcao,  
PROJETO       = N02.CO_PROJETO,
INSCRICAO     = RED.co_inscricao,
UF            = N02.SG_UF_PROVA,
CPF           = PES.cpf, 
CORRECAO_TIPO = tpa.co_tipo_auditoria_n70,
DESCARTADA    = vw.descartada,
CORRECAO      = CASE WHEN cor.id_tipo_correcao IN (1,2) THEN 1 
                     WHEN cor.id_tipo_correcao = 3      THEN 3 
                     WHEN cor.id_tipo_correcao = 4      THEN 4 
                     WHEN cor.id_tipo_correcao = 7      THEN 5 ELSE 1000 END ,
SITUACAO	  = cor.id_correcao_situacao,
NOTA_FINAL	  = cor.nota_final,
NOTA_COMP1    = cor.NOTA_COMPETENCIA1,
NOTA_COMP2    = cor.NOTA_COMPETENCIA2,
NOTA_COMP3    = cor.NOTA_COMPETENCIA3,
NOTA_COMP4    = cor.NOTA_COMPETENCIA4,
NOTA_COMP5    = cor.NOTA_COMPETENCIA5, 
cor.co_barra_redacao, 
cor.id

  from correcoes_correcao cor with (nolock) join correcoes_correcao aud with (nolock) on (cor.co_barra_redacao = aud.co_barra_redacao and 
                                                                                          aud.id_tipo_correcao = 7)
								            JOIN CORRECOES_REDACAO       RED WITH (NOLOCK) ON (RED.co_barra_redacao = AUD.co_barra_redacao and 
											                                                   RED.cancelado = 0)
											JOIN inep_ppl..inep_N02  N02 WITH (NOLOCK) ON (N02.CO_INSCRICAO     = RED.co_inscricao)
										    JOIN usuarios_pessoa         PES WITH (NOLOCK) ON (PES.usuario_id       = AUD.id_corretor)
											join correcoes_tipoauditoria tpa with (nolock) on (tpa.id               = aud.tipo_auditoria_id)
											join vw_descartada_n70       vw  with (nolock) on (vw.co_barra_redacao  = cor.co_barra_redacao and 
											                                                   vw.id_tipo_correcao  = cor.id_tipo_correcao)




-------------------------------------------------------------------------------------------------------------------------
-- VALIDACAO
-------------------------------------------------------------------------------------------------------------------------
/*parte desconectada qeu gerou 4 e auditoria*/
select aud.co_barra_redacao  
from correcoes_correcao aud with (nolock) join correcoes_correcao cor4 with (nolock) on (aud.co_barra_redacao  = cor4.co_barra_redacao and 
                                                                                         aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 
										  join correcoes_correcao cor3 with (nolock) on (cor3.co_barra_redacao = aud.co_barra_redacao and cor3.id_tipo_correcao = 3) 
where cor3.id_correcao_situacao = 9

/* correcoes 1 e 2 que tenham nota mil e que tenham gerado 4 correcao*/
select * 
from correcoes_correcao aud with (nolock) join correcoes_correcao cor4 with (nolock) on (aud.co_barra_redacao  = cor4.co_barra_redacao and 
                                                                                         aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 
										  
where exists (select top 1 1 from correcoes_correcao cor1 with (nolock) join correcoes_correcao cor2 on (cor1.co_barra_redacao = cor2.co_barra_redacao and 
                                                                                                         cor1.id_tipo_correcao = 1 and 
																										 cor2.id_tipo_correcao = 2)
			   where cor1.nota_final = 1000 and cor2.nota_final = 1000 and 
			         cor1.co_barra_redacao = aud.co_barra_redacao)

					 
/* correcoes 1 e 2 que tenham nota mil e que tenham gerado 3 correcao*/
select * 
from correcoes_correcao aud with (nolock) join correcoes_correcao cor3 with (nolock) on (aud.co_barra_redacao  = cor3.co_barra_redacao and 
                                                                                         aud.id_tipo_correcao  = 7 and cor3.id_tipo_correcao = 3) 
										  
where exists (select top 1 1 from correcoes_correcao cor1 with (nolock) join correcoes_correcao cor2 on (cor1.co_barra_redacao = cor2.co_barra_redacao and 
                                                                                                         cor1.id_tipo_correcao = 1 and 
																										 cor2.id_tipo_correcao = 2)
			   where cor1.nota_final = 1000 and cor2.nota_final = 1000 and 
			         cor1.co_barra_redacao = aud.co_barra_redacao)

					 
/* correcoes 1 e 3 ou 2 e 3 que tenham nota mil e que tenham gerado 4 correcao*/
select * 
from correcoes_correcao aud with (nolock) join correcoes_correcao cor4 with (nolock) on (aud.co_barra_redacao  = cor4.co_barra_redacao and 
                                                                                         aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 
										  
where exists (select top 1 1 from correcoes_correcao cor1 with (nolock) join correcoes_correcao cor3 on (cor1.co_barra_redacao = cor3.co_barra_redacao and 
                                                                                                         cor1.id_tipo_correcao = 1 and 
																										 cor3.id_tipo_correcao = 3)
			   where cor1.nota_final = 1000 and cor3.nota_final = 1000 and 
			         cor1.co_barra_redacao = aud.co_barra_redacao) OR 
	 exists (select top 1 1 from correcoes_correcao cor2 with (nolock) join correcoes_correcao cor3 on (cor2.co_barra_redacao = cor3.co_barra_redacao and 
                                                                                                         cor2.id_tipo_correcao = 2 and 
																										 cor3.id_tipo_correcao = 3)
			   where cor2.nota_final = 1000 and cor3.nota_final = 1000 and 
			         cor2.co_barra_redacao = aud.co_barra_redacao)


/*DDH 1 e 2 qeu gerou 4 e auditoria*/

SELECT * FROM correcoes_correcao COR WITH (NOLOCK) JOIN correcoes_correcao AUD WITH (NOLOCK) ON (COR.co_barra_redacao = AUD.CO_BARRA_REDACAO AND 
                                                                                                 AUD.id_tipo_correcao = 7)
WHERE COR.competencia5 = -1 AND 
      COR.id_tipo_correcao IN (1,2) AND 
	   EXISTS (SELECT TOP 1 1 FROM correcoes_correcao CORX WHERE CORX.co_barra_redacao = COR.co_barra_redacao AND CORX.id_tipo_correcao IN (3,4))

/*DDH 3 qeu gerou 4 e auditoria*/
SELECT COR.co_barra_redacao FROM correcoes_correcao COR WITH (NOLOCK) JOIN correcoes_correcao AUD WITH (NOLOCK) ON (COR.co_barra_redacao = AUD.CO_BARRA_REDACAO AND 
                                                                                                 AUD.id_tipo_correcao = 7)
WHERE COR.competencia5 = -1 AND 
      COR.id_tipo_correcao IN (1,2,3) AND 
	   EXISTS (SELECT TOP 1 1 FROM correcoes_correcao CORX WHERE CORX.co_barra_redacao = COR.co_barra_redacao AND CORX.id_tipo_correcao IN (4))



-------------------------------------------------------------------------------------------------------------------------
-- ENTREGA 
-------------------------------------------------------------------------------------------------------------------------
/*registros normais */
               --select * from Entregas.entregas_regular.dbo.N70_08012019_001
-- drop table  N70_098012019_001
SELECT  PROJETO, INSCRICAO, UF, CPF, CORRECAO_TIPO, DESCARTADA, CORRECAO, SITUACAO, vw.NOTA_FINAL, NOTA_COMP1, NOTA_COMP2, NOTA_COMP3, NOTA_COMP4, NOTA_COMP5
             INTO N70_PPL_09012019_001 
FROM VW_N70_AVALIACOES_REDACOES_DESCARTADAS vw join correcoes_redacao cor on (vw.INSCRICAO = cor.co_inscricao and cor.cancelado = 0)

/* PD */
where vw.id not in (
       select distinct cor4.id
                                 from correcoes_correcao aud with (nolock) join correcoes_redacao  red  with (nolock) on (aud.co_barra_redacao = aud.co_barra_redacao)
								                                           join correcoes_correcao cor4 with (nolock) on (aud.co_barra_redacao  = cor4.co_barra_redacao and 
                                                                                         aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 
										  join correcoes_correcao cor3 with (nolock) on (cor3.co_barra_redacao = aud.co_barra_redacao and cor3.id_tipo_correcao = 3) 
                                where cor3.id_correcao_situacao = 9)  and
      /* DDH */
      vw.id not in (select id from correcoes_correcao cor4 where co_barra_redacao in (
	                  SELECT COR.co_barra_redacao FROM correcoes_correcao COR WITH (NOLOCK) JOIN correcoes_correcao AUD WITH (NOLOCK) ON (COR.co_barra_redacao = AUD.CO_BARRA_REDACAO AND 
                                                                                                 AUD.id_tipo_correcao = 7)
                               WHERE COR.competencia5 = -1 AND 
                                     COR.id_tipo_correcao IN (1,2,3) AND 
                               	   EXISTS (SELECT TOP 1 1 FROM correcoes_correcao CORX WHERE CORX.co_barra_redacao = COR.co_barra_redacao AND CORX.id_tipo_correcao IN (4))) 
					 and id_tipo_correcao = 4)


------------------------------------------------------------------------------------------------------------------------------------------------------------
/*registros que existem 4 correcao desnecessaria PD ou DDH */
------------------------------------------------------------------------------------------------------------------------------------------------------------
-- drop table entregas_regular.dbo.N70_02012019_002
SELECT DISTINCT PROJETO, INSCRICAO, UF, CPF, CORRECAO_TIPO, DESCARTADA, CORRECAO, SITUACAO, NOTA_FINAL, NOTA_COMP1, NOTA_COMP2, NOTA_COMP3, NOTA_COMP4, NOTA_COMP5
        --   INTO entregas.entregas_regular.dbo.N70_02012019_002 
FROM VW_N70_AVALIACOES_REDACOES_DESCARTADAS 
/* PD */
where id  in (
       select distinct cor4.id
                                 from correcoes_correcao aud with (nolock) join correcoes_redacao  red  with (nolock) on (aud.co_barra_redacao = aud.co_barra_redacao)
								                                           join correcoes_correcao cor4 with (nolock) on (aud.co_barra_redacao  = cor4.co_barra_redacao and 
                                                                                         aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 
										  join correcoes_correcao cor3 with (nolock) on (cor3.co_barra_redacao = aud.co_barra_redacao and cor3.id_tipo_correcao = 3) 
                                where cor3.id_correcao_situacao = 9)  or
      /* DDH */
      id  in (select id from correcoes_correcao cor4 where co_barra_redacao in (
	                  SELECT COR.co_barra_redacao FROM correcoes_correcao COR WITH (NOLOCK) JOIN correcoes_correcao AUD WITH (NOLOCK) ON (COR.co_barra_redacao = AUD.CO_BARRA_REDACAO AND 
                                                                                                 AUD.id_tipo_correcao = 7)
                               WHERE COR.competencia5 = -1 AND 
                                     COR.id_tipo_correcao IN (1,2,3) AND 
                               	   EXISTS (SELECT TOP 1 1 FROM correcoes_correcao CORX WHERE CORX.co_barra_redacao = COR.co_barra_redacao AND CORX.id_tipo_correcao IN (4))) 
					 and id_tipo_correcao = 4)
				

			