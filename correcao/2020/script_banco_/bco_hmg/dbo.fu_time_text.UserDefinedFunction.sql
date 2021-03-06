USE [erp_hmg]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_time_text]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[fu_time_text] (@time varchar(50)) 
returns varchar(50) as
begin
  declare @hour_part varchar(50)
  declare @dec_part  varchar(10)

  if not @time is null begin
    set @hour_part = convert(int, left(@time, charindex(':', @time) - 1))
    set @dec_part = substring(@time, charindex(':', @time) + 1, len(@time))

    return @hour_part + ':' + @dec_part
  end

  return null
end
GO
