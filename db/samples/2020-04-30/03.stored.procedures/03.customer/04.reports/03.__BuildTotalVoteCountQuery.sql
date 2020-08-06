SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: __BuildTotalVoteCountQuery.
-- Description:	Build Query for select votevalue and total vote count for that votevalue.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
-- <2020-01-14> :
--	- Update time ckecking code.
--
-- [== Example ==]
--
--DECLARE @customerId nvarchar(30) = N'EDL-C2018040002'
--DECLARE @orgId nvarchar(30) = N'O0001';
--DECLARE @deviceId nvarchar(50) = N'233356614';
--DECLARE @qsetId nvarchar(30) = N'QS2018040001';
--DECLARE @qSeq int = 1; -- has single question.
--DECLARE @userId nvarchar(30) = NULL;
--DECLARE @beginDate datetime = N'2018-01-01';
--DECLARE @endDate datetime = N'2018-12-31';
--DECLARE @sql nvarchar(MAx);
--SET @orgId = NULL;
--SET @deviceId = NULL;
--
--EXEC __BuildTotalVoteCountQuery @customerId
--							    , @qsetId, @qSeq
--							    , @beginDate, @endDate
--							    , @orgId, @deviceId, @userId
--							    , @sql output;
-- =============================================
CREATE PROCEDURE [dbo].[__BuildTotalVoteCountQuery]
(
  @customerId as nvarchar(30)
, @qSetId as nvarchar(30)
, @qSeq as int
, @beginDate As DateTime = null
, @endDate As DateTime = null
, @orgId as nvarchar(30) = null
, @deviceId as nvarchar(30) = null
, @userId as nvarchar(30) = null
, @sql as nvarchar(MAX) output
)
AS
BEGIN
DECLARE @showOutput as int = 0;
DECLARE @objectStatus as int = 1;
DECLARE @includeSubOrg bit = 1;
DECLARE @inClause as nvarchar(MAX);
DECLARE @vBeginDateStr nvarchar(40);
DECLARE @vEndDateStr nvarchar(40); 
--DECLARE @vBeginDate as DateTime;
--DECLARE @vEndDate as DateTime;

	IF (dbo.IsNullOrEmpty(@orgId) = 0) -- OrgId Exist.
	BEGIN
		EXEC GenerateSubOrgInClause @customerId, @orgId, @includeSubOrg, @showOutput, @inClause output
	END

	-- CONVERT DATE
	SET @vBeginDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @beginDate)) + '-' +
						  CONVERT(nvarchar(2), DatePart(mm, @beginDate)) + '-' +
						  CONVERT(nvarchar(2), DatePart(dd, @beginDate)) + ' ' +
						  N'00:00:00');
	--SET @vBeginDate = CONVERT(datetime, @vBeginDateStr, 121);
	--SET @vBeginDate = CAST(@vBeginDateStr AS datetime)

	SET @vEndDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @endDate)) + '-' +
						CONVERT(nvarchar(2), DatePart(mm, @endDate)) + '-' +
						CONVERT(nvarchar(2), DatePart(dd, @endDate)) + ' ' +
						N'23:59:59');
	--SET @vEndDate = CONVERT(datetime, @vEndDateStr, 121);
	--SET @vEndDate = CAST(@vEndDateStr AS datetime)

	SET @sql = N'';
	SET @sql = @sql + 'SELECT VoteValue' + CHAR(13);
	SET @sql = @sql + '     , Count(VoteValue) AS TotalVote' + CHAR(13);
	SET @sql = @sql + '     , VoteValue * Count(VoteValue) AS TotalXCount' + CHAR(13);
	SET @sql = @sql + '     , Count(Remark) AS TotalRemark' + CHAR(13);
	SET @sql = @sql + '  FROM VOTE ' + CHAR(13);
	SET @sql = @sql + ' WHERE ' + CHAR(13);
	SET @sql = @sql + '		ObjectStatus = ' + convert(nvarchar, @objectStatus) + ' AND ' + CHAR(13);
	SET @sql = @sql + '		CustomerID = N''' + @customerId + ''' AND ' + CHAR(13);

	IF (dbo.IsNullOrEmpty(@userId) = 0)
	BEGIN
		SET @sql = @sql + '		UserID = N''' + @userId + ''' AND ' + CHAR(13);
	END

	IF (dbo.IsNullOrEmpty(@deviceId) = 0)
	BEGIN
		SET @sql = @sql + '		DeviceID = N''' + @deviceId + ''' AND ' + CHAR(13);
	END

	IF (dbo.IsNullOrEmpty(@orgId) = 0)
	BEGIN
		SET @sql = @sql + '		OrgID in (' + @inClause + ') AND ' + CHAR(13);
	END

	SET @sql = @sql + '		QSetID = N''' + @qSetId + ''' AND ' + CHAR(13);
	SET @sql = @sql + '		QSeq = ' + convert(nvarchar, @qSeq) + ' AND ' + CHAR(13);

	SET @sql = @sql + '		(VoteDate >= ''' + @vBeginDateStr + ''' AND ' + CHAR(13);
	SET @sql = @sql + '		 VoteDate <= ''' + @vEndDateStr + ''') ' + CHAR(13);

	SET @sql = @sql + ' GROUP BY VoteValue ' + CHAR(13);
	SET @sql = @sql + ' ORDER BY VoteValue ' + CHAR(13);

END

GO
