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

