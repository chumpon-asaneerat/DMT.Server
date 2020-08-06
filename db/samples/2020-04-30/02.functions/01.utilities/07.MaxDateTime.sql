SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MaxDateTime.
-- Description:	MaxDateTime is function to returns maximum value posible for datetime.
-- [== History ==]
-- <2018-06-01> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[MaxDateTime]
(
)
RETURNS datetime
AS
BEGIN
DECLARE @dt datetime;
DECLARE @vDateStr nvarchar(40);
DECLARE @result datetime;
    SELECT @dt = CAST(CAST(0x2D247f AS BIGINT) AS DATETIME);
	SET @vDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @dt)) + '-' +
				     CONVERT(nvarchar(2), DatePart(mm, @dt)) + '-' +
					 CONVERT(nvarchar(2), DatePart(dd, @dt)) + ' ' +
					 N'23:59:59.000');
	-- The max millisecond add with out round to next second is 998.
	SELECT @result = DATEADD(millisecond, 998, CONVERT(datetime, @vDateStr, 121));
	
    -- Return the result of the function
    RETURN @result;
END

GO
