SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TOD_TSBShift](
	[TSBShiftId] [nvarchar](36) NOT NULL,
	[TSBId] [nvarchar](10) NOT NULL,
	[ShiftId] [int] NOT NULL,
	[UserId] [varchar](10) NOT NULL,
	[FullNameEN] [nvarchar](150) NULL,
	[FullNameTH] [nvarchar](150) NULL,
	[BeginTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[TSBShiftId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO