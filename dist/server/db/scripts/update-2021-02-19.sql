/*********** Script Update Date: 2021-02-19  ***********/
ALTER TABLE TA_Coupon
ADD 
    PayTypeID int ,
    PaytypeName nvarchar(20),
	EdcDateTime Datetime,
	EdcTerminalId nvarchar(8),
	EdcCardNo nvarchar(8),
	EdcAmount decimal(6,2),
	EdcRef1 nvarchar(20),
	EdcRef2 nvarchar(20),
	EdcRef3 nvarchar(20);

/*********** Script Update Date: 2021-02-19  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vmCouponSold]
AS
SELECT        TSBId, CouponType, SerialNo, Price, SoldBy, SoldDate, LaneId, SAPItemName, PayTypeID, PaytypeName, EdcDateTime, EdcTerminalId, EdcCardNo, EdcRef1, EdcAmount, EdcRef2, EdcRef3
FROM            dbo.TA_Coupon
WHERE        (CouponStatus IN (3, 4))
GO


/*********** Script Update Date: 2021-02-19  ***********/
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
, @edcterminalid nvarchar(8)
, @edccardno nvarchar(8)
, @edcamount decimal(6,2)
, @edcref1 nvarchar(20)
, @edcref2 nvarchar(20)
, @edcref3 nvarchar(20)
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
