SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSets.
-- Description:	Get Question Sets.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
-- <2019-08-19> :
--	- Stored Procedure Changes.
--    - Remove QSetDescriptionNative column.
--    - Rename QSetDescriptionEN column to QSetDescription.
-- <2020-01-07> :
--    - Add MinVoteDate, MaxVoteDate
-- <2020-04-30> :
--    - remove parameter @qSetId
--    - temporary remove column minvotedate, maxvotedate
--
-- [== Example ==]
--
--EXEC GetQSets NULL, N'EDL-C2020030001', 1;   -- get all QSets for enable languages
--EXEC GetQSets N'EN', N'EDL-C2020030001';     -- get all QSets for EN language
--EXEC GetQSets N'EN', NULL;                   -- no data returns
-- =============================================
CREATE PROCEDURE [dbo].[GetQSets]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT A.langId
		 , A.customerId
		 , A.qSetId
		 , A.BeginDate
		 , A.EndDate
         /*
		 , (
			SELECT MIN(VoteDate) 
			  FROM Vote 
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
		   ) AS MinVoteDate
		 , (
			SELECT MAX(VoteDate) 
			  FROM Vote 
			 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
			   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
		   ) AS MaxVoteDate
         */
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
	 ORDER BY A.SortOrder, A.CustomerId, A.QSetId
END

GO
