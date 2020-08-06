SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsSameYear.
-- Description:	IsSameYear is function to check is data is in same year
--              returns 1 if same year otherwise returns 0
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[IsSameYear](@date1 datetime, @date2 datetime)
RETURNS bit
AS
BEGIN
DECLARE @diff int;
DECLARE @result bit;
    SELECT @diff = DATEDIFF(year, @date1, @date2);
    -- Return the result of the function
    IF @diff = 0
		SET @result = 1;
	ELSE SET @result = 0;
    RETURN @result;
END

GO
