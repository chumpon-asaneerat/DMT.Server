
create PROCEDURE [dbo].[Acc_getReqDatabyStatus]
(
   @status nchar(1)
)
AS
BEGIN
select T.TSBId, T.TSB_Th_Name , E.RequestDate , E.ExchangeBHT , E.BorrowBHT , E.AdditionalBHT
, E.PeriodBegin ,E.PeriodEnd , E.RequestRemark , E.TSBRequestBy 
, E.AppExchangeBHT , E.AppBorrowBHT , E.AppAdditionalBHT , E.ApproveBy ,E.ApproveDate , E.ApproveRemark
from [dbo].[TSBExchange] E , [dbo].[TSB] T
where  E.TSBId = T.TSBId
and E.Status = COALESCE(@status, E.Status)  
order by T.TSBId


END
GO