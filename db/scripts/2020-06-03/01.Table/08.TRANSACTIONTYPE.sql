USE [DMT_TATOD]
GO

/****** Object:  Table [dbo].[TRANSACTIONTYPE]    Script Date: 6/3/2020 12:54:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TRANSACTIONTYPE](
	[TRANS_TYPE] [nchar](1) NULL, /* Type: 1 received, 2: returns */
	[TRANS_DESC] [nchar](10) NULL,
	[TRANS_GROUP] [nchar](1) NULL
) ON [PRIMARY]
GO

