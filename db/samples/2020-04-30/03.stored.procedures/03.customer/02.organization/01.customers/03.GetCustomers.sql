SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetCustomers
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-30> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
-- <2010-04-30> :
--	- remove parameter @customerId
--
-- [== Example ==]
--
--exec GetCustomers NULL, 1; -- for only enabled languages.
--exec GetCustomers;         -- for get all.
--exec GetCustomers N'EN';   -- for get customers for EN language.
--exec GetCustomers N'TH';   -- for get customers for TH language.
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomers] 
(
  @langId nvarchar(3) = NULL
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
	 ORDER BY SortOrder, CustomerId
END

GO
