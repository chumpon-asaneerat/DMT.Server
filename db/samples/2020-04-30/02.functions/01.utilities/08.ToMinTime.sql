SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: ToMinTime.
-- Description: ToMinTime is function for set time of specificed datetime to 00:00:00.000.
-- [== History ==]
-- <2018-06-01> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[ToMinTime]
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
					 N'00:00:00.000');
	SET @result = CONVERT(datetime, @vDateStr, 121);
    -- Return the result of the function
    RETURN @result;
END

GO
