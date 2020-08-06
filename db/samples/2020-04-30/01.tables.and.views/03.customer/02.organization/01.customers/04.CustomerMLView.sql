SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[CustomerMLView]
AS
	SELECT CUV.LangId
	     , CUV.CustomerId
		 , CASE 
			WHEN (CUML.CustomerName IS NULL OR LTRIM(RTRIM(CUML.CustomerName)) = '') THEN 
				CUV.CustomerName
			ELSE 
				CUML.CustomerName 
		   END AS CustomerName
		 , CASE 
			WHEN (CUML.CustomerName IS NULL OR LTRIM(RTRIM(CUML.CustomerName)) = '') THEN 
				CUV.TaxCode
			ELSE 
				CUML.TaxCode 
		   END AS TaxCode
		 , CASE 
			WHEN (CUML.CustomerName IS NULL OR LTRIM(RTRIM(CUML.CustomerName)) = '') THEN 
				CUV.Address1
			ELSE 
				CUML.Address1 
		   END AS Address1
		 , CASE 
			WHEN (CUML.CustomerName IS NULL OR LTRIM(RTRIM(CUML.CustomerName)) = '') THEN 
				CUV.Address2
			ELSE 
				CUML.Address2 
		   END AS Address2
		 , CASE 
			WHEN (CUML.CustomerName IS NULL OR LTRIM(RTRIM(CUML.CustomerName)) = '') THEN 
				CUV.City
			ELSE 
				CUML.City 
		   END AS City
		 , CASE 
			WHEN (CUML.CustomerName IS NULL OR LTRIM(RTRIM(CUML.CustomerName)) = '') THEN 
				CUV.Province
			ELSE 
				CUML.Province 
		   END AS Province
		 , CASE 
			WHEN (CUML.CustomerName IS NULL OR LTRIM(RTRIM(CUML.CustomerName)) = '') THEN 
				CUV.PostalCode
			ELSE 
				CUML.PostalCode 
		   END AS PostalCode
		 , CUV.Phone
		 , CUV.Mobile
		 , CUV.Fax
		 , CUV.Email
		 , CUV.ObjectStatus
		 , CUV.Enabled
		 , CUV.SortOrder
		FROM dbo.CustomerML AS CUML RIGHT OUTER JOIN CustomerView AS CUV
		  ON (CUML.LangId = CUV.LangId AND CUML.CustomerId = CUV.CustomerId)

GO
