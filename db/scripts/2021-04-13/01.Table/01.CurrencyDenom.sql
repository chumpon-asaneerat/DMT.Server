CREATE TABLE [dbo].[CurrencyDenom](
	[CurrencyId] [int] NULL,
	[CurrencyDenomId] [int] NULL,
	[Abbreviation] [nvarchar](10) NULL,
	[Description] [nvarchar](20) NULL,
	[DenomValue] [decimal](7, 2) NULL,
	[DenomTypeId] [int] NULL,
	[UseFlag] [int] NULL
) ON [PRIMARY]
GO