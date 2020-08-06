SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Get Vote Summaries.
-- [== History ==]
-- <2017-04-12> :
--	- Stored Procedure Created.
-- <2018-05-10> :
--	- Changes code supports unlimited choices.
--	- Add Remark count.
--	- Add langId parameter.
-- <2018-05-13> :
--  - Add QSetId, QSeq in result query.
--
-- [== Example ==]
--
--EXEC GetVoteSummaries NULL, N'EDL-C2017050001', N'QS00001', 1, '2017-01-01', '2017-12-31', null, null, null
--EXEC GetVoteSummaries  N'TH', N'EDL-C2017050001', N'QS00001', 1, '2017-01-01', '2017-12-31', N'O0001', null, null
-- =============================================
CREATE PROCEDURE [dbo].[GetVoteSummaries] (
  @langId as nvarchar(3)
, @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @BeginDate As DateTime = null
, @EndDate As DateTime = null
, @orgId as nvarchar(30) = null
, @deviceId as nvarchar(50) = null
, @userId as nvarchar(30) = null
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out)
AS
BEGIN
DECLARE @ShowOutput bit = 0;
DECLARE @branchId nvarchar(30);
	-- Error Code:
	--    0 : Success
	-- 2001 : CustomerId cannot be null or empty string.
	-- 2002 : QSetId cannot be null or empty string.
	-- 2003 : QSeq cannot be null.
	-- 2004 : The default OrgId not found.
	-- 2005 : The BranchId not found.
	-- 2006 : 
	-- OTHER : SQL Error Number & Error Message.

	CREATE TABLE #VOTEDATA
	(
		VoteValue tinyint,
		TotalVote Int,
		TotalXCount int,
		TotalRemark Int
	) 

	CREATE TABLE #VOTESUM
	(
		Choice int,				-- choice value.
		Cnt int,				-- count = current choice count.
		Pct decimal(18, 2),		-- percent = (current choice count * 100 / overall choices count).
		RemarkCnt int,			-- Remark count.
		MaxChoice tinyint,		-- max choice value.
		TotCnt int,				-- Total count -> overall choices count.
		TotCntXChoice int,		-- Total count * choice value. (for internal calc).
		AvgPct decimal(18, 2),	-- Choice Average Percent
		AvgTot decimal(18, 2),	-- Choice Average Total = (TotCntXChoice / TotCnt).
		CustomerId nvarchar(30) COLLATE DATABASE_DEFAULT,
		BranchId nvarchar(30) COLLATE DATABASE_DEFAULT,
		OrgId nvarchar(30) COLLATE DATABASE_DEFAULT,
		UserId nvarchar(30) COLLATE DATABASE_DEFAULT,
		DeviceId nvarchar(50) COLLATE DATABASE_DEFAULT,
		QSetId nvarchar(30) COLLATE DATABASE_DEFAULT,
		QSeq int
	)

	BEGIN TRY
		IF (dbo.IsNullOrEmpty(@customerId) = 1)
		BEGIN
			EXEC GetErrorMsg 2001, @errNum out, @errMsg out
			RETURN
		END
		IF (dbo.IsNullOrEmpty(@qSetId) = 1)
		BEGIN
			EXEC GetErrorMsg 2002, @errNum out, @errMsg out
			RETURN
		END
		IF (@qSeq IS NULL)
		BEGIN
			EXEC GetErrorMsg 2003, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			-- OrgID not exist so find root org id and branch id.
			SELECT @orgId = OrgId
				 , @branchId = BranchId
			  FROM Org
			 WHERE LOWER(LTRIM(RTRIM(CustomerId))) = LOWER(LTRIM(RTRIM(@customerId)))
			   AND (ParentId IS NULL OR LOWER(RTRIM(LTRIM(ParentId))) = N'');
		END
		ELSE
		BEGIN
			-- OrgID exist so find branch id.
			SELECT @branchId = BranchId
			  FROM Org
			 WHERE LOWER(LTRIM(RTRIM(CustomerId))) = LOWER(LTRIM(RTRIM(@customerId)))
			   AND LOWER(LTRIM(RTRIM(OrgId))) = LOWER(LTRIM(RTRIM(@orgId)))
		END
		
		IF (dbo.IsNullOrEmpty(@orgId) = 1)
		BEGIN
			EXEC GetErrorMsg 2004, @errNum out, @errMsg out
			RETURN
		END

		IF (dbo.IsNullOrEmpty(@branchId) = 1)
		BEGIN
			EXEC GetErrorMsg 2005, @errNum out, @errMsg out
			RETURN
		END

		DECLARE @sqlCommand as nvarchar(MAX);

		EXEC __BuildTotalVoteCountQuery @customerId
									  , @qsetId, @qSeq
									  , @beginDate, @endDate
									  , @orgId, @deviceId, @userId
									  , @sqlCommand output

		--SELECT @sqlCommand;
		INSERT INTO #VOTEDATA EXECUTE sp_executesql @sqlCommand -- Insert into temp table

		DECLARE @iChoice tinyint;
		DECLARE @iCnt int;
		DECLARE @maxChoice as tinyint;
		DECLARE @decimalPlaces as int = 2;

		DECLARE @totalCount int;
		DECLARE @totalXCount int;

		SELECT @maxChoice = COUNT(*)
		  FROM QSlideItem
		 WHERE QSetId = @qSetId
		   AND QSeq = @qSeq
		   AND CustomerId = @customerId
		   AND ObjectStatus = 1
		
		--SET @maxChoice = 4; -- Fake max choice.

		SET @iChoice = 1;
		WHILE (@iChoice <= @maxChoice)
		BEGIN
			SELECT @iCnt = COUNT(*) 
			  FROM #VOTEDATA 
			 WHERE VoteValue = @iChoice;
			IF (@iCnt IS NULL OR @iCnt = 0)
			BEGIN
				INSERT INTO #VOTEDATA(
					  VoteValue
					, TotalVote
					, TotalRemark)
				VALUES(
					  @iChoice
					, 0
					, 0);
			END
			SET @iChoice = @iChoice + 1; -- increase.
		END

		SELECT @totalCount = SUM(TotalVote)
		     , @totalXCount = SUM(TotalXCount)
		  FROM #VOTEDATA;

		-- Insert Non calc values.
		INSERT INTO #VOTESUM
		(
			 CustomerID
			,BranchID
			,OrgID
			,UserId
			,DeviceId
			,QSetId
			,QSeq
			,MaxChoice
			,TotCnt
			,TotCntXChoice
			,Choice
			,Cnt
			,RemarkCnt
		)
		SELECT @customerId AS CustomerId
			 , @branchId AS BranchId
			 , @orgId AS OrgId
			 , @userId AS UserId
			 , @deviceId AS DeviceId
			 , @qSetId AS QSetId
			 , @qSeq AS QSeq
			 , @maxChoice AS MaxChoice
			 , @totalCount AS TotCnt
			 , @totalXCount AS TotCntXChoice
			 , VoteValue AS Choice
			 , TotalVote AS Cnt
			 , TotalRemark AS RemarkCnt
		  FROM #VOTEDATA;

		-- Update Calc Percent value, Total avarage.
		UPDATE #VOTESUM
		   SET Pct = vd.Pct
		     , AvgTot = vd.AvgTot
			 , AvgPct = vd.AvgPct
		  FROM (
			SELECT t1.Choice
			     , t2.Pct
				 , t2.AvgTot
				 , CASE WHEN MaxChoice = 0 THEN
					ROUND(0, @decimalPlaces)
				   ELSE
					ROUND((100 / Convert(decimal(18,2), MaxChoice)) * t2.AvgTot, @decimalPlaces)
				   END AS AvgPct
				FROM #VOTESUM t1 INNER JOIN 
				(
					SELECT Choice,
						   CASE WHEN TotCnt = 0 THEN
							 ROUND(0, @decimalPlaces)
						   ELSE
							 ROUND(Convert(decimal(18,2), (Cnt * 100)) / Convert(decimal(18,2), TotCnt), @decimalPlaces)
						   END AS Pct,
						   CASE WHEN TotCnt = 0 THEN
							 ROUND(0, @decimalPlaces)
						   ELSE
							 ROUND(Convert(decimal(18,2), TotCntXChoice) / Convert(decimal(18,2), TotCnt), @decimalPlaces)
						   END AS AvgTot
					  FROM #VOTESUM
				) AS t2 ON t2.Choice = t1.Choice
		  ) AS vd
		 WHERE vd.Choice = #VOTESUM.Choice

		-- SUCCESS
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH

	IF (dbo.IsNullOrEmpty(@userId) = 1)
	BEGIN
		SELECT vs.Choice
			 , vs.Cnt
			 , vs.Pct
			 , vs.RemarkCnt
			 , vs.MaxChoice
			 , vs.TotCnt
			 , vs.AvgPct
			 , vs.AvgTot
			 , lgv.LangId
			 , vs.CustomerId
			 , cmlv.CustomerName
			 , vs.BranchId
			 , omlv.BranchName
			 , vs.OrgId
			 , omlv.ParentId
			 , omlv.OrgName
			 , vs.QSetId
			 , vs.QSeq
			 , vs.UserId
			 , NULL AS FullName
			 , vs.DeviceId
		  FROM #VOTESUM as vs
			 , LanguageView lgv
			 , CustomerMLView cmlv
			 , OrgMLView omlv
			 --, LogInView lmlv
		 WHERE lgv.LangId = COALESCE(@langId, lgv.LangId)
		   AND lgv.Enabled = 1
		   AND cmlv.CustomerId = vs.CustomerId
		   AND cmlv.LangId = lgv.LangId
		   AND omlv.CustomerId = vs.CustomerId
		   AND omlv.OrgId = vs.OrgId 
		   AND omlv.LangId = lgv.LangId
		   --AND lmlv.CustomerId = COALESCE(@customerId, omlv.CustomerId) 
		   --AND lmlv.MemberId = COALESCE(@userId, lmlv.MemberId)
		   --AND lmlv.LangId = lgv.LangId
		 ORDER BY lgv.SortOrder, vs.QSetId, vs.QSeq, vs.Choice
	END
	ELSE
	BEGIN
		SELECT vs.Choice
			 , vs.Cnt
			 , vs.Pct
			 , vs.RemarkCnt
			 , vs.MaxChoice
			 , vs.TotCnt
			 , vs.AvgPct
			 , vs.AvgTot
			 , lgv.LangId
			 , vs.CustomerId
			 , cmlv.CustomerName
			 , vs.BranchId
			 , omlv.BranchName
			 , vs.OrgId
			 , omlv.ParentId
			 , omlv.OrgName
			 , vs.QSetId
			 , vs.QSeq
			 , vs.UserId
			 , lmlv.FullName
			 , vs.DeviceId
		  FROM #VOTESUM as vs
			 , LanguageView lgv
			 , CustomerMLView cmlv
			 , OrgMLView omlv
			 , LogInView lmlv
		 WHERE lgv.LangId = COALESCE(@langId, lgv.LangId)
		   AND lgv.Enabled = 1
		   AND cmlv.CustomerId = vs.CustomerId
		   AND cmlv.LangId = lgv.LangId
		   AND omlv.CustomerId = vs.CustomerId
		   AND omlv.OrgId = vs.OrgId 
		   AND omlv.LangId = lgv.LangId
		   AND lmlv.CustomerId = COALESCE(@customerId, omlv.CustomerId) 
		   AND lmlv.MemberId = COALESCE(@userId, lmlv.MemberId)
		   AND lmlv.LangId = lgv.LangId
		 ORDER BY lgv.SortOrder, vs.QSetId, vs.QSeq, vs.Choice
	END

	DROP TABLE #VOTESUM
	DROP TABLE #VOTEDATA
END

GO
