SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Delete Vote
-- [== History ==]
-- <2019-12-16> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DeleteVote N'EDL-C2019100003', N'O0008', N'QS00001', 2, 1, N'2019-10-10 16:58:13.650'
-- =============================================
CREATE PROCEDURE [dbo].[DeleteVote]
(
  @customerId nvarchar(30)
, @orgId nvarchar(30)
, @qSetId nvarchar(30)
, @qSeq int
, @voteSeq int
, @voteDate datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
    -- Error Code:
    --   0 : Success
	-- 4351: Customer Id cannot be null or empty string.
	-- 4352: Org Id cannot be null or empty string.
	-- 4353: QSet Id cannot be null or empty string.
	-- 4354: QSeq cannot be null.
	-- 4355: VoteSeq cannot be null.
	-- 4356: Vote Date cannot be null.
    -- OTHER : SQL Error Number & Error Message.
	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			-- Customer Id cannot be null or empty string.
            EXEC GetErrorMsg 4351, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- Org Id cannot be null or empty string.
            EXEC GetErrorMsg 4352, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			-- QSet Id cannot be null or empty string.
            EXEC GetErrorMsg 4353, @errNum out, @errMsg out
			RETURN
		END

		IF (@qSeq IS NULL)
		BEGIN
			-- QSeq cannot be null.
            EXEC GetErrorMsg 4354, @errNum out, @errMsg out
			RETURN
		END

		IF (@voteSeq IS NULL)
		BEGIN
			-- Vote Seq cannot be null.
            EXEC GetErrorMsg 4355, @errNum out, @errMsg out
			RETURN
		END

		IF (@voteDate IS NULL)
		BEGIN
			-- Vote Date cannot be null.
            EXEC GetErrorMsg 4356, @errNum out, @errMsg out
			RETURN
		END

		DELETE FROM Vote 
		 WHERE LTRIM(RTRIM(LOWER(CustomerId))) = LTRIM(RTRIM(LOWER(@customerId))) 
		 AND LTRIM(RTRIM(LOWER(OrgId))) = LTRIM(RTRIM(LOWER(@orgId)))
		   AND LTRIM(RTRIM(LOWER(QSetId))) = LTRIM(RTRIM(LOWER(@qSetId)))
		   AND QSeq = @qSeq
		   AND VoteSeq = @voteSeq
		   AND VoteDate = @voteDate

		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
