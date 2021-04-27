SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AR_Line](
	[RunNo] [int] NOT NULL,
	[ParentKey] [int] NOT NULL,
	[LineNum] [int] NOT NULL,
	[DocDate] [nvarchar](8) NOT NULL,
	[ItemCode] [nvarchar](3) NULL,
	[ItemDescription] [nvarchar](20) NULL,
	[Quantity] [decimal](18, 2) NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[PriceAfterVAT] [decimal](18, 2) NULL,
	[VatGroup] [nvarchar](3) NULL,
	[WarehouseCode] [nvarchar](8) NULL,
	[TollWayId] [smallint] NOT NULL,
	[ExportExcel] [bit] NULL,
	[InsertDate] [datetime] NULL,
	[ExportDate] [datetime] NULL,
 CONSTRAINT [PK_AR_Line] PRIMARY KEY CLUSTERED 
(
	[RunNo] ASC,
	[ParentKey] ASC,
	[LineNum] ASC,
	[DocDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO