SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CustomerView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
		 --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , Customer.CustomerId
		 , Customer.CustomerName
		 , Customer.TaxCode
		 , Customer.Address1
		 , Customer.Address2
		 , Customer.City
		 , Customer.Province
		 , Customer.PostalCode
		 , Customer.Phone
		 , Customer.Mobile
		 , Customer.Fax
		 , Customer.Email
		 , Customer.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Customer

GO
