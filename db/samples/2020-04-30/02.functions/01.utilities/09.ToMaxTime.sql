SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: ToMaxTime.
-- Description: ToMaxTime is function for set time of specificed datetime to 23:59:59.997.
--              The 997 ms is max value that not SQL Server not round to next second.
--              The data type datetime has a precision only up to 3ms, so there's no .999 precision.
-- [== History ==]
-- <2018-06-01> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[ToMaxTime]
(
 @dt datetime
)
RETURNS datetime
AS
BEGIN
DECLARE @vDateStr nvarchar(40);
DECLARE @result datetime;
	IF (@dt IS NULL)
	BEGIN
		RETURN NULL;
	END
	SET @vDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @dt)) + '-' +
				     CONVERT(nvarchar(2), DatePart(mm, @dt)) + '-' +
					 CONVERT(nvarchar(2), DatePart(dd, @dt)) + ' ' +
					 N'23:59:59.997');
	SET @result = CONVERT(datetime, @vDateStr, 121);
    -- Return the result of the function
    RETURN @result;
END

GO
