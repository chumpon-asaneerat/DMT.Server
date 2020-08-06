SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SetDeviceOrg.
-- Description:	Set Device Org.
-- [== History ==]
-- <2019-11-05> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC SetDeviceOrg N'EDL-C2019100003', N'D0001', N'O0003'
-- =============================================
CREATE PROCEDURE [dbo].[SetDeviceOrg] (
  @customerId as nvarchar(30)
, @deviceId as nvarchar(30)
, @orgId as nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iDevCnt int = 0;
DECLARE @iOrgCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 2901 : Customer Id cannot be null or empty string.
	-- 2902 : Device Id cannot be null or empty string.
	-- 2903 : Customer Id is not found.
	-- 2904 : Device Id Not Found.
	-- 2905 : Org Id is not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 2901, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@deviceId) = 1)
		BEGIN
			-- Device Id cannot be null or empty string.
            EXEC GetErrorMsg 2902, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 2903, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iDevCnt = COUNT(*)
		  FROM Device
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER(DeviceId) <> LOWER(RTRIM(LTRIM(@deviceId)));

		IF @iDevCnt = 0
		BEGIN
			-- Device Id Not Found
            EXEC GetErrorMsg 2904, @errNum out, @errMsg out
			RETURN;
		END

		IF (@orgId IS NULL OR RTRIM(LTRIM(@orgId)) = '')
		BEGIN
			UPDATE Device
				SET OrgId = NULL
			  WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				AND LOWER(DeviceId) = LOWER(RTRIM(LTRIM(@deviceId)))
		END
		ELSE
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(OrgId) <> LOWER(RTRIM(LTRIM(@orgId)));

			IF (@iOrgCnt = 0)
			BEGIN
				-- Org Id Not Found
				EXEC GetErrorMsg 2905, @errNum out, @errMsg out
				RETURN;
			END

			UPDATE Device
				SET OrgId = UPPER(RTRIM(LTRIM(@orgId)))
			  WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				AND LOWER(DeviceId) = LOWER(RTRIM(LTRIM(@deviceId)))
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
