/*********** Script Update Date: 2021-05-11  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Acc_getReqDatabyStatus]
(
   @status nchar(1)
)
AS
BEGIN
select T.TSBId, T.TSB_Th_Name 
, E.RequestId 
, E.RequestDate , E.ExchangeBHT , E.BorrowBHT , E.AdditionalBHT
, E.PeriodBegin ,E.PeriodEnd , E.RequestRemark , E.TSBRequestBy 
, E.AppExchangeBHT , E.AppBorrowBHT , E.AppAdditionalBHT , E.ApproveBy ,E.ApproveDate , E.ApproveRemark
from [dbo].[TSBExchange] E , [dbo].[TSB] T
where  E.TSBId = T.TSBId
and E.Status = COALESCE(@status, E.Status)  
order by T.TSBId

END

GO


/*********** Script Update Date: 2021-05-11  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TSBCreditApprove](
	[TSBId] [nvarchar](5) NULL,
	[MaxCredit] [decimal](8, 0) NULL,
	[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-05-11  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TSBCreditAppTrans](
	[TSBId] [nvarchar](5) NULL,
	[CreditApprove] [decimal](8, 0) NULL,
	[CreditActual] [decimal](8, 0) NULL,
	[ApproveDate] [datetime] NULL,
	[ApproveType] [nchar](1) NULL,
	[ApproveFileName] [nchar](10) NULL,
	[ApproveBy] [nvarchar](10) NULL
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-05-11  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[Acc_getTSBCreditAppList]

AS
BEGIN
select T.TSBId, T.TSB_Th_Name , C.MaxCredit , isnull(TB.tsbbalance,0) tsbbalance
from TSB T  
join TSBCreditApprove C on T.TSBId = C.TSBId
full outer join 
(select B.TSBId
, Amnt1+Amnt2+Amnt5+Amnt10+Amnt20+Amnt50+Amnt100+Amnt500+Amnt1000+U.usercrdit As tsbbalance
from [dbo].[TSBCreditBalance] B Full outer join 
(select TSBId , sum(Credit) usercrdit 
from [dbo].[UserCreditOnJob]
where Flag = 0
group by TSBId ) U  on B.TSBId = U.TSBId) TB on T.TSBId = TB.TSBId
order by T.TSBId


END
GO

/*********** Script Update Date: 2021-05-11  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[Acc_getTSBCreditAppTrans]
(
  @tsbid nvarchar(5)
)
AS
BEGIN

select *
from [dbo].[TSBCreditAppTrans]
where [TSBId] = @tsbid
order by [ApproveDate] asc


END
GO

/*********** Script Update Date: 2021-05-11  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


Create PROCEDURE [dbo].[Acc_SaveCreditApproveTrans] (
  @tsbid nvarchar(5)
, @creapprove decimal(8,0)
, @creactual decimal(6,0)
, @approvetype nchar(1)
, @filename nvarchar(100)
, @approveby nvarchar(10)
, @approvedate datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
BEGIN TRY

INSERT INTO [dbo].[TSBCreditAppTrans]
           ([TSBId] ,[CreditApprove] ,[CreditActual] ,[ApproveDate]
           ,[ApproveType] ,[ApproveFileName],[ApproveBy])
     VALUES
          (@tsbid, @creapprove ,@creactual ,@approvedate, @approvetype, @filename, @approveby)

update [dbo].[TSBCreditApprove]
	set MaxCredit = @creapprove
	, LastUpdate = @approvedate
where TSBId = @tsbid
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END




GO

/*********** Script Update Date: 2021-05-11  ***********/
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'01', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'02', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'03', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'04', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'05', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'06', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'07', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'08', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))
INSERT [dbo].[TSBCreditApprove] ([TSBId], [MaxCredit], [LastUpdate]) VALUES (N'09', CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime))


/*********** Script Update Date: 2021-05-11  ***********/
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'01', CAST(0 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'02', CAST(0 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'03', CAST(0 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'04', CAST(0 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'05', CAST(0 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'06', CAST(0 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'07', CAST(0 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'08', CAST(0 AS Decimal(8, 0)), CAST(100000 AS Decimal(8, 0)), CAST(N'2021-05-09T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'09', CAST(0 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), NULL, NULL, NULL)
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'08', CAST(100000 AS Decimal(8, 0)), CAST(300000 AS Decimal(8, 0)), CAST(N'2021-05-10T12:00:00.000' AS DateTime), N'I', N'AAA.pdf   ', N'00444')
INSERT [dbo].[TSBCreditAppTrans] ([TSBId], [CreditApprove], [CreditActual], [ApproveDate], [ApproveType], [ApproveFileName], [ApproveBy]) VALUES (N'08', CAST(300000 AS Decimal(8, 0)), CAST(200000 AS Decimal(8, 0)), CAST(N'2021-05-11T12:00:00.000' AS DateTime), N'D', N'A08.pdf   ', N'00444')

