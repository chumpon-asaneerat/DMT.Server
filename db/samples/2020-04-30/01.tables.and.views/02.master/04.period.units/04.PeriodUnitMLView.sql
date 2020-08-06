SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: PeriodUnitMLView.
-- Description:	The Period Unit ML View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove PeriodUnitDescriptionNative column.
--    - Rename PeriodUnitDescriptionEN column to PeriodUnitDescription.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[PeriodUnitMLView]
AS
	SELECT PUV.LangId
		 , PUV.PeriodUnitId
		 , CASE 
			WHEN (PUML.Description IS NULL OR LTRIM(RTRIM(PUML.Description)) = '') THEN 
				PUV.PeriodUnitDescription
			ELSE 
				PUML.Description 
		   END AS PeriodUnitDescription
		 , PUV.SortOrder
		 , PUV.Enabled
		FROM dbo.PeriodUnitML AS PUML RIGHT OUTER JOIN PeriodUnitView AS PUV
		  ON (PUML.LangId = PUV.LangId AND PUML.PeriodUnitId = PUV.PeriodUnitId)
GO
