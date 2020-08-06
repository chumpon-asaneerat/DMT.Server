SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SetCustomerPK.
-- Description:	Set Customer Primary Key.
-- [== History ==]
-- <2017-01-09> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SetCustomerPK N'EDL-C2017010001', N'Branch', 4, 'B', 4
-- =============================================
CREATE PROCEDURE [dbo].[SetCustomerPK] (
  @customerId nvarchar(30)
, @tableName nvarchar(50)
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
	-- 801 : CustomerId is null or empty string.
	-- 802 : Table Name is null or empty string.
	-- 803 : Seed Reset Mode should be number 1-4.
	-- 804 : Seed Digits should be number 1-9.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF @customerId is null OR RTRIM(LTRIM(@customerId)) = N''
		BEGIN
			-- CustomerId is null or empty string.
            EXEC GetErrorMsg 801, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @tableName is null OR RTRIM(LTRIM(@tableName)) = N''
		BEGIN
			-- Table Name is null or empty string.
            EXEC GetErrorMsg 802, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedResetMode is null OR @seedResetMode <= 0 OR @seedResetMode > 4
		BEGIN
			-- Seed Reset Mode should be number 1-4.
            EXEC GetErrorMsg 803, @errNum out, @errMsg out
			RETURN;
		END
		
		IF @seedDigits is null OR @seedDigits <= 0 OR @seedDigits > 9
		BEGIN
			-- Seed Digits should be number 1-9
            EXEC GetErrorMsg 804, @errNum out, @errMsg out
			RETURN;
		END

		SELECT @iTblCnt = COUNT(*)
		  FROM CustomerPK
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)))
		IF @iTblCnt IS NULL OR @iTblCnt = 0
		BEGIN
			INSERT INTO CustomerPK(
					CustomerId
			      , [TableName]
				  , SeedResetMode
				  , LastSeed
				  , [Prefix]
				  , SeedDigits
				  , LastUpdated
				 )
			     VALUES (
				    RTRIM(LTRIM(@customerId))
				  , RTRIM(LTRIM(@tableName))
				  , @seedResetMode
				  , 0
				  , COALESCE(@prefix, N'')
				  , @seedDigits
				  , GETDATE()
				 );
		END
		ELSE
		BEGIN
			UPDATE CustomerPK
			   SET [TableName] = RTRIM(LTRIM(@tableName))
			     , SeedResetMode = @seedResetMode
				 , LastSeed = 0
				 , [Prefix] = COALESCE(@prefix, N'')
				 , SeedDigits = @seedDigits
				 , LastUpdated = GETDATE()
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER([TableName]) = LOWER(RTRIM(LTRIM(@tableName)));
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
