SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Delete Device
-- [== History ==]
-- <2019-12-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DeleteDevice N'EDL-C2019100003', N'D0002'
-- =============================================
CREATE PROCEDURE [dbo].[DeleteDevice]
(
  @customerId nvarchar(30)
, @deviceId nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
    -- Error Code:
    --   0 : Success
	-- 4301: Customer Id cannot be null or empty string.
	-- 4302: Device Id cannot be null or empty string.
	-- 4303: Cannot be remove default device.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 4301, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@deviceId) = 1)
		BEGIN
			-- Device Id cannot be null or empty string.
            EXEC GetErrorMsg 4302, @errNum out, @errMsg out
			RETURN
		END
		/*
		IF (LTRIM(RTRIM(LOWER(@orgId))) = LOWER(N'D0001'))
		BEGIN
			-- Cannot be remove default device.
            EXEC GetErrorMsg 4303, @errNum out, @errMsg out
			RETURN
		END
		*/

		DELETE FROM Vote 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(DeviceId))) = LTRIM(RTRIM(LOWER(@deviceId)))

		DELETE FROM DeviceML 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
		   AND LTRIM(RTRIM(LOWER(DeviceId))) = LTRIM(RTRIM(LOWER(@deviceId))) 

		DELETE FROM Device 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(DeviceId))) = LTRIM(RTRIM(LOWER(@deviceId))) 

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
