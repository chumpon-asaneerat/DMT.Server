SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LicenseHistoryMLView]
AS
	SELECT lhis.historyId
         , cmlv.langId
		 , lhis.customerId
		 , lhis.maxDevice
		 , lhis.maxAccount
		 , lhis.maxClient
		 , lhis.RequestDate
		 , lhis.BeginDate
		 , lhis.EndDate
		 , CASE
		    WHEN CAST(lhis.EndDate AS DATE) = CAST(lhis.BeginDate AS DATE) THEN CAST(1 AS bit)
			ELSE CAST(0 AS bit)
		   END AS Revoked
		 , CASE 
		    WHEN CAST(lhis.EndDate AS DATE) < CAST(GETDATE() AS DATE) THEN CAST(1 AS bit)
		    ELSE CAST(0 AS bit)
		   END AS Expired
		 , CASE
		    WHEN (CAST(lhis.EndDate AS DATE) = CAST(lhis.BeginDate AS DATE)) THEN 0
			ELSE DATEDIFF(day, CAST(GETDATE() AS DATE), CAST(lhis.EndDate AS DATE))
		   END AS RemainDays
		 , cmlv.CustomerName
		 , cmlv.TaxCode
		 , cmlv.Address1
		 , cmlv.Address2
		 , cmlv.City
		 , cmlv.Province
		 , cmlv.PostalCode
		 , cmlv.Phone
		 , cmlv.Mobile
		 , cmlv.Fax
		 , cmlv.Email
		 , ltmlv.LicenseTypeDescription as Description
		 , ltmlv.AdText
		 , ltmlv.NumberOfUnit
		 , pmlv.PeriodUnitDescription as PeriodUnit
		 , ltmlv.PeriodUnitId
		 , ltmlv.Price
		 , ltmlv.UseDefaultPrice
		 , ltmlv.CurrencySymbol
		 , ltmlv.CurrencyText
		 , ltmlv.LicenseTypeId
	  FROM LicenseHistory lhis 
	 RIGHT OUTER JOIN CustomerMLView AS cmlv
        ON (cmlv.CustomerId = lhis.CustomerId)
	 RIGHT OUTER JOIN LicenseTypeMLView AS ltmlv
        ON (ltmlv.LangId = cmlv.LangId AND ltmlv.LicenseTypeId = lhis.LicenseTypeId)
	 RIGHT OUTER JOIN PeriodUnitMLView AS pmlv
        ON (pmlv.LangId = ltmlv.LangId AND pmlv.PeriodUnitId = ltmlv.PeriodUnitId)
	 WHERE cmlv.Enabled = 1
	   AND ltmlv.Enabled = 1
	   AND pmlv.Enabled = 1

GO
