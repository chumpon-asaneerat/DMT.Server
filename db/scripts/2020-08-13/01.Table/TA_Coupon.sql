DROP TABLE [dbo].[TA_Coupon]
GO

/****** Object:  Table [dbo].[TA_Coupon]    Script Date: 8/13/2020 7:41:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TA_Coupon](
	[CouponPK] [int] IDENTITY(1,1) NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[CouponType] [varchar](2) NOT NULL,
	[SerialNo] [nvarchar](7) NOT NULL,
	[Price] [decimal](6, 0) NOT NULL,
	[UserId] [nvarchar](10) NULL,
	[UserReceiveDate] [datetime] NULL,
	[CouponStatus] [char](1) NULL,
	[SoldDate] [datetime] NULL,
	[SoldBy] [nvarchar](10) NULL,
	[LaneId] [nvarchar](10) NULL,
	[FinishFlag] [char](1) NULL,
	[SapChooseFlag] [char](1) NULL,
	[SapChooseDate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TA_Coupon] ADD  DEFAULT ((0)) FOR [SapChooseFlag]
GO