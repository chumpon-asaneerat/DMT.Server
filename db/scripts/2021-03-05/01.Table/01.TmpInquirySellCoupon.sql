SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TmpInquirySellCoupon](
	[SAPItemCode] [nvarchar](10) NULL,
	[SAPIntrSerial] [nvarchar](15) NULL,
	[SAPSysSerial] [int] NOT NULL,
	[SAPTransferNo] [varchar](20) NULL,
	[SAPTransferDate] [datetime] NULL,
	[ItemStatus] [nvarchar](15) NULL,
	[ItemStatusDigit] [tinyint] NULL,
	[TollWayName] [nvarchar](50) NULL,
	[TollWayId] [smallint] NOT NULL,
	[WorkingDate] [datetime] NULL,
	[ShiftName] [nvarchar](10) NULL,
	[SAPARInvoice] [varchar](30) NULL,
	[SAPARDate] [datetime] NULL,
	[ShiftId] [int] NULL
) ON [PRIMARY]
GO