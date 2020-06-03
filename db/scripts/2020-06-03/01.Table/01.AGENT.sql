/****** Object:  Table [dbo].[AGENT]    Script Date: 6/3/2020 12:48:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AGENT](
	[AGENT_ID] [nvarchar](5) NOT NULL,
	[AGENT_NAME] [nvarchar](30) NULL,
	[POSITION_ID] [nchar](1) NULL,
	[FLAG] [nchar](1) NULL
) ON [PRIMARY]
GO

