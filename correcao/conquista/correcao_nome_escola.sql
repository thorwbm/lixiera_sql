--########################################################################
   --declare @tabela table (palavra varchar(100))

declare @palavra_original VARCHAR(100)
DECLARE @palavra_correcao VARCHAR(100)

declare CUR_PALAVRA cursor for 
-----------------------------------------------------------
        select distinct palavra_original, palavra_correcao 
        from banco_palavra 
        where flag_aplicar = 1
-----------------------------------------------------------
	open CUR_PALAVRA 
		fetch next from CUR_PALAVRA into @palavra_original, @palavra_correcao
		while @@FETCH_STATUS = 0
			BEGIN
                
                  update esc set esc.corrigido = replace(corrigido,@palavra_original,@palavra_correcao), FLG_CORRECAO = 1
                  FROM BKP_ESCOLAs esc where nome LIke '%'+@palavra_original+'%'
                

			fetch next from CUR_PALAVRA into @palavra_original, @palavra_correcao
			END
	close CUR_PALAVRA 
deallocate CUR_PALAVRA 

select * from BKP_ESCOLAs 
WHERE flg_correcao = 1


/* ##############################################################
------------------------------------------------------------------
update BKP_ESCOLAs set corrigido = nome, flg_correcao = 0
where corrigido is null 

------------------------------------------------------------------
select 
       nome = case when flg_correcao = 0 then nome else corrigido end,
       estado, cidade
from bkp_escolas 

------------------------------------------------------------------
BEGIN TRAN
update bkp_escolas set corrigido = replace(CORRIGIDO,'PRE-','PRÉ-' )
WHERE nome LIKE '%PRE-%'

update bkp_escolas set corrigido = replace(CORRIGIDO,'PRE ','PRÉ ' )
WHERE nome LIKE '%PRE %'
-- COMMIT
-- ROLLBACK
###################################################################*/