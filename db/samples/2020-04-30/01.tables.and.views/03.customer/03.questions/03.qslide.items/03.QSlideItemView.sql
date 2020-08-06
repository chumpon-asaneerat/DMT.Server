SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideItemView.
-- Description:	The QSlideItem View.
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
CREATE VIEW [dbo].[QSlideItemView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , QSlideItem.CustomerId
	     , QSlideItem.QSetId
	     , QSlideItem.QSeq
		 , QSlideItem.QSSeq
		 , QSlideItem.QText AS QItemText
		 , QSlideItem.IsRemark
         , QSlideItem.Choice
		 , QSlideItem.SortOrder AS QItemOrder
		 , QSlideItem.ObjectStatus AS QItemStatus
	  FROM LanguageView CROSS JOIN dbo.QSlideItem

GO
