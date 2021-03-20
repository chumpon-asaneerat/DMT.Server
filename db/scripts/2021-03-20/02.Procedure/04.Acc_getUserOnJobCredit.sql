/****** Object:  StoredProcedure [dbo].[Acc_getUserOnJobCredit]    Script Date: 20/3/2564 20:51:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[Acc_getUserOnJobCredit]
(
    @tsbid nvarchar(5)
)

AS
BEGIN
select T.TSBId , T.TSB_Th_Name , U.UserId , U.UserPrefix+' '+U.userfirstname+' '+U.userlastname as username
, U.Bagno , U.Credit , U.creditdate , C.C35 , C.C80
from [dbo].[TSB] T 
FULL outer join [dbo].[UserCreditOnJob] U
on T.TSBId = U.TSBId 
FULL outer join
( select TSBId , userId,  COUNT(CASE WHEN CouponType = 35 THEN 1 ELSE NULL END) As C35
, COUNT(CASE WHEN CouponType = 80 THEN 1 ELSE NULL END) As C80
from TA_Coupon
where [CouponStatus] in (2,3 )
and FinishFlag = 1
group by TSBId ,userId  ) C 
on  U.userId = C.userId
where  T.TSBId = @tsbid
and U.flag = 0


END
GO

