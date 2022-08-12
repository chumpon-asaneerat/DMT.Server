/*********** Script Update Date: 2022-08-13  ***********/
CREATE PROCEDURE [dbo].[TOD_UserReceiveBag] (
  @tsbid nvarchar(10)
, @shiftid int
, @userid nvarchar(10)
, @fullnameen nvarchar(150)
, @fullnameth nvarchar(150)
, @receivedDate datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
	BEGIN TRY
		SET @errNum = 0;
		SET @errMsg = N'Success';

	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

