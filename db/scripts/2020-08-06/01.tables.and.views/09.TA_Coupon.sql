CREATE TABLE [dbo].[TA_Coupon](
	[CouponPK] int NOT NULL,
	[TransactionDate] [datetime]  NOT NULL,
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
	[SapChooseFlag] [char](1) NULL default  0,
	[SapChooseDate] [datetime] NULL
	) ON [PRIMARY]
GO