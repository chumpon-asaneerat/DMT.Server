SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceMLView]
AS
	SELECT DV.LangId
	     , DV.DeviceId
	     , DV.CustomerId
	     , DV.DeviceTypeId
		 , CASE 
			WHEN (DML.DeviceName IS NULL OR LTRIM(RTRIM(DML.DeviceName)) = '') THEN 
				DV.DeviceName
			ELSE 
				DML.DeviceName 
		   END AS DeviceName
		 , CASE 
			WHEN (DML.Location IS NULL OR LTRIM(RTRIM(DML.Location)) = '') THEN 
				DV.Location
			ELSE 
				DML.Location 
		   END AS Location
	     , DV.OrgId
	     , DV.MemberId
	     , DV.Enabled
	     , DV.SortOrder
		FROM dbo.DeviceML AS DML RIGHT OUTER JOIN DeviceView AS DV
		  ON (    DML.LangId = DV.LangId 
		      AND DML.DeviceId = DV.DeviceId
		      AND DML.CustomerId = DV.CustomerId
			 )
GO
