SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Delete QSlide
-- [== History ==]
-- <2019-12-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DeleteQSlide N'EDL-C2019100003', N'QS00001', 2
-- =============================================
CREATE PROCEDURE [dbo].[DeleteQSlide]
(
  @customerId nvarchar(30)
, @qSetId nvarchar(30)
, @qSeq int
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iCnt int;
    -- Error Code:
    --   0 : Success
	-- 4201: Customer Id cannot be null or empty string.
	-- 4202: Qset Id cannot be null or empty string.
	-- 4203: QSeq cannot be null.
	-- 4204: Cannot be remove qslide that already in used.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 4201, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- Qset Id cannot be null or empty string.
            EXEC GetErrorMsg 4202, @errNum out, @errMsg out
			RETURN
		END
		
		IF (@qSeq IS NULL)
		BEGIN
			-- QSeq cannot be null.
            EXEC GetErrorMsg 4203, @errNum out, @errMsg out
			RETURN
		END

		SET @iCnt = 0;
		SELECT @iCnt = COUNT(*) 
		  FROM Vote
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 
		   AND QSeq = @qSeq

		IF (@iCnt > 0)
		BEGIN
			-- Cannot be remove qslideitem that already in used.
			EXEC GetErrorMsg 4254, @errNum out, @errMsg out
			RETURN
		END

		DELETE FROM QSlideItemML
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 
		   AND LTRIM(RTRIM(LOWER(QSeq))) = LTRIM(RTRIM(LOWER(@qSeq))) 

		DELETE FROM QSlideItem
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 
		   AND LTRIM(RTRIM(LOWER(QSeq))) = LTRIM(RTRIM(LOWER(@qSeq))) 

		DELETE FROM QSlideML
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 
		   AND LTRIM(RTRIM(LOWER(QSeq))) = LTRIM(RTRIM(LOWER(@qSeq))) 

		DELETE FROM QSlide 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 
		   AND LTRIM(RTRIM(LOWER(QSeq))) = LTRIM(RTRIM(LOWER(@qSeq))) 

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
