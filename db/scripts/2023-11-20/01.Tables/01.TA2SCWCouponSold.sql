/****** Object:  Table [dbo].[TA2SCWCouponSold]    Script Date: 20/11/2566 12:32:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TA2SCWCouponSold](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TSBId] [nvarchar](5) NULL,
	[SoldBy] [nvarchar](10) NULL,
	[SoldDate] [date] NULL,
	[SerialNo] [nvarchar](7) NULL,
	[CouponType] [nvarchar](3) NULL,
	[Price] [decimal](6, 0) NULL,
	[TransactionDate] [datetime] NULL,
 CONSTRAINT [PK__TA2SCWCo__3214EC278BF8AFC8] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
