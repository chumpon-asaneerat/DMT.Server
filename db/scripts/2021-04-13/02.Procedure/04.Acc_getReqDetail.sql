
create PROCEDURE [dbo].[Acc_getReqDetail]
(
   @requestid int,
   @tsbid nvarchar(5)
)
AS
BEGIN
select *
from [dbo].[ExchangeRequestDetail]
where  RequestId = @requestid
and TSBId = @tsbid  
order by CurrencyDenomId


END
GO