SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseMLView]
AS
	SELECT LTMLV.LangId
		  ,LTMLV.LicenseTypeId
		  ,LFMLV.Seq
		  ,LTMLV.LicenseTypeDescription
		  ,LTMLV.AdText
		  ,LTMLV.PeriodUnitId
		  ,LTMLV.NumberOfUnit
		  ,LTMLV.UseDefaultPrice
		  ,LTMLV.Price
		  ,LTMLV.CurrencySymbol
		  ,LTMLV.CurrencyText
		  ,LFMLV.LimitUnitId
		  ,LFMLV.NoOfLimit
		  ,LFMLV.LimitUnitText
		  ,LFMLV.LimitUnitDescription
		  ,LTMLV.Enabled
		  ,LTMLV.SortOrder
	  FROM LicenseTypeMLView LTMLV LEFT JOIN
		(
		 SELECT * 
		   FROM LicenseFeatureMLView LFMLV
		) AS LFMLV ON (
		      LFMLV.LangId = LTMLV.LangId
		  AND LFMLV.LicenseTypeId = LTMLV.LicenseTypeId
		)
GO
