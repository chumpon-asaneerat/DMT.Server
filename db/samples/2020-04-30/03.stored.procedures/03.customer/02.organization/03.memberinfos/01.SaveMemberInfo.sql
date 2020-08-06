SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveMemberInfo.
-- Description:	Save Member Information.
-- [== History ==]
-- <2016-12-14> :
--	- Stored Procedure Created.
-- <2017-01-09> :
--	- Add Field TagId, IDCard, EmployeeCode.
-- <2017-06-07> :
--	- Fixed Logic to check duplicated all Prefix - FirstName - LastName.
--	- Fixed Logic to check duplicated UserName.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2017-06-12> :
--  - Add logic to checks IDCard, EmployeeCode and TagID.
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveMemberInfo N'EDL-C2017060005', N'', N'Administrator', N'', N'admin@softbase2.co.th', N'1234', 200
--exec SaveMemberInfo N'EDL-C2017060005', N'Mr.', N'Chumpon', N'Asaneerat', N'chumpon@softbase2.co.th', N'1234', 210
--exec SaveMemberInfo N'EDL-C2017060005', N'Mr.', N'Thana', N'Phorchan', N'thana@softbase2.co.th', N'1234', 280
-- =============================================
CREATE PROCEDURE [dbo].[SaveMemberInfo] (
  @customerId as nvarchar(30)
, @prefix as nvarchar(10) = null
, @firstName as nvarchar(40)
, @lastName as nvarchar(50) = null
, @userName as nvarchar(50)
, @passWord as nvarchar(20)
, @memberType as int = 280 /* Staff */
, @tagId as nvarchar(30) = null
, @idCard as nvarchar(30) = null
, @employeeCode as nvarchar(30) = null
, @memberId as nvarchar(30) = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iMemCnt int = 0;
DECLARE @iCnt int = 0;
	-- Error Code:
	--    0 : Success
	-- 1101 : Customer Id cannot be null or empty string.
	-- 1102 : Customer Id not found.
	-- 1103 : First Name (default) cannot be null or empty string.
	-- 1104 : User Name cannot be null or empty string.
	-- 1105 : Password cannot be null or empty string.
	-- 1106 : MemberType cannot be null.
	-- 1107 : MemberType allow only value 200 admin, 210 exclusive, 280 staff, 290 Device.
	-- 1108 : Member Full Name (default) already exists.
	-- 1109 : User Name already exists.
	-- 1110 : Member Id is not found.
	-- 1111 : IDCard is already exists.
	-- 1111 : Employee Code is already exists.
	-- 1113 : TagId is already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1101, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)));
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1102, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@firstName) = 1)
		BEGIN
			-- First Name (default) cannot be null or empty string.
            EXEC GetErrorMsg 1103, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@userName) = 1)
		BEGIN
			-- User Name cannot be null or empty string.
            EXEC GetErrorMsg 1104, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@passWord) = 1)
		BEGIN
			-- Password cannot be null or empty string.
            EXEC GetErrorMsg 1105, @errNum out, @errMsg out
			RETURN
		END

		IF (@memberType IS NULL)
		BEGIN
			-- MemberType cannot be null.
            EXEC GetErrorMsg 1106, @errNum out, @errMsg out
			RETURN
		END

		IF (@memberType <> 200 AND @memberType <> 210 AND @memberType <> 280 AND @memberType <> 290)
		BEGIN
			-- MemberType allow only value 200 admin, 210 exclusive, 280 staff, 290 Device.
            EXEC GetErrorMsg 1107, @errNum out, @errMsg out
			RETURN
		END

		/* Check Prefix, FirstName, LastName exists */
		IF (@memberId IS NOT NULL)
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(MemberId) <> LOWER(RTRIM(LTRIM(@memberId)))
			   AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
			   AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
			   AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))
		END
		ELSE
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(RTRIM(LTRIM(Prefix))) = LOWER(RTRIM(LTRIM(@prefix)))
			   AND LOWER(RTRIM(LTRIM(FirstName))) = LOWER(RTRIM(LTRIM(@firstName)))
			   AND LOWER(RTRIM(LTRIM(LastName))) = LOWER(RTRIM(LTRIM(@lastName)))
		END

		IF @iMemCnt <> 0
		BEGIN
			-- Member Full Name (default) already exists.
            EXEC GetErrorMsg 1108, @errNum out, @errMsg out
			RETURN;
		END

		SET @iMemCnt = 0; -- Reset Counter.

		/* Check UserName exists */
		IF (@memberId IS NOT NULL)
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(MemberId) <> LOWER(RTRIM(LTRIM(@memberId)))
			   AND LOWER(RTRIM(LTRIM(UserName))) = LOWER(RTRIM(LTRIM(@userName)))
		END
		ELSE
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(RTRIM(LTRIM(UserName))) = LOWER(RTRIM(LTRIM(@userName)))
		END

		IF @iMemCnt <> 0
		BEGIN
			-- User Name already exists.
            EXEC GetErrorMsg 1109, @errNum out, @errMsg out
			RETURN;
		END

		IF (@memberId IS NOT NULL)
		BEGIN
			-- Checks is MemberId is valid.
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
			   AND LOWER(RTRIM(LTRIM(MemberId))) = LOWER(RTRIM(LTRIM(@memberId)))
			IF (@iMemCnt = 0)
			BEGIN
				--- Member Id is not found.
                EXEC GetErrorMsg 1110, @errNum out, @errMsg out
				RETURN;
			END
			-- Check IDCard, EmployeeCode, TagId
			IF (@idCard IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
					FROM MemberInfo
					WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
					  AND LOWER(RTRIM(LTRIM(IDCard))) = LOWER(RTRIM(LTRIM(@idCard)))
					  AND LOWER(RTRIM(LTRIM(MemberId))) <> LOWER(RTRIM(LTRIM(@memberId)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- IDCard is already exists.
                    EXEC GetErrorMsg 1111, @errNum out, @errMsg out
					RETURN;
				END
			END
			IF (@employeeCode IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
					FROM MemberInfo
					WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
					  AND LOWER(RTRIM(LTRIM(EmployeeCode))) = LOWER(RTRIM(LTRIM(@employeeCode)))
					  AND LOWER(RTRIM(LTRIM(MemberId))) <> LOWER(RTRIM(LTRIM(@memberId)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- Employee Code is already exists.
                    EXEC GetErrorMsg 1112, @errNum out, @errMsg out
					RETURN;
				END
			END
			IF (@tagId IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
					FROM MemberInfo
					WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
					  AND LOWER(RTRIM(LTRIM(TagId))) = LOWER(RTRIM(LTRIM(@tagId)))
					  AND LOWER(RTRIM(LTRIM(MemberId))) <> LOWER(RTRIM(LTRIM(@memberId)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- TagId is already exists.
                    EXEC GetErrorMsg 1113, @errNum out, @errMsg out
					RETURN;
				END
			END
		END
		ELSE
		BEGIN
			-- Check IDCard, EmployeeCode, TagId
			IF (@idCard IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
				  FROM MemberInfo
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND LOWER(RTRIM(LTRIM(IDCard))) = LOWER(RTRIM(LTRIM(@idCard)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- IDCard is already exists.
                    EXEC GetErrorMsg 1111, @errNum out, @errMsg out
					RETURN;
				END
			END
			IF (@employeeCode IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
				  FROM MemberInfo
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND LOWER(RTRIM(LTRIM(EmployeeCode))) = LOWER(RTRIM(LTRIM(@employeeCode)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- Employee Code is already exists.
                    EXEC GetErrorMsg 1112, @errNum out, @errMsg out
					RETURN;
				END
			END
			IF (@tagId IS NOT NULL)
			BEGIN
				SELECT @iMemCnt = COUNT(*)
				  FROM MemberInfo
				 WHERE LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
				   AND LOWER(RTRIM(LTRIM(TagId))) = LOWER(RTRIM(LTRIM(@tagId)));
				IF (@iMemCnt <> 0)
				BEGIN
					-- TagId is already exists.
                    EXEC GetErrorMsg 1113, @errNum out, @errMsg out
					RETURN;
				END
			END
		END

		SET @iMemCnt = 0; -- Reset Counter.

		IF dbo.IsNullOrEmpty(@memberId) = 1
		BEGIN
			EXEC NextCustomerPK @customerId
							, N'MemberInfo'
							, @memberId out
							, @errNum out
							, @errMsg out;
			IF @errNum <> 0
			BEGIN
				RETURN;
			END	
		END
		ELSE
		BEGIN
			SELECT @iMemCnt = COUNT(*)
			  FROM MemberInfo
			 WHERE LOWER(MemberId) = LOWER(RTRIM(LTRIM(@memberId)))
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		END

		IF @iMemCnt = 0
		BEGIN
			INSERT INTO MemberInfo
			(
				  MemberId
				, CustomerId
				, TagId
				, IDCard
				, EmployeeCode
				, Prefix
				, FirstName
				, LastName
				, UserName
				, [Password]
				, MemberType
				, ObjectStatus
			)
			VALUES
			(
				  RTRIM(LTRIM(@memberId))
				, RTRIM(LTRIM(@customerId))
				, RTRIM(LTRIM(@tagId))
				, RTRIM(LTRIM(@idCard))
				, RTRIM(LTRIM(@employeeCode))
				, RTRIM(LTRIM(@prefix))
				, RTRIM(LTRIM(@firstName))
				, RTRIM(LTRIM(@lastName))
				, RTRIM(LTRIM(@userName))
				, RTRIM(LTRIM(@passWord))
				, @memberType
				, 1
			);
		END
		ELSE
		BEGIN
			UPDATE MemberInfo
			   SET TagId = RTRIM(LTRIM(@tagId))
			     , IDCard = RTRIM(LTRIM(@idCard))
			     , EmployeeCode = RTRIM(LTRIM(@employeeCode))
			     , Prefix = RTRIM(LTRIM(@prefix))
			     , FirstName = RTRIM(LTRIM(@firstName))
				 , LastName = RTRIM(LTRIM(@lastName))
				 , UserName = RTRIM(LTRIM(@userName))
				 , [Password] = RTRIM(LTRIM(@passWord))
				 , MemberType = @memberType
			 WHERE LOWER(MemberId) = LOWER(RTRIM(LTRIM(@memberId))) 
			   AND LOWER(CustomerId) = LOWER(RTRIM(LTRIM(@customerId))) 
		END
		SET @errNum = 0;
		SET @errMsg = N'success';
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
