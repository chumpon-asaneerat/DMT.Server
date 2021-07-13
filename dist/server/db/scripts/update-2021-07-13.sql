/*********** Script Update Date: 2021-07-13  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER  PROCEDURE [dbo].[TCTCheckTODBoj] 
(
 @tsbid nvarchar(5),
 @userid nvarchar(10)
)
AS
BEGIN
	select T.UserId , T.FullNameTH , T.BeginTime , T.ShiftId
from  [dbo].[TODUserShift] T
where T.TSBId = @tsbid
AND T.UserId = @userid
and T.EndTime is null 

END


GO
