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
