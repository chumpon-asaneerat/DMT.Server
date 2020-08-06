SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLanguage.
-- Description:	Save Language.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-06> :
--	- Update parameters for match change table structure.
--	- Add logic to allow to change DescriptionEN if in Update Mode.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2017-06-12> :
-- - Fixed all checks logic.
-- <2018-04-16> :
-- - Remove Currency.
-- - Replace FlagIconCss with FlagId.
-- - Replace Error Message code.
-- <2019-08-19> :
--	- Stored Procedure Changes.
--    - Remove @descriptionNative parameter.
--    - Rename @descriptionEN parameter to @description.
-- <2019-10-10> :
--	- Stored Procedure Changes.
--    - Remove Remove check descrption duplicate.
--
-- [== Example ==]
--
--exec SaveLanguage N'EN', N'US', N'English', 1, 1
--exec SaveLanguage N'JP', N'JA', N'中文', 2, 1
--exec SaveLanguage N'CN', N'ZH', N'中文', 3, 1
-- =============================================
CREATE PROCEDURE [dbo].[SaveLanguage] (
  @langId as nvarchar(3) = null
, @flagId as nvarchar(3) = null
, @description as nvarchar(50) = null
, @sortOrder as int = null
, @enabled as bit = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iDescCnt int = 0;
DECLARE @iSortOrder int = 0;
DECLARE @bEnabled bit = 0;

	-- Error Code:
	--   0 : Success
	-- 101 : Language Id cannot be null or empty string.
	-- 102 : Description cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			EXEC GetErrorMsg 101, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			EXEC GetErrorMsg 102, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iLangCnt = COUNT(*)
		  FROM [dbo].[Language]
		 WHERE LOWER(RTRIM(LTRIM([LangId]))) = LOWER(RTRIM(LTRIM(@langId)))

		IF @iLangCnt = 0
		BEGIN
			-- Auto set sort order if required.
			IF (@sortOrder IS NULL)
			BEGIN
				SELECT @iSortOrder = MAX([SortOrder])
				  FROM [dbo].[Language];
				IF (@iSortOrder IS NULL)
				BEGIN
					SET @iSortOrder = 1;
				END
				ELSE
				BEGIN
					SET @iSortOrder = @iSortOrder + 1;
				END
			END
			ELSE
			BEGIN
				SET @iSortOrder = @sortOrder;
			END
			-- Check enabled flag.
			IF (@enabled IS NULL)
			BEGIN
				SET @bEnabled = 0; -- default mode is disabled.
			END
			ELSE
			BEGIN
				SET @bEnabled = @enabled; -- change mode.
			END

			-- INSERT
			INSERT INTO [dbo].[Language]
			(
				  [LangId]
				, [FlagId]
				, [Description]
				, [SortOrder]
				, [Enabled]
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@langId)))
				, COALESCE(UPPER(RTRIM(LTRIM(@flagId))), UPPER(RTRIM(LTRIM(@langId))))
				, RTRIM(LTRIM(@description))
				, @iSortOrder
				, @bEnabled
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE [dbo].[Language]
			   SET [FlagId] =  COALESCE(UPPER(RTRIM(LTRIM(@flagId))), [FlagId])
			     , [Description] = RTRIM(LTRIM(@description))
			     , [SortOrder] = COALESCE(@sortOrder, [SortOrder])
			     , [Enabled] =  COALESCE(@enabled, [Enabled])
			 WHERE LOWER(RTRIM(LTRIM([LangId]))) = LOWER(RTRIM(LTRIM(@langId)));
		END
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
