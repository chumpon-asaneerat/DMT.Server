SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********** Script Update Date: 2020-08-13  ***********/


ALTER PROCEDURE [dbo].[TA_UpdateCreditLowLimit] (
  @tsbid nvarchar(5)
, @bht1 decimal(6,0)
, @bht2 decimal(6,0)
, @bht5 decimal(6,0)
, @bht10 decimal(6,0)
, @bht20 decimal(6,0)
, @bht50 decimal(6,0)
, @bht100 decimal(6,0)
, @bht500 decimal(6,0)
, @bht1000 decimal(6,0)
, @userid nvarchar(10)
, @updatedate datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
BEGIN TRY
		/*	IF EXISTS (
		SELECT *	 
		FROM [dbo].[TA_CreditLowLimit]
		WHERE [TSBId] = @tsbid
		
	)
	BEGIN

	UPDATE [dbo].[TA_CreditLowLimit]
	SET [Baht_1] = @bht1
	, [Baht_2] = COALESCE(@bht2, [Baht_2])
	, [Baht_5] = COALESCE(@bht5, [Baht_5])
	, [Baht_10] = COALESCE(@bht10, [Baht_10])
	, [Baht_20] = COALESCE(@bht20, [Baht_20])
	, [Baht_50] = COALESCE(@bht50, [Baht_50])
	, [Baht_100] = COALESCE(@bht100, [Baht_100])
	, [Baht_500] = COALESCE(@bht500, [Baht_500])
	, [Baht_1000] = COALESCE(@bht1000, [Baht_1000])
	, [UpdateDate] = COALESCE(@updatedate, [UpdateDate])
	, [UpdateBy]  = COALESCE(@userid, [UpdateBy])
    WHERE [TSBId] = @tsbid
	and [useflag] = 1;
	*/
	UPDATE [dbo].[TA_CreditLowLimit]
	SET [useflag] = 0
	 WHERE [TSBId] = @tsbid
	and [useflag] = 1;
	
	INSERT INTO [dbo].[TA_CreditLowLimit]
           ([TSBId] ,[Baht_1] ,[Baht_2] ,[Baht_5] ,[Baht_10] ,[Baht_20]
           ,[Baht_50] ,[Baht_100] ,[Baht_500] ,[Baht_1000] ,[UpdateDate],[UpdateBy])
     VALUES
           (@tsbid, @bht1 ,@bht2 ,@bht5, @bht10, @bht20, @bht50, @bht100, @bht500, @bht1000,
		   @updatedate , @userid );


		
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO