SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetTopLevelOrgs.
-- Description:	Get Top Level Orgs.
-- [== History ==]
-- <2019-12-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetTopLevelOrgs N'EN';
--exec GetTopLevelOrgs N'EN', N'EDL-C2019100001';
-- =============================================
CREATE PROCEDURE [dbo].[GetTopLevelOrgs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , orgId
		 , parentId
		 , branchId
		 , OrgName
		 , BranchName
		 , OrgStatus
		 , BranchStatus
		 , SortOrder
		 , Enabled 
	  FROM OrgMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
	   AND UPPER(LTRIM(RTRIM(ParentId))) 
	   IN  (
			 SELECT DISTINCT OrgId 
			   FROM Org 
			  WHERE ParentId IS NULL
	       )	     
	 ORDER BY SortOrder, LangId, CustomerId, BranchId, OrgId
END

GO
