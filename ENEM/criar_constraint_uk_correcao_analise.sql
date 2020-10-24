if(exists(SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[UQ_correcoes_analise__REDACAO_ID_ID_CORRETOR_A_ID_TIPO_CORRECAO_A]')))
	begin
		ALTER TABLE correcoes_analise  
		drop CONSTRAINT UQ_correcoes_analise__REDACAO_ID_ID_CORRETOR_A_ID_TIPO_CORRECAO_A
    end

ALTER TABLE correcoes_analise  
ADD CONSTRAINT UQ_correcoes_analise__REDACAO_ID_ID_CORRETOR_A_ID_TIPO_CORRECAO_A UNIQUE (REDACAO_ID, ID_CORRETOR_A, ID_TIPO_CORRECAO_A); 
