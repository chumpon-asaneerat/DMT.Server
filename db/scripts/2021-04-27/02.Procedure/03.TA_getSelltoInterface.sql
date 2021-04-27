SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[TA_getSelltoInterface]	@tollwayid	 nvarchar(5)
										,@SoldDate SMALLDATETIME
AS

select TollWayId , CouponType , SAPItemName, SerialNo , SAPSysSerial , SoldDate, SoldBy , LaneId 
 from TA_Coupon
where CouponStatus in ( 3 ,4)
and CAST(COALESCE(SoldDate, '1/1/1900') as date) = @SoldDate
and TollWayId = COALESCE(@tollwayid,TollWayId)
and SapChooseFlag = 1
ORDER BY CouponType , SerialNo , SAPSysSerial

GO