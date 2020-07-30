/****** Object:  StoredProcedure [dbo].[rebuild_indices]    Script Date: 04/10/2019 10:14:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[rebuild_indices] as
begin
    exec sp_foreach_table_azure @command1="ALTER INDEX ALL ON ? REORGANIZE ; "
    exec sp_foreach_table_azure @command1="ALTER INDEX ALL ON ? REBUILD ; "
    exec sp_foreach_table_azure @command1="UPDATE STATISTICS ? ; "
end

GO
