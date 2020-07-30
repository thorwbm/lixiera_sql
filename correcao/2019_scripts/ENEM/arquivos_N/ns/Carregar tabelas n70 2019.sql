
create OR ALTER  view vw_descartada_n70 as    
select  aud.redacao_id,     
        cor.id_tipo_correcao,    
  descartada = case when (isnull(aud.nota_final  ,0) = isnull(cor.nota_final  ,0) and     
                          isnull(aud.competencia1,0) = isnull(cor.competencia1,0) and    
                          isnull(aud.competencia2,0) = isnull(cor.competencia2,0) and    
                          isnull(aud.competencia3,0) = isnull(cor.competencia3,0) and    
                          isnull(aud.competencia4,0) = isnull(cor.competencia4,0) and    
                          isnull(aud.competencia5,0) = isnull(cor.competencia5,0) and    
                          aud.id_correcao_situacao = cor.id_correcao_situacao) then 0 else 1 end    
  from correcoes_correcao aud join correcoes_correcao cor on (aud.redacao_id = cor.redacao_id and     
                                                              aud.id_tipo_correcao = 7 ) 

/*---------------------------------------------------------------------------------------------------*/
create or alter view VW_N70_AVALIACOES_REDACOES_DESCARTADAS as 
select distinct cor.id_tipo_correcao,  
CO_PROJETO            = N02.CO_PROJETO,
CO_INSCRICAO          = RED.co_inscricao,
SIGLA_UF              = N02.SG_UF_PROVA,
NU_CPF                = PES.cpf, 
TP_TIPO_CORRECAO      = tpa.co_tipo_auditoria_n70,
IN_DESCARTADA         = vw.descartada,
NU_CORRECAO           = CASE WHEN cor.id_tipo_correcao IN (1,2) THEN 1 
                          WHEN cor.id_tipo_correcao = 3      THEN 3 
                          WHEN cor.id_tipo_correcao = 4      THEN 4 
                          WHEN cor.id_tipo_correcao = 7      THEN 5 ELSE 1000 END ,
CO_SITUACAO_REDACAO   = cor.id_correcao_situacao,
NU_NOTA_REDACAO	      = cor.nota_final,
NU_NOTA_COMP1_REDACAO = cor.NOTA_COMPETENCIA1,
NU_NOTA_COMP2_REDACAO = cor.NOTA_COMPETENCIA2,
NU_NOTA_COMP3_REDACAO = cor.NOTA_COMPETENCIA3,
NU_NOTA_COMP4_REDACAO = cor.NOTA_COMPETENCIA4,
NU_NOTA_COMP5_REDACAO = cor.NOTA_COMPETENCIA5, 
cor.redacao_id, 
cor.id

  from correcoes_correcao cor join correcoes_correcao      aud on (cor.redacao_id = aud.redacao_id and 
                                                                           aud.id_tipo_correcao = 7)
							  JOIN CORRECOES_REDACAO       RED  ON (RED.ID = AUD.redacao_id and 
							                                      RED.cancelado = 0)
							  JOIN inep_N02                N02  ON (N02.CO_INSCRICAO     = RED.co_inscricao)
							  JOIN usuarios_pessoa         PES  ON (PES.usuario_id       = AUD.id_corretor)
							  join correcoes_tipoauditoria tpa  on (tpa.id               = aud.tipo_auditoria_id)
							  join vw_descartada_n70       vw   on (vw.redacao_id  = cor.redacao_id and 
							                                                   vw.id_tipo_correcao  = cor.id_tipo_correcao)




-------------------------------------------------------------------------------------------------------------------------
-- VALIDACAO
-------------------------------------------------------------------------------------------------------------------------
/*parte desconectada qeu gerou 4 e auditoria*/
select COUNT(1)  
from correcoes_correcao aud join correcoes_correcao cor4 on (aud.redacao_id  = cor4.redacao_id and 
                                                             aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 
				            join correcoes_correcao cor3 on (cor3.redacao_id = aud.redacao_id and cor3.id_tipo_correcao = 3) 
where cor3.id_correcao_situacao = 9

/* correcoes 1 e 2 que tenham nota mil e que tenham gerado 4 correcao*/
select COUNT(1) 
from correcoes_correcao aud join correcoes_correcao cor4 on (aud.redacao_id  = cor4.redacao_id and 
                                                             aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 								  
where exists (select top 1 1 from correcoes_correcao cor1 join correcoes_correcao cor2 on (cor1.redacao_id = cor2.redacao_id and 
                                                                                           cor1.id_tipo_correcao = 1 and 
																						   cor2.id_tipo_correcao = 2)
			   where cor1.nota_final = 1000 and cor2.nota_final = 1000 and 
			         cor1.redacao_id = aud.redacao_id)

					 
/* correcoes 1 e 2 que tenham nota mil e que tenham gerado 3 correcao*/
select COUNT(1) 
  from correcoes_correcao aud join correcoes_correcao cor3 on (aud.redacao_id  = cor3.redacao_id and 
                                                               aud.id_tipo_correcao  = 7 and cor3.id_tipo_correcao = 3) 										  
where exists (select top 1 1 from correcoes_correcao cor1 join correcoes_correcao cor2 on (cor1.redacao_id = cor2.redacao_id and 
                                                                                           cor1.id_tipo_correcao = 1 and 
																						   cor2.id_tipo_correcao = 2)
			   where cor1.nota_final = 1000 and cor2.nota_final = 1000 and 
			         cor1.redacao_id = aud.redacao_id)

					 
/* correcoes 1 e 3 ou 2 e 3 que tenham nota mil e que tenham gerado 4 correcao*/
select COUNT(1)
  from correcoes_correcao aud join correcoes_correcao cor4 on (aud.redacao_id = cor4.redacao_id and 
                                                               aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 										  
where exists (select top 1 1 from correcoes_correcao cor1 join correcoes_correcao cor3 on (cor1.redacao_id = cor3.redacao_id and 
                                                                                           cor1.id_tipo_correcao = 1 and 
																						   cor3.id_tipo_correcao = 3)
			   where cor1.nota_final = 1000 and cor3.nota_final = 1000 and 
			         cor1.redacao_id = aud.redacao_id) OR 
	 exists (select top 1 1 from correcoes_correcao cor2 join correcoes_correcao cor3 on (cor2.redacao_id = cor3.redacao_id and 
                                                                                          cor2.id_tipo_correcao = 2 and 
																						  cor3.id_tipo_correcao = 3)
			   where cor2.nota_final = 1000 and cor3.nota_final = 1000 and 
			         cor2.redacao_id = aud.redacao_id)


/*DDH 1 e 2 qeu gerou 4 e auditoria*/

SELECT COUNT(1)  
  FROM correcoes_correcao COR JOIN correcoes_correcao AUD ON (COR.redacao_id = AUD.redacao_id AND 
                                                              AUD.id_tipo_correcao = 7)
WHERE COR.competencia5 = -1 AND 
      COR.id_tipo_correcao IN (1,2) AND 
	   EXISTS (SELECT TOP 1 1 FROM correcoes_correcao CORX
	            WHERE CORX.redacao_id = COR.redacao_id AND CORX.id_tipo_correcao IN (3,4))

/*DDH 3 qeu gerou 4 e auditoria*/
SELECT  COUNT(1)  
  FROM correcoes_correcao COR JOIN correcoes_correcao AUD ON (COR.redacao_id = AUD.redacao_id AND 
                                                              AUD.id_tipo_correcao = 7)
WHERE COR.competencia5 = -1 AND 
      COR.id_tipo_correcao IN (1,2,3) AND 
	   EXISTS (SELECT TOP 1 1 FROM correcoes_correcao CORX WHERE CORX.redacao_id = COR.redacao_id AND CORX.id_tipo_correcao IN (4))



-------------------------------------------------------------------------------------------------------------------------
-- ENTREGA 
-------------------------------------------------------------------------------------------------------------------------
/*registros normais */
               --select * from Entregas.entregas_regular.dbo.N70_08012019_001
-- drop table  N70_098012019_001
SELECT  PROJETO, INSCRICAO, UF, CPF, CORRECAO_TIPO, DESCARTADA, CORRECAO, SITUACAO, 
        vw.NOTA_FINAL, NOTA_COMP1, NOTA_COMP2, NOTA_COMP3, NOTA_COMP4, NOTA_COMP5
             INTO N70_PPL_09012019_001 
FROM VW_N70_AVALIACOES_REDACOES_DESCARTADAS vw join correcoes_redacao cor on (vw.INSCRICAO = cor.co_inscricao and cor.cancelado = 0)

/* PD */
where vw.id not in (
       select distinct cor4.id
                                 from correcoes_correcao aud join correcoes_redacao  red  on (aud.redacao_id = aud.redacao_id)
								                                           join correcoes_correcao cor4 on (aud.redacao_id  = cor4.redacao_id and 
                                                                                         aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 
										  join correcoes_correcao cor3 on (cor3.redacao_id = aud.redacao_id and cor3.id_tipo_correcao = 3) 
                                where cor3.id_correcao_situacao = 9)  and
      /* DDH */
      vw.id not in (select id from correcoes_correcao cor4 where redacao_id in (
	                  SELECT COR.redacao_id FROM correcoes_correcao COR JOIN correcoes_correcao AUD ON (COR.redacao_id = AUD.redacao_id AND 
                                                                                                 AUD.id_tipo_correcao = 7)
                               WHERE COR.competencia5 = -1 AND 
                                     COR.id_tipo_correcao IN (1,2,3) AND 
                               	   EXISTS (SELECT TOP 1 1 FROM correcoes_correcao CORX WHERE CORX.redacao_id = COR.redacao_id AND CORX.id_tipo_correcao IN (4))) 
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
                                 from correcoes_correcao aud join correcoes_redacao  red  on (aud.redacao_id = aud.redacao_id)
								                                           join correcoes_correcao cor4 on (aud.redacao_id  = cor4.redacao_id and 
                                                                                         aud.id_tipo_correcao  = 7 and cor4.id_tipo_correcao = 4) 
										  join correcoes_correcao cor3 on (cor3.redacao_id = aud.redacao_id and cor3.id_tipo_correcao = 3) 
                                where cor3.id_correcao_situacao = 9)  or
      /* DDH */
      id  in (select id from correcoes_correcao cor4 where redacao_id in (
	                  SELECT COR.redacao_id FROM correcoes_correcao COR JOIN correcoes_correcao AUD ON (COR.redacao_id = AUD.redacao_id AND 
                                                                                                 AUD.id_tipo_correcao = 7)
                               WHERE COR.competencia5 = -1 AND 
                                     COR.id_tipo_correcao IN (1,2,3) AND 
                               	   EXISTS (SELECT TOP 1 1 FROM correcoes_correcao CORX WHERE CORX.redacao_id = COR.redacao_id AND CORX.id_tipo_correcao IN (4))) 
					 and id_tipo_correcao = 4)
				

			