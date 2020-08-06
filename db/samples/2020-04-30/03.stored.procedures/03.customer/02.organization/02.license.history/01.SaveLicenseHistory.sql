SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseHistory.
-- Description:	Begin Log.
-- [== History ==]
-- <2019-10-01> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveLicenseHistory N'EDL-C2019080001', 0
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseHistory]
(
  @customerId as nvarchar(30)
, @licenseTypeId int
, @historyId int = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int;

DECLARE @priodId int;
DECLARE @priodTimes int;

DECLARE @beginDate datetime;
DECLARE @endDate datetime;
DECLARE @maxDevice int;
DECLARE @maxAccount int;
DECLARE @maxClient int;
    -- Error Code:
    --    0 : Success
	-- 2601 : Customer Id cannot be null or empty string.
	-- 2602 : Customer Id not exist.
	-- 2603 : LicenseTypeId cannot be null.
	-- 2604 : LicenseTypeId not exits.
	-- 2605 : Request is on processing.
	-- 2606 : Your Free License is already used.
    -- OTHER : SQL Error Number & Error Message.
    BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			EXEC GetErrorMsg 2601, @errNum out, @errMsg out
			RETURN
		END
		SELECT @iCnt = COUNT(CustomerId) 
		  FROM Customer 
		 WHERE LOWER(RTRIM(LTRIM(CustomerId))) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
            -- Cannot found Customer Id.
            EXEC GetErrorMsg 2602, @errNum out, @errMsg out
			RETURN
		END
		IF (dbo.IsNullOrEmpty(@licenseTypeId) = 1)
		BEGIN
			EXEC GetErrorMsg 2603, @errNum out, @errMsg out
			RETURN
		END
		SELECT @iCnt = COUNT(LicenseTypeId) 
		  FROM LicenseType 
		 WHERE LicenseTypeId = @licenseTypeId
		IF (@iCnt = 0)
		BEGIN
            -- Cannot found License Type Id.
            EXEC GetErrorMsg 2604, @errNum out, @errMsg out
			RETURN
		END

		-- Check is already requests to renew license.
		SELECT @iCnt = COUNT(*) 
		  FROM LicenseHistory
		 WHERE LOWER(RTRIM(LTRIM(CustomerId))) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND (BeginDate IS NULL OR EndDate IS NULL)

		IF (@iCnt <> 0)
		BEGIN
			EXEC GetErrorMsg 2605, @errNum out, @errMsg out
			RETURN
		END

		-- Check is license type 0 (free) is already apply.
		SELECT @iCnt = COUNT(*) 
		  FROM LicenseHistory
		 WHERE LOWER(RTRIM(LTRIM(CustomerId))) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LicenseTypeId = 0

		IF (@iCnt <> 0)
		BEGIN
			EXEC GetErrorMsg 2606, @errNum out, @errMsg out
			RETURN
		END

		IF (@iCnt = 0)
		BEGIN
			SELECT @historyId = MAX(HistoryId) FROM LicenseHistory;
			IF (@historyId IS NULL) 
			BEGIN
				SET @historyId = 0;
			END
			SET @historyId = @historyId + 1;

			-- MAX DEVICE (MIN = 1)
			SELECT @maxDevice = NoOfLimit
			  FROM LicenseFeature
			 WHERE LimitUnitId = 1
			   AND LicenseTypeId = @licenseTypeId
			IF (@maxDevice IS NULL OR @maxDevice < 1) SET @maxDevice = 1;
			-- MAX ACCOUNT (MIN = 1)
			SELECT @maxAccount = NoOfLimit
			  FROM LicenseFeature
			 WHERE LimitUnitId = 1
			   AND LicenseTypeId = @licenseTypeId
			IF (@maxAccount IS NULL OR @maxAccount < 1) SET @maxAccount = 1;
			-- MAX CLIENT (MIN = 1)
			SELECT @maxClient = NoOfLimit
			  FROM LicenseFeature
			 WHERE LimitUnitId = 1
			   AND LicenseTypeId = @licenseTypeId
			IF (@maxClient IS NULL OR @maxClient < 1) SET @maxClient = 1;

			-- CALC PERIOD
			SELECT @priodId = PeriodUnitId, @priodTimes = NumberOfUnit
				FROM LicenseType
				WHERE LicenseTypeId = @licenseTypeId;
				
			SET @beginDate = GETDATE();
			IF (@priodId = 1) SELECT @endDate = DATEADD(day, @priodTimes, GETDATE());
			ELSE 
			BEGIN 
				IF (@priodId = 2) SELECT @endDate = DATEADD(month, @priodTimes, GETDATE());
				ELSE SELECT @endDate = DATEADD(year, @priodTimes, GETDATE());
			END

			INSERT INTO LicenseHistory
			(
				HistoryId
			  , CustomerId
			  , LicenseTypeId
			  , MaxDevice
			  , MaxAccount
			  , MaxClient
			  , BeginDate
			  , EndDate
			) 
			VALUES
			(
				@historyId
			  , @customerId
			  , @licenseTypeId
			  , @maxDevice
			  , @maxAccount
			  , @maxClient
			  , @beginDate
			  , @endDate
			)
		END

		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
