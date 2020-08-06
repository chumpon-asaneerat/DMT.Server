SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: FilterVoteMembers.
-- Description:	Filter Vote Members from vote table that match date range.
-- [== History ==]
-- <2019-11-07> :
--	- Stored Procedure Created.
-- <2020-01-07> :
--	- Rename SP name from FilterMembers to FilterVoteMembers.
-- <2020-01-15> :
--	- Supports include sub org(s).
--
-- [== Example ==]
--
--exec FilterVoteMembers N'TH', N'EDL-C2019100003', N'QS00001', NULL, N'2019-10-01', N'2019-11-01'
--exec FilterVoteMembers N'EN', N'EDL-C2019100003', N'QS00001', N'O0010', N'2019-10-01', N'2019-11-01'
-- =============================================
CREATE PROCEDURE [dbo].[FilterVoteMembers] 
(
  @langId as nvarchar(3)
, @customerId as nvarchar(30)
, @qsetId as nvarchar(30)
, @orgId as nvarchar(30) = null
, @beginDate As DateTime = null
, @endDate As DateTime = null
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out
)
AS
BEGIN
DECLARE @showOutput as int = 0;
DECLARE @objectStatus as int = 1;
DECLARE @includeSubOrg bit = 1;
DECLARE @inClause as nvarchar(MAX);
DECLARE @sql as nvarchar(MAX)
DECLARE @vBeginDateStr nvarchar(40);
DECLARE @vEndDateStr nvarchar(40); 
DECLARE @vBeginDate as DateTime;
DECLARE @vEndDate as DateTime;
	BEGIN TRY
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
		SET @vBeginDate = CAST(@vBeginDateStr AS datetime)

		SET @vEndDateStr = (CONVERT(nvarchar(4), DatePart(yyyy, @endDate)) + '-' +
							CONVERT(nvarchar(2), DatePart(mm, @endDate)) + '-' +
							CONVERT(nvarchar(2), DatePart(dd, @endDate)) + ' ' +
							N'23:59:59');
		--SET @vEndDate = CONVERT(datetime, @vEndDateStr, 121);
		SET @vEndDate = CAST(@vEndDateStr AS datetime)

		SET @sql = N'';
		SET @sql = @sql + '';
		SET @sql = @sql + 'SELECT DISTINCT L.langId ' + CHAR(13);
		SET @sql = @sql + '              --, A.customerId ' + CHAR(13);
		SET @sql = @sql + '			  --, A.orgId ' + CHAR(13);
		SET @sql = @sql + '			  --, O.OrgName ' + CHAR(13);
		SET @sql = @sql + '			  --, A.BranchId ' + CHAR(13);
		SET @sql = @sql + '			  --, B.BranchName ' + CHAR(13);
		SET @sql = @sql + '			  , A.UserId ' + CHAR(13);
		SET @sql = @sql + '			  , M.FullName ' + CHAR(13);
		SET @sql = @sql + '  FROM VOTE A ' + CHAR(13);
		SET @sql = @sql + '	   INNER JOIN LanguageView L ON ( ' + CHAR(13);
		IF (dbo.IsNullOrEmpty(@langId) = 0) -- LangId Exist.
		BEGIN
			SET @sql = @sql + '				  UPPER(LTRIM(RTRIM(L.LangId))) = UPPER(LTRIM(RTRIM(N''' + @langId + ''')))' + CHAR(13);
		END
		ELSE
		BEGIN
			SET @sql = @sql + '				  UPPER(LTRIM(RTRIM(L.LangId))) = UPPER(LTRIM(RTRIM(L.LangId)))' + CHAR(13);
		END
		SET @sql = @sql + '	   ) ' + CHAR(13);
		SET @sql = @sql + '	   LEFT OUTER JOIN MemberInfoMLView M ON ( ' + CHAR(13);
		SET @sql = @sql + '				  M.MemberId = A.UserId ' + CHAR(13);
		SET @sql = @sql + '			  AND M.CustomerId = A.CustomerId ' + CHAR(13);
		SET @sql = @sql + '			  AND M.LangId = L.LangId ' + CHAR(13);
		SET @sql = @sql + '	   ) ' + CHAR(13);
		SET @sql = @sql + ' WHERE A.ObjectStatus = 1 ' + CHAR(13);
		SET @sql = @sql + '   AND LOWER(A.CustomerId) = LOWER(RTRIM(LTRIM(N''' + @customerId + '''))) ' + CHAR(13);
		SET @sql = @sql + '   AND LOWER(A.QSetId) = LOWER(RTRIM(LTRIM(N''' + @qsetId + '''))) ' + CHAR(13);
		IF (dbo.IsNullOrEmpty(@orgId) = 0) -- OrgId Exist.
		BEGIN
			SET @sql = @sql + '   AND A.OrgId IN (' + @inClause + ') ' + CHAR(13);
		END

		SET @sql = @sql + '   AND A.VoteDate >= ''' + @vBeginDateStr + ''' ' + CHAR(13);
		SET @sql = @sql + '   AND A.VoteDate <= ''' + @vEndDateStr + ''' ' + CHAR(13);

		--SELECT @sql
		EXECUTE sp_executesql @sql
		-- success
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
