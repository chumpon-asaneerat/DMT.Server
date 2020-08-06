SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitDefaultUser.
-- Description:	Init Init Default User.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitDefaultUser
-- =============================================
CREATE PROCEDURE [dbo].[InitDefaultUser]
AS
BEGIN
	DECLARE @errNum int = null;
	DECLARE @errMsg nvarchar(MAX) = null;
	DECLARE @userId nvarchar(30);
	EXEC SaveUserInfo N'The', N'EDL', N'Administrator', N'raterweb2-admin@edl.co.th', N'1234', 100--, @userId out, @errNum out, @errMsg out;
	--SELECT @userId AS userId, @errNum AS ErrNum, @errMsg AS ErrMsg;
	EXEC SaveUserInfoML @userId, N'TH', N'[', N'แอดมิน', N']'--, @errNum out, @errMsg out;
	--SELECT @userId AS userId, @errNum AS ErrNum, @errMsg AS ErrMsg;
END

GO

EXEC InitDefaultUser;

GO
