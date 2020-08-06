SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveCustomer.
-- Description:	Save Customer Information.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Fixed logic to check duplicate Customer Name.
-- <2017-06-08> :
--	- Add code to used exists data if null is set (TaxCode, Address1, Address2, etc.).
-- <2018-04-16> :
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
exec SaveCustomer --Company Name
                  N'Softbase Co., Ltd.'
				  --Tax Code
                , N'123-908-098-098'
				  --Address 1
				, N'222 first road my address 1'
				  --Address 2
				, N'address 2'
				  --City
				, N'banglumpoolang'
				  --Province
				, N'bangkok'
				  --PostalCode
				, N'10600'
				  --Phone
				, N'02-888-8822, 02-888-8888'
				  --Mobile
				, N'081-666-6666'
				  --Fax
				, N'02-899-9888'
				  --Email
				, N'chumponsenate@yahoo.com'
				  --CustomerId
				, @customerId out
				  -- Err Number
				, @errNum out
				  -- Err Message
				, @errMsg out
SELECT * FROM Customer
SELECT @customerId AS CustomerId, @errNum AS ErrNum, @errMsg AS ErrMsg
-- [Update]
exec SaveCustomer 
                  --Company Name
                  N'Softbase2 Co., Ltd.'
				  --Tax Code
                , N'123-908-098-098'
				  --Address 1
				, N'222 first road'
				  --Address 2
				, N'address 2'
				  --City
				, N'banglumpoolang'
				  --Province
				, N'bangkok'
				  --PostalCode
				, N'10600'
				  --Phone
				, N'02-888-8822'
				  --Mobile
				, N''
				  --Fax
				, N''
				  --Email
				, N''
				  --CustomerId
				, @customerId
				  -- Err Number
				, @errNum out
				  -- Err Message
				, @errMsg out
SELECT * FROM Customer
SELECT @customerId AS CustomerId, @errNum AS ErrNum, @errMsg AS ErrMsg
*/
-- =============================================
CREATE PROCEDURE [dbo].[SaveCustomer] (
  @customerName as nvarchar(50)
, @taxCode as nvarchar(30) = null
, @address1 as nvarchar(80) = null
, @address2 as nvarchar(80) = null
, @city as nvarchar(50) = null
, @province as nvarchar(50) = null
, @postalcode as nvarchar(8) = null
, @phone as nvarchar(80) = null
, @mobile as nvarchar(80) = null
, @fax as nvarchar(80) = null
, @email as nvarchar(80) = null
, @customerId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 901 : Customer Name (default) cannot be null or empty string.
	-- 902 : The Customer Id is not exists.
	-- 903 : Customer Name (default) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			-- Customer Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 901, @errNum out, @errMsg out
			RETURN
		END
		/* Check Name exists */
		IF (@customerId IS NOT NULL)
		BEGIN
			/* Check is Customer Id is exists. */
			SELECT @iCustCnt = COUNT(*)
			  FROM Customer
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
			IF (@iCustCnt = 0)
			BEGIN
                -- The Customer Id is not exists.
                EXEC GetErrorMsg 902, @errNum out, @errMsg out
				RETURN;
			END

			SELECT @iCustCnt = COUNT(*)
				FROM Customer
				WHERE LOWER(CustomerName) = LOWER(RTRIM(LTRIM(@customerName)))
				  AND LOWER(CustomerId) <> LOWER(RTRIM(LTRIM(@customerId)))
		END
		ELSE
		BEGIN
			SELECT @iCustCnt = COUNT(*)
				FROM Customer
				WHERE LOWER(CustomerName) = LOWER(RTRIM(LTRIM(@customerName)))
		END

		IF @iCustCnt <> 0
		BEGIN
			-- Customer Name (default) already exists.
            EXEC GetErrorMsg 903, @errNum out, @errMsg out
			RETURN;
		END
		/* Reset Counter */
		SET @iCustCnt = 0;

		IF dbo.IsNullOrEmpty(@customerId) = 1
		BEGIN
			EXEC NextMasterPK N'Customer'
							, @customerId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iCustCnt = COUNT(*)
			  FROM Customer
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iCustCnt = 0
		BEGIN
			INSERT INTO Customer
			(
				  CustomerID
				, CustomerName
				, TaxCode
				, Address1
				, Address2
				, City
				, Province
				, PostalCode
				, Phone
				, Mobile
				, Fax
				, Email
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@customerName))
				, RTRIM(LTRIM(@taxCode))
				, RTRIM(LTRIM(@address1))
				, RTRIM(LTRIM(@address2))
				, RTRIM(LTRIM(@city))
				, RTRIM(LTRIM(@province))
				, RTRIM(LTRIM(@postalcode))
				, RTRIM(LTRIM(@phone))
				, RTRIM(LTRIM(@mobile))
				, RTRIM(LTRIM(@fax))
				, RTRIM(LTRIM(@email))
				, 1
			);
			/* Init Related PK */
			exec SetCustomerPK @customerId, N'Branch', 4, 'B', 4;
			exec SetCustomerPK @customerId, N'MemberInfo', 4, 'M', 5;
			exec SetCustomerPK @customerId, N'Org', 4, 'O', 4;
			exec SetCustomerPK @customerId, N'QSet', 4, 'QS', 5;
			exec SetCustomerPK @customerId, N'Device', 4, 'D', 4;
		END
		ELSE
		BEGIN
			UPDATE Customer
			   SET CustomerName = RTRIM(LTRIM(@customerName)) /* Cannot be null. */
				 , TaxCode = RTRIM(LTRIM(COALESCE(@taxCode, TaxCode)))
				 , Address1 = RTRIM(LTRIM(COALESCE(@address1, Address1)))
				 , Address2 = RTRIM(LTRIM(COALESCE(@address2, Address2)))
				 , City = RTRIM(LTRIM(COALESCE(@city, City)))
				 , Province = RTRIM(LTRIM(COALESCE(@province, Province)))
				 , Postalcode = RTRIM(LTRIM(COALESCE(@postalcode, Postalcode)))
				 , Phone = RTRIM(LTRIM(COALESCE(@phone, Phone)))
				 , Mobile = RTRIM(LTRIM(COALESCE(@mobile, Mobile)))
				 , Fax = RTRIM(LTRIM(COALESCE(@fax, Fax)))
				 , Email = RTRIM(LTRIM(COALESCE(@email, Email)))
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
