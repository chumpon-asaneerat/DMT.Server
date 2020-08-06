SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[OrgView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , dbo.Org.CustomerId
		 , dbo.Org.OrgId
		 , dbo.Org.BranchId
		 , dbo.Org.ParentId
	     , dbo.Org.OrgName
		 , dbo.Org.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.Org

GO
