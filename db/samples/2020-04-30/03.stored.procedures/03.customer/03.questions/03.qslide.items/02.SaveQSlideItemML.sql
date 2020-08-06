SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSlideItemML.
-- Description:	Save Question Slide Item ML.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSlideItemML N'EDL-C2018050001', N'QS00001', 1, N'TH', N'คำถามที่ 1'
--exec SaveQSlideItemML N'EDL-C2018050001', N'QS00001', 1, N'JA', N'質問 1'
--DECLARE @customerId nvarchar(30) = N'EDL-C2018050001';
--DECLARE @qsetId nvarchar(30) = 'QS00001';
--DECLARE @langId nvarchar(3) = NULL;
--DECLARE @qSeq int = 1;
--DECLARE @qSSeq int = 1;
--DECLARE @qText nvarchar(MAX);
--DECLARE @isRemark bit = NULL;
--DECLARE @sortOrder int = NULL;
--DECLARE @errNum int;
--DECLARE @errMsg nvarchar(MAX);

--SET @langId = N'TH';
--SET @qText = N'ตัวเลือกที่ 1';
--EXEC SaveQSlideItemML @customerId, @qsetId, @qSeq, @qSSeq, @langId
--					  , @qText
--					  , @errNum out, @errMsg out
--SELECT @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @langId = N'JA';
--SET @qText = N'選択肢 1';
--EXEC SaveQSlideItemML @customerId, @qsetId, @qSeq, @qSSeq, @langId
--					  , @qText
--					  , @errNum out, @errMsg out
--SELECT @errNum AS ErrNum, @errMsg AS ErrMsg;
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSlideItemML] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @qSSeq as int
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
DECLARE @iQSlideItemCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1609 : Lang Id cannot be null or empty string.
	-- 1610 : Lang Id not found.
	-- 1611 : Customer Id cannot be null or empty string.
	-- 1612 : Customer Id not found.
	-- 1613 : QSetId cannot be null or empty string.
	-- 1614 : No QSet match QSetId in specificed Customer Id.
	-- 1615 : QSeq is null or less than zero.
	-- 1616 : No QSlide match QSetId and QSeq.
	-- 1617 : QSSeq is null or less than zero.
	-- 1618 : No QSlideItem match QSetId, QSeq and QSSeq.
	-- 1619 : Question Item Text (ML) cannot be null or empty string.
	-- 1620 : Question Item Text (ML) already exists.
	-- 1621 : 
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1609, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 1610, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1611, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1612, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId is not null. */
		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSetId cannot be null or empty string.
            EXEC GetErrorMsg 1613, @errNum out, @errMsg out
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
            EXEC GetErrorMsg 1614, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSeq IS NULL OR @qSeq <= 0)
		BEGIN
			-- QSeq is null or less than zero.
            EXEC GetErrorMsg 1615, @errNum out, @errMsg out
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
            EXEC GetErrorMsg 1616, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSSeq IS NULL OR @qSSeq <= 0)
		BEGIN
			-- QSSeq is null or less than zero.
            EXEC GetErrorMsg 1617, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iQSlideItemCnt = COUNT(*)
		  FROM QSlideItem
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		   AND QSSeq = @qSSeq;

		IF (@iQSlideItemCnt = 0)
		BEGIN
			-- No QSlideItem match QSetId, QSeq and QSSeq.
            EXEC GetErrorMsg 1618, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qText) = 1)
		BEGIN
			-- Question Item Text (ML) cannot be null or empty string.
            EXEC GetErrorMsg 1619, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iQSlideItemCnt = COUNT(*)
		  FROM QSlideItemML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		   AND QSSeq <> @qSSeq
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(QText))) = UPPER(RTRIM(LTRIM(@qText)));
		IF (@iQSlideItemCnt <> 0)
		BEGIN
			-- Question Item Text (ML) already exists.
            EXEC GetErrorMsg 1620, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSlideItemCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iQSlideItemCnt = COUNT(*)
		  FROM QSlideItemML
		 WHERE UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		   AND QSeq = @qSeq
		   AND QSSeq = @qSSeq
		   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))

		IF (@iQSlideItemCnt = 0)
		BEGIN
			INSERT INTO QSlideItemML
			(
				  CustomerId
				, QSetId
				, QSeq
				, QSSeq
				, LangId
				, QText
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@qSetId)))
				, @qSeq
				, @qSSeq
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@qText))
			);
		END
		ELSE
		BEGIN
			UPDATE QSlideItemML
			   SET QText = RTRIM(LTRIM(@qText))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(QSetId))) = UPPER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq
			   AND QSSeq = @qSSeq
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
