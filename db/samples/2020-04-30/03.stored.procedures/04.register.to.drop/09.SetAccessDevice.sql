SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Set Access Device.
-- Description:	Set Access Device.
-- [== History ==]
-- <2019-12-26> :
--	- Stored Procedure Created.
-- <2020-03-26> :
--	- Add mode parameter.
--
-- [== Example ==]
--
--EXEC SetAccessDevice N'YSP1UVPHWJ', N'edl', N'EDL-C2019100002' -- Reset
--EXEC SetAccessDevice N'YSP1UVPHWJ', N'edl', N'EDL-C2019100002', N'D0001' -- Change
--EXEC SetAccessDevice N'YSP1UVPHWJ', N'customer', N'EDL-C2019100002' -- Reset
--EXEC SetAccessDevice N'YSP1UVPHWJ', N'customer', N'EDL-C2019100002', N'D0001' -- Change
--EXEC SetAccessDevice N'YSP1UVPHWJ', N'device', N'EDL-C2019100002' -- Reset
--EXEC SetAccessDevice N'YSP1UVPHWJ', N'device', N'EDL-C2019100002', N'D0001' -- Change
-- =============================================
CREATE PROCEDURE [dbo].[SetAccessDevice]
(
  @accessId nvarchar(30)
, @mode nvarchar(30)  
, @customerId nvarchar(30)
, @deviceId nvarchar(30) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iCnt int = 0;
    -- Error Code:
    --    0 : Success
	-- 4601 : Access Id cannot be null or empty string.
	-- 4602 : Customer Id cannot be null or empty string.
	-- 4603 : Access Id not found.
	-- 4604 : Device Id not found.
    -- 4605 : mode cannot be null or empty string.
    -- 4606 : invalid mode.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@accessId) = 1)
		BEGIN
            -- Access Id cannot be null or empty string.
            EXEC GetErrorMsg 4601, @errNum out, @errMsg out
			RETURN
		END

        IF (dbo.IsNullOrEmpty(@mode) = 1)
		BEGIN
            -- mode cannot be null or empty string.
            EXEC GetErrorMsg 4605, @errNum out, @errMsg out
			RETURN
        END

		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
            -- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 4602, @errNum out, @errMsg out
			RETURN
		END

        IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
            SELECT @iCnt = COUNT(*)
            FROM DeviceAccess
            WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
              AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
        END
        ELSE
        BEGIN
            -- invalid mode.
            EXEC GetErrorMsg 4606, @errNum out, @errMsg out
			RETURN
        END

		IF (@iCnt = 0)
		BEGIN
            -- Access Id not found.
            EXEC GetErrorMsg 4603, @errNum out, @errMsg out
			RETURN
		END

        IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
            IF (@deviceId IS NULL)
            BEGIN
                UPDATE DeviceAccess
                SET DeviceId = NULL
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
                  AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
            END
            ELSE
            BEGIN
                SELECT @iCnt = COUNT(*)
                FROM Device
                WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
                AND UPPER(LTRIM(RTRIM(DeviceId))) = UPPER(LTRIM(RTRIM(@deviceId)))
                IF (@iCnt = 0)
                BEGIN
                    -- Device Id not found.
                    EXEC GetErrorMsg 4604, @errNum out, @errMsg out
                    RETURN
                END
                UPDATE DeviceAccess
                SET DeviceId = UPPER(LTRIM(RTRIM(@deviceId)))
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
                  AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
            END
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
