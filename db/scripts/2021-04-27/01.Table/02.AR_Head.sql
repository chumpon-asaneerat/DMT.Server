SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AR_Head](
	[RunNo] [int] NOT NULL,
	[DocNum] [int] NULL,
	[DocType] [nvarchar](15) NULL,
	[DocDate] [nvarchar](8) NOT NULL,
	[DocDueDate] [nvarchar](8) NULL,
	[CardCode] [nvarchar](15) NOT NULL,
	[CardName] [nvarchar](100) NULL,
	[NumAtCard] [nvarchar](50) NULL,
	[Comments] [nvarchar](50) NULL,
	[TollWayId] [smallint] NOT NULL,
	[ExportExcel] [bit] NULL,
	[InsertDate] [datetime] NULL,
	[ExportDate] [datetime] NULL,
	[PaymentGroupCode] [smallint] NULL,
 CONSTRAINT [PK_AR_Head] PRIMARY KEY CLUSTERED 
(
	[RunNo] ASC,
	[DocDate] ASC,
	[CardCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO