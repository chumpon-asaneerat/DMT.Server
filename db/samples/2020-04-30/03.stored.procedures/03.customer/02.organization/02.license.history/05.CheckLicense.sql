SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	CheckLicense
-- [== History ==]
-- <2019-10-01> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC CheckLicense N'EDL-C2017010002', 0;
-- =============================================
CREATE PROCEDURE [dbo].[CheckLicense] (
  @customerId nvarchar(30) = null
, @licenseTypeId int = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @memberId nvarchar(30);
    -- Error Code:
    --    0 : Success
	-- 2501 : Customer Id cannot be null or empty string.
	-- 2502 : Customer Id not exist.
	-- 2503 : LicenseTypeId cannot be null.
	-- 2504 : LicenseTypeId not exits.
	-- 2505 : 
	-- 2506 : 
    -- OTHER : SQL Error Number & Error Message.
    BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			EXEC GetErrorMsg 2501, @errNum out, @errMsg out
			RETURN
		END
		SELECT @iCnt = COUNT(CustomerId) 
		  FROM Customer 
		 WHERE LOWER(RTRIM(LTRIM(CustomerId))) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
            -- Cannot found Customer Id.
            EXEC GetErrorMsg 2502, @errNum out, @errMsg out
			RETURN
		END
		IF (dbo.IsNullOrEmpty(@licenseTypeId) = 1)
		BEGIN
			EXEC GetErrorMsg 2503, @errNum out, @errMsg out
			RETURN
		END
		SELECT @iCnt = COUNT(LicenseTypeId) 
		  FROM LicenseType 
		 WHERE LicenseTypeId = @licenseTypeId
		IF (@iCnt = 0)
		BEGIN
            -- Cannot found License Type Id.
            EXEC GetErrorMsg 2504, @errNum out, @errMsg out
			RETURN
		END

		-- 
		/*
		SELECT @accessId = AccessId, @iCnt = COUNT(*)
		  FROM ClientAccess
		 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
		   AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(@memberId)))
		 GROUP BY AccessId

		-- Keep data into session.
		IF (@iCnt = 0)
		BEGIN
			-- NOT EXIST.
			EXEC GetRandomCode 10, @accessId out; -- Generate 10 Chars Unique Id.
			INSERT INTO ClientAccess
			(
				  AccessId
				, CustomerId
				, MemberId 
			)
			VALUES
			(
				  UPPER(LTRIM(RTRIM(@accessId)))
				, UPPER(LTRIM(RTRIM(@customerId)))
				, UPPER(LTRIM(RTRIM(@memberId))) 
			);
		END
		ELSE
		BEGIN
			-- ALREADY EXIST.
			UPDATE ClientAccess
			   SET CustomerId = UPPER(LTRIM(RTRIM(@customerId)))
			     , MemberId = UPPER(LTRIM(RTRIM(@memberId)))
			 WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
		END
		*/

		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO