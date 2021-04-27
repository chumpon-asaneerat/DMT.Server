SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create  PROCEDURE [dbo].[TA_getSAPCustomer] (
    @SearchText NVARCHAR(100)
)
AS
BEGIN
	SELECT *
	FROM [dbo].[SAPCustomerCode]
	WHERE (	(CardCode LIKE '%' + @SearchText + '%') OR
			(CardName LIKE '%' + @SearchText + '%') 
			)
	and UseFlag = 1 

END


GO