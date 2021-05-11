SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[Acc_getTSBCreditAppTrans]
(
  @tsbid nvarchar(5)
)
AS
BEGIN

select *
from [dbo].[TSBCreditAppTrans]
where [TSBId] = @tsbid
order by [ApproveDate] asc


END
GO