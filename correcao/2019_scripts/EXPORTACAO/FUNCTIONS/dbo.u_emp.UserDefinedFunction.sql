/****** Object:  UserDefinedFunction [dbo].[u_emp]    Script Date: 04/10/2019 10:24:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[u_emp]
(   
    @enoNumber INT
)
RETURNS TABLE 
AS
RETURN 
(
    SELECT    
        * 
    FROM    
        sysobjects
)
GO
