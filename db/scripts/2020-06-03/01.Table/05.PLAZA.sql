USE [DMT_TATOD]
GO

/****** Object:  Table [dbo].[PLAZA]    Script Date: 6/3/2020 12:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PLAZA](
	[PLAZA_ID] [nchar](2) NOT NULL,
	[PLAZA_ENG] [nvarchar](20) NULL,
	[PLAZA_THA] [nvarchar](20) NULL,
	[TOT_LANE] [numeric](2, 0) NULL
) ON [PRIMARY]
GO

