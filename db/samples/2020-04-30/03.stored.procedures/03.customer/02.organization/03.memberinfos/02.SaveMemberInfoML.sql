SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveMemberInfoML.
-- Description:	Save Member Information (ML).
-- [== History ==]
-- <2017-06-07> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveMemberInfoML N'EDL-C2017060005', N'M00002', N'TH', N'นาย', N'ชุมพล', N'อัศนีย์รัตน์'
--exec SaveMemberInfoML N'EDL-C2017060005', N'M00002', N'JA', N'氏', N'チュンポン', N'アサニーラット'
--exec SaveMemberInfoML N'EDL-C2017060005', N'M00003', N'TH', N'นาย', N'ธนา', N'โพธิ์จันทร์'
-- =============================================
CREATE PROCEDURE [dbo].[SaveMemberInfoML] (
  @customerId as nvarchar(30)
, @memberId as nvarchar(30)
, @langId as nvarchar(3)
, @prefix as nvarchar(10)
, @firstName as nvarchar(40)
, @lastName as nvarchar(50)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iMemCnt int = 0;
DECLARE @iCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 1101 : CustomerId cannot be null or empty string.
	-- 1102 : Customer Id not found.
	-- 1114 : Lang Id cannot be null or empty string.
	-- 1115 : Lang Id not exist.
	-- 1116 : Member Id cannot be null or empty string.
	-- 1117 : No Member match MemberId in specificed Customer Id.
	-- 1118 : Member Full Name (ML) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1114, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not exist.
            EXEC GetErrorMsg 1115, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1101, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)));
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1102, @errNum out, @errMsg out
			RETURN
		END

		/* Check if branch id is not null. */
		IF (dbo.IsNullOrEmpty(@memberId) = 1)
		BEGIN
			-- Member Id cannot be null or empty string.
            EXEC GetErrorMsg 1116, @errNum out, @errMsg out
			RETURN
		END

		/* Check MemberId is in MemberInfo table */ 
		SELECT @iMemCnt = COUNT(*)
			FROM MemberInfo
		   WHERE UPPER(RTRIM(LTRIM(MemberId))) = UPPER(RTRIM(LTRIM(@memberId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF @iMemCnt = 0
		BEGIN
			-- No Member match MemberId in specificed Customer Id.
            EXEC GetErrorMsg 1117, @errNum out, @errMsg out
			RETURN
		END

		/* Check Prefix, FirstName, LastName exists */
		SELECT @iMemCnt = COUNT(*)
			FROM MemberInfoML
			WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				AND UPPER(LangId) = UPPER(RTRIM(LTRIM(@langId)))
				AND LOWER(MemberId) <> LOWER(RTRIM(LTRIM(@memberId)))
				AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
				AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
				AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))

		IF @iMemCnt <> 0
		BEGIN
			-- Member Full Name (ML) already exists.
            EXEC GetErrorMsg 1118, @errNum out, @errMsg out
			RETURN;
		END

		SET @iMemCnt = 0; -- Reset Counter.

		/* check is need to insert or update? */
		SELECT @iMemCnt = COUNT(*)
			FROM MemberInfoML
		   WHERE UPPER(RTRIM(LTRIM(MemberId))) = UPPER(RTRIM(LTRIM(@memberId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			 AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));

		IF @iMemCnt = 0
		BEGIN
			INSERT INTO MemberInfoML
			(
				  CustomerId
				, MemberId
				, LangId
				, Prefix
				, FirstName
				, LastName
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@memberId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@prefix))
				, RTRIM(LTRIM(@firstName))
				, RTRIM(LTRIM(@lastName))
			);
		END
		ELSE
		BEGIN
			UPDATE MemberInfoML
			   SET Prefix = RTRIM(LTRIM(@prefix))
			     , FirstName = RTRIM(LTRIM(@firstName))
				 , LastName = RTRIM(LTRIM(@lastName))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(MemberId))) = UPPER(RTRIM(LTRIM(@memberId)))
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
