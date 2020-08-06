SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveErrorMsg.
-- Description:	Save Error Message.
-- [== History ==]
-- <2018-04-16> :
--	- Stored Procedure Created.
-- <2018-05-18> :
--	- Change parameter name.
--
-- [== Example ==]
--
--EXEC SaveErrorMsg 0, N'Success.';
--EXEC SaveErrorMsg 101, N'Language Id cannot be null or empty string.';
-- =============================================
CREATE PROCEDURE [dbo].[SaveErrorMsg](
  @errCode as int
, @message as nvarchar(MAX))
AS
BEGIN
DECLARE @iCnt int = 0;
    SELECT @iCnt = COUNT(*)
      FROM ErrorMessage
     WHERE ErrCode = @errCode;

    IF @iCnt = 0
    BEGIN
        -- INSERT
        INSERT INTO ErrorMessage
        (
              ErrCode
            , ErrMsg
        )
        VALUES
        (
              @errCode
            , @message
        );
    END
    ELSE
    BEGIN
        -- UPDATE
        UPDATE ErrorMessage
           SET ErrMsg = COALESCE(@message, ErrMsg)
         WHERE ErrCode = @errCode;
    END 
END

GO
