/****** Object:  View [dbo].[vw_rebuild_indices]    Script Date: 26/12/2019 13:14:39 ******/
DROP VIEW IF EXISTS [dbo].[vw_rebuild_indices]
GO
/****** Object:  View [dbo].[vw_rebuild_indices]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_rebuild_indices] as
select 'alter index ' + dbindexes.[name] + ' on ' + dbtables.[name] + ' reorganize' as reorg,
       'alter index ' + dbindexes.[name] + ' on ' + dbtables.[name] + ' rebuild with (fillfactor=80, online=on)' as rebuild,
	   indexstats.avg_fragmentation_in_percent
--select count(1)
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id
WHERE 1 = 1 
and indexstats.database_id = DB_ID()
and indexstats.avg_fragmentation_in_percent > 10
--and dbindexes.fill_factor = 10
GO
