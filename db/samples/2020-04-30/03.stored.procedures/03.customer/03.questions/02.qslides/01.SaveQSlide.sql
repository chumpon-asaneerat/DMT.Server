SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSlide.
-- Description:	Save New Question Slide.
-- [== History ==]
-- <2018-05-15> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec SaveQSlide N'EDL-C2018050001', N'QS00001', N'What do you feel today?'
--exec SaveQSlide N'EDL-C2018050001', N'QS00001', N'What do you feel today?' /*, 0, 1, @qSeq out, @errNum out, @errMsg out*/
--exec SaveQSlide N'EDL-C2018050001', N'QS00002', N'What do think about our service?'
--exec SaveQSlide N'EDL-C2018050001', N'QS00002', N'What do think about our food taste?'
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSlide] (
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qText as nvarchar(max) = null
, @hasRemark as bit = 0
, @sortOrder int = 0
, @qSeq as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iQSeqCnt int = 0;
DECLARE @iLastSeq int = 0;
DECLARE @vQSeq int = 0;
	-- Error Code:
	--    0 : Success
	-- 1501 : Customer Id cannot be null or empty string.
	-- 1502 : Question Set Id cannot be null or empty string.
	-- 1503 : Question Text cannot be null or empty string.
	-- 1504 : Customer Id is not found.
	-- 1505 : QSetId is not found. 
	-- 1506 : QSeq is not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
			EXEC GetErrorMsg 1501, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- Question Set Id cannot be null or empty string.
			EXEC GetErrorMsg 1502, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qText) = 1)
		BEGIN
			-- Question Text cannot be null or empty string.
			EXEC GetErrorMsg 1503, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 1504, @errNum out, @errMsg out
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
                EXEC GetErrorMsg 1505, @errNum out, @errMsg out
				RETURN
			END
		END

		-- Checks is Seq has value and exists
		IF (@qSeq IS NULL OR @qSeq <= 0)
		BEGIN
			SELECT @vQSeq = MAX(QSeq)
			  FROM QSlide
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));
			IF (@vQSeq IS NULL OR @vQSeq <= 0)
			BEGIN
				-- SET SEQ TO 1.
				SET @iLastSeq = 1;
			END
			ELSE
			BEGIN
				-- INCREACE SEQ.
				SET @iLastSeq = @vQSeq + 1;
			END
			-- Set sort order if required.
			IF @sortOrder is null or @sortOrder <= 0
			BEGIN
				SET @sortOrder = @iLastSeq;
			END
			-- Check Has Remark.
			IF @hasRemark is null
			BEGIN
				SET @hasRemark = 0; -- default
			END
			-- INSERT
			INSERT INTO QSlide
			(
				  CustomerId
				, QSetId
				, QSeq
				, QText
				, HasRemark
				, SortOrder
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@qSetId))
				, @iLastSeq
				, RTRIM(LTRIM(@qText))
				, @hasRemark
				, @sortOrder
				, 1
			);
			-- SET OUTPUT.
			SET @qSeq = @iLastSeq;
		END
		ELSE
		BEGIN
			-- CHECKS QSeq exist.
			SELECT @iQSeqCnt = COUNT(QSeq)
			  FROM QSlide
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq;
			IF (@iQSeqCnt IS NULL OR @iQSeqCnt <= 0)
			BEGIN
				-- QSeq is not found.
                EXEC GetErrorMsg 1506, @errNum out, @errMsg out
				RETURN
			END
			-- Set sort order if required.
			IF (@sortOrder IS NOT NULL AND @sortOrder <= 0)
			BEGIN
				SET @sortOrder = @qSeq;
			END
			-- UPDATE
			UPDATE QSlide
			   SET QText = RTRIM(LTRIM(@qText))
			     , HasRemark = COALESCE(@hasRemark, HasRemark)
				 , SortOrder = COALESCE(@sortOrder, SortOrder)
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND QSeq = @qSeq;
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
