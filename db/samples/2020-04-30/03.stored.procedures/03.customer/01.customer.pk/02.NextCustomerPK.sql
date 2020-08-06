SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NextCustomerPK.
-- Description:	Gets Next Customer Primary Key.
-- [== History ==]
-- <2017-01-09> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
--   
-- [== Example ==]
--
-- <Simple>
--exec NextCustomerPK N'EDL-C2017010001', N'Branch';
--
-- <Complex>
--declare @seedNo as nvarchar(30);
--declare @errNum as int;
--declare @errMsg as nvarchar(max);
--exec NextCustomerPK N'EDL-C2017010001', N'Branch'
--				, @seedNo out
--				, @errNum out
--				, @errMsg out;
--select @seedNo as seedcode
--     , @errNum as ErrNumber
--     , @errMsg as ErrMessage;
--select * from CustomerPK;
-- =============================================
CREATE PROCEDURE [dbo].[NextCustomerPK] 
(
  @customerId as nvarchar(30)
, @tableName as nvarchar(50)
, @seedcode nvarchar(max) = N'' out  -- prefix(max:10) + date(max:10) + seedi(max:10) = 30
, @errNum int = 0 out
, @errMsg nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @lastSeedId int;
DECLARE @resetMode tinyint;
DECLARE @prefix nvarchar(10);
DECLARE @seedDigits tinyint;
DECLARE @lastDate datetime;
DECLARE @now datetime;
DECLARE @isSameDate bit;
DECLARE @iTblCnt tinyint;
	-- Error Code:
	--   0 : Success
	-- 801 : CustomerId is null or empty string.
	-- 802 : Table Name is null or empty string.
	-- 805 : Table name is not exists in CustomerPK table.
	-- 806 : Not supports reset mode.
	-- 807 : Cannot generate seed code for table:
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @customerId is null OR RTRIM(LTRIM(@customerId)) = N''
		BEGIN
			-- CustomerID cannot be null or empty string.
            EXEC GetErrorMsg 801, @errNum out, @errMsg out
			RETURN;
		END

		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			-- Table name cannot be null or empty string.
            EXEC GetErrorMsg 802, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM CustomerPK
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
			-- Table Name not exists in CustomerPK table.
            EXEC GetErrorMsg 805, @errNum out, @errMsg out
			RETURN;
		END

		SET @now = GETDATE();
		-- for testing
		--SET @now = CONVERT(datetime, '2017-12-03 23:55:11:123', 121);
		SELECT @lastSeedId = LastSeed
			 , @resetMode = SeedResetMode
			 , @prefix = [prefix]
			 , @seedDigits = SeedDigits
			 , @lastDate = LastUpdated
			FROM CustomerPK
			WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			  AND LOWER([TableName]) = LOWER(@tableName)
		-- for testing
		--SELECT @lastDate = CONVERT(datetime, '2016-11-03 23:55:11:123', 121);

		IF @lastSeedId IS NOT NULL OR @lastSeedId >= 0
		BEGIN
			-- format code
			SET @seedcode = @prefix;

			IF @resetMode = 1
			BEGIN
				SELECT @isSameDate = dbo.IsSameDate(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- daily
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(mm, @now)), 2) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(dd, @now)), 2) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 2
			BEGIN
				SELECT @isSameDate = dbo.IsSameMonth(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- monthly
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT('00' + CONVERT(nvarchar(2), DATEPART(mm, @now)), 2) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 3
			BEGIN
				SELECT @isSameDate = dbo.IsSameYear(@now, @lastDate)
				IF (@isSameDate = 0)
					SET @lastSeedId = 1;
				ELSE SET @lastSeedId = @lastSeedId + 1;
				-- yearly
				SET @seedcode = @seedcode + 
					CONVERT(nvarchar(4), DATEPART(yyyy, @now)) +
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE IF @resetMode = 4
			BEGIN
				SET @lastSeedId = @lastSeedId + 1;
				-- ignore date
				SET @seedcode = @seedcode + 
					RIGHT(REPLICATE('0', @seedDigits) + RTRIM(CONVERT(nvarchar, @lastSeedId)), @seedDigits);
			END
			ELSE
			BEGIN
				-- not supports
				-- Not supports reset mode.
                EXEC GetErrorMsg 806, @errNum out, @errMsg out
				RETURN;
			END

			IF @seedcode IS NOT NULL OR @seedcode <> N''
			BEGIN
				-- update nexvalue and stamp last updated date.
				UPDATE CustomerPK
					SET LastSeed = @lastSeedId
					  , LastUpdated = @now
					WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
					  AND LOWER([TableName]) = LOWER(@tableName)

                EXEC GetErrorMsg 0, @errNum out, @errMsg out
			END
			ELSE
			BEGIN
				-- Cannot generate seed code for table: 
                EXEC GetErrorMsg 807, @errNum out, @errMsg out
                SET @errMsg = @errMsg + ' ' + @tableName + '.'
			END
		END
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
