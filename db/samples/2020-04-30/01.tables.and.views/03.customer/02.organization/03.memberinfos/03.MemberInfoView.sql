SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberInfoView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
		 , MemberInfo.CustomerId
		 , MemberInfo.MemberId
		 , MemberInfo.TagId
		 , MemberInfo.IDCard
		 , MemberInfo.EmployeeCode
	     , MemberInfo.Prefix
	     , MemberInfo.FirstName
	     , MemberInfo.LastName
		 , MemberInfo.UserName
		 , MemberInfo.Password
		 , MemberInfo.MemberType
		 , MemberInfo.ObjectStatus
	  FROM LanguageView CROSS JOIN dbo.MemberInfo

GO
