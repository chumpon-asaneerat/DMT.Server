SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateAR_Serial] (

@RunNo int
, @ParentKey int
, @InternalSerialNumber int
, @BaseLineNumber int
, @DocDate nvarchar(8)
, @TollWayId smallint
, @SerialNo	nvarchar(7)

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
		FROM [dbo].[AR_Serial]
		WHERE AR_Serial.RunNo = @RunNo
		And AR_Serial.ParentKey = @ParentKey
		And AR_Serial.InternalSerialNumber = @InternalSerialNumber
		And AR_Serial.BaseLineNumber = @BaseLineNumber
		And AR_Serial.DocDate = @DocDate
		And AR_Serial.TollWayId = @TollWayId
		And ExportExcel = 0) = 0

	BEGIN
	SET @ReturnType = 1
	INSERT INTO [dbo].[AR_Serial]
           (RunNo,ParentKey , InternalSerialNumber ,SerialNo, BaseLineNumber , DocDate , TollWayId , ExportExcel , InsertDate , ExportDate )
    VALUES (@RunNo,@ParentKey , @InternalSerialNumber,@SerialNo , @BaseLineNumber , @DocDate , @TollWayId , 0 ,GETDATE() , null)
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