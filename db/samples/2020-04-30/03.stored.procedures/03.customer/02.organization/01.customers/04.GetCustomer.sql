SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetCustomer
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetCustomer N'EN', N'EDL-C2020030001';   -- only EN language
--exec GetCustomer N'TH', N'EDL-C2020030001';   -- only TH language
--exec GetCustomer NULL, N'EDL-C2020030001', 1; -- all enable languages
--exec GetCustomer NULL, N'EDL-C2020030001';    -- all languages
--exec GetCustomer NULL, NULL;                  -- no customerId (no data returns)
--exec GetCustomer N'TH', NULL;                 -- no customerId (no data returns)
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomer] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , CustomerName
		 , TaxCode
		 , Address1
		 , Address2
		 , City
		 , Province
		 , PostalCode
		 , Phone
		 , Mobile
		 , Fax
		 , Email
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM CustomerMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	 ORDER BY SortOrder, CustomerId
END

GO
