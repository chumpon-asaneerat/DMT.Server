SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[MemberTypeMLView]
AS
    SELECT MTV.LangId
		 , MTV.MemberTypeId
		 , CASE 
			WHEN (MTML.Description IS NULL OR LTRIM(RTRIM(MTML.Description)) = '') THEN 
				MTV.MemberTypeDescription
			ELSE 
				MTML.Description 
		   END AS MemberTypeDescription
		 , MTV.Enabled
		 , MTV.SortOrder
    FROM dbo.MemberTypeML AS MTML RIGHT OUTER JOIN MemberTypeView AS MTV
        ON (MTML.LangId = MTV.LangId AND MTML.MemberTypeId = MTV.MemberTypeId)

GO
