SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LimitUnitView.
-- Description:	The Limit Unit View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove DescriptionNative column.
--    - Rename DescriptionEN column to Description.
--    - Rename LimitUnitDescriptionEN column to LimitUnitDescription.
--    - Rename LimitUnitTextEN column to LimitUnitText.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LimitUnitView]
AS
	SELECT LanguageView.LangId
		 --, LanguageView.FlagId
	     --, LanguageView.Description
		 , LanguageView.Enabled
		 , LanguageView.SortOrder
	     , LimitUnit.LimitUnitId
		 , LimitUnit.Description AS LimitUnitDescription
		 , LimitUnit.UnitText AS LimitUnitText
	  FROM LanguageView CROSS JOIN dbo.LimitUnit

GO
