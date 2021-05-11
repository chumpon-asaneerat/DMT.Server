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