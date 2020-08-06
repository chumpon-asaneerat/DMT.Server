SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseHistory](
	[HistoryId] [int] NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[LicenseTypeId] [int] NOT NULL,
	[MaxDevice] [int] NOT NULL,
	[MaxAccount] [int] NOT NULL,
	[MaxClient] [int] NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[BeginDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_LicenseHistory_1] PRIMARY KEY CLUSTERED 
(
	[HistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseHistory] ADD  CONSTRAINT [DF_LicenseHistory_MaxDevice]  DEFAULT ((0)) FOR [MaxDevice]
GO

ALTER TABLE [dbo].[LicenseHistory] ADD  CONSTRAINT [DF_LicenseHistory_MaxAccount]  DEFAULT ((0)) FOR [MaxAccount]
GO

ALTER TABLE [dbo].[LicenseHistory] ADD  CONSTRAINT [DF_LicenseHistory_MaxClient]  DEFAULT ((0)) FOR [MaxClient]
GO

ALTER TABLE [dbo].[LicenseHistory] ADD  CONSTRAINT [DF_LicenseHistory_RequestDate]  DEFAULT (getdate()) FOR [RequestDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The History Id (primary key)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseHistory', @level2type=N'COLUMN',@level2name=N'HistoryId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseHistory', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO
