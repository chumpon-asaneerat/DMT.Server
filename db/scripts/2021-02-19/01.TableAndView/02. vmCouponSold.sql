SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vmCouponSold]
AS
SELECT        TSBId, CouponType, SerialNo, Price, SoldBy, SoldDate, LaneId, SAPItemName, PayTypeID, PaytypeName, EdcDateTime, EdcTerminalId, EdcCardNo, EdcRef1, EdcAmount, EdcRef2, EdcRef3
FROM            dbo.TA_Coupon
WHERE        (CouponStatus IN (3, 4))

GO
