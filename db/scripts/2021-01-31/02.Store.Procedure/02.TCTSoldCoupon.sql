SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TCTSoldCoupon] 
(
  @tsbid nvarchar(5)
, @coupontype nvarchar(2)
, @serialno nvarchar(7)
, @price decimal(6,0)
, @userid nvarchar(10)
, @solddate datetime
, @laneid nvarchar(10)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @tsb nvarchar(5) = NULL;
	BEGIN TRY
		SELECT @tsb = [TSBId]
		  FROM [dbo].[Lane]
		 WHERE [LaneId] = @laneid;
		 --AND [PlazaId] = @plazaid
		-- UPDATE SOLD COUPON BY TCT
		UPDATE [dbo].[TA_Coupon]
		   SET [CouponStatus] = 3
			 , [SoldDate] = @solddate
			 , [SoldBy] = @userid
			 , [LaneId] = @laneid
			 , [sendtaflag] = 0 -- MARK SENDING FLAG = 0 TO SEND TO TA APP LATER
		 WHERE [SerialNo] = @serialno 
		   AND [CouponType]  = @coupontype
		   --AND [TSBId] = @tsb
		   AND [UserId] = @userid;

		-- SET SUCCESS
		SET @errNum = 0;
		SET @errMsg = N'Success'
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO