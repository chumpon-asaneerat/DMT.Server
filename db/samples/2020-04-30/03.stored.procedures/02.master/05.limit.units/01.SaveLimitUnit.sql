SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLimitUnit.
-- Description:	Save Limit Unit.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
-- <2019-08-19> :
--	- Rename @descriptionEN parameter to @description
--	- Rename @unitTextEN parameter to @unitText
--
-- [== Example ==]
--
--exec SaveLimitUnit 4, N'Number Of Connection', N'connection(s)'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLimitUnit] (
  @limitUnitId as int = null
, @description as nvarchar(50) = null
, @unitText as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLimitCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 401 : LimitUnit Id cannot be null.
	-- 402 : Description (default) cannot be null or empty string.
	-- 403 : Description (default) is duplicated.
	-- 404 : UnitText (default) cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@limitUnitId IS NULL)
		BEGIN
            EXEC GetErrorMsg 401, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
            EXEC GetErrorMsg 402, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLimitCnt = COUNT(*)
		  FROM LimitUnit
		 WHERE LimitUnitId = @limitUnitId

		IF (@iLimitCnt = 0)
		BEGIN
			-- Detected PeriodUnit not exists so need to check duplicate description.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnit
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description))) COLLATE SQL_Latin1_General_CP1_CS_AS

			IF (@iDescCnt <> 0)
			BEGIN
                EXEC GetErrorMsg 403, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (dbo.IsNullOrEmpty(@unitText) = 1)
		BEGIN
            EXEC GetErrorMsg 404, @errNum out, @errMsg out
			RETURN
		END

		IF @iLimitCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO LimitUnit
			(
				  [LimitUnitId]
				, [Description]
				, [UnitText]
			)
			VALUES
			(
				  @limitUnitId
				, RTRIM(LTRIM(@description))
				, RTRIM(LTRIM(@unitText))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE LimitUnit
			   SET [Description] = RTRIM(LTRIM(@description))
			     , [UnitText] = RTRIM(LTRIM(COALESCE(@unitText, [UnitText])))
			 WHERE [LimitUnitId] = @limitUnitId;
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
