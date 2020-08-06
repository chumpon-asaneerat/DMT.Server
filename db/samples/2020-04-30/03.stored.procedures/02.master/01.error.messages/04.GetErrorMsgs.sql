SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetErrorMessages.
-- Description:	Get Error Messages.
-- [== History ==]
-- <2018-05-18> :
--	- Stored Procedure Created.
-- <2019-08-19> :
--  - Remove ErrMsgNative column.
--
-- [== Example ==]
--
--exec GetErrorMsgs N'EN'; -- for only EN language.
--exec GetErrorMsgs;       -- for get all.
-- =============================================
CREATE PROCEDURE [dbo].[GetErrorMsgs] 
(
  @langId nvarchar(3) = null
, @errCode int = null
)
AS
BEGIN
	SELECT langId
		 , ErrCode
		 , ErrMsg
		 , SortOrder
		 , Enabled
	  FROM ErrorMessageMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND ErrCode = COALESCE(@errCode, ErrCode)
	   AND Enabled = 1
	 Order By SortOrder, ErrCode
END

GO