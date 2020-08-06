SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetPeriodUnits.
-- Description:	Get Period Units.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column PeriodUnitId to periodUnitId
-- <2019-08-19> :
--	- Remove PeriodUnitDescriptionNative column.
--	- Rename PeriodUnitDescriptionEN column to PeriodUnitDescription.
--
-- [== Example ==]
--
--exec GetPeriodUnits NULL, 1;  -- for only enabled languages.
--exec GetPeriodUnits;          -- for get all.
--exec GetPeriodUnits N'EN';    -- for get PeriodUnit for EN language.
-- =============================================
CREATE PROCEDURE [dbo].[GetPeriodUnits] 
(
  @langId nvarchar(3) = NULL
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
	 ORDER BY SortOrder, PeriodUnitId
END

GO
