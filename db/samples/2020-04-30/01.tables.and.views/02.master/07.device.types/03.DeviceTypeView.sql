SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[DeviceTypeView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , DeviceType.DeviceTypeId
	     , DeviceType.Description
	  FROM LanguageView CROSS JOIN dbo.DeviceType
GO
