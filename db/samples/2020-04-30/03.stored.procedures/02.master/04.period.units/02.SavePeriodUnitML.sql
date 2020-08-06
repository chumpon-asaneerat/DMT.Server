SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SavePeriodUnitML.
-- Description:	Save PeriodUnit ML.
-- [== History ==]
-- <2017-06-12> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SavePeriodUnitML 4, N'EN', N'quarter'
--exec SavePeriodUnitML 4, N'TH', N'ไตรมาส'
-- =============================================
CREATE PROCEDURE [dbo].[SavePeriodUnitML] (
  @periodUnitId as int = null
, @langId as nvarchar(3) = null
, @description as nvarchar(50) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iPeriodCnt int = 0;
DECLARE @iDescCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 101 : Language Id cannot be null or empty string.
	-- 104 : Language Id not found.
	-- 301 : PeriodUnit Id cannot be null.
	-- 304 : Description (ML) cannot be null or empty string.
	-- 305 : Cannot add new Description (ML) that already exists.
	-- 306 : Cannot change Description (ML) that alreadt exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@periodUnitId IS NULL)
		BEGIN
			-- Check Null Or Empty Period Unit Id.
            EXEC GetErrorMsg 301, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Check Null Or Empty Language Id.
            EXEC GetErrorMsg 101, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
		IF (@iLangCnt = 0)
		BEGIN
			-- Language not found.
            EXEC GetErrorMsg 104, @errNum out, @errMsg out
			RETURN
		END
		
		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Check Null Or Empty description.
            EXEC GetErrorMsg 304, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iPeriodCnt = COUNT(*)
		  FROM PeriodUnitML
		 WHERE PeriodUnitId = @periodUnitId
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF (@iPeriodCnt = 0)
		BEGIN
			-- Detected data not exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnitML
				WHERE UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 305, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			-- Detected data is exists so need to check duplicate description in same language.
			-- Check is description is duplicated?.
			SELECT @iDescCnt = COUNT(*)
				FROM PeriodUnitML
				WHERE PeriodUnitId <> @periodUnitId
				  AND UPPER(RTRIM(LTRIM([Description]))) = UPPER(RTRIM(LTRIM(@description)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)))

			IF (@iDescCnt <> 0)
			BEGIN
				-- Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.
                EXEC GetErrorMsg 306, @errNum out, @errMsg out
				RETURN
			END
		END

		IF @iPeriodCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO PeriodUnitML
			(
				  [PeriodUnitId]
				, [LangId]
				, [Description]
			)
			VALUES
			(
				  @periodUnitId
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@description))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE PeriodUnitML
			   SET [Description] = RTRIM(LTRIM(@description))
			 WHERE [PeriodUnitId] = @periodUnitId
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
