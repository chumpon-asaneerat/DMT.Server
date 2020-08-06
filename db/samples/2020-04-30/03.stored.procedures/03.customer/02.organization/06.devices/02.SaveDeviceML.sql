SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveDeviceML.
-- Description:	Save Device (ML).
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC SaveDeviceML N'EDL-C2017060005', N'D0001', N'TH', N'อุปกรณ์ 1', N'ชั้น 1'
-- =============================================
CREATE PROCEDURE [dbo].[SaveDeviceML] (
  @customerId as nvarchar(30)
, @deviceId as nvarchar(30)
, @langId as nvarchar(3)
, @deviceName as nvarchar(80)
, @location as nvarchar(150)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iDevCnt int = 0;
	-- Error Code:
	--    0 : Success
    -- 2407 : Customer Id cannot be null or empty string.
	-- 2408 : Lang Id cannot be null or empty string.
	-- 2409 : Language Id not exist.
	-- 2410 : Device Id cannot be null or empty string.
	-- 2411 : Device Id is not found.
	-- 2412 : Device Name (ML) is already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
            -- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 2407, @errNum out, @errMsg out
			RETURN
		END

		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 2408, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not exist.
            EXEC GetErrorMsg 2409, @errNum out, @errMsg out
			RETURN
		END

		/* Check if device id is not null. */
		IF (dbo.IsNullOrEmpty(@deviceId) = 1)
		BEGIN
			-- Device Id cannot be null or empty string.
            EXEC GetErrorMsg 2410, @errNum out, @errMsg out
			RETURN
		END

		/* Check Id is in table */ 
		SELECT @iDevCnt = COUNT(*)
			FROM Device
		   WHERE UPPER(RTRIM(LTRIM(DeviceId))) = UPPER(RTRIM(LTRIM(@deviceId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF @iDevCnt = 0
		BEGIN
			-- Device Id is not found.
            EXEC GetErrorMsg 2411, @errNum out, @errMsg out
			RETURN
		END

		/* Check Device Name is already exists. */
		SELECT @iDevCnt = COUNT(*)
			FROM DeviceML
		   WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		     AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		     AND UPPER(RTRIM(LTRIM(DeviceName))) = UPPER(RTRIM(LTRIM(@deviceName)))
		     AND UPPER(RTRIM(LTRIM(DeviceId))) <> UPPER(RTRIM(LTRIM(@deviceId)))
		IF @iDevCnt <> 0
		BEGIN
			-- Branch Name (ML) is already exists.
            EXEC GetErrorMsg 2412, @errNum out, @errMsg out
			RETURN
		END

		/* check is need to insert or update? */
		SELECT @iDevCnt = COUNT(*)
			FROM DeviceML
		   WHERE UPPER(RTRIM(LTRIM(DeviceId))) = UPPER(RTRIM(LTRIM(@deviceId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			 AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));

		IF @iDevCnt = 0
		BEGIN
			INSERT INTO DeviceML
			(
				  CustomerId
				, DeviceId
				, LangId
				, DeviceName
				, Location
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@deviceId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@deviceName))
				, RTRIM(LTRIM(@location))
			);
		END
		ELSE
		BEGIN
			UPDATE DeviceML
			   SET DeviceName = RTRIM(LTRIM(@deviceName))
			     , Location = RTRIM(LTRIM(@location))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(DeviceId))) = UPPER(RTRIM(LTRIM(@deviceId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
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
