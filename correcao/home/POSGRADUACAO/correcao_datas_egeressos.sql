WITH CTE_DATACONCLUSAO AS (
            SELECT EGR.ID, --EGR.dataconclusao,
                   new_dataconclusao = CASE WHEN EGR.dataconclusao LIKE '%/%' THEN  CAST (RIGHT(EGR.dataconclusao,4) + '-' +RIGHT(LEFT(EGR.DATACONCLUSAO,5),2) + '-' + LEFT(EGR.DATACONCLUSAO,2) AS DATE)
                                            ELSE CAST(EGR.dataconclusao AS DATE) END 
            FROM egressos EGR WHERE
            EGR.dataconclusao IS NOT NULL  AND
            EGR.dataconclusao <> ''
),
---------------------------------------------------------------------------------
    CTE_DATACOLACAOGRAU AS (
            SELECT EGR.ID, --EGR.DATACOLACAOGRAU,
                   NEW_DATACOLACAOGRAU = CASE WHEN EGR.DATACOLACAOGRAU LIKE '%/%' THEN  CAST (RIGHT(EGR.DATACOLACAOGRAU,4) + '-' +RIGHT(LEFT(EGR.DATACOLACAOGRAU,5),2) + '-' + LEFT(EGR.DATACOLACAOGRAU,2) AS DATE)
                                            ELSE CAST(EGR.DATACOLACAOGRAU AS DATE) END 
            FROM egressos EGR WHERE
            EGR.DATACOLACAOGRAU IS NOT NULL  AND
            EGR.DATACOLACAOGRAU <> ''
),
---------------------------------------------------------------------------------
    CTE_DATAEXPEDICAODIPLOMA AS (
            SELECT EGR.ID, --EGR.DATAEXPEDICAODIPLOMA,
                   NEW_DATAEXPEDICAODIPLOMA = CASE WHEN EGR.DATAEXPEDICAODIPLOMA LIKE '%/%' THEN  CAST (RIGHT(EGR.DATAEXPEDICAODIPLOMA,4) + '-' +RIGHT(LEFT(EGR.DATAEXPEDICAODIPLOMA,5),2) + '-' + LEFT(EGR.DATAEXPEDICAODIPLOMA,2) AS DATE)
                                            ELSE CAST(EGR.DATAEXPEDICAODIPLOMA AS DATE) END 
            FROM egressos EGR WHERE
            EGR.DATAEXPEDICAODIPLOMA IS NOT NULL  AND
            EGR.DATAEXPEDICAODIPLOMA <> ''
),
---------------------------------------------------------------------------------
    CTE_DATAREGISTRODIPLOMA AS (
            SELECT EGR.ID, --EGR.DATAREGISTRODIPLOMA,
                   NEW_DATAREGISTRODIPLOMA = CASE WHEN EGR.DATAREGISTRODIPLOMA LIKE '%/%' THEN  CAST (RIGHT(EGR.DATAREGISTRODIPLOMA,4) + '-' +RIGHT(LEFT(EGR.DATAREGISTRODIPLOMA,5),2) + '-' + LEFT(EGR.DATAREGISTRODIPLOMA,2) AS DATE)
                                            ELSE CAST(EGR.DATAREGISTRODIPLOMA AS DATE) END 
            FROM egressos EGR WHERE
            EGR.DATAREGISTRODIPLOMA IS NOT NULL  AND
            EGR.DATAREGISTRODIPLOMA <> ''
),
---------------------------------------------------------------------------------
    CTE_DATADIARIOOFICIALUNIAO AS (
            SELECT EGR.ID, --EGR.DATADIARIOOFICIALUNIAO,
                   NEW_DATADIARIOOFICIALUNIAO = CASE WHEN EGR.DATADIARIOOFICIALUNIAO LIKE '%/%' THEN  CAST (RIGHT(EGR.DATADIARIOOFICIALUNIAO,4) + '-' +RIGHT(LEFT(EGR.DATADIARIOOFICIALUNIAO,5),2) + '-' + LEFT(EGR.DATADIARIOOFICIALUNIAO,2) AS DATE)
                                            ELSE CAST(EGR.DATADIARIOOFICIALUNIAO AS DATE) END 
            FROM egressos EGR WHERE
            EGR.DATADIARIOOFICIALUNIAO IS NOT NULL  AND
            EGR.DATADIARIOOFICIALUNIAO <> ''
) 




-- SELECT TOP 10 
--         EGR.ID,
--         EGR.DATACONCLUSAO                ,EGR.NEW_DATACONCLUSAO                ,CON.NEW_DATACONCLUSAO,
--         EGR.DATACOLACAOGRAU              ,EGR.NEW_DATACOLACAOGRAU              ,COL.NEW_DATACOLACAOGRAU,
--         EGR.DATAEXPEDICAODIPLOMA         ,EGR.NEW_DATAEXPEDICAODIPLOMA         ,ESP.NEW_DATAEXPEDICAODIPLOMA,
--         EGR.DATAREGISTRODIPLOMA          ,EGR.NEW_DATAREGISTRODIPLOMA          ,REG.NEW_DATAREGISTRODIPLOMA,
--         EGR.DATADIARIOOFICIALUNIAO       ,EGR.NEW_DATADIARIOOFICIALUNIAO       ,DIA.NEW_DATADIARIOOFICIALUNIAO
-- 

UPDATE EGR SET 
       EGR.NEW_DATACONCLUSAO                = CON.NEW_DATACONCLUSAO,
       EGR.NEW_DATACOLACAOGRAU              = COL.NEW_DATACOLACAOGRAU,
       EGR.NEW_DATAEXPEDICAODIPLOMA         = ESP.NEW_DATAEXPEDICAODIPLOMA,
       EGR.NEW_DATAREGISTRODIPLOMA          = REG.NEW_DATAREGISTRODIPLOMA,
       EGR.NEW_DATADIARIOOFICIALUNIAO       = DIA.NEW_DATADIARIOOFICIALUNIAO
       
  FROM egressos EGR LEFT JOIN CTE_DATACONCLUSAO          CON ON (EGR.ID = CON.ID)
                    LEFT JOIN CTE_DATACOLACAOGRAU        COL ON (EGR.ID = COL.ID)
                    LEFT JOIN CTE_DATAEXPEDICAODIPLOMA   ESP ON (EGR.ID = ESP.ID)
                    LEFT JOIN CTE_DATAREGISTRODIPLOMA    REG ON (EGR.ID = REG.ID)
                    LEFT JOIN CTE_DATADIARIOOFICIALUNIAO DIA ON (EGR.ID = DIA.ID)


    SELECT * FROM EGRESSOS EGR
    WHERE 
      (LEN(EGR.DATACONCLUSAO         )> 3 AND  (EGR.NEW_DATACONCLUSAO           IS NOT NULL)) OR 
      (LEN(EGR.DATACOLACAOGRAU       )> 3 AND  (EGR.NEW_DATACOLACAOGRAU         IS NULL)) OR 
      (LEN(EGR.DATAEXPEDICAODIPLOMA  )> 3 AND  (EGR.NEW_DATAEXPEDICAODIPLOMA    IS NULL)) OR 
      (LEN(EGR.DATAREGISTRODIPLOMA   )> 3 AND  (EGR.NEW_DATAREGISTRODIPLOMA     IS NULL)) OR 
      (LEN(EGR.DATADIARIOOFICIALUNIAO)> 3 AND  (EGR.NEW_DATADIARIOOFICIALUNIAO  IS NULL)) 