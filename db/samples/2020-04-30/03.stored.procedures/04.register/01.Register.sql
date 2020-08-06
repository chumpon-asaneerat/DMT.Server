SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Register.
-- Description:	Register (Customer).
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2019-10-01> :
--	- auto add license history.
--
-- [== Example ==]
--
--EXEC Register N'Softbase Co., Ltd.', N'admin@softbase.co.th', N'1234', 0
-- =============================================
CREATE PROCEDURE [dbo].[Register] (
  @customerName as nvarchar(50)
, @userName as nvarchar(50)
, @passWord as nvarchar(20)
, @licenseTypeId int = null
, @customerId as nvarchar(30) = null out
, @memberId as nvarchar(30) = null out
, @branchId as nvarchar(30) = null out
, @orgId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iAdminCnt int = 0;
DECLARE @iBranchCnt int = 0;
DECLARE @iOrgCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1801 : CustomerName cannot be null or empty string.
	-- 1802 : UserName and Password cannot be null or empty string.
	-- 1803 : LicenseTypeId cannot be null.
	-- 1804 : LicenseTypeId not exits.
	-- 1805 : 
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			EXEC GetErrorMsg 1801, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@customerName) = 1)
		BEGIN
			EXEC GetErrorMsg 1802, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@licenseTypeId) = 1)
		BEGIN
			EXEC GetErrorMsg 1803, @errNum out, @errMsg out
			RETURN
		END
		SELECT @iCnt = COUNT(LicenseTypeId) 
		  FROM LicenseType 
		 WHERE LicenseTypeId = @licenseTypeId
		IF (@iCnt = 0)
		BEGIN
            -- Cannot found License Type Id.
            EXEC GetErrorMsg 1804, @errNum out, @errMsg out
			RETURN
		END

		/* Save the customer */
		exec SaveCustomer @customerName 
						, null /* taxcode */
						, null /* address1 */
						, null /* address2 */
						, null /* city */
						, null /* province */
						, null /* postalcode */
						, null /* phone */
						, null /* mobile */
						, null /* fax */
						, null /* email */
						, @customerId out
						, @errNum out
						, @errMsg out

		IF (@errNum <> 0 OR dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			RETURN;
		END

		-- Auto add license history.
		EXEC SaveLicenseHistory @customerId, @licenseTypeId;

		/* MEMBER INFO */
		SELECT @iAdminCnt = COUNT(*)
		  FROM MemberInfo
  		 WHERE LOWER(MemberId) = LOWER(RTRIM(LTRIM(@memberId)))
		   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND MemberType = 200; /* customer's admin */

		IF @iAdminCnt = 0
		BEGIN
			/* Save the admin member */
			exec SaveMemberInfo @customerId
							  , null /* prefix */
							  , N'admin' /* firstname */
							  , null /* lastname */
							  , @userName /* username */
							  , @passWord /* password */
							  , 200 /* membertype */
							  , null /* tagid */
							  , null /* idcard */
							  , null /* employeecode */
							  , @memberId out
							  , @errNum out
							  , @errMsg out;
		END

		IF (@errNum <> 0 OR dbo.IsNullOrEmpty(@memberId) = 1)
		BEGIN
			RETURN;
		END

		/* BRANCH */
		SELECT @iBranchCnt = COUNT(*)
		  FROM Branch
		 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))

		IF @iBranchCnt = 0
		BEGIN
			exec SaveBranch @customerId
			             , N'HQ'
						 , @branchId out
					     , @errNum out
					     , @errMsg out;
		END

		IF (@errNum <> 0 OR dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			RETURN;
		END

		/* ORG */
		SELECT @iOrgCnt = COUNT(*)
		  FROM Org
  		 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND (ParentId IS NULL OR LOWER(RTRIM(LTRIM(ParentId))) = N'');

		IF @iOrgCnt = 0
		BEGIN
			/* Save the root org */
			exec SaveOrg @customerId
			           , null /* ParentId */
					   , @branchId /* BranchId */
					   , @customerName /* OrgName */
					   , @orgId out
					   , @errNum out
					   , @errMsg out;
		END

		IF (@errNum <> 0 OR dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			RETURN;
		END

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
