SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlides.
-- Description:	Get Question Slides.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
-- <2019-08-19> :
--	- Stored Procedure Changes.
--    - Remove QSlideTextNative column.
--    - Rename QSlideTextEN column to QSlideText.
-- <2020-04-30> :
--    - remove parameter @qSeq
--
-- [== Example ==]
--
--EXEC GetQSlides NULL, N'EDL-C2020030001', NULL, 1;       -- get all QSlide in all QSet (enable languages)
--EXEC GetQSlides N'EN', N'EDL-C2020030001', NULL;         -- get all QSlide in all QSet (EN language)
--EXEC GetQSlides NULL, N'EDL-C2020030001', N'QS00002', 1; -- get all QSlide in Specificed QSet (enable languages)
--EXEC GetQSlides N'EN', N'EDL-C2020030001', N'QS00002';   -- get all QSlide in Specificed QSet (EN language)
-- =============================================
CREATE PROCEDURE [dbo].[GetQSlides]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @qSetId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT langId
		 , customerId
		 , qSetId
		 , qSeq
		 , QSlideText
		 , HasRemark
		 , QSlideStatus
		 , QSlideOrder
		 , Enabled 
	  FROM QSlideMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO
