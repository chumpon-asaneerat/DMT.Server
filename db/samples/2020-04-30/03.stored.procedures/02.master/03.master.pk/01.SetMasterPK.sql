SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Chumpon Asaneerat
-- Name: NextMasterPK.
-- Description:	SetMasterPK (master)
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
--exec SetMasterPK N'Customer', 1, 'EDL', 5
-- =============================================
CREATE PROCEDURE [dbo].[SetMasterPK] (
  @tableName nvarchar(50)
, @seedResetMode int = 1
, @prefix nvarchar(10)
, @seedDigits tinyint
, @errNum int = 0 out
, @errMsg nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @iTblCnt tinyint;
	-- Error Code:
	--   0 : Success
	-- 201 : Table Name is null or empty string.
	-- 202 : Seed Reset Mode should be number 1-3.
	-- 203 : Seed Digits should be number 1-9.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			EXEC GetErrorMsg 201, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedResetMode is null OR @seedResetMode <= 0 OR @seedResetMode > 3
		BEGIN
			EXEC GetErrorMsg 202, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedDigits is null OR @seedDigits <= 0 OR @seedDigits > 9
		BEGIN
			EXEC GetErrorMsg 203, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM MasterPK
		 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
			INSERT INTO MasterPK(
			        [TableName]
				  , SeedResetMode
				  , LastSeed
				  , [Prefix]
				  , SeedDigits
				  , LastUpdated
				 )
			     VALUES (
				    RTRIM(LTRIM(@tableName))
				  , @seedResetMode
				  , 0
				  , COALESCE(@prefix, N'')
				  , @seedDigits
				  , GETDATE()
				 );
		END
		ELSE
		BEGIN
			UPDATE MasterPK
			   SET [TableName] = RTRIM(LTRIM(@tableName))
			     , SeedResetMode = @seedResetMode
				 , LastSeed = 0
				 , [Prefix] = COALESCE(@prefix, N'')
				 , SeedDigits = @seedDigits
				 , LastUpdated = GETDATE()
			 WHERE LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)));
		END

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
