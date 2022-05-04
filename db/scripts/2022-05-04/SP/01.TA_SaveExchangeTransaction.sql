
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
	/**
	if @status in ( 'C' , 'A')
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

		**/
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


/*********** Script Update Date: 2020-08-13  ***********/

