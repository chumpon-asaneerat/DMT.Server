/*********** Script Update Date: 2022-05-02  ***********/

ALTER PROCEDURE [dbo].[TA_GetUpdateReqData]
(
    @requestid  int , 
	@tsbid nvarchar(5)  ,
	@transdate datetime
)
AS
BEGIN
    SELECT *
	FROM  [dbo].[TSBExchange]
     WHERE [RequestId] = COALESCE(@requestid, [RequestId])  
	 and [TSBId] = COALESCE(@tsbid, [TSBId])  
	---and [LastUpdate] > @transdate
     
END
