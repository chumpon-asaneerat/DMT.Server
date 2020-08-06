SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Delete Branch
-- [== History ==]
-- <2019-12-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DeleteBranch N'EDL-C2019100001', N'B0002'
-- =============================================
CREATE PROCEDURE [dbo].[DeleteBranch]
(
  @customerId nvarchar(30)
, @branchId nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
    -- Error Code:
    --   0 : Success
	-- 4051: Customer Id cannot be null or empty string.
	-- 4052: Branch Id cannot be null or empty string.
	-- 4053: Cannot be remove default branch.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 4051, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			-- Branch Id cannot be null or empty string.
            EXEC GetErrorMsg 4052, @errNum out, @errMsg out
			RETURN
		END

		IF (LTRIM(RTRIM(LOWER(@branchId))) = LOWER(N'B0001'))
		BEGIN
			-- Cannot be remove default branch.
            EXEC GetErrorMsg 4053, @errNum out, @errMsg out
			RETURN
		END

		DELETE FROM Vote 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(BranchId))) = LTRIM(RTRIM(LOWER(@branchId)))

		DELETE FROM OrgML 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
		   AND LTRIM(RTRIM(LOWER(OrgId))) 
		    IN (
				 SELECT BranchId 
				   FROM Org 
				  WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
				    AND LTRIM(RTRIM(LOWER(BranchId))) = LTRIM(RTRIM(LOWER(@branchId)))
					AND LTRIM(RTRIM(LOWER(OrgId))) <> LTRIM(RTRIM(LOWER('O0001')))
		       )

		DELETE FROM Org 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(BranchId))) = LTRIM(RTRIM(LOWER(@branchId)))
		   AND LTRIM(RTRIM(LOWER(OrgId))) <> LTRIM(RTRIM(LOWER('O0001')))

		DELETE FROM BranchML 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
		   AND LTRIM(RTRIM(LOWER(BranchId))) 
		    IN (
				 SELECT BranchId 
				   FROM Branch 
				  WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
				    AND LTRIM(RTRIM(LOWER(BranchId))) = LTRIM(RTRIM(LOWER(@branchId)))
		       )

		DELETE FROM Branch 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(BranchId))) = LTRIM(RTRIM(LOWER(@branchId)))

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
