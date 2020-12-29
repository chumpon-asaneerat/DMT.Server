SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAGetCouponList]
(
    @tsbid nvarchar(5)  ,
	@userid nvarchar(10) ,
	@transactiontype char(1),
	@coupontype nvarchar(2),
	@flag char(1)
)
AS
BEGIN
if @flag = 0 
    SELECT *
	FROM [dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = COALESCE(@tsbid, [TsbId])  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
	 and [FinishFlag] = 1
	 and [sendtaflag] = 0
     ORDER BY [couponType], [SerialNo] asc


if @flag  is null 
  SELECT *
	FROM [dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = COALESCE(@tsbid, [TsbId])  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
	 and [FinishFlag] = 1
	 ORDER BY [couponType], [SerialNo] asc
END

GO