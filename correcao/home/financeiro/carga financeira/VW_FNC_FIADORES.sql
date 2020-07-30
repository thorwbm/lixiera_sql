  
create OR ALTER view VW_FNC_FIADORES as   
select * from mat_prd..vw_fiadores union  
select * from rem_prd..vw_fiadores