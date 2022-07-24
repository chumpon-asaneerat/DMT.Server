/*********** Script Update Date: 2022-07-25  ***********/
/****** Object:  StoredProcedure [dbo].[Acc_getReqDatabyStatus]    Script Date: 7/25/2022 6:17:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[Acc_getReqDatabyStatus]
(
   @status nchar(1)
   ,@tsbid nvarchar(5)  
   ,@requestdate date
)
AS
BEGIN
select T.TSBId, T.TSB_Th_Name 
, E.RequestId 
, E.RequestDate , E.ExchangeBHT , E.BorrowBHT , E.AdditionalBHT
, E.PeriodBegin ,E.PeriodEnd , E.RequestRemark , E.TSBRequestBy 
, E.AppExchangeBHT , E.AppBorrowBHT , E.AppAdditionalBHT , E.ApproveBy ,E.ApproveDate , E.ApproveRemark
, E.Status
from [dbo].[TSBExchange] E , [dbo].[TSB] T
where  E.TSBId = T.TSBId
and E.Status = COALESCE(@status, E.Status)  
and E.TSBId = COALESCE(null, E.[TSBId])  
and datediff(day, E.RequestDate, COALESCE(@requestdate, E.RequestDate) ) = 0
order by T.TSBId

END

GO

