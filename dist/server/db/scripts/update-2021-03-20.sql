/*********** Script Update Date: 2021-03-20  ***********/
/****** Object:  Table [dbo].[TSB]    Script Date: 20/3/2564 19:09:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TSB](
	[TSBId] [nvarchar](5) NULL,
	[TSB_Th_Name] [nvarchar](20) NULL,
	[TSB_Eng_name] [nvarchar](20) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2021-03-20  ***********/
/****** Object:  Table [dbo].[TSBCreditBalance]    Script Date: 20/3/2564 19:10:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TSBCreditBalance](
	[TSBId] [nvarchar](5) NOT NULL,
	[Amnt1] [numeric](6, 0) NULL,
	[Amnt2] [numeric](6, 0) NULL,
	[Amnt5] [numeric](6, 0) NULL,
	[Amnt10] [numeric](6, 0) NULL,
	[Amnt20] [numeric](6, 0) NULL,
	[Amnt50] [numeric](6, 0) NULL,
	[Amnt100] [numeric](6, 0) NULL,
	[Amnt500] [numeric](6, 0) NULL,
	[Amnt1000] [numeric](6, 0) NULL,
	[BalanceDate] [datetime] NULL,
	[BalanceRemark] [nvarchar](200) NULL
) ON [PRIMARY]
GO



/*********** Script Update Date: 2021-03-20  ***********/
/****** Object:  Table [dbo].[UserCreditOnJob]    Script Date: 20/3/2564 19:11:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserCreditOnJob](
	[TSBId] [nvarchar](5) NOT NULL,
	[UserId] [nvarchar](10) NOT NULL,
	[UserPrefix] [nvarchar](10) NULL,
	[UserFirstName] [nvarchar](50) NULL,
	[UserLastName] [nvarchar](50) NULL,
	[BagNo] [nvarchar](20) NULL,
	[Credit] [numeric](6, 0) NULL,
	[Flag] [int] NULL,
	[CreditDate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserCreditOnJob] ADD  DEFAULT ((1)) FOR [Flag]
GO



/*********** Script Update Date: 2021-03-20  ***********/
/****** Object:  StoredProcedure [dbo].[Acc_SaveTSBCreditBalance]    Script Date: 20/3/2564 19:57:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


CREATE PROCEDURE [dbo].[Acc_SaveTSBCreditBalance] (
  @tsbid nvarchar(5)
, @amnt1 decimal(6,0)
, @amnt2 decimal(6,0)
, @amnt5 decimal(6,0)
, @amnt10 decimal(6,0)
, @amnt20 decimal(6,0)
, @amnt50 decimal(6,0)
, @amnt100 decimal(6,0)
, @amnt500 decimal(6,0)
, @amnt1000 decimal(6,0)
, @updatedate datetime
, @remark nvarchar(200)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
	IF EXISTS (
		SELECT *	 
		FROM [dbo].[TSBCreditBalance]
		WHERE [TSBId] = @tsbid
		
	)
	BEGIN

	UPDATE [dbo].[TSBCreditBalance]
	SET [Amnt1] = @amnt1
	, [Amnt2] = @amnt2
	, [Amnt5] = @amnt5
	, [Amnt10] = @amnt10
	, [Amnt20] = @amnt20
	, [Amnt50] = @amnt50
	, [Amnt100] = @amnt100
	, [Amnt500] = @amnt500
	, [Amnt1000] = @amnt1000
	, [BalanceDate] = @updatedate
	, [BalanceRemark] = @remark
    WHERE [TSBId] = @tsbid
	END
	ELSE
		
	INSERT INTO [dbo].[TSBCreditBalance]
           ([TSBId] ,[Amnt1] ,[Amnt2] ,[Amnt5] ,[Amnt10] ,[Amnt20]
           ,[Amnt50] ,[Amnt100] ,[Amnt500] ,[Amnt1000] ,[BalanceDate] ,[BalanceRemark] )
     VALUES
           (@tsbid, @amnt1 ,@amnt2 ,@amnt5, @amnt10, @amnt20, @amnt50, @amnt100, @amnt500, @amnt1000,
		   @updatedate , @remark);


		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO



/*********** Script Update Date: 2021-03-20  ***********/
/****** Object:  StoredProcedure [dbo].[Acc_SaveUserCreditOnJob]    Script Date: 20/3/2564 19:12:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/


create PROCEDURE [dbo].[Acc_SaveUserCreditOnJob] (
  @tsbid nvarchar(5)
, @userid nvarchar(10)
, @userprefix nvarchar(10)
, @userfirstname nvarchar(50)
, @userlastname nvarchar(50)
, @bagno nvarchar(20)
, @credit decimal(6,0)
, @flag int
, @creditdate datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
	IF EXISTS (
		SELECT *	 
		FROM [dbo].[UserCreditOnJob]
		WHERE [TSBId] = @tsbid
		and [UserId] = @userid
		and [BagNo] = @bagno
		and [Flag] = 0
		
	)
	BEGIN

	UPDATE [dbo].[UserCreditOnJob]
	SET [Credit] = @credit
	, [Flag] = @flag
	, [CreditDate] = @creditdate
	WHERE  [TSBId] = @tsbid
		and [UserId] = @userid
		and [BagNo] = @bagno
		and [Flag] = 0
	END
	ELSE
		
	INSERT INTO [dbo].[UserCreditOnJob]
           ([TSBId] ,[UserId] , [UserPrefix], [UserFirstName],[UserLastName] ,[BagNo]
           , [Credit], [Flag] , [CreditDate] )
     VALUES
           (@tsbid, @userid ,@userprefix ,@userfirstname, @userlastname, @bagno, @credit, 0, @creditdate );


		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO



/*********** Script Update Date: 2021-03-20  ***********/
/****** Object:  StoredProcedure [dbo].[Acc_getTSBBalance]    Script Date: 20/3/2564 20:32:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Acc_getTSBBalance]

AS
BEGIN

select T.TSBId , T.TSB_Th_Name , M.Amnt1 , M.Amnt2 , M.Amnt5, M.Amnt10, M.Amnt20
, M.Amnt50 , M.Amnt100 , M.Amnt500, M.Amnt1000, M.BalanceDate , M.BalanceRemark 
, U.ucredit,  C.C35 , C.C80 
from [dbo].[TSB] T 
FULL outer join [dbo].[TSBCreditBalance] M
on T.TSBId = M.TSBId 
FULL outer join
(select TSBId , sum(credit) ucredit
from [dbo].[UserCreditOnJob]
where flag = 0
group by TSBId) U
on  T.TSBId = U.TSBId 
FULL outer join
( select TSBId , COUNT(CASE WHEN CouponType = 35 THEN 1 ELSE NULL END) As C35
, COUNT(CASE WHEN CouponType = 80 THEN 1 ELSE NULL END) As C80
from TA_Coupon
where [CouponStatus] = 1
group by TSBId  ) C 
on  T.TSBId = C.TSBId 
order by T.TSBId


END
GO



/*********** Script Update Date: 2021-03-20  ***********/
/****** Object:  StoredProcedure [dbo].[Acc_getUserOnJobCredit]    Script Date: 20/3/2564 20:51:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[Acc_getUserOnJobCredit]
(
    @tsbid nvarchar(5)
)

AS
BEGIN
select T.TSBId , T.TSB_Th_Name , U.UserId , U.UserPrefix+' '+U.userfirstname+' '+U.userlastname as username
, U.Bagno , U.Credit , U.creditdate , C.C35 , C.C80
from [dbo].[TSB] T 
FULL outer join [dbo].[UserCreditOnJob] U
on T.TSBId = U.TSBId 
FULL outer join
( select TSBId , userId,  COUNT(CASE WHEN CouponType = 35 THEN 1 ELSE NULL END) As C35
, COUNT(CASE WHEN CouponType = 80 THEN 1 ELSE NULL END) As C80
from TA_Coupon
where [CouponStatus] in (2,3 )
and FinishFlag = 1
group by TSBId ,userId  ) C 
on  U.userId = C.userId
where  T.TSBId = @tsbid
and U.flag = 0


END
GO



/*********** Script Update Date: 2021-03-20  ***********/
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'09', N'อนุสรณ์สถาน', N'ANUSORN SATHAN')
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'01', N'ดินแดง', N'DIN DAENG')
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'02', N'สุทธิสาร', N'SUTHISARN')
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'03', N'ลาดพร้าว', N'LAD PRAO')
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'04', N'รัชดาภิเษก', N'RATCHADA PHISEK')
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'05', N'บางเขน', N'BANGKHEN')
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'06', N'แจ้งวัฒนะ', N'CHANGEWATTANA')
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'07', N'หลักสี่', N'LAKSI')
INSERT [dbo].[TSB] ([TSBId], [TSB_Th_Name], [TSB_Eng_name]) VALUES (N'08', N'ดอนเมือง', N'DON MUANG')
