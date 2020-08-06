SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveCustomerML.
-- Description:	Save Customer ML.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--	- Fixed Logic to checks duplicated name.
--	- Fixed Logic to checks mismatch langId.
--	- Add code to used exists data if null is set (TaxCode, Address1, Address2, etc.).
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
/*
-- Complex Example.
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @customerId nvarchar(30)
-- [AddNew]
exec SaveCustomerML --CustomerId
				    @customerId
				    --LangId
                  , N'TH'
				    --Company Name
                  , N'บริษัท ซอฟต์เบส จำกัด'
				    --Tax Code
                  , N'123-908-098-098'
				    --Address 1
				  , N'30 ซอยเจริญนคร 51 ถ.เจริญนคร'
				    --Address 2
				  , N'แขวงบางลำภูล่าง'
				    --City
				  , N'เขตคลองสาน'
				    --Province
				  , N'ก.ท.ม.'
				    --PostalCode
				  , N'10600'
				    -- Err Number
				  , @errNum out
				    -- Err Message
				  , @errMsg out

SELECT * FROM CustomerML
SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
*/
-- =============================================
CREATE PROCEDURE [dbo].[SaveCustomerML] (
  @customerId as nvarchar(30) = null
, @langId as nvarchar(3)
, @customerName as nvarchar(50)
, @taxCode as nvarchar(30) = null
, @address1 as nvarchar(80) = null
, @address2 as nvarchar(80) = null
, @city as nvarchar(50) = null
, @province as nvarchar(50) = null
, @postalcode as nvarchar(8) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iCustCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 904 : Customer Id cannot be null or empty string.
	-- 905 : Lang Id cannot be null or empty string.
	-- 906 : Lang Id not found.
	-- 907 : Customer Name (ML) cannot be null or empty string.
	-- 908 : Customer Name (ML) is already exist.

	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 904, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 905, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iLangCnt = COUNT(*)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangID))) = UPPER(RTRIM(LTRIM(@langId)));

		IF (@iLangCnt IS NULL OR @iLangCnt = 0)
		BEGIN
			-- Lang Id not found.
            EXEC GetErrorMsg 906, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			-- Customer Name (ML) cannot be null or empty string.
            EXEC GetErrorMsg 907, @errNum out, @errMsg out
			RETURN
		END

		/* Check Duplicate Name in same language. */ 
		SELECT @iCustCnt = COUNT(*)
		  FROM CustomerML
		 WHERE UPPER(RTRIM(LTRIM(LangID))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(CustomerName))) = UPPER(RTRIM(LTRIM(@customerName)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) <> UPPER(RTRIM(LTRIM(@customerId)))

		IF @iCustCnt > 0
		BEGIN
			-- The Customer Name (ML) is already exist.
            EXEC GetErrorMsg 908, @errNum out, @errMsg out
			RETURN
		END

		SET @iCustCnt = 0; -- Reset

		/* check is need to insert or update? */
		SELECT @iCustCnt = COUNT(*)
		  FROM CustomerML
		 WHERE UPPER(RTRIM(LTRIM(LangID))) = UPPER(RTRIM(LTRIM(@langId)))
		   AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)));

		IF @iCustCnt = 0
		BEGIN
			INSERT INTO CustomerML
			(
				  CustomerID
				, LangId
				, CustomerName
				, TaxCode
				, Address1
				, Address2
				, City
				, Province
				, PostalCode
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@langId))
				, RTRIM(LTRIM(@customerName))
				, RTRIM(LTRIM(@taxCode))
				, RTRIM(LTRIM(@address1))
				, RTRIM(LTRIM(@address2))
				, RTRIM(LTRIM(@city))
				, RTRIM(LTRIM(@province))
				, RTRIM(LTRIM(@postalcode))
			);
		END
		ELSE
		BEGIN
			UPDATE CustomerML
			   SET CustomerName = RTRIM(LTRIM(@customerName))
				 , TaxCode = RTRIM(LTRIM(COALESCE(@taxCode, TaxCode)))
				 , Address1 = RTRIM(LTRIM(COALESCE(@address1, Address1)))
				 , Address2 = RTRIM(LTRIM(COALESCE(@address2, Address2)))
				 , City = RTRIM(LTRIM(COALESCE(@city, City)))
				 , Province = RTRIM(LTRIM(COALESCE(@province, Province)))
				 , Postalcode = RTRIM(LTRIM(COALESCE(@postalcode, Postalcode)))
			 WHERE UPPER(RTRIM(LTRIM(LangID))) = UPPER(RTRIM(LTRIM(@langId)))
			   AND UPPER(RTRIM(LTRIM(CustomerID))) = UPPER(RTRIM(LTRIM(@customerId)))
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
