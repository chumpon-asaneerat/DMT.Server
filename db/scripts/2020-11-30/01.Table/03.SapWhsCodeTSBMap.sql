SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SapWhsCodeTSBMap](
	[TSBId] [nvarchar](5) NULL,
	[TollwayID] [smallint] NULL,
	[SapWhsCode] [nvarchar](3) NULL
) ON [PRIMARY]
GO