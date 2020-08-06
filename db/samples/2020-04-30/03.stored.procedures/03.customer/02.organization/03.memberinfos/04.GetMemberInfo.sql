SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberInfo
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- /* Get MemberInfo by CustomerID and MemberId. */
--exec GetMemberInfo NULL, N'EDL-C2017060011', N'M00001';      -- all languages
--exec GetMemberInfo NULL, N'EDL-C2017060011', N'M00001', 1;   -- all enable languages
--exec GetMemberInfo N'TH', N'EDL-C2017060011', N'M00001';     -- TH language
--exec GetMemberInfo N'TH', NULL, N'M00001';                   -- no customerID (no data returns)
--exec GetMemberInfo N'TH', N'EDL-C2020030001', NULL;          -- no memberId (no data returns)
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberInfo] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @memberId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , memberId
		 , MemberType
		 , Prefix
		 , FirstName
		 , LastName
		 , FullName
		 , IDCard
		 , TagId
		 , EmployeeCode
		 , UserName
		 , Password
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM MemberInfoMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(MemberId))) = UPPER(LTRIM(RTRIM(@memberId)))
	 ORDER BY SortOrder, LangId, CustomerId, MemberId;
END

GO
