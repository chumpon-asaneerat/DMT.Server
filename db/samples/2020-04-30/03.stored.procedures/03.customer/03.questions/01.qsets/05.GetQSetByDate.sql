SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetQSetByDate.
-- Description:	Get Question Set By date(s).
-- [== History ==]
-- <2019-12-26> :
--	- Stored Procedure Created.
-- <2020-01-07> :
--    - Add MinVoteDate, MaxVoteDate
--
-- [== Example ==]
--
--EXEC GetQSetByDate NULL, N'EDL-C2018050001', N'2019-12-01'
--EXEC GetQSetByDate N'EN', N'EDL-C2018050001', N'2019-12-01'
--EXEC GetQSetByDate NULL, N'EDL-C2018050001', N'2019-01-15', N'2019-02-15'
-- =============================================
CREATE PROCEDURE [dbo].[GetQSetByDate]
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @beginDate datetime = NULL
, @endDate datetime = NULL
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @vBeginDate datetime;
DECLARE @vEndDate datetime; 
DECLARE @vBeginDateStr nvarchar(40);
DECLARE @vEndDateStr nvarchar(40); 
DECLARE @qsetId nvarchar(30);
DECLARE @iCase int;
	-- Error Code:
	--   0 : Success
	-- 4701 : Customer Id cannot be null or empty string.
	-- 4702 : Begin Date is null.
	-- 4703 : Begin Date should less than End Date.
	-- 4704 : No QSet Found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1401, @errNum out, @errMsg out
			RETURN
		END
		IF (@beginDate IS NULL)
		BEGIN
			-- Begin Date is null.
            EXEC GetErrorMsg 1402, @errNum out, @errMsg out
			RETURN
		END

		IF (@endDate IS NULL)
		BEGIN
			SET @endDate = @beginDate
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
			EXEC GetErrorMsg 4703, @errNum out, @errMsg out
			RETURN
		END

		SET @qsetId = NULL
		IF ((SELECT COUNT(*) 
		       FROM QSet 
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND (   @vBeginDate BETWEEN BeginDate AND EndDate
			        OR @vEndDate BETWEEN BeginDate AND EndDate)
			   AND IsDefault = 0) > 0)
		BEGIN
			SET @iCase = 1
			-- HAS QSet between date with that not set as default.
			SELECT TOP 1 @qsetId = QSetId
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND (   @vBeginDate BETWEEN BeginDate AND EndDate
			        OR @vEndDate BETWEEN BeginDate AND EndDate
				   )
			   AND IsDefault = 0
			 --ORDER BY EndDate DESC
			 ORDER BY QSetId DESC
		END
		ELSE IF ((SELECT COUNT(*) 
		            FROM QSet 
			       WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			         AND IsDefault = 1) > 0)
		BEGIN
			SET @iCase = 2
			-- No QSet between date so used default if exists.
			SELECT TOP 1 @qsetId = QSetId
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND IsDefault = 1
			 --ORDER BY EndDate DESC
			 ORDER BY QSetId DESC
		END
		ELSE IF ((SELECT count(*) FROM QSet 
		  WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			AND IsDefault = 0) > 0)
		BEGIN
			SET @iCase = 3
			-- No QSet between date and no default is assigned in all qsets.
			-- Used top 1 (the last ones)
			SELECT TOP 1 @qsetId = QSetId
			  FROM QSet
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			 --ORDER BY EndDate DESC
			 ORDER BY QSetId DESC
		END

		IF (@qsetId IS NULL)
		BEGIN
			-- No QSet Found.
			EXEC GetErrorMsg 4704, @errNum out, @errMsg out
			RETURN
		END
		ELSE
		BEGIN
			   SELECT langId
				    , customerId
					, qSetId
					, BeginDate
					, EndDate
					, (
						SELECT MIN(VoteDate) 
						  FROM Vote 
						 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
						   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
					  ) AS MinVoteDate
					, (
						SELECT MAX(VoteDate) 
						  FROM Vote 
						 WHERE UPPER(LTRIM(RTRIM(CustomerId))) = UPPER(LTRIM(RTRIM(COALESCE(@customerId, CustomerId))))
						   AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(COALESCE(@qSetId, QSetId))))
					  ) AS MaxVoteDate
					, QSetDescription as [Description]
					, DisplayMode
					, HasRemark
					, IsDefault
					--, QSetStatus
					--, SortOrder
					, Enabled 
					--, @iCase as [Case]
				 FROM QSetMLView 
				WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				  AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
				  AND UPPER(LTRIM(RTRIM(QSetId))) = UPPER(LTRIM(RTRIM(@qsetId)))
				  --AND Enabled = 1
			 ORDER BY SortOrder, CustomerId, QSetId
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
