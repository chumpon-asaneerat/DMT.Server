SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-06  ***********/
ALTER PROCEDURE [dbo].[GetUserCouponList]
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
	and [TsbId] = COALESCE(@tsbid, [TsbId])  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = 2
     ORDER BY [SerialNo] asc
END

GO