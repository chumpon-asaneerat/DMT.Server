SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitML.
-- Description:	The Period Unit ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[PeriodUnitML](
	[PeriodUnitId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PeriodUnitML] PRIMARY KEY CLUSTERED 
(
	[PeriodUnitId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Description For Period Unit by specificed language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PeriodUnitML', @level2type=N'COLUMN',@level2name=N'Description'
GO
