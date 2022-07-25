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


/*********** Script Update Date: 2022-07-25  ***********/

ALTER PROCEDURE [dbo].[TA_SaveExchangeTransaction] (
  @requestid  int
, @tsbid nvarchar(5)
, @exchangebht decimal(8,0)
, @borrowbht decimal(7,0)
, @additionalbht decimal(7,0)
, @periodbegin datetime
, @periodend datetime
, @remark nvarchar(255)
, @finishflag nchar(1)
, @userid nvarchar(10)
, @tranactiondate datetime
, @status nchar(1)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
		IF EXISTS (
		SELECT *	 
		FROM [dbo].[TSBExchange]
		WHERE  [RequestId] = @requestid
		and [TSBId] = @tsbid
		
	)
	BEGIN
	if @status in ( 'R') 
	 UPDATE [dbo].[TSBExchange]
		SET [FinishFlag] = COALESCE(@finishflag, [FinishFlag])
		, [Status] = @status
		, [ExchangeBHT]  = COALESCE(@exchangebht, [ExchangeBHT])
		, [BorrowBHT] = COALESCE(@borrowbht, [BorrowBHT])
		, [AdditionalBHT] = COALESCE(@additionalbht, [AdditionalBHT])
		, [ApproveBy] = @userid
		, [ApproveDate] = @tranactiondate
		, [ApproveRemark] = @remark
		, [LastUpdate] = @tranactiondate
		, [PeriodBegin] = COALESCE(@periodbegin, [PeriodBegin])
		, [PeriodEnd] = COALESCE(@periodend, [PeriodEnd])
		WHERE [RequestId] = @requestid
		and [TSBId] = @tsbid;

	if @status in ( 'A')
		UPDATE [dbo].[TSBExchange]
		SET [FinishFlag] = COALESCE(@finishflag, [FinishFlag])
		, [Status] = @status
		, [AppExchangeBHT]  = COALESCE(@exchangebht, [AppExchangeBHT])
		, [AppBorrowBHT] = COALESCE(@borrowbht, [AppBorrowBHT])
		, [AppAdditionalBHT] = COALESCE(@additionalbht, [AppAdditionalBHT])
		, [ApproveBy] = @userid
		, [ApproveDate] = @tranactiondate
		, [ApproveRemark] = @remark
		, [LastUpdate] = @tranactiondate
		WHERE [RequestId] = @requestid
		and [TSBId] = @tsbid;

	if @status in ( 'C')
		UPDATE [dbo].[TSBExchange]
		SET [FinishFlag] = COALESCE(@finishflag, [FinishFlag])
		, [Status] = @status
		, [ApproveBy] = @userid
		, [ApproveDate] = @tranactiondate
		, [ApproveRemark] = @remark
		, [LastUpdate] = @tranactiondate
		WHERE [RequestId] = @requestid
		and [TSBId] = @tsbid;


	if @status in ( 'F')
		UPDATE [dbo].[TSBExchange]
		SET [FinishFlag] = COALESCE(@finishflag, [FinishFlag])
		, [Status] = @status
		, [TSBReceiveBy] = @userid
		, [TSBReceiveDate] = @tranactiondate
		, [TSBReceiveRemark] = @remark
		, [LastUpdate] = @tranactiondate
		WHERE [RequestId] = @requestid
		and [TSBId] = @tsbid;

		/**
		UPDATE [dbo].[TSBExchange]
		SET [FinishFlag] = COALESCE(@finishflag, [FinishFlag])
		, [Status] = @status
		, [ExchangeBHT]  = COALESCE(@exchangebht, [ExchangeBHT])
		, [BorrowBHT] = COALESCE(@borrowbht, [BorrowBHT])
		, [AdditionalBHT] = COALESCE(@additionalbht, [AdditionalBHT])
		, [ApproveBy] = @userid
		, [ApproveDate] = @tranactiondate
		, [ApproveRemark] = @remark
		, [LastUpdate] = @tranactiondate
		, [PeriodBegin] = COALESCE(@periodbegin, [PeriodBegin])
		, [PeriodEnd] = COALESCE(@periodend, [PeriodEnd])
		WHERE [RequestId] = @requestid
		and [TSBId] = @tsbid;
		**/
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[TSBExchange]
           ( [RequestId],[TSBId],[RequestDate] ,[FinishFlag],[TSBRequestBy]
		   ,[ExchangeBHT],[BorrowBHT],[AdditionalBHT],[PeriodBegin],[PeriodEnd],[RequestRemark]
		   ,[Status],[LastUpdate])
     VALUES (  @requestid , @tsbid, @tranactiondate, @finishflag, @userid
	         ,@exchangebht,@borrowbht, @additionalbht,@periodbegin,@periodend,@remark
			  ,@status , @tranactiondate)


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END



