SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveOrgML.
-- Description:	Save Organization (ML).
-- [== History ==]
-- <2016-06-07> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveOrgML N'EDL-C2017060005', N'O0013', N'TH', N'ฝ่ายบริการ'
--exec SaveOrgML N'EDL-C2017060005', N'O0013', N'JA', N'サービス部門'
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrgML] (
  @customerId as nvarchar(30)
, @orgId as nvarchar(30)
, @langId as nvarchar(3)
, @orgName as nvarchar(80)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iLangCnt int = 0;
DECLARE @iOrgCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1209 : Lang Id cannot be null or empty string.
	-- 1210 : Lang Id not found.
	-- 1211 : Customer Id cannot be null or empty string.
	-- 1212 : Customer Id not found.
	-- 1213 : Org Id cannot be null or empty string.
	-- 1214 : No Org match Org Id in specificed Customer Id.
	-- 1215 : Org Name (ML) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1209, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 1210, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1211, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1212, @errNum out, @errMsg out
			RETURN
		END

		/* Check if Org id is not null. */
		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- Org Id cannot be null or empty string.
            EXEC GetErrorMsg 1213, @errNum out, @errMsg out
			RETURN
		END

		/* Check OrgId is in Org table */ 
		SELECT @iOrgCnt = COUNT(*)
		  FROM Org
		 WHERE UPPER(RTRIM(LTRIM(OrgId))) = UPPER(RTRIM(LTRIM(@orgId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iOrgCnt = 0)
		BEGIN
			-- No Org match Org Id in specificed Customer Id.
            EXEC GetErrorMsg 1214, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iOrgCnt = COUNT(*)
		  FROM OrgML
		 WHERE UPPER(RTRIM(LTRIM(OrgId))) <> UPPER(RTRIM(LTRIM(@orgId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(OrgName))) = UPPER(RTRIM(LTRIM(@orgName)));
		IF (@iOrgCnt <> 0)
		BEGIN
			-- Org Name (ML) already exists.
            EXEC GetErrorMsg 1215, @errNum out, @errMsg out
			RETURN
		END

		SET @iOrgCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iOrgCnt = COUNT(*)
		  FROM OrgML
		 WHERE UPPER(RTRIM(LTRIM(OrgId))) = UPPER(RTRIM(LTRIM(@orgId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))

		IF (@iOrgCnt = 0)
		BEGIN
			INSERT INTO OrgML
			(
				  CustomerId
				, OrgId
				, LangId
				, OrgName
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@orgId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@orgName))
			);
		END
		ELSE
		BEGIN
			UPDATE OrgML
			   SET OrgName = RTRIM(LTRIM(@orgName))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(OrgId))) = UPPER(RTRIM(LTRIM(@orgId)))
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
