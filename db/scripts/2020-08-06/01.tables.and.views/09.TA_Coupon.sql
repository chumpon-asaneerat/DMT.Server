CREATE TABLE [dbo].[TA_Coupon](
	[TransactionID] [varchar](10) NOT NULL,
	[TransactionDate] [datetime]  NOT NULL,
	[TSBId] [varchar](10) NOT NULL,
	[CouponType] [varchar](2) NOT NULL,
	[SerialNo] [varchar](7) NOT NULL,
	[Price] [decimal](6, 0) NOT NULL,
	[UserId] [varchar](10) NULL,
	[UserReceiveDate] [datetime] NULL,
	[CouponStatus] [char](1) NULL,
	[SoldDate] [datetime] NULL,
	[SoldBy] [varchar](10) NULL,
	[FinishFlag] [char](1) NULL,
	[TransferFlag] [char](1) NULL
	) ON [PRIMARY]
GO