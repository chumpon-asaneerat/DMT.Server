SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CustomerPK](
	[CustomerId] [nvarchar](30) NOT NULL,
	[TableName] [nvarchar](50) NOT NULL,
	[SeedResetMode] [tinyint] NOT NULL,
	[LastSeed] [int] NOT NULL,
	[Prefix] [nvarchar](10) NULL,
	[SeedDigits] [tinyint] NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_CustomerPK] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[CustomerPK] ADD  CONSTRAINT [DF_CustomerPK_SeedResetMode]  DEFAULT ((1)) FOR [SeedResetMode]
GO

ALTER TABLE [dbo].[CustomerPK] ADD  CONSTRAINT [DF_CustomerPK_LastSeed]  DEFAULT ((1)) FOR [LastSeed]
GO

ALTER TABLE [dbo].[CustomerPK] ADD  CONSTRAINT [DF_CustomerPK_SeedDigits]  DEFAULT ((4)) FOR [SeedDigits]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reset Mode : 1: daily, 2 : monthly, 3: yearly, 4: IgnoreDate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerPK', @level2type=N'COLUMN',@level2name=N'SeedResetMode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Last Seed Number (integer) - value cannot be negative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerPK', @level2type=N'COLUMN',@level2name=N'LastSeed'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Number of digit for seed (default is 4)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomerPK', @level2type=N'COLUMN',@level2name=N'SeedDigits'
GO
