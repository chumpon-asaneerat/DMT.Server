SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AR_Serial](
	[RunNo] [int] NOT NULL,
	[ParentKey] [int] NOT NULL,
	[InternalSerialNumber] [int] NOT NULL,
	[SerialNo] [nvarchar](7) NOT NULL,
	[BaseLineNumber] [int] NOT NULL,
	[DocDate] [nvarchar](8) NOT NULL,
	[TollWayId] [smallint] NOT NULL,
	[ExportExcel] [bit] NULL,
	[InsertDate] [datetime] NULL,
	[ExportDate] [datetime] NULL,
 CONSTRAINT [PK_AR_Serial_1] PRIMARY KEY CLUSTERED 
(
	[RunNo] ASC,
	[ParentKey] ASC,
	[InternalSerialNumber] ASC,
	[DocDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO