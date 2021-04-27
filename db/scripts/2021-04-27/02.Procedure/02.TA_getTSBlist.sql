SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create  PROCEDURE [dbo].[TA_getTSBlist] 
AS
BEGIN
	select T.* , W.SapWhsCode , W.TollwayID
from  [dbo].[TSB] T , [dbo].[SapWhsCodeTSBMap]  W
where T.TSBId = W.TSBId

END


GO