SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseType.
-- Description:	Save License Type.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLicenseType N'3 Months', N'Save 40%', 2, 3, 50000, N'$', N'USD'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseType] (
  @description as nvarchar(100) = null
, @adText as nvarchar(MAX) = null
, @periodUnitId as int = null
, @numberOfUnit as int = null
, @price as decimal(18, 2) = null
, @currSymbol as nvarchar(5)
, @currText as nvarchar(20)
, @licenseTypeId as int = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @vlicenseTypeId int;
DECLARE @iCnt int;
	-- Error Code:
	--   0 : Success
	-- 601 : Description (default) cannot be null or empty string.
	-- 602 : Advertise Text (default) cannot be null or empty string.
	-- 603 : PeriodUnitId cannot be null.
	-- 604 : PeriodUnitId not found.
	-- 605 : Number of Period cannot be null.
	-- 606 : Price cannot be null.
	-- 607 : Cannot add new item description because the description (default) is duplicated.
	-- 608 : Cannot change item description because the description (default) is duplicated.
	-- 609 : Cannot add new item because the period and number of period is duplicated.
    -- 610 : Cannot change item because the period and number of period is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (default) cannot be null or empty string.
            EXEC GetErrorMsg 601, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@adText) = 1)
		BEGIN
			-- Advertise Text (default) cannot be null or empty string.
            EXEC GetErrorMsg 602, @errNum out, @errMsg out
			RETURN
		END

		IF (@periodUnitId IS NULL)
		BEGIN
			-- PeriodUnitId cannot be null.
            EXEC GetErrorMsg 603, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM PeriodUnit
		 WHERE PeriodUnitId = @periodUnitId;
		IF (@iCnt = 0)
		BEGIN
			-- PeriodUnitId not found.
            EXEC GetErrorMsg 604, @errNum out, @errMsg out
			RETURN
		END

		IF (@numberOfUnit IS NULL)
		BEGIN
			-- Number of Period cannot be null.
            EXEC GetErrorMsg 605, @errNum out, @errMsg out
			RETURN
		END

		IF (@price IS NULL)
		BEGIN
			-- Price cannot be null.
            EXEC GetErrorMsg 606, @errNum out, @errMsg out
			RETURN
		END

		IF (@licenseTypeId IS NULL)
		BEGIN
			-- Detected Data not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iCnt <> 0)
			BEGIN
				-- Cannot add new item description because the description (default) is duplicated.
                EXEC GetErrorMsg 607, @errNum out, @errMsg out
				RETURN
			END
			/*
			-- Check is PeriodUnitId and NumberOfUnit is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE PeriodUnitId = @periodUnitId
			   AND NumberOfUnit = @numberOfUnit;

			IF (@iCnt >= 1)
			BEGIN
				-- Cannot add new item because the period and number of period is duplicated.
                EXEC GetErrorMsg 609, @errNum out, @errMsg out
				RETURN
			END
			*/
		END
		ELSE
		BEGIN
			-- Detected Data is exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS
			   AND LicenseTypeId <> @licenseTypeId;

			IF (@iCnt <> 0)
			BEGIN
				-- Cannot change item description because the description (default) is duplicated.
                EXEC GetErrorMsg 608, @errNum out, @errMsg out
				RETURN
			END
			/*
			-- Check is PeriodUnitId and NumberOfUnit is duplicated?.
			SELECT @iCnt = COUNT(*)
			  FROM [dbo].[LicenseType]
			 WHERE PeriodUnitId = @periodUnitId
			   AND NumberOfUnit = @numberOfUnit
			   AND LicenseTypeId <> @licenseTypeId;

			IF (@iCnt >= 1)
			BEGIN
				-- Cannot change item because the period and number of period is duplicated.
                EXEC GetErrorMsg 610, @errNum out, @errMsg out
				RETURN
			END
			*/
		END

		IF (@licenseTypeId IS NULL)
		BEGIN
			SELECT @vlicenseTypeId = (MAX([LicenseTypeId]) + 1)
			  FROM [dbo].[LicenseType];

			INSERT INTO [dbo].[LicenseType]
			(
				 LicenseTypeId
			   , Description
			   , AdText
			   , PeriodUnitId
			   , NumberOfUnit
			   , Price
			   , CurrencySymbol
			   , CurrencyText
			)
			VALUES
			(
			     @vlicenseTypeId
			   , LTRIM(RTRIM(@description))
			   , LTRIM(RTRIM(@adText))
			   , @periodUnitId
			   , @numberOfUnit
			   , @price
			   , COALESCE(@currSymbol, '$')
			   , COALESCE(@currText, 'USD')
			);
		END
		ELSE
		BEGIN
			SET @vlicenseTypeId = @licenseTypeId;

			UPDATE [dbo].[LicenseType]
			   SET [Description] = LTRIM(RTRIM(@description))
			     , AdText = LTRIM(RTRIM(COALESCE(@adText, AdText)))
				 , PeriodUnitId = COALESCE(@periodUnitId, NumberOfUnit)
				 , NumberOfUnit = COALESCE(@numberOfUnit, NumberOfUnit)
				 , Price = COALESCE(@price, Price)
				 , CurrencySymbol = COALESCE(@currSymbol, CurrencySymbol)
				 , CurrencyText = COALESCE(@currText, CurrencyText)
			 WHERE LicenseTypeId = @vlicenseTypeId;
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
