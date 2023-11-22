Alter table TA_Coupon add sendSCW char(1) ; ---- 1 = Send , 0 = Unsend
GO

ALter table TA_Coupon add sendSCWDate datetime; 
GO

-- Update sendSCW = 0 สำหรับ Finishflag = 1 Coupon ที่อยู่ใน Stock 
update TA_Coupon
   set sendSCW = 0
 where  FinishFlag = 1
   and couponstatus  in (1,2)
GO

--- update sendSCW = 1 สำหรับ Finishflag = 0 , Sapchooseflag = 0 , SapChooseDate is not null  Coupon ที่ ส่ง Sap แล้ว 
update TA_Coupon
   set sendSCW = 1
 where  FinishFlag = 0
   and SapChooseDate is not null 
GO

--- update sendSCW = 1 สำหรับ Finishflag = 0 , Sapchooseflag = 0 , SapChooseDate is null  Coupon ที่ ส่ง Sap แล้ว 
update TA_Coupon
   set sendSCW = 1
 where  FinishFlag = 0
   and Sapchooseflag = 0
   and sendSCW is null
GO

-- Update sendSCW = 1 สำหรับ Finishflag = 1 แต่ Status = 3, 4 และ Sapchooseflag = 0 คูปอง ถูก mark ว่าส่ง Sap แล้ว 
update TA_Coupon
   set sendSCW = 1
 where  sendSCW is null
   and FinishFlag = 1
   and couponstatus  in (3,4)
   and Sapchooseflag = 0
GO

-- Update sendSCW = 0 สำหรับ Coupon ที่เหลือ ที่มี Solddate และ รับคืนจาก พก แล้ว ยังไม่ส่ง SAP
update TA_Coupon
   set sendSCW = 0
 where  sendSCW is null
   and FinishFlag = 0
   and SoldDate is not null
GO

--- update sendSCW = 1 สำหรับ Finishflag = 0 
update TA_Coupon
   set sendSCW = 1
 where  sendSCW is null
   and FinishFlag = 0
GO

-- Update คูปองที่เหลือ
update TA_Coupon
   set sendSCW = 1
 where sendSCW is null
GO
