SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetMemberType.
-- Description:	Get Member Type.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetMemberType NULL, 100;    -- all
--exec GetMemberType NULL, 100, 0; -- disable only
--exec GetMemberType NULL, 100, 1; -- enable only
-- =============================================
CREATE PROCEDURE [dbo].[GetMemberType] 
(
  @langId nvarchar(3) = NULL
, @memberTypeId int = NULL
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
       AND MemberTypeId =  @memberTypeId
	 ORDER BY SortOrder, MemberTypeId
END

GO
