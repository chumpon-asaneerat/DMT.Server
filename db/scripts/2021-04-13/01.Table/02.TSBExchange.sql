
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