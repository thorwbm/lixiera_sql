/****** Object:  UserDefinedFunction [dbo].[InlineMaxDatetime]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[InlineMaxDatetime](@val1 datetime2, @val2 datetime2)
returns datetime2
as
begin
  if @val1 > @val2
    return @val1
  return isnull(@val2,@val1)
end
GO
