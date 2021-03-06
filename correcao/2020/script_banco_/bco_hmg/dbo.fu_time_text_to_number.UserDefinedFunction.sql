USE [erp_hmg]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_time_text_to_number]    Script Date: 12/02/2020 15:40:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[fu_time_text_to_number] (@time varchar(50)) 
returns numeric(10, 2) as
begin
  declare @hour_part int
  declare @dec_part int

  if not @time is null begin
    set @hour_part = convert(int, left(@time, charindex(':', @time) - 1))
    set @dec_part = convert(int, substring(@time, charindex(':', @time) + 1, len(@time)))

    return @hour_part + (@dec_part / 60.00)
  end

  return null
end
GO
