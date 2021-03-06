/****** Object:  UserDefinedFunction [dbo].[getlocaldate]    Script Date: 26/12/2019 13:14:39 ******/
DROP FUNCTION IF EXISTS [dbo].[getlocaldate]
GO
/****** Object:  UserDefinedFunction [dbo].[getlocaldate]    Script Date: 26/12/2019 13:14:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[getlocaldate]()
returns datetime2
as
begin
   return convert(datetime2, CONVERT(datetimeoffset, getdate()) AT TIME ZONE 'E. South America Standard Time');
end
GO
