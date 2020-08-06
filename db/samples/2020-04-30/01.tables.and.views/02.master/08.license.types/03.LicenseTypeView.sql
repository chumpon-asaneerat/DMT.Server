SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseTypeView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , LicenseType.LicenseTypeId
	     , LicenseType.Description AS LicenseTypeDescription
	     , LicenseType.AdText AS AdText
	     , LicenseType.PeriodUnitId
	     , LicenseType.NumberOfUnit
	     , LicenseType.Price
		 , LicenseType.CurrencySymbol
		 , LicenseType.CurrencyText
	  FROM LanguageView CROSS JOIN dbo.LicenseType

GO
