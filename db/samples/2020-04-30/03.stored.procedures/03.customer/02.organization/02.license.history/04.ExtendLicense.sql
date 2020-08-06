SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Extend License.
-- Description:	Extend License.
-- [== History ==]
-- <2019-10-01> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
/*
EXEC ExtendLicense 2, '2019-10-30', NULL, NULL, NULL, @errNum out, @errMsg out 
*/
-- =============================================
CREATE PROCEDURE [dbo].[ExtendLicense] (
  @historyId as int
, @endDate as datetime = null
, @maxDevice as int = null
, @maxAccount as int = null
, @maxClient as int = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 2801 : History Id cannot be null or empty string.
	-- 2802 : History Id not found.
	-- 2803 : License Still in active state.
	-- 2804 : 
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@historyId) = 1)
		BEGIN
			-- History Id cannot be null.
            EXEC GetErrorMsg 2801, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(HistoryId)
		  FROM LicenseHistory
		 WHERE HistoryId = @historyId
		IF (@iCnt = 0)
		BEGIN
			-- History Id not found.
            EXEC GetErrorMsg 2802, @errNum out, @errMsg out
			RETURN
		END
        /*
		SELECT @iCnt = COUNT(*)
		  FROM LicenseHistoryMLView 
		 WHERE HistoryId = @historyId
		   AND RemainDays > 0
		   AND langId = 'EN'
		IF (@iCnt > 0)
		BEGIN
			-- License Still in active state.
            EXEC GetErrorMsg 2803, @errNum out, @errMsg out
			RETURN
		END
        */

		UPDATE LicenseHistory
		   SET EndDate = COALESCE(@endDate, EndDate)
		     , MaxDevice = COALESCE(@maxDevice, MaxDevice)
			 , MaxAccount = COALESCE(@maxAccount, MaxAccount)
			 , MaxClient = COALESCE(@maxClient, MaxClient)
		 WHERE HistoryId = @historyId;

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
