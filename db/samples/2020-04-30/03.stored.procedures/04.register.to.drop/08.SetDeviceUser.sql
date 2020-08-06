SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SetDeviceUser.
-- Description:	Set Device User.
-- [== History ==]
-- <2019-11-05> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC SetDeviceUser N'EDL-C2019100003', N'D0001', N'M00003'
-- =============================================
CREATE PROCEDURE [dbo].[SetDeviceUser] (
  @customerId as nvarchar(30)
, @deviceId as nvarchar(30)
, @memberId as nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iDevCnt int = 0;
DECLARE @iMemCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 3001 : Customer Id cannot be null or empty string.
	-- 3002 : Device Id cannot be null or empty string.
	-- 3003 : Customer Id is not found.
	-- 3004 : Device Id Not Found.
	-- 3005 : Member Id is not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 3001, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@deviceId) = 1)
		BEGIN
			-- Device Id cannot be null or empty string.
            EXEC GetErrorMsg 3002, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 3003, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iDevCnt = COUNT(*)
		  FROM Device
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER(DeviceId) <> LOWER(RTRIM(LTRIM(@deviceId)));

		IF @iDevCnt = 0
		BEGIN
			-- Device Id Not Found
            EXEC GetErrorMsg 3004, @errNum out, @errMsg out
			RETURN;
		END

		IF (@memberId IS NULL OR RTRIM(LTRIM(@memberId)) = '')
		BEGIN
			UPDATE Device
				SET MemberId = NULL
			  WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				AND LOWER(DeviceId) = LOWER(RTRIM(LTRIM(@deviceId)))
		END
		ELSE
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(MemberId) <> LOWER(RTRIM(LTRIM(@memberId)));

			IF (@iMemCnt = 0)
			BEGIN
				-- Member Id Not Found
				EXEC GetErrorMsg 3005, @errNum out, @errMsg out
				RETURN;
			END

			UPDATE Device
				SET MemberId = UPPER(RTRIM(LTRIM(@memberId)))
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
