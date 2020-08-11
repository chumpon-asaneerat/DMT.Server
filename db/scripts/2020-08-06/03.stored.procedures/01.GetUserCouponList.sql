CREATE PROCEDURE [dbo].[GetUserCouponList]
(
    @tsbid nvarchar(5)  ,
	@userid nvarchar(10) ,
	@coupontype nvarchar(2)
)
AS
BEGIN
    SELECT [CouponPK], [CouponType], [SerialNo], [Price]
	FROM[dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = @tsbid  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = 2
     ORDER BY [SerialNo] asc
END

GO