

ALTER     VIEW [dbo].[vw_aproveitamento_notas_time] as
select
    polo.id as polo_id,
    polo.descricao as polo_descricao,
    time.id as time_id,
    time.descricao as time_descricao,
    time.indice as indice,
    p.nome as avaliador,
    ultima_correcao,
    isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor) usuario_id,
    isnull(discrepantes.data, total_correcoes_1a_2a.data) data,
    isnull(total_correcoes_1a_2a.nr_corrigidas, 0 ) nr_corrigidas,
    isnull(nr_aproveitadas, 0) nr_aproveitadas,
    isnull(nr_nao_aproveitadas, 0) nr_nao_aproveitadas,
    isnull(nr_discrepantes, 0) nr_discrepantes
from (
    select
        id_corretor,
        cast(data as date) data,
        count(1) nr_discrepantes,
        sum(case when aproveitamento = 1 then 1 else 0 end) as nr_aproveitadas,
        sum(case when (aproveitamento = 0 or aproveitamento is null) and terceiro_situacao is not null then 1 else 0 end) as nr_nao_aproveitadas
    from  relatorios_responsabilidadeavaliadorcomdata
    group by id_corretor, cast(data as date)
) discrepantes
right join (
    select
        id_corretor,
        cast(data_termino as date) [data],
        COUNT(1) nr_corrigidas,
        MAX(data_termino) as ultima_correcao
    from correcoes_correcao
    where data_termino is not null and id_tipo_correcao in (1, 2)
    GROUP by id_corretor, cast(data_termino as date)
) total_correcoes_1a_2a on total_correcoes_1a_2a.id_corretor = discrepantes.id_corretor
    and discrepantes.data = total_correcoes_1a_2a.[data]
inner join dbo.usuarios_pessoa p on p.usuario_id = isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor)
inner join dbo.usuarios_hierarquia_usuarios b on b.user_id = isnull(discrepantes.id_corretor, total_correcoes_1a_2a.id_corretor)
inner join dbo.usuarios_hierarquia as [time] on [time].id = b.hierarquia_id
inner join dbo.usuarios_hierarquia as polo on polo.id = [time].id_hierarquia_usuario_pai
inner join dbo.usuarios_hierarquia as fgv on fgv.id = polo.id_hierarquia_usuario_pai
inner join dbo.usuarios_hierarquia as geral on geral.id = fgv.id_hierarquia_usuario_pai

GO


