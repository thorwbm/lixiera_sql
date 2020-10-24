select *

-- setar maximo correcao e nota corretor
update cor set cor.max_correcoes_dia = 30, 
               cor.nota_corretor = null 
 from correcoes_corretor cor 


-- apagar historico correcao
delete  from correcoes_historicocorrecao
 DBCC CHECKIDENT('correcoes_historicocorrecao', RESEED, 0) ;

-- apagar analises
delete from correcoes_pendenteanalise
delete from correcoes_analise
 DBCC CHECKIDENT('correcoes_pendenteanalise', RESEED, 0) ;
 DBCC CHECKIDENT('correcoes_analise', RESEED, 0) ;

-- apgar filapessoal 
delete from correcoes_filapessoal
 DBCC CHECKIDENT('correcoes_filapessoal', RESEED, 0) ;

-- apagar correcoes correao
 delete from correcoes_correcao
 DBCC CHECKIDENT('correcoes_correcao', RESEED, 0) ;
 
 -- apagar correcoes redacao
delete from correcoes_gabarito
 DBCC CHECKIDENT('correcoes_gabarito', RESEED, 0) ; 
delete from correcoes_redacao
 DBCC CHECKIDENT('correcoes_redacao', RESEED, 0) ;



select * from core_feature
