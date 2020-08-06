SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Default user for EDL and add related reset all generate id for PK.
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Remove Auto Create EDL Admin User. Need to call manually.
--
-- [== Example ==]
--
--exec InitMasterPKs
-- =============================================
CREATE PROCEDURE [dbo].[InitMasterPKs] (
  @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		-- For EDL
		exec SetMasterPK N'UserInfo', 1, 'EDL-U', 3;
		-- For Customer
		exec SetMasterPK N'Customer', 2, 'EDL-C', 4;

		IF (@errNum <> 0)
		BEGIN
			RETURN
		END
		SET @errNum = 0;
		SET @errMsg = N'success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

EXEC InitMasterPKs;

GO
