/****** Object:  UserDefinedFunction [dbo].[InlineMaxDatetime]    Script Date: 26/12/2019 13:14:39 ******/
DROP FUNCTION IF EXISTS [dbo].[InlineMaxDatetime]
GO
/****** Object:  UserDefinedFunction [dbo].[InlineMaxDatetime]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE    function [dbo].[InlineMaxDatetime](@val1 datetime2, @val2 datetime2)
returns datetime2
as
begin
  if @val1 >= @val2
    return @val1
  return isnull(@val2,@val1)
end
GO
