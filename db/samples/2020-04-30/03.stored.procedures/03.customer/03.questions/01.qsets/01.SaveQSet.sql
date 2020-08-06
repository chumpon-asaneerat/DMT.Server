SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveQSet.
-- Description:	Save Question Set.
-- [== History ==]
-- <2018-05-13> :
--	- Stored Procedure Created.
-- <2018-05-15> :
--	- Add Check code for duplicate description (ERROR_CORE 1416).
-- <2018-12-26> :
--	- Remove date overlap check code (ERROR_CORE 1418).
--	
--
-- [== Example ==]
--DECLARE @customerId nvarchar(30) = NULL;
--DECLARE @qsetId nvarchar(30) = NULL;
--DECLARE @description nvarchar(MAX);
--DECLARE @displayMode tinyint = 0;
--DECLARE @hasRemark bit = 1;
--DECLARE @isDefault bit = 0;
--DECLARE @beginDate datetime = NULL;
--DECLARE @endDate datetime = NULL;
--DECLARE @errNum int;
--DECLARE @errMsg nvarchar(MAX);
--
--SET @customerId = N'EDL-C2018050001';
--SET @description = N'Question Set 1';
--SET @beginDate = '2018-05-10';
--SET @endDate = '2018-05-15';
--
--EXEC SaveQSet @customerId
--			  , @description
--			  , @hasRemark, @displayMode
--			  , @isDefault
--			  , @beginDate, @endDate
--			  , @qsetId out
--			  , @errNum out, @errMsg out
--SELECT @errNum AS ErrNum, @errMsg AS ErrMsg, @qsetId AS QSetId;
-- =============================================
CREATE PROCEDURE [dbo].[SaveQSet] (
  @customerId as nvarchar(30)
, @description as nvarchar(MAX)
, @hasRemark as bit = 0
, @displayMode as tinyint = 0
, @isDefault as bit = 0
, @beginDate as datetime = null
, @endDate as datetime = null
, @qSetId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iQSetCnt int = 0;
DECLARE @iVoteCnt int = 0;

DECLARE @vBeginDate datetime;
DECLARE @vEndDate datetime; 
DECLARE @vBeginDateStr nvarchar(40);
DECLARE @vEndDateStr nvarchar(40); 
	-- Error Code:
	--   0 : Success
	-- 1401 : Customer Id cannot be null or empty string.
	-- 1402 : Customer Id is not found.
	-- 1403 : QSet Id is not found.
	-- 1404 : QSet is already used in vote table.
	-- 1405 : Begin Date and/or End Date should not be null.
	-- 1406 : Display Mode is null or value is not in 0 to 1.
	-- 1407 : Begin Date should less than End Date.
	-- 1408 : Begin Date or End Date is overlap with another Question Set.
	-- 1416 : Description (default) cannot be null or empty string.
	-- 1417 : Description (default) already exists.
	-- 1418 : Begin Date or End Date is overlap with another Question Set.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @isDefault IS NULL
		BEGIN
			SET @isDefault = 0;
		END

		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1401, @errNum out, @errMsg out
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
				-- QSet Id is not found.
                EXEC GetErrorMsg 1403, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (@beginDate is null or @endDate is null)
		BEGIN
			-- Begin Date and/or End Date should not be null.
			EXEC GetErrorMsg 1405, @errNum out, @errMsg out
			RETURN
		END

		IF (@displayMode is null or (@displayMode < 0 or @displayMode > 1))
		BEGIN
			-- Display Mode is null or value is not in 0 to 1.
			EXEC GetErrorMsg 1406, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSetCnt = 0; -- Reset Counter.
		-- Check the default is already exist or not.
		SELECT @iQSetCnt = COUNT(*)
		  FROM QSet
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND IsDefault = 1;

		-- Checks IsDefault, Begin-End Date.
		IF (@isDefault = 1)
		BEGIN
			IF (@iQSetCnt <> 0)
			BEGIN
				-- It's seem the default QSet is already exists.
				-- Set the exists default default QSet to 0
				UPDATE QSet
				   SET IsDefault = 0
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
			END

			-- CONVERT DATE
			SET @vBeginDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @beginDate)) + '-' +
								  CONVERT(nvarchar(2), DatePart(mm, @beginDate)) + '-' +
								  CONVERT(nvarchar(2), DatePart(dd, @beginDate)) + ' ' +
								  N'00:00:00');
			--SET @vBeginDate = CONVERT(datetime, @vBeginDateStr, 121);
			SET @vBeginDate = CAST(@vBeginDateStr AS datetime)

			SET @vEndDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @endDate)) + '-' +
								CONVERT(nvarchar(2), DatePart(mm, @endDate)) + '-' +
								CONVERT(nvarchar(2), DatePart(dd, @endDate)) + ' ' +
								N'23:59:59');
			--SET @vEndDate = CONVERT(datetime, @vEndDateStr, 121);
			SET @vEndDate = CAST(@vEndDateStr AS datetime)

			IF (@vBeginDate > @vEndDate)
			BEGIN
				-- Begin Date should less than End Date.
				EXEC GetErrorMsg 1407, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			IF (@iQSetCnt = 0)
			BEGIN
				-- It's seem the default QSet is not exists.
				-- Set current QSet as default.
				SET @isDefault = 1
			END

			SET @vBeginDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @beginDate)) + '-' +
								  CONVERT(nvarchar(2), DatePart(mm, @beginDate)) + '-' +
								  CONVERT(nvarchar(2), DatePart(dd, @beginDate)) + ' ' +
								  N'00:00:00');
			SET @vBeginDate = CONVERT(datetime, @vBeginDateStr, 121);

			SET @vEndDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @endDate)) + '-' +
								CONVERT(nvarchar(2), DatePart(mm, @endDate)) + '-' +
								CONVERT(nvarchar(2), DatePart(dd, @endDate)) + ' ' +
								N'23:59:59');
			SET @vEndDate = CONVERT(datetime, @vEndDateStr, 121);

			IF (@vBeginDate > @vEndDate)
			BEGIN
				-- Begin Date should less than End Date.
				EXEC GetErrorMsg 1407, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (dbo.IsNullOrEmpty(@description) = 1)
		BEGIN
			-- Description (default) cannot be null or empty string.
            EXEC GetErrorMsg 1416, @errNum out, @errMsg out
			RETURN
		END

		SET @iQSetCnt = 0; -- Reset Counter.

		-- Checks Duplicated desctiption.
		IF (@qSetId IS NULL)
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(LTRIM(RTRIM(Description))) = LOWER(LTRIM(RTRIM(@description)))
			IF (@iQSetCnt <> 0)
			BEGIN
				-- Description (default) already exists.
                EXEC GetErrorMsg 1417, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(LTRIM(RTRIM(QSetId))) <> LOWER(LTRIM(RTRIM(@qSetId)))
			   AND LOWER(LTRIM(RTRIM(Description))) = LOWER(LTRIM(RTRIM(@description)))
			IF (@iQSetCnt <> 0)
			BEGIN
				-- Description (default) already exists.
                EXEC GetErrorMsg 1417, @errNum out, @errMsg out
				RETURN
			END
		END

		IF dbo.IsNullOrEmpty(@qSetId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
			                , N'QSet'
							, @qSetId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iQSetCnt = COUNT(*)
			  FROM QSet
			 WHERE LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)))
			   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		-- Checks is already in used.
		SELECT @iVoteCnt = COUNT(*)
			FROM Vote
			WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			AND LOWER(QSetId) = LOWER(RTRIM(LTRIM(@qSetId)));

		IF (@iVoteCnt <> 0)
		BEGIN
			-- QSet is already used in vote table.
            EXEC GetErrorMsg 1404, @errNum out, @errMsg out
			RETURN
		END

		IF @iQSetCnt = 0
		BEGIN
			INSERT INTO QSet
			(
				  CustomerID
				, QSetID
				, [Description]
				, HasRemark
				, DisplayMode
				, IsDefault
				, BeginDate
				, EndDate
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@qSetId))
				, RTRIM(LTRIM(@description))
				, @hasRemark
				, @displayMode
				, @isDefault
				, @vBeginDate
				, @vEndDate
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE QSet
			   SET [Description] = RTRIM(LTRIM(@description))
			     , HasRemark = @hasRemark
				 , DisplayMode = @displayMode
			     , IsDefault = @isDefault
				 , BeginDate = @vBeginDate
				 , EndDate = @vEndDate
			 WHERE LOWER(QSetID) = LOWER(RTRIM(LTRIM(@qSetId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
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
