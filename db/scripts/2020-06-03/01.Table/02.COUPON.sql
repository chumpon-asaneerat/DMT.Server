/****** Object:  Table [dbo].[COUPON]    Script Date: 6/3/2020 12:49:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[COUPON](
	[COUPON_CODE] [nchar](3) NOT NULL,
	[COUPON_TYPE] [nvarchar](10) NULL,
	[COUPON_PRICE] [numeric](6, 2) NULL,
	[ACTIVE_DATE] [datetime] NULL,
	[FLAG] [nchar](1) NULL
) ON [PRIMARY]
GO

