/*********** Script Update Date: 2020-08-13  ***********/
DROP TABLE [dbo].[TA_Coupon]
GO

/****** Object:  Table [dbo].[TA_Coupon]    Script Date: 8/13/2020 7:41:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TA_Coupon](
	[CouponPK] [int] IDENTITY(1,1) NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[CouponType] [varchar](2) NOT NULL,
	[SerialNo] [nvarchar](7) NOT NULL,
	[Price] [decimal](6, 0) NOT NULL,
	[UserId] [nvarchar](10) NULL,
	[UserReceiveDate] [datetime] NULL,
	[CouponStatus] [char](1) NULL,
	[SoldDate] [datetime] NULL,
	[SoldBy] [nvarchar](10) NULL,
	[LaneId] [nvarchar](10) NULL,
	[FinishFlag] [char](1) NULL,
	[SapChooseFlag] [char](1) NULL,
	[SapChooseDate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TA_Coupon] ADD  DEFAULT ((0)) FOR [SapChooseFlag]
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
      ,[UserId] = COALESCE(@userid, [UserId])
      ,[UserReceiveDate] = COALESCE(@userreceivedate, [UserReceiveDate])
      ,[CouponStatus] = COALESCE(@Couponstatus, [CouponStatus])
      ,[SoldDate] = COALESCE(@solddate, [SoldDate])
      ,[SoldBy] = COALESCE(@soldby, [SoldBy])
      ,[FinishFlag] = COALESCE(@finishflag, [FinishFlag])
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

GO

/*********** Script Update Date: 2020-08-13  ***********/
ALTER PROCEDURE [dbo].[TCTSaveLaneAttendance] (
  @jobid nvarchar(20)
 , @tsbid nvarchar(5)
, @plazaid nvarchar(10)
, @laneid nvarchar(10)
, @userid nvarchar(10)
, @boj datetime
, @eoj datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @plazagroupid nvarchar(10) = NULL;
DECLARE @tsb nvarchar(5) = NULL;

	select @plazagroupid = [PlazaGroupId] ,
	        @tsb = [TSBId]
	FROM [dbo].[Lane]
	WHERE	[LaneId] = @laneid ;
		--and [PlazaId] = @plazaid
		
	BEGIN TRY
		IF EXISTS (
		SELECT *	 
		FROM [dbo].[LaneAttendance]
		WHERE [JobId] = @jobid
		and  [LaneId] = @laneid
		and [PlazaId] = @plazaid
		
	)
	BEGIN
	UPDATE [dbo].[LaneAttendance]
	SET [EOJ] = @eoj
    WHERE [JobId] = @jobid
		and  [LaneId] = @laneid
		and [PlazaId] = @plazaid;
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[LaneAttendance]
           ([JobId],[TSBId],[PlazaGroupId],[PlazaId],[LaneId],[UserId],[BOJ],[EOJ] )
     VALUES ( @jobid , @tsb , @plazagroupid, @plazaid
	         ,@laneid , @userid , @boj ,@eoj )


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

/*********** Script Update Date: 2020-08-13  ***********/
ALTER PROCEDURE [dbo].[TCTSoldCoupon] (
  @tsbid nvarchar(5)
, @coupontype nvarchar(2)
, @serialno nvarchar(7)
, @price decimal(6,0)
, @userid nvarchar(10)
, @solddate datetime
, @laneid nvarchar(10)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @tsb nvarchar(5) = NULL;

	select @tsb = [TSBId]
	FROM [dbo].[Lane]
	WHERE	[LaneId] = @laneid ;
		--and [PlazaId] = @plazaid
BEGIN TRY

	UPDATE [dbo].[TA_Coupon]
	SET [CouponStatus] = 3
      ,[SoldDate] = @solddate
      ,[SoldBy] = @userid
      , [LaneId] = @laneid
	WHERE [SerialNo] = @serialno 
		and [CouponType]  = @coupontype
		and [TSBId] = @tsb
		and [UserId] = @userid;
	
	
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

/*********** Script Update Date: 2020-08-13  ***********/
CREATE PROCEDURE [dbo].[TAGetCouponList]
(
    @tsbid nvarchar(5)  ,
	@userid nvarchar(10) ,
	@transactiontype char(1),
	@coupontype nvarchar(2)
)
AS
BEGIN
    SELECT *
	FROM [dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = COALESCE(@tsbid, [TsbId])  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
     ORDER BY [couponType], [SerialNo] asc
END

GO

/*********** Script Update Date: 2020-08-13  ***********/

GO
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002202', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002203', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002204', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002205', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002206', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002207', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002208', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002209', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002210', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002211', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002212', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002213', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002214', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002215', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002216', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002217', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002218', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002219', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002220', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002221', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002222', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002223', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002224', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002225', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002226', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002227', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002228', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002229', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002230', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002231', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002232', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002233', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002234', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002235', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002236', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002237', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002238', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002239', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002240', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002241', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002242', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002243', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002244', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002245', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002246', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002247', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002248', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002249', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003502', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003503', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003504', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003505', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003506', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003509', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003510', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003511', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003512', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003513', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003514', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003515', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003516', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003517', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003518', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003521', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003522', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003523', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003524', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003525', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003526', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003527', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003528', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003529', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003530', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003531', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003532', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003533', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003534', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003535', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003536', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003537', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003538', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003539', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003540', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002302', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002303', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002304', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002305', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002306', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002307', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002308', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002309', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002310', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002311', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002312', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002313', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002314', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002315', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002316', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002317', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002318', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002319', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002320', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002321', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002322', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002323', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002324', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002325', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002326', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002327', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002328', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002329', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002330', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002331', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002332', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002333', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002334', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002335', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002336', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002337', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002338', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002339', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002340', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002341', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002342', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002343', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002344', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002345', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002346', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002347', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002348', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002349', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004002', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004003', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004004', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004005', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004006', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004009', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004010', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004011', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004012', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004013', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004014', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004015', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004016', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004017', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004018', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004021', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004022', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004023', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004024', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004025', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004026', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004027', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004028', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004029', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004030', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004031', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004032', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004033', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004034', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004035', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004036', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004037', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004038', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004039', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ( [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES ( CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C004040', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')

