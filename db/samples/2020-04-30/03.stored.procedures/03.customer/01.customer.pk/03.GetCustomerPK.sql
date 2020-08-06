SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetCustomerPK.
-- Description:	Gets Customer Primary Key.
-- [== History ==]
-- <2017-01-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetCustomerPK N'EDL-C2017010001', N'Branch'; -- for get match by name
--exec GetCustomerPK N'EDL-C2017010001'; -- for get all
-- =============================================
CREATE PROCEDURE [dbo].[GetCustomerPK] 
(
  @customerId nvarchar(30)
, @tableName nvarchar(50) = null
)
AS
BEGIN
	SELECT CustomerId
		 , LastSeed
		 , SeedResetMode
		 , CASE SeedResetMode
			 WHEN 1 THEN N'Daily'
			 WHEN 2 THEN N'Monthly'
			 WHEN 3 THEN N'Yearly'
			 WHEN 4 THEN N'Sequence'
		   END AS ResetMode
		 , [prefix]
		 , SeedDigits
		 , LastUpdated
		FROM CustomerPK
		WHERE LOWER(CustomerId) = LOWER(@customerId)
		  AND LOWER([TableName]) = LOWER(COALESCE(@tableName, [TableName]));
END

GO
