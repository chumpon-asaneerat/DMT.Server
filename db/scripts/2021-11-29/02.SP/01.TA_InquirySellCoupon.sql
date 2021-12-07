/****** Object:  StoredProcedure [dbo].[TA_InquirySellCoupon]    Script Date: 29/11/2564 11:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER  PROCEDURE [dbo].[TA_InquirySellCoupon] (
    @SAPItemCode nvarchar(10)
   ,@SAPIntrSerial nvarchar(15) 
   ,@SAPTransferNo varchar(20) 
   ,@ItemStatusDigit tinyint
   ,@TollWayId smallint
   ,@WorkingDateFrom datetime
   ,@WorkingDateTo datetime
   ,@SAPARInvoice varchar(30)
   ,@ShiftId int
   
)
AS
BEGIN
/*
select S.* , T.SoldBy , T.SoldDate , T.LaneId
from [dbo].[TmpInquirySellCoupon] S
left join [dbo].[TA_Coupon] T
on S.SAPIntrSerial = T.SerialNo
and S.SAPSysSerial = T.SAPSysSerial
where  S.SAPItemCode = COALESCE(@SAPItemCode, S.SAPItemCode) 
and S.SAPIntrSerial = COALESCE(@SAPIntrSerial, S.SAPIntrSerial)  
and S.TollWayId = COALESCE(@TollWayId, S.TollWayId) 
and S.SAPTransferNo = COALESCE(@SAPTransferNo,S.SAPTransferNo )
and COALESCE(SAPARInvoice,'') like '%' + @SAPARInvoice + '%'
and S.ItemStatusDigit = COALESCE(@ItemStatusDigit, S.ItemStatusDigit)
and S.ShiftId = COALESCE(@ShiftId, S.ShiftId)
and (  (S.WorkingDate >= @WorkingDateFrom OR @WorkingDateFrom IS NULL) 
        AND (S.WorkingDate < DATEADD(day,1,@WorkingDateTo) OR @WorkingDateTo IS NULL)
    )

*/
select a.* from 
(
select ISNULL(S.[SAPItemCode] ,b.[SAPItemCode]) SAPItemCode , 
ISNULL(S.SAPIntrSerial, b.SAPIntrSerial) SAPIntrSerial ,
S.SAPSysSerial , S.SAPTransferNo , S.SAPTransferDate , 
ISNULL(b.ItemStatus , S.ItemStatus) ItemStatus,
ISNULL (b.ItemStatusDigit , S.ItemStatusDigit) ItemStatusDigit ,  
ISNULL(S.TollWayName, b.TollWayName) TollWayName , 
ISNULL(S. TollWayId ,b. TollWayId) TollWayId ,
ISNULL(S.WorkingDate , b.WorkingDate ) WorkingDate ,
ISNULL(S.ShiftName, b.ShiftName) ShiftName , S.SAPARInvoice , S.SAPARDate ,
ISNULL(b.ShiftId, S.ShiftId ) ShiftId , b.SoldBy, b.LaneId
from [dbo].[TmpInquirySellCoupon] S 
FULL OUTER JOIN
( select 'C'+CouponType as SAPItemCode , SerialNo as SAPIntrSerial ,
null as SAPSysSerial , null as SAPTransferNo, null as SAPTransferDate , 
CASE WHEN CouponStatus = 1   THEN 'สต๊อก'
     WHEN CouponStatus = 2   THEN 'จ่ายพนักงาน'
	 WHEN CouponStatus = 3   THEN 'พนักงานขาย'
	 WHEN CouponStatus = 4   THEN 'หพ ขาย'
ELSE null END AS  ItemStatus
, CouponStatus as ItemStatusDigit , B.TSB_Th_Name as TollWayName ,
CAST(SUBSTRING(T.TSBId, 2,1) as smallint) as TollWayId , SoldDate as WorkingDate, 
CASE WHEN Cast(SoldDate as Time) between '06:00:00' and '14:00:00'  THEN 'เช้า'
     WHEN Cast(SoldDate as Time) between '14:00:00' and '20:00:00'  THEN 'บ่าย'
	 WHEN Cast(SoldDate as Time) between '20:00:00' and '06:00:00'  THEN 'ดึก'
ELSE null END AS  ShiftName ,
null as SAPARInvoice , null as SAPARDate , 
CASE WHEN SoldDate is null THEN 0
     WHEN Cast(SoldDate as Time) between '06:00:00' and '14:00:00'  THEN 1
     WHEN Cast(SoldDate as Time) between '14:00:00' and '20:00:00'  THEN 2
	 WHEN Cast(SoldDate as Time) between '20:00:00' and '06:00:00'  THEN 3
ELSE null END AS ShiftId ,SoldBy, LaneId
from TA_Coupon T , TSB B
where T.TSBId = B.TSBId ) B
on S.SAPIntrSerial = b.SAPIntrSerial ) a
where  a.SAPItemCode = COALESCE(@SAPItemCode, a.SAPItemCode) 
and a.SAPIntrSerial = COALESCE(@SAPIntrSerial, a.SAPIntrSerial)  
and a.TollWayId = COALESCE(@TollWayId, a.TollWayId) 
and (a.SAPTransferNo = COALESCE(@SAPTransferNo,a.SAPTransferNo )  OR @SAPTransferNo IS NULL)
and COALESCE(a.SAPARInvoice,'') like '%' + @SAPARInvoice + '%'
and a.ItemStatusDigit = COALESCE(@ItemStatusDigit, a.ItemStatusDigit)
and a.ShiftId = COALESCE(@ShiftId, a.ShiftId)
and (  (a.WorkingDate >= @WorkingDateFrom OR @WorkingDateFrom IS NULL) 
        AND (a.WorkingDate < DATEADD(day,1,@WorkingDateTo) OR @WorkingDateTo IS NULL)
    )
order by a.SAPIntrSerial

END;

GO
