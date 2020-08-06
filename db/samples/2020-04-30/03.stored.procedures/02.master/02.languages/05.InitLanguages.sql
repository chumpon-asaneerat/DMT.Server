SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init supports languages
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLanguages
-- =============================================
CREATE PROCEDURE [dbo].[InitLanguages]
AS
BEGIN
    /*
    EXEC SaveLanguage N'', N'', N'', 1, 1
    */
    EXEC SaveLanguage N'EN', N'US', N'English', 1, 1
    EXEC SaveLanguage N'TH', N'TH', N'ไทย', 2, 1
    EXEC SaveLanguage N'ZH', N'CN', N'中文', 3, 1
    EXEC SaveLanguage N'JA', N'JP', N'中文', 4, 1
    EXEC SaveLanguage N'DE', N'DE', N'Deutsche', 5, 0
    EXEC SaveLanguage N'FR', N'FR', N'français', 6, 0
    EXEC SaveLanguage N'KO', N'KR', N'한국어', 7, 1
    EXEC SaveLanguage N'RU', N'RU', N'Россия', 8, 0
    EXEC SaveLanguage N'ES', N'ES', N'Spanish', 9, 1
END

GO

EXEC InitLanguages;

GO
