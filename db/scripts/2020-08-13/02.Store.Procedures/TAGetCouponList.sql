CREATE PROCEDURE [dbo].[TAGetCouponList]
(
    @tsbid nvarchar(5)  ,
	@userid nvarchar(10) ,
	@transactiontype char(1),
	@coupontype nvarchar(2)
)
AS
BEGIN
    SELECT *
	FROM [dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = COALESCE(@tsbid, [TsbId])  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
     ORDER BY [couponType], [SerialNo] asc
END

GO