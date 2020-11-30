DROP TABLE [dbo].[TA_Coupon]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TA_Coupon](
	[CouponPK] [int] IDENTITY(1,1) NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[CouponType] [varchar](3) NOT NULL,
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
	[SapChooseDate] [datetime] NULL,
	[SAPSysSerial] [int] NULL,
	[SAPWhsCode] [nvarchar](3) NULL,
	[TollWayId] [smallint] NULL,
	[SAPItemName] [nvarchar](20) NULL
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [dbo].[TA_Coupon] OFF
ALTER TABLE [dbo].[TA_Coupon] ADD  DEFAULT ((0)) FOR [SapChooseFlag]
GO