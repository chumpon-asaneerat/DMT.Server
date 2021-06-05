/****** Object:  StoredProcedure [dbo].[TOD_SaveUserShift]    Script Date: 5/6/2564 11:06:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*********** Script Update Date: 2020-08-13  ***********/


create PROCEDURE [dbo].[TOD_SaveUserShift] (
  @usershiftid nvarchar(36)
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

	BEGIN TRY
	IF EXISTS (
		SELECT *	 
		FROM [dbo].[TODUserShift]
		WHERE [TSBId] = @tsbid
		and [UserShiftId] = @usershiftid
		
		
	)
	BEGIN

	UPDATE [dbo].[TODUserShift]
	SET [FullNameEN] = @fullnameen
	,	[FullNameTH] =@fullnameth
	,  [EndTime]= @end
	,  [ShiftId] = @shiftid
	WHERE   [TSBId] = @tsbid
		and [UserShiftId] = @usershiftid
	END
	ELSE
		
	INSERT INTO [dbo].[TODUserShift]
           ([UserShiftId], [TSBId] ,[UserId] ,[ShiftId] , [FullNameEN], [FullNameTH], [BeginTime],[EndTime] )
     VALUES
           (@usershiftid, @tsbid, @userid , @shiftid ,@fullnameen,@fullnameth,@begin ,@end  );


		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

/*********** Script Update Date: 2020-08-13  ***********/

GO

