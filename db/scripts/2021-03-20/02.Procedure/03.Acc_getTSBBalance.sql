/****** Object:  StoredProcedure [dbo].[Acc_getTSBBalance]    Script Date: 20/3/2564 20:32:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Acc_getTSBBalance]

AS
BEGIN

select T.TSBId , T.TSB_Th_Name , M.Amnt1 , M.Amnt2 , M.Amnt5, M.Amnt10, M.Amnt20
, M.Amnt50 , M.Amnt100 , M.Amnt500, M.Amnt1000, M.BalanceDate , M.BalanceRemark 
, U.ucredit,  C.C35 , C.C80 
from [dbo].[TSB] T 
FULL outer join [dbo].[TSBCreditBalance] M
on T.TSBId = M.TSBId 
FULL outer join
(select TSBId , sum(credit) ucredit
from [dbo].[UserCreditOnJob]
where flag = 0
group by TSBId) U
on  T.TSBId = U.TSBId 
FULL outer join
( select TSBId , COUNT(CASE WHEN CouponType = 35 THEN 1 ELSE NULL END) As C35
, COUNT(CASE WHEN CouponType = 80 THEN 1 ELSE NULL END) As C80
from TA_Coupon
where [CouponStatus] = 1
group by TSBId  ) C 
on  T.TSBId = C.TSBId 
order by T.TSBId


END
GO

