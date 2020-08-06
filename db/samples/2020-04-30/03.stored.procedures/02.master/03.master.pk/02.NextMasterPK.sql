SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NextMasterPK.
-- Description:	NextMasterPK (master)
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
-- <2016-11-02> :
--	- Change Size of @prefix from nvarchar(5) to nvarchar(10) due to table MasterPK changed.
--	- Add checks parameter code.
-- <2018-04-16> :
--	- change code(s).
--   
-- [== Example ==]
--
-- <Simple>
--exec NextMasterPK N'Customer';
--
-- <Complex>
--declare @seedNo as nvarchar(30);
--declare @errNum as int;
--declare @errMsg as nvarchar(max);
--exec NextMasterPK N'Customer'
--				, @seedNo out
--				, @errNum out
--				, @errMsg out;
--select @seedNo as seedcode
--     , @errNum as ErrNumber
--     , @errMsg as ErrMessage;
--select * from MasterPK;
-- =============================================
CREATE PROCEDURE [dbo].[NextMasterPK] 
(
  @tableName as nvarchar(50)
, @seedcode nvarchar(MAX) = N'' out  -- prefix(max:10) + date(max:10) + seedi(max:10) = 30
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
	-- 201 : Table name cannot be null or empty string.
	-- 204 : Table name is not exists in MasterPK table.
	-- 205 : Not supports reset mode.
	-- 206 : Cannot generate seed code major cause should be 
	--		 seed reset mode is not supports.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			EXEC GetErrorMsg 201, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM MasterPK
		 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
            EXEC GetErrorMsg 204, @errNum out, @errMsg out
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
			FROM MasterPK
			WHERE LOWER([TableName]) = LOWER(@tableName)
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
			ELSE
			BEGIN
				-- not supports
                EXEC GetErrorMsg 205, @errNum out, @errMsg out
				RETURN;
			END

			IF @seedcode IS NOT NULL OR @seedcode <> N''
			BEGIN
				-- update nexvalue and stamp last updated date.
				UPDATE MasterPK
					SET LastSeed = @lastSeedId
					  , LastUpdated = @now
					WHERE LOWER([TableName]) = LOWER(@tableName)
				
				EXEC GetErrorMsg 0, @errNum out, @errMsg out
			END
			ELSE
			BEGIN
                EXEC GetErrorMsg 206, @errNum out, @errMsg out
                SET @errMsg = ' ' + @errMsg + '.'
			END
		END
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
