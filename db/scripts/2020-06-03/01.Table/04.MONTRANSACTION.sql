
/****** Object:  Table [dbo].[MONTRANSACTION]    Script Date: 6/3/2020 12:51:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MONTRANSACTION](
	[TRANS_TYPE] [nchar](1) NOT NULL,
	[PLAZA_ID] [nchar](2) NOT NULL,
	[AGENT_ID] [nvarchar](5) NULL,
	[AMNT_1] [numeric](5, 0) NULL,
	[AMNT_2] [numeric](5, 0) NULL,
	[AMNT_5] [numeric](5, 0) NULL,
	[AMNT_10] [numeric](5, 0) NULL,
	[AMNT_20] [numeric](5, 0) NULL,
	[AMNT_50] [numeric](5, 0) NULL,
	[AMNT_100] [numeric](5, 0) NULL,
	[AMNT_500] [numeric](5, 0) NULL,
	[AMNT_1000] [numeric](5, 0) NULL,
	[TRANS_DATE] [datetime] NULL,
	[TRANS_REMARK] [nvarchar](100) NULL
) ON [PRIMARY]
GO

