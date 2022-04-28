/*********** Script Update Date: 2022-04-28  ***********/

Create PROCEDURE [dbo].[Acc_SaveExchangeReceiveDetial] (
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
		FROM [dbo].[ExchangeReceiveDetail]
		WHERE  [RequestId] = @requestid
		and [TSBId] = @tsbid
		and [CurrencyDenomId] = @currencydenomid
		
	)
	BEGIN
	UPDATE [dbo].[ExchangeReceiveDetail]
		SET [CurrencyValue] = @currencyvalue
		, [CurrencyCount] = @currencycount
		WHERE [RequestId] = @requestid
		and [TSBId] = @tsbid
		and [CurrencyDenomId] = @currencydenomid;
	

	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[ExchangeReceiveDetail]
           ( [RequestId],[TSBId], [CurrencyDenomId],[CurrencyValue],[CurrencyCount])
     VALUES (  @requestid , @tsbid, @currencydenomid, @currencyvalue, @currencycount)


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

