CREATE TABLE [dbo].[UserShift](
	[UserShiftId] [int] NOT NULL,
	[TSBId] [nvarchar](5) NULL,
	[ShiftId] [int] NULL,
	[UserId] [nvarchar](10) NULL,
	[BeginShift] [datetime] NULL,
	[EndShift] [datetime] NULL,
	[Status] [int] NULL,
	[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO

