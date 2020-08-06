SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetCustomerHistories
-- [== History ==]
-- <2019-10-01> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetCustomerHistories NULL, NULL;                -- for get all.
--exec GetCustomerHistories;                           -- for get all.
--exec GetCustomerHistories N'EN';                     -- for get customer histories for EN language.
--exec GetCustomerHistories N'TH';                     -- for get customer histories for TH language.
--exec GetCustomerHistories N'TH', N'EDL-C2017060011'; -- for get customer histories for TH language by Customer Id.
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomerHistories] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
)
AS
BEGIN
	SELECT hisv.historyId
         , hisv.langId
		 , hisv.customerId
		 , hisv.CustomerName
		 , hisv.RequestDate
		 , hisv.BeginDate
		 , hisv.EndDate
         , hisv.Revoked
		 , hisv.Expired
		 , hisv.RemainDays
		 , hisv.maxDevice
		 , hisv.maxAccount
		 , hisv.maxClient
		 /*
		 , hisv.TaxCode
		 , hisv.Address1
		 , hisv.Address2
		 , hisv.City
		 , hisv.Province
		 , hisv.PostalCode
		 , hisv.Phone
		 , hisv.Mobile
		 , hisv.Fax
		 , hisv.Email
		 */
		 , hisv.Description
		 , hisv.AdText
		 , hisv.NumberOfUnit
		 , hisv.PeriodUnit
		 , hisv.PeriodUnitId
		 , hisv.Price
		 , hisv.UseDefaultPrice
		 , hisv.CurrencySymbol
		 , hisv.CurrencyText
		 , hisv.LicenseTypeId
	  FROM LicenseHistoryMLView hisv
	 WHERE UPPER(LTRIM(RTRIM(hisv.LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, hisv.LangId))))
	   AND UPPER(LTRIM(RTRIM(hisv.CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, hisv.CustomerId))))
	 ORDER BY hisv.CustomerId, hisv.RequestDate
END

GO
