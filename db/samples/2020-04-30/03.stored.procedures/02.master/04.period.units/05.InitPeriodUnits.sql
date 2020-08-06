SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Init Period Units.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- replace insert with sp call.
--
-- [== Example ==]
--
--exec InitPeriodUnits
-- =============================================
CREATE PROCEDURE [dbo].[InitPeriodUnits]
AS
BEGIN
    EXEC SavePeriodUnit 1, N'day'
    EXEC SavePeriodUnit 2, N'month'
    EXEC SavePeriodUnit 3, N'year'

	-- [ENGLISH]
    EXEC SavePeriodUnitML 1, N'EN', N'day'
    EXEC SavePeriodUnitML 2, N'EN', N'month'
    EXEC SavePeriodUnitML 3, N'EN', N'year'
	-- [THAI]
    EXEC SavePeriodUnitML 1, N'TH', N'วัน'
    EXEC SavePeriodUnitML 2, N'TH', N'เดือน'
    EXEC SavePeriodUnitML 3, N'TH', N'ปี'
	-- [CHINESE]
	EXEC SavePeriodUnitML 1, N'ZH', N'天'
	EXEC SavePeriodUnitML 2, N'ZH', N'月'
	EXEC SavePeriodUnitML 3, N'ZH', N'年'
	-- [JAPANESE]
	EXEC SavePeriodUnitML 1, N'JA', N'日'
	EXEC SavePeriodUnitML 2, N'JA', N'月'
	EXEC SavePeriodUnitML 3, N'JA', N'年'
	-- [GERMAN]
	EXEC SavePeriodUnitML 1, N'DE', N'Tag'
	EXEC SavePeriodUnitML 2, N'DE', N'Monat'
	EXEC SavePeriodUnitML 3, N'DE', N'Jahr'
	-- [FRENCH]
	EXEC SavePeriodUnitML 1, N'FR', N'jour'
	EXEC SavePeriodUnitML 2, N'FR', N'mois'
	EXEC SavePeriodUnitML 3, N'FR', N'an'
	-- [KOREAN]
	EXEC SavePeriodUnitML 1, N'KO', N'일'
	EXEC SavePeriodUnitML 2, N'KO', N'달'
	EXEC SavePeriodUnitML 3, N'KO', N'년'
END

GO

EXEC InitPeriodUnits;

GO
