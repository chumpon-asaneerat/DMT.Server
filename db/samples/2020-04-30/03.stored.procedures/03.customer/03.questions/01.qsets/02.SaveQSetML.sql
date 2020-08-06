SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSetML.
-- Description:	Save Question Set ML.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSetML N'EDL-C2018050001', N'QS00001', N'TH', N'คำถามที่ 1'
--exec SaveQSetML N'EDL-C2018050001', N'QS00001', N'JA', N'質問 1'
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSetML] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @langId as nvarchar(3)
, @description as nvarchar(MAX)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iLangCnt int = 0;
DECLARE @iQSetCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1409 : Lang Id cannot be null or empty string.
	-- 1410 : Lang Id not found.
	-- 1411 : Customer Id cannot be null or empty string.
	-- 1412 : Customer Id not found.
	-- 1413 : QSetId cannot be null or empty string.
	-- 1414 : No QSet match QSetId in specificed Customer Id.
	-- 1415 : Description(ML) already exists.
	-- 1418 : Description (ML) cannot be null or empty string.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1409, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 1410, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1411, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1412, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId is not null. */
		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSetId cannot be null or empty string.
            EXEC GetErrorMsg 1413, @errNum out, @errMsg out
			RETURN
		END

		/* Check QSetId is in QSet table */ 
		SELECT @iQSetCnt = COUNT(*)
		  FROM QSet
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iQSetCnt = 0)
		BEGIN
			-- No QSet match QSetId in specificed Customer Id.
            EXEC GetErrorMsg 1414, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (ML) cannot be null or empty string.
            EXEC GetErrorMsg 1418, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iQSetCnt = COUNT(*)
		  FROM QSetML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) <> UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(Description))) = UPPER(RTRIM(LTRIM(@description)));
		IF (@iQSetCnt <> 0)
		BEGIN
			-- Description (ML) already exists.
            EXEC GetErrorMsg 1415, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSetCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iQSetCnt = COUNT(*)
		  FROM QSetML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) <> UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))

		IF (@iQSetCnt = 0)
		BEGIN
			INSERT INTO QSetML
			(
				  CustomerId
				, QSetId
				, LangId
				, Description
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@qSetId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@description))
			);
		END
		ELSE
		BEGIN
			UPDATE QSetML
			   SET Description = RTRIM(LTRIM(@description))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END
		
		-- SUCCESS
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
