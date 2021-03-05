SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create  PROCEDURE [dbo].[TA_InquirySellCoupon] (
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



	
END;
GO