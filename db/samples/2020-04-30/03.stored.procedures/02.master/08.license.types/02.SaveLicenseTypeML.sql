SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseTypeML.
-- Description:	Save License Type ML.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLicenseTypeML 5, N'TH', N'ทดลองใช้งาน', N'ทดลองใช้งานราคาประหยัด', 599, N'฿', N'บาท'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseTypeML] (
  @licenseTypeId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(100) = null
, @adText as nvarchar(MAX) = null
, @price as decimal(18, 2) = null
, @currSymbol as nvarchar(5) = null
, @currText as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int;
	-- Error Code:
	--   0 : Success
	-- 611 : LicenseTypeId cannot be null.
	-- 612 : Language Id cannot be null or empty string.
	-- 613 : Language Id not found.
	-- 614 : Description (ML) cannot be null or empty string.
	-- 615 : Advertise Text (ML) cannot be null or empty string.
	-- 616 : Price (ML) cannot be null.
	-- 617 : Description (ML) is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@licenseTypeId IS NULL)
		BEGIN
			-- LicenseTypeId cannot be null.
            EXEC GetErrorMsg 611, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 612, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iCnt = 0)
		BEGIN
			-- Language Id not found.
            EXEC GetErrorMsg 613, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (ML) cannot be null or empty string.
            EXEC GetErrorMsg 614, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@adText) = 1)
		BEGIN
			-- Advertise Text (ML) cannot be null or empty string.
            EXEC GetErrorMsg 615, @errNum out, @errMsg out
			RETURN
		END

		IF (@price IS NULL)
		BEGIN
			-- Price (ML) cannot be null.
            EXEC GetErrorMsg 616, @errNum out, @errMsg out
			RETURN
		END

		-- Check is description is duplicated?.
		SELECT @iCnt = COUNT(*)
			FROM [dbo].[LicenseTypeML]
			WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
			  AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)))
			  AND LicenseTypeId <> @licenseTypeId;

		IF (@iCnt <> 0)
		BEGIN
			-- Description (ML) is duplicated.
            EXEC GetErrorMsg 617, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LicenseTypeML
		 WHERE UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND [LicenseTypeId] = @licenseTypeId;

		IF (@iCnt = 0)
		BEGIN
			INSERT INTO [dbo].[LicenseTypeML]
			(
				 LicenseTypeId
			   , LangId
			   , Description
			   , AdText
			   , Price
			   , CurrencySymbol
			   , CurrencyText
			)
			VALUES
			(
			     @licenseTypeId
			   , UPPER(RTRIM(LTRIM(@langId)))
			   , LTRIM(RTRIM(@description))
			   , LTRIM(RTRIM(@adText))
			   , @price
			   , @currSymbol
			   , @currText
			);
		END
		ELSE
		BEGIN
			UPDATE [dbo].LicenseTypeML
			   SET [Description] = LTRIM(RTRIM(@description))
			     , AdText = LTRIM(RTRIM(COALESCE(@adText, AdText)))
				 , Price = COALESCE(@price, Price)
				 , CurrencySymbol = COALESCE(@currSymbol, CurrencySymbol)
				 , CurrencyText = COALESCE(@currText, CurrencyText)
			 WHERE LicenseTypeId = @licenseTypeId
			   AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)));
		END

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
