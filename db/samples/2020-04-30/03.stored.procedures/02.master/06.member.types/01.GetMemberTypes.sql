SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	GetMemberTypes
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column MemberTypeId to memberTypeId
-- <2019-08-19> :
--	- Remove MemberTypeDescriptionNavive column.
--	- Rename MemberTypeDescriptionEN column to MemberTypeDescription.
--
-- [== Example ==]
--
--exec GetMemberTypes NULL, 1;  -- for only enabled languages.
--exec GetMemberTypes;          -- for get all.
--exec GetMemberTypes N'EN';    -- for get MemberType for EN language.
--exec GetMemberTypes N'TH';    -- for get MemberType for TH language.
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberTypes] 
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , memberTypeId
		 , MemberTypeDescription
		 , SortOrder
		 , Enabled 
	  FROM MemberTypeMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId,LangId))))
	 ORDER BY SortOrder, MemberTypeId
END

GO
