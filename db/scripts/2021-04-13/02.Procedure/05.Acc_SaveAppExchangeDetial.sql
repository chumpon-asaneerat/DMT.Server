
create PROCEDURE [dbo].[Acc_SaveAppExchangeDetial] (
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
		FROM [dbo].[ExchangeApproveDetail]
		WHERE  [RequestId] = @requestid
		and [TSBId] = @tsbid
		and [CurrencyDenomId] = @currencydenomid
		
	)
	BEGIN
	UPDATE [dbo].[ExchangeApproveDetail]
		SET [CurrencyValue] = @currencyvalue
		, [CurrencyCount] = @currencycount
		WHERE [RequestId] = @requestid
		and [TSBId] = @tsbid
		and [CurrencyDenomId] = @currencydenomid;
	

	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[ExchangeApproveDetail]
           ( [RequestId],[TSBId], [CurrencyDenomId],[CurrencyValue],[CurrencyCount])
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