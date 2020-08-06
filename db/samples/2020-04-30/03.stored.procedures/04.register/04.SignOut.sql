SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SignOut.
-- Description:	Sign Out.
-- [== History ==]
-- <2018-05-25> :
--	- Stored Procedure Created.
-- <2020-03-26> :
--	- Add mode parameter.
--
-- [== Example ==]
--
--EXEC SignOut N'YSP1UVPHWJ', N'edl';
--EXEC SignOut N'YSP1UVPHWJ', N'customer';
--EXEC SignOut N'YSP1UVPHWJ', N'device';
-- =============================================
CREATE PROCEDURE [dbo].[SignOut]
(
  @accessId nvarchar(30)
, @mode nvarchar(30)  
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iCnt int = 0;
    -- Error Code:
    --    0 : Success
	-- 2307 : Access Id cannot be null or empty string.
	-- 2308 : Access Id not found.
    -- 2309 : mode cannot be null or empty string.
    -- 2310 : invalid mode.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@accessId) = 1)
		BEGIN
            -- Access Id cannot be null or empty string.
            EXEC GetErrorMsg 2309, @errNum out, @errMsg out
			RETURN
		END

        IF (dbo.IsNullOrEmpty(@mode) = 1)
		BEGIN
            -- mode cannot be null or empty string.
            EXEC GetErrorMsg 2309, @errNum out, @errMsg out
			RETURN
        END

        IF (UPPER(LTRIM(RTRIM(@mode))) = 'EDL')
        BEGIN
            SELECT @iCnt = COUNT(*)
              FROM EDLAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'CUSTOMER')
        BEGIN
            SELECT @iCnt = COUNT(*)
              FROM CustomerAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
            SELECT @iCnt = COUNT(*)
              FROM DeviceAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
        END
        ELSE
        BEGIN
            -- invalid mode.
            EXEC GetErrorMsg 2310, @errNum out, @errMsg out
			RETURN
        END

		IF (@iCnt = 0)
		BEGIN
            -- Access Id not found.
            EXEC GetErrorMsg 2308, @errNum out, @errMsg out
			RETURN
		END

        IF (UPPER(LTRIM(RTRIM(@mode))) = 'EDL')
        BEGIN
            DELETE FROM EDLAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'CUSTOMER')
        BEGIN
            DELETE FROM CustomerAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
            DELETE FROM DeviceAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
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
