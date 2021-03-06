USE [erp_hmg]
GO
/****** Object:  StoredProcedure [dbo].[sp_copiar_etapaano]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_copiar_etapaano] @ano_origem int, @ano_destino int, @user_id int as
begin
    insert into academico_etapaano (criado_em, atualizado_em, ano, criado_por, atualizado_por, etapa_id, periodo, percentual_aprovacao, maximo_nota_apos_recuperacao, frequencia_minima, percentual_recuperacao, fechamento_disciplina, oferta)
    select getdate(), getdate(), @ano_destino, @user_id, null, etapa_id, periodo, percentual_aprovacao, maximo_nota_apos_recuperacao, frequencia_minima, percentual_recuperacao, fechamento_disciplina, oferta
    from academico_etapaano ea
    where ea.ano = @ano_origem
    and not exists (select top 1 1 from academico_etapaano ea2 where ea2.ano = @ano_destino and ea2.etapa_id = ea.etapa_id and ea.periodo = ea2.periodo)
end
GO
