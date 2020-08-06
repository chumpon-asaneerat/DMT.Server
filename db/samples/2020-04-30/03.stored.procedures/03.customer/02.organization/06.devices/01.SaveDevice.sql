SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveDevice.
-- Description:	Save Device.
-- [== History ==]
-- <2018-05-21> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC SaveDevice N'EDL-C2017010001', 0, N'Device 1', N'Floor 1'
-- =============================================
CREATE PROCEDURE [dbo].[SaveDevice] (
  @customerId as nvarchar(30)
, @deviceTypeId as int
, @deviceName as nvarchar(80)
, @location as nvarchar(150)
, @deviceId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iTypeCnt int = 0;
DECLARE @iCustCnt int = 0;
DECLARE @iDevCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 2401 : Customer Id cannot be null or empty string.
	-- 2402 : Device Type Id not found.
	-- 2403 : Device Name (default) cannot be null or empty string.
	-- 2404 : Customer Id is not found.
	-- 2405 : Device Id is not found.
	-- 2406 : Device Name (default) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 2401, @errNum out, @errMsg out
			RETURN
		END

		IF (@deviceTypeId IS NULL)
		BEGIN
			SET @deviceTypeId = 0;
		END 

		SELECT @iTypeCnt = COUNT(*) 
		  FROM DeviceType
		 WHERE DeviceTypeId = @deviceTypeId;
		IF (@iTypeCnt = 0) 
		BEGIN
			-- Device Type Id not found.
            EXEC GetErrorMsg 2402, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@deviceName) = 1)
		BEGIN
			-- Device Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 2403, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 2404, @errNum out, @errMsg out
			RETURN
		END

		/* Check Name exists */
		IF (@deviceId IS NOT NULL AND LTRIM(RTRIM(@deviceId)) <> N'')
		BEGIN
			SELECT @iDevCnt = COUNT(*)
			  FROM Device
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(DeviceId) = LOWER(RTRIM(LTRIM(@deviceId)));
			IF (@iDevCnt = 0)
			BEGIN
				-- Device Id is not found.
                EXEC GetErrorMsg 2405, @errNum out, @errMsg out
				RETURN
			END

			SELECT @iDevCnt = COUNT(*)
				FROM Device
				WHERE LOWER(DeviceName) = LOWER(RTRIM(LTRIM(@deviceName)))
				  AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			      AND LOWER(DeviceId) <> LOWER(RTRIM(LTRIM(@deviceId)));
		END
		ELSE
		BEGIN
			SELECT @iDevCnt = COUNT(*)
				FROM Device
				WHERE LOWER(DeviceName) = LOWER(RTRIM(LTRIM(@deviceName)))
				  AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iDevCnt <> 0
		BEGIN
			-- Device Name (default) already exists.
            EXEC GetErrorMsg 2406, @errNum out, @errMsg out
			RETURN;
		END

		SET @iDevCnt = 0; -- Reset Counter.

		IF dbo.IsNullOrEmpty(@deviceId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
			                  , N'Device'
							  , @deviceId out
							  , @errNum out
							  , @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iDevCnt = COUNT(*)
			  FROM Device
			 WHERE LOWER(DeviceId) = LOWER(RTRIM(LTRIM(@deviceId)))
			   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iDevCnt = 0
		BEGIN
			INSERT INTO Device
			(
				  CustomerId
				, DeviceTypeId
				, DeviceId
				, DeviceName
				, Location
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, @deviceTypeId
				, RTRIM(LTRIM(@deviceId))
				, RTRIM(LTRIM(@deviceName))
				, RTRIM(LTRIM(@location))
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE Device
			   SET DeviceName = RTRIM(LTRIM(@deviceName))
			     , Location = RTRIM(LTRIM(@location))
				 , DeviceTypeId = @deviceTypeId
			 WHERE LOWER(DeviceId) = LOWER(RTRIM(LTRIM(@deviceId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
