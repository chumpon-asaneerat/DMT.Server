SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSlideML.
-- Description:	Save Question Slide ML.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSlideML N'EDL-C2018050001', N'QS00001', 1, N'TH', N'คำถามที่ 1'
--exec SaveQSlideML N'EDL-C2018050001', N'QS00001', 1, N'JA', N'質問 1'
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSlideML] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @langId as nvarchar(3)
, @qText as nvarchar(MAX)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iLangCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iQSlideCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1507 : Lang Id cannot be null or empty string.
	-- 1508 : Lang Id not found.
	-- 1509 : Customer Id cannot be null or empty string.
	-- 1510 : Customer Id not found.
	-- 1511 : QSetId cannot be null or empty string.
	-- 1512 : No QSet match QSetId in specificed Customer Id.
	-- 1513 : QSeq is null or less than zero.
	-- 1514 : No QSlide match QSetId and QSeq.
	-- 1515 : Question Text (ML) cannot be null or empty string.
	-- 1516 : Question Text (ML) already exists.
	-- 1517 : 
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1507, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 1508, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1509, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1510, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId is not null. */
		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSetId cannot be null or empty string.
            EXEC GetErrorMsg 1511, @errNum out, @errMsg out
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
            EXEC GetErrorMsg 1512, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSeq IS NULL OR @qSeq <= 0)
		BEGIN
			-- QSeq is null or less than zero.
            EXEC GetErrorMsg 1513, @errNum out, @errMsg out
			RETURN
		END

		/* Check QSetId, QSeq is in QSlide table */
		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlide
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		IF (@iQSlideCnt = 0)
		BEGIN
			-- No QSlide match QSetId and QSeq.
            EXEC GetErrorMsg 1514, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qText) = 1)
		BEGIN
			-- Question Text (ML) cannot be null or empty string.
            EXEC GetErrorMsg 1515, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlideML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq <> @qSeq
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(QText))) = UPPER(RTRIM(LTRIM(@qText)));
		IF (@iQSlideCnt <> 0)
		BEGIN
			-- Question Text (ML) already exists.
            EXEC GetErrorMsg 1516, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSlideCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlideML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))

		IF (@iQSlideCnt = 0)
		BEGIN
			INSERT INTO QSlideML
			(
				  CustomerId
				, QSetId
				, QSeq
				, LangId
				, QText
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@qSetId)))
				, @qSeq
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@qText))
			);
		END
		ELSE
		BEGIN
			UPDATE QSlideML
			   SET QText = RTRIM(LTRIM(@qText))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq
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
