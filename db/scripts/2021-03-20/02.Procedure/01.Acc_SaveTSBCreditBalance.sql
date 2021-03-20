/****** Object:  StoredProcedure [dbo].[Acc_SaveTSBCreditBalance]    Script Date: 20/3/2564 19:57:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


CREATE PROCEDURE [dbo].[Acc_SaveTSBCreditBalance] (
  @tsbid nvarchar(5)
, @amnt1 decimal(6,0)
, @amnt2 decimal(6,0)
, @amnt5 decimal(6,0)
, @amnt10 decimal(6,0)
, @amnt20 decimal(6,0)
, @amnt50 decimal(6,0)
, @amnt100 decimal(6,0)
, @amnt500 decimal(6,0)
, @amnt1000 decimal(6,0)
, @updatedate datetime
, @remark nvarchar(200)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
	IF EXISTS (
		SELECT *	 
		FROM [dbo].[TSBCreditBalance]
		WHERE [TSBId] = @tsbid
		
	)
	BEGIN

	UPDATE [dbo].[TSBCreditBalance]
	SET [Amnt1] = @amnt1
	, [Amnt2] = @amnt2
	, [Amnt5] = @amnt5
	, [Amnt10] = @amnt10
	, [Amnt20] = @amnt20
	, [Amnt50] = @amnt50
	, [Amnt100] = @amnt100
	, [Amnt500] = @amnt500
	, [Amnt1000] = @amnt1000
	, [BalanceDate] = @updatedate
	, [BalanceRemark] = @remark
    WHERE [TSBId] = @tsbid
	END
	ELSE
		
	INSERT INTO [dbo].[TSBCreditBalance]
           ([TSBId] ,[Amnt1] ,[Amnt2] ,[Amnt5] ,[Amnt10] ,[Amnt20]
           ,[Amnt50] ,[Amnt100] ,[Amnt500] ,[Amnt1000] ,[BalanceDate] ,[BalanceRemark] )
     VALUES
           (@tsbid, @amnt1 ,@amnt2 ,@amnt5, @amnt10, @amnt20, @amnt50, @amnt100, @amnt500, @amnt1000,
		   @updatedate , @remark);


		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO

