/****** Object:  Table [dbo].[TSBCreditBalance]    Script Date: 20/3/2564 19:10:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TSBCreditBalance](
	[TSBId] [nvarchar](5) NOT NULL,
	[Amnt1] [numeric](6, 0) NULL,
	[Amnt2] [numeric](6, 0) NULL,
	[Amnt5] [numeric](6, 0) NULL,
	[Amnt10] [numeric](6, 0) NULL,
	[Amnt20] [numeric](6, 0) NULL,
	[Amnt50] [numeric](6, 0) NULL,
	[Amnt100] [numeric](6, 0) NULL,
	[Amnt500] [numeric](6, 0) NULL,
	[Amnt1000] [numeric](6, 0) NULL,
	[BalanceDate] [datetime] NULL,
	[BalanceRemark] [nvarchar](200) NULL
) ON [PRIMARY]
GO

