SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[UserInfoMLView]
AS
	SELECT UIV.LangId
	     , UIV.UserId
		 , UIV.MemberType
		 , CASE 
			WHEN (UIML.FirstName IS NULL OR LTRIM(RTRIM(UIML.FirstName)) = '') THEN /* Use FirstName to check for used Native data */
				UIV.Prefix
			ELSE 
				UIML.Prefix 
		   END AS Prefix
		 , CASE 
			WHEN (UIML.FirstName IS NULL OR LTRIM(RTRIM(UIML.FirstName)) = '') THEN 
				UIV.FirstName
			ELSE 
				UIML.FirstName 
		   END AS FirstName
		 , CASE 
			WHEN (UIML.FirstName IS NULL OR LTRIM(RTRIM(UIML.FirstName)) = '') THEN /* Use FirstName to check for used Native data */
				UIV.LastName 
			ELSE 
				UIML.LastName
		   END AS LastName
		 , CASE 
			WHEN (UIML.FirstName IS NULL OR LTRIM(RTRIM(UIML.FirstName)) = '') THEN /* Use FirstName to check for used Native data */
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(UIV.Prefix, N''))) + N' ' +
				            RTRIM(LTRIM(UIV.FirstName)) + N' ' +
				            RTRIM(LTRIM(ISNULL(UIV.LastName, N'')))))
			ELSE 
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(UIML.Prefix, N''))) + N' ' +
				            RTRIM(LTRIM(UIML.FirstName)) + N' ' +
				            RTRIM(LTRIM(ISNULL(UIML.LastName, N'')))))
		   END AS FullName
	     , UIV.UserName
	     , UIV.Password
		 , UIV.ObjectStatus
		 , UIV.Enabled
		 , UIV.SortOrder
		FROM dbo.UserInfoML AS UIML RIGHT OUTER JOIN UserInfoView AS UIV
		  ON (UIML.LangId = UIV.LangId AND UIML.UserId = UIV.UserId)

GO
