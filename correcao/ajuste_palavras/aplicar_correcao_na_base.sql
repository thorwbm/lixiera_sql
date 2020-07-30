 
begin tran update egr set 
                  egr.nomepai     = cor.corrigido_nomepai,    
                  egr.nomemae     = cor.corrigido_nomemae,    
                  egr.endereco    = cor.corrigido_endereco,   
                  egr.bairro      = cor.corrigido_bairro,     
                  egr.cidade      = cor.corrigido_cidade,     
                  egr.complemento = cor.corrigido_complemento,
                  egr.aluno       = cor.corrigido_aluno      
from egresso_correcao cor join egressos_univers egr on (cor.id = egr.id)
where 
(flag_nomepai     = 1 or 
 flag_nomemae     = 1 or 
 flag_endereco    = 1 or 
 flag_bairro      = 1 or 
 flag_cidade      = 1 or 
 flag_complemento = 1 or 
 flag_aluno       = 1 )

 -- commit 
 -- rollback 
