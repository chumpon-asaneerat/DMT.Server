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
--EXEC DeleteCustomer N'EDL-C2018050002'
-- =============================================
CREATE PROCEDURE [dbo].[DeleteCustomer]
(
  @customerId nvarchar(30)
)
AS
BEGIN
	DELETE FROM DeviceML WHERE CustomerId = @customerId;
	DELETE FROM Device WHERE CustomerId = @customerId;
	DELETE FROM ClientAccess WHERE CustomerId = @customerId;

	DELETE FROM Vote WHERE CustomerId = @customerId;
	DELETE FROM QSlideItemML WHERE CustomerId = @customerId;
	DELETE FROM QSlideItem WHERE CustomerId = @customerId;
	DELETE FROM QSlideML WHERE CustomerId = @customerId;
	DELETE FROM QSlide WHERE CustomerId = @customerId;
	DELETE FROM QSetML WHERE CustomerId = @customerId;
	DELETE FROM QSet WHERE CustomerId = @customerId;
	DELETE FROM DeviceML WHERE CustomerId = @customerId;
	DELETE FROM Device WHERE CustomerId = @customerId;
	DELETE FROM OrgML WHERE CustomerId = @customerId;
	DELETE FROM Org WHERE CustomerId = @customerId;
	DELETE FROM BranchML WHERE CustomerId = @customerId;
	DELETE FROM Branch WHERE CustomerId = @customerId;
	DELETE FROM MemberInfoML WHERE CustomerId = @customerId;
	DELETE FROM MemberInfo WHERE CustomerId = @customerId;
	DELETE FROM CustomerML WHERE CustomerId = @customerId;
	DELETE FROM Customer WHERE CustomerId = @customerId;
	DELETE FROM CustomerPK WHERE CustomerId = @customerId;
END

GO
