SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SAPCustomerCode](
	[CardCode] [nvarchar](15) NOT NULL,
	[CardName] [nvarchar](100) NULL,
	[UseFlag] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SAPCustomerCode] ADD  DEFAULT ((1)) FOR [UseFlag]
GO