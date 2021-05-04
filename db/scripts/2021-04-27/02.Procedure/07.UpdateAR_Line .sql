SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateAR_Line] (

@RunNo int
, @ParentKey int
, @LineNum int
, @DocDate nvarchar(8)
, @ItemCode nvarchar(3)
, @ItemDescription nvarchar(20)
, @Quantity decimal(18, 2)
, @UnitPrice decimal(18, 2)
, @PriceAfterVAT decimal(18, 2)
, @VatGroup nvarchar(3)
, @WarehouseCode nvarchar(8)
, @TollWayId smallint

,@ErrMsg As Varchar(200) = '''' Output
,@ErrNum As Int = 0 Output
,@ReturnType As Int = 0 Output

)
AS
BEGIN
DECLARE @DocNum int = NULL;

	BEGIN TRY
	SET @ErrMsg = ''''
	SET @ErrNum = 0	

	IF (select count(ParentKey) 	
		FROM [dbo].[AR_Line]
		WHERE AR_Line.RunNo = @RunNo
		And AR_Line.ParentKey = @ParentKey
		And AR_Line.LineNum = @LineNum
		And AR_Line.DocDate = @DocDate
		And AR_Line.TollWayId = @TollWayId
		And ExportExcel = 0) = 0

	--BEGIN
	--SET @ReturnType = 1

	--UPDATE [dbo].[AR_Line]
	--SET  Quantity = isnull(@Quantity ,[Quantity])
	--WHERE AR_Line.ParentKey = @ParentKey
		--And AR_Line.LineNum = @LineNum
		--And AR_Line.DocDate = @DocDate
		--And AR_Line.TollWayId = @TollWayId
		--And ExportExcel = 0

	--End
	--ELSE
	BEGIN
	SET @ReturnType = 1
	INSERT INTO [dbo].[AR_Line]
           (RunNo,ParentKey , LineNum , DocDate , ItemCode , ItemDescription , Quantity , UnitPrice , PriceAfterVAT , VatGroup , WarehouseCode , TollWayId , ExportExcel , InsertDate , ExportDate )
    VALUES (@RunNo,@ParentKey , @LineNum , @DocDate , @ItemCode , @ItemDescription , @Quantity , @UnitPrice , @PriceAfterVAT , @VatGroup , @WarehouseCode , @TollWayId , 0 ,GETDATE() , null)
	END
		
	RETURN
	END TRY
	BEGIN CATCH
		IF @@Error > 0 OR @@RowCount < 1 
		BEGIN
			SET @ErrMsg = ERROR_MESSAGE()
			SET @ErrNum = ERROR_NUMBER()
			SET @ReturnType = 0
			Return	
		END
	END CATCH

	COMMIT;
END;


GO