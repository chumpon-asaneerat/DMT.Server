USE [DMT_TATOD]
GO

/****** Object:  Table [dbo].[MONEY]    Script Date: 6/3/2020 12:50:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MONEY](
	[AMNT_VALUE] [numeric](4, 0) NULL,
	[AMNT_ORDER] [numeric](2, 0) NULL,
	[MONEY_TYPE] [nchar](1) NULL
) ON [PRIMARY]
GO

