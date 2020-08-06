SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSlideItem.
-- Description:	Save New Question Slide Item.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
-- <2020-03-26> :
--	- Add choice parameter.
--
-- [== Example ==]
--DECLARE @customerId nvarchar(30) = N'EDL-C2018050001';
--DECLARE @qsetId nvarchar(30) = 'QS00001';
--DECLARE @qSeq int = 1;
--DECLARE @qSSeq int = NULL;
--DECLARE @qText nvarchar(MAX);
--DECLARE @isRemark bit = NULL;
--DECLARE @choice int = NULL;
--DECLARE @sortOrder int = NULL;
--DECLARE @errNum int;
--DECLARE @errMsg nvarchar(MAX);
--
--SET @qSSeq = NULL;
--SET @qText = N'Choice 1';
--SET @choice = 1;
--SET @isRemark = NULL;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @qSSeq = NULL;
--SET @qText = N'Choice 2';
--SET @choice = 2;
--SET @isRemark = NULL;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @qSSeq = NULL;
--SET @qText = N'Choice 3';
--SET @choice = 3;
--SET @isRemark = NULL;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @qSSeq = NULL;
--SET @qText = N'Choice 4';
--SET @choice = 4;
--SET @isRemark = NULL;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
--
--SET @qSSeq = NULL;
--SET @qText = N'Remark';
--SET @choice = 0;
--SET @isRemark = 1;
--EXEC SaveQSlideItem @customerId, @qsetId, @qSeq
--					, @qText, @isRemark, @choice, @sortOrder
--					, @qSSeq out
--					, @errNum out, @errMsg out
--SELECT @qSSeq AS QSSeq, @errNum AS ErrNum, @errMsg AS ErrMsg;
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSlideItem] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @qText as nvarchar(max) = null
, @isRemark as bit = 0
, @choice as int = null
, @sortOrder int = 0
, @qSSeq as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iQSlideCnt int = 0;
DECLARE @iQSSeqCnt int = 0;
DECLARE @iLastSSeq int = 0;
DECLARE @vQSSeq int = 0;
	-- Error Code:
	--    0 : Success
	-- 1601 : Customer Id cannot be null or empty string.
	-- 1602 : Question Set Id cannot be null or empty string.
	-- 1603 : QSeq cannot be null or less than zero.
	-- 1604 : Question Text cannot be null or empty string.
	-- 1605 : Customer Id is not found.
	-- 1606 : QSetId is not found. 
	-- 1607 : QSlide is not found.
	-- 1608 : QSSeq is not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
			EXEC GetErrorMsg 1601, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- Question Set Id cannot be null or empty string.
			EXEC GetErrorMsg 1602, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSeq IS NULL OR @qSeq <= 0)
		BEGIN
			-- QSeq cannot be null or less than zero.
			EXEC GetErrorMsg 1603, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qText) = 1)
		BEGIN
			-- Question Text cannot be null or empty string.
			EXEC GetErrorMsg 1604, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 1605, @errNum out, @errMsg out
			RETURN
		END

		/* Check if QSetId exists */
		IF (@qSetId IS NOT NULL AND LTRIM(RTRIM(@qSetId)) <> N'')
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));
			IF (@iQSetCnt = 0)
			BEGIN
				-- QSetId is not found.
                EXEC GetErrorMsg 1606, @errNum out, @errMsg out
				RETURN
			END
		END

		/* Check if QSlide exists */
		SELECT @iQSlideCnt = COUNT(*)
		  FROM QSlide
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
		   AND QSeq = @qSeq;
		IF (@iQSlideCnt = 0)
		BEGIN
			-- QSlide is not found.
            EXEC GetErrorMsg 1607, @errNum out, @errMsg out
			RETURN
		END

		-- Checks is QSSeq has value and exists
		IF (@qSSeq IS NULL OR @qSSeq <= 0)
		BEGIN
			SELECT @vQSSeq = MAX(QSSeq)
			  FROM QSlideItem
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq;
			IF (@vQSSeq IS NULL OR @vQSSeq <= 0)
			BEGIN
				-- SET SEQ TO 1.
				SET @iLastSSeq = 1;
			END
			ELSE
			BEGIN
				-- INCREACE SEQ.
				SET @iLastSSeq = @vQSSeq + 1;
			END
			-- Set sort order if required.
			IF @sortOrder is null or @sortOrder <= 0
			BEGIN
				SET @sortOrder = @iLastSSeq;
			END
			-- Check Has Remark.
			IF @isRemark is null
			BEGIN
				SET @isRemark = 0; -- default
			END
			-- INSERT
			INSERT INTO QSlideItem
			(
				  CustomerId
				, QSetId
				, QSeq
				, QSSeq
				, QText
				, IsRemark
				, SortOrder
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@qSetId))
				, @qSeq
				, @iLastSSeq
				, RTRIM(LTRIM(@qText))
				, @isRemark
				, @sortOrder
				, 1
			);
			-- SET OUTPUT.
			SET @qSSeq = @iLastSSeq;
		END
		ELSE
		BEGIN
			-- CHECKS QSSeq exist.
			SELECT @iQSSeqCnt = COUNT(QSSeq)
			  FROM QSlideItem
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq
			   AND QSSeq = @qSSeq;
			IF (@iQSSeqCnt IS NULL OR @iQSSeqCnt <= 0)
			BEGIN
				-- QSSeq is not found.
                EXEC GetErrorMsg 1608, @errNum out, @errMsg out
				RETURN
			END
			-- Set sort order if required.
			IF (@sortOrder IS NOT NULL AND @sortOrder <= 0)
			BEGIN
				SET @sortOrder = @qSSeq;
			END
			-- UPDATE
			UPDATE QSlideItem
			   SET QText = RTRIM(LTRIM(@qText))
			     , IsRemark = COALESCE(@isRemark, IsRemark)
				 , SortOrder = COALESCE(@sortOrder, SortOrder)
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq
			   AND QSSeq = @qSSeq;
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
