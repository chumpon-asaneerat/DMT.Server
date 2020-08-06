SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveBranch.
-- Description:	Save Branch.
-- [== History ==]
-- <2017-01-09> :
--	- Stored Procedure Created.
-- <2017-06-07> :
--	- Fixed Logic to check duplicated Branch Name.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveBranch N'EDL-C2017010001', N'Softbase'
--exec SaveBranch N'EDL-C2017010001', N'Services', N'B0001'
-- =============================================
CREATE PROCEDURE [dbo].[SaveBranch] (
  @customerId as nvarchar(30)
, @branchName as nvarchar(80)
, @branchId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCustCnt int = 0;
DECLARE @iBranchCnt int = 0;
	-- Error Code:
	--   0 : Success
	-- 1001 : Customer Id cannot be null or empty string.
	-- 1002 : Branch Name (default) cannot be null or empty string.
	-- 1003 : Customer Id is not found.
	-- 1004 : Branch Id is not found.
	-- 1005 : Branch Name (default) already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1001, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@branchName) = 1)
		BEGIN
			-- Branch Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 1002, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCustCnt = COUNT(*)
		  FROM Customer
		 WHERE RTRIM(LTRIM(CustomerId)) = RTRIM(LTRIM(@customerId));
		IF (@iCustCnt = 0)
		BEGIN
			-- Customer Id is not found.
            EXEC GetErrorMsg 1003, @errNum out, @errMsg out
			RETURN
		END

		/* Check Name exists */
		IF (@branchId IS NOT NULL AND LTRIM(RTRIM(@branchId)) <> N'')
		BEGIN
			SELECT @iBranchCnt = COUNT(*)
			  FROM Branch
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(BranchId) = LOWER(RTRIM(LTRIM(@branchId)));
			IF (@iBranchCnt = 0)
			BEGIN
				-- Branch Id is not found.
                EXEC GetErrorMsg 1004, @errNum out, @errMsg out
				RETURN
			END

			SELECT @iBranchCnt = COUNT(*)
				FROM Branch
				WHERE LOWER(BranchName) = LOWER(RTRIM(LTRIM(@branchName)))
				  AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				  AND LOWER(BranchId) <> LOWER(RTRIM(LTRIM(@branchId)))
		END
		ELSE
		BEGIN
			SELECT @iBranchCnt = COUNT(*)
				FROM Branch
				WHERE LOWER(BranchName) = LOWER(RTRIM(LTRIM(@branchName)))
				  AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iBranchCnt <> 0
		BEGIN
			-- Branch Name (default) already exists.
            EXEC GetErrorMsg 1005, @errNum out, @errMsg out
			RETURN;
		END

		SET @iBranchCnt = 0; -- Reset Counter.

		IF dbo.IsNullOrEmpty(@branchId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
			                , N'Branch'
							, @branchId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iBranchCnt = COUNT(*)
			  FROM Branch
			 WHERE LOWER(BranchId) = LOWER(RTRIM(LTRIM(@branchId)))
			   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iBranchCnt = 0
		BEGIN
			INSERT INTO Branch
			(
				  CustomerID
				, BranchID
				, BranchName
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@branchId))
				, RTRIM(LTRIM(@branchName))
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE Branch
			   SET BranchName = RTRIM(LTRIM(@branchName))
			 WHERE LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId))) 
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
