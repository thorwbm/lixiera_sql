declare @palavra_original VARCHAR(100)
DECLARE @palavra_correcao VARCHAR(100)
declare @tamanho int
declare CUR_PALAVRA cursor for 
-----------------------------------------------------------
        select distinct palavra_original, palavra_correcao, len(palavra_original) as tamanho
        from biblioteca_palavra_aux 
        where flag_aplicar = 1 
        order by len(palavra_original) desc
-----------------------------------------------------------
	open CUR_PALAVRA 
		fetch next from CUR_PALAVRA into @palavra_original, @palavra_correcao, @tamanho
		while @@FETCH_STATUS = 0
			BEGIN
                  update esc set 
                         esc.corrigido_aluno = replace(corrigido_aluno,@palavra_original,@palavra_correcao), 
                         FLAG_aluno = 1
                    FROM egresso_correcao esc 
                   where aluno like '%'+@palavra_original+'%'

                  update esc set 
                         esc.corrigido_nomepai = replace(corrigido_nomepai,@palavra_original,@palavra_correcao), 
                         FLAG_nomepai = 1
                    FROM egresso_correcao esc 
                   where nomepai like '%'+@palavra_original+'%'

                  update esc set 
                         esc.corrigido_nomemae = replace(corrigido_nomemae,@palavra_original,@palavra_correcao), 
                         FLAG_nomemae = 1
                    FROM egresso_correcao esc 
                   where nomemae like '%'+@palavra_original+'%'

                  update esc set 
                         esc.corrigido_endereco = replace(corrigido_endereco,@palavra_original,@palavra_correcao), 
                         FLAG_endereco = 1
                    FROM egresso_correcao esc 
                   where endereco like '%'+@palavra_original+'%'

                  update esc set 
                         esc.corrigido_bairro = replace(corrigido_bairro,@palavra_original,@palavra_correcao), 
                         FLAG_bairro = 1
                    FROM egresso_correcao esc 
                   where bairro like '%'+@palavra_original+'%'

                  update esc set 
                         esc.corrigido_cidade = replace(corrigido_cidade,@palavra_original,@palavra_correcao), 
                         FLAG_cidade = 1
                    FROM egresso_correcao esc 
                   where cidade like '%'+@palavra_original+'%'

                  update esc set 
                         esc.corrigido_complemento = replace(corrigido_complemento,@palavra_original,@palavra_correcao), 
                         FLAG_complemento = 1
                    FROM egresso_correcao esc 
                   where complemento like '%'+@palavra_original+'%'

			fetch next from CUR_PALAVRA into @palavra_original, @palavra_correcao, @tamanho
			END
	close CUR_PALAVRA 
deallocate CUR_PALAVRA 


----------------------------------------------------------------------------------
-- select que retorna todas as linhas que sofreram alguma alteracao
/*
select * 
from egresso_correcao 
where 
flag_nomepai     = 1 or 
flag_nomemae     = 1 or 
flag_endereco    = 1 or 
flag_bairro      = 1 or 
flag_cidade      = 1 or 
flag_complemento = 1 or 
flag_aluno       = 1 

*/


