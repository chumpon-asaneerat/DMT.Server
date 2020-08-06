SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideItemMLView.
-- Description:	The QSlide Item ML View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove QItemTextNative column.
--    - Rename QItemTextEn column to QItemText.
-- <2020-03-26> :
--	- Add choice parameter.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSlideItemMLView]
AS
	SELECT QItemV.LangId
		 , QItemV.CustomerId
		 , QItemV.QSetId
		 , QItemV.QSeq
		 , QItemV.QSSeq
		 , CASE 
			WHEN (QItemML.QText IS NULL OR LTRIM(RTRIM(QItemML.QText)) = '') THEN 
				QItemV.QItemText
			ELSE 
				QItemML.QText 
		   END AS QItemText
		 , QItemV.IsRemark
         , QItemV.Choice
		 , QItemV.QItemStatus
		 , QItemV.QItemOrder
		 , QItemV.Enabled
		 , QItemV.SortOrder
		FROM dbo.QSlideItemML AS QItemML RIGHT OUTER JOIN QSlideItemView AS QItemV
		  ON (QItemML.LangId = QItemV.LangId 
		  AND QItemML.CustomerId = QItemV.CustomerId
		  AND QItemML.QSetId = QItemV.QSetId
		  AND QItemML.QSeq = QItemV.QSeq
		  AND QItemML.QSSeq = QItemV.QSSeq)

GO
