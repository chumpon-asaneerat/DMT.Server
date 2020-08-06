SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: LanguageView.
-- Description:	The Language View.
-- [== History ==]
-- <2018-04-16> :
--	- View Created.
-- <2019-08-19> :
--	- View changes.
--    - Remove DescriptionNative column.
--    - Rename DescriptionEN column to Description.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[LanguageView]
AS
	SELECT LangId
		 , FlagId
	     , Description
		 , SortOrder
		 , Enabled
    FROM dbo.Language

GO
