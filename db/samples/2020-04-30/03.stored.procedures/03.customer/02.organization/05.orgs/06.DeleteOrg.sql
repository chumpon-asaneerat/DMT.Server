SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Delete Org
-- [== History ==]
-- <2019-12-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DeleteOrg N'EDL-C2019100001', N'B0002'
-- =============================================
CREATE PROCEDURE [dbo].[DeleteOrg]
(
  @customerId nvarchar(30)
, @orgId nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
    -- Error Code:
    --   0 : Success
	-- 4101: Customer Id cannot be null or empty string.
	-- 4102: Org Id cannot be null or empty string.
	-- 4103: Cannot be remove default org.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 4101, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- Org Id cannot be null or empty string.
            EXEC GetErrorMsg 4102, @errNum out, @errMsg out
			RETURN
		END

		IF (LTRIM(RTRIM(LOWER(@orgId))) = LOWER(N'O0001'))
		BEGIN
			-- Cannot be remove default org.
            EXEC GetErrorMsg 4103, @errNum out, @errMsg out
			RETURN
		END

		DELETE FROM Vote 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(OrgId))) = LTRIM(RTRIM(LOWER(@orgId)))

		DELETE FROM OrgML 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
		   AND LTRIM(RTRIM(LOWER(OrgId))) = LTRIM(RTRIM(LOWER(@orgId))) 

		DELETE FROM Org 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(OrgId))) = LTRIM(RTRIM(LOWER(@orgId))) 
		   AND LTRIM(RTRIM(LOWER(OrgId))) <> LTRIM(RTRIM(LOWER('O0001')))

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
