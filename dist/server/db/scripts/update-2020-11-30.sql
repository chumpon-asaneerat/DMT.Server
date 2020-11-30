/*********** Script Update Date: 2020-11-30  ***********/
/****** Object:  Table [dbo].[TA_CreditLowLimit]    Script Date: 11/30/2020 11:15:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TA_CreditLowLimit](
	[TSBId] [nvarchar](5) NOT NULL,
	[Baht_1] [decimal](6, 0) NULL,
	[Baht_2] [decimal](6, 0) NULL,
	[Baht_5] [decimal](6, 0) NULL,
	[Baht_10] [decimal](6, 0) NULL,
	[Baht_20] [decimal](6, 0) NULL,
	[Baht_50] [decimal](6, 0) NULL,
	[Baht_100] [decimal](6, 0) NULL,
	[Baht_500] [decimal](6, 0) NULL,
	[Baht_1000] [decimal](6, 0) NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateBy] [nvarchar](10) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-11-30  ***********/
/****** Object:  StoredProcedure [dbo].[TA_UpdateCreditLowLimit]    Script Date: 11/30/2020 11:18:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


Create PROCEDURE [dbo].[TA_UpdateCreditLowLimit] (
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
		IF EXISTS (
		SELECT *	 
		FROM [dbo].[TA_CreditLowLimit]
		WHERE [TSBId] = @tsbid
		
	)
	BEGIN
	UPDATE [dbo].[TA_CreditLowLimit]
	SET [Baht_1] = COALESCE(@bht1, [Baht_1])
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
    WHERE [TSBId] = @tsbid;
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[TA_CreditLowLimit]
           ([TSBId] ,[Baht_1] ,[Baht_2] ,[Baht_5] ,[Baht_10] ,[Baht_20]
           ,[Baht_50] ,[Baht_100] ,[Baht_500] ,[Baht_1000] ,[UpdateDate],[UpdateBy])
     VALUES
           (@tsbid, @bht1 ,@bht2 ,@bht5, @bht10, @bht20, @bht50, @bht100, @bht500, @bht1000,
		   @updatedate , @userid );



		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO


