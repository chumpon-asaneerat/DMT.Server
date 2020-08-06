SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLimitUnitML.
-- Description:	Save LimitUnit ML.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveLimitUnitML 4, N'EN', N'Number Of Connection', N'connection(s)'
--exec SaveLimitUnitML 4, N'TH', N'จำนวนการเชื่อมต่อ', N'จุด'
-- =============================================
CREATE PROCEDURE [dbo].[SaveLimitUnitML] (
  @limitUnitId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(50) = null
, @unitText as nvarchar(20) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iLimitCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 401 : LimitUnit Id cannot be null.
	-- 405 : Language Id cannot be null or empty string.
	-- 406 : Language Id not found.
	-- 407 : Description (ML) cannot be null or empty string.
	-- 408 : Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
	-- 409 : Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@limitUnitId IS NULL)
		BEGIN
            -- LimitUnit Id cannot be null.
            EXEC GetErrorMsg 401, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
            -- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 405, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
		IF (@iLangCnt = 0)
		BEGIN
            -- Language Id not found.
            EXEC GetErrorMsg 406, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
            -- Description (ML) cannot be null or empty string.
            EXEC GetErrorMsg 407, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLimitCnt = COUNT(*)
		  FROM LimitUnitML
		 WHERE LimitUnitId = @limitUnitId
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iLimitCnt = 0)
		BEGIN
			-- Detected data not exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnitML
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 408, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			-- Detected data is exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM LimitUnitML
				WHERE LimitUnitId <> @limitUnitId
				  AND UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 409, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iLimitCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO LimitUnitML
			(
				  [LimitUnitId]
				, [LangId]
				, [Description]
				, [UnitText]
			)
			VALUES
			(
				  @limitUnitId
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@description))
				, RTRIM(LTRIM(@unitText))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE LimitUnitML
			   SET [Description] = RTRIM(LTRIM(@description))
			     , [UnitText] = RTRIM(LTRIM(COALESCE(@unitText, [UnitText])))
			 WHERE [LimitUnitId] = @limitUnitId
			   AND UPPER(RTRIM(LTRIM([LangId]))) = UPPER(RTRIM(LTRIM(@langId)));
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
