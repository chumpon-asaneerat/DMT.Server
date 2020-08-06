SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: Save Org.
-- Description:	Save Organization.
-- [== History ==]
-- <2016-12-14> :
--	- Stored Procedure Created.
-- <2017-01-09> :
--	- Add BranchId.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2017-06-19> :
--  - Add more checks logic.
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
-- [== Complex Example ==]
/*
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @orgId nvarchar(30) = null
exec SaveOrg N'EDL-C2017060005', null, N'B0001', N'Softbase', @orgId out, @errNum out, @errMsg out
SELECT @orgId AS OrgId, @errNum AS ErrNum, @errMsg AS ErrMsg
exec SaveOrg N'EDL-C2017060005', @orgId, N'B0001', N'Services', NULL, @errNum out, @errMsg out 
SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
exec SaveOrg N'EDL-C2017060005', @orgId, N'B0001', N'Supports', NULL, @errNum out, @errMsg out 
SELECT @errNum AS ErrNum, @errMsg AS ErrMsg
SET @orgId = NULL
*/
-- =============================================
CREATE PROCEDURE [dbo].[SaveOrg] (
  @customerId as nvarchar(30)
, @parentId as nvarchar(30) = null
, @branchId as nvarchar(30) = null
, @orgName as nvarchar(80)
, @orgId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int = 0;
DECLARE @iOrgCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1201 : Customer Id cannot be null or empty string.
	-- 1202 : Customer Id not found.
	-- 1203 : Branch Id cannot be null or empty string.
	-- 1204 : Branch Id not found.
	-- 1205 : The Root Org already assigned.
	-- 1206 : The Parent Org Id is not found.
	-- 1207 : Org Name (default) cannot be null or empty string.
	-- 1208 : Org Name (default) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1201, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1202, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			-- Branch Id cannot be null or empty string.
            EXEC GetErrorMsg 1203, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Branch
		 WHERE LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Branch Id not found.
            EXEC GetErrorMsg 1204, @errNum out, @errMsg out
			RETURN
		END

		IF (@parentId IS NULL OR LOWER(RTRIM(LTRIM(@parentId))) = N'')
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND (ParentId IS NULL OR LOWER(RTRIM(LTRIM(ParentId))) = N'');
			IF (@iOrgCnt > 0 and @parentId is null and @orgId is null)
			BEGIN
				-- The Root Org already assigned.
                EXEC GetErrorMsg 1205, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(RTRIM(LTRIM(OrgId))) = LOWER(RTRIM(LTRIM(@parentId)))
			IF (@iCnt = 0)
			BEGIN
				-- The Parent Org Id is not found.
                EXEC GetErrorMsg 1206, @errNum out, @errMsg out
				RETURN
			END
		END

		IF (dbo.IsNullOrEmpty(@orgName) = 1)
		BEGIN
			-- Org Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 1207, @errNum out, @errMsg out
			RETURN
		END

		IF (@orgId IS NULL)
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
			   AND LOWER(LTRIM(RTRIM(OrgName))) = LOWER(LTRIM(RTRIM(@orgName)))
			IF (@iOrgCnt <> 0)
			BEGIN
				-- Org Name (default) already exists.
                EXEC GetErrorMsg 1208, @errNum out, @errMsg out
				RETURN
			END
		END
		ELSE
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
			   AND LOWER(LTRIM(RTRIM(OrgId))) <> LOWER(LTRIM(RTRIM(@orgId)))
			   AND LOWER(LTRIM(RTRIM(OrgName))) = LOWER(LTRIM(RTRIM(@orgName)))
			IF (@iOrgCnt <> 0)
			BEGIN
				-- Org Name (default) already exists.
                EXEC GetErrorMsg 1208, @errNum out, @errMsg out
				RETURN
			END
		END

		/* RESET COUNTER*/
		SET @iOrgCnt = 0;

		IF dbo.IsNullOrEmpty(@orgId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
							, N'Org'
							, @orgId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iOrgCnt = COUNT(*)
			  FROM Org
			 WHERE LOWER(OrgId) = LOWER(RTRIM(LTRIM(@orgId)))
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iOrgCnt = 0
		BEGIN
			INSERT INTO Org
			(
				  CustomerId
				, OrgID
				, BranchId
				, ParentId
				, OrgName
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@orgId))
				, RTRIM(LTRIM(@branchId))
				, RTRIM(LTRIM(@parentId))
				, RTRIM(LTRIM(@orgName))
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE Org
			   SET ParentID = RTRIM(LTRIM(@parentId))
			     , BranchId = RTRIM(LTRIM(@branchId))
			     , OrgName = RTRIM(LTRIM(@orgName))
			 WHERE LOWER(OrgId) = LOWER(RTRIM(LTRIM(@orgId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
