/****** Object:  StoredProcedure [dbo].[TOD_SaveTSBShift]    Script Date: 5/6/2564 11:05:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*********** Script Update Date: 2020-08-13  ***********/


create PROCEDURE [dbo].[TOD_SaveTSBShift] (
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
END


/*********** Script Update Date: 2020-08-13  ***********/

GO

