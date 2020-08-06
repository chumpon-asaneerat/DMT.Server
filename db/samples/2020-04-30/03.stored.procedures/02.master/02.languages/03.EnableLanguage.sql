SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: EnagleLanguage.
-- Description:	Enable Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- Change langId type from nvarchar(10) to nvarchar(3).
--
-- [== Example ==]
--
--exec EnagleLanguage N'ES' -- Enable Language.
-- =============================================
CREATE PROCEDURE [dbo].[EnableLanguage]
(
    @langId nvarchar(3) = null
)
AS
BEGIN
    UPDATE [dbo].[Language]
	   SET [ENABLED] = 1
	 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
END

GO
