SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveLicenseFeature.
-- Description:	Save License Feature.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2017-06-08> :
--  - The @errMsg set as nvarchar(MAX).
-- <2018-04-16> :
--	- change error code(s).
--
-- [== Example ==]
--declare seq int;
--exec SaveLicenseFeature 5, 1, 2, @seq out -- Save Feature Limit device with 2 device(s).
--select * from seq as Seq;
-- =============================================
CREATE PROCEDURE [dbo].[SaveLicenseFeature] (
  @licenseTypeId as int = null
, @limitUnitId as int = null
, @noOfLimit as int = null
, @seq as int = null out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @iCnt int;
DECLARE @iSeq int;
	-- Error Code:
	--   0 : Success
	-- 701 : LicenseType Id cannot be null.
	-- 702 : LicenseType Id not found.
	-- 703 : LimitUnit Id cannot be null.
	-- 704 : LimitUnit Id not found.
	-- 705 : LimitUnit Id already exists.
	-- 706 : No Of Limit cannot be null.
	-- 707 : No Of Limit should be zero or more.
	-- 708 : Invalid Seq Number.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (@licenseTypeId IS NULL)
		BEGIN
			-- LicenseType Id cannot be null.
            EXEC GetErrorMsg 701, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LicenseType
		 WHERE LicenseTypeId = @licenseTypeId;
		IF (@iCnt = 0)
		BEGIN
			--LicenseType Id not found.
            EXEC GetErrorMsg 702, @errNum out, @errMsg out
			RETURN
		END

		IF (@limitUnitId IS NULL)
		BEGIN
			-- LimitUnit Id cannot be null.
            EXEC GetErrorMsg 703, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM LimitUnit
		 WHERE LimitUnitId = @limitUnitId;
		IF (@iCnt = 0)
		BEGIN
			-- LimitUnit Id not found.
            EXEC GetErrorMsg 704, @errNum out, @errMsg out
			RETURN
		END

		IF (@seq IS NULL)
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND LimitUnitId = @limitUnitId;
		END
		ELSE
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND LimitUnitId = @limitUnitId
			   AND Seq <> @seq;
		END

		IF (@iCnt <> 0)
		BEGIN
			-- LimitUnit Id already exists.
            EXEC GetErrorMsg 705, @errNum out, @errMsg out
			RETURN
		END

		IF (@noOfLimit IS NULL)
		BEGIN
			-- No Of Limit cannot be null.
            EXEC GetErrorMsg 706, @errNum out, @errMsg out
			RETURN
		END

		IF (@noOfLimit < 0)
		BEGIN
			-- No Of Limit should be zero or more.
            EXEC GetErrorMsg 707, @errNum out, @errMsg out
			RETURN
		END

		IF (@seq IS NULL)
		BEGIN
			SELECT @iSeq = MAX(Seq)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId;
			IF (@iSeq IS NULL)
			BEGIN
				SET @iSeq = 1;
			END
			ELSE
			BEGIN
				SET @iSeq = @iSeq + 1;
			END
		END
		ELSE
		BEGIN
			SELECT @iCnt = COUNT(*)
			  FROM LicenseFeature
			 WHERE LicenseTypeId = @licenseTypeId
			   AND Seq = @seq;
			
			IF (@iCnt = 0)
			BEGIN
				-- Invalid Seq Number.
                EXEC GetErrorMsg 708, @errNum out, @errMsg out
				RETURN
			END

			SET @iSeq = @seq;
		END

		IF (@seq IS NULL)
		BEGIN
			INSERT INTO [dbo].[LicenseFeature]
			(
				 LicenseTypeId
			   , Seq
			   , LimitUnitId
			   , NoOfLimit
			)
			VALUES
			(
			     @licenseTypeId
			   , @iSeq
			   , @limitUnitId
			   , @noOfLimit
			);

			-- SET OUTPUT SEQ.
			SET @seq = @iSeq;
		END
		ELSE
		BEGIN
			UPDATE [dbo].[LicenseFeature]
			   SET LimitUnitId = COALESCE(@limitUnitId, LimitUnitId)
				 , NoOfLimit = COALESCE(@noOfLimit, NoOfLimit)
			 WHERE LicenseTypeId = @licenseTypeId
			   AND Seq = @iSeq;
		END

        EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
