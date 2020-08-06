SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnit.
-- Description:	The Limit Unit Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[LimitUnit](
	[LimitUnitId] [int] NOT NULL,
	[Description] [nvarchar](100) NOT NULL,
	[UnitText] [nvarchar](20) NULL,
 CONSTRAINT [PK_LimitUnit] PRIMARY KEY CLUSTERED 
(
	[LimitUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LimitUnitId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'LimitUnitId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The English Description for LimitUnit.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The English limit unit text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LimitUnit', @level2type=N'COLUMN',@level2name=N'UnitText'
GO
