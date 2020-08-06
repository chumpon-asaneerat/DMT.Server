SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnit.
-- Description:	The Period Unit Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[PeriodUnit](
	[PeriodUnitId] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_PeriodUnit] PRIMARY KEY CLUSTERED 
(
	[PeriodUnitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Description For Period Unit' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PeriodUnit', @level2type=N'COLUMN',@level2name=N'Description'
GO
