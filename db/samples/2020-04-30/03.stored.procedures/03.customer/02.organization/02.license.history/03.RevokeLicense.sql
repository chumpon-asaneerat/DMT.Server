SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Revoke License.
-- Description:	Revoke License.
-- [== History ==]
-- <2019-10-01> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
/*
EXEC RevokeLicense 1, @errNum out, @errMsg out 
*/
-- =============================================
CREATE PROCEDURE [dbo].[RevokeLicense] (
  @historyId as int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 2701 : History Id cannot be null or empty string.
	-- 2702 : History Id not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@historyId) = 1)
		BEGIN
			-- History Id cannot be null.
            EXEC GetErrorMsg 2701, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(HistoryId)
		  FROM LicenseHistory
		 WHERE HistoryID = @historyId
		IF (@iCnt = 0)
		BEGIN
			-- History Id not found.
            EXEC GetErrorMsg 2702, @errNum out, @errMsg out
			RETURN
		END

		UPDATE LicenseHistory
		   SET BeginDate = GETDATE()
		     , EndDate = GETDATE()
		 WHERE HistoryID = @historyId
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
