SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LicenseTypeML](
	[LicenseTypeId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](100) NULL,
	[AdText] [nvarchar](max) NULL,
	[Price] [decimal](18, 2) NULL,
	[CurrencySymbol] [nvarchar](5) NULL,
	[CurrencyText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LicenseTypeML] PRIMARY KEY CLUSTERED 
(
	[LicenseTypeId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[LicenseTypeML] ADD  CONSTRAINT [DF_LicenseTypeML_CurrencySymbol]  DEFAULT (N'$') FOR [CurrencySymbol]
GO

ALTER TABLE [dbo].[LicenseTypeML] ADD  CONSTRAINT [DF_LicenseTypeML_CurrencyText]  DEFAULT (N'USD') FOR [CurrencyText]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The default price' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'Price'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Currency Symbol' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'CurrencySymbol'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Currency Unit Text' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LicenseTypeML', @level2type=N'COLUMN',@level2name=N'CurrencyText'
GO
