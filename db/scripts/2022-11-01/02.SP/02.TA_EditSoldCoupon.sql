
ALTER PROCEDURE [dbo].[TA_EditSoldCoupon] (
  @tsbid nvarchar(5)
, @oldserialno nvarchar(7)
, @newserialno nvarchar(7)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN


	BEGIN TRY

	update a
	   set SoldDate = b.SoldDate
	   , SoldBy = b.SoldBy
	   , CouponStatus = b.CouponStatus
	   , LaneId = b.LaneId
	   , PayTypeID = b.PayTypeID
	   , PaytypeName = b.PaytypeName
	   , EdcAmount = b.EdcAmount
	   , EdcCardNo = b.EdcCardNo
	   , EdcDateTime = b.EdcDateTime
	   , EdcRef1 = b.EdcRef1
	   , EdcRef2 = b.EdcRef2
	   , EdcRef3 = b.EdcRef3
	   , EdcTerminalId = b.EdcTerminalId
	   , FinishFlag = b.FinishFlag
	   from TA_Coupon a , TA_Coupon b
	   where a.SerialNo = @newserialno
	   and b.SerialNo = @oldserialno ; 

	update TA_Coupon
	   set SoldDate = NULL
	   , SoldBy = NULL
	   , CouponStatus = 1
	   , LaneId = NULL
	   , PayTypeID = NULL
	   , PaytypeName = NULL
	   , EdcAmount = NULL
	   , EdcCardNo = NULL
	   , EdcDateTime = NULL
	   , EdcRef1 = NULL
	   , EdcRef2 = NULL
	   , EdcRef3 = NULL
	   , EdcTerminalId = NULL
	   , FinishFlag = 1
	   where SerialNo = @oldserialno ; 

		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END
GO