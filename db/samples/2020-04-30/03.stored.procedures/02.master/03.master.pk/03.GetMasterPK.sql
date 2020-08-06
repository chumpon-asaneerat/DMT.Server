SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetMasterPK.
-- Description:	GetUniquePK (master)
-- [== History ==]
-- <2016-10-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetMasterPK N'Customer'; -- for get match by name
--exec GetMasterPK; -- for get all
-- =============================================
CREATE PROCEDURE [dbo].[GetMasterPK] 
(
  @tableName nvarchar(50) = null
)
AS
BEGIN
	SELECT LastSeed
		 , SeedResetMode
		 , CASE SeedResetMode
			 WHEN 1 THEN N'Daily'
			 WHEN 2 THEN N'Monthly'
			 WHEN 3 THEN N'Yearly'
		   END AS ResetMode
		 , [prefix]
		 , SeedDigits
		 , LastUpdated
		FROM MasterPK
		WHERE LOWER([TableName]) = LOWER(COALESCE(@tableName, [TableName]));
END

GO
