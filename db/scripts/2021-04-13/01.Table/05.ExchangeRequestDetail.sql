CREATE TABLE [dbo].[ExchangeRequestDetail](
	[RequestId] [int] NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[CurrencyDenomId] [int] NULL,
	[CurrencyValue] [decimal](7, 0) NULL,
	[CurrencyCount] [decimal](7, 0) NULL
) ON [PRIMARY]
GO