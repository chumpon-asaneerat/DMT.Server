SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetUserInfo.
-- Description:	Get User Info.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetUserInfo NULL, N'EDL-U20200402001';      -- all languages
--exec GetUserInfo NULL, N'EDL-U20200402001', 1;   -- only enable languages
--exec GetUserInfo N'TH', N'EDL-U20200402001';     -- only TH language
--exec GetUserInfo N'EN', N'EDL-U20200402001';     -- only EN language
--exec GetUserInfo NULL, NULL;					 -- no customerId (no data returns)
--exec GetUserInfo N'TH', NULL;					 -- no customerId (no data returns)
-- =============================================
CREATE PROCEDURE [dbo].[GetUserInfo] 
(
  @langId nvarchar(3) = NULL
, @userId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , userId
		 , MemberType
		 , Prefix
		 , FirstName
		 , LastName
		 , FullName
		 , UserName
		 , Password
		 , ObjectStatus
		 , SortOrder
		 , Enabled 
	  FROM UserInfoMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
       AND UserId = @userId
	 ORDER BY SortOrder, UserId
END

GO
