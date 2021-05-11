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