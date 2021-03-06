/****** Object:  View [dbo].[vw_uitl_server_params]    Script Date: 04/10/2019 10:16:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_uitl_server_params] as
SELECT 
    [name],
    [value],
    [description]
FROM 
    sys.configurations
WHERE 
    [name] IN ( 'max degree of parallelism', 'cost threshold for parallelism', 'min server memory (MB)',
                'max server memory (MB)', 'clr enabled', 'xp_cmdshell', 'Ole Automation Procedures',
                'user connections', 'fill factor (%)', 'cross db ownership chaining', 'remote access',
                'default trace enabled', 'external scripts enabled', 'Database Mail XPs', 'Ad Hoc Distributed Queries',
                'SMO and DMO XPs', 'clr strict security', 'remote admin connections'
              )
GO
