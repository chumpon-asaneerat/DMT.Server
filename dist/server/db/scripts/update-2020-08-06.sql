/*********** Script Update Date: 2020-08-06  ***********/
EXEC DROPALL;
DROP PROCEDURE DROPALL;


/*********** Script Update Date: 2020-08-06  ***********/
/****** Object:  Table [dbo].[AGENT]    Script Date: 6/3/2020 12:48:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AGENT](
	[AGENT_ID] [nvarchar](5) NOT NULL,
	[AGENT_NAME] [nvarchar](30) NULL,
	[POSITION_ID] [nchar](1) NULL,
	[FLAG] [nchar](1) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/
/****** Object:  Table [dbo].[COUPON]    Script Date: 6/3/2020 12:49:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[COUPON](
	[COUPON_CODE] [nchar](3) NOT NULL,
	[COUPON_TYPE] [nvarchar](10) NULL,
	[COUPON_PRICE] [numeric](6, 2) NULL,
	[ACTIVE_DATE] [datetime] NULL,
	[FLAG] [nchar](1) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/

/****** Object:  Table [dbo].[MONEY]    Script Date: 6/3/2020 12:50:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MONEY](
	[AMNT_VALUE] [numeric](4, 0) NULL,
	[AMNT_ORDER] [numeric](2, 0) NULL,
	[MONEY_TYPE] [nchar](1) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/

/****** Object:  Table [dbo].[MONTRANSACTION]    Script Date: 6/3/2020 12:51:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MONTRANSACTION](
	[TRANS_TYPE] [nchar](1) NOT NULL,
	[PLAZA_ID] [nchar](2) NOT NULL,
	[AGENT_ID] [nvarchar](5) NULL,
	[AMNT_1] [numeric](5, 0) NULL,
	[AMNT_2] [numeric](5, 0) NULL,
	[AMNT_5] [numeric](5, 0) NULL,
	[AMNT_10] [numeric](5, 0) NULL,
	[AMNT_20] [numeric](5, 0) NULL,
	[AMNT_50] [numeric](5, 0) NULL,
	[AMNT_100] [numeric](5, 0) NULL,
	[AMNT_500] [numeric](5, 0) NULL,
	[AMNT_1000] [numeric](5, 0) NULL,
	[TRANS_DATE] [datetime] NULL,
	[TRANS_REMARK] [nvarchar](100) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/
/****** Object:  Table [dbo].[PLAZA]    Script Date: 6/3/2020 12:52:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PLAZA](
	[PLAZA_ID] [nchar](2) NOT NULL,
	[PLAZA_ENG] [nvarchar](20) NULL,
	[PLAZA_THA] [nvarchar](20) NULL,
	[TOT_LANE] [numeric](2, 0) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/

/****** Object:  Table [dbo].[PLAZA_BALANCE]    Script Date: 6/3/2020 12:53:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PLAZA_BALANCE](
	[PLAZA_ID] [nchar](2) NOT NULL,
	[AMNT_1] [numeric](5, 0) NULL,
	[AMNT_2] [numeric](5, 0) NULL,
	[AMNT_5] [numeric](5, 0) NULL,
	[AMNT_10] [numeric](5, 0) NULL,
	[AMNT_20] [numeric](5, 0) NULL,
	[AMNT_50] [numeric](5, 0) NULL,
	[AMNT_100] [numeric](5, 0) NULL,
	[AMNT_500] [numeric](5, 0) NULL,
	[AMNT_1000] [numeric](5, 0) NULL,
	[BALANCE_DATE] [datetime] NULL,
	[BALANCE_REMARK] [nvarchar](200) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/
/****** Object:  Table [dbo].[SHIFT]    Script Date: 6/3/2020 12:53:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SHIFT](
	[PLAZA_ID] [nchar](2) NOT NULL,
	[AGENT_ID] [nvarchar](5) NOT NULL,
	[SHIFT_ID] [datetime] NOT NULL,
	[SHIFT_END] [datetime] NULL,
	[SYSTEM_ID] [nvarchar](2) NULL,
	[SHI_SHIFT_ID] [datetime] NULL,
	[ENTRY_ID] [nchar](10) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/

/****** Object:  Table [dbo].[TRANSACTIONTYPE]    Script Date: 6/3/2020 12:54:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TRANSACTIONTYPE](
	[TRANS_TYPE] [nchar](1) NULL, /* Type: 1 received, 2: returns */
	[TRANS_DESC] [nchar](10) NULL,
	[TRANS_GROUP] [nchar](1) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/
CREATE TABLE [dbo].[TA_Coupon](
	[TransactionID] [varchar](10) NOT NULL,
	[TransactionDate] [datetime]  NOT NULL,
	[TSBId] [varchar](10) NOT NULL,
	[CouponType] [varchar](2) NOT NULL,
	[SerialNo] [varchar](7) NOT NULL,
	[Price] [decimal](6, 0) NOT NULL,
	[UserId] [varchar](10) NULL,
	[UserReceiveDate] [datetime] NULL,
	[CouponStatus] [char](1) NULL,
	[SoldDate] [datetime] NULL,
	[SoldBy] [varchar](10) NULL,
	[FinishFlag] [char](1) NULL,
	[TransferFlag] [char](1) NULL
	) ON [PRIMARY]
GO

/*********** Script Update Date: 2020-08-06  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: DropAll.
-- Description:	Drop all Stored Procedures/Views/Tables/Functions
-- [== History ==]
-- <2019-08-19> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec DropAll
-- =============================================
CREATE PROCEDURE [dbo].[DropAll]
AS
BEGIN
CREATE TABLE #SP_NAMES
(
    ProcName nvarchar(100)
);

CREATE TABLE #VIEW_NAMES
(
    ViewName nvarchar(100)
);

CREATE TABLE #TABLE_NAMES
(
    TableName nvarchar(100)
);

CREATE TABLE #FN_NAMES
(
    FuncName nvarchar(100)
);

DECLARE @sql nvarchar(MAX);
DECLARE @name nvarchar(100);
DECLARE @dropSPCursor CURSOR;
DECLARE @dropViewCursor CURSOR;
DECLARE @dropTableCursor CURSOR;
DECLARE @dropFuncCursor CURSOR;
	/*========= DROP PROCEDURES =========*/
    INSERT INTO #SP_NAMES
        (ProcName)
    SELECT name
      FROM sys.objects 
	 WHERE type = 'P' 
	   AND NAME <> 'DropAll' -- ignore current procedure.
	 ORDER BY modify_date DESC

    SET @dropSPCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT ProcName
    FROM #SP_NAMES;

    OPEN @dropSPCursor;
    FETCH NEXT FROM @dropSPCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop procedures.
        SET @sql = 'DROP PROCEDURE ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropSPCursor INTO @name;
    END
    CLOSE @dropSPCursor;
    DEALLOCATE @dropSPCursor;

    DROP TABLE #SP_NAMES;

	/*========= DROP VIEWS =========*/
    INSERT INTO #VIEW_NAMES
        (ViewName)
    SELECT name
    FROM sys.views;

    SET @dropViewCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT ViewName
    FROM #VIEW_NAMES;

    OPEN @dropViewCursor;
    FETCH NEXT FROM @dropViewCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table.
        SET @sql = 'DROP VIEW ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropViewCursor INTO @name;
    END
    CLOSE @dropViewCursor;
    DEALLOCATE @dropViewCursor;

    DROP TABLE #VIEW_NAMES;

	/*========= DROP TABLES =========*/
    INSERT INTO #TABLE_NAMES
        (TableName)
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_TYPE = N'BASE TABLE';

    SET @dropTableCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT TableName
    FROM #TABLE_NAMES;

    OPEN @dropTableCursor;
    FETCH NEXT FROM @dropTableCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table.
        SET @sql = 'DROP TABLE ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropTableCursor INTO @name;
    END
    CLOSE @dropTableCursor;
    DEALLOCATE @dropTableCursor;

    DROP TABLE #TABLE_NAMES;

	/*========= DROP FUNCTIONS =========*/
    INSERT INTO #FN_NAMES
        (FuncName)
    SELECT O.name
      FROM sys.sql_modules M
     INNER JOIN sys.objects O 
	    ON M.object_id = O.object_id
     WHERE O.type IN ('IF','TF','FN')

    SET @dropFuncCursor = CURSOR LOCAL FAST_FORWARD 
	    FOR SELECT FuncName
    FROM #FN_NAMES;

    OPEN @dropFuncCursor;
    FETCH NEXT FROM @dropFuncCursor INTO @name;
    WHILE @@FETCH_STATUS = 0
	BEGIN
        -- drop table.
        SET @sql = 'DROP FUNCTION ' + @name;
        EXECUTE SP_EXECUTESQL @sql;
        
        FETCH NEXT FROM @dropFuncCursor INTO @name;
    END
    CLOSE @dropFuncCursor;
    DEALLOCATE @dropFuncCursor;

    DROP TABLE #FN_NAMES;
END

GO


/*********** Script Update Date: 2020-08-06  ***********/
CREATE PROCEDURE [dbo].[GetUserCouponList]
(
    @tsbid varchar(10)  ,
	@userid varchar(10) ,
	@coupontype varchar(2)
)
AS
BEGIN
    SELECT [TransactionID], [CouponType], [SerialNo], [Price]
	FROM[dbo].[TA_Coupon] 
     WHERE [UserId] = COALESCE(@userid, [UserId])
	 and [CouponStatus] = 2
     ORDER BY [SerialNo] asc
END

GO

/*********** Script Update Date: 2020-08-06  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SaveTACoupon] (
  @transactionid  varchar(10)
, @transactiondate datetime
, @tsbid varchar(10)
, @coupontype varchar(2)
, @serialno varchar(7)
, @price decimal(6,0)
, @userid varchar(10)
, @userreceivedate datetime
, @Couponstatus char(1)
, @solddate datetime
, @soldby varchar(10)
, @finishflag char(1)
, @transferflag char(1)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
		IF EXISTS (
		SELECT *	 
		FROM[dbo].[TA_Coupon] 
		WHERE [SerialNo] = @serialno
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid
		
	)
	BEGIN
	UPDATE [dbo].[TA_Coupon]
	SET [Price] = COALESCE(@price, [Price])
      ,[UserId] = COALESCE(@userid, [UserId])
      ,[UserReceiveDate] = COALESCE(@userreceivedate, [UserReceiveDate])
      ,[CouponStatus] = COALESCE(@Couponstatus, [CouponStatus])
      ,[SoldDate] = COALESCE(@solddate, [SoldDate])
      ,[SoldBy] = COALESCE(@soldby, [SoldBy])
      ,[FinishFlag] = COALESCE(@finishflag, [FinishFlag])
      ,[TransferFlag] = COALESCE(@transferflag, [TransferFlag])
	WHERE [SerialNo] = @serialno
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid;
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[TA_Coupon]
           ([TransactionID], [TransactionDate],[TSBId] ,[CouponType] ,[SerialNo]
           ,[Price] ,[CouponStatus] ,[FinishFlag] ,[TransferFlag])
     VALUES ( @transactionid , @transactiondate , @tsbid, @coupontype, @serialno
	         ,@price , @Couponstatus , @finishflag , @transferflag)


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2020-08-06  ***********/

INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'1', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002202', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'3', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'2', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002203', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'3', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002204', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'4', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002205', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'5', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002206', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'6', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002207', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'7', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002208', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'8', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002209', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'9', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002210', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'10', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002211', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'11', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002212', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'12', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002213', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'13', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002214', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'14', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002215', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'15', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002216', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'16', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002217', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'17', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002218', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'18', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002219', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'19', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002220', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'20', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002221', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'21', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002222', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'22', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002223', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'23', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002224', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'24', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002225', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'25', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002226', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'26', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002227', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'27', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002228', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'28', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002229', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'29', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002230', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'30', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002231', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'31', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002232', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'32', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002233', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'33', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002234', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'34', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002235', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'35', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002236', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'36', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002237', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'37', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002238', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'38', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002239', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'39', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002240', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'40', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002241', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'41', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002242', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'42', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002243', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'43', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002244', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'44', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002245', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'45', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002246', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'46', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002247', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'47', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002248', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'48', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002249', CAST(665 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'49', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003502', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'50', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003503', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'51', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003504', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'52', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003505', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'53', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003506', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'54', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003509', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'55', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003510', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'56', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003511', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'57', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003512', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'58', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003513', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'59', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003514', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'60', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003515', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'61', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003516', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'62', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003517', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'63', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003518', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'64', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003521', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'65', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003522', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'66', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003523', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'67', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003524', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'68', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003525', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'69', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003526', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'70', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003527', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'71', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003528', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'72', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003529', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'73', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003530', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'74', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003531', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'75', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003532', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'76', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003533', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'77', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003534', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'78', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003535', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'79', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003536', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'80', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003537', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'81', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003538', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'82', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003539', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)
INSERT [dbo].[TA_Coupon] ([TransactionID], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [TransferFlag]) VALUES (N'83', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003540', CAST(1520 AS Decimal(6, 0)), N'', NULL, N'1', NULL, N'', N'1', NULL)

