SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideMLView.
-- Description:	The QSlide ML View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove QSlideTextNative column.
--    - Rename QSlideTextEn column to QSlideText.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSlideMLView]
AS
	SELECT QSlideV.LangId
		 , QSlideV.CustomerId
		 , QSlideV.QSetId
		 , QSlideV.QSeq
		 , CASE 
			WHEN (QSlideML.QText IS NULL OR LTRIM(RTRIM(QSlideML.QText)) = '') THEN 
				QSlideV.QSlideText
			ELSE 
				QSlideML.QText 
		   END AS QSlideText
		 , QSlideV.HasRemark
		 , QSlideV.QSlideStatus
		 , QSlideV.QSlideOrder
		 , QSlideV.Enabled
		 , QSlideV.SortOrder
		FROM dbo.QSlideML AS QSlideML RIGHT OUTER JOIN QSlideView AS QSlideV
		  ON (QSlideML.LangId = QSlideV.LangId 
		  AND QSlideML.CustomerId = QSlideV.CustomerId
		  AND QSlideML.QSetId = QSlideV.QSetId
		  AND QSlideML.QSeq = QSlideV.QSeq)

GO
