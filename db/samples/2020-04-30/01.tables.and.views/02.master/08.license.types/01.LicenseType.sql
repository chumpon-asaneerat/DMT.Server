SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseType](
	[LicenseTypeId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[AdText] [nvarchar](max) NOT NULL,
	[PeriodUnitId] [int] NOT NULL,
	[NumberOfUnit] [int] NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[CurrencySymbol] [nvarchar](5) NOT NULL,
	[CurrencyText] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_LicenseType_1] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_PeriodDays]  DEFAULT ((30)) FOR [NumberOfUnit]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_Price]  DEFAULT ((0.00)) FOR [Price]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_CurrencySymbol]  DEFAULT (N'$') FOR [CurrencySymbol]
GO

ALTER TABLE [dbo].[LicenseType] ADD  CONSTRAINT [DF_LicenseType_CurrencyEN]  DEFAULT (N'USD') FOR [CurrencyText]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Advertise Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'AdText'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The period unit id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'PeriodUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default number of period unit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'NumberOfUnit'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'Price'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Currency Symbol' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'CurrencySymbol'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Currency Unit Text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseType', @level2type=N'COLUMN',@level2name=N'CurrencyText'
GO
