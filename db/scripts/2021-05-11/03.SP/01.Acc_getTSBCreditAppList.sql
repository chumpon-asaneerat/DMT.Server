SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[Acc_getTSBCreditAppList]

AS
BEGIN
select T.TSBId, T.TSB_Th_Name , C.MaxCredit , isnull(TB.tsbbalance,0) tsbbalance
from TSB T  
join TSBCreditApprove C on T.TSBId = C.TSBId
full outer join 
(select B.TSBId
, Amnt1+Amnt2+Amnt5+Amnt10+Amnt20+Amnt50+Amnt100+Amnt500+Amnt1000+U.usercrdit As tsbbalance
from [dbo].[TSBCreditBalance] B Full outer join 
(select TSBId , sum(Credit) usercrdit 
from [dbo].[UserCreditOnJob]
where Flag = 0
group by TSBId ) U  on B.TSBId = U.TSBId) TB on T.TSBId = TB.TSBId
order by T.TSBId


END
GO