
CREATE PROCEDURE [dbo].[TA_SaveReqExchangeDetial] (
  @requestid  int
, @tsbid nvarchar(5)
, @currencydenomid int
, @currencyvalue decimal(7,0)
, @currencycount decimal(7,0)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
		IF EXISTS (
		SELECT *	 
		FROM [dbo].[ExchangeRequestDetail]
		WHERE  [RequestId] = @requestid
		and [TSBId] = @tsbid
		and [CurrencyDenomId] = @currencydenomid
		
	)
	BEGIN
	UPDATE [dbo].[ExchangeRequestDetail]
		SET [CurrencyValue] = @currencyvalue
		, [CurrencyCount] = @currencycount
		WHERE [RequestId] = @requestid
		and [TSBId] = @tsbid
		and [CurrencyDenomId] = @currencydenomid;
	

	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[ExchangeRequestDetail]
           ( [RequestId],[TSBId],[CurrencyDenomId] ,[CurrencyValue],[CurrencyCount])
     VALUES (  @requestid , @tsbid, @currencydenomid, @currencyvalue, @currencycount)


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO
