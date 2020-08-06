SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SignIn
-- [== History ==]
-- <2016-12-15> :
--	- Stored Procedure Created.
-- <2016-12-16> :
--	- Add returns langId column.
--	- Change CustomerId to customerId.
--	- Change MemberId to memberId.
-- <2018-05-21> :
--	- Add returns columns CustomerNameEN and CustomerNameNative.
-- <2018-05-24> :
--	- Remove langId parameter.
--  - Add accessId out parameter.
-- <2018-05-25> :
--  - Update Code insert/update access id to ClientAccess table.
--  - Remove customerId checks in case EDL User.
-- <2020-03-26> :
--	- Add mode parameter.
--
-- [== Example ==]
--
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'edl';
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'edl';
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'edl';

--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'customer';
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'customer';
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'customer';

--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'device';
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'device';
--exec SignIn N'admin@umi.co.th', N'1234', N'EDL-C2017010002' N'device';
-- =============================================
CREATE PROCEDURE [dbo].[SignIn] (
  @userName nvarchar(50) = null
, @passWord nvarchar(20) = null
, @customerId nvarchar(30) = null
, @mode nvarchar(30) = null
, @accessId nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iUsrCnt int = 0;
DECLARE @iCnt int = 0;
DECLARE @memberId nvarchar(30);
    -- Error Code:
    --    0 : Success
	-- 1901 : User Name cannot be null or empty string.
	-- 1902 : Password cannot be null or empty string.
	-- 1903 : Cannot found User that match information.
	-- 1904 : mode cannot be null or empty string.
    -- 1905 : invalid mode.
    -- OTHER : SQL Error Number & Error Message.
    BEGIN TRY
		IF (dbo.IsNullOrEmpty(@userName) = 1)
		BEGIN
            -- User Name cannot be null or empty string.
            EXEC GetErrorMsg 1901, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@passWord) = 1)
		BEGIN
            -- Password cannot be null or empty string.
            EXEC GetErrorMsg 1902, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			SELECT @memberId = MemberId, @iUsrCnt = COUNT(*)
			  FROM LogInView
			 WHERE LTRIM(RTRIM(UserName)) = LTRIM(RTRIM(@userName))
			   AND LTRIM(RTRIM(PassWord)) = LTRIM(RTRIM(@passWord))
			   AND UPPER(LTRIM(RTRIM(LangId))) = N'EN'
			 GROUP BY MemberId;
		END
		ELSE
		BEGIN
			SELECT @memberId = MemberId, @iUsrCnt = COUNT(*)
			  FROM LogInView
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND LTRIM(RTRIM(UserName)) = LTRIM(RTRIM(@userName))
			   AND LTRIM(RTRIM(PassWord)) = LTRIM(RTRIM(@passWord))
			   AND UPPER(LTRIM(RTRIM(LangId))) = N'EN'
			 GROUP BY MemberId;
		END

		IF (dbo.IsNullOrEmpty(@mode) = 1)
		BEGIN
            -- mode cannot be null or empty string.
            EXEC GetErrorMsg 1904, @errNum out, @errMsg out
			RETURN
		END

		IF (@iUsrCnt = 0)
		BEGIN
            -- Cannot found User that match information.
            EXEC GetErrorMsg 1903, @errNum out, @errMsg out
			RETURN
		END

        IF (UPPER(LTRIM(RTRIM(@mode))) = 'EDL')
        BEGIN
            -- FOR EDL ACCESS (CLIENT APP)
            SELECT @accessId = AccessId, @iCnt = COUNT(*)
              FROM EDLAccess
             WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
               AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(@memberId)))
             GROUP BY AccessId

            -- Keep data into session.
            IF (@iCnt = 0)
            BEGIN
                -- NOT EXIST.
                EXEC GetRandomCode 10, @accessId out; -- Generate 10 Chars Unique Id.
                INSERT INTO EDLAccess
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
                UPDATE EDLAccess
                   SET CustomerId = UPPER(LTRIM(RTRIM(@customerId)))
                     , MemberId = UPPER(LTRIM(RTRIM(@memberId)))
                 WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
            END
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'CUSTOMER')
        BEGIN
            -- FOR CUSTOMER ACCESS (CLIENT APP)
            SELECT @accessId = AccessId, @iCnt = COUNT(*)
              FROM CustomerAccess
             WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
               AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(@memberId)))
             GROUP BY AccessId

            -- Keep data into session.
            IF (@iCnt = 0)
            BEGIN
                -- NOT EXIST.
                EXEC GetRandomCode 10, @accessId out; -- Generate 10 Chars Unique Id.
                INSERT INTO CustomerAccess
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
                UPDATE CustomerAccess
                   SET CustomerId = UPPER(LTRIM(RTRIM(@customerId)))
                     , MemberId = UPPER(LTRIM(RTRIM(@memberId)))
                 WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
            END
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
            -- FOR CUSTOMER ACCESS (DEVICE APP)
            SELECT @accessId = AccessId, @iCnt = COUNT(*)
              FROM DeviceAccess
             WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
               AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(@memberId)))
             GROUP BY AccessId

            -- Keep data into session.
            IF (@iCnt = 0)
            BEGIN
                -- NOT EXIST.
                EXEC GetRandomCode 10, @accessId out; -- Generate 10 Chars Unique Id.
                INSERT INTO DeviceAccess
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
                UPDATE DeviceAccess
                   SET CustomerId = UPPER(LTRIM(RTRIM(@customerId)))
                     , MemberId = UPPER(LTRIM(RTRIM(@memberId)))
                 WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
            END
        END
        ELSE
        BEGIN
            -- invalid mode.
            EXEC GetErrorMsg 1905, @errNum out, @errMsg out
			RETURN
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
