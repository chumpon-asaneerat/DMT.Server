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
	[CouponPK] int NOT NULL,
	[TransactionDate] [datetime]  NOT NULL,
	[TSBId] [nvarchar](5) NOT NULL,
	[CouponType] [varchar](2) NOT NULL,
	[SerialNo] [nvarchar](7) NOT NULL,
	[Price] [decimal](6, 0) NOT NULL,
	[UserId] [nvarchar](10) NULL,
	[UserReceiveDate] [datetime] NULL,
	[CouponStatus] [char](1) NULL,
	[SoldDate] [datetime] NULL,
	[SoldBy] [nvarchar](10) NULL,
	[LaneId] [nvarchar](10) NULL,
	[FinishFlag] [char](1) NULL,
	[SapChooseFlag] [char](1) NULL default  0,
	[SapChooseDate] [datetime] NULL
	) ON [PRIMARY]
GO

/*********** Script Update Date: 2020-08-06  ***********/
CREATE TABLE [dbo].[Lane](
	[LaneNo] [int] NULL,
	[LaneId] [nvarchar](10) NULL,
	[LaneType] [nvarchar](10) NULL,
	[LaneAbbr] [nvarchar](10) NULL,
	[TSBId] [nvarchar](5) NULL,
	[PlazaGroupId] [nvarchar](10) NULL,
	[PlazaId] [nvarchar](10) NULL,
	[Status] [int] NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/
CREATE TABLE [dbo].[LaneAttendance](
	[JobId] [nvarchar](20) NOT NULL,
	[TSBId] [nvarchar](10) NOT NULL,
	[PlazaGroupId] [nvarchar](10) NULL,
	[PlazaId] [nvarchar](10) NOT NULL,
	[LaneId] [nvarchar](10) NULL,
	[UserId] [nvarchar](10) NULL,
	[BOJ] [datetime] NULL,
	[EOJ] [datetime] NULL,
	[RevenueDate] [datetime] NULL,
	[RevenueId] [nvarchar](20) NULL
	
) ON [PRIMARY]
GO



/*********** Script Update Date: 2020-08-06  ***********/
CREATE TABLE [dbo].[UserShift](
	[UserShiftId] [int] NOT NULL,
	[TSBId] [nvarchar](5) NULL,
	[ShiftId] [int] NULL,
	[UserId] [nvarchar](10) NULL,
	[BeginShift] [datetime] NULL,
	[EndShift] [datetime] NULL,
	[Status] [int] NULL,
	[LastUpdate] [datetime] NULL
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
    @tsbid nvarchar(5)  ,
	@userid nvarchar(10) ,
	@coupontype nvarchar(2)
)
AS
BEGIN
    SELECT [CouponPK], [CouponType], [SerialNo], [Price]
	FROM[dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = @tsbid  
	 and [couponType] = COALESCE(@coupontype, [couponType])
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
  @couponpk int
 ,@transactionid  int
, @transactiondate datetime
, @tsbid nvarchar(5)
, @coupontype varchar(2)
, @serialno nvarchar(7)
, @price decimal(6,0)
, @userid nvarchar(10)
, @userreceivedate datetime
, @Couponstatus char(1)
, @solddate datetime
, @soldby nvarchar(10)
, @finishflag char(1)
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
    WHERE [SerialNo] = @serialno
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid;
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[TA_Coupon]
           ([couponpk], [TransactionDate],[TSBId] ,[CouponType] ,[SerialNo]
           ,[Price] ,[CouponStatus] ,[FinishFlag] )
     VALUES ( @transactionid , @transactiondate , @tsbid, @coupontype, @serialno
	         ,@price , @Couponstatus , @finishflag )


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO


/*********** Script Update Date: 2020-08-06  ***********/
CREATE PROCEDURE [dbo].[TCTSoldCoupon] (
  @tsbid nvarchar(5)
, @coupontype nvarchar(2)
, @serialno nvarchar(7)
, @price decimal(6,0)
, @userid nvarchar(10)
, @solddate datetime
, @laneid nvarchar(10)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
BEGIN TRY

	UPDATE [dbo].[TA_Coupon]
	SET [CouponStatus] = 3
      ,[SoldDate] = @solddate
      ,[SoldBy] = @userid
      , [LaneId] = @laneid
	WHERE [SerialNo] = @serialno 
		and [CouponType]  = @coupontype
		and [TSBId] = @tsbid
		and [UserId] = @userid;
	
	
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

/*********** Script Update Date: 2020-08-06  ***********/
CREATE PROCEDURE [dbo].[GetUserLaneAttendance]
(
    @plazagroupid nvarchar(10),
	@userid nvarchar(10) ,
	@startdate datetime,
	@enddate datetime
)
AS
BEGIN
    SELECT [JobId], [PlazaGroupId] , [PlazaId] , [LaneId] , [BOJ] , [EOJ]
	FROM [dbo].[LaneAttendance] 
     WHERE [UserId] = @userid
	and [PlazaGroupId] = @plazagroupid  
	 and [BOJ] between @startdate and @enddate
     ORDER BY [BOJ] asc;
END

GO

/*********** Script Update Date: 2020-08-06  ***********/

Create PROCEDURE [dbo].[TCTSaveLaneAttendance] (
  @jobid nvarchar(20)
 , @tsbid nvarchar(5)
, @plazaid nvarchar(10)
, @laneid nvarchar(10)
, @userid nvarchar(10)
, @boj datetime
, @eoj datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN
DECLARE @plazagroupid nvarchar(10) = NULL;

	select @plazagroupid = [PlazaGroupId]
	FROM [dbo].[Lane]
	WHERE	[LaneId] = @laneid ;
		--and [PlazaId] = @plazaid
		
	BEGIN TRY
		IF EXISTS (
		SELECT *	 
		FROM [dbo].[LaneAttendance]
		WHERE [JobId] = @jobid
		and  [LaneId] = @laneid
		and [PlazaId] = @plazaid
		
	)
	BEGIN
	UPDATE [dbo].[LaneAttendance]
	SET [EOJ] = @eoj
    WHERE [JobId] = @jobid
		and  [LaneId] = @laneid
		and [PlazaId] = @plazaid;
	End
	ELSE
		BEGIN
	INSERT INTO [dbo].[LaneAttendance]
           ([JobId],[TSBId],[PlazaGroupId],[PlazaId],[LaneId],[UserId],[BOJ],[EOJ] )
     VALUES ( @jobid , @tsbid , @plazagroupid, @plazaid
	         ,@laneid , @userid , @boj ,@eoj )


		END
		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END

GO

/*********** Script Update Date: 2020-08-06  ***********/

GO
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'1', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002202', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'3', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'2', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002203', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'3', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002204', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'4', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002205', CAST(665 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'5', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002206', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'6', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002207', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'7', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002208', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'8', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002209', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'9', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002210', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'10', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002211', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'11', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002212', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'12', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002213', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'13', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002214', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'14', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002215', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'15', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002216', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'16', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002217', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'17', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002218', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'18', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002219', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'19', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002220', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'20', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002221', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'21', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002222', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'22', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002223', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'23', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002224', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'24', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002225', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'25', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002226', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'26', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002227', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'27', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002228', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'28', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002229', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'29', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002230', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'30', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002231', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'31', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002232', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'32', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002233', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'33', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002234', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'34', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002235', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'35', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002236', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'36', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002237', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'37', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002238', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'38', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002239', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'39', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002240', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'40', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002241', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'41', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002242', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'42', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002243', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'43', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002244', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'44', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002245', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'45', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002246', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'46', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002247', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'47', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002248', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'48', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'35', N'ข002249', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'49', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003502', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'50', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003503', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'51', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003504', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'52', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003505', CAST(1520 AS Decimal(6, 0)), N'14124', NULL, N'2', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'53', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003506', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'54', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003509', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'55', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003510', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'56', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003511', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'57', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003512', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'58', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003513', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'59', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003514', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'60', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003515', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'61', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003516', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'62', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003517', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'63', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003518', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'64', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003521', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'65', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003522', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'66', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003523', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'67', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003524', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'68', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003525', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'69', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003526', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'70', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003527', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'71', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003528', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'72', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003529', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'73', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003530', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'74', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003531', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'75', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003532', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'76', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003533', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'77', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003534', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'78', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003535', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'79', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003536', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'80', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003537', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'81', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003538', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'82', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003539', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'83', CAST(N'2020-08-06T22:00:47.287' AS DateTime), N'311', N'80', N'C003540', CAST(1520 AS Decimal(6, 0)), NULL, NULL, N'1', NULL, NULL, N'1', N'1')
INSERT [dbo].[TA_Coupon] ([CouponPK], [TransactionDate], [TSBId], [CouponType], [SerialNo], [Price], [UserId], [UserReceiveDate], [CouponStatus], [SoldDate], [SoldBy], [FinishFlag], [SapChooseFlag]) VALUES (N'1', CAST(N'2020-08-06T18:25:43.510' AS DateTime), N'311', N'35', N'ข112202', CAST(665 AS Decimal(6, 0)), NULL, NULL, N'2', NULL, NULL, N'1', N'1')


/*********** Script Update Date: 2020-08-06  ***********/
GO
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (1, N'DD01', N'MTC', N'DD01', N'311', N'DD', N'3101', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (2, N'DD02', N'MTC', N'DD02', N'311', N'DD', N'3101', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (3, N'DD03', N'A/M', N'DD03', N'311', N'DD', N'3101', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (4, N'DD04', N'ETC', N'DD04', N'311', N'DD', N'3101', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (11, N'DD11', N'?', N'DD11', N'311', N'DD', N'3102', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (12, N'DD12', N'?', N'DD12', N'311', N'DD', N'3102', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (13, N'DD13', N'?', N'DD13', N'311', N'DD', N'3102', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (14, N'DD14', N'?', N'DD14', N'311', N'DD', N'3102', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (15, N'DD15', N'?', N'DD15', N'311', N'DD', N'3102', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (16, N'DD16', N'?', N'DD16', N'311', N'DD', N'3102', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (1, N'SS01', N'?', N'SS01', N'311', N'SS', N'3103', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (2, N'SS02', N'?', N'SS02', N'311', N'SS', N'3103', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (3, N'SS03', N'?', N'SS03', N'311', N'SS', N'3103', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (1, N'LP01', N'?', N'LP01', N'311', N'LP-IN', N'3104', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (2, N'LP02', N'?', N'LP02', N'311', N'LP-IN', N'3104', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (3, N'LP03', N'?', N'LP03', N'311', N'LP-IN', N'3104', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (4, N'LP04', N'?', N'LP04', N'311', N'LP-IN', N'3104', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (21, N'LP21', N'?', N'LP21', N'311', N'LP-OUT', N'3105', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (22, N'LP22', N'?', N'LP22', N'311', N'LP-OUT', N'3105', 0)
INSERT [dbo].[Lane] ([LaneNo], [LaneId], [LaneType], [LaneAbbr], [TSBId], [PlazaGroupId], [PlazaId], [Status]) VALUES (23, N'LP23', N'?', N'LP23', N'311', N'LP-OUT', N'3105', 0)

