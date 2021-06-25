
/****** Object:  StoredProcedure [dbo].[TCTCheckTODBoj]    Script Date: 25/6/2564 19:52:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create  PROCEDURE [dbo].[TCTCheckTODBoj] 
(
 @tsbid nvarchar(5),
 @userid nvarchar(10)
)
AS
BEGIN
	select T.UserId , T.FullNameTH , T.BeginTime
from  [dbo].[TODUserShift] T
where T.TSBId = @tsbid
AND T.UserId = @userid
and T.EndTime is null 

END


GO


