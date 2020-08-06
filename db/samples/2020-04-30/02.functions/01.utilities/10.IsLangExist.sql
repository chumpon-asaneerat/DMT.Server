SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: IsLangExist.
-- Description:	IsLangExist is function to check is langId is exist or not
--              returns 0 if langId is not exist otherwise return 1.
-- [== History ==]
-- <2018-05-29> :
--	- Function Created.
--
-- [== Example ==]
--
-- =============================================
CREATE FUNCTION [dbo].[IsLangExist]
(
 @langid nvarchar(3)
)
RETURNS bit
AS
BEGIN
DECLARE @lId nvarchar(3);
DECLARE @iCnt int;
DECLARE @result bit;
	IF (dbo.IsNullOrEmpty(@langId) = 1)
	BEGIN
		SET @lId = N'EN';
	END
	ELSE
	BEGIN
		SET @lId = @langId;
	END

	SELECT @iCnt = COUNT(*)
	  FROM Language
	 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@lId)));
	IF (@iCnt = 0)
	BEGIN
		SET @result = 0;
	END
	ELSE
	BEGIN
		SET @result = 1;
	END

    RETURN @result;
END

GO
