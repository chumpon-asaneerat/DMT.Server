SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetLimitUnits
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LimitUnitId to limitUnitId
-- <2019-08-19> :
--	- Remove LimitUnitDescriptionNative column.
--	- Remove LimitUnitTextNative column.
--	- Rename LimitUnitDescriptionEN column to LimitUnitDescriptionNative.
--	- Rename LimitUnitTextNativeEN column to LimitUnitTextNative.
--
-- [== Example ==]
--
--exec GetLimitUnits NULL, 1;  -- for only enabled languages.
--exec GetLimitUnits;          -- for get all.
--exec GetLimitUnits N'EN';    -- for get LimitUnit for EN language.
-- =============================================
CREATE PROCEDURE [dbo].[GetLimitUnits] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , limitUnitId
		 , LimitUnitDescription
		 , LimitUnitText
		 , SortOrder
		 , Enabled
	  FROM LimitUnitMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, LimitUnitId
END

GO
