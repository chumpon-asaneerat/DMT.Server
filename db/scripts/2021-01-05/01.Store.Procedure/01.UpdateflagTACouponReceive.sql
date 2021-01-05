/****** Object:  StoredProcedure [dbo].[UpdateflagTACouponReceive]    Script Date: 1/5/2021 9:11:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


create PROCEDURE [dbo].[UpdateflagTACouponReceive] (
  @serialno nvarchar(7)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
		
	UPDATE [dbo].[TA_Coupon]
	SET [sendtaflag] = 1
    WHERE [SerialNo] = @serialno;
			
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO