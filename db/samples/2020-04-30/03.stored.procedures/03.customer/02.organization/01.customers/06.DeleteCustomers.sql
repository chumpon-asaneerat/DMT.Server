SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Sample
-- [== History ==]
-- <2018-05-24> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--EXEC DeleteCustomers    -- Delete Customer without reset master pk.
--EXEC DeleteCustomers 1  -- Delete Customer with reset master pk.
-- =============================================
CREATE PROCEDURE [dbo].[DeleteCustomers]
(
  @reset bit = 0
)
AS
BEGIN
	DELETE FROM DeviceML;
	DELETE FROM Device;
	DELETE FROM ClientAccess;

	DELETE FROM Vote;
	DELETE FROM QSlideItemML;
	DELETE FROM QSlideItem;
	DELETE FROM QSlideML;
	DELETE FROM QSlide;
	DELETE FROM QSetML;
	DELETE FROM QSet;
	DELETE FROM DeviceML;
	DELETE FROM Device;
	DELETE FROM OrgML;
	DELETE FROM Org;
	DELETE FROM BranchML;
	DELETE FROM Branch;
	DELETE FROM MemberInfoML;
	DELETE FROM MemberInfo;
	DELETE FROM CustomerML;
	DELETE FROM Customer;
	DELETE FROM CustomerPK;
	IF (@reset = 1)
	BEGIN
		DELETE FROM MasterPK;
		EXEC InitMasterPKs;
	END
END

GO
