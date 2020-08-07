CREATE PROCEDURE [dbo].[GetUserCouponList]
(
    @tsbid varchar(10)  ,
	@userid varchar(10) ,
	@coupontype varchar(2)
)
AS
BEGIN
    SELECT [TransactionID], [CouponType], [SerialNo], [Price]
	FROM[dbo].[TA_Coupon] 
     WHERE [UserId] = COALESCE(@userid, [UserId])
	 and [CouponStatus] = 2
     ORDER BY [SerialNo] asc
END

GO