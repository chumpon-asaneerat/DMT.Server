SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseTypeMLView]
AS
	SELECT LTV.LangId
		 , LTV.LicenseTypeId
		 , CASE WHEN (LTML.Description IS NULL OR LTRIM(RTRIM(LTML.Description)) = '') 
		 	THEN
				LTV.LicenseTypeDescription
			ELSE 
				LTML.Description
		  END AS LicenseTypeDescription
		 , CASE 
			WHEN (LTML.AdText IS NULL OR LTRIM(RTRIM(LTML.AdText)) = '') 
			THEN
				LTV.AdText
			ELSE 
				LTML.AdText
		  END AS AdText
		 , LTV.PeriodUnitId
		 , LTV.NumberOfUnit
		 , CASE 
			WHEN LTML.Price IS NULL 
			THEN CONVERT(bit, 1)
			ELSE CONVERT(bit, 0) 
		  END AS UseDefaultPrice
		 , CASE WHEN LTML.Price IS NULL 
			THEN
				LTV.Price
			ELSE
				LTML.Price
		  END AS Price
			, CASE WHEN (LTML.CurrencySymbol IS NULL OR LTRIM(RTRIM(LTML.CurrencySymbol)) = '') 
			 THEN
			 	LTV.CurrencySymbol
			 ELSE
			 	LTML.CurrencySymbol
			 END AS CurrencySymbol
			, CASE WHEN (LTML.CurrencyText IS NULL OR LTRIM(RTRIM(LTML.CurrencyText)) = '')
			 THEN
			 	LTV.CurrencyText
			 ELSE
			 	LTML.CurrencyText
			 END AS CurrencyText
		 , LTV.Enabled
		 , LTV.SortOrder
		FROM dbo.LicenseTypeML AS LTML RIGHT OUTER JOIN LicenseTypeView AS LTV
		  ON (LTML.LangId = LTV.LangId AND LTML.LicenseTypeId = LTV.LicenseTypeId)

GO
