/*********** Script Update Date: 2021-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[TA_getSelltoInterface]	@tollwayid	 nvarchar(5)
										,@SoldDate date
AS

select TollWayId , CouponType , SAPItemName, SerialNo , SAPSysSerial , SoldDate, SoldBy , LaneId 
 from TA_Coupon
where CouponStatus in ( 3 ,4)
and CAST(COALESCE(SoldDate, '1/1/1900') as date) = @SoldDate
and TollWayId = COALESCE(@tollwayid,TollWayId)
and SapChooseFlag = 1
ORDER BY CouponType , SerialNo , SAPSysSerial

/*********** Script Update Date: 2021-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[GetSumTASellByRunNo]	@tollwayid	 smallint
										,@SoldDate DATETIME
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
where CouponStatus in ( 3 , 4) 
and datediff(day, SoldDate, COALESCE(@SoldDate, SoldDate)) = 0
and TA_Coupon.TollWayId = COALESCE(@tollwayid,TA_Coupon.TollWayId)
and SapChooseFlag = 1
and TA_Coupon.SAPSysSerial Not IN (Select AR_Serial.InternalSerialNumber From AR_Serial Where ExportExcel = 0)
Group By TA_Coupon.TollWayId , CouponType , SAPItemName,SAPWhsCode,RunNo,ParentKey,DocDate
Order By TollWayId , CouponType asc



/*********** Script Update Date: 2021-04-30  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[GetTASellByRunNo]	@tollwayid	smallint
										,@SoldDate DATETIME
										,@RunNo int
AS

Select RunNo,ParentKey ,TA_Coupon.CouponType,TA_Coupon.SAPSysSerial AS InternalSerialNumber , AR_Line.LineNum AS BaseLineNumber ,TA_Coupon.TollWayId,DocDate ,SerialNo
 From TA_Coupon
Inner Join (Select RunNo,ParentKey,LineNum,ItemCode,TollWayId ,DocDate From AR_Line Where AR_Line.ExportExcel = 0 And AR_Line.RunNo = @RunNo
Group By RunNo,ParentKey,LineNum,ItemCode,TollWayId ,DocDate) AS AR_Line On AR_Line.ItemCode = 'C'+TA_Coupon.CouponType
And AR_Line.TollWayId = TA_Coupon.TollWayId
where CouponStatus in (3,4)
AND datediff(day, SoldDate, COALESCE(@SoldDate, SoldDate) ) = 0
and TA_Coupon.TollWayId = COALESCE(@tollwayid,TA_Coupon.TollWayId)
and SapChooseFlag = 1
and TA_Coupon.SAPSysSerial Not IN (Select AR_Serial.InternalSerialNumber From AR_Serial Where ExportExcel = 0)
Group By  RunNo,ParentKey ,TA_Coupon.CouponType,TA_Coupon.SAPSysSerial, AR_Line.LineNum,TA_Coupon.TollWayId,DocDate ,SerialNo
ORDER BY TA_Coupon.CouponType , SerialNo , SAPSysSerial

