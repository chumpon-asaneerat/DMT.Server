SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSetView.
-- Description:	The QSet View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove DescriptionNative column.
--    - Rename DescriptionEn column to Description.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSetView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , QSet.QSetId
	     , QSet.CustomerId
		 , QSet.BeginDate
		 , QSet.EndDate
		 , QSet.Description
		 , QSet.DisplayMode
		 , QSet.HasRemark
		 , QSet.IsDefault
		 , QSet.ObjectStatus AS QSetStatus
	  FROM LanguageView CROSS JOIN dbo.QSet

GO
