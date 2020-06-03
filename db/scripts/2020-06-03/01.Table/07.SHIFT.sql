USE [DMT_TATOD]
GO

/****** Object:  Table [dbo].[SHIFT]    Script Date: 6/3/2020 12:53:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SHIFT](
	[PLAZA_ID] [nchar](2) NOT NULL,
	[AGENT_ID] [nvarchar](5) NOT NULL,
	[SHIFT_ID] [datetime] NOT NULL,
	[SHIFT_END] [datetime] NULL,
	[SYSTEM_ID] [nvarchar](2) NULL,
	[SHI_SHIFT_ID] [datetime] NULL,
	[ENTRY_ID] [nchar](10) NULL
) ON [PRIMARY]
GO

