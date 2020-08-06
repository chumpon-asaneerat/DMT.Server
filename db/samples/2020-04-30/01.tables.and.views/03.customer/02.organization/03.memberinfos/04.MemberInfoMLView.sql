SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberInfoMLView]
AS
	SELECT MIV.LangId
	     , MIV.CustomerId
	     , MIV.MemberId
	     , MIV.MemberType
		 , CASE 
			WHEN (MIML.FirstName IS NULL OR LTRIM(RTRIM(MIML.FirstName)) = '') THEN 
				MIV.Prefix
			ELSE 
				MIML.Prefix 
		   END AS Prefix
		 , CASE 
			WHEN (MIML.FirstName IS NULL OR LTRIM(RTRIM(MIML.FirstName)) = '') THEN 
				MIV.FirstName
			ELSE 
				MIML.FirstName 
		   END AS FirstName
		 , CASE 
			WHEN (MIML.FirstName IS NULL OR LTRIM(RTRIM(MIML.FirstName)) = '') THEN 
				MIV.LastName
			ELSE 
				MIML.LastName 
		   END AS LastName
		 , CASE 
			WHEN (MIML.FirstName IS NULL OR LTRIM(RTRIM(MIML.FirstName)) = '') THEN /* Use FirstName to check for used Native data */
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(MIV.Prefix, N''))) + N' ' +
				            RTRIM(LTRIM(MIV.FirstName)) + N' ' +
				            RTRIM(LTRIM(ISNULL(MIV.LastName, N'')))))
			ELSE 
				RTRIM(LTRIM(RTRIM(LTRIM(ISNULL(MIML.Prefix, N''))) + N' ' +
				            RTRIM(LTRIM(MIML.FirstName)) + N' ' +
				            RTRIM(LTRIM(ISNULL(MIML.LastName, N'')))))
		   END AS FullName
	     , MIV.IDCard
	     , MIV.TagId
	     , MIV.EmployeeCode
	     , MIV.UserName
	     , MIV.Password
	     , MIV.ObjectStatus
	     , MIV.Enabled
	     , MIV.SortOrder
		FROM dbo.MemberInfoML AS MIML RIGHT OUTER JOIN MemberInfoView AS MIV
		  ON (    MIML.LangId = MIV.LangId 
		      AND MIML.CustomerId = MIV.CustomerId
		      AND MIML.MemberId = MIV.MemberId
			 )

GO
