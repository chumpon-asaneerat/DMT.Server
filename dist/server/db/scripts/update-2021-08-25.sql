/*********** Script Update Date: 2021-08-25  ***********/
ALTER TABLE [dbo].[UserCreditOnJob]
ALTER COLUMN  [UserPrefix] nvarchar(30)

/*********** Script Update Date: 2021-08-25  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*********** Script Update Date: 2020-08-13  ***********/


ALTER PROCEDURE [dbo].[Acc_SaveUserCreditOnJob] (
  @tsbid nvarchar(5)
, @userid nvarchar(10)
, @userprefix nvarchar(30)
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



/*********** Script Update Date: 2021-08-25  ***********/

/****** Object:  StoredProcedure [dbo].[TOD_SaveTSBShift]    Script Date: 8/26/2021 4:37:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*********** Script Update Date: 2020-08-13  ***********/


ALTER PROCEDURE [dbo].[TOD_SaveTSBShift] (
  @tsbshiftid nvarchar(36)
, @tsbid nvarchar(10)
, @shiftid int
, @userid nvarchar(10)
, @fullnameen nvarchar(150)
, @fullnameth nvarchar(150)
, @begin datetime
, @end datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
/**

	BEGIN TRY
	IF EXISTS (
		SELECT *	 
		FROM [dbo].[TOD_TSBShift]
		WHERE [TSBId] = @tsbid
		and [EndTime] is null
		
		
	)
	BEGIN

	UPDATE [dbo].[TOD_TSBShift]
	SET  [EndTime]= @begin
	WHERE   [TSBId] = @tsbid
		and [EndTime] is null
	END
	

		
	INSERT INTO [dbo].[TOD_TSBShift]
           ([TSBShiftId], [TSBId] ,[ShiftId], [UserId] , [FullNameEN], [FullNameTH], [BeginTime],[EndTime] )
     VALUES
           (@tsbshiftid, @tsbid, @shiftid, @userid ,@fullnameen,@fullnameth,@begin ,@end  );


		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
**/
BEGIN TRY
	
	IF not EXISTS (
		SELECT *	 
		FROM [dbo].[TOD_TSBShift]
		WHERE  [TSBId] = @tsbid
		and [TSBShiftId] = @tsbshiftid
			
	)
	BEGIN
	
	
	INSERT INTO [dbo].[TOD_TSBShift]
           ([TSBShiftId], [TSBId] ,[ShiftId], [UserId] , [FullNameEN], [FullNameTH], [BeginTime],[EndTime] )
     VALUES
           (@tsbshiftid, @tsbid, @shiftid, @userid ,@fullnameen,@fullnameth,@begin ,@end  );
    
	END
	Else 
	BEGIN

	UPDATE [dbo].[TOD_TSBShift]
	SET  [EndTime]= @end
	WHERE   [TSBId] = @tsbid
		and [TSBShiftId] = @tsbshiftid
	END

		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END







