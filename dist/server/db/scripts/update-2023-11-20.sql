/*********** Script Update Date: 2023-11-20  ***********/
/****** Object:  Table [dbo].[TA2SCWCouponSold]    Script Date: 20/11/2566 12:32:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TA2SCWCouponSold](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TSBId] [nvarchar](5) NULL,
	[SoldBy] [nvarchar](10) NULL,
	[SoldDate] [date] NULL,
	[SerialNo] [nvarchar](7) NULL,
	[CouponType] [nvarchar](3) NULL,
	[Price] [decimal](6, 0) NULL,
	[TransactionDate] [datetime] NULL,
 CONSTRAINT [PK__TA2SCWCo__3214EC278BF8AFC8] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/*********** Script Update Date: 2023-11-20  ***********/
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


/*********** Script Update Date: 2023-11-20  ***********/
/****** Object:  StoredProcedure [dbo].[TA_SendCouponToSCW]    Script Date: 20/11/2566 12:37:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TA_SendCouponToSCW]
(
  @transactiondate date
)
AS
BEGIN
    DECLARE @tsbid nvarchar(5), @soldby nvarchar(10), @solddate datetime, @serialno nvarchar(20), 
            @coupontype varchar(3), @price decimal(6,0);
    DECLARE cursor_coupon CURSOR
    FOR SELECT 
        c.[TSBId],c.[SoldBy] , c.solddate, c.[SerialNo] , c.CouponType, c.[Price] 
        FROM [dbo].[TA_Coupon] c 
        where c.FinishFlag = 0 
        and sendSCW = 0 ;
        
    OPEN cursor_coupon;

    FETCH NEXT FROM cursor_coupon INTO 
        @tsbid,
        @soldby,
        @solddate,
        @serialno,
        @coupontype,
        @price;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF NOT EXISTS (SELECT *	
                            FROM [dbo].[TA2SCWCouponSold]
                        WHERE [TSBId] = @tsbid
                            and [SerialNo] = @serialno)
        BEGIN 
            insert into [dbo].[TA2SCWCouponSold]
                ([TSBId],[SoldBy], [SoldDate] , [SerialNo] ,[CouponType], [Price] , [TransactionDate] )
            VALUES 
                (@tsbid,@soldby,@solddate,@serialno,@coupontype,@price,@transactiondate  );

        END
        ELSE
        BEGIN
            update [dbo].[TA2SCWCouponSold]
            set [SoldBy] = @soldby
            ,	[SoldDate] = @solddate
            ,	[TransactionDate] = @transactiondate
            where [TSBId] = @tsbid
            and [SerialNo] = [SerialNo];
        END

        update [dbo].[TA_Coupon]
           set sendSCW = 1,
               sendSCWDate = @transactiondate
         where [SerialNo] = @serialno
           and [TSBId] = @tsbid;
         --and  sendSCW = 0;

        FETCH NEXT FROM cursor_coupon INTO 
            @tsbid,
            @soldby,
            @solddate,
            @serialno,
            @coupontype,
            @price;
    END
    CLOSE cursor_coupon;
    DEALLOCATE cursor_coupon;
END

GO

