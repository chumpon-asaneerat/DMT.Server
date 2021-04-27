SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAR_Serial]
(
    @DocDate nvarchar(8)
)
AS
BEGIN
    SELECT *
	FROM[dbo].[AR_Serial] 
     WHERE [DocDate] = COALESCE(@DocDate, [DocDate])
	 and  [ExportExcel] = 0
     ORDER BY ParentKey ,BaseLineNumber, InternalSerialNumber asc
END


GO