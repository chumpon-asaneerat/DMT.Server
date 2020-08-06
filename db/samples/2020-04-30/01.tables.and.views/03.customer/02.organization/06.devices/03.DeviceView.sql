SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , Device.CustomerId
		 , Device.DeviceId
		 , Device.DeviceTypeId
	     , Device.DeviceName
		 , Device.Location
		 , Device.OrgId
		 , Device.MemberId
		 , Device.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Device

GO