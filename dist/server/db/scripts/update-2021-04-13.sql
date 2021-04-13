/*********** Script Update Date: 2021-04-13  ***********/
CREATE TABLE [dbo].[CurrencyDenom](
	[CurrencyId] [int] NULL,
	[CurrencyDenomId] [int] NULL,
	[Abbreviation] [nvarchar](10) NULL,
	[Description] [nvarchar](20) NULL,
	[DenomValue] [decimal](7, 2) NULL,
	[DenomTypeId] [int] NULL,
	[UseFlag] [int] NULL
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-04-13  ***********/

CREATE TABLE [dbo].[TSBExchange](
	[RequestId] [int] NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[RequestDate] [datetime] NULL,
	[FinishFlag] [nchar](1) NULL,
	[TSBRequestBy] [nvarchar](10) NULL,
	[ExchangeBHT] [decimal](8, 0) NULL,
	[BorrowBHT] [decimal](7, 0) NULL,
	[AdditionalBHT] [decimal](7, 0) NULL,
	[PeriodBegin] [datetime] NULL,
	[PeriodEnd] [datetime] NULL,
	[RequestRemark] [nvarchar](255) NULL,
	[Status] [nchar](1) NULL,
	[AppExchangeBHT] [decimal](8, 0) NULL,
	[AppBorrowBHT] [decimal](7, 0) NULL,
	[AppAdditionalBHT] [decimal](7, 0) NULL,
	[ApproveDate] [datetime] NULL,
	[ApproveBy] [nvarchar](10) NULL,
	[ApproveRemark] [nvarchar](255) NULL,
	[TSBReceiveDate] [datetime] NULL,
	[TSBReceiveBy] [nvarchar](10) NULL,
	[TSBReceiveRemark] [nvarchar](255) NULL,
	[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-04-13  ***********/

CREATE TABLE [dbo].[ExchangeApproveDetail](
	[RequestId] [int] NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[CurrencyDenomId] [int] NULL,
	[CurrencyValue] [decimal](7, 0) NULL,
	[CurrencyCount] [decimal](7, 0) NULL
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-04-13  ***********/

CREATE TABLE [dbo].[ExchangeReceiveDetail](
	[RequestId] [int] NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[CurrencyDenomId] [int] NULL,
	[CurrencyValue] [decimal](7, 0) NULL,
	[CurrencyCount] [decimal](7, 0) NULL
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-04-13  ***********/
CREATE TABLE [dbo].[ExchangeRequestDetail](
	[RequestId] [int] NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[CurrencyDenomId] [int] NULL,
	[CurrencyValue] [decimal](7, 0) NULL,
	[CurrencyCount] [decimal](7, 0) NULL
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-04-13  ***********/

CREATE PROCEDURE [dbo].[TA_SaveExchangeTransaction] (
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

GO

/*********** Script Update Date: 2021-04-13  ***********/

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


/*********** Script Update Date: 2021-04-13  ***********/

create PROCEDURE [dbo].[Acc_getReqDatabyStatus]
(
   @status nchar(1)
)
AS
BEGIN
select T.TSBId, T.TSB_Th_Name , E.RequestDate , E.ExchangeBHT , E.BorrowBHT , E.AdditionalBHT
, E.PeriodBegin ,E.PeriodEnd , E.RequestRemark , E.TSBRequestBy 
, E.AppExchangeBHT , E.AppBorrowBHT , E.AppAdditionalBHT , E.ApproveBy ,E.ApproveDate , E.ApproveRemark
from [dbo].[TSBExchange] E , [dbo].[TSB] T
where  E.TSBId = T.TSBId
and E.Status = COALESCE(@status, E.Status)  
order by T.TSBId


END
GO

/*********** Script Update Date: 2021-04-13  ***********/

create PROCEDURE [dbo].[Acc_getReqDetail]
(
   @requestid int,
   @tsbid nvarchar(5)
)
AS
BEGIN
select *
from [dbo].[ExchangeRequestDetail]
where  RequestId = @requestid
and TSBId = @tsbid  
order by CurrencyDenomId


END
GO

/*********** Script Update Date: 2021-04-13  ***********/

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

/*********** Script Update Date: 2021-04-13  ***********/

Create PROCEDURE [dbo].[TA_GetUpdateReqData]
(
    @tsbid nvarchar(5)  ,
	@transdate datetime
)
AS
BEGIN
    SELECT *
	FROM  [dbo].[TSBExchange]
     WHERE [TSBId] = COALESCE(@tsbid, [TSBId])  
	and [LastUpdate] > @transdate
     
END
GO

/*********** Script Update Date: 2021-04-13  ***********/

Create PROCEDURE [dbo].[TA_GetAccAppReqDetail]
(
    @requestid int ,
	@tsbid nvarchar(5)  
)
AS
BEGIN
      SELECT C.CurrencyDenomId , C.Description
	 ,  isnull(R.RequestId ,A.RequestId) RequestID , isnull(R.TSBId , A.TSBId) TSBId
	 , R.CurrencyValue  as RequestValue, R.CurrencyCount as RequestCount
	 , A.CurrencyValue as ApproveValue , A.CurrencyCount as  ApproveCount
	FROM  [dbo].[CurrencyDenom] C 
	FULL outer join ( select * from [dbo].[ExchangeRequestDetail]
					  where [RequestId] = COALESCE(@requestid, [RequestId]) 
					and TSBId = COALESCE(@tsbid, TSBId)  ) R  on C.[CurrencyDenomId] = R.[CurrencyDenomId]
	
	FULL outer join ( select * from [dbo].[ExchangeApproveDetail]
					  where [RequestId] = COALESCE(@requestid, [RequestId]) 
					and TSBId = COALESCE(@tsbid, TSBId)  ) A on C.[CurrencyDenomId] = A.[CurrencyDenomId]
     
     
END
GO

/*********** Script Update Date: 2021-04-13  ***********/
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 1, N'Satang25', N'25 Satang', CAST(0.25 AS Decimal(7, 2)), 2, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 2, N'Satang50', N'50 Satang', CAST(0.50 AS Decimal(7, 2)), 2, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 3, N'Baht1', N'1 Baht', CAST(1.00 AS Decimal(7, 2)), 2, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 4, N'Baht2', N'2 Baht', CAST(2.00 AS Decimal(7, 2)), 2, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 5, N'Baht5', N'5 Baht', CAST(5.00 AS Decimal(7, 2)), 2, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 6, N'CBaht10', N'10 Baht', CAST(10.00 AS Decimal(7, 2)), 2, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 7, N'NBaht10', N'10 Baht', CAST(10.00 AS Decimal(7, 2)), 1, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 8, N'NBaht20', N'20 Baht', CAST(20.00 AS Decimal(7, 2)), 1, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 9, N'NBaht50', N'50 Baht', CAST(50.00 AS Decimal(7, 2)), 1, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 10, N'NBaht100', N'100 Baht', CAST(100.00 AS Decimal(7, 2)), 1, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 11, N'NBaht500', N'500 Baht', CAST(500.00 AS Decimal(7, 2)), 1, 1)
INSERT [dbo].[CurrencyDenom] ([CurrencyId], [CurrencyDenomId], [Abbreviation], [Description], [DenomValue], [DenomTypeId], [UseFlag]) VALUES (1, 12, N'NBaht1000', N'1000 Baht', CAST(1000.00 AS Decimal(7, 2)), 1, 1)

