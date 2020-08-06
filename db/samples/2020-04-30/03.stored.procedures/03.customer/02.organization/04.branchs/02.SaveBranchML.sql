SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveBranchML.
-- Description:	SaveBranchML.
-- [== History ==]
-- <2016-11-02> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
--  - Add code to checks not allow conditions for BranchId, BranchName.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
--	- change error code(s).
--
-- [== Example ==]
--
--exec SaveBranchML N'EDL-C2017060005', N'B0001', N'TH', N'สำนักงานใหญ่'
--exec SaveBranchML N'EDL-C2017060005', N'B0001', N'JA', N'ヘッドクォーター'
-- =============================================
CREATE PROCEDURE [dbo].[SaveBranchML] (
  @customerId as nvarchar(30)
, @branchId as nvarchar(30)
, @langId as nvarchar(3)
, @branchName as nvarchar(80)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iLangCnt int = 0;
DECLARE @iBranchCnt int = 0;
	-- Error Code:
	--    0 : Success
    -- 1001 : Customer Id cannot be null or empty string.
	-- 1006 : Lang Id cannot be null or empty string.
	-- 1007 : Language Id not exist.
	-- 1008 : Branch Id cannot be null or empty string.
	-- 1009 : Branch Id is not found.
	-- 1010 : Branch Name (ML) is already exists.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		/* Check if lang id is not null. */
		IF (dbo.IsNullOrEmpty(@langId) = 1)
		BEGIN
			-- Lang Id cannot be null or empty string.
            EXEC GetErrorMsg 1006, @errNum out, @errMsg out
			RETURN
		END
		/* Check if language exists. */
		SELECT @iLangCnt = COUNT(LangId)
		  FROM Language
		 WHERE UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		IF (@iLangCnt IS NULL OR @iLangCnt = 0) 
		BEGIN
			-- Lang Id not exist.
            EXEC GetErrorMsg 1007, @errNum out, @errMsg out
			RETURN
		END

		/* Check if customer id is not null. */
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
            -- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1001, @errNum out, @errMsg out
			RETURN
		END

		/* Check if branch id is not null. */
		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			-- Branch Id cannot be null or empty string.
            EXEC GetErrorMsg 1008, @errNum out, @errMsg out
			RETURN
		END

		/* Check Id is in table */ 
		SELECT @iBranchCnt = COUNT(*)
			FROM Branch
		   WHERE UPPER(RTRIM(LTRIM(BranchId))) = UPPER(RTRIM(LTRIM(@branchId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		IF @iBranchCnt = 0
		BEGIN
			-- Branch Id is not found.
            EXEC GetErrorMsg 1009, @errNum out, @errMsg out
			RETURN
		END

		/* Check Branch Name is already exists. */
		SELECT @iBranchCnt = COUNT(*)
			FROM BranchML
		   WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
		     AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)))
		     AND UPPER(RTRIM(LTRIM(BranchName))) = UPPER(RTRIM(LTRIM(@branchName)))
		     AND UPPER(RTRIM(LTRIM(BranchId))) <> UPPER(RTRIM(LTRIM(@branchId)))
		IF @iBranchCnt <> 0
		BEGIN
			-- Branch Name (ML) is already exists.
            EXEC GetErrorMsg 1010, @errNum out, @errMsg out
			RETURN
		END

		/* check is need to insert or update? */
		SELECT @iBranchCnt = COUNT(*)
			FROM BranchML
		   WHERE UPPER(RTRIM(LTRIM(BranchId))) = UPPER(RTRIM(LTRIM(@branchId)))
		     AND UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			 AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));

		IF @iBranchCnt = 0
		BEGIN
			INSERT INTO BranchML
			(
				  CustomerId
				, BranchId
				, LangId
				, BranchName
			)
			VALUES
			(
				  UPPER(RTRIM(LTRIM(@customerId)))
				, UPPER(RTRIM(LTRIM(@branchId)))
				, UPPER(RTRIM(LTRIM(@langId)))
				, RTRIM(LTRIM(@branchName))
			);
		END
		ELSE
		BEGIN
			UPDATE BranchML
			   SET BranchName = RTRIM(LTRIM(@branchName))
		     WHERE UPPER(RTRIM(LTRIM(CustomerId))) = UPPER(RTRIM(LTRIM(@customerId)))
			   AND UPPER(RTRIM(LTRIM(BranchId))) = UPPER(RTRIM(LTRIM(@branchId)))
			   AND UPPER(RTRIM(LTRIM(LangId))) = UPPER(RTRIM(LTRIM(@langId)));
		END
		
        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
