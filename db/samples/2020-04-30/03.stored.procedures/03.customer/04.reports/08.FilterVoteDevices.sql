SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: FilterVoteDevices.
-- Description:	Filter Devices from vote table that match date range.
-- [== History ==]
-- <2020-01-13> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec FilterVoteDevices N'TH', N'EDL-C2019100004', N'QS00004', NULL, N'2019-10-01', N'2021-11-01'
--exec FilterVoteDevices N'TH', N'EDL-C2019100004', N'QS00004', N'O0010', N'2019-10-01', N'2021-11-01'
-- =============================================
CREATE PROCEDURE [dbo].[FilterVoteDevices] 
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
DECLARE @vBeginDateStr nvarchar(40);
DECLARE @vEndDateStr nvarchar(40); 
DECLARE @vBeginDate as DateTime;
DECLARE @vEndDate as DateTime;
	BEGIN TRY
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

		SELECT DISTINCT L.langId
		              , A.customerId
					  , A.orgId
					  , O.OrgName
					  , A.BranchId
					  , B.BranchName
					  , A.DeviceId
					  , M.DeviceName
					  , M.Location
					  , M.DeviceTypeId
		  FROM VOTE A
			   INNER JOIN LanguageView L ON (
						  UPPER(LTRIM(RTRIM(L.LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, L.LangId))))
			   )
			   INNER JOIN OrgMLView O ON (
						  O.OrgId = A.OrgId 
					  AND O.CustomerId = A.CustomerId
					  AND O.LangId = L.LangId
			   )
			   INNER JOIN BranchMLView B ON (
						  B.BranchId = A.BranchId 
				      AND B.CustomerId = A.CustomerId
					  AND B.LangId = L.LangId
			   )
			   LEFT OUTER JOIN DeviceMLView M ON (
						  M.DeviceId = A.DeviceId 
					  AND M.CustomerId = A.CustomerId
					  AND M.LangId = L.LangId
			   )
		 WHERE A.ObjectStatus = 1
		   AND LOWER(A.CustomerId) = LOWER(RTRIM(LTRIM(@customerId)))
		   AND LOWER(A.QSetId) = LOWER(RTRIM(LTRIM(@qsetId)))
		   AND UPPER(LTRIM(RTRIM(A.OrgId))) = UPPER(LTRIM(RTRIM(COALESCE(@orgId, A.OrgId))))
		   AND A.VoteDate >= @vBeginDate
		   AND A.VoteDate <= @vEndDate

		-- success
		EXEC GetErrorMsg 0, @errNum out, @errMsg out
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO
