/****** Object:  StoredProcedure [dbo].[SaveTACoupon]    Script Date: 11/23/2023 9:01:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SaveTACoupon] (
  @couponpk int
 ,@transactionid  int
, @transactiondate datetime
, @tsbid nvarchar(5)
, @coupontype varchar(2)
, @serialno nvarchar(20)
, @price decimal(6,0)
, @userid nvarchar(10)
, @userreceivedate datetime
, @Couponstatus char(1)
, @solddate datetime
, @soldby nvarchar(10)
, @finishflag char(1)
--, @sendtaflag char(1)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
		IF EXISTS (
		SELECT *	 
		FROM[dbo].[TA_Coupon] 
		WHERE [SerialNo] = @serialno
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid
		
	)
	BEGIN
	UPDATE [dbo].[TA_Coupon]
	SET [Price] = COALESCE(@price, [Price])
      ,[UserId] = @userid
      ,[UserReceiveDate] = @userreceivedate
      ,[CouponStatus] = COALESCE(@Couponstatus, [CouponStatus])
      ,[SoldDate] = @solddate --COALESCE(@solddate, [SoldDate])
      ,[SoldBy] = @soldby --COALESCE(@soldby, [SoldBy])
      ,[FinishFlag] = COALESCE(@finishflag, [FinishFlag])
	  --,[sendtaflag] = COALESCE(@sendtaflag, [sendtaflag])
    WHERE [SerialNo] = @serialno
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid;
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[TA_Coupon]
           ( [TransactionDate],[TSBId] ,[CouponType] ,[SerialNo]
           ,[Price] ,[CouponStatus] ,[FinishFlag] )
     VALUES (  @transactiondate , @tsbid, @coupontype, @serialno
	         ,@price , @Couponstatus , @finishflag )


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
