
Create PROCEDURE [dbo].[TA_GetAccAppReqDetail]
(
    @requestid int ,
	@tsbid nvarchar(5)  
)
AS
BEGIN
      SELECT C.CurrencyDenomId , C.Description
	 ,  isnull(R.RequestId ,A.RequestId) RequestID , isnull(R.TSBId , A.TSBId) TSBId
	 , R.CurrencyValue  as RequestValue, R.CurrencyCount as RequestCount
	 , A.CurrencyValue as ApproveValue , A.CurrencyCount as  ApproveCount
	FROM  [dbo].[CurrencyDenom] C 
	FULL outer join ( select * from [dbo].[ExchangeRequestDetail]
					  where [RequestId] = COALESCE(@requestid, [RequestId]) 
					and TSBId = COALESCE(@tsbid, TSBId)  ) R  on C.[CurrencyDenomId] = R.[CurrencyDenomId]
	
	FULL outer join ( select * from [dbo].[ExchangeApproveDetail]
					  where [RequestId] = COALESCE(@requestid, [RequestId]) 
					and TSBId = COALESCE(@tsbid, TSBId)  ) A on C.[CurrencyDenomId] = A.[CurrencyDenomId]
     
     
END
GO