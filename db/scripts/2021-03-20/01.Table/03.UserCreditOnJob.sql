/****** Object:  Table [dbo].[UserCreditOnJob]    Script Date: 20/3/2564 19:11:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserCreditOnJob](
	[TSBId] [nvarchar](5) NOT NULL,
	[UserId] [nvarchar](10) NOT NULL,
	[UserPrefix] [nvarchar](10) NULL,
	[UserFirstName] [nvarchar](50) NULL,
	[UserLastName] [nvarchar](50) NULL,
	[BagNo] [nvarchar](20) NULL,
	[Credit] [numeric](6, 0) NULL,
	[Flag] [int] NULL,
	[CreditDate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserCreditOnJob] ADD  DEFAULT ((1)) FOR [Flag]
GO

