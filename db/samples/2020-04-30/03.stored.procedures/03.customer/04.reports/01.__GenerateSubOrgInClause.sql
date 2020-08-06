SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: __GenerateSubOrgInClause
-- Description:	Internal Get Sub Org In Clause (use internally).
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC __GenerateSubOrgInClause N'EDL-C2017030001', N'O0001'
-- =============================================
CREATE PROCEDURE __GenerateSubOrgInClause
(
  @customerId nvarchar(30)
, @orgID nvarchar(30)
, @includeSubOrg bit = 1
, @retVal As nvarchar(MAX) = N'' output
)
AS
BEGIN
DECLARE @subOrgID As nvarchar(30)
DECLARE @itemCnt As int
DECLARE @maxCnt As int
DECLARE @retSubVal As nvarchar(MAX)

	SET @itemCnt = 0;
	SET @maxCnt = 0;
	SET @retVal = N'';

	SELECT @maxCnt = COUNT(*) 
	  FROM ORG
 	 WHERE ObjectStatus = 1 AND 
		   ParentId = @orgID AND
		   CustomerId = @customerId;
	DECLARE ORG_CURSOR CURSOR 
			LOCAL
			FORWARD_ONLY 
			READ_ONLY 
			FAST_FORWARD 
		FOR  
		SELECT OrgID
		  FROM ORG 
		 WHERE ObjectStatus = 1 
           AND ParentId = @orgID 
           AND CustomerId = @customerId

	OPEN ORG_CURSOR  
	FETCH NEXT FROM ORG_CURSOR INTO @subOrgID
	WHILE @@FETCH_STATUS = 0  
	BEGIN
		--PRINT @subOrgID;				
		IF @itemCnt = 0
		BEGIN
			SET @retVal = N'''' + @subOrgID + N'''';
		END
		ELSE
		BEGIN
			SET @retVal = @retVal + N', ''' + @subOrgID + N'''';
		END
		
		IF @IncludeSubOrg =  1 AND @maxCnt > 0
		BEGIN
			SET @retSubVal = N'';
			EXEC __GenerateSubOrgInClause @customerId, @subOrgID, @includeSubOrg, @retSubVal output;
			
			IF @retSubVal <> ''
			BEGIN
				--PRINT @retSubVal;
				SET @retVal = @retVal + N', ' + @retSubVal;
			END
		END
		
		SET @itemCnt = @itemCnt + 1;
		
		FETCH NEXT FROM ORG_CURSOR INTO @subOrgID
	END  

	CLOSE ORG_CURSOR  
	DEALLOCATE ORG_CURSOR 	
END

GO

