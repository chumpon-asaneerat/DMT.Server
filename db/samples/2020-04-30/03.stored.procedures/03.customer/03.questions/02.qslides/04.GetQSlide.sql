SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSlide.
-- Description:	Get Question Slide.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC GetQSlide NULL, N'EDL-C2020030001', N'QS00001', 1, 1; -- enable languages only
--EXEC GetQSlide N'EN', N'EDL-C2020030001', N'QS00001', 1;   -- EN language
-- =============================================
CREATE PROCEDURE [dbo].[GetQSlide]
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
		 , QSlideText
		 , HasRemark
		 , QSlideStatus
		 , QSlideOrder
		 , Enabled 
	  FROM QSlideMLView
	 WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
	   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
	   AND UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qSetId)))
	   AND QSeq = @qSeq
	 ORDER BY SortOrder, CustomerId, QSetId, QSeq
END

GO
