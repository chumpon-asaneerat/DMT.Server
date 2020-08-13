ALTER PROCEDURE [dbo].[TCTSaveLaneAttendance] (
  @jobid nvarchar(20)
 , @tsbid nvarchar(5)
, @plazaid nvarchar(10)
, @laneid nvarchar(10)
, @userid nvarchar(10)
, @boj datetime
, @eoj datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @plazagroupid nvarchar(10) = NULL;
DECLARE @tsb nvarchar(5) = NULL;

	select @plazagroupid = [PlazaGroupId] ,
	        @tsb = [TSBId]
	FROM [dbo].[Lane]
	WHERE	[LaneId] = @laneid ;
		--and [PlazaId] = @plazaid
		
	BEGIN TRY
		IF EXISTS (
		SELECT *	 
		FROM [dbo].[LaneAttendance]
		WHERE [JobId] = @jobid
		and  [LaneId] = @laneid
		and [PlazaId] = @plazaid
		
	)
	BEGIN
	UPDATE [dbo].[LaneAttendance]
	SET [EOJ] = @eoj
    WHERE [JobId] = @jobid
		and  [LaneId] = @laneid
		and [PlazaId] = @plazaid;
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[LaneAttendance]
           ([JobId],[TSBId],[PlazaGroupId],[PlazaId],[LaneId],[UserId],[BOJ],[EOJ] )
     VALUES ( @jobid , @tsb , @plazagroupid, @plazaid
	         ,@laneid , @userid , @boj ,@eoj )


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO