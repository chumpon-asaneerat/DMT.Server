SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[GetSumTASellByRunNo]	@tollwayid	 smallint
										,@SoldDate SMALLDATETIME
										,@RunNo int
AS

Select 
  CAST(ROW_NUMBER() OVER (
      PARTITION BY TA_Coupon.TollWayId
      ORDER BY CouponType
   ) - 1  AS smallint) AS LineNum 
,CAST(TA_Coupon.TollWayId AS smallint) AS TollWayId , 'C'+CouponType AS ItemCode , SAPItemName AS ItemDescription ,CAST(Count(SAPSysSerial) AS decimal)  AS Quantity
,CASE
    WHEN CouponType = 35 THEN CAST(665 AS decimal)
    WHEN CouponType = 80 THEN CAST(1520 AS decimal)
    ELSE null
END AS UnitPrice
, null AS PriceAfterVAT
, 'SC7' AS VatGroup
, SAPWhsCode AS WarehouseCode
,RunNo,ParentKey,DocDate
 from TA_Coupon
  Inner Join (Select RunNo,DocNum AS ParentKey,TollWayId ,DocDate From AR_Head Where AR_Head.ExportExcel = 0 And AR_Head.RunNo = @RunNo) AS AR_Head On AR_Head.TollWayId = TA_Coupon.TollWayId
where CouponStatus = 3
and datediff(day, SoldDate, COALESCE(@SoldDate, SoldDate)) = 0
and TA_Coupon.TollWayId = COALESCE(@tollwayid,TA_Coupon.TollWayId)
and SapChooseFlag = 1
and TA_Coupon.SAPSysSerial Not IN (Select AR_Serial.InternalSerialNumber From AR_Serial Where ExportExcel = 0)
Group By TA_Coupon.TollWayId , CouponType , SAPItemName,SAPWhsCode,RunNo,ParentKey,DocDate
Order By TollWayId , CouponType asc

GO