
/****** Object:  Table [dbo].[PLAZA_BALANCE]    Script Date: 6/3/2020 12:53:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PLAZA_BALANCE](
	[PLAZA_ID] [nchar](2) NOT NULL,
	[AMNT_1] [numeric](5, 0) NULL,
	[AMNT_2] [numeric](5, 0) NULL,
	[AMNT_5] [numeric](5, 0) NULL,
	[AMNT_10] [numeric](5, 0) NULL,
	[AMNT_20] [numeric](5, 0) NULL,
	[AMNT_50] [numeric](5, 0) NULL,
	[AMNT_100] [numeric](5, 0) NULL,
	[AMNT_500] [numeric](5, 0) NULL,
	[AMNT_1000] [numeric](5, 0) NULL,
	[BALANCE_DATE] [datetime] NULL,
	[BALANCE_REMARK] [nvarchar](200) NULL
) ON [PRIMARY]
GO

