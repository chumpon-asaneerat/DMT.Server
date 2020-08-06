SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetErrorMsg.
-- Description:	Get Error Message.
-- [== History ==]
-- <2018-04-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetErrorMsg 101 @errNum out, @errMsg out
-- =============================================
CREATE PROCEDURE GetErrorMsg
(
  @errCode as int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iCnt int = 0;
	SELECT @iCnt = COUNT(*)
	  FROM ErrorMessage
	 WHERE ErrCode = @errCode;

	IF @iCnt = 0
	BEGIN
	-- Not Found.
	SET @errNum = @errCode;
	SET @errMsg = 'Error Code Not Found.';
	END
	ELSE
	BEGIN
		SELECT @errNum = ErrCode
			 , @errMsg = ErrMsg
		  FROM ErrorMessage
		 WHERE ErrCode = @errCode;
	END 
END

GO
