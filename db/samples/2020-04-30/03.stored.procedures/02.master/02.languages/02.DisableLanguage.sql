SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DisableLanguage.
-- Description:	Disable Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- Change langId type from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec DisableLanguage N'ES' -- Disable Language.
-- =============================================
CREATE PROCEDURE [dbo].[DisableLanguage]
(
    @langId nvarchar(3) = null
)
AS
BEGIN
    UPDATE [dbo].[Language]
	   SET [ENABLED] = 0
	 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
END

GO
