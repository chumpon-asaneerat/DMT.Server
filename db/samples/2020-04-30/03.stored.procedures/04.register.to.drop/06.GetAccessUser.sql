SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetAccessUser.
-- Description:	Get Access User.
-- [== History ==]
-- <2018-05-25> :
--	- Stored Procedure Created.
-- <2019-12-19> :
--	- Add EDLCustomerId in result.
-- <2020-03-26> :
--	- Add mode parameter.
--
-- [== Example ==]
--
--EXEC GetAccessUser N'TH', N'YSP1UVPHWJ', N'edl';
--EXEC GetAccessUser N'TH', N'YSP1UVPHWJ', N'customer';
--EXEC GetAccessUser N'TH', N'YSP1UVPHWJ', N'device';
-- =============================================
CREATE PROCEDURE [dbo].[GetAccessUser]
(
  @langId nvarchar(3)
, @accessId nvarchar(30)
, @mode nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @customerId nvarchar(30);
DECLARE @iCnt int = 0;
    -- Error Code:
    --    0 : Success
	-- 2303 : Lang Id cannot be null or empty string.
	-- 2304 : Lang Id not found.
	-- 2305 : Access Id cannot be null or empty string.
	-- 2306 : Access Id not found.
    -- 2309 : mode cannot be null or empty string.
    -- 2310 : invalid mode.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
            -- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 2303, @errNum out, @errMsg out
			RETURN
		END

        IF (dbo.IsNullOrEmpty(@mode) = 1)
		BEGIN
            -- mode cannot be null or empty string.
            EXEC GetErrorMsg 2309, @errNum out, @errMsg out
			RETURN
        END

		SELECT @iCnt = COUNT(*)
		  FROM LanguageView
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))
		IF (@iCnt IS NULL OR @iCnt = 0)
		BEGIN
            -- Lang Id not found.
            EXEC GetErrorMsg 2304, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@accessId) = 1)
		BEGIN
            -- Access Id cannot be null or empty string.
            EXEC GetErrorMsg 2305, @errNum out, @errMsg out
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
            EXEC GetErrorMsg 2306, @errNum out, @errMsg out
			RETURN
		END

        IF (UPPER(LTRIM(RTRIM(@mode))) = 'EDL')
        BEGIN
			SELECT /*A.AccessId
				 , */A.CustomerId
				 , N'EDL Co., Ltd.' AS CustomerName
				 , A.MemberId
                 , NULL AS DeviceId
				 , B.FullName
				 , B.IsEDLUser
				 , B.MemberType
				 , D.MemberTypeDescription
			  FROM EDLAccess A
			     , LogInView B
				 --, CustomerMLView C
				 , MemberTypeMLView D
			 WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
			   AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
			   And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
			   --AND UPPER(LTRIM(RTRIM(C.CustomerId))) = UPPER(LTRIM(RTRIM(A.CustomerId)))
			   --AND UPPER(LTRIM(RTRIM(C.LangId))) = UPPER(LTRIM(RTRIM(B.LangId)))
			   AND UPPER(LTRIM(RTRIM(D.LangId))) = UPPER(LTRIM(RTRIM(B.LangId)))
			   AND B.MemberType = D.MemberTypeId
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'CUSTOMER')
        BEGIN
			SELECT /*A.AccessId
				 , */A.CustomerId
				 , C.CustomerName
				 , A.MemberId
                 , NULL AS DeviceId
				 , B.FullName
				 , B.IsEDLUser
				 , B.MemberType
				 , D.MemberTypeDescription
			  FROM CustomerAccess A
			     , LogInView B
				 , CustomerMLView C
				 , MemberTypeMLView D
			 WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
			   AND UPPER(LTRIM(RTRIM(B.CustomerId))) = UPPER(LTRIM(RTRIM(A.CustomerId)))
			   AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
			   And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
			   AND UPPER(LTRIM(RTRIM(C.CustomerId))) = UPPER(LTRIM(RTRIM(A.CustomerId)))
			   AND UPPER(LTRIM(RTRIM(C.LangId))) = UPPER(LTRIM(RTRIM(B.LangId)))
			   AND UPPER(LTRIM(RTRIM(D.LangId))) = UPPER(LTRIM(RTRIM(B.LangId)))
			   AND B.MemberType = D.MemberTypeId
        END
        ELSE IF (UPPER(LTRIM(RTRIM(@mode))) = 'DEVICE')
        BEGIN
			SELECT /*A.AccessId
				 , */A.CustomerId
				 , C.CustomerName
				 , A.MemberId
                 , A.DeviceId
				 , B.FullName
				 , B.IsEDLUser
				 , B.MemberType
				 , D.MemberTypeDescription
			  FROM DeviceAccess A
			     , LogInView B
				 , CustomerMLView C
				 , MemberTypeMLView D
			 WHERE UPPER(LTRIM(RTRIM(AccessId))) = UPPER(LTRIM(RTRIM(@accessId)))
			   AND UPPER(LTRIM(RTRIM(B.CustomerId))) = UPPER(LTRIM(RTRIM(A.CustomerId)))
			   AND UPPER(LTRIM(RTRIM(B.MemberId))) = UPPER(LTRIM(RTRIM(A.MemberId)))
			   And UPPER(LTRIM(RTRIM(B.LangId))) = UPPER(LTRIM(RTRIM(@langId)))
			   AND UPPER(LTRIM(RTRIM(C.CustomerId))) = UPPER(LTRIM(RTRIM(A.CustomerId)))
			   AND UPPER(LTRIM(RTRIM(C.LangId))) = UPPER(LTRIM(RTRIM(B.LangId)))
			   AND UPPER(LTRIM(RTRIM(D.LangId))) = UPPER(LTRIM(RTRIM(B.LangId)))
			   AND B.MemberType = D.MemberTypeId
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
