SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLimitUnit.
-- Description:	Get Limit Unit.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetLimitUnit NULL, 1, 1;
-- =============================================
CREATE PROCEDURE [dbo].[GetLimitUnit] 
(
  @langId nvarchar(3) = NULL
, @limitUnitId int = NULL
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
       AND LimitUnitId =  @limitUnitId
	 ORDER BY SortOrder, LimitUnitId
END

GO
