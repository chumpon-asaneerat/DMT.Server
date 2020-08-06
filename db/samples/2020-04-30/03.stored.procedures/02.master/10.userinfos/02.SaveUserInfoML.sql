SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	SaveUserInfo.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--	- change language id from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec SaveUserInfoML N'EDL-U20170607001', N'TH', N'The', N'EDL', N'Administrator'
-- =============================================
CREATE PROCEDURE [dbo].[SaveUserInfoML] (
  @userId as nvarchar(30)
, @langId as nvarchar(3)
, @prefix as nvarchar(10)
, @firstName as nvarchar(40)
, @lastName as nvarchar(50)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iUsrCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 506 : Language Id cannot be null or empty string.
	-- 507 : The Language Id not exist.
	-- 508 : User Id cannot be null or empty string.
	-- 509 : FirstName (ML) cannot be null or empty string.
	-- 510 : No User match UserId.
	-- 511 : User Full Name (ML) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 506, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- The Language Id not exist.
            EXEC GetErrorMsg 507, @errNum out, @errMsg out
			RETURN
		END

		/* Check if user id is not null. */
		IF (dbo.IsNullOrEmpty(@userId) = 1)
		BEGIN
			-- User Id cannot be null or empty string.
            EXEC GetErrorMsg 508, @errNum out, @errMsg out
			RETURN
		END

		/* Check has first name (required by table constrain). */
		IF (dbo.IsNullOrEmpty(@firstName) = 1)
		BEGIN
			-- FirstName (ML) cannot be null or empty string.
            EXEC GetErrorMsg 509, @errNum out, @errMsg out
			RETURN
		END
		/* Check UserId is in UserInfo table */ 
		SELECT @iUsrCnt = COUNT(*)
			FROM UserInfo
		   WHERE UPPER(RTRIM(LTRIM(UserId))) = UPPER(RTRIM(LTRIM(@userId)))
		IF @iUsrCnt = 0
		BEGIN
			-- No User match UserId.
            EXEC GetErrorMsg 510, @errNum out, @errMsg out
			RETURN
		END

		/* Check Prefix, FirstName, LastName exists */
		SELECT @iUsrCnt = COUNT(*)
			FROM UserInfoML
			WHERE UPPER(LangId) = UPPER(RTRIM(LTRIM(@langId)))
			  AND LOWER(UserId) <> LOWER(RTRIM(LTRIM(@userId)))
			  AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
			  AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
			  AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))

		IF @iUsrCnt <> 0
		BEGIN
			-- User Full Name (ML) already exists.
            EXEC GetErrorMsg 511, @errNum out, @errMsg out
			RETURN;
		END

		SET @iUsrCnt = 0; -- Reset Counter.

		/* check is need to insert or update? */
		SELECT @iUsrCnt = COUNT(*)
			FROM UserInfoML
		   WHERE UPPER(RTRIM(LTRIM(UserId))) = UPPER(RTRIM(LTRIM(@userId)))
			 AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));

		IF @iUsrCnt = 0
		BEGIN
			INSERT INTO UserInfoML
			(
				  UserId
				, LangId
				, Prefix
				, FirstName
				, LastName
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@userId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@prefix))
				, RTRIM(LTRIM(@firstName))
				, RTRIM(LTRIM(@lastName))
			);
		END
		ELSE
		BEGIN
			UPDATE UserInfoML
			   SET Prefix = RTRIM(LTRIM(@prefix))
			     , FirstName = RTRIM(LTRIM(@firstName))
				 , LastName = RTRIM(LTRIM(@lastName))
		     WHERE UPPER(RTRIM(LTRIM(UserId))) = UPPER(RTRIM(LTRIM(@userId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
