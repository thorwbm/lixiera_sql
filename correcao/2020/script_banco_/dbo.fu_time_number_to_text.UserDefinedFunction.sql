USE [erp_hmg]
GO
/****** Object:  UserDefinedFunction [dbo].[fu_time_number_to_text]    Script Date: 09/01/2020 18:38:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   function [dbo].[fu_time_number_to_text] (@time decimal(10, 2)) 
returns varchar(50) as
begin
  declare @hour_part int
  declare @dec_part int

  if not @time is null begin

    set @hour_part = convert(int, @time)
    set @dec_part = convert(decimal(10, 2), (@time - @hour_part)) * 60

    return convert(varchar(10), @hour_part) + ':' + right('00' + convert(varchar(10), @dec_part), 2)
  end

  return null
end
GO
