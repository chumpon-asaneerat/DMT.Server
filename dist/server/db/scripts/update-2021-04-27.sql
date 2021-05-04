/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SAPCustomerCode](
	[CardCode] [nvarchar](15) NOT NULL,
	[CardName] [nvarchar](100) NULL,
	[UseFlag] [int] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SAPCustomerCode] ADD  DEFAULT ((1)) FOR [UseFlag]
GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AR_Head](
	[RunNo] [int] NOT NULL,
	[DocNum] [int] NULL,
	[DocType] [nvarchar](15) NULL,
	[DocDate] [nvarchar](8) NOT NULL,
	[DocDueDate] [nvarchar](8) NULL,
	[CardCode] [nvarchar](15) NOT NULL,
	[CardName] [nvarchar](100) NULL,
	[NumAtCard] [nvarchar](50) NULL,
	[Comments] [nvarchar](50) NULL,
	[TollWayId] [smallint] NOT NULL,
	[ExportExcel] [bit] NULL,
	[InsertDate] [datetime] NULL,
	[ExportDate] [datetime] NULL,
	[PaymentGroupCode] [smallint] NULL,
 CONSTRAINT [PK_AR_Head] PRIMARY KEY CLUSTERED 
(
	[RunNo] ASC,
	[DocDate] ASC,
	[CardCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AR_Line](
	[RunNo] [int] NOT NULL,
	[ParentKey] [int] NOT NULL,
	[LineNum] [int] NOT NULL,
	[DocDate] [nvarchar](8) NOT NULL,
	[ItemCode] [nvarchar](3) NULL,
	[ItemDescription] [nvarchar](20) NULL,
	[Quantity] [decimal](18, 2) NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[PriceAfterVAT] [decimal](18, 2) NULL,
	[VatGroup] [nvarchar](3) NULL,
	[WarehouseCode] [nvarchar](8) NULL,
	[TollWayId] [smallint] NOT NULL,
	[ExportExcel] [bit] NULL,
	[InsertDate] [datetime] NULL,
	[ExportDate] [datetime] NULL,
 CONSTRAINT [PK_AR_Line] PRIMARY KEY CLUSTERED 
(
	[RunNo] ASC,
	[ParentKey] ASC,
	[LineNum] ASC,
	[DocDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AR_Serial](
	[RunNo] [int] NOT NULL,
	[ParentKey] [int] NOT NULL,
	[InternalSerialNumber] [int] NOT NULL,
	[SerialNo] [nvarchar](7) NOT NULL,
	[BaseLineNumber] [int] NOT NULL,
	[DocDate] [nvarchar](8) NOT NULL,
	[TollWayId] [smallint] NOT NULL,
	[ExportExcel] [bit] NULL,
	[InsertDate] [datetime] NULL,
	[ExportDate] [datetime] NULL,
 CONSTRAINT [PK_AR_Serial_1] PRIMARY KEY CLUSTERED 
(
	[RunNo] ASC,
	[ParentKey] ASC,
	[InternalSerialNumber] ASC,
	[DocDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


Create  PROCEDURE [dbo].[TA_getSAPCustomer] (
    @SearchText NVARCHAR(100)
)
AS
BEGIN
	SELECT *
	FROM [dbo].[SAPCustomerCode]
	WHERE (	(CardCode LIKE '%' + @SearchText + '%') OR
			(CardName LIKE '%' + @SearchText + '%') 
			)
	and UseFlag = 1 

END


GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create  PROCEDURE [dbo].[TA_getTSBlist] 
AS
BEGIN
	select T.* , W.SapWhsCode , W.TollwayID
from  [dbo].[TSB] T , [dbo].[SapWhsCodeTSBMap]  W
where T.TSBId = W.TSBId

END


GO

/*********** Script Update Date: 2021-04-27  ***********/
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

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateAR_Head] (

 @DocDate nvarchar(8)
, @DocDueDate nvarchar(8)
, @CardCode nvarchar(15)
, @CardName nvarchar(100)
, @NumAtCard nvarchar(50)
, @Comments nvarchar(50)
,@PaymentGroupCode smallint
,@TollWayId smallint

,@ErrMsg As Varchar(200) = '''' Output
,@ErrNum As Int = 0 Output
,@ReturnType As Int = 0 Output

)
AS
BEGIN
DECLARE @DocNum int = NULL;
DECLARE @RunNo int = NULL;

	select @DocNum = count(AR_Head.DocNum)+1
	FROM [dbo].[AR_Head]
	WHERE ExportExcel = 0
		--And AR_Head.DocDate = @DocDate;

	select @RunNo = count(AR_Head.DocNum)+1
	FROM [dbo].[AR_Head]

	BEGIN TRY
	SET @ErrMsg = ''''
	SET @ErrNum = 0	

	--IF (select count(DocNum) 	
	--	FROM [dbo].[AR_Head]
	--	WHERE AR_Head.DocDate = @DocDate
	--	And AR_Head.CardCode = @CardCode
	--	And ExportExcel = 0) = 0

	--BEGIN
	--SET @ReturnType = 1

	--UPDATE [dbo].[AR_Head]
	--SET  DocDueDate = isnull(@DocDueDate ,[DocDueDate])
	--	, NumAtCard = isnull(@NumAtCard ,[NumAtCard])
	--	, Comments = isnull(@Comments ,[Comments])
	--WHERE AR_Head.DocDate = @DocDate
	--And AR_Head.CardCode = @CardCode
	--And AR_Head.ExportExcel = 0

	--End
	--ELSE
	BEGIN
	SET @ReturnType = 1
	INSERT INTO [dbo].[AR_Head]
           (RunNo,DocNum , DocType , DocDate , DocDueDate , CardCode , CardName , NumAtCard , Comments ,PaymentGroupCode, TollWayId , ExportExcel , InsertDate , ExportDate )
    VALUES (@RunNo,@DocNum , 'dDocument_Items' , @DocDate , @DocDueDate , @CardCode , @CardName , @NumAtCard , @Comments,@PaymentGroupCode , @TollWayId, 0 ,GETDATE() , null)
	END
		
	RETURN
	END TRY
	BEGIN CATCH
		IF @@Error > 0 OR @@RowCount < 1 
		BEGIN
			SET @ErrMsg = ERROR_MESSAGE()
			SET @ErrNum = ERROR_NUMBER()
			SET @ReturnType = 0
			Return	
		END
	END CATCH

	COMMIT;
END;
GO

/*********** Script Update Date: 2021-04-27  ***********/
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

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAR_Head]
(
    @DocDate nvarchar(8)
	,@ExportExcel bit
)
AS
BEGIN
    SELECT *
	FROM[dbo].[AR_Head] 
     WHERE [DocDate] = COALESCE(@DocDate, [DocDate])
	 and  [ExportExcel] = @ExportExcel
     ORDER BY [DocNum] , insertDate asc
END


GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateAR_Line] (

@RunNo int
, @ParentKey int
, @LineNum int
, @DocDate nvarchar(8)
, @ItemCode nvarchar(3)
, @ItemDescription nvarchar(20)
, @Quantity decimal(18, 2)
, @UnitPrice decimal(18, 2)
, @PriceAfterVAT decimal(18, 2)
, @VatGroup nvarchar(3)
, @WarehouseCode nvarchar(8)
, @TollWayId smallint

,@ErrMsg As Varchar(200) = '''' Output
,@ErrNum As Int = 0 Output
,@ReturnType As Int = 0 Output

)
AS
BEGIN
DECLARE @DocNum int = NULL;

	BEGIN TRY
	SET @ErrMsg = ''''
	SET @ErrNum = 0	

	IF (select count(ParentKey) 	
		FROM [dbo].[AR_Line]
		WHERE AR_Line.RunNo = @RunNo
		And AR_Line.ParentKey = @ParentKey
		And AR_Line.LineNum = @LineNum
		And AR_Line.DocDate = @DocDate
		And AR_Line.TollWayId = @TollWayId
		And ExportExcel = 0) = 0

	--BEGIN
	--SET @ReturnType = 1

	--UPDATE [dbo].[AR_Line]
	--SET  Quantity = isnull(@Quantity ,[Quantity])
	--WHERE AR_Line.ParentKey = @ParentKey
		--And AR_Line.LineNum = @LineNum
		--And AR_Line.DocDate = @DocDate
		--And AR_Line.TollWayId = @TollWayId
		--And ExportExcel = 0

	--End
	--ELSE
	BEGIN
	SET @ReturnType = 1
	INSERT INTO [dbo].[AR_Line]
           (RunNo,ParentKey , LineNum , DocDate , ItemCode , ItemDescription , Quantity , UnitPrice , PriceAfterVAT , VatGroup , WarehouseCode , TollWayId , ExportExcel , InsertDate , ExportDate )
    VALUES (@RunNo,@ParentKey , @LineNum , @DocDate , @ItemCode , @ItemDescription , @Quantity , @UnitPrice , @PriceAfterVAT , @VatGroup , @WarehouseCode , @TollWayId , 0 ,GETDATE() , null)
	END
		
	RETURN
	END TRY
	BEGIN CATCH
		IF @@Error > 0 OR @@RowCount < 1 
		BEGIN
			SET @ErrMsg = ERROR_MESSAGE()
			SET @ErrNum = ERROR_NUMBER()
			SET @ReturnType = 0
			Return	
		END
	END CATCH

	COMMIT;
END;


GO

/*********** Script Update Date: 2021-04-27  ***********/
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


/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateAR_Serial] (

@RunNo int
, @ParentKey int
, @InternalSerialNumber int
, @BaseLineNumber int
, @DocDate nvarchar(8)
, @TollWayId smallint
, @SerialNo	nvarchar(7)

,@ErrMsg As Varchar(200) = '''' Output
,@ErrNum As Int = 0 Output
,@ReturnType As Int = 0 Output

)
AS
BEGIN
DECLARE @DocNum int = NULL;

	BEGIN TRY
	SET @ErrMsg = ''''
	SET @ErrNum = 0	

	IF (select count(ParentKey) 	
		FROM [dbo].[AR_Serial]
		WHERE AR_Serial.RunNo = @RunNo
		And AR_Serial.ParentKey = @ParentKey
		And AR_Serial.InternalSerialNumber = @InternalSerialNumber
		And AR_Serial.BaseLineNumber = @BaseLineNumber
		And AR_Serial.DocDate = @DocDate
		And AR_Serial.TollWayId = @TollWayId
		And ExportExcel = 0) = 0

	BEGIN
	SET @ReturnType = 1
	INSERT INTO [dbo].[AR_Serial]
           (RunNo,ParentKey , InternalSerialNumber ,SerialNo, BaseLineNumber , DocDate , TollWayId , ExportExcel , InsertDate , ExportDate )
    VALUES (@RunNo,@ParentKey , @InternalSerialNumber,@SerialNo , @BaseLineNumber , @DocDate , @TollWayId , 0 ,GETDATE() , null)
	END
		
	RETURN
	END TRY
	BEGIN CATCH
		IF @@Error > 0 OR @@RowCount < 1 
		BEGIN
			SET @ErrMsg = ERROR_MESSAGE()
			SET @ErrNum = ERROR_NUMBER()
			SET @ReturnType = 0
			Return	
		END
	END CATCH

	COMMIT;
END;

GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAR_Line]
(
    @DocDate nvarchar(8)
)
AS
BEGIN
    SELECT *
	FROM[dbo].[AR_Line] 
     WHERE [DocDate] = COALESCE(@DocDate, [DocDate])
	 and  [ExportExcel] = 0
     ORDER BY ParentKey , LineNum asc
END


GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAR_Serial]
(
    @DocDate nvarchar(8)
)
AS
BEGIN
    SELECT *
	FROM[dbo].[AR_Serial] 
     WHERE [DocDate] = COALESCE(@DocDate, [DocDate])
	 and  [ExportExcel] = 0
     ORDER BY ParentKey ,BaseLineNumber, InternalSerialNumber asc
END


GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateflagAR_Head] 
(
  @DocDate nvarchar(8)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
	BEGIN TRY
		UPDATE [dbo].[AR_Head]
	       SET [ExportExcel] = 1
		   , ExportDate = GETDATE()
         WHERE [ExportExcel] = 0
		 --And [DocDate] = @DocDate;

		-- SET SUCCESS
		SET @errNum = 0;
		SET @errMsg = N'Success'
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateflagAR_Line] 
(
  @DocDate nvarchar(8)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
	BEGIN TRY
		UPDATE [dbo].[AR_Line]
	       SET [ExportExcel] = 1
		   , ExportDate = GETDATE()
         WHERE [ExportExcel] = 0
		 --And [DocDate] = @DocDate;

		-- SET SUCCESS
		SET @errNum = 0;
		SET @errMsg = N'Success'
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

/*********** Script Update Date: 2021-04-27  ***********/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateflagAR_Serial] 
(
  @DocDate nvarchar(8)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
	BEGIN TRY
		UPDATE [dbo].[AR_Serial]
	       SET [ExportExcel] = 1
		   , ExportDate = GETDATE()
         WHERE [ExportExcel] = 0
		 --And [DocDate] = @DocDate;

		-- SET SUCCESS
		SET @errNum = 0;
		SET @errMsg = N'Success'
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

/*********** Script Update Date: 2021-04-27  ***********/
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'111', N'Novatec Healthcare Co.,Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC015', N'บริษัท  พรีซีสชั่น เอนยีเนียริ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC016', N'บริษัท กรุงเทพคลังเอกสาร จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC017', N'บริษัท รักษาความปลอดภัย การ์ดฟอร์ซ แคช โซลูชั่นส์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC018', N'บริษัท กาญจนอินดัสตรี (1993) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC019', N'บริษัท ก้าวไว จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC021', N'บริษัท จี4เอส แคช โซลูชั่นส์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC022', N'บริษัท จุลศักดิ อินเตอร์เนชั่นแนล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC023', N'บริษัท ช้อยส อินทีเรียส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC024', N'บมจ. ซิโน-ไทย เอ็นจีเนียริ่ง แอนด์ คอนสตรัคชั่น', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC029', N'บริษัท ไทยยานยนตร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC030', N'บริษัท นู ไลฟ์ อินเตอร์เนชั่นแนล (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC031', N'บริษัท บางกอกวัสดุภัณฑ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC043', N'บริษัท ไมลอทท์ แลบบอราทอรีส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC044', N'บริษัท ยูนิค ไมนิ่ง เซอร์วิสเซส จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC045', N'บริษัท ยูพีโก้ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC046', N'บริษัท โรงเส้นหมี่ชอเฮง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC048', N'บริษัท แลททิซเวิร์ค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC049', N'บริษัท สี่พระยาการพิมพ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC050', N'บริษัท สุวพีร์ โฮลดิ้ง 2 จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC051', N'บริษัท อาร์มสตรองอุตสาหกรรม ประเทศไทย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC052', N'บริษัท อาวีว่า เดคอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC057', N'บริษัท เอ็ม. วอเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC058', N'บริษัท เอส. ซี. สมชัยบริการ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC059', N'บริษัท แอ็คซิส อินดัสทรี้ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC060', N'บริษัทไทยยานยนตร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC061', N'ผู้ใช้ทาง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC062', N'สน. ผช. ผบ.ทอ.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC063', N'บจก.วรชาติวัสดุก่อสร้าง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC036', N'บริษัท ปตท จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC037', N'บริษัท ปตท. บริหารธุรกิจค้าปลีก จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC038', N'บริษัท แป้งข้าวสาลีไทยมาร์เก็ตติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC039', N'บริษัท โปรเฟสชั่นนัล คอมพิวเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC040', N'บริษัท พรีซีสชั่น เอนยีเนียริ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC041', N'บริษัท เพ็ญบุญจัดจำหน่าย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC042', N'บริษัท เมเจอร์ซีนีเพล็กซ์ กรุ้ป จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC001', N'Central Pattana Public Company Limited', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC002', N'Central Pattana Rattanathibet Company Limited', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC003', N'DIEHL DEFENCE HOLDING GMBH', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC064', N'ห้างหุ้นส่วนจำกัด ราเม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC065', N'บริษัท พี.เอส.สยามการ์เด้นท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC066', N'บริษัท แม็กซ์ ลิ้งค์ อินเตอร์เทรด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC008', N'TMC Metal (Thailand) Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0084', N'บริษัท กาญจนสตีล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'cc0085', N'คุณนันทกา ยุกตะนันท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC009', N'ธนาคารยูโอบี จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0092', N'บริษัท พรีเมี่ยม ออโต้ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0094', N'บริษัท จ. จิรัฐิการ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT001', N'นายศุภชัย เหมือนทิพย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT003', N'น.ส.มลฤดี บัวตะคุ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT004', N'คุณธัญพล ศรีเมือง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT005', N'กองทุนสำรองเลี้ยงชีพ สินสถาพร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT006', N'คุณโสภาภักดิ์ เรืองจันทึก', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT007', N'บริษัท โกโก้ มาร์เก็ตติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT008', N'คุณนภัสกร พันธุ์แตง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'C-Coupon M', N'ลูกค้าคูปองที่MOC', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'C-Coupon P', N'ลูกค้าคูปองที่ด่าน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL001', N'นายฐานุพงศ์ ศักดิ์อมรรัชต์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL002', N'บริษัท สินมั่นคงประกันภัย จำกัด (มหาชน) สาขาสุทธิสาร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC071', N'บริษัท โตอุดม แทรเวล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC072', N'บริษัท สุวพีร์ โฮลดิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC073', N'บริษัท เอส.จี เซ็นเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC113', N'บริษัท สยามเบสท์ เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC114', N'บริษัท เอส.บี.อาร์.ซี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC115', N'บริษัท เอนเนอร์ยี่ คอมเพล็กซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0075', N'นิติบุคคลอาคารชุด ลุมพินี เพลส รามอินทรา-หลักสี่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC074', N'บริษัท พฤกษา เรียลเอสเตท จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC075', N'บริษัท จี.ซี.ฮาห์น แอนโค (ออสเตรเลีย) พีทีวาย แอลทีดี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC076', N'บริษัท โคเรดะ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'cc077', N'Prompt Serve Ltd.,Part.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC079', N'บริษัท ฝาหมินเพรส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL035', N'นางสาวยุวดี พรรัตนพันธุ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL036', N'บริษัท วิริยะประกันภัย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL037', N'บริษัท แอลเอ็มจี ประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL038', N'คุณภาณุ ลิ้มวงศ์ยุติ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL039', N'บริษัท กมลประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL040', N'บริษัท นวกิจประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO001', N'Cash', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO102', N'คุณประสิทธิ์ อันธพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO103', N'เรือนจำกลางคลองเปรม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO104', N'คุณพูลศักดิ์ อุลิศนันท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO105', N'คุณกฤษฏา รอดสดใส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO106', N'คุณปราการ สมัครการ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO107', N'คุณนกวิจิตร จันทะศูณ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC130', N'บริษัท โกลบอล รีเทล แมเนจเม้นท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC199', N'ธนาคารไทยพาณิชย์ จำกัด (มหาชน)-ประชานิเวศน์ 1', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC200', N'บริษัท เอ็น แอนด์ เอ็น แอ๊คทีฟ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC201', N'บริษัท โรงแรม ป่าตองบีช โฮเต็ล (ภูเก็ต) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC202', N'บริษัท สิริ มาร์เก็ตติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC080', N'ดีลห์ ดีเฟนซ์ โฮลดิ้ง จีเอ็มบีเอช', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC081', N'บจก.ชุมแสงดีเวลลอปเม้นท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC082', N'โครงการปฏิบัติงานวิชาการการวิจัยเอกสารวิชาการทบทวนองค์ความรู้เรื่องระบบบริการปฐมภูมิเขตเมือง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC083', N'บริษัท ลัดดา จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC223', N'บริษัท สหแพทย์เวชกรรม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC224', N'คุณศราวรรณ อินทรไพโรจน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC225', N'บริษัท  อีซูซุสงวนไทยสระบุรี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC226', N'ธนาคารไทยพาณิชย์ จำกัด (มหาชน) สาขาถนนเชิดวุฒากาศ (ดอนเมือง)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC227', N'ธนาคารไทยพาณิชย์ จำกัด (มหาชน)-เซ็นทรัลพลาซ่า', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC228', N'นาย รัฐวัฒน์ ริมชัยสิทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC229', N'สถานทูตสหรัฐอเมริกา  แผนก GSO/MOTORPOOL', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC212', N'บริษัท บอดี้เชพ คอร์ปอเรชั่น กรุ๊ป จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC213', N'โรงเรียนกุนนทีรุทธารามวิทยาคม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC214', N'ห้างหุ้นส่วนจำกัด บีดีพี เทคโนโลยี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC215', N'บริษัท สยามฟายน์เฆมี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'C-TollWay', N'ลูกค้าผู้ใช้ทาง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT-Souvenir', N'ลูกค้าของที่ระลึก', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'TT00001', N'test', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC067', N'หจก.ประชาอุทิศ 33 ทัวร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC068', N'บริษัท จันวาณิชย์ ซีเคียวริตี้ พริ้นท์ติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC069', N'บริษัท ภูเก็ต ไอแลน์ มารีน่า จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL008', N'บริษัท สินทรัพย์ประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL009', N'นายธนัย  เทียมถนอม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL010', N'นายข้าวฟ้าง บำรุง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT009', N'คุณสมัย ประชุมชัย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT010', N'คุณขวัญเรือน ศรีโหมดสุข', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT011', N'คุณเปมิกา นุชนนทรี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT012', N'คุณจรินญา โกงเหลง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT018', N'คุณวัลภา ปราบจันทร์ดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT019', N'คุณปาริชาติ ระงับโจร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT021', N'คุณประทีป แกล้วทนงค์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT027', N'คุณปราณี ประทับศิลป์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT028', N'คุณเสาวณีย์ มณีฉาย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT029', N'คุณเนยาวีร์ ตระกูลรัมย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT030', N'คุณมาลา เพชรกอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL003', N'บริษัท คูเนีย ประกันภัย (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL004', N'บริษัท กรุงไทยพานิชประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL005', N'บมจ. วิริยะประกันภัย สาขาวิภาวดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL006', N'บริษัท ประกันภัยไทยวิวัฒน์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL007', N'บริษัท ไทยพาณิชย์สามัคคีประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT036', N'คุณศิริวัฒน์ ขอบุตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT037', N'คุณมนตรี ปุณวัฒนา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT038', N'คุณวิทวงศ์ กาญจนชมภู', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT039', N'คุณสุชาตุ วงศ์ลุประสิทธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC085', N'นายแพทย์สรายุทธ์ บุญชัยพานิชวัฒนา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'cc086', N'บริษัท เคเคเอ็น คอมมูนิเคชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT044', N'บริษัท วงศ์บราเดอร์ อินเตอร์เทรด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT045', N'บริษัท โกรว์ริชเอ็นเทอร์ไพรซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT046', N'บริษัท รุคส์มารีน่าตราด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC011', N'นายวรชัย หวังปิติพาณิชย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC012', N'นายสมชาย เบญจรงคกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC013', N'นิติบุคคลอาคารชุด ลุมพินี คอนโดทาวน์ รามอินทรา-หลักสี่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC014', N'นิติบุคคลอาคารชุดลุมพินี วิลล์ รามอินทรา-หลักสี่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'C-SmartP', N'ลูกค้าค่าผ่านทางThaiSmartPurse', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC360', N'บริษัท มายน์ เอเซีย จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC361', N'บริษัท อิมพลานท์คาสท์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC362', N'บริษัท ไทยเบฟเวอเรจ รีไซเคิล จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT051', N'บริษัท เอ็นจีวี แอนด์ แอลพีจี ออโต้แก๊ส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT052', N'นายเอกชัย ว่อมละออ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT053', N'สถานีตำรวจวิภาวดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT054', N'คุณธนวรรณ ศรีผิว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT055', N'คุณฐิตินันท์ อันยงค์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT056', N'คุณสุนิสา ภูครองหิน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT057', N'คุณศัลยลักษณ์ แสนสมรส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT058', N'คุณสมฤทัย ตั้งอั้น', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL015', N'บริษัท ธนชาตประกันภัย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL016', N'พ.ต.ท.ชูศักดิ์ เคทอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL017', N'คุณมาลัย บุญผ้าทิพย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL018', N'บริษัท เลิศลอย เมทัลซีท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL019', N'บริษัท เอเชียประกันภัย 1950 จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL020', N'นายเจริญ คำเปรม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL021', N'บริษัท เชิดชัยมอเตอร์เซลส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC010', N'นายกุลวัฒน์ เจนวัฒนวิทย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT059', N'คุณกมลวรรณ ตันติสุขารมย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT060', N'คุณบุษบง ดินม่วง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT061', N'บริษัท เอเซอร์ คอมพิวเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0095', N'บริษัท จินดาสุขคอมเมอร์เชียล (1980) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0096', N'หจก. เคทีพี คอนเทนเนอร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0097', N'CivilPark International Co.,Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0098', N'บริษัท ปูนซีเมนต์เอเชีย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC0099', N'บริษัท กรุงเทพ โอเอ คอมส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL022', N'บริษัท ไทยศรีประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL023', N'บริษัท นิวเทรนด์ ดีเวล๊อปเมนท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL024', N'บริษัท วิริยะประกันภัย จำกัด (มหาชน)สาขาดอนเมือง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'cc087', N'คุณดารารุ่ง จีระพันธุ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'cc088', N'บริษัท เคหพัฒนา จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT067', N'คุณอภิสร  ขาวเกตุ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT068', N'คุณพรเทพ ทรัพย์ศรี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT069', N'คุณนวพล แสนมาตย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT070', N'คุณมนู สุขสมบูรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT075', N'คุณพุทธพล ธรรมารมณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT076', N'คุณประยุทธ สิทธิไชย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT077', N'คุณนฤชา  วิชัยบรรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT083', N'คุณเพทาย รักษาเขตต์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT084', N'คุณยสวินทร์ กาญจนจิตติ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT085', N'คุณรณชัย สุขทิศ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT086', N'คุณจิรัฏฐ์ ชวพัฒน์จิรกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL025', N'บริษัท กรุงเทพประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL026', N'บริษัท เจ้าพระยาประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL027', N'นางนภา อัศวจำรูญ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT022', N'คุณอรอนงค์ เขมกานนท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT023', N'คุณกนกพร แสงอรุณรัตน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT024', N'คุณปราโมทย์ สิงหเดช', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT025', N'คุณคมสันต์ นุ่มพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT026', N'คุณประจวบ ไกรพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR001', N'บริษัท ทศกัณฐ์ ฟิล์ม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR002', N'บริษัท อาเขต โปรดักชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO108', N'บริษัท กรีนไลท์ อินเตอร์เนชั่นแนล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO109', N'คุณโกศล ทับทิมเขียว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO110', N'คุณบังอร  ทนันชัย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO111', N'คุณวิรัช สุดงาม', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO112', N'บริษัท ซีพีออลล์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO113', N'บริษัท ไทยสมาร์ทคาร์ด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO114', N'คุณสุภารัตน์  พุฒซ้อน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC203', N'บริษัท 3 เอ มาร์เก็ตติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC204', N'บริษัท ไพร้ซวอเตอร์เฮาส์คูเปอร์ส เอบีเอเอส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC205', N'หจก.ที.ไอ.พี.ออโต้พาร์ท', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC206', N'บริษัท บางกอกการ์ด เซอร์วิสเซส 2555 จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC207', N'บริษัท ไอ ลอนดรี้ เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC208', N'บริษัท โซล่าร์ เอวีเอชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC094', N'นางสาวศราวรรณ  อินทรไพโรจน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC096', N'คุณกรวุฒิ   ชิวปรีชา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC097', N'คุณปราณี  ประทับศิลป์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC098', N'หจก.ส.การปะปา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL011', N'บริษัท ประกันคุ้มภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL012', N'บริษัท นำสินประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL013', N'บริษัท แอกซ่าประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL014', N'บริษัท โตเกียวมารีนศรีเมืองประกันภัย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC025', N'บริษัท โตชิบา สตอเรจ ดีไวส์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC026', N'บริษัท ทางยกระดับดอนเมือง จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC027', N'บริษัท โททอลลี่ บางกอก จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC028', N'บริษัท ไทยนครพัฒนา จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC116', N'บริษัท ทรี พี-แอคเซส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'cc119', N'บริษัท นิว ไลฟ์ เวิลด์ไวด์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC120', N'บริษัท แอดวานซ์ ฟาร์มาซูติคอล แมนูเฟคเจอริ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC121', N'บริษัท วีเอส เคม (1970) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL069', N'คุณประเสริฐ  เขือนอก', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL070', N'นายวิสิทธิ์  บัวผัน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL071', N'บริษัท ส.สิริขนส่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL072', N'บริษัท อาคเนย์ประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL073', N'บริษัท สินมั่นคงประกันภัย จำกัด (มหาชน)  สาขาดอนเมือง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL074', N'คุณคนึง  วงษ์สมิง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL075', N'นางสาวพัชรินทร์  บุญยะกาญจน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL028', N'บริษัท มิตรแท้ประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL029', N'นายสิทธิโชค ช.เจริญยิ่ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL030', N'นายธานัท  บุญจือ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL031', N'บริษัท อินทรประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL032', N'บริษัท ไอ ลอนดรี้ เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL033', N'บริษัท เอราวัณประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL034', N'หจก.ฟ้าประทานพร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO327', N'คุณศิรินันท์ หนูด้วง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO328', N'คุณอุไรวรรณ เมฆอัคฆกรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO329', N'บริษัท ริโก้ เซอร์วิสเซส (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO330', N'บริษัท เทสโก้ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO331', N'นายปุณชัย  พ่วงครุธ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO332', N'บริษัท อินเตอร์เนชั่นแนล เอ็นจิเนียริ่ง คอนซัลแต้นส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC366', N'บริษัท อาร์โก้ แอโรเท็คทรอนิคส์ จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC367', N'ห้างหุ้นส่วนจำกัด ด๊อกเตอร์แก๊ส เซอร์วิส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC369', N'บริษัท ธรรมสรณ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC370', N'บริษัท อะกรี เวิลด์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC371', N'บริษัท พาร์ค ซิตี้ วิลล์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL094', N'บริษัท สมโพธิ์ เจแปน นิปปอนโคอะ ประกันภัย (ประเทศไทย) จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL095', N'คุณศุภวิชญ์ ประเสริฐ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL096', N'นายเลิศสักดิ์ พุทธรม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL097', N'บริษัท เอลเอ็มจี ประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL098', N'นายไมตรี เชี่ยวชาญ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL099', N'บริษัท ยูไนเต็ดไวน์เนอรี่ แอนด์ ดิสทิลเลอรี่ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT092', N'คุณธีรพล ศรีเลขา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT093', N'คุณวิศรุต ศรีวรศานต์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT094', N'คุณกรณ์ บุญรอด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT095', N'คุณละออง สายคำภา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO333', N'บริษัท เอ็ม เอ เอ คอนซัลแตนท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO334', N'บริษัท เพอโซเน็ท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO335', N'คุณหัทยา วิมลประสาร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL100', N'คุณสมยศ บุสพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL101', N'คุณสมศักดิ์ สรประสิทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL102', N'คุณบรรเทิง นาใฮ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL103', N'คุณชูศิลป์ ทสไกร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL104', N'คุณอัญลี สุวรรณกิจ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL105', N'คุณทเนตร โพธิ์นาค', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC442', N'บริษัท เวสเทิร์น ดิจิตอล (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC443', N'บริษัท นิเด็ค โคปาล (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC444', N'บริษัท เอ็ม พิคเจอร์ส เอ็นเตอร์เทนเม้นท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC445', N'คุณนรวิตต์  กิติกรอรรถ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC446', N'คุณธกฤษณ์  จรัสธนกิจ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC447', N'บริษัท เอ็กโคแล็บ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO449', N'คุณภัควลัญชญ์  แสงน้ำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO450', N'คุณจำนวน  แจ่มแจ้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO451', N'คุณพัชรา  พิริยสิทธางกูร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO452', N'คุณนารีรัตน์  เผ่าม่วง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO453', N'คุณธิดารัตน์  สามลา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO454', N'คุณอุ่นเรือน  เพ็งพรม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO455', N'คุณกรรณิการ์  แอบเพชร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO456', N'คุณวิเชเชษ แผ่นทอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO457', N'คุณกลีบบุปผา  ชนะวงศ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC104', N'บริษัท ทอสเท็ม ไทย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC105', N'คุณธนเกียรติ  ธรรมนิยม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC106', N'บริษัท เพน-เอ็ม โลจิสติกส์(ไทย)จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC100', N'บริษัท พี.ที.ทาวน์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC1001', N'test', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC101', N'บริษัท สยามปาร์ค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC102', N'บริษัท ปราณลี คอร์ปอเรชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC103', N'บริษัท จันวาณิชย์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC109', N'บริษัท แสงอุดมไลท์ติ้งเซ็นเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC110', N'บริษัท อาร์ทีเอช คอนสตรัคชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC111', N'บริษัท อินเตอร์เนชั่นแนลโพรเจค แอดมินิสเตรชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC112', N'บริษัท เอออน กรุ๊ป(ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'cc122', N'โครงการวิจัย นโยบายการคุ้มครอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC123', N'บริษัท อิทธิพร อิมปอร์ต จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC124', N'Tracteble Engineering Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC125', N'บริษัท เอ็นพี เทเน่ อิมปอร์ต เอ็กซ์ปอร์ต จำกัด', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC127', N'บริษัท นิเด็ค แมทชีนเนอรี่ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC128', N'Nidec Machinery Corporation', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT096', N'คุณชไมพร อินทรีสุข', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT097', N'บริษัท เทพพัฒนากระดาษ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT099', N'นายพูนศักดิ์ สีดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT100', N'คุณวิระพรรณ วรนันท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT101', N'บริษัท อินฟินีตี้เปเปอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL041', N'บริษัท เมืองไทยประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL042', N'บริษัท ไอโออิ กรุงเทพ ประกันภัย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL043', N'บริษัท ทิพยประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR007', N'ห้างหุ้นส่วนจำกัด ไอริณ ดิสทริบิวชั่น', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR008', N'บริษัท แอดวานซ์ อินโฟร์ เซอร์วิส จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR009', N'บริษัท วัน-ทา-รา จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR010', N'บริษัท รสา พร็อพเพอร์ตี้ ดีเวลลอปเม้นท์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR011', N'บริษัท ดู บาย เดย์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR012', N'บริษัท เนคทาร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC090', N'บริษัท เฮงเกอร์ เอ็ม.เอฟ.อาร์. จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC091', N'บริษัท ศรีสวัสดิ์พาวเวอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC092', N'บริษัท ไทยยูโรโค๊ต จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC093', N'บริษัท พรีเมี่ยม ออโตพลัส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR003', N'บริษัท ตาโปรดักชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR004', N'บริษัท ปฏิวัติ ฟิล์ม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR005', N'บริษัท มู อัน จา อิ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR006', N'บริษัท แอดเวอร์ไทซิ่ง โปรดักชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL048', N'บริษัท ไปรษณีย์ไทย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL049', N'คุณจุฆามาศ จงรักษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL050', N'บริษัท เทเวศประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC209', N'บริษัท วิภาวดีรังสิตโฮเต็ล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC210', N'บริษัท ฉอยชิว จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC211', N'บริษัท เภสัชกรรมนครพัฒนา จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO115', N'คุณสุรินทร์ บัวเขียว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO116', N'คุณสุทัศ  นิระโคตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO117', N'คุณอภิศักดิ์  จุลเนียม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO118', N'คุณสมถวิล  กระแสสินธุ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO119', N'คุณสมพร  ทันแจ้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO120', N'คุณกรสิณี  คงอินทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO121', N'คุณธนิตา  โพธิอินทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO122', N'คุณอทิตา  วรรณรัตน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO123', N'คุณอัญกัญญ์  ดีวัน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO124', N'คุณมนูศักดิ์  เรืองศรีศักดิกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO125', N'คุณสมพร  เรืองขำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO126', N'คุณสมพงษ์  อ่วมส้มกิจ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO127', N'คุณบุญชนะ  ตรีดิษฐ์  อุดมพร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO128', N'คุณณรงค์  งามสอาด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT087', N'คุณสุภาพร นพคุณ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT088', N'คุณศิรินันท์ รัตนพิพัฒน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT089', N'คุณวรวัฒก์ ศรีนาค', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT090', N'คุณประเสริฐ สินอยู่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT091', N'คุณกิตติ สีดาพาลี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT031', N'คุณกมลลักษณ์ ประทับศิลป์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT032', N'คุณอำนาจ ทิมพงษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT033', N'คุณวนิดา ทิมพงษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT034', N'คุณวีรดา บุญเปี่ยม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT035', N'คุณภาดร ศรีสังข์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO129', N'คุณอารมย์  กลิ่นหอม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO130', N'คุณเกรียงศักดิ์  พึ่งนาม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO131', N'บริษัท ไทรทัน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO132', N'คุณณัฐพล  ไพศาลธนกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO133', N'คุณจักรกฤช  ตามวงศ์วาลย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO134', N'คุณอมรเทพ  แตงฤทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO135', N'คุณอุดมศักดิ์  ทิพย์สมบัติ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC216', N'คุณธีรพงษ์  นาทีกาญจนลาภ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC217', N'บริษัท เทเน่ เทรดดิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC218', N'บริษัท เอส เคม กรุ๊ป จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL055', N'คุณวิกรม ทองพูล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL056', N'นายเจิมพล อำมฤต', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL057', N'ร.อ.ธนัช วรรณสังข์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL058', N'บริษัท นำสินประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL059', N'คุณดนัย วัฒนสมบัติ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL060', N'คุณวะดล กันทำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL061', N'บริษัท นิวแฮมพ์เชอร์ อินชัวร์รันส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO136', N'คุณสุรชาติ  สงเคราะห์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO137', N'คุณอนุวัฒน์  สิทธิไชย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO138', N'คุณมะลิวัลย์  ตรีพุทธ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO139', N'คุณวิรัตน์  ฉัตรัตติกรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO140', N'คุณเกริกไกร  แสงหงษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO141', N'คุณธานินทร์  มีประเสริฐ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO142', N'คุณปาณิศรา  สอนใจ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT071', N'คุณสำเริง บัวเขียว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT072', N'คุณภัทรศยา รัตนสีหา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT073', N'คุณนพ ศรีเกษ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT074', N'คุณธงชัย นิระโคตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL062', N'คุณสวิทธิ์  ทองดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL063', N'คุณจิตตรี  บุตรทวี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL064', N'คุณจักรกฤษ ลิ่มสลักเพชร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL065', N'คุณธีรนันท์  วินทไชย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL066', N'บริษัท วิริยะประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL067', N'คุณเสถียร  พูลสวัสดิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL068', N'บริษัท ศรีอยุธยา เจนเนอรัล ประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO143', N'คุณบุญส่ง  วงศ์บุษยกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO144', N'คุณชาคริต  อุฤทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO145', N'บริษัท แฟกซ์ ไลท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC219', N'คุณสุรศักดิ์  บูรณตรีเวทย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC220', N'บริษัท ศรีจันทร์สหโอสถ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC221', N'บริษัท อีซูซุสงวนไทยกรุงเทพ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC222', N'บริษัท เอส เอ็ม ซี โลจิสติกส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC230', N'บริษัท ป่าตองบีชโฮเต็ล (ภูเก็ต) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC231', N'บริษัท ดูคาทิสติ จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC232', N'บริษัท อีซูซุสงวนไทยสระบุรี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC233', N'บริษัท อิเมอร์สัน เนทเวอร์ค พาวเวอร์ (ประเทศไทย)จำกัด', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC234', N'คุณปราณี  สืบวงศ์ลี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC235', N'บริษัท เวิร์คพอยท์ เอ็นเทอร์เทนเมนท์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC032', N'บริษัท บีจีที คอร์ปอเรชั่น จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC033', N'บริษัท บีเจ เซอร์วิส อินเตอร์เนชั่นแนล (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC034', N'บริษัท บีพี เจนเนอเรเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC035', N'บริษัท เบอร์ลี่ ยุคเกอร์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO150', N'คุณอัจฉรา เจริญพร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO151', N'คุณธัญลักษณ์  ตั้งพงศ์สิริกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO152', N'คุณศราวรรณ  อินทรไพโรจน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO153', N'คุณบัณฑิตา  ถิรทิตสกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'Co154', N'คุณชัยชนะ  แซ่เอี้ยว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO155', N'คุณบุษกร สุขกลับ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO156', N'บริษัท กรุงเทพประกันชีวิต จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO157', N'คุณบุญชนะ ตรีดิษฐ์  อุดมพร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO158', N'บริษัท กรุงไทยพานิชประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO159', N'คุณสุเทพ  ธาระวาส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO160', N'คุณอโนมา  อุฤทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO161', N'คุณนิธินันท์  อติยศพงศ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL076', N'คุณนราธร ป้องรัตนกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL077', N'คุณสมพงษ์ บุญกุ้ม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL078', N'คุณอดุลย์  ตั้งสุวรรณ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL079', N'บริษัท ไทยพัฒนาประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL080', N'บริษัท สามัคคีประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL081', N'คุณวัชระ  จินดาสมุทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC053', N'บริษัท อินเตอร์เนชั่นแนล เฟลเวอร์ส แอนด์ เฟรแกรนซ์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC054', N'บริษัท เอ.แอนด์ เค.ไวร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC055', N'บริษัท เอกวันวิทยา จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC056', N'บริษัท เอ็ม ลิ้งค์ เอเชีย คอร์ปอเรชั่น จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC236', N'คุณสุรชัย  งามสมภาพ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC237', N'คุณธานินทร์  พานิชชีวะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC238', N'บริษัท พี.เซค.เอ็นเตอร์ไพรส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC239', N'บริษัท ดิ เอราวัณ กรุ๊ป จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC240', N'หจก. เอโอดับเบิ้ลยู ซัพพลาย แอนด์ เซอร์วิส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC241', N'คุณศิวิไล แสงน้ำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO166', N'คุณธวัชชัย  ปิ่นเพ็ชร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO167', N'บริษัท ชินโป เอ็นจิเนียริ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO168', N'บริษัท สยามซิตี้ประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO169', N'คุณกันทิมา  ติยะภูมิ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO170', N'คุณณรงค์ชัย  มาลา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO171', N'คุณจเร  โสมเภาว์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO172', N'คุณเอกวิทย์  ขุนทิพย์ทอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC242', N'คุณเอกวิทย์ ขุนทิพย์ทอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC243', N'คุณจเร  โสมเภาว์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC244', N'คุณอนุสรณ์  จันทร์สัมฤทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC245', N'บริษัท ไบรท์ ทีวี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC246', N'ห้างหุ้นส่วนจำกัด เพอร์เฟค เบสท์ ซัพพลาย (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC247', N'บริษัท ดอคคิวเมนท์ พาร์เซล เอ็กซ์เพรส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT013', N'คุณนครินทร์ ผอมจีน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT014', N'คุณณัฐรุจ โตประภัสสร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT015', N'คุณสุพรรณี อรรคโคโย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT016', N'คุณทองขัน ศรีมาเกิด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT017', N'คุณสุมาลี กันกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT062', N'คุณธวัชชัย ปิ่นเพ็ชร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT063', N'คุณบรรดิษฐ์ มั่นจิตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT064', N'คุณชัยพร งามชื่น', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT065', N'คุณไพรัช รอดโฉม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT066', N'คุณยะทิม หวันหม๊ะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO173', N'คุณศิวิไล  แสงน้ำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO174', N'คุณอนุสรณ์  จันทร์สัมฤทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO175', N'คุณประกายพิมพ์  ตันรังสรรค์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL082', N'ร.ต.ตนัย  วัฒนสมบัติ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL083', N'คุณมงคล ชูฉ่ำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL084', N'บริษัท เคเอสเคประกันภัย (ประเทศไทย) จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL085', N'คุณไพบูลย์  รักคำมี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL086', N'คุณจุรินทร์ จันทร์แสง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL087', N'บริษัท ธนชาตประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO2035', N'คุณวัชระ  จินดาสมุทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO204', N'บริษัท หลักทรัพย์ ภัทร จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO205', N'บริษัท ทริปเปิล คอม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO206', N'บริษัท หนึ่งล้านไอเดีย ดีไซน์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO207', N'คุณธีรนุช เรืองสวัสดิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO208', N'คุณธานินทร์  พานิชชีวะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO209', N'บริษัท สถาปนิก ทะโย หรรษา แอนด์ แอสโซซิเอท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO210', N'พนักงานบริษัท เอ็นอีซี คอร์ปอเรชั่น (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO181', N'คุณธนัชชา  วงษ์เจริญสิน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO182', N'บริษัท ราจา แอนด์ ทานน์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO183', N'ธนาคารธนชาต จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO184', N'บริษัท เจริญกิจจงเสถียร จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO185', N'ธนาคารกสิกรไทย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO186', N'บริษัท เบต้า อินเตอร์กรุ๊ป จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO187', N'ธนาคารแลนด์ แอนด์ เฮ้าส์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO188', N'บริษัท เอ็นอีซี คอร์ปอเรชั่น (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL051', N'บริษัท พุทธธรรมประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL052', N'คุณชาติชาย ดิเรกชัย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL053', N'บริษัท เอ็ม เอส ไอ จี ประกันภัย (ประเทศไทย) จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL054', N'คุณอิทธิชัย  งามไตรไร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO189', N'บริษัท เบเคอร์ แอนด์ แม็คเค็นซี่ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO190', N'บริษัท เบสท์ทรัค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO191', N'คุณภูมิใจ  ขำภโต', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO192', N'บริษัท เมโทรซิสเต็มส์ คอร์ปอเรชั่น จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO193', N'คุณวนิดา  กระตุฤกษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO194', N'บริษัท ฮิวแมนิก้า จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO195', N'บริษัท เดอะ ลีจิสท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO197', N'คุณนวพร  โพธิ์ไทย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO198', N'บริษัท ทิสโก้ โตเกียว ลิสซิ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO199', N'บริษัท ควอลิตี้ เร้นท์ อะ คาร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO200', N'บริษัท ไทยศรีประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO201', N'บริษัท สีมาธานี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO202', N'บริษัท คาเธ่ย์ ลีสแพลน จำกัด(มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO203', N'บริษัท ควินตัสอุตสาหกรรม จำกัด', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO211', N'ผู้ไม่ประสงค์ออกนาม (กฐินสาย คุณกมลลักษณ์  ประทับศิลป์)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO212', N'บริษัท ธนชาตประกันชีวิต จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO213', N'สมาคมคนพิการทางการเคลื่อนไหวสากล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO214', N'คุณนัยณา  ม่วงชู', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO215', N'คุณประยงค์  มุขวัตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO216', N'นายชัยวัฒน์  ศรีสะอาด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO217', N'นายสุเชษฐ  เตียวต่อสกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO218', N'นายอำนวย  แสงสว่าง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO219', N'นายอรรคเดช  ไกลที่พึ่ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO220', N'นายเชน  กระสังข์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO221', N'นายสังคม  นนทมาตย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO222', N'นายเศวตชัย  ฐิตะกาญจน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO223', N'คุณกิตติชัย  สามารถ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO224', N'คุณทิพย์อัมพร  ธนพัฒน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO225', N'คุณพัชนี  วงศ์วานิช', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO226', N'นางสาวจารุวรรณ  พนมสินธุ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO227', N'สำนักงานประกันสังคมกรุงเทพมหานครพื้นที่ ๒', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO228', N'คุณจริยา จรัสกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO229', N'คุณธนกร ชื่นชูศรี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO230', N'คุณภาวดี  สินธิพงษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO231', N'คุณรำไพ ชมภู่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO232', N'คุณพนม ใจตรงกล้า', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO233', N'สำนักงานพัฒนาวิทยาศาสตร์และเทคโนโลยีแห่งชาติ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC248', N'บจก.ชัยเจริญพืชผลเอ็กสปอร์ต-อิมปอร์ต', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC249', N'หจก.ยูนิค สตาร์ เทรดดิ้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC250', N'บริษัท ธนชัยเจริญ กรุ๊ป จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC251', N'บริษัท นีโอ ดริ๊งค์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC252', N'ห้างหุ้นส่วนจำกัด ซอฟเท็ค ไฟร์ซีเคียว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC253', N'บริษัท อินเตอร์เนชั่นแนล เฟลเวอร์ส แอนด์ เฟรแกรนซ์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC004', N'Document Parcel Express Co.,Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC005', N'Microsoft (Thailand) limited', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC00575', N'test', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC006', N'PITI DISTRIBUTION SYSTEM CO,.LTD.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC007', N'RUAG AEROSPACE SERVICE GMBH', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC254', N'มูลนิธิเพื่อสุขภาพฯ โครงการป้องกันการแท้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC255', N'บริษัท เอ แอนด์ เจ บิวตี้โปรดักส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC256', N'บริษัท เสาธงชัย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC257', N'บริษัท อินเทลลิเจนท์ ไอทีโซลูชั่นส์แอนด์เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC259', N'บริษัท แนเชอรัล พาร์ค จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC260', N'บริษัท  ฟูจิเซโกะ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC261', N'บริษัท แอสเสท เวิรด์ ลีเฌอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC262', N'RJ Supply and Service Co.,Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC263', N'โรงพยาบาลจุฬาภรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC264', N'คุณสุเทพ  ธาระวาส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC265', N'บริษัท พลัสวัน ออโต้ พาร์ท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC266', N'บริษัท ไอ อินเตอร์เทรด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC267', N'บริษัท แอ็คเท็ค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC268', N'บริษัท แอลจี เคม ไลฟ์ ไซเอนเซส (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC273', N'บริษัท เวิลด์ แทร็คเตอร์ (1996) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC274', N'บริษัท อุตสาหกรรมนมไทย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC275', N'บริษัท ไซโก้ อินสทรูเม้นท์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC276', N'บริษัท เวิลด์แนชเชอรัลฟู้ด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC277', N'ห้างหุ้นส่วนจำกัด พร้อม เซิร์ฟ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC278', N'บริษัท วรรัฐ ศุภโชค อาคิเทค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC279', N'บริษัท ซีพี รีเทลลิงค์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC280', N'บริษัท วี.เอ แอนด์ ซันส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC281', N'บริษัท ชัยโกมลธุรกิจ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC282', N'บริษัท ไอ-ซีเคียว จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC283', N'บริษัท นิชชิน อีเลคทริค (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC284', N'บริษัท ไดซิน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO239', N'คุณอรรถนนท์  ก้อนคำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO240', N'คุณชาตรี  แตงนารา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO241', N'คุณปรางแก้ว  ทองดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO242', N'คุณเอกพล  เพชรศรีช่วง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO243', N'คุณถนัด ลาตุย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO244', N'คุณปาจรีย์  พงษ์ไทย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO245', N'บริษัทเอ็มจี เซลส์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC285', N'บริษัท เฟิสท์ ทรานสปอร์ต จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC286', N'บริษัท ยูโรเอเซียติค สยาม  จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC287', N'บริษัท ทางด่วนกรุงเทพ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC288', N'บริษัท ฟูจิตสึ  (ประเทศไทย) จํากัด  (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC289', N'บริษัท ไฟฟ้าอุตสาหกรรม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC290', N'บริษัท ไบเออร์ไทย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC291', N'บริษัท  ออลเน็กซ์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC292', N'คุณรำไพ ชมภู่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC293', N'บริษัท เอสจี เอสเตท แมเนจเม้นท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC294', N'บริษัท เพียงขวัญคอนซัลแตนท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC295', N'บริษัท บีเจซี แพคเกจจิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC296', N'บริษัท บี.โอ.อุตสาหกรรม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT078', N'คุณศิรินาถ พูลสวัสดิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT079', N'คุณสุรชัย เลิศวีระศักดิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT080', N'คุณบุญกว้าง หงษา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT081', N'คุณสมบัติ ป้องเรือ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT082', N'คุณสิทธิลักษณ์ ผางดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO246', N'คุณศักดา  สุทธิธนานนท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO247', N'คุณกานดา พิมพ์ทอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO248', N'คุณสุมาลี  นิยมเหมาะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO249', N'คุณพิรุณรัตน์  ชาญพ่วง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO250', N'คุณสุนันทา  ชัยสิทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO251', N'บริษัท แฟคซิลิตี้ แมนเนจเมนท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC297', N'บริษัท โควิก เคทท์ อินเตอร์เนชั่นแนล (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC298', N'บริษัท มาลาคี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC299', N'บริษัท บีเจซี แพคเกจจิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC300', N'บริษัท กรณิศ ก่อสร้าง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC301', N'บริษัท ยูซิตี้ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC302', N'บริษัท หงษ์ทองเอ็นเตอร์เทนเม้นท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL088', N'บริษัท โตเกียวมารีนประกันภัย (ประเทศไทย) จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL089', N'คุณวรพจน์ มีสง่า', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL090', N'นายคำบุ บัวใหญ่รักษา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL091', N'คุณพหล โอ่เจริญ', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL092', N'คุณจันทร ตยางคนนท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL093', N'บริษัท ตะวัน เครน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO252', N'บริษัท ล็อกซเล่ย์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO253', N'บริษัท ไทยซีคอมพิทักษ์กิจ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO254', N'คุณจุฬาลักษ์  ชนะบุญ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO255', N'บริษัท เอ็ม เอฟ อี ซี จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO258', N'บริษัท บี.อาร์.เอ็น. เอ็นเตอร์ไพรส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO259', N'บริษัท เอเอ็มอาร์ เอเซีย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO2598', N'คุณทัศนันท์ ฉุยกลม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC303', N'บริษัท หงษ์ทองทรานสปอร์ตคอร์ปอเรชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC304', N'บริษัท หงษ์ทองทรานสปอร์ต จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC305', N'บริษัท เอ็นเทค แอสโซซิเอท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO256', N'บริษัท ฮันนี่เวลล์ ซิสเต็ทส์ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO257', N'บริษัท จีเนียส ทราฟฟิค ซีสเต็ม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO260', N'บริษัท เอ็นอีซี คอร์ปอเรชั่น (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO261', N'บริษัท วันดีทู กรุ๊ป จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO262', N'คุณกิติวุฒิ มั่นคง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO263', N'คุณภัทรนิษฐ์ ตั้งสวามิภักดิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO264', N'คุณพัชรพล  เรืองมณี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO265', N'คุณสาวิตรี กล่อมสวัสดิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO266', N'คุณทัศนัย  ศรีหา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO267', N'คุณสมรรัตน์  ทรัพย์สอน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO268', N'คุณทองเจริญ บุสดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO269', N'คุณพานี ศรีจักรินทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO270', N'คุณธนาจักร์  น่วมอยู่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO271', N'คุณสุกัลยา  สุวรรณธำรงกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO272', N'คุณดี  จันทร์กระแจะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO273', N'คุณปิยะนุช  ชายะตานันท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO274', N'คุณสุรพล  อำพันแสง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO275', N'คุณคมสัน  รุ่งเรืองสรการ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO276', N'คุณปรัชญา แสนฝั้น', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO277', N'คุณเชน  กระสังข์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO278', N'คุณเชาวฤทธิ์  เกรงพา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO279', N'คุณเยาวลักษ์ณ์  ถ้ำทองถวิล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO280', N'คุณกัมปนาท  รัตนวราหะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO281', N'คุณวัชรพล  ศักดิ์นนท์ชัย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO282', N'คุณพินัดดา  พัวพัฒนกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO283', N'คุณจรัสศรี  ภูชิตานุรักษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO284', N'คุณปราณี  นิลดำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO285', N'คุณยศนันท์  ศิริวรรณ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO286', N'คุณปิยนัน นิลคำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO287', N'ว่าที่ ร.ต.นิติศาสตร์  บุษบรรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO288', N'บริษัท สยาม ริช สแควร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO289', N'คุณเมธี  ศรีรุ่งนภาพร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC306', N'บริษัท เอส.เอ็ม.เค.ซี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC307', N'บริษัท โฮยาเลนซ์ ไทยแลนด์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC308', N'บริษัท เอสเอฟซี เอกเซลเล้นซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC309', N'บริษัท ชัยพัฒนาการขนส่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC310', N'บริษัท เคมีแมน จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC311', N'บริษัท เคอร์รี่ อินกรีเดียนท์ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC312', N'ห้างหุ้นส่วนจำกัด เต๊นท์อ๋าธุรกิจ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC313', N'PDR (2014) Co.,LTD', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC314', N'บริษัท ริช แอนด์ ที จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC315', N'บริษัท เจริญราษฏร์ ขนส่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC316', N'บจก.ไทยสงวนโคราช', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC317', N'บริษัท นำโชค เพาเวอร์ วัน เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC318', N'บริษัท จัดหางานไทย นิปปอน เทรนนิ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC319', N'บริษัท สำนักกฎหมายสมเกียรติ แอนด์ แอสโซซิเอท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC320', N'บริษัท คริมสัน คอนซัลติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC321', N'บริษัท ไทยออยล์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC322', N'บริษัท ลัคกี้มิวสิค จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC323', N'บริษัท เดอะ สยามมิส เซอร์วิสเซส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC324', N'บริษัท เฟมีน่า เลซ อินเตอร์เนชั่นแนล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC325', N'บริษัท วรรณ ดี.ดี. จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC326', N'บริษัท ร้อกเวิธ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC327', N'บริษัท เวิลด์เฮาส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC328', N'บริษัท เวิลด์ปิกเม้นท์อินดัสตรี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC329', N'คุณพหล โอ่เจริญ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC330', N'บริษัท ช.การช่าง จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC331', N'บริษัท อเมริกัน ไต้หวัน ไบโอฟาร์ม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC332', N'บริษัท บูห์เล่อร์ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC333', N'บริษัท ลูเครทีฟ วรรณ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC334', N'บริษัท แอสตราโก เมดิเคิล เน็ตเวิร์คส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC335', N'โครงการพัฒนารูปแบบเครือข่ายบริการปฐมภูมิเขตเมือง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO300', N'บริษัท เลิศลอย เมทัล ชีท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO301', N'บริษัท สแตนดาร์ด เอ็นจิเนียริ่ง แอนด์ เทรดดิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO302', N'คุณนงนุช ธรรมรักษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO304', N'คุณจารุดา หลักหิน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO305', N'คุณณัฐพล ฉัตรโชติกวงศ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO306', N'คุณชยางกูร  วัชร์ชนโชติ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO290', N'คุณยุภา ทันแจ้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO291', N'คุณวินัย จันทร์แจ้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO292', N'บริษัท แอ๊ทลาส ยูไนเต็ด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC336', N'บริษัท สยามเจ้าพระยา โฮลดิ้งส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC337', N'บริษัท ไทยเบเวอร์เรจ แคน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC338', N'AEROFLUID GROUP', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC339', N'บริษัท เฟรนลี่กรุ๊ปส์ โลจีสติ๊ก จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC340', N'บริษัท ดับเบิ้ล พลัส พร๊อพเพอร์ตี้ เซอร์วิสเซล (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC341', N'บริษัท มาดี สำนักงานกฎหมายและทนายความ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO298', N'บริษัท ศ.เศรษฐพร ทราฟฟิค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO299', N'หจก.ปัญจะธนรัตน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC342', N'บริษัท โนเบล เอ็นซี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC343', N'บริษัท สุวพีร์ ธรรมวัฒนะ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC344', N'บริษัท ไทยน้ำทิพย์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC345', N'บริษัท ซีวิลดีไซน์แอนด์คอนซัลแต้นส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC346', N'บริษัท ศูนย์ฝึกอบรมความเป็นเลิศทางกลยุทธ์ธุรกิจ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC347', N'บริษัท ทรี ฟลาย สตูดิโอ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO293', N'คุณนฤมล ประเศรษฐานนท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO294', N'คุณปราณี  ประทับศิลป์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO295', N'คุณสุรชัย สุทธิภาค', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO296', N'หจก. ราไชศวรรย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO297', N'เงินกองทุนเงินทดแทนเขตพื้นที่ 2 บัญชี 2', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO307', N'คุณนงลักษณ์ ทองไชย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO308', N'คุณวัฒนพงษ์ เผ่าพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO309', N'คุณพรชัย มะหะหมัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO310', N'คุณสุภาภรณ์ ศิริประพฤทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO311', N'คุณบุษรินทร์ เครือทรง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO312', N'คุณสมพงษ์ เศษคึมบง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO313', N'คุณอารญา แต้ไพบูลย์ศักดิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO314', N'ลูกค้าจับฉลากชิงโชคของรางวัล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO315', N'คุณอัจฉรา พิชิตธงชัย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO316', N'คุณวนิดา  ทิมพงษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO317', N'หจก.โรงพิมพ์สุรวัฒน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO318', N'คุณชัยภัฎ เตมียบุตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO319', N'คุณชานุมาส พิลาสุข', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC348', N'บริษัท ทราฟฟิค เอ็นจิเนียริ่ง ซีสเต็มส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC349', N'บริษัท แสงโสม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC350', N'คุณเจนเนตร ตั้งสินธนาภาส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC351', N'FUJISEIKO (THAILAND) CO.,LTD', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC352', N'บริษัท ทริพเพิล ไอ แอร์ เอ็กซ์เพรส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC353', N'สถาบัน คุ้มครองเงินฝาก', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC354', N'บริษัท อิทธิพรกลการ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC355', N'บริษัท อึ้งประภากร เทรดดิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC356', N'บริษัท อิสริยา 555 จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC357', N'บริษัท ทางด่วนและรถไฟฟ้ากรุงเทพ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC358', N'บริษัท รัตนาลามิเนท แอนด์ ฟอยล์แสตมป์ปิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC359', N'บริษัท คลีโนลซอล ทราฟฟิค (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO320', N'คุณเสาวลักษณ์ สวนม่วง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO321', N'คุณนริศ  ชาญโกเวทย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO322', N'คุณสิริกร สุขสนิท', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC372', N'นายจักรกฤช  ทองนาคะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC373', N'บจก.อุตสาหกรรมกระดูกสัตว์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC374', N'บริษัท สิริธัญญ์ มาร์เก็ตติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC375', N'บริษัท นิปปอน เอ็กซ์เพรส (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC376', N'บริษัท ที.เจ.เค ฟาร์มา จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC377', N'บริษัท ยูไนเต็ดไวน์เนอรี่ แอนด์ ดิสทิลเลอรี่ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO336', N'คุณสิริมา เดชภิญญา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO337', N'คุณอัชรา ปราบใหญ่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO338', N'คุณจักรกฤช ทองนาคะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO339', N'นาย อภิศักดิ์  จุลเนียม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO340', N'บริษัท อาร์เอส จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO341', N'คุณวัชระ  จินดาสมุทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO342', N'คุณรัฐพงษ์  สาระเพ็ญ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO176', N'คุณน้ำผึ้ง  ระเมียดดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO177', N'คุณนฤชา  วิชัยบรรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO178', N'คุณศิราภรณ์  จูฬเศรษฐภักดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO179', N'คุณไพศาล  ชวนางกูร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO180', N'บริษัท ทริสเรทติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO343', N'คุณบุญญฤทธิ์ ศรีทรงเมือง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO344', N'คุณโค๊ก  บุญมา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO345', N'คุณกรวิก  แก้วเปี้ย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO346', N'บริษัท ท่าราบก่อสร้าง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO347', N'บริษัท ไทยวัฒน์วิศวการทาง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO348', N'บริษัท ปักษ์ใต้การช่าง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO349', N'ห้างหุ้นส่วนจำกัดสระบุรีวณิชชากร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO350', N'คุณสมรส พรหมศรี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO351', N'คุณพลพจน์ ชินอ่อน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO352', N'คุณกมลจิต  น้อยเพ็ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO353', N'คุณสิทธิพงษ์ บุญพยุง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO354', N'คุณรุ่งฤดี พราวพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO355', N'นางสาวลลดา  กุฎีรักษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC363', N'บริษัท สังคมสุขภาพ จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC364', N'บริษัท เอไซ (ประเทศไทย) มาร์เก็ตติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC365', N'บริษัท นิตโตกุ (ประเทศไทย) จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC378', N'บริษัท อีโนเว รับเบอร์ (ประเทศไทย) จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC379', N'บริษัท สมาร์ท เรโวลูชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC380', N'บริษัท เมทัลฟิท (ประเทศไทย) จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC381', N'บริษัท อีโนเว รับเบอร์ (ประเทศไทย) จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC382', N'บริษัท ธนคูณ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC383', N'คุณวงศ์วริศ โมคำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC384', N'บริษัท พีพี โหมด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC385', N'บริษัท บอดี้เชพ มาร์เก็ตติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC386', N'KYOWA DENGYO (THAILAND) CO.,LTD', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC387', N'บริษัท โฮยู เทรดดิ้ง (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC388', N'บริษัท ดับบลิวเอ็ม ซิมูเลเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC389', N'คุณชาญยุทธ์ ภาณุทัต', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO356', N'สถาบันการขนส่ง จุฬาลงกรณ์มหาวิทยาลัย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO357', N'บริษัท ลานนา ซอฟท์เวิร์ค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO358', N'คุณสืบสกุล  จันทร์เจนจบ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO359', N'บริษัท ชีวาทัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO360', N'คุณประเสริฐ  มีชูกิจ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO361', N'คุณกานดา ทองนุช', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC390', N'โครงการพัฒนาระบบเฝ้าระวังโรคเหตุใยหิน คณะแพทยศาสตร์ มหาวิทยาลัยธรรมศาสตร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC391', N'คุณน้ำฝน โพธิสาร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC392', N'คุณกนิษฐา พรรณโอรส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC393', N'บริษัท สิริธัญญ์ อินชัวร์ โบรคเกอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC395', N'บริษัท อิตาเลียนไทย ดีเวล๊อปเมนต์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO362', N'บริษัท การบินไทย จำกัด ( มหาชน )', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO363', N'คุณสมัย  ประชุมชัย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO364', N'คุณชยวุฒิ โพบุญธรรม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO365', N'บริษัท เอ พลัส เซร์ฟ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO366', N'ธนาคารกรุงเทพ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO367', N'นางสาวจุฑามาศ  สังเกตุ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO368', N'บริษัท วชิรินทร์สาส์น พริ้นท์ติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC269', N'บริษัท เอส.อาร์.ที.คอม ซัพพลายส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC270', N'ห้างหุ้นส่วนจำกัด เอส.เจ.เซอร์วิส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC271', N'บริษัท เอฟมัก (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC272', N'บริษัท ชับบ์สามัคคีประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO323', N'คุณวีระ ชำนินอก', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO324', N'คุณอรรถพล วุฒิธาดา', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO325', N'คุณนลินทิพย์ เด่นดวงไพโรจน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO326', N'คุณวลัยลักษณ์  อติยศพงศ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL106', N'คุณสันทัด มนัสเพียรเลิศ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL107', N'คุณคฑาวุฒิ กอดสะอาด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL108', N'บริษัท นิวอินเดียแอสชัวรันซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL109', N'บริษัท ไทยศรีประกันภัย จำกัด (มหาชน) สาขารามอินทรา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL110', N'คุณมนตรี ทวีรักษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL111', N'คุณสมหมาย ชูทอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC396', N'บริษัท โคเน่ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC397', N'บริษัท บุญรักษา 999 จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC398', N'บริษัท ส เจริญเภสัชเทรดดิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC399', N'บริษัท วี เอส แอล (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC400', N'บริษัท ฟรีสแลนด์คัมพิน่า (ประเทศไทย) จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC401', N'บริษัท เซ็น คอร์ปอเรชั่น กรุ๊ป จำกัด  (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT040', N'บริษัท เทอร์บอน (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT041', N'นายบุญชัย วสุสินสุข', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT042', N'คุณอโนมา อุฤทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT043', N'บริษัท อินโนเวชั่นพูล เอเซีย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO162', N'นางสาวปุณยนุช  แก้วมา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO163', N'บริษัท ศูนย์รับฝากหลักทรัพย์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO164', N'คุณกรวุฒิ  ชิวปรีชา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO165', N'คุณ ณัชพล  ศรีนอบน้อม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC402', N'บจก.เอ็น แอล เอส โลจิสติกส์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC403', N'บริษัท เซฟเฟิร์ด เทค คอนซัลแตนซี่ ไพรเวท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC404', N'บริษัท โปรเกรสโตโยแมนูแฟคเจอร์ไทย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC405', N'บริษัท อินโด มิตรา เซอเมอสต้า จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC406', N'บริษัท แทนเดม เคมิคอล จำกัด (สำนักงานใหญ)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC407', N'บริษัท ทีวีเอ็น ไทยเวียดนาม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL112', N'คุณเอื้อมเดือน ตันติวิวัฒนพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL113', N'คุณถาวร อยู่กลัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL114', N'คุณวัฒนา เครื่องทิพย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL115', N'คุณสมศักดิ์ กรีพจน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL116', N'คุณอุไร ทองสำแดง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL117', N'คุณพันธสิต สุขชัยศรี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO369', N'บริษัท กรีน แทร็ฟฟิค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO370', N'คุณขจรจิตร ศาลารมย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO371', N'คุณธวัชชัย งามนิมิตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO372', N'นาย กิตติ  สีดาพาลี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO373', N'บริษัท คาร์ลอฟท์ ออโต้ อิมพอร์ต จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO374', N'คุณบุษบา   สาพิมาน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL044', N'คุณสมนึก หารเอี่ยม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL045', N'นาวาเอกโสภณ รัตนสุมาวงศ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL046', N'คุณสมคิด สันโดด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL047', N'คุณนิรมล นพสิทธิ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC408', N'บริษัท อวานการ์ด แคปปิตอล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC409', N'บริษัท ฟูจิเซโกะ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC410', N'โครงการกระบวนทัศน์ใหม่ของการเรียนรู้ในโรงเรียนแพทย์ คณะแพทยศาสตร์ มหาวิทยาลัยธรรมศาสตร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC411', N'บริษัท คันทรี โร๊ด ทรานสปอร์ต จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC412', N'บริษัท สีลมการแพทย์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO375', N'คุณอมรราวดี  มาพล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO376', N'คุณสุพิศ  ช่อมณี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO377', N'คุณพิชามญชุ์  มาพล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO378', N'บริษัท ซาฟารีเวิลด์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO379', N'คุณทองวิไล  อยู่คง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO380', N'คุณวนิดา  สาระรัตน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO234', N'คุณอภิชาติ สังขมี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO235', N'คุณพิเชษฐ  ลัภยานันท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO236', N'คุณกฤษณะ  จั่นเพิ้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO237', N'คุณวาสนา  สังข์ทุม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO238', N'คุณสุพิชชา  เจริญผล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL118', N'นายชัชวาลย์  กัลยาวรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL119', N'บริษัท อาคเนย์ประกันภัย จำกัด (มหาชน) สาขาสุรวงศ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL120', N'คุณปิยณัฐ  บุญคุณ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL121', N'บริษัท เอ เพาเวอร์ เคนเซทซึ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL122', N'นายวัชเรนท์  ทองสุขศรี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL123', N'คุณภาสกร  บัวดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC413', N'คุณศุภพัชญาณ์  จินดาปัณณาพัฒน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC414', N'บริษัท บางกอก ออโต้กลาส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC415', N'บริษัท ทีทีดับบลิว จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC416', N'บริษัท ออเรนทอล แอโร จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC417', N'บริษัท สยามโอกาโมโต จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC418', N'บริษัท ฟอลคอนประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC419', N'บริษัท ห้างทองรัตนาพร จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC420', N'บริษัท ฟู้ดแพชชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC421', N'บริษัท สีลมการแพทย์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC422', N'คุณสุเทพ  โพธิ์ย้อย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC423', N'บริษัท แคนนอน เพสท์ เมเนจเม้น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC424', N'บริษัท โรงพิมพ์อักษรสัมพันธ์ (1987) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO381', N'คุณปราณี  สุขเฉย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO382', N'คุณบุญค้ำ สุวรรณะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO383', N'คุณอดิศักดิ์  แจ่มกระจ่าง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO384', N'คุณณปภัช  นธกิจไพศาล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO385', N'บริษัท ฟรีดอม เอเซีย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO386', N'บริษัท อสมท จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO387', N'คุณกิตติ  สีดาพาลี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO388', N'คุณจักรกฤช  ทองนาคะ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO389', N'คุณวารินทร์  บุญสุนีย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO390', N'คุณโอภาส  ธรรมพาสุข', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO391', N'คุณอำนาจ  กองมณี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO392', N'ส.ต.สุทิน  ปัญญาใส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO393', N'คุณอนุชิต  แจ้งสว่าง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO394', N'คุณสุรัตน์  เอกภาพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO395', N'คุณชิราวุฒ  ชมวิจิตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO396', N'คุณศุภกฤช  ศรีทรงแสง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO397', N'คุณทศพร  บุญเนตร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO398', N'คุณปราโมทย์ ดวงเพียราช', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO399', N'คุณนิพิฐพนธ์  พุทธวงษ์วาลย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO400', N'คุณชัยชนะ  สว่างจินดากุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO401', N'คุณจรรยวรรณ  เอี่ยมท้วม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO402', N'คุณน้ำผึ้ง  ศรีแสง', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO403', N'คุณสุมิตรา  คงชาตรี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO404', N'คุณวงกต  บุญเมือง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO405', N'คุณบรรพต  ปิยอิสระกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO406', N'คุณณัฏฐพงษ์  เรียงเรียบ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO407', N'คุณสมยศ ผลอินทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO408', N'บริษัท เพรพพาเรชั่น แอนด์ โซลูชั่น ซิสเต็ม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO409', N'คุณธัญทิพย์  พนมสินธุ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC431', N'บริษัท ไทยพิมพ์สัมผัส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC432', N'บริษัท กรุงเทพ ซินธิติกส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC433', N'บริษัท บุญถาวรเซรามิค  จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC434', N'บริษัท เจ ควอลิตี้ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC435', N'บริษัท มิทซูนามิ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC436', N'บริษัท เยนเนอรัล ไมนิ่ง แอนด์ เทรดดิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC425', N'คุณธรรมนูญ  วงศ์สวรรค์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC426', N'บริษัท พี.พี.สยามรีเทล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC427', N'บริษัท บีมายเดฟ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC428', N'บริษัท คำรน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC429', N'บริษัท ธานินกิตติ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC430', N'บริษัท ชัยยงไซโลการเกษตร จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO410', N'คุณวริษา  ก้านพิกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO411', N'คุณเยาวลักษณ์  เขียวนิล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO412', N'บริษัท ธีระกุล (1995) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO413', N'คุณพิมพา  แย้มยิ้ม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO414', N'คุณปาณิศรา สอนใจ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO415', N'บริษัท ไทยเน็ต (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO416', N'บริษัท คอนเทนเนอร์ ซัพพลาย (2000) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO417', N'คุณทัศนีย์  ชาวหมู่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO418', N'คุณธนศักดิ์  วรรณธง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO419', N'คุณปาริชาติ แก้วกิ่ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO420', N'คุณชาลิณี  เริ่มยินดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO421', N'คุณถนัด  ขันทอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO422', N'คุณปัญญา  ทาโบราณ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO423', N'คุณปริยณัชญ์  ทองมี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO424', N'คุณพิมพร  ภู่สาย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO425', N'คุณศุภักชัย โพดขุนทด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO426', N'คุณอัจฉราวรรณ กุลนอก', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO427', N'คุณสัญชัย  วีระพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO428', N'คุณนฤมล  ทองแถม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC437', N'บริษัท เอชเคที ออโต้พาร์ท (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC438', N'บริษัท อาร์ทรัส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC439', N'บริษัท ซีพี บีแอนด์เอฟ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC440', N'บจก.โตโยต้า ไดฮัทสุ เอ็นจิเนียริ่ง แอนด์ แมนูแฟคเจอริ่ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC441', N'บริษัท บางจาก คอร์ปอเรชั่น จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL124', N'นายยุทธการ  ทองจันทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL125', N'น.ส.พิจิตรา  ค้ำชู', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL126', N'คุณสุรพล  วัฒนา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL127', N'คุณวรกฤษ  ทิศเป็ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL128', N'คุณเอนก  เอี่ยมสมบูรณ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL129', N'คุณวินัย  อาดำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL130', N'บริษัท ไทยประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO429', N'คุณวัชรินทร์  ชัยเขว้า', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO430', N'คุณอิสรีย์ ภู่สี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO431', N'คุณฤทัยรัตน์  กลิ่นแจ่ม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO432', N'คุณอัจฉรา โชมขุนทด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO433', N'คุณธนธานี  สุวรรณทิพย์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO434', N'คุณวรวรรณ  อนุยา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO435', N'คุณธาราภรณ์  สายคำกอง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO436', N'นายณัชพล  ศรีนอบน้อม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO437', N'คุณวีรชาติ  ธารีศัพท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO438', N'คุณสายหยุด  จิตติแสง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO439', N'คุณมาลิษา  นาคขวัญ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO440', N'คุณพอใจ สนิทวงศ์ ณ อยุธยา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO441', N'คุณเยาวภา ขันติวงษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO442', N'คุณสมพล  มานะงาน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO443', N'คุณรัชนก มั่นคง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO444', N'คุณนาฏยพร  ภิญโญจิต', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO445', N'คุณสัมฤทธิ์ รัตนา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO446', N'ลูกหนี้อื่น', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO447', N'บริษัท ไพโอเนียร์ ลิฟท์ แอนด์ เครน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO448', N'คุณฤทธิกรณ์  รอบรู้', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO458', N'บริษัท อินติเกรต ซิสเต้ม (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO459', N'บริษัท ซี แอนด์ ซี อินเตอร์เนชั่นแนล เวนเจอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO460', N'บริษัท อิตาเลียนไทย ดีเวล๊อปเมนต์ จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO462', N'คุณเพ็ญศรี  ทองขาว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO463', N'คุณสุขวันดี  ทองพราว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO464', N'คุณกุลยา  ภูครองหิน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR013', N'บริษัท สมาร์ท ซายน์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CR014', N'บริษัท นิยม ชมชอบ ออกาไนเซอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO465', N'ห้างหุ้นส่วนจำกัดเฟิรส์ท ออฟฟิศเซอร์วิส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO466', N'คุณเทพกร  ชะเอมหอม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO467', N'คุณพฤกษ์  ชุ่มผึ้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC448', N'บริษัท สยามเอวีเอชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC449', N'บริษัท เจดับบลิวเอสคอนสตรัคชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC450', N'บริษัท โอเรกอน อลูมิเนียม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC451', N'บริษัท พีพี ลุกซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC452', N'บริษัท ทริส คอร์ปอเรชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC453', N'บริษัท ทริสเรทติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO468', N'นายวิเชียร  ธรรมจักร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO469', N'คุณเกศแก้ว  บัลลังค์แก้ว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO470', N'บริษัท ซิสตร้า เอ็มวีเอ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO471', N'บริษัท ไต้ฝุ่นเทค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO472', N'คุณธนะสิทธิ์ ไชยวรรณวัชร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO473', N'คุณผกากาญจน์ สิงห์คา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC454', N'บริษัท สามัคคีแมนชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC455', N'บริษัท อะแด็ปเตอร์ ดิจิตอล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC456', N'บริษัท เอ็มเอ็มไอ พรีซิชั่น แอสเซมบลิ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC457', N'บริษัท ซู อินเตอร์เนชั่นแนล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC458', N'บริษัท ไมพ๊อกซ์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC459', N'บริษัท ครีเอชั่นเฟอร์นิเจอร์อินดัสตรี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO474', N'Metropolitan Expressway Company Limited', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO475', N'Japan Expressway International Company Limited', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO477', N'กรมทางหลวง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO478', N'คุณวรรณวิภา  ภูริวัฒนกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO479', N'บริษัท ทรัพย์อยู่สุข จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO480', N'บริษัท บ้านพีอาร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC460', N'บริษัท เดอ เมย์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC461', N'บริษัท สุขสวัสดิ์การแพทย์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC462', N'บริษัท สกาย ไอซีที จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC463', N'บริษัท เอสวีแอล คอร์ปอเรชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC464', N'บริษัท ไทยบรอดคาสติ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC465', N'บริษัท ชาญชัยเอ็นจิเนียริ่ง แอนด์ อีควิปเม้นท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO481', N'นายนพพล  โพธิ์ขี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO482', N'บริษัท ซเพียร์ ไอเดีย ครีเอชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO483', N'คุณ ศักดิ์ดา  พรรณไวย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO484', N'บริษัท เอ็นแอนด์ที เทคนิคคอล เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO485', N'บริษัท อิเลคนิคัล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO486', N'บริษัท เพชราภรณ์ กรุ๊ป แทรเวล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC466', N'คุณณัฏฐ์  อภิหิรัญสิริกุล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC467', N'สำนักงานรักษาความปลอดภัย อผศ.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC468', N'นางกาญจนา รอดบุญธรรม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC469', N'คุณกรนัฐ ทองย้อย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC470', N'บริษัท เค.อาร์.เอส.สไปรซี่ ฟู้ดส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC471', N'บริษัท อีเอสวี เรสซิเดนซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC472', N'คุณอธิวัฒน์  บัวเกตุ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC473', N'บริษัท อิออน ธนสินทรัพย์ (ไทยแลนด์) จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC474', N'บริษัท อิซ ไอที กรุ๊ป จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC475', N'บริษัท ครีเอทีโว่ พร็อพเพอร์ตี้ แอนด์ ดีเวลลอปเม้นท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC476', N'บริษัท โรงพยาบาลพระรามเก้า จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC477', N'บริษัท มาเฮ่ เมดิคอล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO487', N'คุณแคทลียา  ทารการ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO488', N'บริษัท เอ.ที.ไทย.เอ็นเตอร์ไพรส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO489', N'บริษัท ยูนิค เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO490', N'คุณปวันรัตน์ พิกุลขาว', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO491', N'คุณสราวุธ  เรืองงาม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO492', N'คุณรจนา  แพงวงษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC478', N'บริษัท เคมีแมน จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC479', N'บริษัท โตโยต้า ทูโซ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC480', N'บริษัท โอเชี่ยนบลู ชิปปิ้ง ไลน์ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC481', N'บริษัท แม็คโปร เอ็กซ์เพรส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC482', N'บริษัท ที.เจ.เค ฟาร์มา จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC483', N'บริษัท ก.ภัทรค้าไม้ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'C-Other', N'ลูกค้าอื่น', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO493', N'T.M.S. Engineering Co.Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO494', N'บริษัท ซีซีเอ็ม ซิสเต็มส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO495', N'การรถไฟแห่งประเทศไทย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL131', N'คุณประจักษ์  เศรษฐีพ่อค้า', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL132', N'บริษัท อลิอันซ์ ประกันภัย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL133', N'นายปฎิกรณ์  ศรีสว่าง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL134', N'หจก.ศรีทะวงศ์ ทัวร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL135', N'คุณสุรัตน์  เถาศิริพันธ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL136', N'คุณธนวัฒน์  ถิ่นหนองไทร', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC484', N'บริษัท เฮลโหลไพน์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC485', N'บริษัท มหาชัยคราฟเปเปอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC486', N'บริษัท เทคนิคอล เอ็นจิเนียริ่ง เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC487', N'บริษัท เอคโค่ แทนเนอรี่ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC488', N'บริษัท ชาริช โฮลดิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC489', N'บริษัท สุนทรเมทัลแพค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO146', N'คุณวรพจน์  ศรีนอบน้อม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO147', N'บริษัท แลคตาซอย จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO148', N'บริษัท ถนอมวงศ์บริการ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO149', N'คุณวีระวัฒน์  วีรารักษ์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO1497', N'คุณ ณัฐวุฒิ  หิวานันท์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC490', N'บริษัท เนเจอร์ไบโอเทค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC491', N'บริษัท มัลติเฟส คอนเนค จำกัด (สำนักงานใหญ่)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC492', N'สถาบันมาตรวิทยา แห่งชาติ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC493', N'บริษัท เอคโค่  (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC494', N'บริษัท จาร์ดีน ชินด์เล่อร์ (ไทย)จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC495', N'บริษัท เรนาสโซ มอเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO496', N'ซาบีย่า', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO497', N'ห้างหุ้นส่วนจำกัด บ้านโป่ง เพ้นท์ส', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO499', N'คุณจิรัชญา พันธ์ศรี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO500', N'คุณรัชกฤช  จันทร์ลภ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO501', N'บริษัท จีเคเอ็ม เอ็นจิเนียริ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO502', N'บริษัท พี ยู เอ็ม เอ็นจิเนียริ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC496', N'บริษัท มัลติ ปิโตรเลียม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC497', N'บริษัท ซีบีอาร์อี (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC498', N'คุณสมพงษ์  บุญหนุน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC499', N'บริษัท อายิโนะโมะโต๊ะ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC500', N'บริษัท อายิโนะโมะโต๊ะ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC501', N'บริษัท ปาร์คพลัส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO503', N'คุณสุภาพร  เช้าวันดี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO504', N'คุณปิยะดา  แท่นรัตน์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO505', N'คุณจักรพล  เฉตาไพย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO506', N'คุณพงศ์ศรัณย์  บวรบันเทิง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO507', N'ห้างหุ้นส่วนจำกัด บีบีพี ออโต้', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO508', N'บริษัท คิว-ฟรี (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO509', N'บริษัท อีซีเอ็น มอเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO510', N'บริษัท กรุ๊ป เทค โซลูชั่นส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO511', N'บริษัท ไทยโทรนิค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO512', N'บริษัท แซม โทคโนโลยี ซัพพอร์ต จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO513', N'บริษัท แพลนเน็ต คอมมิวนิเคชั่น เอเชีย จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO514', N'Grenobloise d''Electronique et d''Automatismes (GEA) Co.,Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO515', N'บริษัท ยูไนเต็ด เทเลคอม เซลส์ แอนด์ เซอร์วิสเซส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO516', N'บริษัท ไทยอิงเกอร์ เทคโนโลยี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO517', N'Tecsidel India Private Limited', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO518', N'บริษัท ทราส์โค้ด จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO519', N'คุณฤทัยรัตน์  กลิ่นแจ่ม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO520', N'บริษัท อินฟินิตี้ เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC502', N'บริษัท ปทุมรักษ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC503', N'ห้างหุ้นส่วนจำกัด ชยุต', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC504', N'Panasonic Industrial Devices Sales (Thailand) Co.,Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC505', N'บริษัท โรงพยาบาลปิยะเวท จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC506', N'บมจ.เพาเวอร์ โซลูชั่น เทคโนโลยี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC507', N'บริษัท เคาน์เซลลิ่ง โซลูชั่นส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO521', N'บริษัท เจาะวางท่อใต้ดิน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO522', N'คุณชวณัฎฐ  ศรีสุขวัฒนา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO523', N'คุณเกตสรา  เพิงคาม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO524', N'คุณบุษบา  นุชเทียม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO525', N'บริษัท ยูนิค เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO526', N'คุณศศิธร  ปฏิภาณบุญนำ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC508', N'บริษัท ชัยเสรี รับเบอร์ อินดัสทรี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC509', N'บริษัท คอนเนค แอนด์ แกเธอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC510', N'หจก.รุ่งโรจน์เพ้นท์ติ้ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC511', N'อุตสาหกรรมพัฒนามูลนิธิ สถาบันพลาสติก', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC512', N'ห้างหุ้นส่วนจำกัด ข้าวกล้า', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC513', N'บริษัท เยนเนอรัล ฟู้ด โปรดักส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CB489', N'บริษัท เอฟโอเอ็มเอ็ม (เอเซีย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC514', N'บริษัท อาร์ วี คอนเน็กซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC515', N'บริษัท เรือลำเลียงบางปะกง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC516', N'บริษัท ยูโรมิลล์ โฮเต็ล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC517', N'บริษัท ปทุมไรซมิล แอนด์ แกรนารี จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC518', N'บจก. เอส เจ พี อินฟอร์เมชั่นซิสเต็ม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC519', N'บริษัท ดราก้อน วัน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL137', N'บริษัท สินมั่นคงประกันภัย จำกัด (มหาชน) สาขาหลักสี่', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL138', N'คุณยศกร  ชมภูนิช', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL139', N'คุณสิทธิกร  สวัสดิการ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL140', N'คุณพงศกร  เทพานวล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL141', N'คุณก้องเกียรติ  ฤทธิยา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL142', N'ด.ต.ยุทธการ ทองจันทร์', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC520', N'บริษัท สุรากระทิงแดง (1988) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC521', N'บริษัท ออร์เดอร์ บิวตี้ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC522', N'บริษัท เอ เอ เอส ออโต้ เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC523', N'บริษัท บิ๊ก วอล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC524', N'บริษัท พงศกรกลการ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC525', N'บริษัท หลักทรัพย์ ฟินันเซีย ไซรัส จำกัด (มหาชน)', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO527', N'คุณอานนท์  คงจินดา', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO528', N'บริษัท รังสิตพลาซ่า จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO529', N'บริษัท พี.พี.พี.รีไซเคิล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO530', N'บริษัท  แอนท์ แมน ออร์แกไนเซอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC526', N'บริษัท เวิลด์ เอเซีย โซลูชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC527', N'บริษัท เคอร่าไทล์ เซรามิก จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC528', N'บริษัท ซีจี ออโตโมบิล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC529', N'บริษัท เอ็นเอเอส อิควิปเม้นท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC530', N'บริษัท กรีน ลาเท็กซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC531', N'บริษัท สยามเบรเตอร์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT047', N'บริษัท คาร์แลค(ไทย-เยอรมัน) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT048', N'บริษัท เครื่องดับเพลิง อิมพีเรียล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT049', N'บริษัท โอเรียนท์ไทยแอร์ไลน์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CT050', N'บริษัท เดสทินี่ เอ็นเตอร์ไพร์ซ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO543', N'บริษัท เอบีจี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO544', N'บริษัท เดโก้ กรีน เอนเนอร์จี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CL143', N'คุณพิชานัต  ไกรคุ้ม', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO531', N'บริษัท แอพเวิร์คส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO532', N'คุณวัชระ  สัตยาประเสริฐ', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO533', N'กิจการร่วมค้า คิวฟรี-ยูเทล', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO534', N'คุณศิรภัสสร  ผอมจีน', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO542', N'บริษัท กิ๊ฟ เคบิน จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO545', N'บริษัท เมกไกวส์ (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO546', N'บริษัท ชิโมโน (ไทยแลนด์) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO547', N'บริษัท ไฮไฟ อินเตอร์เนชั่นแนล จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO548', N'คุณอุทัย เจาะนอก', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CO549', N'บริษัท อินสตาวอช (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC532', N'บริษัท ซัมมิท ไพน์เฮิร์สท กอล์ฟ คลับ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC533', N'บริษัท พาสปอร์ตคาร์เร้นท์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC534', N'บริษัท ด็อกเตอร์ ออโต้ คลินิค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC535', N'บริษัท ไทยธานีเคมี จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC536', N'บริษัท ส.วัฒนพงศ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC537', N'บริษัท คุณทิพเจริญ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC538', N'บริษัท ไอ ทรี ดิสทริบิวชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC539', N'บริษัท โมบิส โซลูชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC540', N'บริษัท ชาญ ไอที โซลูชั่น เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC541', N'ห้างหุ้นส่วนจำกัด ไทร์วิชั่น', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC542', N'บริษัทแอดวานซ์ ออนโกอิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC543', N'บริษัท ไทยยามาซากิ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC544', N'บริษัท ทำเป็นจุ๊ยซ์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC545', N'บริษัท ไฮโดรไบโอ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC546', N'บริษัท ทีวายที โซลูชั่นส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC547', N'บริษัท โฟคัซ แมนูแฟคเจอริ่ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC548', N'บริษัท ฟอร์แตงส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC549', N'บริษัท เวฟเทค เคลียรันซ เซอร์วิส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC550', N'บริษัท พระนครศรีอยุธยาพาณิชย์และอุตสาหกรรม จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC551', N'บริษัทเจ.บี.ยู (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC552', N'บริษัท เอ็มซี ดีไซน์ แพคเกจจิ้ง จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC553', N'บริษัท ออโรส จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC554', N'บจก. โตโยต้าลพบุรีอุดมชัย ผู้จำหน่ายโตโยต้า', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC555', N'บจก. เพาเวอร์ โซลูชั่น เทคโนโลยี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC556', N'บริษัท สไมล์ ออดิท จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC557', N'บริษัท โชว์ไทม์ คลินิก จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC558', N'บริษัท พลัส-บีบีจี คอร์ปอเรชั่น (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC559', N'สถาบันเทคโนโลยี แห่งเอเชีย', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC560', N'บริษัท สตีล แอนด์ ทูลส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC561', N'บริษัท ธัญบุรีฮอนด้าคาร์ส์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC562', N'Holland Star Packaging Co.,Ltd.', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC563', N'บริษัท ไทยไพศาลเอ็นยิเนียริ่ง (1995) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC564', N'บริษัท ทรัพย์ไพศาลคอนสตรัคชั่น จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC565', N'บริษัท แอลพีเอ็น แอดวานซ์ เทค จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC566', N'มูลนิธิ ทางสู่ฝัน ปั้นคนเก่ง', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC567', N'บริษัท ซีวา แอนิมัล เฮลธ์ (ประเทศไทย) จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC568', N'บริษัท ราชา อินเตอร์ กรุ๊ป จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC569', N'คุณทรงศักดิ์  สมเนตร', 1)
GO
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC570', N'บริษัท ศิวะโกลด์ จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC571', N'กิจการร่วมค้า จีเคอี แอนด์ เอฟอีซี', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC572', N'บริษัท นฤคธมฤวัน คอนสตรั๊คชั่น98 จำกัด', 1)
INSERT [dbo].[SAPCustomerCode] ([CardCode], [CardName], [UseFlag]) VALUES (N'CC573', N'บริษัท นนทกรณ์ เอ็นจิเนียริ่ง จำกัด', 1)

