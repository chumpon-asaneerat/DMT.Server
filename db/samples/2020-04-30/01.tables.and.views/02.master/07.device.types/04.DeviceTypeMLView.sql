SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceTypeMLView]
AS
	SELECT DTV.LangId
	     , DTV.DeviceTypeId
		 , CASE 
			WHEN (DTML.Description IS NULL OR LTRIM(RTRIM(DTML.Description)) = '') THEN 
				DTV.Description
			ELSE 
				DTML.Description 
		   END AS Description
	     , DTV.Enabled
	     , DTV.SortOrder
		FROM dbo.DeviceTypeML AS DTML RIGHT OUTER JOIN DeviceTypeView AS DTV
		  ON (    DTML.LangId = DTV.LangId 
		      AND DTML.DeviceTypeId = DTV.DeviceTypeId
			 )
GO