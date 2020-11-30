SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ESellingToTA] (

 @TSBId_ESelling nvarchar(5)
, @CouponType varchar(2)
, @SerialNo nvarchar(7)
, @CouponStatus char(1)
, @FinishFlag char(1)
, @SapChooseFlag char(1)
, @SAPSysSerial int
, @TollWayId smallint
, @SAPItemName nvarchar(20)

,@ErrMsg As Varchar(200) = '''' Output
,@ErrNum As Int = 0 Output
,@ReturnType As Int = 0 Output

)
AS
BEGIN
DECLARE @TSBId nvarchar(5) = NULL;
DECLARE @Price decimal(6, 0) = NULL;

	select @TSBId = TSBId 
	FROM [dbo].[SapWhsCodeTSBMap]
	WHERE	SapWhsCode = @TSBId_ESelling;

	if(@CouponType = '35')
	BEGIN
		SET @Price = 665
	END
	else if(@CouponType = '80')
	BEGIN
		SET @Price = 1520
	END

	BEGIN TRY
	SET @ErrMsg = ''''
	SET @ErrNum = 0	

		IF EXISTS (
		SELECT *	 
		FROM [dbo].[TA_Coupon]
		WHERE TSBId = @TSBId
		and  [CouponType] = @CouponType
		and [SerialNo] = @SerialNo
		and [SAPSysSerial] = @SAPSysSerial
	)
	BEGIN
	SET @ReturnType = 1

	UPDATE [dbo].[TA_Coupon]
	SET TransactionDate = isnull(GETDATE(),[TransactionDate])
	, Price = isnull(@Price,[Price])
	, CouponStatus = isnull(@CouponStatus,[CouponStatus])
	, FinishFlag = isnull(@FinishFlag ,[FinishFlag])
	, SapChooseFlag = isnull(@SapChooseFlag ,[SapChooseFlag])
	, SAPWhsCode = isnull(@TSBId_ESelling ,[SAPWhsCode])
	, TollWayId = isnull(@TollWayId ,[TollWayId])
	, SAPItemName = isnull(@SAPItemName ,[SAPItemName])
    WHERE TSBId = @TSBId
		and  [CouponType] = @CouponType
		and [SerialNo] = @SerialNo
		and [SAPSysSerial] = @SAPSysSerial

	End
	ELSE
	BEGIN
	INSERT INTO [dbo].[TA_Coupon]
           (TransactionDate ,[TSBId],[CouponType],[SerialNo],[Price],[CouponStatus],[FinishFlag],[SapChooseFlag],[SAPSysSerial],[SAPWhsCode],[TollWayId],[SAPItemName] )
    VALUES (GETDATE(), @TSBId , @CouponType , @SerialNo, @Price,@CouponStatus , @FinishFlag , @SapChooseFlag ,@SAPSysSerial,@TSBId_ESelling,@TollWayId,@SAPItemName )
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