SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSet.
-- Description:	Get Question Set.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetQSet NULL, N'EDL-C2020030001', N'QS00001', 1; -- get QSet in all enable languages.
--EXEC GetQSet N'EN', N'EDL-C2020030001', N'QS00001';   -- get QSet in EN language.
--EXEC GetQSet N'EN', NULL, N'QS00001';			        -- no data returns
--EXEC GetQSet N'EN', N'EDL-C2020030001', NULL;			-- no data returns
-- =============================================
CREATE PROCEDURE [dbo].[GetQSet]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT A.langId
		 , A.customerId
		 , A.qSetId
		 , A.BeginDate
		 , A.EndDate
		 , (
			SELECT MIN(VoteDate) 
			  FROM Vote 
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
		   ) AS MinVoteDate
		 , (
			SELECT MAX(VoteDate) 
			  FROM Vote 
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
		   ) AS MaxVoteDate
		 , A.QSetDescription
		 , A.DisplayMode
		 , A.HasRemark
		 , A.IsDefault
		 , A.QSetStatus
		 , A.SortOrder
		 , A.Enabled 
	  FROM QSetMLView A
	 WHERE A.[ENABLED] = COALESCE(@enabled, A.[ENABLED])
	   AND UPPER(LTRIM(RTRIM(A.LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, A.LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(A.QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
	 ORDER BY A.SortOrder, A.CustomerId, A.QSetId
END

GO
