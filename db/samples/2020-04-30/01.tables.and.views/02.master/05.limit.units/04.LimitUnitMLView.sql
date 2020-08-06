SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitMLView.
-- Description:	The Limit Unit ML View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove LimitUnitDescriptionNative column.
--    - Remove LimitUnitTextNative column.
--    - Rename LimitUnitDescriptionEN column to LimitUnitDescription.
--    - Rename LimitUnitTextEN column to LimitUnitText.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LimitUnitMLView]
AS
	SELECT LUV.LangId
		 , LUV.LimitUnitId
		 , CASE 
			WHEN (LMML.Description IS NULL OR LTRIM(RTRIM(LMML.Description)) = '') THEN 
				LUV.LimitUnitDescription
			ELSE 
				LMML.Description 
		   END AS LimitUnitDescription
		 , CASE 
			WHEN (LMML.UnitText IS NULL OR LTRIM(RTRIM(LMML.UnitText)) = '') THEN 
				LUV.LimitUnitText
			ELSE 
				LMML.UnitText 
		   END AS LimitUnitText
		 , LUV.Enabled
		 , LUV.SortOrder
		FROM dbo.LimitUnitML AS LMML RIGHT OUTER JOIN LimitUnitView AS LUV
		  ON (LMML.LangId = LUV.LangId AND LMML.LimitUnitId = LUV.LimitUnitId)

GO
