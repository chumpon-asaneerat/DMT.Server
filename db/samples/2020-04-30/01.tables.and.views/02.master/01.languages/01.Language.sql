SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Language.
-- Description:	The Language Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--	  - FlagId is used ISO 3166-1 alpha 2 code.
-- <2019-08-19> :
--	- Table Changes.
--	  - Remove DescriptionNative column.
--	  - Change DescriptionEN column to Description.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[Language]
(
    [LangId] [nvarchar](3) NOT NULL,
    [FlagId] [nvarchar](3) NOT NULL,
    [Description] [nvarchar](50) NOT NULL,
    [SortOrder] [int] NOT NULL,
    [Enabled] [bit] NOT NULL,
    CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_Language_FlagId]    Script Date: 4/20/2018 14:22:48 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Language_FlagId] ON [dbo].[Language]
(
	[FlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_SortOrder]  DEFAULT ((1)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[Language] ADD  CONSTRAINT [DF_Language_Enabled]  DEFAULT ((1)) FOR [Enabled]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ISO 639-1 alpha 2 code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ISO 3166-1-alpha-2 code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'FlagId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Enable Lanugage to used.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'Enabled'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Unique index for FlagId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'INDEX',@level2name=N'IX_Language_FlagId'
GO
