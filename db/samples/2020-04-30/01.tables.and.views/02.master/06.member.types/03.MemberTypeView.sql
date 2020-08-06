SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberTypeView]
AS
    SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , MemberType.MemberTypeId
		 , MemberType.Description AS MemberTypeDescription
    FROM LanguageView CROSS JOIN dbo.MemberType

GO
