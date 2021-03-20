/****** Object:  StoredProcedure [dbo].[Acc_SaveUserCreditOnJob]    Script Date: 20/3/2564 19:12:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


create PROCEDURE [dbo].[Acc_SaveUserCreditOnJob] (
  @tsbid nvarchar(5)
, @userid nvarchar(10)
, @userprefix nvarchar(10)
, @userfirstname nvarchar(50)
, @userlastname nvarchar(50)
, @bagno nvarchar(20)
, @credit decimal(6,0)
, @flag int
, @creditdate datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
	IF EXISTS (
		SELECT *	 
		FROM [dbo].[UserCreditOnJob]
		WHERE [TSBId] = @tsbid
		and [UserId] = @userid
		and [BagNo] = @bagno
		and [Flag] = 0
		
	)
	BEGIN

	UPDATE [dbo].[UserCreditOnJob]
	SET [Credit] = @credit
	, [Flag] = @flag
	, [CreditDate] = @creditdate
	WHERE  [TSBId] = @tsbid
		and [UserId] = @userid
		and [BagNo] = @bagno
		and [Flag] = 0
	END
	ELSE
		
	INSERT INTO [dbo].[UserCreditOnJob]
           ([TSBId] ,[UserId] , [UserPrefix], [UserFirstName],[UserLastName] ,[BagNo]
           , [Credit], [Flag] , [CreditDate] )
     VALUES
           (@tsbid, @userid ,@userprefix ,@userfirstname, @userlastname, @bagno, @credit, 0, @creditdate );


		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO

