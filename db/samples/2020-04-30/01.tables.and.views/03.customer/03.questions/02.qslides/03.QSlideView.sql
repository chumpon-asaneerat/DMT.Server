SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSlideView.
-- Description:	The QSlide View.
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
CREATE VIEW [dbo].[QSlideView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , QSlide.CustomerId
	     , QSlide.QSetId
	     , QSlide.QSeq
		 , QSlide.QText AS QSlideText
		 , QSlide.HasRemark
		 , QSlide.SortOrder AS QSlideOrder
		 , QSlide.ObjectStatus AS QSlideStatus
	  FROM LanguageView CROSS JOIN dbo.QSlide

GO
