SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetOrgs
-- Description:	Get Organizations.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column CustomerId to customerId
--	- change column OrgId to orgId
--	- change column ParentId to parentId
--	- change column BranchId to branchId
-- <2020-04-30> :
--  - remove parameter @orgId
--
-- [== Example ==]
--
--/* With Specificed CustomerId */
--exec GetOrgs NULL, N'EDL-C2020030001';              -- Gets orgs in enable languages all branchs.
--exec GetOrgs N'EN', N'EDL-C2020030001';             -- Gets orgs in EN language all branchs.
--exec GetOrgs N'TH', N'EDL-C2020030001';             -- Gets orgs in TH language all branchs.
--/* With Specificed CustomerId, BranchId */
--exec GetOrgs NULL, N'EDL-C2020030001', N'B0001';    -- Gets orgs in enable languages in Branch 1.
--exec GetOrgs N'EN', N'EDL-C2020030001', N'B0001';   -- Gets orgs in EN language in Branch 1.
--exec GetOrgs N'TH', N'EDL-C2020030001', N'B0001';   -- Gets orgs in TH language in Branch 1.
--/* Without Specificed CustomerId */
--exec GetOrgs NULL, NULL, N'B0001';                  -- no data returns.
-- =============================================
CREATE PROCEDURE [dbo].[GetOrgs] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @branchId nvarchar(30) = NULL
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
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(COALESCE(@branchId, BranchId))))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId, OrgId
END

GO
