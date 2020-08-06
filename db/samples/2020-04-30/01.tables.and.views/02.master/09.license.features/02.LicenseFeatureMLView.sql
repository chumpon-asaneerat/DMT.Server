SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseFeatureMLView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
	     , LF.LicenseTypeId
	     , LF.Seq
		 , LF.LimitUnitId
		 , LF.LimitUnitDescription
		 , LF.NoOfLimit
		 , LF.LimitUnitText
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	  FROM LanguageView RIGHT OUTER JOIN 
	  (
	    SELECT dbo.LimitUnitMLView.LangId
			 , dbo.LicenseFeature.*
		     , dbo.LimitUnitMLView.LimitUnitDescription
		     , dbo.LimitUnitMLView.LimitUnitText
		  FROM dbo.LicenseFeature, dbo.LimitUnitMLView
		 WHERE dbo.LicenseFeature.LimitUnitId = dbo.LimitUnitMLView.LimitUnitId
	  ) AS LF ON (LanguageView.LangId = LF.LangId)

GO
