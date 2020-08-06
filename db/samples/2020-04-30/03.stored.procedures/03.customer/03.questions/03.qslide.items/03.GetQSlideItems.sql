SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlideItems.
-- Description:	Get Question Slide Items.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
-- <2019-08-19> :
--	- Stored Procedure Changes.
--    - Remove QItemTextNative column.
--    - Rename QItemTextEN column to QItemText.
-- <2020-03-26> :
--	- Add choice parameter.
-- <2020-04-30> :
--    - remove parameter @qSSeq
--
-- [== Example ==]
--
--EXEC GetQSlideItems NULL, N'EDL-C2020030001', N'QS00001', 1, 1;  -- all items in all enable languages
--EXEC GetQSlideItems N'JA', N'EDL-C2020030001', N'QS00001', 1;    -- all items in all JA language
--EXEC GetQSlideItems N'JA', NULL, N'QS00001', 1;                  -- no data returns
--EXEC GetQSlideItems N'JA', N'EDL-C2020030001', NULL, 1;          -- no data returns
--EXEC GetQSlideItems N'JA', N'EDL-C2020030001', N'QS00001', NULL; -- no data returns
-- =============================================
CREATE PROCEDURE [dbo].[GetQSlideItems]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @qSeq int = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , qSetId
		 , qSeq
		 , qSSeq
		 , QItemText
		 , IsRemark
         , Choice
		 , QItemStatus
		 , QItemOrder
		 , Enabled 
	  FROM QSlideItemMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
	   AND QSeq = COALESCE(@qSeq, QSeq)
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO
