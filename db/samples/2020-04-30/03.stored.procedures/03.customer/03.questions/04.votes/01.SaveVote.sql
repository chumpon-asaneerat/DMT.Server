SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: SaveVote.
-- Description:	Save Vote.
-- [== History ==]
-- <2018-01-30> :
--	- Stored Procedure Created.
-- <2018-05-10> :
--	- remove branchId from parameter.
-- <2018-05-22> :
--	- deviceId parameter change size from nvarchar(50) to nvarchar(30).
--
-- [== Example ==]
--
-- [== Complex Example ==]
/*
DECLARE @errNum int;
DECLARE @errMsg nvarchar(MAX);
DECLARE @customerId nvarchar(30);
DECLARE @orgId nvarchar(30);
DECLARE @deviceId nvarchar(30);
DECLARE @qSetId nvarchar(30);
DECLARE @qSeq int;
DECLARE @userId nvarchar(30);
DECLARE @voteSeq int = null
DECLARE @voteDate datetime;
DECLARE @voteValue int;
DECLARE @remark nvarchar(100)

SET @customerId = N'EDL-C2017060005';
SET @orgId = N'O0001';
SET @deviceId = N'4dff3f4640374939a856d892bc57bf1c';
SET @qSetId = 'QS2018010001';
SET @userId = NULL;
SET @voteDate = GETDATE();
SET @remark = NULL;

SET @qSeq = 1;
SET @voteValue = 1;
exec SaveVote @customerId, @orgId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg

SET @qSeq = 1;
SET @voteValue = 2;
exec SaveVote @customerId, @orgId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out 
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg

SET @qSeq = 1;
SET @voteValue = 2;
exec SaveVote @customerId, @orgId
            , @deviceId
			, @qSetId, @qSeq
			, @userId
			, @voteDate, @voteValue, @remark
            , @voteSeq out, @errNum out, @errMsg out 
SELECT @voteSeq as VoteSeq, @errNum AS ErrNum, @errMsg AS ErrMsg
*/
-- =============================================
CREATE PROCEDURE [dbo].[SaveVote] (
  @customerId as nvarchar(30)
, @orgId as nvarchar(30) = null
, @deviceId as nvarchar(30) = null
, @qSetId as nvarchar(30) = null
, @qSeq as int = 0
, @userId as nvarchar(30) = null
, @voteDate as datetime = null
, @voteValue as int = 0
, @remark as nvarchar(100) = null
, @voteSeq as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @branchId nvarchar(30);
DECLARE @iCnt int = 0;
DECLARE @iVoteSeq int = 0;
	-- Error Code:
	--    0 : Success
	-- 1701 : Customer Id cannot be null or empty string.
	-- 1702 : Customer Id not found.
	-- 1703 : Branch Id cannot be null or empty string.
	-- 1704 : Branch Id not found.
	-- 1705 : Org Id cannot be null or empty string.
	-- 1706 : Org Id not found.
	-- 1707 : QSet Id cannot be null or empty string.
	-- 1708 : QSet Id not found.
	-- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 1701, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Customer
		 WHERE LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Customer Id not found.
            EXEC GetErrorMsg 1702, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- Org Id cannot be null or empty string.
            EXEC GetErrorMsg 1705, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Org
		 WHERE LOWER(OrgID) = LOWER(RTRIM(LTRIM(@orgId)))
           --AND LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Org Id not found.
            EXEC GetErrorMsg 1706, @errNum out, @errMsg out
			RETURN
		END

		-- Find Branch Id from customerid and orgid.
		SELECT @branchId = BranchId
		  FROM Org
		 WHERE OrgID = @orgId
		   AND CustomerId = @customerId;

		-- NOTE: No Need to Check Branch Id.
		/*
		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			-- Branch Id cannot be null or empty string.
            EXEC GetErrorMsg 1703, @errNum out, @errMsg out
			RETURN
		END

		SELECT @iCnt = COUNT(*)
		  FROM Branch
		 WHERE LOWER(BranchID) = LOWER(RTRIM(LTRIM(@branchId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- Branch Id not found.
            EXEC GetErrorMsg 1704, @errNum out, @errMsg out
			RETURN
		END
		*/

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSet Id cannot be null or empty string.
            EXEC GetErrorMsg 1707, @errNum out, @errMsg out
			RETURN
		END

		-- NOTE: Temporary disable check QSet code.
		/*
		SELECT @iCnt = COUNT(*)
		  FROM QSet
		 WHERE LOWER(QSetID) = LOWER(RTRIM(LTRIM(@qSetId)))
		   AND LOWER(CustomerID) = LOWER(RTRIM(LTRIM(@customerId)))
		IF (@iCnt = 0)
		BEGIN
			-- QSet Id not found.
            EXEC GetErrorMsg 1708, @errNum out, @errMsg out
			RETURN
		END
		*/

		/* RESET COUNTER*/
		SET @iVoteSeq = 0;
		SELECT @iVoteSeq = MAX(VoteSeq)
		  FROM Vote
		 WHERE CustomerId = LOWER(RTRIM(LTRIM(@customerId)))
		   AND OrgId = LOWER(RTRIM(LTRIM(@orgId)))
		   AND BranchId = LOWER(RTRIM(LTRIM(@branchId)))
		   AND DeviceId = LOWER(RTRIM(LTRIM(@deviceId)))
		   AND QSetId = LOWER(RTRIM(LTRIM(@qSetId)))
		   AND QSeq = LOWER(RTRIM(LTRIM(@qSeq)))

		IF (@iVoteSeq IS NULL OR @iVoteSeq <= 0)
		BEGIN
			SET @voteSeq = 1;
		END
		ELSE
		BEGIN
			SET @voteSeq = @iVoteSeq + 1;
		END

		INSERT INTO Vote
		(
			  CustomerId
			, OrgId
			, BranchId
			, DeviceId
			, QSetId
			, QSeq
			, VoteSeq
			, UserId
			, VoteDate
			, VoteValue
			, Remark
			, ObjectStatus
		)
		VALUES
		(
			  RTRIM(LTRIM(@customerId))
			, RTRIM(LTRIM(@orgId))
			, RTRIM(LTRIM(@branchId))
			, RTRIM(LTRIM(@deviceId))
			, RTRIM(LTRIM(@qSetId))
			, @qSeq
			, @voteSeq
			, RTRIM(LTRIM(@userId))
			, @voteDate
			, @voteValue
			, RTRIM(LTRIM(@remark))
			, 1
		);

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
