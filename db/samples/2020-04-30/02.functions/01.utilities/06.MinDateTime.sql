SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MinDateTime.
-- Description:	MinDateTime is function to returns minimum value posible for datetime.
-- [== History ==]
-- <2018-06-01> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[MinDateTime]
(
)
RETURNS datetime
AS
BEGIN
DECLARE @dt datetime;
DECLARE @vDateStr nvarchar(40);
DECLARE @result datetime;
    SELECT @dt = CAST(CAST(0xD1BA AS BIGINT) * -1 AS DATETIME);
	SET @vDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @dt)) + '-' +
				     CONVERT(nvarchar(2), DatePart(mm, @dt)) + '-' +
					 CONVERT(nvarchar(2), DatePart(dd, @dt)) + ' ' +
					 N'00:00:00.000');
	SET @result = CONVERT(datetime, @vDateStr, 121);
    -- Return the result of the function
    RETURN @result;
END

GO
