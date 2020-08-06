SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Generate Sub Org In Clause.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
-- EXEC GenerateSubOrgInClause N'EDL-C2017030001', N'O0001' -- Get in clause for root note
-- EXEC GenerateSubOrgInClause N'EDL-C2017030001', N'O0001', 0 -- Get in clause for root note not include sub org
-- =============================================
CREATE PROCEDURE GenerateSubOrgInClause
(
  @customerId nvarchar(30)
, @orgID nvarchar(30)
, @includeSubOrg bit = 1
, @ShowOutput bit = 0
, @retVal As nvarchar(MAX) = N'' output
)
AS
BEGIN
	SET NOCOUNT ON;
	SET @retVal = N'';
	
	IF @IncludeSubOrg <> 0
	BEGIN
		EXEC __GenerateSubOrgInClause @customerId, @orgID, @includeSubOrg, @retVal output;
	END
	
	--PRINT @retVal;
	
	IF @retVal <> N''
	BEGIN
		--PRINT N'HAS SUB ORG';
		SET @retVal = N'''' + @orgID + N''', ' + @retVal;
	END
	ELSE
	BEGIN
		--PRINT N'NO SUB ORG';
		SET @retVal = N'''' + @orgID + N'''';
	END
	IF @ShowOutput <> 0
	BEGIN
		SELECT @retVal AS InClause;
	END
END

GO
