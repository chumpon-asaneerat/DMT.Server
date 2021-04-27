SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAR_Head]
(
    @DocDate nvarchar(8)
	,@ExportExcel bit
)
AS
BEGIN
    SELECT *
	FROM[dbo].[AR_Head] 
     WHERE [DocDate] = COALESCE(@DocDate, [DocDate])
	 and  [ExportExcel] = @ExportExcel
     ORDER BY [DocNum] , insertDate asc
END


GO