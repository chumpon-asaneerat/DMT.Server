SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SavePeriodUnit.
-- Description:	Save PeriodUnit.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
-- <2019-08-19> :
--	- Rename @descriptionEN parameter to @description
--
-- [== Example ==]
--
--exec SavePeriodUnit 4, N'quarter'
-- =============================================
CREATE PROCEDURE [dbo].[SavePeriodUnit] (
  @periodUnitId as int = null
, @description as nvarchar(50) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iPeriodCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 301 : PeriodUnit Id cannot be null.
	-- 302 : Description (default) cannot be null or empty string.
	-- 303 : Description (default) is duplicated.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@periodUnitId IS NULL)
		BEGIN
            EXEC GetErrorMsg 301, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
            EXEC GetErrorMsg 302, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iPeriodCnt = COUNT(*)
		  FROM PeriodUnit
		 WHERE PeriodUnitId = @periodUnitId

		IF (@iPeriodCnt = 0)
		BEGIN
			-- Detected PeriodUnit not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnit
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iDescCnt <> 0)
			BEGIN
                EXEC GetErrorMsg 303, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iPeriodCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO PeriodUnit
			(
				  [PeriodUnitId]
				, [Description]
			)
			VALUES
			(
				  @periodUnitId
				, RTRIM(LTRIM(@description))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE PeriodUnit
			   SET [Description] = RTRIM(LTRIM(@description))
			 WHERE [PeriodUnitId] = @periodUnitId;
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
