CREATE TABLE [dbo].[LaneAttendance](
	[JobId] [nvarchar](20) NOT NULL,
	[TSBId] [nvarchar](10) NOT NULL,
	[PlazaGroupId] [nvarchar](10) NULL,
	[PlazaId] [nvarchar](10) NOT NULL,
	[LaneId] [nvarchar](10) NULL,
	[UserId] [nvarchar](10) NULL,
	[BOJ] [datetime] NULL,
	[EOJ] [datetime] NULL,
	[RevenueDate] [datetime] NULL,
	[RevenueId] [nvarchar](20) NULL
	
) ON [PRIMARY]
GO

