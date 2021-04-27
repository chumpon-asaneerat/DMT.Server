SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[GetTASellByRunNo]	@tollwayid	smallint
										,@SoldDate SMALLDATETIME
										,@RunNo int
AS

Select RunNo,ParentKey ,TA_Coupon.CouponType,TA_Coupon.SAPSysSerial AS InternalSerialNumber , AR_Line.LineNum AS BaseLineNumber ,TA_Coupon.TollWayId,DocDate ,SerialNo
 From TA_Coupon
Inner Join (Select RunNo,ParentKey,LineNum,ItemCode,TollWayId ,DocDate From AR_Line Where AR_Line.ExportExcel = 0 And AR_Line.RunNo = @RunNo
Group By RunNo,ParentKey,LineNum,ItemCode,TollWayId ,DocDate) AS AR_Line On AR_Line.ItemCode = 'C'+TA_Coupon.CouponType
And AR_Line.TollWayId = TA_Coupon.TollWayId
where CouponStatus = 3
AND datediff(day, SoldDate, COALESCE(@SoldDate, SoldDate) ) = 0
and TA_Coupon.TollWayId = COALESCE(@tollwayid,TA_Coupon.TollWayId)
and SapChooseFlag = 1
and TA_Coupon.SAPSysSerial Not IN (Select AR_Serial.InternalSerialNumber From AR_Serial Where ExportExcel = 0)
Group By  RunNo,ParentKey ,TA_Coupon.CouponType,TA_Coupon.SAPSysSerial, AR_Line.LineNum,TA_Coupon.TollWayId,DocDate ,SerialNo
ORDER BY TA_Coupon.CouponType , SerialNo , SAPSysSerial
GO
