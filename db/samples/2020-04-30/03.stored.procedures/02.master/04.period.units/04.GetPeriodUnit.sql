SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetPeriodUnit.
-- Description:	Get Period Unit.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetPeriodUnit NULL, 1, 1;
-- =============================================
CREATE PROCEDURE [dbo].[GetPeriodUnit] 
(
  @langId nvarchar(3) = NULL
, @periodUnitId int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , periodUnitId
		 , PeriodUnitDescription
		 , SortOrder
		 , Enabled 
	  FROM PeriodUnitMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
       AND PeriodUnitId =  @periodUnitId
	 ORDER BY SortOrder, PeriodUnitId
END

GO
