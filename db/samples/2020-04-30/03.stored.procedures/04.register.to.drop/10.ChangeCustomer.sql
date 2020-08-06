SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Change Customer.
-- Description:	Change Customer.
-- [== History ==]
-- <2019-12-19> :
--	- Stored Procedure Created.
-- <2020-03-26> :
--	- Add mode parameter.
--
-- [== Example ==]
--
--EXEC ChangeUser N'YSP1UVPHWJ', N'edl'; -- Reset
--EXEC ChangeUser N'YSP1UVPHWJ', N'edl' N'EDL-C2019100002'; -- Change
--EXEC ChangeUser N'YSP1UVPHWJ', N'customer'; -- Reset
--EXEC ChangeUser N'YSP1UVPHWJ', N'customer' N'EDL-C2019100002'; -- Change
--EXEC ChangeUser N'YSP1UVPHWJ', N'device'; -- Reset
--EXEC ChangeUser N'YSP1UVPHWJ', N'edldevice' N'EDL-C2019100002'; -- Change
-- =============================================
CREATE PROCEDURE [dbo].[ChangeCustomer]
(
  @accessId nvarchar(30)
, @mode nvarchar(30)  
, @customerId nvarchar(30) = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iCnt int = 0;
    -- Error Code:
    --    0 : Success
	-- 4501 : Access Id cannot be null or empty string.
	-- 4502 : Access Id not found.
	-- 4503 : Customer Id not found.
    -- 4504 : mode cannot be null or empty string.
    -- 4505 : invalid mode.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@accessId) = 1)
		BEGIN
            -- Access Id cannot be null or empty string.
            EXEC GetErrorMsg 4501, @errNum out, @errMsg out
			RETURN
		END

        IF (dbo.IsNullOrEmpty(@mode) = 1)
		BEGIN
            -- mode cannot be null or empty string.
            EXEC GetErrorMsg 4504, @errNum out, @errMsg out
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
            EXEC GetErrorMsg 4505, @errNum out, @errMsg out
			RETURN
        END

		IF (@iCnt = 0)
		BEGIN
            -- Access Id not found.
            EXEC GetErrorMsg 4502, @errNum out, @errMsg out
			RETURN
		END

        IF (UPPER(LTRIM(RTRIM(@mode))) = 'EDL')
        BEGIN
            IF (@customerId IS NULL)
            BEGIN
                UPDATE EDLAccess
                SET CustomerId = NULL
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
            END
            ELSE
            BEGIN
                SELECT @iCnt = COUNT(*)
                FROM Customer
                WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))

                IF (@iCnt = 0)
                BEGIN
                    -- Customer Id not found.
                    EXEC GetErrorMsg 4503, @errNum out, @errMsg out
                    RETURN
                END
                UPDATE EDLAccess
                SET CustomerId = UPPER(LTRIM(RTRIM(@customerId)))
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
            END
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'CUSTOMER')
        BEGIN
            IF (@customerId IS NULL)
            BEGIN
                UPDATE CustomerAccess
                SET CustomerId = NULL
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
            END
            ELSE
            BEGIN
                SELECT @iCnt = COUNT(*)
                FROM Customer
                WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))

                IF (@iCnt = 0)
                BEGIN
                    -- Customer Id not found.
                    EXEC GetErrorMsg 4503, @errNum out, @errMsg out
                    RETURN
                END
                UPDATE CustomerAccess
                SET CustomerId = UPPER(LTRIM(RTRIM(@customerId)))
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
            END
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
            IF (@customerId IS NULL)
            BEGIN
                UPDATE DeviceAccess
                SET CustomerId = NULL
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
            END
            ELSE
            BEGIN
                SELECT @iCnt = COUNT(*)
                FROM Customer
                WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))

                IF (@iCnt = 0)
                BEGIN
                    -- Customer Id not found.
                    EXEC GetErrorMsg 4503, @errNum out, @errMsg out
                    RETURN
                END
                UPDATE DeviceAccess
                SET CustomerId = UPPER(LTRIM(RTRIM(@customerId)))
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)));
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
