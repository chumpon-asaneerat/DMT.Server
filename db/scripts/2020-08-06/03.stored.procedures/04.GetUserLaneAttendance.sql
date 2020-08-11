CREATE PROCEDURE [dbo].[GetUserLaneAttendance]
(
    @plazagroupid nvarchar(10),
	@userid nvarchar(10) ,
	@startdate datetime,
	@enddate datetime
)
AS
BEGIN
    SELECT [JobId], [PlazaGroupId] , [PlazaId] , [LaneId] , [BOJ] , [EOJ]
	FROM [dbo].[LaneAttendance] 
     WHERE [UserId] = @userid
	and [PlazaGroupId] = @plazagroupid  
	 and [BOJ] between @startdate and @enddate
     ORDER BY [BOJ] asc;
END

GO