/*********** Script Update Date: 2020-12-29  ***********/
ALTER TABLE [dbo].[TA_Coupon] 
ADD sendtaflag CHAR(1) DEFAULT(0)
GO



/*********** Script Update Date: 2020-12-29  ***********/

ALTER TABLE [dbo].[TA_CreditLowLimit] DROP CONSTRAINT [DF__TA_Credit__usefl__7CD98669]
GO

/****** Object:  Table [dbo].[TA_CreditLowLimit]    Script Date: 12/29/2020 1:07:58 PM ******/
DROP TABLE [dbo].[TA_CreditLowLimit]
GO

/****** Object:  Table [dbo].[TA_CreditLowLimit]    Script Date: 12/29/2020 1:07:58 PM ******/
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
	[UpdateBy] [nvarchar](10) NULL,
	[useflag] [char](1) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TA_CreditLowLimit] ADD  DEFAULT ((1)) FOR [useflag]
GO



/*********** Script Update Date: 2020-12-29  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[TAGetCouponList]
(
    @tsbid nvarchar(5)  ,
	@userid nvarchar(10) ,
	@transactiontype char(1),
	@coupontype nvarchar(2),
	@flag char(1)
)
AS
BEGIN
if @flag = 0 
    SELECT *
	FROM [dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = COALESCE(@tsbid, [TsbId])  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
	 and [FinishFlag] = 1
	 and [sendtaflag] = 0
     ORDER BY [couponType], [SerialNo] asc


if @flag  is null 
  SELECT *
	FROM [dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = COALESCE(@tsbid, [TsbId])  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
	 and [FinishFlag] = 1
	 ORDER BY [couponType], [SerialNo] asc
END

GO

/*********** Script Update Date: 2020-12-29  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


ALTER PROCEDURE [dbo].[SaveTACoupon] (
  @couponpk int
 ,@transactionid  int
, @transactiondate datetime
, @tsbid nvarchar(5)
, @coupontype varchar(2)
, @serialno nvarchar(7)
, @price decimal(6,0)
, @userid nvarchar(10)
, @userreceivedate datetime
, @Couponstatus char(1)
, @solddate datetime
, @soldby nvarchar(10)
, @finishflag char(1)
, @sendtaflag char(1)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
		IF EXISTS (
		SELECT *	 
		FROM[dbo].[TA_Coupon] 
		WHERE [SerialNo] = @serialno
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid
		
	)
	BEGIN
	UPDATE [dbo].[TA_Coupon]
	SET [Price] = COALESCE(@price, [Price])
      ,[UserId] = @userid
      ,[UserReceiveDate] = @userreceivedate
      ,[CouponStatus] = COALESCE(@Couponstatus, [CouponStatus])
      ,[SoldDate] = COALESCE(@solddate, [SoldDate])
      ,[SoldBy] = COALESCE(@soldby, [SoldBy])
      ,[FinishFlag] = COALESCE(@finishflag, [FinishFlag])
	  ,[sendtaflag] = COALESCE(@sendtaflag, [sendtaflag])
    WHERE [SerialNo] = @serialno
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid;
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[TA_Coupon]
           ( [TransactionDate],[TSBId] ,[CouponType] ,[SerialNo]
           ,[Price] ,[CouponStatus] ,[FinishFlag] )
     VALUES (  @transactiondate , @tsbid, @coupontype, @serialno
	         ,@price , @Couponstatus , @finishflag )


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO


/*********** Script Update Date: 2020-12-29  ***********/
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

/*********** Script Update Date: 2020-12-29  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*********** Script Update Date: 2020-08-06  ***********/
CREATE PROCEDURE [dbo].[GetTSBLowLimit]
(
    @tsbid nvarchar(5)  
)
AS
BEGIN
    SELECT *
	FROM  [dbo].[TA_CreditLowLimit]
     WHERE  [TsbId] = @tsbid  
	 
END

GO


