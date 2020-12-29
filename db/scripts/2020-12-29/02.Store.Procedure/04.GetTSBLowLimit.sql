SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*********** Script Update Date: 2020-08-06  ***********/
CREATE PROCEDURE [dbo].[GetTSBLowLimit]
(
    @tsbid nvarchar(5)  
)
AS
BEGIN
    SELECT *
	FROM  [dbo].[TA_CreditLowLimit]
     WHERE  [TsbId] = @tsbid  
	 
END

GO

