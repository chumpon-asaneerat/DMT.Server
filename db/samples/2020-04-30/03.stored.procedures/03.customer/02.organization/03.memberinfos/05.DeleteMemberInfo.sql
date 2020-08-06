SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Delete MemberInfo
-- [== History ==]
-- <2019-12-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DeleteMemberInfo N'EDL-C2019100001', N'M00001'
-- =============================================
CREATE PROCEDURE [dbo].[DeleteMemberInfo]
(
  @customerId nvarchar(30)
, @memberId nvarchar(30)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
    -- Error Code:
    --   0 : Success
	-- 4001: Customer Id cannot be null or empty string.
	-- 4002: Member Id cannot be null or empty string.
	-- 4003: Cannot be remove default admin.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 4001, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@memberId) = 1)
		BEGIN
			-- Member Id cannot be null or empty string.
            EXEC GetErrorMsg 4002, @errNum out, @errMsg out
			RETURN
		END

		IF (LTRIM(RTRIM(LOWER(@memberId))) = LOWER(N'M00001'))
		BEGIN
			-- Cannot be remove default admin member.
            EXEC GetErrorMsg 4003, @errNum out, @errMsg out
			RETURN
		END

		DELETE FROM ClientAccess 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(MemberId))) = LTRIM(RTRIM(LOWER(@memberId)));

		DELETE FROM Vote 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(UserId))) = LTRIM(RTRIM(LOWER(@memberId)));

		DELETE FROM MemberInfoML 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId)))
		   AND LTRIM(RTRIM(LOWER(MemberId))) = LTRIM(RTRIM(LOWER(@memberId)));

		DELETE FROM MemberInfo 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		   AND LTRIM(RTRIM(LOWER(MemberId))) = LTRIM(RTRIM(LOWER(@memberId)));

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
