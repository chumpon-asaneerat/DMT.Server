SET ANSI_NULLS ON

GO

SET QUOTED_IDENTIFIER ON

GO

ALTER PROCEDURE [dbo].[GetAR_Head]
(
	 @RunNo int 
	,@TollWayID smallint 
    ,@DocDate nvarchar(8)
	,@ExportExcel bit
)
AS
BEGIN
    SELECT *
	FROM[dbo].[AR_Head] 
     WHERE RunNo = COALESCE(@RunNo, [RunNo])
	 and [TollWayID] = COALESCE(@TollWayID, [TollWayID])
	 and [DocDate] = COALESCE(@DocDate, [DocDate])
	 and  [ExportExcel] = @ExportExcel
     ORDER BY RunNo,TollWayID,[DocNum] , insertDate asc
END

GO