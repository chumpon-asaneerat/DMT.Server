SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetBranch.
-- Description:	Get Branch.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetBranch NULL, N'EDL-C2020030001', N'B0001';      -- all languages
--exec GetBranch NULL, N'EDL-C2020030001', N'B0001', 1;   -- all enable languages
--exec GetBranch N'TH', N'EDL-C2020030001', N'B0001';     -- only TH language
--exec GetBranch N'TH', NULL, N'B0001';                   -- no customerId (no data returns)
--exec GetBranch N'TH', N'EDL-C2020030001', NULL;         -- no branchId (no data returns)
-- =============================================
CREATE PROCEDURE [dbo].[GetBranch] 
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
		 , branchId
		 , BranchName
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM BranchMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(BranchId))) = UPPER(LTRIM(RTRIM(@branchId)))
	 ORDER BY SortOrder, LangId, CustomerId, BranchId;
END

GO
