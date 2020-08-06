SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseFeature](
	[LicenseTypeId] [int] NOT NULL,
	[Seq] [int] NOT NULL,
	[LimitUnitId] [int] NOT NULL,
	[NoOfLimit] [int] NOT NULL,
 CONSTRAINT [PK_LicenseFeature] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC,
	[Seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseFeature] ADD  CONSTRAINT [DF_LicenseFeature_NoOfLimit]  DEFAULT ((0)) FOR [NoOfLimit]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LicenseTypeId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'LicenseTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Feature Sequence.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'Seq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Limit Unit Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of Limit Unit (<= 0 = Unlimited).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseFeature', @level2type=N'COLUMN',@level2name=N'NoOfLimit'
GO
