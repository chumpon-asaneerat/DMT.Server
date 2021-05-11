SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


Create PROCEDURE [dbo].[Acc_SaveCreditApproveTrans] (
  @tsbid nvarchar(5)
, @creapprove decimal(8,0)
, @creactual decimal(6,0)
, @approvetype nchar(1)
, @filename nvarchar(100)
, @approveby nvarchar(10)
, @approvedate datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
BEGIN TRY

INSERT INTO [dbo].[TSBCreditAppTrans]
           ([TSBId] ,[CreditApprove] ,[CreditActual] ,[ApproveDate]
           ,[ApproveType] ,[ApproveFileName],[ApproveBy])
     VALUES
          (@tsbid, @creapprove ,@creactual ,@approvedate, @approvetype, @filename, @approveby)

update [dbo].[TSBCreditApprove]
	set MaxCredit = @creapprove
	, LastUpdate = @approvedate
where TSBId = @tsbid
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END




GO