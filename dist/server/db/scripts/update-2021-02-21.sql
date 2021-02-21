/*********** Script Update Date: 2021-02-21  ***********/
ALTER TABLE TA_Coupon ALTER COLUMN EdcTerminalId nvarchar(20)
GO

ALTER TABLE TA_Coupon ALTER COLUMN EdcCardNo nvarchar(30)
GO

ALTER TABLE TA_Coupon ALTER COLUMN EdcRef1 nvarchar(40)
GO

ALTER TABLE TA_Coupon ALTER COLUMN EdcRef2 nvarchar(40)
GO

ALTER TABLE TA_Coupon ALTER COLUMN EdcRef3 nvarchar(40)
GO


/*********** Script Update Date: 2021-02-21  ***********/
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
, @paytypeid int
, @paytypename nvarchar(20)
, @edcdatetime Datetime
, @edcterminalid nvarchar(20)
, @edccardno nvarchar(30)
, @edcamount decimal(6,2)
, @edcref1 nvarchar(40)
, @edcref2 nvarchar(40)
, @edcref3 nvarchar(40)
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
			 , [PayTypeID] = @paytypeid
			 , [PaytypeName] = @paytypename
			 , [EdcDateTime] = @edcdatetime
			 , [EdcTerminalId] = @edcterminalid
			 , [EdcCardNo] = @edccardno
			 , [EdcAmount] = @edcamount
			 , [EdcRef1] = @edcref1
			 , [EdcRef2] = @edcref2
			 , [EdcRef3] = @edcref3
			 , [sendtaflag] = 0 -- MARK SENDING FLAG = 0 TO SEND TO TA APP LATER
		 WHERE [SerialNo] = @serialno 
		   AND [CouponType]  = @coupontype
		   AND [TSBId] = @tsb
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

