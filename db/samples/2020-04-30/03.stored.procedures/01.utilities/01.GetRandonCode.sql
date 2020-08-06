SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetRandomode.
-- Description:	GetRandomCode is generate random code with specificed length max 50.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2018-05-29> :
--  - rename from GetRandomHexCode to GetRandomCode.
--	- extend @RandomString parameter size from 20 to 50.
--
-- [== Example ==]
-- /* execute */
-- exec GetRandomCode; -- generate 6 digit code.
-- exec GetRandomCode 4; -- generate 4 digit code.
-- /* use out parameter */
-- declare @code nvarchar(20);
-- exec dbo.GetRandomCode 6, @code out;
-- select @code;
-- =============================================
CREATE PROCEDURE [dbo].[GetRandomCode]
(
  @length int = 6
, @RandomString nvarchar(50) = null out
)
AS
BEGIN
DECLARE @PoolLength int;
DECLARE @CharPool nvarchar(40);
    -- define allowable character explicitly
    SET @CharPool = N'ABCDEFGHIJKLMNPQRSTUVWXYZ1234567890';
    SET @PoolLength = Len(@CharPool);
    SET @RandomString = '';

    WHILE (LEN(@RandomString) < @Length) BEGIN
        SET @RandomString = @RandomString +  SUBSTRING(@Charpool, CONVERT(int, RAND() * @PoolLength), 1)
    END

    SELECT @RandomString as Code;
END

GO
