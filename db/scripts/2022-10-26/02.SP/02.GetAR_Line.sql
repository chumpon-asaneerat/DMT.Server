SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetAR_Line]
(
	 @RunNo int 
	,@TollWayID smallint 
    ,@DocDate nvarchar(8)
)
AS
BEGIN
    SELECT *
	FROM[dbo].[AR_Line] 
     WHERE  RunNo = COALESCE(@RunNo, [RunNo])
	 and [TollWayID] = COALESCE(@TollWayID, [TollWayID])
	 and [DocDate] = COALESCE(@DocDate, [DocDate])
	 and  [ExportExcel] = 0
     ORDER BY ParentKey , LineNum asc
END

GO