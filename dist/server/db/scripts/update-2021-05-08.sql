/*********** Script Update Date: 2021-05-08  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[TA_getSelltoInterface]	@tollwayid	 nvarchar(5)
										,@SoldDate date
AS

select C.TollWayId , C.CouponType , C.SAPItemName, C.SerialNo , C.SAPSysSerial , C.SoldDate, 
C.SoldBy , C.LaneId , T.TSB_Th_Name as TollWayName  , null as ShiftName
 from TA_Coupon C , TSB T
where C.TSBId = T.TSBId
and C.CouponStatus in ( 3 ,4)
and CAST(COALESCE(C.SoldDate, '1/1/1900') as date) = @SoldDate
and C.TollWayId = COALESCE(@tollwayid,TollWayId)
and C.SapChooseFlag = 1
ORDER BY C.CouponType , C.SerialNo , C.SAPSysSerial


