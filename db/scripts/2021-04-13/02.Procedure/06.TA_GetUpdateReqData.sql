
Create PROCEDURE [dbo].[TA_GetUpdateReqData]
(
    @tsbid nvarchar(5)  ,
	@transdate datetime
)
AS
BEGIN
    SELECT *
	FROM  [dbo].[TSBExchange]
     WHERE [TSBId] = COALESCE(@tsbid, [TSBId])  
	and [LastUpdate] > @transdate
     
END
GO