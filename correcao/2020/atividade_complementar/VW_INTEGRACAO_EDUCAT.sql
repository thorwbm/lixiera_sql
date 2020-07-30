create view VW_INTEGRACAO_EDUCAT as
SELECT distinct 
       CPFALUNO        = USU.CPF_USU,  
       CODPARTICIPACAO = PAR.COD_PAR, 
       HORCOMPUTADA    = CAST(PAR.HOR_CON AS float), 
       DATACERTIFICADO = PAR.DAT_CER,
       OBSERVACAO      = ISNULL(PAR.DES_PAR,' - * - ') ,
       FUNCAO          = ' ' + UPPER(DES_FUN),
       CURSO_NOME      = CUR.DES_CUR,
       CATEGORIA       = cat.des_cat

  FROM PARTICIPACAO PAR with(nolock) JOIN ATIVIDADE  ATI with(nolock) ON (PAR.COD_ATI = ATI.COD_ATI)
                                     JOIN FUNCAO     FUN with(nolock) ON (FUN.COD_FUN = ATI.COD_FUN)
                                     JOIN CATEGORIA  CAT with(nolock) ON (CAT.COD_CAT = ATI.COD_CAT)
                                     JOIN GRUPO      GRU with(nolock) ON (GRU.COD_GRU = CAT.COD_GRU)
                                     JOIN USUARIO    USU with(nolock) ON (USU.COD_USU = PAR.COD_USU)
                                LEFT JOIN CURSO      CUR with(nolock) ON (CUR.COD_CUR = USU.COD_CUR)
  WHERE des_sta IN ('DEFERIDO') AND  PAR.FLG_EXP = 1 --and USU.cod_usu = 8385
