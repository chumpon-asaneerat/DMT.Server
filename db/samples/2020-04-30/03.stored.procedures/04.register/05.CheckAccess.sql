SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: CheckAccess.
-- Description:	Check Access.
-- [== History ==]
-- <2018-05-25> :
--	- Stored Procedure Created.
-- <2019-12-19> :
--	- Add EDLCustomerId column in result.
-- <2020-03-26> :
--	- Add mode parameter.
--
-- [== Example ==]
--
--EXEC CheckAccess N'YSP1UVPHWJ', N'edl';
--EXEC CheckAccess N'YSP1UVPHWJ', N'customer';
--EXEC CheckAccess N'YSP1UVPHWJ', N'device';
-- =============================================
CREATE PROCEDURE [dbo].[CheckAccess]
(
  @accessId nvarchar(30)
, @mode nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @langId nvarchar(3) = N'EN';
DECLARE @customerId nvarchar(30);
DECLARE @iCnt int = 0;
    -- Error Code:
    --    0 : Success
	-- 2301 : Access Id cannot be null or empty string.
	-- 2302 : Access Id not found.
    -- 2309 : mode cannot be null or empty string.
    -- 2310 : invalid mode.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@accessId) = 1)
		BEGIN
            -- Access Id cannot be null or empty string.
            EXEC GetErrorMsg 2301, @errNum out, @errMsg out
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
            SELECT @customerId = CustomerId, @iCnt = COUNT(*)
              FROM EDLAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
             GROUP BY CustomerId;
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'CUSTOMER')
        BEGIN
            SELECT @customerId = CustomerId, @iCnt = COUNT(*)
              FROM CustomerAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
             GROUP BY CustomerId;
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
            SELECT @customerId = CustomerId, @iCnt = COUNT(*)
              FROM DeviceAccess
             WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
             GROUP BY CustomerId;
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
            EXEC GetErrorMsg 2302, @errNum out, @errMsg out
			RETURN
		END

        IF (UPPER(LTRIM(RTRIM(@mode))) = 'EDL')
        BEGIN
            IF (@customerId IS NULL)
            BEGIN
                SELECT A.AccessId
                     , B.CustomerId
                     , A.MemberId
                     , A.CreateDate
                     , NULL AS DeviceId
                     , B.MemberType
                     , B.IsEDLUser
                 FROM EDLAccess A, LogInView B
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
                  AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
                  And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
            END
            ELSE
            BEGIN
                SELECT A.AccessId
                     , A.CustomerId
                     , A.MemberId
                     , A.CreateDate
                     , NULL AS DeviceId
                     , B.MemberType
                     , B.IsEDLUser
                 FROM EDLAccess A, LogInView B
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
                  AND UPPER(LTRIM(RTRIM(B.CustomerId))) = UPPER(LTRIM(RTRIM(A.CustomerId)))
                  AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
                  And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
            END
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'CUSTOMER')
        BEGIN
            IF (@customerId IS NULL)
            BEGIN
                SELECT A.AccessId
                     , B.CustomerId
                     , A.MemberId
                     , A.CreateDate
                     , NULL AS DeviceId
                     , B.MemberType
                     , B.IsEDLUser
                 FROM CustomerAccess A, LogInView B
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
                  AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
                  And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
            END
            ELSE
            BEGIN
                SELECT A.AccessId
                     , A.CustomerId
                     , A.MemberId
                     , A.CreateDate
                     , NULL AS DeviceId
                     , B.MemberType
                     , B.IsEDLUser
                 FROM CustomerAccess A, LogInView B
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
                  AND UPPER(LTRIM(RTRIM(B.CustomerId))) = UPPER(LTRIM(RTRIM(A.CustomerId)))
                  AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
                  And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
            END
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
            IF (@customerId IS NULL)
            BEGIN
                SELECT A.AccessId
                     , B.CustomerId
                     , A.MemberId
                     , A.CreateDate
                     , A.DeviceId
                     , B.MemberType
                     , B.IsEDLUser
                 FROM DeviceAccess A, LogInView B
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
                  AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
                  And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
            END
            ELSE
            BEGIN
                SELECT A.AccessId
                     , A.CustomerId
                     , A.MemberId
                     , A.CreateDate
                     , A.DeviceId
                     , B.MemberType
                     , B.IsEDLUser
                 FROM DeviceAccess A, LogInView B
                WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
                  AND UPPER(LTRIM(RTRIM(B.CustomerId))) = UPPER(LTRIM(RTRIM(A.CustomerId)))
                  AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
                  And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
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
