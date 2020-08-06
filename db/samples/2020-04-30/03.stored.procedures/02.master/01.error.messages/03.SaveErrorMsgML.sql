SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveErrorMsgML.
-- Description:	Save LimitUnit ML.
-- [== History ==]
-- <2018-05-18> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveErrorMsgML 101, N'TH', N'รหัสภาษาไม่สามารถใส่ค่าว่างได้'
-- =============================================
CREATE PROCEDURE [dbo].[SaveErrorMsgML] 
(
  @errCode as int = null
, @langId as nvarchar(3) = null
, @message as nvarchar(MAX) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iMsgCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 2201 : Error Code cannot be null or empty string.
	-- 2202 : Language Id cannot be null or empty string.
	-- 2203 : Language Id not found.
	-- 2204 : Error Message (ML) cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@errCode IS NULL)
		BEGIN
            -- LimitUnit Id cannot be null.
            EXEC GetErrorMsg 2201, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
            -- Language Id cannot be null or empty string.
            EXEC GetErrorMsg 2202, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));
		IF (@iLangCnt = 0)
		BEGIN
            -- Language Id not found.
            EXEC GetErrorMsg 2203, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@message) = 1)
		BEGIN
            -- Error Message (ML) cannot be null or empty string.
            EXEC GetErrorMsg 2204, @errNum out, @errMsg out
			RETURN
		END

		-- Check INSERT OR UPDATE?.
		SELECT @iMsgCnt = COUNT(*)
		  FROM ErrorMessageML
		 WHERE ErrCode = @errCode
		   AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(@langId)));

		IF @iMsgCnt = 0
		BEGIN
			-- INSERT
			INSERT INTO ErrorMessageML
			(
				  ErrCode
				, [LangId]
				, ErrMsg
			)
			VALUES
			(
				  @errCode
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@message))
			);
		END
		ELSE
		BEGIN
			-- UPDATE
			UPDATE ErrorMessageML
			   SET ErrMsg = RTRIM(LTRIM(@message))
			 WHERE ErrCode = @errCode
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
