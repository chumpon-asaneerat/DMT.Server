SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateflagAR_Serial] 
(
  @DocDate nvarchar(8)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
	BEGIN TRY
		UPDATE [dbo].[AR_Serial]
	       SET [ExportExcel] = 1
		   , ExportDate = GETDATE()
         WHERE [ExportExcel] = 0
		 --And [DocDate] = @DocDate;

		-- SET SUCCESS
		SET @errNum = 0;
		SET @errMsg = N'Success'
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO