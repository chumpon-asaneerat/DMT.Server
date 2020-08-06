SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserInfoView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , UserInfo.UserId
		 , UserInfo.MemberType
		 , UserInfo.UserName
		 , UserInfo.Password
		 , UserInfo.ObjectStatus
		 , UserInfo.Prefix
		 , UserInfo.FirstName
		 , UserInfo.LastName
	  FROM LanguageView CROSS JOIN dbo.UserInfo

GO
