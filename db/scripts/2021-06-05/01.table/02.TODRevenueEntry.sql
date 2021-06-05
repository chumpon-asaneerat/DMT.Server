SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TODRevenueEntry](
	[PKId] [nvarchar](36) NOT NULL,
	[EntryDate] [datetime] NOT NULL,
	[RevenueDate] [datetime] NOT NULL,
	[RevenueId] [nvarchar](20) NOT NULL,
	[BagNo] [nvarchar](10) NOT NULL,
	[BeltNo] [nvarchar](20) NOT NULL,
	[IsHistorical] [int] NOT NULL,
	[Lanes] [nvarchar](100) NULL,
	[PlazaNames] [nvarchar](100) NULL,
	[ShiftBegin] [datetime] NOT NULL,
	[ShiftEnd] [datetime] NOT NULL,
	[TSBId] [nvarchar](10) NOT NULL,
	[PlazaGroupId] [nvarchar](10) NOT NULL,
	[ShiftId] [int] NOT NULL,
	[UserId] [nvarchar](10) NOT NULL,
	[CollectorNameEN] [nvarchar](150) NULL,
	[CollectorNameTH] [nvarchar](150) NULL,
	[SupervisorId] [nvarchar](10) NOT NULL,
	[SupervisorNameEN] [nvarchar](150) NULL,
	[SupervisorNameTH] [nvarchar](150) NULL,
	[TrafficST25] [int] NULL,
	[TrafficST50] [int] NULL,
	[TrafficBHT1] [int] NULL,
	[TrafficBHT2] [int] NULL,
	[TrafficBHT5] [int] NULL,
	[TrafficBHT10] [int] NULL,
	[TrafficBHT20] [int] NULL,
	[TrafficBHT50] [int] NULL,
	[TrafficBHT100] [int] NULL,
	[TrafficBHT500] [int] NULL,
	[TrafficBHT1000] [int] NULL,
	[TrafficBHTTotal] [float] NULL,
	[TrafficRemark] [nvarchar](255) NULL,
	[OtherBHTTotal] [float] NULL,
	[OtherRemark] [nvarchar](255) NULL,
	[CouponUsageBHT30] [int] NULL,
	[CouponUsageBHT35] [int] NULL,
	[CouponUsageBHT60] [int] NULL,
	[CouponUsageBHT70] [int] NULL,
	[CouponUsageBHT80] [int] NULL,
	[FreePassUsageClassA] [int] NULL,
	[FreePassUsageOther] [int] NULL,
	[CouponSoldBHT35] [int] NULL,
	[CouponSoldBHT80] [int] NULL,
	[CouponSoldBHT35Factor] [float] NULL,
	[CouponSoldBHT80Factor] [float] NULL,
	[CouponSoldBHT35Total] [float] NULL,
	[CouponSoldBHT80Total] [float] NULL,
	[CouponSoldBHTTotal] [float] NULL,
	[Status] [int] NULL,
	[LastUpdate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[PKId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO