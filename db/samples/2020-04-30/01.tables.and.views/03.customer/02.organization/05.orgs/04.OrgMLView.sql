SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[OrgMLView]
AS
   SELECT ORMLV.LangId
        , ORMLV.CustomerId
        , ORMLV.OrgId
        , ORMLV.BranchId
		, BMLV.BranchName
        , ORMLV.ParentId
        , ORMLV.OrgName
        , ORMLV.ObjectStatus AS OrgStatus
		, BMLV.ObjectStatus AS BranchStatus
        , ORMLV.Enabled
        , ORMLV.SortOrder
     FROM (
			SELECT ORV.LangId
				 , ORV.CustomerId
				 , ORV.OrgId
				 , ORV.BranchId
				 , ORV.ParentId
				 , CASE 
					WHEN (ORML.OrgName IS NULL OR LTRIM(RTRIM(ORML.OrgName)) = '') THEN 
						ORV.OrgName
					ELSE 
						ORML.OrgName 
				   END AS OrgName
				 , ORV.ObjectStatus
				 , ORV.Enabled
				 , ORV.SortOrder
				FROM dbo.OrgML AS ORML RIGHT OUTER JOIN OrgView AS ORV
				  ON (    ORML.LangId = ORV.LangId 
					  AND ORML.CustomerId = ORV.CustomerId
					  AND ORML.OrgId = ORV.OrgId
					 )
	      ) AS ORMLV LEFT JOIN BranchMLView AS BMLV
		          ON (    ORMLV.LangId = BMLV.LangId
				      AND ORMLV.CustomerId = BMLV.CustomerId
				      AND ORMLV.BranchId = BMLV.BranchId)

GO
