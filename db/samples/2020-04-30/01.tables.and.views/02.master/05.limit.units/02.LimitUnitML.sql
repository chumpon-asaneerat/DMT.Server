SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitML.
-- Description:	The Limit Unit ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[LimitUnitML](
	[LimitUnitId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[UnitText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LimitUnitML] PRIMARY KEY CLUSTERED 
(
	[LimitUnitId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LimitUnit Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The description by specificed language id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The limit unit text for specificed language id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnitML', @level2type=N'COLUMN',@level2name=N'UnitText'
GO
