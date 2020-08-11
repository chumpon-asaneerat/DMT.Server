CREATE PROCEDURE [dbo].[TCTSoldCoupon] (
  @tsbid nvarchar(5)
, @coupontype nvarchar(2)
, @serialno nvarchar(7)
, @price decimal(6,0)
, @userid nvarchar(10)
, @solddate datetime
, @laneid nvarchar(10)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
BEGIN TRY

	UPDATE [dbo].[TA_Coupon]
	SET [CouponStatus] = 3
      ,[SoldDate] = @solddate
      ,[SoldBy] = @userid
      , [LaneId] = @laneid
	WHERE [SerialNo] = @serialno 
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid
		and [UserId] = @userid;
	
	
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO