SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveUserInfo.
-- Description:	Save User Information.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Fixed Logic to check duplicated Prefix - FirstName- LastName.
--	- Fixed Logic to check duplicated UserName.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveUserInfo N'The', N'EDL', N'Administrator', N'raterweb2-admin@edl.co.th', N'1234', 100
--exec SaveUserInfo N'Mr.', N'Chumpon', N'Asaneerat', N'chumpon@edl.co.th', N'1234', 100
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserInfo] (
  @prefix as nvarchar(10)
, @firstName as nvarchar(40)
, @lastName as nvarchar(50)
, @userName as nvarchar(50)
, @passWord as nvarchar(20)
, @memberType as int = 100
, @userId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iUsrCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 501 : FirstName (default) cannot be null or empty string.
	-- 502 : UserName cannot be null or empty string.
	-- 503 : Password cannot be null or empty string.
	-- 504 : User Full Name (default) already exists.
	-- 505 : UserName already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@firstName) = 1)
		BEGIN
            -- FirstName (default) cannot be null or empty string.
            EXEC GetErrorMsg 501, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@userName) = 1)
		BEGIN
			-- UserName cannot be null or empty string.
            EXEC GetErrorMsg 502, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@passWord) = 1)
		BEGIN
			-- Password cannot be null or empty string.
            EXEC GetErrorMsg 503, @errNum out, @errMsg out
			RETURN
		END

		/* Check Prefix, FirstName, LastName exists */
		IF (@userId IS NOT NULL)
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
				FROM UserInfo
				WHERE LOWER(UserId) <> LOWER(RTRIM(LTRIM(@userId)))
				  AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
				  AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
				  AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))
		END
		ELSE
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
				FROM UserInfo
				WHERE LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
				  AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
				  AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))
		END

		IF @iUsrCnt <> 0
		BEGIN
            -- User Full Name (default) already exists.
			EXEC GetErrorMsg 504, @errNum out, @errMsg out
			RETURN;
		END

		SET @iUsrCnt = 0; -- Reset Counter.

		/* Check UserName exists */
		IF (@userId IS NOT NULL)
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
				FROM UserInfo
				WHERE LOWER(UserId) <> LOWER(RTRIM(LTRIM(@userId)))
				  AND LOWER(RTRIM(LTRIM(UserName))) = LOWER(RTRIM(LTRIM(@userName)))
		END
		ELSE
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
				FROM UserInfo
				WHERE LOWER(RTRIM(LTRIM(UserName))) = LOWER(RTRIM(LTRIM(@userName)))
		END

		IF @iUsrCnt <> 0
		BEGIN
			-- UserName already exists.
            EXEC GetErrorMsg 505, @errNum out, @errMsg out
			RETURN;
		END

		SET @iUsrCnt = 0; -- Reset Counter.

		IF dbo.IsNullOrEmpty(@userId) = 1
		BEGIN
			EXEC NextMasterPK N'UserInfo'
							, @userId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iUsrCnt = COUNT(*)
			  FROM UserInfo
			 WHERE LOWER(UserId) = LOWER(RTRIM(LTRIM(@userId)))
		END

		IF @iUsrCnt = 0
		BEGIN
			INSERT INTO USERINFO
			(
				  UserId
				, MemberType
				, Prefix
				, FirstName
				, LastName
				, UserName
				, [Password]
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@userId))
				, @memberType
				, RTRIM(LTRIM(@prefix))
				, RTRIM(LTRIM(@firstName))
				, RTRIM(LTRIM(@lastName))
				, RTRIM(LTRIM(@userName))
				, RTRIM(LTRIM(@passWord))
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE UserInfo
			   SET Prefix = RTRIM(LTRIM(@prefix))
			     , FirstName = RTRIM(LTRIM(@firstName))
				 , LastName = RTRIM(LTRIM(@lastName))
				 , UserName = RTRIM(LTRIM(@userName))
				 , [Password] = RTRIM(LTRIM(@passWord))
				 , MemberType = @memberType
			 WHERE LOWER(UserId) = LOWER(RTRIM(LTRIM(@userId)))
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
