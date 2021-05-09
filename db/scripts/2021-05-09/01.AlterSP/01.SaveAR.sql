SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SaveAR] (

 @DocDate nvarchar(8)
, @DocDueDate nvarchar(8)
, @CardCode nvarchar(15)
, @CardName nvarchar(100)
,@TollWayId smallint

,@ErrMsg As Varchar(200) = '''' Output
,@ErrNum As Int = 0 Output
,@ReturnType As Int = 0 Output

)
AS
BEGIN
DECLARE @DocNum int = NULL;
DECLARE @RunNo int = NULL;

	select @DocNum = count(AR_Head.DocNum)+1
	FROM [dbo].[AR_Head]
	WHERE ExportExcel = 0
		--And AR_Head.DocDate = @DocDate;

	select @RunNo = count(AR_Head.DocNum)+1
	FROM [dbo].[AR_Head]

	BEGIN TRY
	SET @ErrMsg = ''''
	SET @ErrNum = 0	

	if(Select Count(TA_Coupon.TollWayId) AS CountID
		From TA_Coupon
		Where (CouponStatus = 3 Or CouponStatus = 4)
		and datediff(day, SoldDate, COALESCE(@DocDueDate, SoldDate)) = 0
		and TA_Coupon.TollWayId = COALESCE(@TollWayId,TA_Coupon.TollWayId)
		and SapChooseFlag = 1
		and TA_Coupon.SAPSysSerial Not IN (Select AR_Serial.InternalSerialNumber From AR_Serial Where ExportExcel = 0) ) > 0

	BEGIN
	SET @ReturnType = 1
	INSERT INTO [dbo].[AR_Head]
           (RunNo,DocNum , DocType , DocDate , DocDueDate , CardCode , CardName , NumAtCard , Comments ,PaymentGroupCode, TollWayId , ExportExcel , InsertDate , ExportDate )
    VALUES (@RunNo,@DocNum , 'dDocument_Items' , @DocDate , @DocDueDate , @CardCode , @CardName , null , null,1 , @TollWayId, 0 ,GETDATE() , null)

	if( SELECT Count(AR_Head.RunNo) AS CountRunNo
	FROM[dbo].[AR_Head] 
    WHERE [ExportExcel] = 0
	and  RunNo = @RunNo
	and  TollWayId = @TollWayId) > 0

	BEGIN
	SET @ReturnType = 1
		INSERT INTO [dbo].[AR_Line]
			   (RunNo,ParentKey , LineNum , DocDate , ItemCode , ItemDescription , Quantity , UnitPrice , PriceAfterVAT , VatGroup , WarehouseCode , TollWayId , ExportExcel , InsertDate , ExportDate )
		Select RunNo,ParentKey,
				CAST(ROW_NUMBER() OVER (
					PARTITION BY TA_Coupon.TollWayId
					ORDER BY CouponType
				) - 1  AS smallint) AS LineNum ,DocDate
			, 'C'+CouponType AS ItemCode , SAPItemName AS ItemDescription ,CAST(Count(SAPSysSerial) AS decimal)  AS Quantity
			,CASE
				WHEN CouponType = 35 THEN CAST(665 AS decimal)
				WHEN CouponType = 80 THEN CAST(1520 AS decimal)
				ELSE null
			END AS UnitPrice
			, null AS PriceAfterVAT
			, 'SC7' AS VatGroup
			, SAPWhsCode AS WarehouseCode
			,CAST(TA_Coupon.TollWayId AS smallint) AS TollWayId 
			, 0 AS ExportExcel,GETDATE() AS InsertDate , null AS ExportDate
			From TA_Coupon
			Inner Join (Select RunNo,DocNum AS ParentKey,TollWayId ,DocDate From AR_Head Where AR_Head.ExportExcel = 0 And AR_Head.RunNo = @RunNo) AS AR_Head On AR_Head.TollWayId = TA_Coupon.TollWayId
			where (CouponStatus = 3 Or CouponStatus = 4) 
			and datediff(day, SoldDate, COALESCE(@DocDueDate, SoldDate)) = 0
			and TA_Coupon.TollWayId = COALESCE(@TollWayId,TA_Coupon.TollWayId)
			and SapChooseFlag = 1
			and TA_Coupon.SAPSysSerial Not IN (Select AR_Serial.InternalSerialNumber From AR_Serial Where ExportExcel = 0)
			Group By TA_Coupon.TollWayId , CouponType , SAPItemName,SAPWhsCode,RunNo,ParentKey,DocDate
			Order By TollWayId , CouponType asc

	if(SELECT Count(AR_Line.RunNo) AS CountRunNo
	FROM[dbo].[AR_Line] 
    WHERE [ExportExcel] = 0
	and  RunNo = @RunNo
	and  TollWayId = @TollWayId) > 0 

	BEGIN
	SET @ReturnType = 1
		INSERT INTO [dbo].[AR_Serial]
			   (RunNo,ParentKey , InternalSerialNumber ,SerialNo, BaseLineNumber , DocDate , TollWayId , ExportExcel , InsertDate , ExportDate )
		Select RunNo,ParentKey ,TA_Coupon.SAPSysSerial AS InternalSerialNumber,SerialNo , AR_Line.LineNum AS BaseLineNumber ,DocDate ,TA_Coupon.TollWayId
		, 0 AS ExportExcel,GETDATE() AS InsertDate, null AS ExportDate
		From TA_Coupon
		Inner Join (Select RunNo,ParentKey,LineNum,ItemCode,TollWayId ,DocDate From AR_Line Where AR_Line.ExportExcel = 0 And AR_Line.RunNo = @RunNo
		Group By RunNo,ParentKey,LineNum,ItemCode,TollWayId ,DocDate) AS AR_Line On AR_Line.ItemCode = 'C'+TA_Coupon.CouponType
		And AR_Line.TollWayId = TA_Coupon.TollWayId
		where (CouponStatus = 3 Or CouponStatus = 4)
		AND datediff(day, SoldDate, COALESCE(@DocDueDate, SoldDate) ) = 0
		and TA_Coupon.TollWayId = COALESCE(@TollWayId,TA_Coupon.TollWayId)
		and SapChooseFlag = 1
		and TA_Coupon.SAPSysSerial Not IN (Select AR_Serial.InternalSerialNumber From AR_Serial Where ExportExcel = 0)
		Group By  RunNo,ParentKey ,TA_Coupon.CouponType,TA_Coupon.SAPSysSerial, AR_Line.LineNum,TA_Coupon.TollWayId,DocDate ,SerialNo
		ORDER BY TA_Coupon.CouponType , SerialNo , SAPSysSerial


	if(SELECT Count(AR_Serial.RunNo) AS CountRunNo
	FROM[dbo].[AR_Serial] 
    WHERE [ExportExcel] = 0
	and  TollWayId = @TollWayId
	and  RunNo = @RunNo) > 0 

	BEGIN
	SET @ReturnType = 1
		Update [dbo].[TA_Coupon]
		Set SapChooseFlag = 0
		From (Select AR_Serial.SerialNo,AR_Serial.InternalSerialNumber,AR_Serial.TollWayId From AR_Serial
		Where AR_Serial.RunNo = @RunNo
		and AR_Serial.TollWayId = COALESCE(@TollWayId,AR_Serial.TollWayId)
		and ExportExcel = 0) AS Coupon
		Where TA_Coupon.SapChooseFlag = 1
		and TA_Coupon.SerialNo = Coupon.SerialNo
		and TA_Coupon.SAPSysSerial = Coupon.InternalSerialNumber
		and TA_Coupon.TollWayId = Coupon.TollWayId

	End

	End

	End

	End

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
