SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Delete QSet
-- [== History ==]
-- <2019-12-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DeleteQSet N'EDL-C2019100003', N'QS00001'
-- =============================================
CREATE PROCEDURE [dbo].[DeleteQSet]
(
  @customerId nvarchar(30)
, @qSetId nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iCnt int;
    -- Error Code:
    --   0 : Success
	-- 4151: Customer Id cannot be null or empty string.
	-- 4152: Qset Id cannot be null or empty string.
	-- 4153: Cannot be remove qslide that already in used.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 4151, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- Qset Id cannot be null or empty string.
            EXEC GetErrorMsg 4152, @errNum out, @errMsg out
			RETURN
		END

		SET @iCnt = 0;
		SELECT @iCnt = COUNT(*) 
		  FROM Vote
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 

		IF (@iCnt > 0)
		BEGIN
			-- Cannot be remove qset that already in used.
			EXEC GetErrorMsg 4153, @errNum out, @errMsg out
			RETURN
		END

		DELETE FROM QSlideItemML
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 

		DELETE FROM QSlideItem
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 

		DELETE FROM QSlideML
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 

		DELETE FROM QSlide 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 

		DELETE FROM QSetML
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 

		DELETE FROM QSet
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId))) 

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
